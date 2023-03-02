// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi8>, tensor<20x20xi8>)
    %1 = call @expected() : () -> tensor<20x20xi8>
    %2 = stablehlo.minimum %0#0, %0#1 : tensor<20x20xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi8>, tensor<20x20xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi8>, tensor<20x20xi8>) {
    %0 = stablehlo.constant dense<"0x00FF0000FF00050600FF00FEFEFF01FE04FCFDFFFDFE02FD05FB0101FCFE000300020000000002000000FFFF02050205FEFCFE0602FFFDFEFE00FF020001FDFD040501000001010001030300FF00010003000701FD010303FF0004FF000200FC04FD02FFFDFE02FDFDFE0001FE01FF000301FE0000FD000000FCFF00FC0002FE02FF02FEFE0300FE02070100FBFFFF0200FF010101FDFF0007FE03FE00FF00FE0003FD01FA01FDFD00FE0100F9FDFDFFFEFEFE00000001030000FDFB01010008FE0100FFFDFE00FE00FF02000002FE00FD00FEFFFE0000FE00FB010201FFFF00FE04FD010002000001FFFF04F900020602FE06020200FFFE00FEFC00FF0403FC020001FC01040101000000FD0200FD0002FFFEFC00FDFCFFFF02000002FF000302FB00010000FF01050003000002FDFE0302FEFFFC0301040203010100000001FE020105FE010000000003FFFB00FF00FD01FF0300FE02000504FCFF04FDFE03060102FF0204FE0600030100010000FB000000050105FDFB00FE01FE070000FD000100FF00FF0000FFFF00FC01010004"> : tensor<20x20xi8>
    %1 = stablehlo.constant dense<"0xFE000600FE01010001FD0101FF000300FFFF00FF01FFFD03FFFF01000300FF01FA0202FFFC00FF03FB0000FD02FEFB02FEFF010101000004070304FC02FDFC00FCFF01000200FEFFFF05FD030204000000FFFCFF00000000FBFEFB02FC01FB0502000003FE01FD01FCFEFC00040001FF0000FD0000FAFE01FE01020001FD03FF04FDFB02000300FD03020000FEFD000000FCFFFE000000FD01FE01FF000102FFFE01000401FA030000FBFF00FDFFFD0102FC02000100FAFF030000FB03FDFF02FFFF02FC05020200FE030202FF0400FD0006FF00FD02FD00020000000305FFFCFE010002FEFD0401060301FF02040001000300FEFF010002FFFFFCFFFAFD000203FFFC00FFFEFF00FF010000000400FE000306FD010004010000FC03FE0004F9FFFCFC040002FF020100FF0100FA000200FE0703FF02FA0402FDFEFAFCFE01FFFFFCFF00FD00000206FD01FC000304070101FE01FE00FF0600000000FC00F903FF00FEFFFD0001FB030102000204FE03000000FF00000000000102FD0001FD010001FF00FFFFFBFD05FE02F903040203"> : tensor<20x20xi8>
    return %0, %1 : tensor<20x20xi8>, tensor<20x20xi8>
  }
  func.func private @expected() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0xFEFF0000FE00010000FD00FEFEFF01FEFFFCFDFFFDFEFDFDFFFB0100FCFEFF01FA0200FFFC00FF00FB00FFFD02FEFB02FEFCFE0101FFFDFEFE00FFFC00FDFCFDFCFF01000000FEFFFF03FD00FF00000000FFFCFFFD000000FBFEFBFFFC01FBFC02FD00FFFDFEFDFDFCFEFC00FE00FFFF0000FD0000FAFE00FEFCFF00FCFD02FE02FDFBFEFE0300FD02020000FBFDFF0000FCFFFE00FDFFFD01FE01FE00FF00FEFE01FD01FAFAFDFD00FBFF00F9FDFDFFFEFCFE000000FAFF0000FDFB01FDFF02FEFF00FCFDFE00FEFEFF0200FF02FEFDFD00FEFFFD00FDFE00FB000001FFFFFCFE01FD01FEFD000001FFFFFFF900000100FE00FEFF00FFFEFFFEFCFFFAFD00FC02FFFCFCFFFEFF00FF0000FD0000FDFE00FFFEFC00FDFCFFFF00FC00FEFF00F9FFFBFC010000FF010100FF0000FAFDFE00FEFEFFFC02FA0402FDFEFAFCFE00FFFEFCFF00FD00000000FD01FCFB00FF00FD01FE01FEFEFF000000FCFFFCFDF903FF00FEFFFD00FEFB000101000100FEFB000000FF0000FDFB00FE01FD0000FDFD0001FFFFFFFFFBFDFFFE00F901010003"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
}
