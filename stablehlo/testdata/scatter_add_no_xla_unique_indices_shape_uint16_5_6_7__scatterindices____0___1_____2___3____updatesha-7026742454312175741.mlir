// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x1xi32>, tensor<5x2x2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>) {
    %0 = stablehlo.constant dense<"0x010000000100010001000000010001000100000001000400030004000300010002000300020002000100010002000500050000000300050005000200000000000000020000000100000002000100040005000200000002000500060001000300000002000000010001000500010000000200010000000000010005000200000003000400000004000100020001000700030003000500000003000300000001000200050004000500020003000300030004000000060006000100020001000300030005000500000002000000010000000700000002000300020003000100000001000100000002000400020002000200010004000100040000000100010000000100010005000500010005000000020004000000040000000000020003000200060005000100010001000200000001000200020005000000020001000200020000000500040000000000000001000100010003000300010004000100080003000200030002000200010002000200000002000000020002000200040001000300020001000500020001000100000000000200000000000000020003000200050002000100"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<"0x0000010003000500060002000000000000000600000002000000020004000300000000000000010001000400000004000300000001000000010003000200000000000000000005000000040000000000040001000300050003000400000005000500040001000400010000000000030006000100000004000200030001000000010002000400000004000100030002000100020000000300050001000300000003000000010005000300060002000600010005000100020001000300000001000400000001000500010000000200040005000200020002000100020000000500060004000100000000000000020001000100050002000A000200000002000200000004000000040001000100010000000100040002000200"> : tensor<5x2x2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x01000100040006000700020001000100010006000100060003000600070004000200030002000300020005000200090008000000040005000500020000000000000002000000010000000200010004000500020001000500070006000100030000000700000005000100050005000100050006000300040001000A000700040004000800010004000100050001000700030003000500000003000300000001000200050004000500080004000300070006000300070006000200040005000300070006000800020003000200010003000C00010005000300050003000200050001000100000002000400020002000200010004000100040000000100040006000300070006000A000200070001000500040001000800000001000700040002000800090006000300030004000100030002000700050000000200010002000200000005000400000000000000010001000700070004000100040001000A0004000300080004000C00030002000400020002000400020006000300050002000300030005000700040001000100000000000200000000000000020003000200050002000100"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

