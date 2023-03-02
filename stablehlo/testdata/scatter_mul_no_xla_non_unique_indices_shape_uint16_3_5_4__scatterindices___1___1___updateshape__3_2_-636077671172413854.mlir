// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xui16>, tensor<3x2x4xui16>)
    %2 = call @expected() : () -> tensor<3x5x4xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xui16>, tensor<2x1xi32>, tensor<3x2x4xui16>) -> tensor<3x5x4xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xui16>, tensor<3x5x4xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xui16>, tensor<3x2x4xui16>) {
    %0 = stablehlo.constant dense<[[[1, 4, 2, 1], [4, 3, 1, 1], [1, 1, 4, 1], [0, 9, 7, 1], [0, 0, 1, 2]], [[3, 2, 0, 4], [0, 3, 1, 1], [3, 4, 8, 1], [1, 1, 2, 1], [1, 2, 5, 0]], [[3, 2, 2, 1], [0, 5, 1, 2], [0, 6, 3, 2], [0, 3, 1, 2], [0, 4, 0, 0]]]> : tensor<3x5x4xui16>
    %1 = stablehlo.constant dense<[[[0, 1, 6, 2], [4, 2, 3, 5]], [[0, 1, 3, 0], [7, 6, 1, 6]], [[0, 1, 3, 2], [2, 1, 4, 0]]]> : tensor<3x2x4xui16>
    return %0, %1 : tensor<3x5x4xui16>, tensor<3x2x4xui16>
  }
  func.func private @expected() -> tensor<3x5x4xui16> {
    %0 = stablehlo.constant dense<[[[1, 4, 2, 1], [0, 6, 18, 10], [1, 1, 4, 1], [0, 9, 7, 1], [0, 0, 1, 2]], [[3, 2, 0, 4], [0, 18, 3, 0], [3, 4, 8, 1], [1, 1, 2, 1], [1, 2, 5, 0]], [[3, 2, 2, 1], [0, 5, 12, 0], [0, 6, 3, 2], [0, 3, 1, 2], [0, 4, 0, 0]]]> : tensor<3x5x4xui16>
    return %0 : tensor<3x5x4xui16>
  }
}

