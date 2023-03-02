// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x1xi32>, tensor<5x2x2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>) {
    %0 = stablehlo.constant dense<"0x000009000500050002000200000003000200020001000000050003000000060000000200010000000100030000000000010004000200000004000400010001000200030002000300010008000100000000000100060001000300010001000200000003000000010003000400040003000100000001000300000002000100000002000000010000000200030000000400010000000100000001000100000000000000010000000100000001000200010002000400010003000200070007000200020000000000000001000400020006000300000001000200000005000400000001000600010005000200010005000000010004000200040000000700080006000100010002000100010001000200010002000100000003000500040003000400000004000100000000000000000000000600020007000400040005000000040001000400020005000400010004000000000000000000020004000100040001000000040002000300040002000800040000000400040005000000040001000100030003000400020002000100020002000500000001000000000001000400000004000300"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<"0x00000100010004000200020001000600010000000000040001000000010005000100020001000300040000000600000002000800010000000000010000000000060000000000000003000200030002000300050002000400020003000400020003000000010006000000030002000000000000000300010000000000000000000200030001000200010001000100030002000200010002000300000002000500000003000600060002000200000000000100010001000200010002000100010002000000000004000000030004000300010001000100020003000400000000000200030002000100000003000200000003000300040002000000040000000100020003000000020001000200020002000000020001000600"> : tensor<5x2x2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x0000090005001400040004000000120002000000000000000500000000001E00000004000100000004000000000000000200200002000000040004000100010002000300020003000100080001000000000001000000010000000000060000000000000000000200090008000C000F00020000000200090000000400030000000200000000000000040000000000040001000000010000000100010000000000000001000000010000000000060001000000000000000000040015000700040002000000000000000200080002000C000900000002000A0000000F00180000000100060001000500020001000500000001000400020004000000070010000C000000000002000100010002000200020002000100000000000000100000000C0000000C0001000000000000000000000000000000070004000400050000000400010004000200050004000100040000000000000000000200000003000800000000000C0008000600000008000000040000000C0000000A0000000800020002000000060004000C0002000100020002000500000001000000000001000400000004000300"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

