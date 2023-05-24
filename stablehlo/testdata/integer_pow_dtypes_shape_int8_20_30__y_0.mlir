// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xi8>
    %1 = call @expected() : () -> tensor<20x30xi8>
    %2 = stablehlo.constant dense<1> : tensor<i8>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<i8>) -> tensor<20x30xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x30xi8>, tensor<20x30xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xi8> {
    %0 = stablehlo.constant dense<"0x0100020400FCFEFD0102020105FD0003000003FE020101FFFAFF0500000302020104FFFE00FF0100FF03FCFD000500FEFFFCFE0002FFFE040000FFFD06000305000001040000FEFF03FF02FE0301FBFFFC00FF0001FF050500FD0006FAFF0300FB00FCFE00FF0201FE01FB00000000FB0300FCFE020105FEFE00FD00FF00FFFCFF000101010000FDFFFE00FCFE020400FE00FE000603FD000002FBFF02010400FF02020305FF01FDFFFFFF03FD0100FCFDFCFF000204FB010103FD040200FE0003FD0300FFFDFF02F8FF000202030201FE020000FC02000005FDFEFFFD0101FF01FF0301FC00010100FDFF00FEFDFEFD00FEFF0001FF04FFFE030104010000000104000202FE0304FC0000FA0000FE06010000FF040100000100000002FEFF08FB00FB03040203F900FE00FE0004000003FDFE08FC0304FFFDFEFC0204FDFF0502FF000000FF04030102FEFFFEFEFEFAFC0005FA000004010000FE0000FC050000FFFAFFFD0006FFFF0504030AFF010200FE0001FE02FDFFFE01FE02FFFBFBFF0000FD01FBFDFDFDFEFD0000FF0102F800FF02010202010102000001FC0102FEFD00FCFFF9FDFC01030500FE00FEFE00010000FB010402000301FEFD07FD0202000000FE0002030103000102040104040001FD0100FE00000005010103FD0103FF0503FD000203FF02FF00FF0000000101FEFFFD0002FF01FE00FF00FC000300040105FCFF0202FFFE01FEFC00010201FC000003FE000202FD00FE00020201FF0004FC0300FF0400FF010002000201FE0100FC000000FEFE02010007000302FD00FF01FE030000030000FA01FFFDFC01FDFD01000500FC00"> : tensor<20x30xi8>
    return %0 : tensor<20x30xi8>
  }
  func.func private @expected() -> tensor<20x30xi8> {
    %0 = stablehlo.constant dense<1> : tensor<20x30xi8>
    return %0 : tensor<20x30xi8>
  }
}
