// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x2xi32>, tensor<5x2x2xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>) {
    %0 = stablehlo.constant dense<"0xF6BF81BF403F58405FC084402BC00640F6BEF6BF58BF754076C0A1BFA640CFC0B8C0203F56C083C003406F405E40A2C0B24084C0B2BE83BF49C0BAC0CCC0F7BF4C3E29C0C7BFDFBFAD407C3F953EAEC0403F3C406740D63F623F0DC0A04002400B4014C09B40FCC00C3E7D40A1C0B1C08EC0883E78C0733E31C02DC082C0BDC07240E03FB8BF0FC03C40F83FA3C09540EA3F4140F0BFC63D0B3F6AC07040A8BEB03F8AC052C0F7BFD73EF9BF273F1E40A5BFD83F32C043C09ABF0AC0EF409EBEF5BD54401840D33F85BF82C0BDBE3CBF0CC0CABDE2405240803E29BFA83FAEC0283F8040803F1DC11F406F40B83F0CC09640024192C093BF883F52405040B5BF83BF0740B83FC53F84C0B43F5FC0A3C01040AC40A9C0E83F55BEFCBCBC3F7EBE85C0C8C0F8BF453EE8BF2BC0733ECCC0ED3E38C0C1BFAA3F6C40E6BFA6401AC09A40D0405FBF2FC0424050401C3F7540E03F4E401CC0F43F8DBF75C08B40464042C0C03F53C0C03FB7C0AF3FF5BF53BE064009C0243E8D4083C00440BD400B40523FA740543F4840F0BC2A4084BF823F4B3F74BF52BFFCC0663FB4BF9140573F9140B540"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<[[[2.990720e-02, 1.609380e+00], [1.148440e+00, 3.857420e-02]], [[2.207030e-01, -5.859380e-01], [2.703130e+00, 3.937500e+00]], [[-4.687500e-01, -2.843750e+00], [1.312500e+00, 1.734380e+00]], [[-2.453130e+00, 1.375000e+00], [-2.890630e+00, 2.937500e+00]], [[1.914060e+00, 6.687500e+00], [2.390630e+00, 2.390630e+00]]]> : tensor<5x2x2xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0xF6BF7ABF403F58405FC084402BC00640F6BEF1BF58BF754076C0A1BFA640CFC0B8C00F4056C083C003406F405E40A2C0B24084C0B2BE83BFFFBFBAC0CCC0F7BF4C3E29C0C7BFDFBFAD407C3F953EAEC0403F3C406740F23F623F0DC0A04002400B4014C09B407CC00C3E7D40A1C0B1C08EC0883E78C0B2BE31C02DC082C0BDC07240E03FB8BF0FC03C40F83F19C09540EA3F4140F0BFC63D0B3F6AC07040A8BEB03F8AC052C0F7BFD73E1AC0273F1E40A5BFD83F32C043C09ABFD8BEEF409EBEF5BD54401840D33F85BFDDC0BDBE3CBF0CC0CABDE2405240803E29BFA83FAEC0FC3F8040803F1DC11F406F40B83F0CC09640024192C093BF883F5240504078C083BF0740B83FC53F84C0B43F5FC00AC01040AC40A9C0E83F55BEFCBCBC3F903F85C0C8C0F8BF453EE8BF2BC0733ECCC0ED3E38C08DC0AA3F6C40E6BFA6401AC09A40D0405FBF2FC0424050401C3F7540E03FA4401CC0F43F8DBF75C08B40464042C0794053C0C03FB7C0AF3FF5BF53BE06409240243E8D4083C00440BD400B40523FA740543F484017402A4084BF823F4B3F74BF52BFFCC0663FB4BF9140573F9140B540"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

