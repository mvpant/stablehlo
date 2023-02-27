module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<i8>, tensor<i8>)
    %1 = call @expected() : () -> tensor<i1>
    %2 = stablehlo.compare  LE, %0#0, %0#1,  SIGNED : (tensor<i8>, tensor<i8>) -> tensor<i1>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<i1>, tensor<i1>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<i8>, tensor<i8>) {
    %0 = stablehlo.constant dense<0> : tensor<i8>
    %1 = stablehlo.constant dense<3> : tensor<i8>
    return %0, %1 : tensor<i8>, tensor<i8>
  }
  func.func private @expected() -> tensor<i1> {
    %0 = stablehlo.constant dense<true> : tensor<i1>
    return %0 : tensor<i1>
  }
}