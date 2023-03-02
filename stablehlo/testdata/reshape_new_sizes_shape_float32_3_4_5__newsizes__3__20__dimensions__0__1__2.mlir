// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4x5xf32>
    %1 = call @expected() : () -> tensor<3x20xf32>
    %2 = stablehlo.reshape %0 : (tensor<3x4x5xf32>) -> tensor<3x20xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x20xf32>, tensor<3x20xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4x5xf32> {
    %0 = stablehlo.constant dense<[[[-2.96237659, -0.0335355662, 0.217233837, 1.27358866, -0.729995966], [1.54219961, 3.59251642, -2.83846402, 3.35471296, -3.61553645], [1.75544918, -5.10288763, -1.3973372, -1.11978114, 1.46665609], [-2.20884776, -2.63135672, 0.0102883819, 1.12641931, 2.6856997]], [[-1.76199281, 1.67992568, 0.0570272952, -5.57233095, -1.55903947], [-6.43577909, 1.6255213, 2.86052179, -3.54938889, 0.426148772], [5.8888793, -3.67026377, 2.25473619, 2.63139749, 4.575900e+00], [2.07161665, -1.06155682, 0.194238663, -0.379884183, -2.04678631]], [[0.349503607, -0.527342856, 2.14674425, -2.26491094, 1.39366341], [2.8636384, 3.63841319, 0.732589066, 4.64202166, -0.0731235892], [-0.606714904, -2.74732113, -3.20702577, -4.49452209, 0.53478384], [1.38006139, 4.27410889, -3.33952475, 0.529874921, 1.24446058]]]> : tensor<3x4x5xf32>
    return %0 : tensor<3x4x5xf32>
  }
  func.func private @expected() -> tensor<3x20xf32> {
    %0 = stablehlo.constant dense<[[-2.96237659, -0.0335355662, 0.217233837, 1.27358866, -0.729995966, 1.54219961, 3.59251642, -2.83846402, 3.35471296, -3.61553645, 1.75544918, -5.10288763, -1.3973372, -1.11978114, 1.46665609, -2.20884776, -2.63135672, 0.0102883819, 1.12641931, 2.6856997], [-1.76199281, 1.67992568, 0.0570272952, -5.57233095, -1.55903947, -6.43577909, 1.6255213, 2.86052179, -3.54938889, 0.426148772, 5.8888793, -3.67026377, 2.25473619, 2.63139749, 4.575900e+00, 2.07161665, -1.06155682, 0.194238663, -0.379884183, -2.04678631], [0.349503607, -0.527342856, 2.14674425, -2.26491094, 1.39366341, 2.8636384, 3.63841319, 0.732589066, 4.64202166, -0.0731235892, -0.606714904, -2.74732113, -3.20702577, -4.49452209, 0.53478384, 1.38006139, 4.27410889, -3.33952475, 0.529874921, 1.24446058]]> : tensor<3x20xf32>
    return %0 : tensor<3x20xf32>
  }
}
