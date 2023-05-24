// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x3x2xf32> {mhlo.sharding = ""}, %arg2: tensor<?x3x1xf32> {mhlo.sharding = ""}) -> tensor<?x3x2xcomplex<f32>> {
    %0 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %1 = stablehlo.reshape %0 : (tensor<i32>) -> tensor<1xi32>
    %2 = stablehlo.constant dense<3> : tensor<1xi32>
    %3 = stablehlo.constant dense<2> : tensor<1xi32>
    %4 = stablehlo.concatenate %1, %2, %3, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<3xi32>
    %5 = stablehlo.dynamic_broadcast_in_dim %arg2, %4, dims = [0, 1, 2] : (tensor<?x3x1xf32>, tensor<3xi32>) -> tensor<?x3x2xf32>
    %6 = stablehlo.complex %arg1, %5 : tensor<?x3x2xcomplex<f32>>
    return %6 : tensor<?x3x2xcomplex<f32>>
  }
}

