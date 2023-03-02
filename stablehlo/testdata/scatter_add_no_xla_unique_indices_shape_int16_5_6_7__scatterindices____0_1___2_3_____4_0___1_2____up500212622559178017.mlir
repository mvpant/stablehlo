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
    %0 = stablehlo.constant dense<"0x0000070003000100FBFF0000FBFFFEFF00000400FDFFFEFF0300FCFF0500FEFF0000FFFFFEFF0500FDFF01000000FDFF01000100FEFF00000000FCFF0500FFFF00000000FFFF02000000030003000000FBFF0000FFFF00000200FEFF00000000FEFFFEFF0100FCFF010003000100FEFF04000100FBFF000004000000FEFFFCFFFDFF0200040002000100010003000000FEFF00000000FFFF050003000000FCFF0000000003000200FCFF000000000400FFFFFDFF02000000000001000200FFFFFDFF00000300FFFF0300FFFF000001000300FEFF00000300FEFFFEFFFDFFFBFF0000FDFF0000020000000000020004000000010003000000FDFF0000FFFFFBFF020001000000FDFF000000000500FDFF000004000000FFFF0200010003000600FEFFFDFF02000200FEFFFEFFFAFF03000100FDFFFEFF02000000FCFF0300010005000100FDFFFFFF0300FDFFFEFFFFFFFFFFFDFF00000300FDFF0900FEFFFFFF0400FFFFFBFF010004000000010000000400000000000200FCFF00000000FCFFFFFFFCFFFFFF0600FDFF0100020004000000FEFF000004000300FDFF00000200FFFF0200"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<[[[-3, 0], [-2, -2]], [[-2, 2], [2, -2]], [[4, 5], [2, -1]], [[-1, -2], [-5, 0]], [[-1, 5], [0, 1]]]> : tensor<5x2x2xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<5x2x2xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x0000040003000100FBFF0000FBFFFEFF00000200FDFFFEFF0300FCFF0500FEFF0000FFFFFEFF0500FDFF01000000FDFF01000100FEFF0000FEFFFCFF0500FFFF00000000FFFF02000000030003000000FBFF0000FFFFFEFF0200FEFF00000000FEFFFEFF0100FAFF010003000100FEFF04000100FBFF020004000000FEFFFCFFFDFF0200040002000100010005000000FEFF00000000FFFF050003000000FCFF0000000003000200FCFF040000000400FFFFFDFF02000000000000000200FFFFFDFF00000300FFFF03000400000001000300FEFF00000300FEFFFEFFFDFFFBFF0200FDFF0000020000000000020004000000010003000000FDFF0000FFFFFAFF020001000000FDFF000000000500FDFF000004000000FFFF0200010003000400FEFFFDFF02000200FEFFFEFFFAFF03000100FDFFF9FF02000000FCFF0300010005000100FDFFFFFF0300FDFFFEFFFFFFFFFFFCFF00000300FDFF0900FEFFFFFF04000000FBFF010004000000010000000400050000000200FCFF00000000FCFFFFFFFCFFFFFF0600FDFF0100020004000000FEFF000004000300FDFF00000200FFFF0200"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

