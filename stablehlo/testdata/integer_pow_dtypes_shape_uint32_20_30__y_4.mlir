// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui32>
    %1 = call @expected() : () -> tensor<20x30xui32>
    %2 = call @integer_pow(%0) : (tensor<20x30xui32>) -> tensor<20x30xui32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xui32>, tensor<20x30xui32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui32> {
    %0 = stablehlo.constant dense<"0x000000000200000002000000000000000300000007000000010000000100000000000000010000000000000002000000000000000100000000000000020000000A00000003000000050000000100000007000000050000000400000005000000010000000300000001000000030000000100000001000000030000000000000004000000030000000000000002000000000000000300000001000000010000000300000002000000000000000300000001000000020000000200000006000000030000000300000000000000010000000300000000000000020000000300000000000000000000000200000005000000000000000200000002000000020000000400000003000000000000000100000000000000050000000200000002000000010000000200000000000000020000000800000003000000020000000300000003000000000000000400000000000000000000000200000002000000020000000200000003000000050000000100000001000000020000000000000002000000000000000000000000000000030000000300000006000000000000000000000002000000020000000200000001000000010000000000000000000000010000000200000000000000030000000200000005000000020000000000000003000000020000000100000001000000000000000400000000000000040000000300000000000000010000000100000004000000000000000200000001000000000000000100000003000000030000000500000000000000010000000300000003000000040000000500000001000000010000000000000003000000030000000100000001000000000000000600000003000000040000000300000002000000020000000500000003000000000000000100000007000000030000000400000004000000020000000100000000000000050000000000000001000000040000000400000000000000000000000100000000000000010000000000000003000000040000000100000000000000000000000000000002000000000000000200000002000000020000000000000000000000030000000100000001000000020000000000000000000000030000000300000001000000020000000300000000000000040000000300000000000000000000000000000000000000000000000300000002000000060000000200000000000000010000000200000000000000000000000100000002000000000000000400000000000000010000000100000002000000000000000100000005000000040000000000000002000000010000000200000000000000010000000000000003000000020000000500000003000000000000000100000001000000050000000100000003000000010000000000000001000000020000000000000008000000050000000000000001000000000000000300000000000000000000000100000000000000020000000000000003000000010000000000000001000000020000000000000000000000000000000100000001000000000000000000000004000000010000000400000002000000030000000000000000000000000000000000000002000000000000000000000004000000020000000000000001000000060000000100000003000000000000000000000000000000020000000300000001000000000000000100000000000000010000000200000000000000040000000700000000000000020000000000000003000000010000000200000002000000030000000300000003000000030000000100000006000000000000000100000001000000010000000400000002000000000000000100000001000000030000000000000001000000040000000100000000000000010000000000000002000000020000000100000002000000010000000300000002000000000000000500000002000000010000000500000002000000010000000200000004000000030000000000000002000000010000000200000002000000000000000000000001000000000000000300000002000000000000000200000004000000000000000000000001000000010000000200000005000000040000000000000000000000010000000700000000000000010000000400000000000000020000000300000003000000030000000000000001000000010000000100000002000000000000000000000005000000040000000200000001000000010000000300000002000000000000000200000001000000040000000100000003000000010000000100000004000000020000000100000000000000000000000300000007000000030000000000000002000000020000000100000001000000040000000200000001000000050000000200000001000000030000000900000001000000010000000200000006000000030000000500000000000000010000000100000002000000010000000100000001000000060000000300000005000000020000000100000001000000020000000500000001000000050000000100000004000000010000000200000000000000000000000100000001000000020000000200000003000000040000000000000001000000010000000300000002000000000000000300000002000000040000000300000005000000000000000300000003000000000000000200000001000000000000000100000003000000030000000100000000000000000000000000000003000000000000000100000000000000040000000000000002000000030000000100000000000000020000000200000005000000030000000000000001000000030000000100000002000000000000000200000000000000030000000100000001000000000000000200000001000000010000000200000007000000010000000000000000000000030000000000000003000000010000000100000001000000000000000000000000000000040000000100000001000000030000000000000005000000030000000300000004000000070000000200000004000000010000000200000006000000020000000100000000000000060000000200000000000000010000000300000002000000020000000000000002000000010000000000000002000000020000000000000001000000020000000300000000000000020000000100000005000000010000000000000003000000040000000100000001000000000000000000000000000000030000000000000002000000010000000500000003000000030000000200000001000000040000000100000004000000"> : tensor<20x30xui32>
    return %0 : tensor<20x30xui32>
  }
  func.func private @expected() -> tensor<20x30xui32> {
    %0 = stablehlo.constant dense<"0x00000000100000001000000000000000510000006109000001000000010000000000000001000000000000001000000000000000010000000000000010000000102700005100000071020000010000006109000071020000000100007102000001000000510000000100000051000000010000000100000051000000000000000001000051000000000000001000000000000000510000000100000001000000510000001000000000000000510000000100000010000000100000001005000051000000510000000000000001000000510000000000000010000000510000000000000000000000100000007102000000000000100000001000000010000000000100005100000000000000010000000000000071020000100000001000000001000000100000000000000010000000001000005100000010000000510000005100000000000000000100000000000000000000100000001000000010000000100000005100000071020000010000000100000010000000000000001000000000000000000000000000000051000000510000001005000000000000000000001000000010000000100000000100000001000000000000000000000001000000100000000000000051000000100000007102000010000000000000005100000010000000010000000100000000000000000100000000000000010000510000000000000001000000010000000001000000000000100000000100000000000000010000005100000051000000710200000000000001000000510000005100000000010000710200000100000001000000000000005100000051000000010000000100000000000000100500005100000000010000510000001000000010000000710200005100000000000000010000006109000051000000000100000001000010000000010000000000000071020000000000000100000000010000000100000000000000000000010000000000000001000000000000005100000000010000010000000000000000000000000000001000000000000000100000001000000010000000000000000000000051000000010000000100000010000000000000000000000051000000510000000100000010000000510000000000000000010000510000000000000000000000000000000000000000000000510000001000000010050000100000000000000001000000100000000000000000000000010000001000000000000000000100000000000001000000010000001000000000000000010000007102000000010000000000001000000001000000100000000000000001000000000000005100000010000000710200005100000000000000010000000100000071020000010000005100000001000000000000000100000010000000000000000010000071020000000000000100000000000000510000000000000000000000010000000000000010000000000000005100000001000000000000000100000010000000000000000000000000000000010000000100000000000000000000000001000001000000000100001000000051000000000000000000000000000000000000001000000000000000000000000001000010000000000000000100000010050000010000005100000000000000000000000000000010000000510000000100000000000000010000000000000001000000100000000000000000010000610900000000000010000000000000005100000001000000100000001000000051000000510000005100000051000000010000001005000000000000010000000100000001000000000100001000000000000000010000000100000051000000000000000100000000010000010000000000000001000000000000001000000010000000010000001000000001000000510000001000000000000000710200001000000001000000710200001000000001000000100000000001000051000000000000001000000001000000100000001000000000000000000000000100000000000000510000001000000000000000100000000001000000000000000000000100000001000000100000007102000000010000000000000000000001000000610900000000000001000000000100000000000010000000510000005100000051000000000000000100000001000000010000001000000000000000000000007102000000010000100000000100000001000000510000001000000000000000100000000100000000010000010000005100000001000000010000000001000010000000010000000000000000000000510000006109000051000000000000001000000010000000010000000100000000010000100000000100000071020000100000000100000051000000A119000001000000010000001000000010050000510000007102000000000000010000000100000010000000010000000100000001000000100500005100000071020000100000000100000001000000100000007102000001000000710200000100000000010000010000001000000000000000000000000100000001000000100000001000000051000000000100000000000001000000010000005100000010000000000000005100000010000000000100005100000071020000000000005100000051000000000000001000000001000000000000000100000051000000510000000100000000000000000000000000000051000000000000000100000000000000000100000000000010000000510000000100000000000000100000001000000071020000510000000000000001000000510000000100000010000000000000001000000000000000510000000100000001000000000000001000000001000000010000001000000061090000010000000000000000000000510000000000000051000000010000000100000001000000000000000000000000000000000100000100000001000000510000000000000071020000510000005100000000010000610900001000000000010000010000001000000010050000100000000100000000000000100500001000000000000000010000005100000010000000100000000000000010000000010000000000000010000000100000000000000001000000100000005100000000000000100000000100000071020000010000000000000051000000000100000100000001000000000000000000000000000000510000000000000010000000010000007102000051000000510000001000000001000000000100000100000000010000"> : tensor<20x30xui32>
    return %0 : tensor<20x30xui32>
  }
  func.func private @integer_pow(%arg0: tensor<20x30xui32>) -> tensor<20x30xui32> {
    %0 = stablehlo.multiply %arg0, %arg0 : tensor<20x30xui32>
    %1 = stablehlo.multiply %0, %0 : tensor<20x30xui32>
    return %1 : tensor<20x30xui32>
  }
}
