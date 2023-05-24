// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xi32>
    %1 = call @expected() : () -> tensor<20x30xi32>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x30xi32>, tensor<20x30xi32>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xi32> {
    %0 = stablehlo.constant dense<"0x020000000300000000000000FDFFFFFF0000000000000000030000000000000007000000FCFFFFFF020000000800000004000000000000000200000000000000010000000200000000000000FEFFFFFF00000000000000000000000002000000FFFFFFFF030000000000000000000000FEFFFFFFFCFFFFFF0000000000000000FFFFFFFF03000000FFFFFFFF0000000001000000FCFFFFFF000000000700000000000000FBFFFFFF02000000030000000100000003000000FDFFFFFF00000000FFFFFFFF0000000002000000FFFFFFFF0400000000000000FFFFFFFF02000000030000000400000005000000FAFFFFFF010000000400000006000000FFFFFFFF00000000FDFFFFFF00000000000000000100000004000000040000000100000002000000FDFFFFFFFEFFFFFF0400000000000000FEFFFFFFFDFFFFFF0600000000000000030000000600000003000000FBFFFFFF040000000100000000000000FDFFFFFF03000000FEFFFFFFFDFFFFFF01000000FFFFFFFF0A000000FBFFFFFF00000000FCFFFFFF0000000006000000FBFFFFFF020000000000000004000000FCFFFFFF02000000FFFFFFFF050000000000000000000000FDFFFFFFFBFFFFFF03000000FEFFFFFFFEFFFFFFFFFFFFFFFAFFFFFFFFFFFFFF06000000FBFFFFFF0000000000000000FFFFFFFFFEFFFFFF00000000FAFFFFFF0200000002000000FDFFFFFF0200000002000000FDFFFFFF02000000FDFFFFFFFFFFFFFF0000000003000000FCFFFFFF04000000010000000000000003000000F7FFFFFFFBFFFFFF0000000000000000FCFFFFFF00000000010000000000000000000000FEFFFFFF0300000004000000FBFFFFFFFFFFFFFFFEFFFFFF02000000FEFFFFFFFFFFFFFF00000000FDFFFFFF04000000000000000000000000000000000000000100000001000000FEFFFFFF0600000000000000FFFFFFFF040000000200000002000000FFFFFFFF010000000500000000000000FDFFFFFFFEFFFFFF03000000020000000200000000000000FCFFFFFFFDFFFFFFF9FFFFFFFCFFFFFFFFFFFFFF0100000000000000FDFFFFFF0200000003000000FFFFFFFF04000000FBFFFFFFFFFFFFFF01000000FDFFFFFF00000000000000000000000004000000FCFFFFFF00000000FBFFFFFF01000000FEFFFFFFFDFFFFFF0000000000000000FEFFFFFFFFFFFFFF0100000002000000FFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFEFFFFFF02000000FAFFFFFF03000000FEFFFFFF0000000002000000FEFFFFFFFFFFFFFF0000000000000000FDFFFFFF010000000200000000000000020000000000000003000000010000000400000002000000FDFFFFFF00000000000000000200000000000000FFFFFFFF00000000030000000300000004000000FCFFFFFF0100000002000000000000000300000001000000FFFFFFFF0000000000000000FFFFFFFF02000000010000000200000000000000FCFFFFFFFEFFFFFFFFFFFFFF00000000000000000100000001000000FFFFFFFF05000000020000000000000002000000FEFFFFFFFCFFFFFFFCFFFFFF000000000500000003000000FDFFFFFF03000000FFFFFFFF0000000000000000010000000100000000000000FEFFFFFFFBFFFFFFFFFFFFFF0000000004000000000000000200000003000000FCFFFFFFFFFFFFFFFCFFFFFFFEFFFFFF0000000003000000FFFFFFFF01000000010000000100000002000000FAFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFF0000000000000000FDFFFFFF000000000200000003000000FBFFFFFF04000000F7FFFFFFFCFFFFFF000000000000000000000000FEFFFFFFFFFFFFFF01000000000000000000000003000000040000000300000002000000FCFFFFFFFEFFFFFF01000000FBFFFFFF05000000FCFFFFFF00000000000000000000000000000000FFFFFFFF02000000020000000200000000000000010000000000000000000000F9FFFFFF0500000000000000FFFFFFFF0100000002000000FFFFFFFFFEFFFFFFFFFFFFFF01000000F9FFFFFF000000000200000002000000FFFFFFFF0100000002000000FDFFFFFF020000000100000001000000FBFFFFFF0000000001000000030000000300000000000000FDFFFFFF00000000FCFFFFFF00000000000000000000000003000000FFFFFFFF02000000FFFFFFFF0100000001000000000000000500000001000000040000000200000001000000FAFFFFFFFFFFFFFF020000000300000003000000020000000000000005000000000000000200000000000000FFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFF05000000FEFFFFFF0000000000000000FFFFFFFF01000000040000000100000000000000FEFFFFFF0000000000000000FEFFFFFF0000000006000000020000000200000000000000FFFFFFFF0000000004000000FCFFFFFF0000000002000000FFFFFFFF03000000FFFFFFFF0000000007000000FDFFFFFF02000000FFFFFFFFFFFFFFFF0300000004000000FFFFFFFFFFFFFFFF0100000002000000FFFFFFFFFDFFFFFF01000000FFFFFFFFFEFFFFFF0100000000000000FAFFFFFF0000000004000000FBFFFFFFFEFFFFFF0100000006000000FCFFFFFFFDFFFFFF00000000FEFFFFFF03000000FCFFFFFFFEFFFFFFFCFFFFFF0000000000000000FEFFFFFF02000000FBFFFFFF00000000FFFFFFFF00000000000000000000000000000000FDFFFFFF06000000FFFFFFFFFAFFFFFF000000000000000004000000FFFFFFFF000000000300000001000000000000000000000004000000FCFFFFFF0200000002000000FFFFFFFFFFFFFFFF04000000FFFFFFFFFFFFFFFFFFFFFFFF010000000100000001000000FEFFFFFFF9FFFFFF0600000004000000FFFFFFFF00000000000000000000000005000000FCFFFFFF000000000100000001000000FEFFFFFFFCFFFFFFFEFFFFFFFDFFFFFFFFFFFFFFFFFFFFFF0200000000000000FFFFFFFF02000000020000000000000000000000FEFFFFFF02000000000000000000000000000000000000000000000002000000FCFFFFFFFCFFFFFFFEFFFFFF000000000300000000000000FEFFFFFF00000000FFFFFFFF00000000030000000100000003000000010000000000000000000000FEFFFFFFFCFFFFFFFFFFFFFF0300000004000000000000000200000003000000000000000000000004000000FAFFFFFF03000000000000000100000000000000FCFFFFFF0000000000000000FFFFFFFF0200000001000000040000000600000000000000040000000000000000000000FAFFFFFF000000000000000002000000"> : tensor<20x30xi32>
    return %0 : tensor<20x30xi32>
  }
  func.func private @expected() -> tensor<20x30xi32> {
    %0 = stablehlo.constant dense<"0x020000000300000000000000FDFFFFFF0000000000000000030000000000000007000000FCFFFFFF020000000800000004000000000000000200000000000000010000000200000000000000FEFFFFFF00000000000000000000000002000000FFFFFFFF030000000000000000000000FEFFFFFFFCFFFFFF0000000000000000FFFFFFFF03000000FFFFFFFF0000000001000000FCFFFFFF000000000700000000000000FBFFFFFF02000000030000000100000003000000FDFFFFFF00000000FFFFFFFF0000000002000000FFFFFFFF0400000000000000FFFFFFFF02000000030000000400000005000000FAFFFFFF010000000400000006000000FFFFFFFF00000000FDFFFFFF00000000000000000100000004000000040000000100000002000000FDFFFFFFFEFFFFFF0400000000000000FEFFFFFFFDFFFFFF0600000000000000030000000600000003000000FBFFFFFF040000000100000000000000FDFFFFFF03000000FEFFFFFFFDFFFFFF01000000FFFFFFFF0A000000FBFFFFFF00000000FCFFFFFF0000000006000000FBFFFFFF020000000000000004000000FCFFFFFF02000000FFFFFFFF050000000000000000000000FDFFFFFFFBFFFFFF03000000FEFFFFFFFEFFFFFFFFFFFFFFFAFFFFFFFFFFFFFF06000000FBFFFFFF0000000000000000FFFFFFFFFEFFFFFF00000000FAFFFFFF0200000002000000FDFFFFFF0200000002000000FDFFFFFF02000000FDFFFFFFFFFFFFFF0000000003000000FCFFFFFF04000000010000000000000003000000F7FFFFFFFBFFFFFF0000000000000000FCFFFFFF00000000010000000000000000000000FEFFFFFF0300000004000000FBFFFFFFFFFFFFFFFEFFFFFF02000000FEFFFFFFFFFFFFFF00000000FDFFFFFF04000000000000000000000000000000000000000100000001000000FEFFFFFF0600000000000000FFFFFFFF040000000200000002000000FFFFFFFF010000000500000000000000FDFFFFFFFEFFFFFF03000000020000000200000000000000FCFFFFFFFDFFFFFFF9FFFFFFFCFFFFFFFFFFFFFF0100000000000000FDFFFFFF0200000003000000FFFFFFFF04000000FBFFFFFFFFFFFFFF01000000FDFFFFFF00000000000000000000000004000000FCFFFFFF00000000FBFFFFFF01000000FEFFFFFFFDFFFFFF0000000000000000FEFFFFFFFFFFFFFF0100000002000000FFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFEFFFFFF02000000FAFFFFFF03000000FEFFFFFF0000000002000000FEFFFFFFFFFFFFFF0000000000000000FDFFFFFF010000000200000000000000020000000000000003000000010000000400000002000000FDFFFFFF00000000000000000200000000000000FFFFFFFF00000000030000000300000004000000FCFFFFFF0100000002000000000000000300000001000000FFFFFFFF0000000000000000FFFFFFFF02000000010000000200000000000000FCFFFFFFFEFFFFFFFFFFFFFF00000000000000000100000001000000FFFFFFFF05000000020000000000000002000000FEFFFFFFFCFFFFFFFCFFFFFF000000000500000003000000FDFFFFFF03000000FFFFFFFF0000000000000000010000000100000000000000FEFFFFFFFBFFFFFFFFFFFFFF0000000004000000000000000200000003000000FCFFFFFFFFFFFFFFFCFFFFFFFEFFFFFF0000000003000000FFFFFFFF01000000010000000100000002000000FAFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFF0000000000000000FDFFFFFF000000000200000003000000FBFFFFFF04000000F7FFFFFFFCFFFFFF000000000000000000000000FEFFFFFFFFFFFFFF01000000000000000000000003000000040000000300000002000000FCFFFFFFFEFFFFFF01000000FBFFFFFF05000000FCFFFFFF00000000000000000000000000000000FFFFFFFF02000000020000000200000000000000010000000000000000000000F9FFFFFF0500000000000000FFFFFFFF0100000002000000FFFFFFFFFEFFFFFFFFFFFFFF01000000F9FFFFFF000000000200000002000000FFFFFFFF0100000002000000FDFFFFFF020000000100000001000000FBFFFFFF0000000001000000030000000300000000000000FDFFFFFF00000000FCFFFFFF00000000000000000000000003000000FFFFFFFF02000000FFFFFFFF0100000001000000000000000500000001000000040000000200000001000000FAFFFFFFFFFFFFFF020000000300000003000000020000000000000005000000000000000200000000000000FFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFF05000000FEFFFFFF0000000000000000FFFFFFFF01000000040000000100000000000000FEFFFFFF0000000000000000FEFFFFFF0000000006000000020000000200000000000000FFFFFFFF0000000004000000FCFFFFFF0000000002000000FFFFFFFF03000000FFFFFFFF0000000007000000FDFFFFFF02000000FFFFFFFFFFFFFFFF0300000004000000FFFFFFFFFFFFFFFF0100000002000000FFFFFFFFFDFFFFFF01000000FFFFFFFFFEFFFFFF0100000000000000FAFFFFFF0000000004000000FBFFFFFFFEFFFFFF0100000006000000FCFFFFFFFDFFFFFF00000000FEFFFFFF03000000FCFFFFFFFEFFFFFFFCFFFFFF0000000000000000FEFFFFFF02000000FBFFFFFF00000000FFFFFFFF00000000000000000000000000000000FDFFFFFF06000000FFFFFFFFFAFFFFFF000000000000000004000000FFFFFFFF000000000300000001000000000000000000000004000000FCFFFFFF0200000002000000FFFFFFFFFFFFFFFF04000000FFFFFFFFFFFFFFFFFFFFFFFF010000000100000001000000FEFFFFFFF9FFFFFF0600000004000000FFFFFFFF00000000000000000000000005000000FCFFFFFF000000000100000001000000FEFFFFFFFCFFFFFFFEFFFFFFFDFFFFFFFFFFFFFFFFFFFFFF0200000000000000FFFFFFFF02000000020000000000000000000000FEFFFFFF02000000000000000000000000000000000000000000000002000000FCFFFFFFFCFFFFFFFEFFFFFF000000000300000000000000FEFFFFFF00000000FFFFFFFF00000000030000000100000003000000010000000000000000000000FEFFFFFFFCFFFFFFFFFFFFFF0300000004000000000000000200000003000000000000000000000004000000FAFFFFFF03000000000000000100000000000000FCFFFFFF0000000000000000FFFFFFFF0200000001000000040000000600000000000000040000000000000000000000FAFFFFFF000000000000000002000000"> : tensor<20x30xi32>
    return %0 : tensor<20x30xi32>
  }
}
