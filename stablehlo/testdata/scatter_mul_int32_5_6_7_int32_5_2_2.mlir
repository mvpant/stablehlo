// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>)
    %1 = call @expected() : () -> tensor<5x6x7xi32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %3 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %3 : tensor<i32>
    }) : (tensor<5x6x7xi32>, tensor<2x2x2xi64>, tensor<5x2x2xi32>) -> tensor<5x6x7xi32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> ()
    return %2 : tensor<5x6x7xi32>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32> {mhlo.layout_mode = "default"}, tensor<5x2x2xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x010000000400000000000000030000000300000000000000FEFFFFFF01000000FEFFFFFFFEFFFFFF0000000002000000FEFFFFFF030000000A00000000000000FAFFFFFF00000000FEFFFFFF0100000001000000FEFFFFFF000000000000000002000000FEFFFFFF00000000FEFFFFFFFEFFFFFFFFFFFFFF0100000000000000040000000400000002000000000000000200000001000000010000000200000000000000080000000100000000000000FFFFFFFF01000000FCFFFFFFFFFFFFFF02000000FCFFFFFF04000000FFFFFFFF0000000000000000FEFFFFFF01000000FEFFFFFF01000000FFFFFFFF0000000000000000FDFFFFFFFCFFFFFFFBFFFFFF04000000000000000200000003000000050000000200000000000000FFFFFFFFFDFFFFFF03000000FCFFFFFF0200000001000000FDFFFFFF01000000FFFFFFFF0100000001000000FCFFFFFF0100000000000000010000000000000000000000020000000000000001000000FFFFFFFF0100000000000000FCFFFFFF000000000000000000000000FFFFFFFFFBFFFFFF00000000FEFFFFFF04000000F9FFFFFF010000000300000003000000010000000200000001000000FEFFFFFFFAFFFFFF00000000FFFFFFFF01000000FDFFFFFF00000000FCFFFFFF0100000001000000FDFFFFFF02000000000000000000000000000000FFFFFFFFFDFFFFFFFFFFFFFFFBFFFFFF0000000002000000020000000000000003000000000000000400000000000000010000000100000004000000FFFFFFFFFCFFFFFF030000000000000000000000030000000200000000000000FCFFFFFF00000000FFFFFFFFFFFFFFFFFEFFFFFF02000000040000000000000000000000FEFFFFFFFFFFFFFF0200000001000000FEFFFFFFFBFFFFFFFEFFFFFF01000000FCFFFFFF0000000001000000FFFFFFFFFFFFFFFF0000000003000000FDFFFFFF04000000000000000100000002000000010000000200000000000000FDFFFFFF0100000000000000FDFFFFFF000000000100000001000000FEFFFFFFFBFFFFFFFFFFFFFF0000000004000000000000000300000003000000FFFFFFFFFFFFFFFF000000000200000002000000FFFFFFFF00000000020000000000000001000000FEFFFFFFFDFFFFFF000000000400000001000000"> : tensor<5x6x7xi32>
    %c_0 = stablehlo.constant dense<[[[3, -3], [-2, -4]], [[-4, -3], [-3, 2]], [[-2, 1], [0, 4]], [[-4, -1], [0, -4]], [[6, 1], [0, -2]]]> : tensor<5x2x2xi32>
    return %c, %c_0 : tensor<5x6x7xi32>, tensor<5x2x2xi32>
  }
  func.func private @expected() -> (tensor<5x6x7xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x010000000C00000000000000030000000300000000000000FEFFFFFF01000000FEFFFFFF080000000000000002000000FEFFFFFF030000000A00000000000000FAFFFFFF00000000FEFFFFFF0100000001000000FEFFFFFF000000000000000002000000FEFFFFFF00000000FEFFFFFF04000000FFFFFFFF0100000000000000040000000400000002000000000000000200000001000000010000000200000000000000080000000100000000000000FFFFFFFF01000000FCFFFFFFFFFFFFFF02000000FCFFFFFF04000000FEFFFFFF0000000000000000FEFFFFFF01000000FEFFFFFF01000000FFFFFFFF0000000000000000FDFFFFFFFCFFFFFFFBFFFFFF04000000000000000200000003000000050000000200000000000000FFFFFFFFFDFFFFFF03000000FCFFFFFF0200000001000000FDFFFFFF01000000FFFFFFFF0100000001000000FCFFFFFF0100000000000000FEFFFFFF0000000000000000020000000000000001000000FFFFFFFF0100000000000000FCFFFFFF000000000000000000000000FFFFFFFFFBFFFFFF00000000FEFFFFFF04000000F9FFFFFF010000000300000003000000010000000200000001000000FEFFFFFFFAFFFFFF00000000FFFFFFFF01000000FDFFFFFF00000000FCFFFFFF0100000001000000FDFFFFFF02000000000000000000000000000000FFFFFFFFFDFFFFFF04000000FBFFFFFF000000000200000002000000000000000300000000000000F0FFFFFF00000000010000000100000004000000FFFFFFFFFCFFFFFF030000000000000000000000030000000200000000000000FCFFFFFF00000000FFFFFFFFFFFFFFFFFEFFFFFF02000000000000000000000000000000FEFFFFFFFFFFFFFF0200000001000000FEFFFFFFFBFFFFFFFEFFFFFF01000000FCFFFFFF0000000001000000FFFFFFFFFAFFFFFF0000000003000000FDFFFFFF04000000000000000100000002000000FEFFFFFF0200000000000000FDFFFFFF0100000000000000FDFFFFFF000000000100000001000000FEFFFFFFFBFFFFFFFFFFFFFF0000000004000000000000000300000003000000FFFFFFFF00000000000000000200000002000000FFFFFFFF00000000020000000000000001000000FEFFFFFFFDFFFFFF000000000400000001000000"> : tensor<5x6x7xi32>
    return %c : tensor<5x6x7xi32>
  }
}