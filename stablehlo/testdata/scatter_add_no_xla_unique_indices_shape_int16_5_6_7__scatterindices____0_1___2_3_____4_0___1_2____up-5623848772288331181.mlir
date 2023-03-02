// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<5x2x2xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2x2xi32>, tensor<5x2x2xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<5x2x2xi16>) {
    %0 = stablehlo.constant dense<"0x01000000010001000000FDFF01000200000000000000FDFFFDFF01000400F9FFFFFFF7FFFEFF0000FEFF0100FAFFFBFF06000100000000000000000000000000FDFFFEFFFBFF0000FEFF030003000200020004000100FCFFFAFF06000100FEFF04000300FEFF0100FDFF040003000000FBFF0400070002000100000000000100FBFF02000000FCFFFEFF0200FFFFFDFF01000100FEFF0000020005000100FBFFFFFF0000000003000300010000000200FDFF00000400FFFF0000FCFF000000000000FFFFFDFFFFFF00000000FBFFFBFF0000FFFFFFFF02000400FBFFFEFFFFFFFCFF01000000FDFF0200FEFF0500FEFFFEFF030003000400030000000000FDFF01000000FFFF0000FBFFFCFFFEFFFEFF030004000000FDFF00000000FBFF01000000020003000400FEFFFDFFFFFF0400FFFF0000FEFFFDFF0000FCFF0000010003000000FAFFFFFF0000FDFFFBFFFFFF0000FFFFFDFFFDFFFCFFFDFF03000000FFFF0400FFFFFEFF000000000000FEFF01000300FCFFFEFF000001000100000001000100FEFF0100000000000200020004000000FDFF00000500FCFFFFFF02000200FEFF"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<[[[-3, 4], [0, 7]], [[4, -1], [-2, 4]], [[-1, -3], [0, -2]], [[-1, 2], [-4, 3]], [[2, -1], [1, 2]]]> : tensor<5x2x2xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<5x2x2xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x0100FDFF010001000000FDFF01000200000007000000FDFFFDFF01000400F9FFFFFFFBFFFEFF0000FEFF0100FAFFFBFF06000100000000000000000000000000FDFFFEFFFBFF0000FEFF0300030002000200040001000000FAFF06000100FEFF04000300FEFF0500FDFF040003000000FBFF0400070001000100000000000100FBFF02000000FCFFFEFF0200FDFFFDFF01000100FEFF0000020005000100FBFFFFFF0000000003000300000000000200FDFF00000400FFFF0000FAFF000000000000FFFFFDFFFFFF0000FDFFFBFFFBFF0000FFFFFFFF02000400FBFFFEFFFFFFFCFF01000000FDFF0200FEFF0500FEFFFEFF030003000400030000000000FCFF01000000FFFF0000FBFFFCFFFEFF0100030004000000FDFF00000000FBFF03000000020003000400FEFFFDFFFFFF0400FFFF0000FAFFFDFF0000FCFF0000010003000000FAFFFFFF0000FDFFFBFFFFFF00000100FDFFFDFFFCFFFDFF03000000FFFF0600FFFFFEFF000000000000FEFF01000200FCFFFEFF000001000100000001000100FEFF0100010000000200020004000000FDFF00000500FCFFFFFF02000200FEFF"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

