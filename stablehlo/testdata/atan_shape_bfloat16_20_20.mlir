// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xbf16>
    %3 = stablehlo.atan2 %0, %2 : tensor<20x20xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x8A4074BF61C0803FCC3FD64037408EC047C0124037C0893FD8BF9940A6404040C53E2140A0C0AC408B4047C0EC3F89BF37405AC0BCBD0B407E3E17C07D40FA3FCCBF73404FC0A0BEF4401E4035BF76C048C0C2BFAD4090BF43403A40F6BFB43F01BF84C03B403AC0784061C00A4097405740613F1D4011C0FFBF49C010BF8C40D9BF9D3F10C04C3F7440DDBD85C01EC09EC01640BC3F1BBF04C03A407A3FF13F2FBF593E0BC0AFC0304049C005C0054068BFBAC05E3EDC3FCD3FD2BFD73F0940DABFF8BF2B4009C0DC3DD13FC2C0463EB2C0C440BB3E2E4016BE97BEA9BFB6BFE3BF1E40ABBF27C0D33FF73D04C09FC0E2BF51BFFD3D393F163F8FC05240193F364041406FBF5940623FDCBFBCBFFCBF1DC03EC022C07C40E13D4D407C408A3E7AC090BE95C0BCBFA13F66BE093E63C0B8404D402F3F34BFBF4095C0CEBF953FBF3F0140CEBF8A405FC092404F401940A43DCD404D3F10BFA6BE223DA63F09C0AEBF694050BF1DC0E23F91BF973F81BF844091BF2EC044C049406140393FD5BEDB3EF3BE07C02540A8BFA7402C4024C0D0BF35C063BF34C054BE834096C039C0473F4CC019C09F3F753F25404E40E73ED54009C0B1BF8EC015BFAC40254040C0424040C09ABF503EA5C0DB3F4DBF12C0ED3FC6BFA8C0833F1940F6BE4ABD6E40694026C099C0F1BFC83F84BF16C069BE68C03F400E40CE40703FD540E73D673F97C0203E15C08BC08C408BBFB63FDD3FB53FFDBEB33F93C048BF90BF983F5F40473FA1BFCBBE17C0723FA4C057401440BFBF743F7840C63F00C13DC0283FFABF5FC01ABF82BFE8C06D3F2740C3403BC0E83CE2BF2AC0CF3EB6C0DABF07401340B0BFD8BEE2C090C09FBF9A409ABF7ABF81C00EC08740454043BF914037C004C0514065403E3F153EB93F9EBFCE40463ED43D9A3EEEBDA9BE4FC02DBF053F314001404C3FC33FDE40994006C0F23E443F90409F3BE7BFC640DDBF75BF6540B53FC1BFA4BF91C08B3FB13F1F40D8BEE3BF1F40634002C0253FDF3FA8C0724053BFB7BF2E3F73BD1C3F3D4096C013C02B4009417840B94043C098C09F40D6BFACBDA340C7C022C043C0FE3E3FC029BFDDBE54C07A3E11408ABFD0BF2A40874094C0"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xAC3F43BFA6BF493F813FB63F9E3FADBFA1BF943F9EBF523F85BFAF3FB13FA03FBC3E993FB0BFB23FAC3FA1BF893F52BF9E3FA5BFBBBD923F793E96BFA93F8C3F81BFA83FA3BF9BBEB83F983F1EBFA8BFA1BF7DBFB23F58BFA03F9F3F8CBF743FEFBEABBF9F3F9FBFA93FA6BF913FAE3FA43F393F983F94BF8EBFA2BF03BFAC3F85BF633F94BF2C3FA83FDCBDABBF98BFAFBF953F793F0BBF8FBF9F3F463F8B3F1ABF563E92BFB2BF9C3FA2BF90BF903F3CBFB3BF5B3E863F823F83BF843F913F85BF8CBF9B3F91BFDB3D833FB4BF443EB2BFB43FB33E9C3F15BE93BE6CBF75BF87BF983F6EBF9ABF833FF63D8FBFB0BF87BF2FBFFC3D203F083FADBFA33F0A3F9E3FA03F40BFA43F393F86BF79BF8DBF98BF9FBF99BFA93FE03DA23FA93F873EA9BF8CBEAEBF79BF663F62BE083EA6BFB33FA23F1A3F1DBFB43FAEBF82BF5C3F7B3F8E3F82BFAC3FA5BFAD3FA33F963FA43DB53F2D3F03BFA1BE223D6A3F91BF70BFA73F2FBF98BF873F59BF5E3F4ABFAB3F59BF9CBFA1BFA23FA63F203FCABECF3EE3BE90BF9A3F6BBFB13F9B3F99BF82BF9EBF3ABF9DBF51BEAA3FAEBF9EBF293FA2BF96BF653F433F9A3FA33FD93EB63F91BF72BFADBF07BFB23F9A3FA0BFA03FA0BF61BF4D3EB1BF853F2DBF94BF8A3F7FBFB1BF4C3F963FE5BE4ABDA73FA73F9ABFAFBF8BBF803F4DBF95BF65BEA7BFA03F933FB53F413FB63FE63D3C3FAEBF1F3E95BFACBFAC3F54BF753F863F753FEBBE733FAEBF2ABF58BF5F3FA53F293F66BFC1BE96BF423FB0BFA43F953F7BBF433FA93F7F3FB9BF9FBF153F8CBFA5BF0BBF4BBFB8BF3F3F9A3FB43F9FBFE83C87BF9BBFC53EB3BF85BF903F953F71BFCCBEB7BFADBF65BFAF3F61BF46BFAABF93BFAB3FA13F27BFAD3F9EBF8FBFA33FA63F233F143E773F64BFB53F443ED33D963EEDBDA3BEA3BF18BFF53E9D3F8E3F2C3F7D3FB73FAF3F90BFE23E273FAD3F9F3B88BFB53F86BF43BFA63F753F7CBF68BFADBF543F723F983FCCBE87BF983FA63F8FBF133F863FB1BFA83F30BF76BF193F73BD0C3F9F3FAEBF95BF9B3FBA3FA93FB33FA0BFAFBFB03F84BFACBDB03FB5BF99BFA0BFEC3EA0BF15BFD1BEA4BF753E943F53BF82BF9B3FAB3FAEBF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}

