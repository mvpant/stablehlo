// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xui32>
    %1 = call @expected() : () -> tensor<20x20xui32>
    %2 = stablehlo.negate %0 : tensor<20x20xui32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui32>, tensor<20x20xui32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xui32> {
    %0 = stablehlo.constant dense<"0x000000000200000005000000050000000200000001000000020000000100000001000000030000000200000001000000020000000200000003000000020000000400000001000000000000000300000003000000030000000200000001000000000000000300000000000000000000000000000003000000000000000100000002000000030000000100000005000000000000000300000000000000060000000500000002000000010000000300000002000000020000000000000000000000000000000200000002000000000000000200000002000000040000000300000007000000040000000200000003000000000000000100000005000000000000000200000000000000000000000400000001000000030000000000000001000000010000000000000002000000010000000100000003000000010000000200000001000000030000000000000002000000020000000100000001000000040000000000000003000000010000000100000006000000050000000000000000000000030000000000000003000000040000000A00000003000000010000000200000003000000000000000000000002000000010000000000000000000000040000000100000001000000080000000100000001000000020000000100000001000000010000000000000000000000040000000000000004000000070000000000000005000000000000000300000009000000000000000400000001000000030000000200000004000000000000000000000000000000020000000100000001000000000000000300000003000000060000000000000001000000020000000300000004000000040000000200000000000000020000000000000002000000000000000000000000000000010000000000000000000000000000000400000008000000040000000400000002000000010000000A0000000100000000000000050000000600000002000000000000000000000001000000010000000200000001000000000000000000000007000000050000000100000001000000050000000000000003000000050000000500000005000000020000000400000001000000030000000200000000000000060000000100000000000000010000000300000003000000000000000100000002000000000000000200000001000000000000000000000001000000000000000500000000000000010000000200000001000000010000000200000000000000000000000000000003000000010000000600000002000000040000000500000000000000040000000100000003000000020000000000000004000000030000000100000000000000050000000000000001000000040000000000000000000000030000000100000006000000060000000300000003000000040000000000000001000000030000000300000002000000040000000600000001000000010000000300000003000000000000000100000002000000010000000000000000000000040000000100000000000000000000000000000000000000000000000400000000000000030000000200000000000000000000000100000004000000040000000100000000000000030000000100000007000000030000000300000001000000000000000200000000000000030000000000000004000000020000000500000001000000000000000000000002000000030000000200000002000000000000000000000002000000010000000100000001000000050000000000000002000000000000000200000000000000000000000400000000000000010000000200000001000000030000000200000000000000010000000100000003000000000000000200000000000000020000000200000004000000040000000100000006000000040000000400000003000000000000000000000000000000040000000400000000000000050000000000000002000000040000000000000005000000010000000000000001000000000000000000000000000000040000000400000003000000010000000900000005000000000000000500000005000000020000000100000004000000010000000100000005000000000000000000000002000000010000000500000001000000060000000300000001000000000000000300000002000000010000000100000000000000010000000200000000000000"> : tensor<20x20xui32>
    return %0 : tensor<20x20xui32>
  }
  func.func private @expected() -> tensor<20x20xui32> {
    %0 = stablehlo.constant dense<"0x00000000FEFFFFFFFBFFFFFFFBFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFEFFFFFFFDFFFFFFFEFFFFFFFCFFFFFFFFFFFFFF00000000FDFFFFFFFDFFFFFFFDFFFFFFFEFFFFFFFFFFFFFF00000000FDFFFFFF000000000000000000000000FDFFFFFF00000000FFFFFFFFFEFFFFFFFDFFFFFFFFFFFFFFFBFFFFFF00000000FDFFFFFF00000000FAFFFFFFFBFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFEFFFFFFFEFFFFFF000000000000000000000000FEFFFFFFFEFFFFFF00000000FEFFFFFFFEFFFFFFFCFFFFFFFDFFFFFFF9FFFFFFFCFFFFFFFEFFFFFFFDFFFFFF00000000FFFFFFFFFBFFFFFF00000000FEFFFFFF0000000000000000FCFFFFFFFFFFFFFFFDFFFFFF00000000FFFFFFFFFFFFFFFF00000000FEFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF00000000FEFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFCFFFFFF00000000FDFFFFFFFFFFFFFFFFFFFFFFFAFFFFFFFBFFFFFF0000000000000000FDFFFFFF00000000FDFFFFFFFCFFFFFFF6FFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFDFFFFFF0000000000000000FEFFFFFFFFFFFFFF0000000000000000FCFFFFFFFFFFFFFFFFFFFFFFF8FFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FCFFFFFF00000000FCFFFFFFF9FFFFFF00000000FBFFFFFF00000000FDFFFFFFF7FFFFFF00000000FCFFFFFFFFFFFFFFFDFFFFFFFEFFFFFFFCFFFFFF000000000000000000000000FEFFFFFFFFFFFFFFFFFFFFFF00000000FDFFFFFFFDFFFFFFFAFFFFFF00000000FFFFFFFFFEFFFFFFFDFFFFFFFCFFFFFFFCFFFFFFFEFFFFFF00000000FEFFFFFF00000000FEFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000FCFFFFFFF8FFFFFFFCFFFFFFFCFFFFFFFEFFFFFFFFFFFFFFF6FFFFFFFFFFFFFF00000000FBFFFFFFFAFFFFFFFEFFFFFF0000000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000F9FFFFFFFBFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF00000000FDFFFFFFFBFFFFFFFBFFFFFFFBFFFFFFFEFFFFFFFCFFFFFFFFFFFFFFFDFFFFFFFEFFFFFF00000000FAFFFFFFFFFFFFFF00000000FFFFFFFFFDFFFFFFFDFFFFFF00000000FFFFFFFFFEFFFFFF00000000FEFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FBFFFFFF00000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFEFFFFFF000000000000000000000000FDFFFFFFFFFFFFFFFAFFFFFFFEFFFFFFFCFFFFFFFBFFFFFF00000000FCFFFFFFFFFFFFFFFDFFFFFFFEFFFFFF00000000FCFFFFFFFDFFFFFFFFFFFFFF00000000FBFFFFFF00000000FFFFFFFFFCFFFFFF0000000000000000FDFFFFFFFFFFFFFFFAFFFFFFFAFFFFFFFDFFFFFFFDFFFFFFFCFFFFFF00000000FFFFFFFFFDFFFFFFFDFFFFFFFEFFFFFFFCFFFFFFFAFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFDFFFFFF00000000FFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FCFFFFFFFFFFFFFF0000000000000000000000000000000000000000FCFFFFFF00000000FDFFFFFFFEFFFFFF0000000000000000FFFFFFFFFCFFFFFFFCFFFFFFFFFFFFFF00000000FDFFFFFFFFFFFFFFF9FFFFFFFDFFFFFFFDFFFFFFFFFFFFFF00000000FEFFFFFF00000000FDFFFFFF00000000FCFFFFFFFEFFFFFFFBFFFFFFFFFFFFFF0000000000000000FEFFFFFFFDFFFFFFFEFFFFFFFEFFFFFF0000000000000000FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF00000000FEFFFFFF00000000FEFFFFFF0000000000000000FCFFFFFF00000000FFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFEFFFFFF00000000FFFFFFFFFFFFFFFFFDFFFFFF00000000FEFFFFFF00000000FEFFFFFFFEFFFFFFFCFFFFFFFCFFFFFFFFFFFFFFFAFFFFFFFCFFFFFFFCFFFFFFFDFFFFFF000000000000000000000000FCFFFFFFFCFFFFFF00000000FBFFFFFF00000000FEFFFFFFFCFFFFFF00000000FBFFFFFFFFFFFFFF00000000FFFFFFFF000000000000000000000000FCFFFFFFFCFFFFFFFDFFFFFFFFFFFFFFF7FFFFFFFBFFFFFF00000000FBFFFFFFFBFFFFFFFEFFFFFFFFFFFFFFFCFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF0000000000000000FEFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFFAFFFFFFFDFFFFFFFFFFFFFF00000000FDFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFEFFFFFF00000000"> : tensor<20x20xui32>
    return %0 : tensor<20x20xui32>
  }
}
