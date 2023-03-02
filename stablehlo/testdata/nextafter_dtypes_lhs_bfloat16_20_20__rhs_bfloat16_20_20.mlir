// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xbf16>, tensor<20x20xbf16>)
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.bitcast_convert %0#0 : (tensor<20x20xbf16>) -> tensor<20x20xi16>
    %3 = stablehlo.bitcast_convert %0#1 : (tensor<20x20xbf16>) -> tensor<20x20xi16>
    %4 = stablehlo.compare  NE, %0#0, %0#0 : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<20x20xi1>
    %5 = stablehlo.compare  NE, %0#1, %0#1 : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<20x20xi1>
    %6 = stablehlo.or %4, %5 : tensor<20x20xi1>
    %7 = stablehlo.constant dense<0x7FC0> : tensor<20x20xbf16>
    %8 = stablehlo.bitcast_convert %7 : (tensor<20x20xbf16>) -> tensor<20x20xi16>
    %9 = stablehlo.constant dense<-32768> : tensor<20x20xi16>
    %10 = stablehlo.constant dense<32767> : tensor<20x20xi16>
    %11 = stablehlo.and %2, %10 : tensor<20x20xi16>
    %12 = stablehlo.and %3, %10 : tensor<20x20xi16>
    %13 = stablehlo.compare  EQ, %0#0, %0#1 : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<20x20xi1>
    %14 = stablehlo.constant dense<0> : tensor<20x20xi16>
    %15 = stablehlo.compare  EQ, %11, %14 : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<20x20xi1>
    %16 = stablehlo.compare  EQ, %12, %14 : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<20x20xi1>
    %17 = stablehlo.and %2, %9 : tensor<20x20xi16>
    %18 = stablehlo.and %3, %9 : tensor<20x20xi16>
    %19 = stablehlo.constant dense<1> : tensor<20x20xi16>
    %20 = stablehlo.or %18, %19 : tensor<20x20xi16>
    %21 = stablehlo.compare  NE, %17, %18 : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<20x20xi1>
    %22 = stablehlo.compare  GT, %11, %12 : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<20x20xi1>
    %23 = stablehlo.or %22, %21 : tensor<20x20xi1>
    %24 = stablehlo.constant dense<-1> : tensor<20x20xi16>
    %25 = stablehlo.select %23, %24, %19 : tensor<20x20xi1>, tensor<20x20xi16>
    %26 = stablehlo.add %2, %25 : tensor<20x20xi16>
    %27 = stablehlo.select %16, %3, %20 : tensor<20x20xi1>, tensor<20x20xi16>
    %28 = stablehlo.select %15, %27, %26 : tensor<20x20xi1>, tensor<20x20xi16>
    %29 = stablehlo.select %13, %3, %28 : tensor<20x20xi1>, tensor<20x20xi16>
    %30 = stablehlo.select %6, %8, %29 : tensor<20x20xi1>, tensor<20x20xi16>
    %31 = stablehlo.bitcast_convert %30 : (tensor<20x20xi16>) -> tensor<20x20xbf16>
    %32 = stablehlo.custom_call @check.eq(%31, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %32 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xbf16>, tensor<20x20xbf16>) {
    %0 = stablehlo.constant dense<"0x80C0A93FD03F963EC3C0733FF1BF103F2C40B23F46C0A13F2BBFCCC0A9BF2AC05EC0F53D93402FBC893FC7BE45C08D3F07C11D40D8BEF6BF17C0973E00403340283F86404CC0733FD6BFA43F2A40B43F3E40DDBE034022BFE4BFB1BE5BC003C02DC0993F5ABF6940E4BFB7BF01BFA340EB40ED3E84406EBF92C0784035C0D73F72C089C068400140FB3F053F58C00A4088BE953F5E3E6B407E40203D69C04EC0764075401840593E74BE03C0B4405F40AC3F2940E73F30404CC07BC014C088C09040A93FAEBFFABF84C04C3EDFBF36BFD8C0B54016409DC0603F4FBF53BEB2BD6D40473FDD40BEC0B4BF9140A2404FBF00BF5AC0973F68C0AB3F66C022C0A03F03405BBFA43DE8BF483F923D104023C075BFE8BF91C084408EC05D40694010C0EB3D3BC05540B3BF97BFDA3EA1BF66C07940FD3E514005C0BBBF72C0E93F0440933F983EBEBEB03E0E40073F04C01CC00D404BC0254098403A40A83F5FBF67BE244092C0073F14BFA0BF72BD7A3FEF3E5FBFB64059400BC072409C3F37402CC0FABEB2BF3DC04D4040C0CEBEE33EB8BF0F3F26C035C003C059C0AA3F81C08B3F574001409B3F9FBFA2C0D3406640083DC53F55C069C0F0BF7B3E42BF5DBD063F953F11C09EBE923F0EC0573F16C0574089406BC039BF17403840D13EA1403EC0574024C0D1BF433FBC3E06C00FC09BBEC8BF1F40FA40BC40AD40B73FAB3FB3BFB93F95BBDCBF2940B4C089C0BABF3B3E16C09E3F21BF68C06E3F0A409040C93E21C0E23EFABE524008C0BBC07C4056406640C9C09CBFF340DEBEAAC0353FC53F3DC0F53FA6BDA13FD7BF8CBF2C407CC0704073409E404A3F8CBF324043BEDC3F664002C0923F25BF8DC09B400CC02540BAC018C02FC06E40D0BF8EC03740C2C0F73D8A409F3F9BBE05C06C40D13F01C031BFBE3F1BBE9CBFBF3F29409ABFCEBE3B3F9C3F0DC09DBF30C097BF10BD81C08EBF17C083C0A8BD9DBF0141BD3F3BBFDCBE22BE6BBFA64027C037C0D940B3C027408F3FB740FB3F09C085BFB3BFE63F783EF8BFF43F34C081406DBFE0BE89C0CB3F03401140873FA4BFD23F3540DEBF6240DFBF67C016BF59C0833D0A3F0D4035C0F93D25BFB1BF933F524015BEA9BF"> : tensor<20x20xbf16>
    %1 = stablehlo.constant dense<"0x6D3F5AC091BFA240444051409DBFCEBE94C04AC0B93FE83F08BF673FF93F88C01D3E63C03C3FBB3F4B40D4BF0B4004C0833FA83F17C02D3F23404A40CD3F6F40EABE0A40C5402640263EEABEC240ABC0BC4002C051C03340C0BE37401B40C03ED44066C02B40C3BF2B3E23408EBF8E4075C045C020BFC53FA83F3840EB3FAE4011C0D040F8BD22C09B3F5640B4BF0D4040C0B23FCA3F31BFAEC04640BBBE593F113F93C0CF3FCA402D402FBF43C004C018C0563F873E6840D83D00C05CC0AC403040BD406340CCBE413F8DBE38C00FBF3F3FCE3F5ABE16BFC0BF9FC00F4078405ABDD2BFB5BF5CC0F3BD4B3F463F87BFACBF3BC031C08EC00CC0FEBF53C0683FA44031402B40A4C097BF943F78BFCC3FC83E6EBFFF3FC43E204091BF8CC0E23EE33F96407CBEBE3E3E400C40A1BB0840E13EB1C04EC05DC08C3FC640AC3F8A3F084006402D3F873ED24022BF514099BFAEBF5AC09BBEA5BEC4BEB03F7040BA3FB9C03A3F06C098C07E3ECBBEC63ECD3FCA3E2AC08540114059409FBF2FC018C031409A402FC08BC029C0C8BF04C041BFB4BFDABEF5BFD23FC1BF2FBEA1C0DF3FBE3F4E40C3C097C083C02C40C43FAAC0734073C05C40774088BF0840EE3E3140A5C03140CCBF12C098C04DC0FA3F5CC0EABFFDBFC1BF74C0973F48402ABF1A3E3CBE8A40E53F8BBF0641B5C029407FBEF73F5DC0A4BFBFBFDA3F68C087C02CC0A3BF904087BFF83C1040FA3DF33F93C011BE8EC0A2C0384051BF3D4097C087409C3F41BF29C09B3E8FC0B3C0BE4051409BC0904005C0773DB1BE0DC02AC0DDBFDA3F1C40FB3F66C030C0F0BC3B40D4BF293CFABE60C066C0E13F33C0E0BF84BE313F8F4088BE253F97BC9D40E23F213F4E3F83BFA33FEEBF60BEEAC087BFE1C052BFAEC0B03FE33F0FBFDF3E12400740ECBF27C1373F8D3F9240A04047BF983FDC3FD23DE33E17BFA2C0003F26BF043EE2BFFABFE63F6EBEC03FB43FBDBF2F4082C0F5BD644006403D400F40E3BFADBF15C094BF54BFB7402EC04440E6BF8FBDFC3F083FDEBFA83FB6C0ECBF593E4A3F8ABFCD3E6CBF8B3F64BE6B4006C02B40C540CE3F204099401A402C3F0040D93D2BBFB4C0C53F1B3F0A402340BEC081BC"> : tensor<20x20xbf16>
    return %0, %1 : tensor<20x20xbf16>, tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x7FC0A83FCF3F973EC2C0743FF0BF0F3F2B40B13F45C0A23F2ABFCBC0A8BF2BC05DC0F43D92402EBC8A3FC8BE44C08C3F06C11C40D9BEF5BF16C0983EFF3F3440273F85404BC0743FD5BFA33F2B40B33F3F40DEBE024021BFE3BFB0BE5AC002C02CC0983F59BF6840E3BFB6BF02BFA240EA40EC3E83406DBF91C0774034C0D83F71C088C067400040FA3F063F57C00B4089BE963F5F3E6A407D40213D68C04DC07540744017405A3E73BE02C0B3405E40AB3F2840E63F31404BC07AC015C087C08F40AA3FADBFF9BF83C04B3EE0BF35BFD7C0B44015409CC05F3F50BF52BEB1BD6C40463FDC40BDC0B3BF9040A14050BF01BF59C0963F69C0AA3F65C023C09F3F04405ABFA53DE9BF473F933D0F4022C074BFE7BF90C083408DC05C4068400FC0EC3D3AC05440B2BF96BFDB3EA0BF65C07840FC3E504006C0BABF71C0E83F0340943F993EBDBEAF3E0F40063F03C01BC00C404CC0244097403940A93F5EBF66BE234091C0063F15BF9FBF73BD793FF03E5EBFB5405A400AC071409B3F36402BC0F9BEB1BF3CC04C403FC0CFBEE23EB7BF0E3F25C034C002C058C0A93F82C08C3F564002409A3FA0BFA1C0D2406540073DC63F56C068C0EFBF7A3E41BF5CBD073F943F10C09FBE913F0FC0563F15C0564088406AC03ABF16403740D23EA0403DC0564023C0D0BF423FBD3E07C00EC09ABEC7BF1E40F940BB40AC40B63FAA3FB4BFB83F94BBDBBF2840B3C088C0B9BF3A3E15C09D3F22BF67C06D3F0B408F40CA3E20C0E13EFBBE514009C0BAC07D4055406540C8C09DBFF240DDBEA9C0343FC43F3CC0F63FA5BDA03FD8BF8BBF2D407BC06F4072409D40493F8BBF314044BEDB3F654001C0913F24BF8CC09C400BC02440B9C017C02EC06D40CFBF8FC03640C3C0F63D8940A03F9ABE04C06B40D23F00C032BFBD3F1ABE9BBFC03F2A4099BFCDBE3C3F9B3F0CC09CBF31C096BF11BD80C08FBF16C082C0A9BD9CBF0041BC3F3ABFDDBE21BE6ABFA54026C036C0D840B2C026408E3FB640FC3F0AC084BFB4BFE53F793EF7BFF33F33C080406EBFDFBE88C0CA3F02401040883FA3BFD33F3440DDBF6340DEBF66C015BF58C0843D0B3F0C4034C0F83D24BFB0BF943F514016BEA8BF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}

