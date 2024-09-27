// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<2x3xf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:3 = call @inputs() : () -> (tensor<2x3xi1>, tensor<2x3xf16>, tensor<2x3xf16>)
    %1 = call @expected() : () -> tensor<2x3xf16>
    %2 = stablehlo.select %0#0, %0#2, %0#1 : tensor<2x3xi1>, tensor<2x3xf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<2x3xf16>, tensor<2x3xf16>) -> ()
    return %2 : tensor<2x3xf16>
  }
  func.func private @inputs() -> (tensor<2x3xi1> {mhlo.layout_mode = "default"}, tensor<2x3xf16> {mhlo.layout_mode = "default"}, tensor<2x3xf16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<true> : tensor<2x3xi1>
    %cst = stablehlo.constant dense<[[2.345700e+00, -3.708980e+00, -3.125000e-01], [-1.188480e+00, 5.234380e+00, 3.688960e-01]]> : tensor<2x3xf16>
    %cst_0 = stablehlo.constant dense<[[-3.354490e-01, 2.207030e+00, 9.462890e-01], [-7.617180e-01, 1.318360e+00, 5.312500e+00]]> : tensor<2x3xf16>
    return %c, %cst, %cst_0 : tensor<2x3xi1>, tensor<2x3xf16>, tensor<2x3xf16>
  }
  func.func private @expected() -> (tensor<2x3xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-3.354490e-01, 2.207030e+00, 9.462890e-01], [-7.617180e-01, 1.318360e+00, 5.312500e+00]]> : tensor<2x3xf16>
    return %cst : tensor<2x3xf16>
  }
}