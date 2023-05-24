// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %3 = stablehlo.compare  LT, %0, %2 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %4 = stablehlo.negate %0 : tensor<20x20xf32>
    %5 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf32>
    %6 = stablehlo.subtract %0, %5 : tensor<20x20xf32>
    %7 = stablehlo.select %3, %4, %6 : tensor<20x20xi1>, tensor<20x20xf32>
    %8 = stablehlo.constant dense<0.000000e+00> : tensor<20x20xf32>
    %9 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf32>
    %10 = stablehlo.constant dense<676.520386> : tensor<20x20xf32>
    %11 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf32>
    %12 = stablehlo.add %7, %11 : tensor<20x20xf32>
    %13 = stablehlo.multiply %12, %12 : tensor<20x20xf32>
    %14 = stablehlo.divide %10, %13 : tensor<20x20xf32>
    %15 = stablehlo.subtract %8, %14 : tensor<20x20xf32>
    %16 = stablehlo.divide %10, %12 : tensor<20x20xf32>
    %17 = stablehlo.add %9, %16 : tensor<20x20xf32>
    %18 = stablehlo.constant dense<-1259.13916> : tensor<20x20xf32>
    %19 = stablehlo.constant dense<2.000000e+00> : tensor<20x20xf32>
    %20 = stablehlo.add %7, %19 : tensor<20x20xf32>
    %21 = stablehlo.multiply %20, %20 : tensor<20x20xf32>
    %22 = stablehlo.divide %18, %21 : tensor<20x20xf32>
    %23 = stablehlo.subtract %15, %22 : tensor<20x20xf32>
    %24 = stablehlo.divide %18, %20 : tensor<20x20xf32>
    %25 = stablehlo.add %17, %24 : tensor<20x20xf32>
    %26 = stablehlo.constant dense<771.323425> : tensor<20x20xf32>
    %27 = stablehlo.constant dense<3.000000e+00> : tensor<20x20xf32>
    %28 = stablehlo.add %7, %27 : tensor<20x20xf32>
    %29 = stablehlo.multiply %28, %28 : tensor<20x20xf32>
    %30 = stablehlo.divide %26, %29 : tensor<20x20xf32>
    %31 = stablehlo.subtract %23, %30 : tensor<20x20xf32>
    %32 = stablehlo.divide %26, %28 : tensor<20x20xf32>
    %33 = stablehlo.add %25, %32 : tensor<20x20xf32>
    %34 = stablehlo.constant dense<-176.615036> : tensor<20x20xf32>
    %35 = stablehlo.constant dense<4.000000e+00> : tensor<20x20xf32>
    %36 = stablehlo.add %7, %35 : tensor<20x20xf32>
    %37 = stablehlo.multiply %36, %36 : tensor<20x20xf32>
    %38 = stablehlo.divide %34, %37 : tensor<20x20xf32>
    %39 = stablehlo.subtract %31, %38 : tensor<20x20xf32>
    %40 = stablehlo.divide %34, %36 : tensor<20x20xf32>
    %41 = stablehlo.add %33, %40 : tensor<20x20xf32>
    %42 = stablehlo.constant dense<12.5073433> : tensor<20x20xf32>
    %43 = stablehlo.constant dense<5.000000e+00> : tensor<20x20xf32>
    %44 = stablehlo.add %7, %43 : tensor<20x20xf32>
    %45 = stablehlo.multiply %44, %44 : tensor<20x20xf32>
    %46 = stablehlo.divide %42, %45 : tensor<20x20xf32>
    %47 = stablehlo.subtract %39, %46 : tensor<20x20xf32>
    %48 = stablehlo.divide %42, %44 : tensor<20x20xf32>
    %49 = stablehlo.add %41, %48 : tensor<20x20xf32>
    %50 = stablehlo.constant dense<-0.138571098> : tensor<20x20xf32>
    %51 = stablehlo.constant dense<6.000000e+00> : tensor<20x20xf32>
    %52 = stablehlo.add %7, %51 : tensor<20x20xf32>
    %53 = stablehlo.multiply %52, %52 : tensor<20x20xf32>
    %54 = stablehlo.divide %50, %53 : tensor<20x20xf32>
    %55 = stablehlo.subtract %47, %54 : tensor<20x20xf32>
    %56 = stablehlo.divide %50, %52 : tensor<20x20xf32>
    %57 = stablehlo.add %49, %56 : tensor<20x20xf32>
    %58 = stablehlo.constant dense<9.98436917E-6> : tensor<20x20xf32>
    %59 = stablehlo.constant dense<7.000000e+00> : tensor<20x20xf32>
    %60 = stablehlo.add %7, %59 : tensor<20x20xf32>
    %61 = stablehlo.multiply %60, %60 : tensor<20x20xf32>
    %62 = stablehlo.divide %58, %61 : tensor<20x20xf32>
    %63 = stablehlo.subtract %55, %62 : tensor<20x20xf32>
    %64 = stablehlo.divide %58, %60 : tensor<20x20xf32>
    %65 = stablehlo.add %57, %64 : tensor<20x20xf32>
    %66 = stablehlo.constant dense<1.50563267E-7> : tensor<20x20xf32>
    %67 = stablehlo.constant dense<8.000000e+00> : tensor<20x20xf32>
    %68 = stablehlo.add %7, %67 : tensor<20x20xf32>
    %69 = stablehlo.multiply %68, %68 : tensor<20x20xf32>
    %70 = stablehlo.divide %66, %69 : tensor<20x20xf32>
    %71 = stablehlo.subtract %63, %70 : tensor<20x20xf32>
    %72 = stablehlo.divide %66, %68 : tensor<20x20xf32>
    %73 = stablehlo.add %65, %72 : tensor<20x20xf32>
    %74 = stablehlo.constant dense<7.500000e+00> : tensor<20x20xf32>
    %75 = stablehlo.add %74, %7 : tensor<20x20xf32>
    %76 = stablehlo.constant dense<2.01490307> : tensor<20x20xf32>
    %77 = stablehlo.divide %7, %74 : tensor<20x20xf32>
    %78 = stablehlo.log_plus_one %77 : tensor<20x20xf32>
    %79 = stablehlo.add %76, %78 : tensor<20x20xf32>
    %80 = stablehlo.divide %71, %73 : tensor<20x20xf32>
    %81 = stablehlo.constant dense<7.000000e+00> : tensor<20x20xf32>
    %82 = stablehlo.divide %81, %75 : tensor<20x20xf32>
    %83 = stablehlo.add %79, %80 : tensor<20x20xf32>
    %84 = stablehlo.subtract %83, %82 : tensor<20x20xf32>
    %85 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %86 = stablehlo.add %0, %85 : tensor<20x20xf32>
    %87 = stablehlo.floor %86 : tensor<20x20xf32>
    %88 = stablehlo.abs %87 : tensor<20x20xf32>
    %89 = stablehlo.add %0, %88 : tensor<20x20xf32>
    %90 = stablehlo.constant dense<3.14159274> : tensor<20x20xf32>
    %91 = stablehlo.multiply %90, %89 : tensor<20x20xf32>
    %92 = stablehlo.cosine %91 : tensor<20x20xf32>
    %93 = stablehlo.sine %91 : tensor<20x20xf32>
    %94 = stablehlo.multiply %90, %92 : tensor<20x20xf32>
    %95 = stablehlo.divide %94, %93 : tensor<20x20xf32>
    %96 = stablehlo.subtract %84, %95 : tensor<20x20xf32>
    %97 = stablehlo.select %3, %96, %84 : tensor<20x20xi1>, tensor<20x20xf32>
    %98 = stablehlo.compare  LE, %0, %8 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %99 = stablehlo.floor %0 : tensor<20x20xf32>
    %100 = stablehlo.compare  EQ, %0, %99 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %101 = stablehlo.and %98, %100 : tensor<20x20xi1>
    %102 = stablehlo.constant dense<0x7FC00000> : tensor<20x20xf32>
    %103 = stablehlo.select %101, %102, %97 : tensor<20x20xi1>, tensor<20x20xf32>
    %104 = stablehlo.custom_call @check.eq(%103, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %104 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x104B2C3EAB8A1B3D1844C1BF8B6B0FC0AF3AC2C051BF7E3FD511AA3EC8E196C0EA13F8BDF45A1A405800163F60F79EBEAE1F1341E9391B401E9E023F428B9C3F96B49AC08D97874014989FC0637B01BF5B134C40FF7215C0EC0DD4BE049C5840AA7B8C40773780C07C639BBFD97EF7C03BA6ECBEA10FB0BF9485DA3F60A659C08845BCBE778606C0CF61473E448B90BFF759C43FFA27C13F65A4D7BFA030A0BFE4F34240ECCF2E3E2212E0408626034025B80B4064C4B8BFA42FA0C06748BFBF1770A33EC0B3C34082774840951CFEBF42A91CBFE1C207408589A63ED78186BEF2E94CBFD9966A3E5CBAE7BF7C75E53F0B1B5ABF62014C3FC8FE0EC03E666E3F5742B83FAE5454BFF17CC040B29D5940303DF13FA0216040559447C0546E3DBEF446FDBEE78A65C0D2211DBF279884C08D16333F97DAAD3F68BF12402071DA3EA3BB93BEFFA0D0BE267C1540D74F0C402FBBDE400BC69F406C45CA3FF7B9443E25FE49402855C140E3542D4048ACDA3CF58B03C075B547BF59B5633E5050BE3EA74F273F14EB0E4003D4AEBFFB5D0A3F4439A3405F7E104040D928BF883FF3BEE99711BDC8BC29C0E6F9EBBFFE6F9640B84CD84086AEE7BFEA67E7BFFAD5C9BFD4C26ABF0226BDBF0E5416C0C747583DC45192BF53DD2AC0D9580F3E78D2D4BE6A9F8840AA25F13E1B2920407680A33FF5C37EBEC0DC84BF6C49F93F9384CEBE775C853FD24A7D40405F243FCC1E7940F37F1140F97767BF1BC0A53FA05C58C0AF908D3FF76BE4BFF4AF3CC0CF839A3F80B425405CC9AC3F03D26DC09342B2BF1653C73F71D11340185933C0C042C3BFA79057BF85EDF6403C0329C021E54440154BEB3DA4F653C0B44879C0929D963EA4D226BEAB7D24C0FB05C44088022BC00A017E40D03686BFBF4601BF05E00EC123BDE63FFD49F5BF6F00853FA5C9B9BE60939CC08DDA64405381C93F011950BF8CC30AC04337713F9BD0803F927A96BF85D46E3F905D06BF8619B03F75F40CBEB73C993FA93019BF0E6B98BF07BA8CBF12C66AC03630D9BF28D96BC00DB5F0BF8F41AD3E7F8273C0405219BF9D9F15C0EBCCB53FB5A80440857D55407FC75DC0F38552400DB598C03AD2C63F6DA8E7C00C0874402F69B14066796BC07156CFC07C29C33F565842C0F2069A403D9D87C0C78136C0CFD58E409F69A8BF63660ABE422314BD89410B403B9469BF09248E40E804EAC077F473C0D1379DBE1F0C35C0CDF4BD3FE4C68A4015A9B2409EA1D13FFA2F0B40422E88C0748F16C0CA9FD8BFD547D53F3E9A8FC0DBB6013E56F2B0C03F36404087247F4061862EC01A5EFBBFD0272640B1943C4009D9AC403BA5703E039312419735EABE257F13BEB5B2623E5BE32DC09437A64083DC94C0B3EF53C098BA06C0DB7153C0E9D5BABF1150F6BEE5B079BF4A6792C088812EBFE53592C0D070D43FA95E7E3D2D3088C07F35B2402876A33F9E740BBE3DC8A4BF055C2BC0E7654F40CD8A7AC0C8B21640F04BFDBE030E03403C6C48C0F4E906C0F09A163F6F07853FA9817ABF1401A6C006B3FFBE760216403A9C16C020B60940099510C047BC4940DDDA833FCC208D3E20BD163F4D7E363F60F453BF482205419DB7F1BF5683EABFD832FF3F236335C05D4733C0D1094AC0235A20BF9C5C9BBF7EB2E23F15AB144055D9BAC07BD31D3F1F942E3F21AC3EC0200CEFC07BE8803F1C358D3FCEEF5B409CB934C06FAD03C0D41B44BF2CBD5940248943C0259981C060FC703FE554CB3F23E0DA3E06A9DE3FA2BC7E3E3DC05940E45885C07A2331404D5B53BFC504A240FC6790BFB86369C00059643F1CDE65BF68DB763FAA7A27BE6023DB3EC788BC3F517924C0F8A547C00D898C40F6014B4056797940A2618B406009D6BBD751F940E3CAC2BFF58D6D3F0D4777407BEC5ABE3F67E1BEB95219C09E5058C0CF9E6240B8984AC01074AABF082E963EF79904C0939BB23F73C752C059BC56C021087C4027CA40408C1B164095FC7EBFFF4D2EBFE466AC4029E8CC3F00EFEF3EA7E42F4096B25C405D745140CC19F6BF88F8DDBF1DB566C0A05A6F4056EB0E3F54ECDDBF19D924C036A0E4BEEBD906C0D64A75BD725B0CC04CC70740C36784BF5F7BB0C0609C3D3F3546B23FE0C963BFE0B06A3D02554BC0CAEF193FA2678E3EE105D0BF969695C0728128BF230CB33FD4F3263F9D7B69BFB0DDF5BE35C6EE3ECC43C0C07D86D0BE49FD6E3FE7CD9C3FAD315D40FF2A343FEB4719402649723E"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xA1BFC8C039CDD6C1BD3F1C3FEEDC8A40D6108041CED515BFB83449C01A645DBFB3B1EE40C7B1283FF4DECBBFA640FC3FEA730A40EB782A3F1AFBF4BFC64285BE441674C04320A93F722A9AC2C8E779BCA3A37E3F0E9535408741523FF039883F653AAE3FB82E154306FD8F4010663CBF802BC03ECACDF73FF8625B3ED01218406349A53FD6EB2641F4CFADC0CCEAF94080DA8A3D40E9373D8680A2BF52E46B4016DB703F91E7C5C08AC2EF3F8E79E83EC7D9083F928D9E3F63A42D433676413F82F051C05F0ADD3F3446793F14A385C2C32182BF480FFF3E64C74DC053062C4067A581C080C593C07A8672C05E228F3E320BBEC0EDDF78BF57558F40184532BF400BB1BC59799FC08CBCDA3F68EA883F32F1B03E744A8D3FFC6F15418D308F40A807AC3D71A1083F119384BFBB60004159529CBF503CD7BD75A0183FC73518C0A4C6114080D2623FBF851E3FD7370A3F4EEFEE3F2095C03FC020DF3D0823B0C06B8E7B3F9258DB3FF8EC4C3F64FC17C20A74964126EC61C0C84198C06CFD31C009F5ADBF3926103F78CA02405263E3BF149BC33F8EAB133F88D4C5BFECBD843E94F7DB41B05AF3BEA053A0C09C06B83FC8E5EA3FCDCF71C0B69A6DC0D08808BDB09436C15793693FF0A92A409C749BC1EEABE040846D32BF445DF0C02C924E3FDC37AA3F864E07C0AB52343F6CDE47BEFAF03B40CB2CD5414CDBC63EDE236D3F5DA602BFA23C9F3F48ACB2BF46D19C3FEEE4153F7C261CC1702933BE9F162640A897D4BEB9DC44C022438FC19C5E8FBEF0F63E3F588EE9BD58A68BBF6B14E03F8897B53DC4F21A3F0A504CC05A5EED3EA897AFC0CE13FD3F68E1ADBE42DA733FD5B411C19CB05C40045FF6C033D064C0E02DA840441BD83EBC44DD3F3E043ABF26A59F3FB322A741A03904BCE0F23BC1EEE9923EB28D2CC122C403BF1800AC3FB6B7E9C0315F903F7068D43D976C8DC04ECFCB40362B2DBF491911BF1C4FB440E47B31BF11E73EBE302EB1BD05ECCD40A6D495BE23EF60BF1369A440EA6923412CDDCFBE7A31B8BFB8AE21BF9828E3C0163A45C0E33540C0C43F62BF20603340D0EE26BDA4F8EF3E0411863FFAACDC3F5CFA833FCA40F9BF486AAE3D6A06AD40B2CD993F0C57CF3F6C230DBFEC7E09400008733D617FE3412C62BB3FC0499E401A12A1C0849CB03FC25D2A407D60D240C817D841D6C6073FAB372CC18BE9AF3FF3B484403ACE4DC0E30C0140B30282C040C8AF3CA278AC3FF252D03F94BF213E059E073FB2FB9240C0DD27409C24B0BFE8C8393E579ADD3FB37C04C13CA4C03F3C916C3FA64BA03FB645C5BF9DD4D4C16DCF3F3F3BC6663F7AAECB3F650690C027330A407446D63E9F30C340F2EF98C02444B0BF222CC63FC072853C3A125D4040052241961B644034B18A3F758B523E2F5B20C226DF5E3FB455E9BFC49C6E3FE84C343EEEA784C18ED7924026F8CF3F283E48BE7584D040FA9B4440B08B4CBFB2BD813F49511FC11218213F6A55AB3DD2FEE73E7C4007417CCF1D41A6BBCABF5BAE03BFD57B38C2AEFCCD408BF42A3D36A31F3FD6442740E629043FEA2E7F40442C7B3F4E5B07BF48CE74C07C7BCABF309097BFDCBD9DC0ACAD0340F6D8F6C0834891C0E264D63E668A88C0FF524AC044D2E4406C9A95BFD4279040F8E2863E01C71C3F06D974C065AFBDBF68D9A2BF598D3BC232BF174082CB10BF82A1D6BEB77D8A3FD24C78C0AE45914191D04DC0E6FF883F6286994194FFAA410B952DBFF8E1ED3DD7DB17C0D830753EE4F587C0FE01893F76EFDE40BB9F533F1C0B9BC0CF8EC23FF217FC4040950ABECE3B45BF64A711C1543623BF8C5DA7407EA517C0401B323CD078D93EBC2A14411048AE3F29107D3F3A069D3FAC18AD3FDD811843EE64FE3F330CFF3E50D133BFF4BB9B3F9F896B40BD6F133FA7B80840889C264084EC8E3FB42ED940DCFB1C40B28165C075F46941407487BD79096E4014D93840B8829E3F287A6D3F60D81F3F9E317CC3E603E8BF8151CB3F70CE013EC62308C0A573513FE8008B3FA437833F88873CC1720102C008ACAE3E3EF8963F7DCED9BFB49601C00E4BBB3EF19A043F1A361F413325804176C5B0407E24FF3E0319EB41F2C5D23F7B0E8EBFC0F48CBD68C105C103848FC15A74CB409296C4BFE68972C02C650ABFFCBA8CBE5AC6C3BF483880BD8886AEBFD86B2BC1F38B5A3E3BF108C0525BF5429653633FAF3131BF12FA83BE34568B3F18CC9ABF057C263F700A8FC0"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}

