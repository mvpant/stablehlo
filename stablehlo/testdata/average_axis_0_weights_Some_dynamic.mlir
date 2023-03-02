// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x8x4xf32> {mhlo.sharding = ""}, %arg2: tensor<?x8x4xf32> {mhlo.sharding = ""}) -> tensor<8x4xf32> {
    %0 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %1 = stablehlo.reduce(%arg2 init: %0) across dimensions = [0] : (tensor<?x8x4xf32>, tensor<f32>) -> tensor<8x4xf32>
     reducer(%arg3: tensor<f32>, %arg4: tensor<f32>)  {
      %6 = stablehlo.add %arg3, %arg4 : tensor<f32>
      stablehlo.return %6 : tensor<f32>
    }
    %2 = stablehlo.multiply %arg1, %arg2 : tensor<?x8x4xf32>
    %3 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %4 = stablehlo.reduce(%2 init: %3) across dimensions = [0] : (tensor<?x8x4xf32>, tensor<f32>) -> tensor<8x4xf32>
     reducer(%arg3: tensor<f32>, %arg4: tensor<f32>)  {
      %6 = stablehlo.add %arg3, %arg4 : tensor<f32>
      stablehlo.return %6 : tensor<f32>
    }
    %5 = stablehlo.divide %4, %1 : tensor<8x4xf32>
    return %5 : tensor<8x4xf32>
  }
}

