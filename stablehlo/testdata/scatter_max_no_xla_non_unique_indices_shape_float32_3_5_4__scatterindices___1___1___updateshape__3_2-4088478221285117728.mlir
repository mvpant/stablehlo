// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xf32>, tensor<3x2x4xf32>)
    %2 = call @expected() : () -> tensor<3x5x4xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xf32>, tensor<2x1xi32>, tensor<3x2x4xf32>) -> tensor<3x5x4xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xf32>, tensor<3x5x4xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xf32>, tensor<3x2x4xf32>) {
    %0 = stablehlo.constant dense<[[[5.09688663, 6.23198699, 4.06049156, -1.60519361], [0.985119521, -4.36682844, -0.846203982, 3.05821323], [-1.9639461, 0.539973795, -0.360455066, -0.694631934], [0.373230338, 4.15367794, -1.90692449, 6.20180559], [-1.34755313, 2.97656107, -5.8807435, -2.40851569]], [[-0.417034417, -1.18042827, -3.77787614, -3.99143481], [-4.63594055, -3.78773046, -3.05780458, -0.110915124], [-0.278965682, -0.301429063, 0.49902004, 2.8770225], [-2.55546165, -0.686553359, 2.8372879, 2.77480507], [1.05282116, 0.0841837897, -4.02734137, 0.0910546109]], [[8.69586944, 1.14761329, 1.46356463, -2.01309609], [-4.44314957, 2.076850e+00, -5.79015923, 1.29819858], [-3.7800808, 4.23801851, 0.771010458, 2.63374496], [-3.242130e-01, 0.382399976, 2.8982482, 0.574922621], [-0.0899443477, -0.209361538, -5.45742226, 3.50102329]]]> : tensor<3x5x4xf32>
    %1 = stablehlo.constant dense<[[[1.82848799, 1.07396472, -0.64421773, -3.24742103], [-7.44991636, 1.83169985, -1.03108871, 1.45275044]], [[3.27605367, -1.30596232, -5.73748779, 1.40525913], [1.61962259, -2.90803695, -3.21194363, -2.14855933]], [[-1.89624679, 2.28133368, -7.47177314, 2.97684646], [-4.33874559, -2.02739573, 1.45558751, 5.03033781]]]> : tensor<3x2x4xf32>
    return %0, %1 : tensor<3x5x4xf32>, tensor<3x2x4xf32>
  }
  func.func private @expected() -> tensor<3x5x4xf32> {
    %0 = stablehlo.constant dense<[[[5.09688663, 6.23198699, 4.06049156, -1.60519361], [1.82848799, 1.83169985, -0.64421773, 3.05821323], [-1.9639461, 0.539973795, -0.360455066, -0.694631934], [0.373230338, 4.15367794, -1.90692449, 6.20180559], [-1.34755313, 2.97656107, -5.8807435, -2.40851569]], [[-0.417034417, -1.18042827, -3.77787614, -3.99143481], [3.27605367, -1.30596232, -3.05780458, 1.40525913], [-0.278965682, -0.301429063, 0.49902004, 2.8770225], [-2.55546165, -0.686553359, 2.8372879, 2.77480507], [1.05282116, 0.0841837897, -4.02734137, 0.0910546109]], [[8.69586944, 1.14761329, 1.46356463, -2.01309609], [-1.89624679, 2.28133368, 1.45558751, 5.03033781], [-3.7800808, 4.23801851, 0.771010458, 2.63374496], [-3.242130e-01, 0.382399976, 2.8982482, 0.574922621], [-0.0899443477, -0.209361538, -5.45742226, 3.50102329]]]> : tensor<3x5x4xf32>
    return %0 : tensor<3x5x4xf32>
  }
}

