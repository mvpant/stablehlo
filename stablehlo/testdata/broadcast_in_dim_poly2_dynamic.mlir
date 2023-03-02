// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<i64>, %arg2: tensor<?x1x?xf32> {mhlo.sharding = ""}) -> tensor<?x5x6x?x4xf32> {
    %0 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %1 = stablehlo.reshape %0 : (tensor<i32>) -> tensor<1xi32>
    %2 = stablehlo.constant dense<5> : tensor<1xi32>
    %3 = stablehlo.constant dense<6> : tensor<1xi32>
    %4 = stablehlo.convert %arg1 : (tensor<i64>) -> tensor<i32>
    %5 = stablehlo.reshape %4 : (tensor<i32>) -> tensor<1xi32>
    %6 = stablehlo.constant dense<4> : tensor<1xi32>
    %7 = stablehlo.concatenate %1, %2, %3, %5, %6, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<5xi32>
    %8 = stablehlo.dynamic_broadcast_in_dim %arg2, %7, dims = [0, 2, 3] : (tensor<?x1x?xf32>, tensor<5xi32>) -> tensor<?x5x6x?x4xf32>
    return %8 : tensor<?x5x6x?x4xf32>
  }
}

