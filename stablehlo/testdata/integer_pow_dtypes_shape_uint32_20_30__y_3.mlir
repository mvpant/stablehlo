// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui32>
    %1 = call @expected() : () -> tensor<20x30xui32>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xui32>
    %3 = stablehlo.multiply %0, %2 : tensor<20x30xui32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x30xui32>, tensor<20x30xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui32> {
    %0 = stablehlo.constant dense<"0x01000000030000000100000003000000000000000000000002000000040000000200000000000000030000000200000004000000010000000400000004000000000000000500000001000000000000000200000000000000020000000300000002000000030000000100000004000000010000000500000000000000030000000300000004000000040000000300000001000000000000000300000001000000010000000200000000000000030000000100000000000000010000000200000004000000010000000300000000000000010000000200000001000000000000000300000002000000000000000200000000000000040000000500000001000000000000000000000001000000000000000200000005000000000000000000000002000000000000000300000004000000000000000400000001000000000000000100000003000000010000000600000000000000060000000700000002000000040000000300000003000000000000000200000000000000010000000100000002000000000000000400000005000000000000000700000004000000060000000400000002000000010000000600000004000000020000000300000001000000040000000000000003000000020000000500000003000000000000000200000001000000040000000100000005000000030000000300000002000000020000000000000001000000000000000100000003000000030000000400000001000000030000000000000005000000000000000000000000000000010000000500000002000000030000000300000001000000000000000000000000000000060000000100000001000000000000000600000001000000010000000300000001000000010000000300000001000000020000000600000000000000010000000100000000000000050000000400000004000000000000000400000001000000030000000200000000000000010000000200000000000000030000000200000000000000010000000100000000000000020000000200000000000000010000000400000002000000020000000300000001000000020000000400000002000000000000000400000000000000020000000000000003000000030000000300000001000000010000000200000002000000010000000400000004000000000000000000000000000000000000000200000000000000000000000100000004000000010000000500000003000000010000000200000002000000000000000100000003000000000000000100000001000000060000000000000003000000000000000300000000000000050000000100000003000000050000000000000005000000000000000300000001000000000000000200000001000000020000000000000001000000030000000100000006000000040000000000000002000000020000000200000001000000030000000100000002000000020000000900000000000000050000000300000000000000020000000000000002000000000000000000000000000000000000000000000002000000010000000100000000000000000000000300000005000000000000000400000004000000040000000300000001000000000000000500000002000000020000000200000002000000020000000200000001000000000000000100000003000000000000000400000002000000000000000000000000000000040000000400000001000000020000000100000003000000000000000500000001000000010000000000000006000000030000000500000004000000040000000000000005000000050000000000000000000000010000000100000003000000040000000100000000000000020000000100000001000000030000000100000002000000010000000000000000000000050000000100000000000000000000000000000002000000030000000000000002000000020000000000000002000000010000000200000001000000020000000500000002000000040000000000000000000000040000000000000000000000010000000600000000000000030000000400000000000000020000000400000006000000020000000500000001000000020000000000000002000000030000000100000002000000010000000000000004000000030000000100000002000000010000000400000002000000030000000300000001000000030000000200000002000000020000000300000001000000000000000100000000000000010000000200000005000000030000000000000000000000010000000500000002000000000000000100000000000000040000000000000000000000000000000000000002000000040000000100000005000000000000000000000002000000030000000300000000000000040000000100000004000000000000000200000001000000000000000000000001000000010000000200000004000000010000000400000000000000040000000100000005000000020000000200000000000000060000000100000000000000050000000200000001000000000000000100000002000000010000000200000004000000040000000500000001000000020000000100000002000000020000000200000002000000030000000100000000000000000000000100000003000000040000000100000002000000030000000200000003000000000000000400000006000000030000000000000001000000000000000000000002000000030000000000000003000000020000000000000003000000000000000200000000000000010000000300000001000000010000000000000001000000000000000000000000000000010000000000000004000000000000000100000002000000030000000100000003000000040000000200000000000000020000000A000000020000000100000003000000050000000100000007000000000000000200000002000000010000000100000000000000070000000300000004000000060000000000000001000000000000000100000004000000000000000000000000000000050000000400000003000000000000000000000000000000060000000300000003000000000000000000000007000000060000000000000001000000000000000300000001000000020000000700000002000000000000000100000002000000030000000200000001000000010000000300000000000000030000000200000005000000010000000400000000000000000000000500000002000000000000000100000000000000"> : tensor<20x30xui32>
    return %0 : tensor<20x30xui32>
  }
  func.func private @expected() -> tensor<20x30xui32> {
    %0 = stablehlo.constant dense<"0x010000001B000000010000001B0000000000000000000000080000004000000008000000000000001B0000000800000040000000010000004000000040000000000000007D00000001000000000000000800000000000000080000001B000000080000001B0000000100000040000000010000007D000000000000001B0000001B00000040000000400000001B00000001000000000000001B000000010000000100000008000000000000001B0000000100000000000000010000000800000040000000010000001B00000000000000010000000800000001000000000000001B00000008000000000000000800000000000000400000007D0000000100000000000000000000000100000000000000080000007D000000000000000000000008000000000000001B0000004000000000000000400000000100000000000000010000001B00000001000000D800000000000000D80000005701000008000000400000001B0000001B00000000000000080000000000000001000000010000000800000000000000400000007D000000000000005701000040000000D8000000400000000800000001000000D800000040000000080000001B0000000100000040000000000000001B000000080000007D0000001B00000000000000080000000100000040000000010000007D0000001B0000001B0000000800000008000000000000000100000000000000010000001B0000001B00000040000000010000001B000000000000007D000000000000000000000000000000010000007D000000080000001B0000001B00000001000000000000000000000000000000D8000000010000000100000000000000D800000001000000010000001B00000001000000010000001B0000000100000008000000D8000000000000000100000001000000000000007D00000040000000400000000000000040000000010000001B00000008000000000000000100000008000000000000001B0000000800000000000000010000000100000000000000080000000800000000000000010000004000000008000000080000001B0000000100000008000000400000000800000000000000400000000000000008000000000000001B0000001B0000001B00000001000000010000000800000008000000010000004000000040000000000000000000000000000000000000000800000000000000000000000100000040000000010000007D0000001B00000001000000080000000800000000000000010000001B000000000000000100000001000000D8000000000000001B000000000000001B000000000000007D000000010000001B0000007D000000000000007D000000000000001B000000010000000000000008000000010000000800000000000000010000001B00000001000000D80000004000000000000000080000000800000008000000010000001B000000010000000800000008000000D9020000000000007D0000001B00000000000000080000000000000008000000000000000000000000000000000000000000000008000000010000000100000000000000000000001B0000007D000000000000004000000040000000400000001B00000001000000000000007D0000000800000008000000080000000800000008000000080000000100000000000000010000001B00000000000000400000000800000000000000000000000000000040000000400000000100000008000000010000001B000000000000007D000000010000000100000000000000D80000001B0000007D0000004000000040000000000000007D0000007D000000000000000000000001000000010000001B0000004000000001000000000000000800000001000000010000001B00000001000000080000000100000000000000000000007D00000001000000000000000000000000000000080000001B0000000000000008000000080000000000000008000000010000000800000001000000080000007D0000000800000040000000000000000000000040000000000000000000000001000000D8000000000000001B00000040000000000000000800000040000000D8000000080000007D000000010000000800000000000000080000001B00000001000000080000000100000000000000400000001B00000001000000080000000100000040000000080000001B0000001B000000010000001B0000000800000008000000080000001B0000000100000000000000010000000000000001000000080000007D0000001B0000000000000000000000010000007D0000000800000000000000010000000000000040000000000000000000000000000000000000000800000040000000010000007D0000000000000000000000080000001B0000001B0000000000000040000000010000004000000000000000080000000100000000000000000000000100000001000000080000004000000001000000400000000000000040000000010000007D000000080000000800000000000000D800000001000000000000007D0000000800000001000000000000000100000008000000010000000800000040000000400000007D000000010000000800000001000000080000000800000008000000080000001B000000010000000000000000000000010000001B0000004000000001000000080000001B000000080000001B0000000000000040000000D80000001B00000000000000010000000000000000000000080000001B000000000000001B00000008000000000000001B000000000000000800000000000000010000001B000000010000000100000000000000010000000000000000000000000000000100000000000000400000000000000001000000080000001B000000010000001B00000040000000080000000000000008000000E803000008000000010000001B0000007D0000000100000057010000000000000800000008000000010000000100000000000000570100001B00000040000000D800000000000000010000000000000001000000400000000000000000000000000000007D000000400000001B000000000000000000000000000000D80000001B0000001B000000000000000000000057010000D80000000000000001000000000000001B000000010000000800000057010000080000000000000001000000080000001B0000000800000001000000010000001B000000000000001B000000080000007D000000010000004000000000000000000000007D00000008000000000000000100000000000000"> : tensor<20x30xui32>
    return %0 : tensor<20x30xui32>
  }
}
