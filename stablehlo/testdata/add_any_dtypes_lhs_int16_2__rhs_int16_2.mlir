// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2xi16>, tensor<2xi16>)
    %1 = call @expected() : () -> tensor<2xi16>
    %2 = stablehlo.add %0#0, %0#1 : tensor<2xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2xi16>, tensor<2xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2xi16>, tensor<2xi16>) {
    %0 = stablehlo.constant dense<0> : tensor<2xi16>
    %1 = stablehlo.constant dense<[0, -5]> : tensor<2xi16>
    return %0, %1 : tensor<2xi16>, tensor<2xi16>
  }
  func.func private @expected() -> tensor<2xi16> {
    %0 = stablehlo.constant dense<[0, -5]> : tensor<2xi16>
    return %0 : tensor<2xi16>
  }
}
