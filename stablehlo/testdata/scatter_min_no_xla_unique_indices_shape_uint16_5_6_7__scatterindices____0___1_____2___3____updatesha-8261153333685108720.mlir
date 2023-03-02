// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x1xi32>, tensor<5x2x2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>) {
    %0 = stablehlo.constant dense<"0x000000000200010002000000000002000500040001000400030004000200000001000100010004000100030002000300040002000500020002000100020003000500050003000000020000000200010001000700020002000400000002000100010000000100000006000200040004000500070001000200010001000000030003000200000001000000060005000000000000000300010000000000040004000000010001000200020002000100040002000000000004000200010005000100050003000000000001000100010000000000000000000300010000000000020002000000010004000400010003000200010003000300030001000300030000000300010003000400050002000500010002000200020000000000010001000300030006000100030001000100010001000400000002000200010000000300010004000000020000000000020000000100030003000400070000000000010002000200020003000200000001000400020005000400000003000000010000000200020003000500000007000600010001000300050002000000000002000000020000000300"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<"0x07000200030004000100020003000000010002000100010002000000010003000000000001000300010001000100030000000300010000000100040003000600000008000100000006000300000002000000020001000400000001000000000006000200020001000000000004000200020005000500060002000700040004000100010003000000010003000000030005000200020003000500040001000200000001000400010000000100000002000300030000000000010002000200000001000400050000000100050001000000020002000300030000000000000004000100040007000400000002000700030003000300040000000000040002000000050003000200010000000000040003000400000000000000"> : tensor<5x2x2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x000000000200010001000000000000000100020001000100020000000100000000000000010003000100010001000300000002000100000002000100020003000500050003000000020000000200010001000700010002000300000000000100010000000100000000000200000002000100040000000100000000000000020002000100000000000000020005000000000000000300010000000000040004000000010001000200020002000100040002000000000004000100010003000000010003000000000001000100010000000000000000000200000000000000010002000000010004000400010003000200010003000300030001000300000000000000010003000300000000000100010002000000010000000000000001000300010000000100020001000100000000000000000002000200010000000300010004000000020000000000020000000100010003000400040000000000010002000200020003000000000001000200000005000300000001000000000000000200020000000000000007000600010001000300050002000000000002000000020000000300"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

