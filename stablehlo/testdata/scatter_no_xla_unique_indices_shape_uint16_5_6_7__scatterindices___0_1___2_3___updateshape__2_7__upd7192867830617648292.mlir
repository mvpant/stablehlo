// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      stablehlo.return %arg1 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2xi32>, tensor<2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<2x7xui16>) {
    %0 = stablehlo.constant dense<"0x03000200000001000100020002000500010000000300010005000200020000000700010005000600000000000300000003000100040001000200010003000400010003000200020003000000030000000100000003000000000002000000020000000200020000000000010002000400050004000A000100000001000400010000000300020000000400000002000100020004000300050001000000000001000600050000000400020000000200060001000500010000000000000002000200000002000000010000000300010004000300040001000200010007000000020001000100050004000300020006000000010004000000000000000300010001000000000000000100030001000000010002000000070000000200020006000300030002000100010005000200020006000100000001000000010000000100030001000000020003000200000001000200040001000000020002000100000005000200030002000000000000000100020003000100020001000000020003000000010000000200000006000400000004000200040004000400010002000000010000000400"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[2, 0, 2, 0, 1, 3, 0], [3, 6, 6, 2, 2, 3, 2]]> : tensor<2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x03000200000001000100020002000200000002000000010003000000020000000700010005000600000000000300000003000100040001000200010003000400010003000200020003000000030000000100000003000000000002000000020000000200020000000000010002000400050004000A000100000001000400010000000300020000000400000002000100020004000300050001000000000001000600050000000400020000000200060001000500010000000000000002000200000002000000010000000300010004000300030006000600020002000300020001000100050004000300020006000000010004000000000000000300010001000000000000000100030001000000010002000000070000000200020006000300030002000100010005000200020006000100000001000000010000000100030001000000020003000200000001000200040001000000020002000100000005000200030002000000000000000100020003000100020001000000020003000000010000000200000006000400000004000200040004000400010002000000010000000400"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

