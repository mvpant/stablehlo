// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2x1xi32>, tensor<5x2x2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>) {
    %0 = stablehlo.constant dense<"0x0000FBFF02000200010004000000000001000500000001000200FFFF0100FBFFFFFFFBFFFEFF01000800030000000200040002000000FFFFFEFFFEFF0000FAFF0300FCFF0000FEFF0200FEFFFEFFFFFF0000FCFFFFFF0400FEFF0000010000000200FAFF030002000200FBFFFEFFFEFFFFFFFFFFFFFF00000000FAFFFFFF00000300FFFF03000000FEFFFCFF02000000FFFF03000000FEFF060004000100FDFF0300FDFFFFFF0000FBFF0100FFFF0000FFFF0000FCFF010000000000F8FF0100FFFF0000FDFF00000000FEFFFDFFFFFF020001000000FCFFFEFF05000200FCFF0200FDFF000001000000000002000200FFFF0000FEFFFAFF0400FFFF0000FEFFFAFF0100FDFFF8FF000001000000FEFF00000500FEFFFFFF01000200050000000000000001000000FEFF02000200FEFF0200000000000000000002000300FDFF0100030001000000030002000300FEFFFDFFFDFF0100FFFFFEFF0200FFFFFDFF0200040002000100010002000000FEFF00000000FAFF03000000FFFF0400FFFFFDFF0000FFFF0700FEFFFBFF06000000FDFFFEFF050000000500FDFF0200000001000000"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<"0xFAFF000000000100020005000400030000000200FFFF000002000300000002000000FEFF02000000000003000000FCFF0000FFFFFFFF0500FFFFFEFF00000300FFFFFEFF020000000300040000000300FFFF0700020000000300FFFFFCFF0000FDFF000004000400FFFF00000300FEFF04000000070000000000F4FFFDFFFEFF020000000100FDFF0300FFFF02000000040000000000FFFF0000FEFFFBFF0200FEFFFEFFF9FFFAFF0000010001000600FCFF0000000000000100FCFF030000000000FDFF0100FEFF020000000000FFFF00000000000000000100FFFF010000000000FDFF0000FDFF05000400F9FFFEFF05000300FEFF060000000100FCFFFBFFF9FF0300FEFFFEFFFDFFFFFFFCFFFDFF0000020000000100"> : tensor<5x2x2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<5x2x2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0xFAFFFBFF02000300030009000400030001000700FFFF0100040002000100FDFFFFFFF9FF00000100080006000000FEFF04000100FFFF0400FEFFFEFF0000FAFF0300FCFF0000FEFF0200FEFFFEFFFFFF0000FCFFFEFF0200FEFF03000000FEFF0400FAFF060006000200FEFFFDFF05000100FFFF0200FFFFFCFFFAFFFCFF000007000300020000000100FAFF02000000FFFF03000000FEFF060004000100FDFF0300FDFFFFFF0000FFFF010006000000FFFFF4FFF9FFFFFF02000000F9FFFEFF0200FFFFFFFF00000400FEFFFDFFFEFF0200FFFFFBFFFEFFFCFF0300FBFFF6FF0200FDFF000001000000000002000200FFFF0000FEFFFAFF0400FFFF0000FFFFFBFF0700F9FFF8FF000001000100FAFF03000500FEFFFCFF02000000070000000000FFFF01000000FEFF02000300FDFF0300000000000000000002000300FDFF0100030001000000030002000300FEFFFDFFFAFF0100FCFF03000600F8FFFBFF070007000000070001000300FCFFF9FFF9FF0300F8FF0100FDFFFEFF0000FCFFFDFF0200FFFF0800FEFFFBFF06000000FDFFFEFF050000000500FDFF0200000001000000"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

