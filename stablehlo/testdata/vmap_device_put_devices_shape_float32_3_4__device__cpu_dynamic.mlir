// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x3x4xf32> {mhlo.sharding = ""}) -> tensor<?x3x4xf32> {
    return %arg1 : tensor<?x3x4xf32>
  }
}

