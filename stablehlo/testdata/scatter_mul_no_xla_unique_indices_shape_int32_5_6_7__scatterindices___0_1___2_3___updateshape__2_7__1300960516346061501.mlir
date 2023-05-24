// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2xi32>, tensor<2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<2x7xi32>) {
    %0 = stablehlo.constant dense<"0x0000000002000000FFFFFFFF060000000000000000000000FFFFFFFFFCFFFFFF00000000FCFFFFFFFDFFFFFF0100000003000000000000000300000000000000FFFFFFFFFDFFFFFF02000000FCFFFFFF06000000FEFFFFFFFFFFFFFF01000000FFFFFFFF00000000FBFFFFFF0400000000000000FEFFFFFF0000000000000000FDFFFFFFFEFFFFFFFFFFFFFF02000000000000000300000000000000010000000A00000003000000000000000100000002000000FDFFFFFF0200000002000000FFFFFFFF00000000FEFFFFFFFDFFFFFF040000000300000003000000FFFFFFFF03000000FFFFFFFF03000000FEFFFFFF01000000FEFFFFFF05000000FDFFFFFF02000000000000000000000001000000030000000300000003000000FEFFFFFF000000000000000004000000020000000000000001000000010000000000000007000000FBFFFFFFFFFFFFFFFFFFFFFF00000000000000000300000001000000FBFFFFFF010000000300000000000000FAFFFFFF02000000FCFFFFFFFDFFFFFF000000000000000000000000FBFFFFFFFFFFFFFF000000000300000002000000FDFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFDFFFFFFFDFFFFFFFDFFFFFFFEFFFFFF02000000FFFFFFFFFEFFFFFF02000000FEFFFFFF00000000FEFFFFFFFEFFFFFFFEFFFFFF020000000000000000000000020000000200000000000000FDFFFFFF05000000FCFFFFFFFEFFFFFF00000000FEFFFFFF0000000004000000FFFFFFFF000000000500000000000000FDFFFFFFFEFFFFFF08000000FFFFFFFF04000000FEFFFFFF000000000000000000000000FDFFFFFF07000000000000000000000004000000000000000000000001000000FDFFFFFF0300000000000000040000000300000002000000FEFFFFFF00000000FEFFFFFF0200000000000000FEFFFFFF01000000FEFFFFFFFDFFFFFF0000000003000000F9FFFFFF000000000300000000000000000000000000000000000000020000000100000002000000FFFFFFFFFFFFFFFF00000000000000000500000000000000FDFFFFFFFDFFFFFF00000000FDFFFFFFFFFFFFFFFEFFFFFF00000000FFFFFFFF040000000100000003000000FFFFFFFFFEFFFFFFFCFFFFFF0100000001000000000000000300000000000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[2, 1, 4, 0, -1, -1, 1], [-2, 0, -3, 1, 4, -4, -6]]> : tensor<2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x0000000002000000FFFFFFFF060000000000000000000000FFFFFFFFF8FFFFFF00000000F0FFFFFF00000000FFFFFFFFFDFFFFFF000000000300000000000000FFFFFFFFFDFFFFFF02000000FCFFFFFF06000000FEFFFFFFFFFFFFFF01000000FFFFFFFF00000000FBFFFFFF0400000000000000FEFFFFFF0000000000000000FDFFFFFFFEFFFFFFFFFFFFFF02000000000000000300000000000000010000000A00000003000000000000000100000002000000FDFFFFFF0200000002000000FFFFFFFF00000000FEFFFFFFFDFFFFFF040000000300000003000000FFFFFFFF03000000FFFFFFFF03000000FEFFFFFF01000000FEFFFFFF05000000FDFFFFFF02000000000000000000000001000000030000000300000003000000FEFFFFFF000000000000000004000000020000000000000001000000010000000000000007000000FBFFFFFFFFFFFFFFFFFFFFFF00000000000000000300000001000000FBFFFFFF010000000300000000000000FAFFFFFF02000000FCFFFFFFFDFFFFFF000000000000000000000000FBFFFFFFFFFFFFFF000000000300000002000000FDFFFFFF040000000000000003000000FFFFFFFFF4FFFFFF0C00000012000000FDFFFFFFFEFFFFFF02000000FFFFFFFFFEFFFFFF02000000FEFFFFFF00000000FEFFFFFFFEFFFFFFFEFFFFFF020000000000000000000000020000000200000000000000FDFFFFFF05000000FCFFFFFFFEFFFFFF00000000FEFFFFFF0000000004000000FFFFFFFF000000000500000000000000FDFFFFFFFEFFFFFF08000000FFFFFFFF04000000FEFFFFFF000000000000000000000000FDFFFFFF07000000000000000000000004000000000000000000000001000000FDFFFFFF0300000000000000040000000300000002000000FEFFFFFF00000000FEFFFFFF0200000000000000FEFFFFFF01000000FEFFFFFFFDFFFFFF0000000003000000F9FFFFFF000000000300000000000000000000000000000000000000020000000100000002000000FFFFFFFFFFFFFFFF00000000000000000500000000000000FDFFFFFFFDFFFFFF00000000FDFFFFFFFFFFFFFFFEFFFFFF00000000FFFFFFFF040000000100000003000000FFFFFFFFFEFFFFFFFCFFFFFF0100000001000000000000000300000000000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

