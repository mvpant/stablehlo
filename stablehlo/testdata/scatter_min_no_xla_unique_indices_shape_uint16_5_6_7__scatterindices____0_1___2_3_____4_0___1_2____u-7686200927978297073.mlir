// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x2xi32>, tensor<5x2x2xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>) {
    %0 = stablehlo.constant dense<"0x0300050001000100060000000100020003000000030005000400030000000200030003000800040000000000000001000200000005000000030002000500010001000200010002000300030001000200040006000300040000000200040000000000010000000000060001000500020002000100000001000100010000000000010003000500000001000100050004000600000002000200050000000000000001000000010002000100020000000A0001000300030002000600040000000200000000000000000000000400020002000300010002000000000002000600070003000100090001000200000002000100000001000500010000000000040002000100000009000100000003000200030001000100000001000400010001000100010001000000040002000300010001000200010000000000060002000100010000000400020001000100020000000200050005000100020003000000000002000200010003000200000005000200050002000000010001000000040001000300050000000900020000000200060003000200030002000400070000000000000003000000"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[[1, 1], [0, 2]], [[1, 0], [1, 0]], [[0, 0], [4, 2]], [[1, 5], [0, 2]], [[3, 1], [2, 4]]]> : tensor<5x2x2xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x0300010001000100060000000100020003000000030005000400030000000200030001000800040000000000000001000200000005000000000002000500010001000200010002000300030001000200040006000300010000000200040000000000010000000000060001000500020002000100000000000100010000000000010003000500000001000100010004000600000002000200050000000000000001000000010002000100000000000A0001000300030002000600020000000200000000000000000000000000020002000300010002000000000002000600070003000100090001000200000002000100000001000500010000000000040001000100000009000100000003000200020001000100000001000400010001000100010001000000040002000300010001000200010000000000060002000100010000000400020001000100020000000200050003000100020003000000000002000200010003000200000005000200050002000000010001000000040001000300050000000900020000000200060003000200030002000400070000000000000003000000"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

