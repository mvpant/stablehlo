// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xi8>
    %1 = call @expected() : () -> tensor<20x30xi8>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xi8>
    %3 = stablehlo.multiply %0, %2 : tensor<20x30xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x30xi8>, tensor<20x30xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xi8> {
    %0 = stablehlo.constant dense<"0x02FF000001FFFD030201FF0004FDFD0300FF000201FEFD00040500010003030003FEFE0200FEFFFD00FEFDFD03FE02010400FDFDFD04FA00FF01FE00FD00FAFF00010301FCFC0201FE06000407FF00FE03FD0003FEFC03FEFEFE06FF01FDFF01FC01000101FEFEFAFF0005FB02F90306020A010301010001040003FE000201FBFFFB01020100FCFBFAF80101FC01FD01020000FD01010302FD020000FDFE00FFFAFFFC01FAFDFFFE04FE0303FF01FE00000101070000FFFCFCFFFE0004FD00030101FF0400FC0306FD0203FDFEFF000500FF000401FFFE00FC020003FC030000FD0105FF0201FB0001FE000000000101FD02020801FDFD010105FFFD000502FF04FE02FD0000F9030000020001FFFEFD0000030101FE0003FFFFFAFBFE02FD00010102030202020200FEFF0003FF010101FDFF02040200FCFCFFFE050000020102FD02FE00FEFFFC07FF03FF020301040003FFFF0001FC000200FEFF0103FFFDFB0002010002020000FF0003FEFE020400010300FE06FEFEFE00FD00010000FDFCFE03010603FD0006FE000002FFFEFE0000FC00FC00FDFF02000600FA05FD00FB03FFFDFB0305FDFFFF00FF00FD040201FB0301FFFD0104FAFF00FEFFFE04FE000503020001010406000400000400010000FFFE01F800FE0101FD00FF0200FEFF010100FE00FF00050301FB0500050300FC00FEFFFBFF00FF01000108040000FE0002FFFBFFFD00FF00FEFF00020200030201000100020403FFFF00FE0200FD050003FE02FE02FF02FE020003FC0200FCFAFE020404FCFCFC00FE0300030406FF0000FB0500FFFFFEFFFD00FDFE0006000200F8000202FF"> : tensor<20x30xi8>
    return %0 : tensor<20x30xi8>
  }
  func.func private @expected() -> tensor<20x30xi8> {
    %0 = stablehlo.constant dense<"0x08FF000001FFE51B0801FF0040E5E51B00FF000801F8E500407D0001001B1B001BF8F80800F8FFE500F8E5E51BF808014000E5E5E5402800FF01F800E50028FF00011B01C0C00801F8D8004057FF00F81BE5001BF8C01BF8F8F8D8FF01E5FF01C001000101F8F828FF007D8308A91BD808E8011B0101000140001BF800080183FF8301080100C08328000101C001E501080000E501011B08E5080000E5F800FF28FFC00128E5FFF840F81B1BFF01F800000101570000FFC0C0FFF80040E5001B0101FF4000C01BD8E5081BE5F8FF007D00FF004001FFF800C008001BC01B0000E5017DFF0801830001F8000000000101E508080001E5E501017DFFE5007D08FF40F808E50000A91B0000080001FFF8E500001B0101F8001BFFFF2883F808E5000101081B0808080800F8FF001BFF010101E5FF08400800C0C0FFF87D0000080108E508F800F8FFC057FF1BFF081B0140001BFFFF0001C0000800F8FF011BFFE5830008010008080000FF001BF8F8084000011B00F8D8F8F8F800E500010000E5C0F81B01D81BE500D8F8000008FFF8F80000C000C000E5FF0800D800287DE500831BFFE5831B7DE5FFFF00FF00E5400801831B01FFE5014028FF00F8FFF840F8007D1B0800010140D8004000004000010000FFF8010000F80101E500FF0800F8FF010100F800FF007D1B01837D007D1B00C000F8FF83FF00FF01000100400000F80008FF83FFE500FF00F8FF000808001B080100010008401BFFFF00F80800E57D001BF808F808FF08F808001BC00800C028F8084040C0C0C000F81B001B40D8FF0000837D00FFFFF8FFE500E5F800D800080000000808FF"> : tensor<20x30xi8>
    return %0 : tensor<20x30xi8>
  }
}
