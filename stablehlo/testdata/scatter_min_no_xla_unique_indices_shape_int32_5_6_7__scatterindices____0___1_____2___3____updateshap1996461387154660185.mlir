// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x1xi32>, tensor<5x2x2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>) {
    %0 = stablehlo.constant dense<"0x02000000FFFFFFFF04000000040000000100000001000000FEFFFFFF00000000FEFFFFFF0600000001000000FEFFFFFF0000000001000000FCFFFFFF00000000FEFFFFFFFAFFFFFFFEFFFFFF00000000FFFFFFFFFDFFFFFF00000000FEFFFFFF0100000000000000FEFFFFFF01000000FEFFFFFF00000000000000000000000000000000030000000200000000000000000000000000000002000000FDFFFFFFFFFFFFFF00000000FFFFFFFF01000000000000000200000002000000FEFFFFFF0500000002000000FEFFFFFFFDFFFFFF000000000400000003000000FFFFFFFF00000000FFFFFFFFFDFFFFFF02000000FFFFFFFFFCFFFFFFFEFFFFFF08000000FBFFFFFFFCFFFFFF0400000001000000000000000300000003000000FEFFFFFF01000000FDFFFFFF000000000700000001000000FFFFFFFF03000000FEFFFFFF0100000000000000FFFFFFFFFEFFFFFF01000000FBFFFFFF0000000002000000FFFFFFFFFDFFFFFF0200000001000000FFFFFFFF07000000FFFFFFFFFDFFFFFF00000000FFFFFFFFFEFFFFFFFDFFFFFF00000000020000000000000001000000FEFFFFFFFEFFFFFF000000000200000000000000F6FFFFFF050000000300000002000000FEFFFFFF000000000000000001000000FAFFFFFF0100000001000000FEFFFFFF00000000FBFFFFFF0200000002000000FEFFFFFF00000000FBFFFFFF03000000FDFFFFFFFBFFFFFF03000000FFFFFFFFFAFFFFFF0000000000000000FCFFFFFF01000000FCFFFFFF01000000000000000000000002000000010000000200000000000000F6FFFFFF00000000050000000100000006000000FFFFFFFF0400000000000000FFFFFFFFFFFFFFFFFFFFFFFF0500000004000000FFFFFFFF04000000FFFFFFFFFCFFFFFF00000000FDFFFFFFFFFFFFFFFDFFFFFF0100000000000000FEFFFFFFFFFFFFFF01000000FDFFFFFF01000000FBFFFFFFFFFFFFFFFFFFFFFF0000000000000000FDFFFFFFFEFFFFFFFEFFFFFF00000000FFFFFFFF00000000FFFFFFFFFEFFFFFF02000000FEFFFFFFFBFFFFFFFEFFFFFF0500000003000000FBFFFFFF01000000FFFFFFFFFDFFFFFF0000000000000000030000000200000000000000030000000000000001000000040000000300000001000000FDFFFFFF01000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<"0x0200000000000000FCFFFFFF0100000001000000FFFFFFFF02000000FEFFFFFFFCFFFFFF00000000FEFFFFFFFEFFFFFFFEFFFFFF0000000000000000FFFFFFFFFCFFFFFF00000000FFFFFFFFFFFFFFFF0000000003000000FFFFFFFF00000000000000000600000000000000FDFFFFFFFEFFFFFFFEFFFFFF00000000F6FFFFFF010000000000000000000000FEFFFFFF00000000FDFFFFFF0000000000000000000000000300000008000000FDFFFFFFFDFFFFFFFCFFFFFF00000000030000000000000000000000FFFFFFFFFAFFFFFF0000000001000000FFFFFFFF0000000002000000030000000100000004000000FFFFFFFF020000000100000001000000000000000000000000000000FEFFFFFF020000000300000000000000FBFFFFFF010000000200000000000000FEFFFFFFFEFFFFFFF9FFFFFF03000000FCFFFFFF020000000000000002000000FEFFFFFFFFFFFFFF03000000FFFFFFFF000000000500000000000000FEFFFFFF05000000000000000100000000000000FFFFFFFF03000000FFFFFFFF01000000FFFFFFFF0200000003000000FBFFFFFF0100000000000000FFFFFFFF000000000300000000000000FEFFFFFF010000000200000001000000F9FFFFFF0200000000000000FFFFFFFF0000000000000000FEFFFFFF02000000FDFFFFFF010000000100000000000000010000000200000001000000FEFFFFFF0000000000000000FDFFFFFF00000000FFFFFFFFFFFFFFFF0000000000000000FEFFFFFFFEFFFFFFFDFFFFFF"> : tensor<5x2x2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x02000000FFFFFFFFFCFFFFFF0100000001000000FFFFFFFFFEFFFFFFFEFFFFFFFCFFFFFF00000000FEFFFFFFFEFFFFFFFEFFFFFF00000000FCFFFFFFFFFFFFFFFCFFFFFFFAFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFF0000000000000000FEFFFFFFFDFFFFFFFEFFFFFF00000000000000000000000000000000030000000200000000000000000000000000000002000000FDFFFFFFFFFFFFFF00000000FEFFFFFFFEFFFFFF00000000F6FFFFFF01000000FEFFFFFF00000000FEFFFFFFFEFFFFFFFDFFFFFF000000000000000000000000FFFFFFFF00000000FDFFFFFFFDFFFFFFFCFFFFFFFFFFFFFFFCFFFFFFFEFFFFFF00000000FBFFFFFFFAFFFFFF0000000001000000FFFFFFFF0000000003000000FEFFFFFF01000000FDFFFFFF000000000700000001000000FFFFFFFF03000000FEFFFFFF0100000000000000FFFFFFFFFEFFFFFF01000000FBFFFFFF0000000002000000FFFFFFFFFDFFFFFF0100000001000000FFFFFFFF00000000FFFFFFFFFDFFFFFF00000000FFFFFFFFFEFFFFFFFBFFFFFF000000000200000000000000FEFFFFFFFEFFFFFFF9FFFFFF00000000FCFFFFFF00000000F6FFFFFF02000000FEFFFFFF02000000FEFFFFFF000000000000000001000000FAFFFFFF0100000001000000FEFFFFFF00000000FBFFFFFF0200000002000000FEFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFFDFFFFFFFBFFFFFF00000000FEFFFFFFFAFFFFFF0000000000000000FCFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF00000000FFFFFFFF0200000001000000FBFFFFFF00000000F6FFFFFFFFFFFFFF000000000100000000000000FEFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFF0500000004000000FFFFFFFF04000000FFFFFFFFFCFFFFFF00000000FDFFFFFFFFFFFFFFFDFFFFFF0100000000000000F9FFFFFFFFFFFFFF00000000FDFFFFFF00000000FBFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF00000000FDFFFFFFFEFFFFFFFEFFFFFF00000000FFFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFDFFFFFFFEFFFFFFFBFFFFFFFEFFFFFF0000000000000000FBFFFFFFFEFFFFFFFDFFFFFFFDFFFFFF0000000000000000030000000200000000000000030000000000000001000000040000000300000001000000FDFFFFFF01000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

