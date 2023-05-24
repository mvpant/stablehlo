// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.convert %0 : (tensor<20x20xbf16>) -> tensor<20x20xf32>
    %3 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %4 = stablehlo.constant dense<-0.693147182> : tensor<20x20xf32>
    %5 = stablehlo.add %2, %4 : tensor<20x20xf32>
    %6 = stablehlo.exponential %5 : tensor<20x20xf32>
    %7 = stablehlo.subtract %4, %2 : tensor<20x20xf32>
    %8 = stablehlo.exponential %7 : tensor<20x20xf32>
    %9 = stablehlo.subtract %6, %8 : tensor<20x20xf32>
    %10 = stablehlo.exponential_minus_one %2 : tensor<20x20xf32>
    %11 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf32>
    %12 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %13 = stablehlo.add %10, %11 : tensor<20x20xf32>
    %14 = stablehlo.divide %10, %13 : tensor<20x20xf32>
    %15 = stablehlo.add %10, %14 : tensor<20x20xf32>
    %16 = stablehlo.multiply %12, %15 : tensor<20x20xf32>
    %17 = stablehlo.abs %2 : tensor<20x20xf32>
    %18 = stablehlo.compare  LT, %17, %11 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %19 = stablehlo.select %18, %16, %9 : tensor<20x20xi1>, tensor<20x20xf32>
    %20 = stablehlo.convert %19 : (tensor<20x20xf32>) -> tensor<20x20xbf16>
    %21 = stablehlo.custom_call @check.eq(%20, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %21 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xE53E41BF95BF3E4080C06DBF3F4012BE884013C0BF3F19C025C08C4080C0204094401CBFBC3E35BF80BF8A407ABE73BF56403640064005BF28BFE2BF2E4085BF7D3FE2BE80C01DC045BFB540E4BEAE3FCBBEEC3F80C0E0BCC8BFF73F52C098C022409A3F72C0A7C0D13F2FBF3E3F3640FF3FE8BFE3BF3CC0AC3FB73E744079409B4044C08240F2BFDEBF2D40D63F8C4053C010C008C0D1BFDBBF16C0A1402DC00DBF1340A34045C05F40ECBD32C07E3F2F4043409C40143FA3C06DBFA7BF98406EBF8EBEEC3F6ABF023FACBFE13FC93E5AC0B6405B40373F5F4072BFBB3F9240ACC09FC07DBE423E46BFD5C0213E1440B5BF4640B43F9FBFC140B5BF44405140C13F47BF2A3F5DBF4DBF14C08E3ECDC09DBDE03FB940E8BFD5402940E8C0BC3F22C080C007BF87BF8BBFF7C04EC0F8BF473FB8C03CC0EB3FAABF6E402140203FD7BFF73F8FC07DC04EBE3F3F8ABE25409C3FA6BF2E40603FE4C07CBF1DBF2B40B13F6240CD3F4AC00640A43F94BF10C0E8BFF23F2E4060BF9D40A1C0134139BE86C033C0333D19C0144085BFA640D6BF843F92C0A43FAF3E903F9DBF0240BBC011C03A3F7AC013402EC08FBFEDBFF1BE813F963F0EC069BE4FC0D9BFCABFEA3F0BC0A13F9DBD65BF55C0C34059C0ADBF32C08D3EA03F81BF993DDDC0754057408DBF46BE42C0D3BF1D40C8BF2A3DEDBEB04018C081C028BE27BFB0C0EEBF763F8E3F16BD71C0484089BF3E3FD1C0693F15BF5340E03FC13F4240F1BFB34008BE4BBF4C3F3DC0D73E2EC08E4089C0CBBFAC3FF43F2EC09BC07A3E9DBF6E407140FBBF1C407EC00B40DA4026C06EBE19409440204017C066403BBFD5C046BF12C0B6401D3C1D3F8FBF56C085C07C3F453E1A407D4055C0FC3F9340703FE3BF174042BEB33C2AC04EBE9A4013403C404340FF40923F9D3F04C011C0E33F25C08040C0402EC0C43F15C041C0D740B0BFAEBFAD4047405B3D25BFE5C00C402940A53F96C0ACC0C0BF544046C0BE3EFD3F583F01C0323F7140F03F9D3F94408ABFA8BE22C07CBE91C05F406740EFBE1B408ABF3EBF31C07E3F64BEA23F35C0EBC003418F40A1C0B140633FBBBFCE3F99C067BE56BE823FF8BD003F0C40853FEC3E0441"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xED3E54BFB9BF1B41DAC188BF1E4112BE0C429DC00740ADC0D2C01F42DAC1C2404C4226BFC03E44BF96BF15427CBE8DBF6241094180400BBF34BF36C0F2409EBF943FE9BEDAC1B9C059BF0F43ECBEE93FD0BE4540DAC1E0BC12C0584055C167C2C840C23FAFC1B9C21E403DBF503F094166403FC037C017C1E53FBB3EB541C4417E422BC1E8414FC030C0EE4024401F4258C196C084C01EC02BC0A5C09942EEC014BF9D40A3422DC18241EDBD01C1953FF540284183421C3FA3C288BFDBBF674289BF90BE454086BF083FE5BF3440CE3E71C114437541473F82418CBF02404042D8C290C280BE433E5ABFC2C3223EA040F8BF3041F53FCBBF5043F8BF2B41514109405CBF373F79BF64BFA0C0903E97C39DBD334022433FC0C243DF4030C40440C8C0DAC10DBFA1BFA8BF8DC448C15AC05C3F1DC317C14440E1BFA541C5402B3F26C058402EC2D0C14FBE513F8CBED240C63FD9BFF2407E3F1BC493BF27BFE640EF3F894118403CC18040D53FB7BF96C03FC04F40F2407EBF874299C299453ABE04C203C1333DADC0A0409EBFB34224C09D3F40C2D53FB23EB03FC7BF70402DC399C04B3FC7C19D40F2C0AFBF47C0FABE983FBB3F91C06BBE4BC128C014C042408BC0CF3F9DBD82BF5FC15E436DC1E7BF01C18F3ECD3F98BF993DFAC3B8416641ABBF47BE25C120C0B94012C02A3DF6BEF542ABC0E1C129BE33BFF5C248C08F3FAD3F16BDADC13641A5BF503FACC3853F1EBF58413340094025414DC0064308BE61BF623F19C1DD3EF2C0294211C216C0E53F5340F2C07EC27C3EC7BFA541AD415FC0B640D4C18B40E343D5C070BEAD404C42C240A8C091414CBFC2C35ABF9BC014431D3C273FAFBF62C1FFC1933F463EB040D0415FC1614046428A3F37C0A84043BEB33CE3C04FBE76429D4017412841B544B43FC73F78C099C03740D2C0DA414A43F2C00D40A3C023C1CF43EDBFE9BFDF4233415B3D31BF20C48D40DF40D73F59C2D8C208C05B4130C1C23E6340733F6CC0413FAD414C40C73F4C42A6BFABBEC8C07FBE3AC282419441F8BEB340A6BF50BFFDC0953F66BED13F07C141C4E1442E4299C2FC42813F02C01A406EC269BE58BE9A3FF9BD053F8D409E3FF43EEF44"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}

