// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x2xi32>, tensor<5x2x2xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>) {
    %0 = stablehlo.constant dense<"0x03000000FEFFFFFF030000000000000000000000000000000000000000000000FDFFFFFFFFFFFFFF01000000FCFFFFFFFFFFFFFFF8FFFFFFFEFFFFFFFFFFFFFF0200000002000000FDFFFFFF01000000FCFFFFFF00000000FFFFFFFF01000000FDFFFFFF0000000000000000FEFFFFFF00000000FFFFFFFF01000000FFFFFFFF040000000000000001000000FDFFFFFFFDFFFFFF00000000030000000300000001000000FDFFFFFF0100000001000000FEFFFFFF0200000001000000FEFFFFFFFFFFFFFFFDFFFFFF050000000100000000000000FEFFFFFF04000000FCFFFFFF00000000FDFFFFFF06000000FBFFFFFF050000000300000000000000040000000200000000000000FEFFFFFFFBFFFFFF0000000004000000FBFFFFFFFEFFFFFFFDFFFFFF00000000FBFFFFFFFEFFFFFF03000000FDFFFFFFFEFFFFFFFDFFFFFF010000000000000000000000FFFFFFFFFCFFFFFFFFFFFFFF0000000003000000050000000100000000000000FAFFFFFF03000000FBFFFFFFFFFFFFFFFDFFFFFFFEFFFFFFFBFFFFFF03000000FCFFFFFF0100000000000000000000000300000001000000FFFFFFFF01000000000000000000000004000000010000000300000000000000FFFFFFFFFFFFFFFFFEFFFFFFFDFFFFFFFBFFFFFFFFFFFFFF04000000FEFFFFFF010000000100000004000000FFFFFFFFFFFFFFFFFFFFFFFF02000000040000000400000000000000FBFFFFFF000000000200000003000000FFFFFFFF00000000FFFFFFFF0300000000000000FDFFFFFF010000000000000003000000FAFFFFFF0000000000000000FFFFFFFFFEFFFFFF0000000002000000FDFFFFFFFBFFFFFF020000000000000000000000FEFFFFFF01000000000000000000000000000000FDFFFFFFFAFFFFFF000000000200000000000000FEFFFFFFFEFFFFFF020000000000000002000000FFFFFFFF0300000002000000FBFFFFFFFFFFFFFFFCFFFFFF080000000300000005000000FEFFFFFF000000000000000000000000FBFFFFFFFBFFFFFF00000000FFFFFFFF00000000FFFFFFFFFEFFFFFF0300000001000000FFFFFFFF000000000000000002000000FDFFFFFF010000000000000000000000FEFFFFFF00000000FFFFFFFF06000000FAFFFFFF02000000FEFFFFFF01000000FAFFFFFF"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[[-3, 0], [2, -6]], [[0, -1], [0, 0]], [[-2, -3], [0, -3]], [[3, -2], [-2, -3]], [[5, 0], [-1, 4]]]> : tensor<5x2x2xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x0300000006000000030000000000000000000000000000000000000000000000FDFFFFFF0600000001000000FCFFFFFFFFFFFFFFF8FFFFFFFEFFFFFFFFFFFFFF0200000000000000FDFFFFFF01000000FCFFFFFF00000000FFFFFFFF01000000FDFFFFFF0000000000000000FEFFFFFF00000000FFFFFFFF01000000FFFFFFFF040000000000000001000000FDFFFFFFFDFFFFFF00000000030000000300000001000000FDFFFFFF0100000000000000FEFFFFFF0200000001000000FEFFFFFFFFFFFFFFFDFFFFFF050000000000000000000000FEFFFFFF04000000FCFFFFFF00000000FDFFFFFF0600000005000000050000000300000000000000040000000200000000000000FEFFFFFFFBFFFFFF000000000400000000000000FEFFFFFFFDFFFFFF00000000FBFFFFFFFEFFFFFF03000000FDFFFFFFFEFFFFFFFDFFFFFF010000000000000000000000FFFFFFFFFCFFFFFF020000000000000003000000050000000100000000000000FAFFFFFF030000000F000000FFFFFFFFFDFFFFFFFEFFFFFFFBFFFFFF03000000FCFFFFFF0100000000000000000000000300000001000000FFFFFFFF01000000000000000000000004000000010000000300000000000000FFFFFFFFFFFFFFFFFEFFFFFFFDFFFFFFFBFFFFFFFFFFFFFF04000000FEFFFFFF010000000100000004000000FFFFFFFFFFFFFFFFFFFFFFFF06000000040000000400000000000000FBFFFFFF0000000002000000030000000300000000000000FFFFFFFF0300000000000000FDFFFFFF0100000000000000FAFFFFFFFAFFFFFF0000000000000000FFFFFFFFFEFFFFFF0000000002000000FDFFFFFFFBFFFFFF020000000000000000000000FEFFFFFF01000000000000000000000000000000FDFFFFFFFAFFFFFF000000000200000000000000FEFFFFFFFEFFFFFF020000000000000002000000FFFFFFFF0300000002000000FBFFFFFFFFFFFFFFFCFFFFFF200000000300000005000000FEFFFFFF000000000000000000000000FBFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFFFEFFFFFF0300000001000000FFFFFFFF0000000000000000FEFFFFFFFDFFFFFF010000000000000000000000FEFFFFFF00000000FFFFFFFF06000000FAFFFFFF02000000FEFFFFFF01000000FAFFFFFF"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

