// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.cosine %0 : tensor<20x20xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xF16E45C06C2C0F4056CCF53FF70CBD3F8AA41040FAEBFBBFBAE7A6C076A2C53E246D1C3E944A0FC0A9D681BE2F44A240418EC43FD0B96B40BD4C133F70030AC0E96ADDBF2FD2F6BF5058DF3E38FBA0C0EFAEB2403C2F8A40050E0BC0E17278405877F3BF9CC7814050C7ABBFD6529240A88D6D4012FE09C0071949C0D1E1173F6EC9ACBF9E0178406E6E66BFCDAD574039FEC940DB3E0CC07410A2BF706C5C4026E39FBE06F4BFBB376697C04ED0BC3E045996BF23143CC0374B55C03476A23F9D2E174082CF62BFAE0595BF74560740657BFB40AE3C54C0A87254C0350591400CADB5BF974A2C40E3A6F23FA54E203F9610BEC0C9634E405D04A6C0E6030CC002038AC07CA880BE891C183FDFADC33F0602CD405591C93F418BA8406B23B23FF9AE8FBE7D8A64BFF15A543F0909E5BFD9A7303F4142B73FDA477EBF8966A340B985A73F9E9B0BC19F47FB3FCA9D4D3FBAE532C02DEB86C04B82D24098560C4180D7C43F4F4CF53F9CA715BF1DB1CBBF74F423BF34F353BF917711BEADCA103FAA7B083EE95D90BFFC3C303E8FAF9040F2BBE83FBA065FC07C4A234015C11BC08EB808C0208FCA3F77DF5340391F9540B76F703F1886E1BF4934BF3FE12F09C00BD6E6BFDF11F0BC517E2040CB1D0CC09B8C4DC0D333B9BF0A7173C035EC30BF16FA90400436E9BFF6E75540242930C0EC71503F2CBB4B3FE85BE2C03E972440A421BDC0C93EFDBE81F4D2408FA18640AF9C0D4021E0D1BFD791DA3F3FD6933FE8F98BBE3FC1C2BE5166D93F5B83B0BFCEC0E3BF92E4A1BF8947D6C0CB4961C08993B4C05CC925C077D016BFD24C22C033790C400478BE405DF3813E582C28C00715574045C0853F9990C23E07E416C00442E53F323F913FD9CF2F3FFCE806BE351B51BF8E80564080F62E40C133834012B2A6BEE64C80C0AC308840FA363540CBD0A8BF1ECFA340F77BE23FD2167EC07D85E73E298CC23FA15808C0CBFF17C0D4C80CBF44E33D4027E79EC0B8FEDBBD9870CFBFCE1A503FA72F5940EE1E143F2095793EC6F3623C189753C0A3B998BEF985C7BF3EB9E0BF098840BF1925FABF22169B40D5B0C03FBC9AD0C0172854BF4A7BFDBF40BE9B3EC54DE2BFEBD6FC3F464129C03776823F39D9D43F020126406918EC3D69A506C050E8C93F2A26C1C029BF6840AF7327C002ED9B40A3CA92C0517B9A3F0334BB3F248A96BFF1AB1BBF1769F1BF019B95C0575489BE5AF85DBF2ED0A040C613A54054466ABD933B21BD7440673FEA320140440AB24055BB7F40575053C0A8795740E26E35C05A533B40270DED3F5530824069408AC0355B10C0338C4740D7DD533F7574A4C0C27AE8BFAAFA0840348403C053572CC0AD8F46BF5DBB183FF9CA1FC085409940809F94405F9FF8BF5FA1BD3EFB530040C065073F3673523F6564ACBEAC729D3FD794B6BF308AC33F9DFEC1BE46B628404B233DBE6E744D3F930A3B3EE31DDDBFDCBE1BC11AAB1340F43A883F148300C0B2B7C1BE16CA0BC0CDC36AC047BB8CBF1DA25F40E2CAD3BDC5D0B53F12971640DA50813F1C8CCA3FD71F0A40DFF1B9BF46A615C016B0863E30621FC09F6A85402129A13E415985C0F1251340A6C21840EDFEB7BFCDE0A73FE1A94D3EF60486BF06B26240C1AA4040C1D90140424EF4408778A940CAFB2240A1C81EBE2B45803F9369534005D8843F8C9F4440A9C96EBF58DC9740EB796E40CF1BE93D3A6A623F89D7AB3F80998F4045D1AEBFC98950C0E8D418C0D9B588BF54AF4AC09564B7BE26341C40D8A2233FF2EF0D40EB576ABE0E601FC0F6FF76BE56D54DBEA9AAA5BE4882073FDE0EFDBF6D55A73F2A347EC01940D5BFBEDF6CC0431C8AC04C732640183ED2401E30E43D45B75D404DC404405939BCC054A052400CAB324044D888C0C2FE24C1D687FB3F0DA8733FD8EEA4BF0DDFB3BFE7C40C4070256FBF635FBDBFA080C2BFF29D0CC0CD3B00C0AB5D48BE9A4D36BEDA7BA03F6F7B5E40D991323E27460BC0BD40274012A01EC0C36C1440FA1D36404D14D1C05621123F4AB736C0935559C073C0823FD7518D4053B63A3D7F8E9A404EF7CDBF814672C0B06812BF28016C3E3AAFD93E7A01933EF646803F26C58BBF7B147A3E3CCD2A40063E27C0E7716FBFCC2F51C0CA4774BB3CBAB03F662CB4BF03D7323FB0F1BCBF544034BED1ABA23F62DF9CBF3934D3BF1FD201C094571EC0AAF7864003A1EC3F8E5413408CE0A7BE5C9AFBBF69246DC0182D5BC0D2D94FC0"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xB2967FBF143A1EBFFB52AFBE0EE6BF3DFFCD22BFD920C6BEC1FDF63EE5296D3FD3047D3FD6981EBF03D0773F289DB33E942B103D055C5BBF6AC7563F2F810DBFF42822BE9B29B3BEE106683F7B38A03EEDE8433F789BC4BEF8F410BFC1F93CBF0E88A6BEED4D1CBF8E3A683E8CAA0EBE848057BF4A6F0DBFFDFF7FBF4C40543F995D603E392A3EBF8A1B1F3F2B5A79BF42E47F3F85DB14BFAB96993ED05F74BF649E733FE0FE7F3FB0509A3CF3C96E3F4C97C53E19C07ABFB0567BBF3912983E561B36BF99ED213FC178CA3EE17604BFAD4E9EBB791B7CBF9DF57BBF58D537BED97E1A3ECE9066BFB672A3BE3A6D4F3FF307713F0B1D7FBF4773EA3E6A1B14BF1B28C7BEC0F5773F721F543F75322C3D5E0E7E3F487A81BB05D0063FEE68363E46FC753F8C95203F39DC2C3F82025EBED46D453F5CF70D3ED3C20B3FC07DC43EDDA0843EDAEA43BF02C2C3BE38C5313FFCCC70BF85BFF3BECDEC743F8F3B4BBF1105073D7E71ADBE087D553F8F4DA8BC94444D3FAF282D3FD76B7D3F2822583FBFBA7D3F0270DB3EC5377C3FF25A42BEDACC7ABE461271BF46B254BF347C42BFE92A09BF91A13FBC345B7CBF733C56BD6E26173F868142BE33919D3DFABC0ABF1B0D6CBEDCE37F3F92444EBFD96F14BFFA5E7FBF651AFD3D25E549BF4942453F643339BE397F7EBEA5DC7ABFB2DD6CBF62B92F3F431F333F5A16343FB88B57BFB9696E3F7751613FE1DC733FD2C8F7BE2E4519BFE1E78CBD30A00BBE51D1CE3E0D7E763FB6B36D3FEC5802BE5830433E50FC53BE153E9A3E8E786A3F7BE06DBF464F4D3FAB165ABFA7D8543F1D7752BF259915BFD219723F69CC773F6CEF5EBFC0E179BF9B80003FBCBC6D3F2B4935BF6CBF5FBE8240D83E0EF7453F0DC87D3F213E2F3F2F607ABFD2016BBF092413BF268D723FBC8125BF94ABE1BEE4C973BF26407F3ECB82CA3E430B4ABEBA0A2DBF1F45663F2B5F503D56E607BF986338BF1F415A3FA31B7CBF2E52803E41867E3F0E024CBDB2F82F3F0FEB77BFC154563F036F783FB6F97F3F3E8B7CBFEFB1743F9AEF443C96373CBE22F33A3F408EBFBE93DE083EEAD7853DF4EB783FB7012D3FDBDDCBBE513F743FEAA048BE1682C9BEC30761BF2726063FB351BCBDEB8A5ABF014D7E3FEA1602BFF774D8BB9136783F4D4361BFB7805DBF0B70233E15A5FFBD543CB63EA24EDD3DF6E1C43EF91B523F16BC9EBE7B6818BDADD8763FE6A5253FE1A99D3EBEFBDC3ED5947F3F3CCD7F3FCC761E3F1BC0DDBEDF8E403FAF2428BFFCB87CBF128979BFC50D74BF4A207ABF89118EBE2EB319BF9D9DC3BE36EB21BFA8ED7FBF6A382D3FC8F5D33E1BD378BEE6090ABF0350EEBEECA666BF68C7363F5EC6533F88984CBFC8009D3D9FFD8ABD20E5B9BE31A46E3F6273D7BE74055D3FBE422E3F15A0713F8C19AB3EC254133E4CA7303DC6D76D3F9AFC5FBF44A57B3FF9E2313FC6BD7B3F6DC81FBEBED973BF8AF52BBF4961F83EF4C8D8BEE1E46D3F8F5E13BFFA505DBF357CE83E5A3E70BFE0A17E3F5164193E506F34BF7D18083F971F3EBCCEDF0DBFE24FF13D14BF31BF7231773F889B4BBFD74D04BF1F6C733FB5C404BF81692ABFED7C3ABFF71F083EDB40833EA4DA7A3FB709003F4CBD6BBF03CD7DBF2F70E2BE6BE55E3EFB0E0D3F780254BFB2ED7C3FC4DC093FCFA87CBF8511023F72627FBF437A183F9533083DAD7C55BFEE577E3FFE3B223F26BC673EBE5C64BEE07C503E59417EBFEDAE3ABFFBB2F63EEEEA7FBFA3C06F3F44A643BF4D754D3F6E4F1ABF5353793F5C964BBFB296783F79D87A3F26B7723F0EF75C3FBF4FCABE6C5B853E28B42CBF7DB8C2BDE7F458BFA0B3C5BEA3775BBF5E89753FA0697E3FD3C872BFB31EF7BE5FAC6B3F8C257DBFEA7C70BFAE38D8BE76A421BF41AFC4BE138A143FC19A8E3E75C0283E778E16BF8030183FF4C4BA3DD0CF513D531016BFD9C3D6BE6B1D7B3F2AF47B3F819B9F3E87CB71BF0D1E7C3FD1AD11BF471A5DBF38C149BF4F302EBFA7DD74BFD501783FC369573FCB8D75BF13C577BF9DA7053FE56B95BEECBB7F3F1519F03D98E41CBDBABA4CBF2D43573F203B793F6035693F2B85753FBFD9093FB0E7EB3E5267783F01EA63BFCD145DBFFDF2173F9DF07DBF8BFF7F3F4A81413E045E263E0A08443F8E98C13D4A0B7C3F6645973E6344AD3E721AA2BD6939E2BE3A0E49BFBB0FF3BEC3718CBE77F42ABF9B5C723FA8F3C4BE9D6258BF7AD075BFA18F7EBF"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}
