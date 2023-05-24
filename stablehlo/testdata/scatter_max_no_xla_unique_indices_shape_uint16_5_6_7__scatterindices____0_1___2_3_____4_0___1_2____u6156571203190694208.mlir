// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x2xi32>, tensor<5x2x2xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>) {
    %0 = stablehlo.constant dense<"0x050000000300030006000600000001000000050004000300000002000100010003000000010002000000040002000000020001000400040000000300030001000000000001000500000002000300010000000100000001000200000000000100000002000100030000000200000000000000000000000000040001000100050000000100030001000100000006000000010000000400000000000300000008000100020000000200010004000300010007000000080002000100010000000100000000000000000001000400000001000000010001000800030000000200000000000100010000000100000003000300030003000300000004000300030004000100040005000000000000000200050000000000020004000200030001000500020002000000030001000200000004000400020006000000040003000100010001000200020001000500000000000200000003000000000001000200010003000100020000000300060003000200030000000000030001000500000000000200040005000300000003000100010001000200020000000200050000000300000003000100"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[[1, 0], [0, 2]], [[2, 0], [1, 2]], [[7, 1], [3, 4]], [[3, 3], [2, 3]], [[0, 3], [3, 0]]]> : tensor<5x2x2xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x050001000300030006000600000001000000050004000300000002000100010003000000010002000000040002000000020001000400040000000300030001000000000001000500000002000300010000000100000002000200000000000100000002000100030000000200000000000000000000000000040001000100050000000100030001000100000006000000010000000400000000000300000008000100020000000200010007000300010007000000080002000100040000000100000000000000000001000400000001000000010001000800030000000200000003000100010000000100000003000300030003000300000004000300030004000100040005000000000000000200050000000000020004000200030001000500020002000000030001000200000004000400020006000000040003000100010001000200020001000500000000000200000003000000000001000200010003000100020000000300060003000200030000000300030001000500000000000200040005000300000003000100010001000200020000000200050000000300000003000100"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

