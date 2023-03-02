// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>)
    %2 = call @expected() : () -> tensor<3x5x40xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui8>, tensor<2x1xi32>, tensor<3x5x2xui8>) -> tensor<3x5x40xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui8>, tensor<3x5x40xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>) {
    %0 = stablehlo.constant dense<"0x040000040701030001000800050000000401000006030604010002040501000202040306000000000307000201020003030200040406000100020000010100000003010603050003000303040302000105020302000200000204040300000003000102000001000203060202010405030000000100020101010200000100020001000000000300030104000107010001000201020501010300040103020007000300050301020302030200000500050001020400010200020102010201000101050604070603000104000202000401000000030101010303040501030109010104020402010204030306030403020000040500030101030002020005000600000004020000010404030102030201040100000002010005000203020400030000020202000100030000010300000103040202000303000B03040000000301060001030101000200000002040500000104000208010001000900020000000001010001040202020100000100020001000300080302010005000001040002020102010001010007050000010307000202000100020001000400050506000001030100020104000102010202040100000202040104030102020201010200010100000101010102000201000301000101020102010000030005050002020201020102030200020703000203000205000200030302020201030201000203010004020200020000000300060204010102020406020005000100000401000104010003000701030000020402030300020803020101020001020000020204040204000900070203030102010101010001020200010003040102000102"> : tensor<3x5x40xui8>
    %1 = stablehlo.constant dense<[[[2, 2], [1, 0], [0, 1], [3, 5], [4, 1]], [[4, 4], [3, 1], [1, 3], [1, 1], [1, 0]], [[0, 4], [1, 1], [2, 0], [4, 4], [0, 0]]]> : tensor<3x5x2xui8>
    return %0, %1 : tensor<3x5x40xui8>, tensor<3x5x2xui8>
  }
  func.func private @expected() -> tensor<3x5x40xui8> {
    %0 = stablehlo.constant dense<"0x040000040701030001000800050000000401000006030604010002040501000202040306000000000300000201020003030200040406000100020000010100000003010603050003000303040302000105000302000200000204040300000003000102000001000203060202010405030000000100020101010200000100020001000000000300030104000107010001000201020501010300040103020007000300050301020302030200000500050001020400010200020102010201000101050604070603000104000202000401000000030101010303040501030109010104020402010204030306030403020000040100030101030002020005000600000004020000010404030102030201040100000002010005000201020400030000020202000100030000010300000103040202000303000B03040000000301060001010101000200000002040500000104000208010001000900020000000001010001040202020100000000020001000300080302010005000001040002020102010001010007050000010307000202000100020001000400050506000001030100020104000102010202040100000202040104030102020201010200010100000101010102000201000301000101020102010000030005050002020201020102030000020703000203000205000200030302020201030201000203010004020200020000000300060204010102020406020005000100000401000104010003000701030000020402030300020803020101000001020000020204040204000900070203030102010101010001020200010003040102000102"> : tensor<3x5x40xui8>
    return %0 : tensor<3x5x40xui8>
  }
}

