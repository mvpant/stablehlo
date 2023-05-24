// RUN-DISABLED(#1278): stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf32>
    %1 = call @expected() : () -> tensor<20x30xf32>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xf32>
    %3 = stablehlo.multiply %0, %2 : tensor<20x30xf32>
    %4 = stablehlo.multiply %2, %2 : tensor<20x30xf32>
    %5 = stablehlo.multiply %3, %4 : tensor<20x30xf32>
    %6 = stablehlo.multiply %4, %4 : tensor<20x30xf32>
    %7 = stablehlo.multiply %5, %6 : tensor<20x30xf32>
    %8 = stablehlo.multiply %6, %6 : tensor<20x30xf32>
    %9 = stablehlo.multiply %7, %8 : tensor<20x30xf32>
    %10 = stablehlo.multiply %8, %8 : tensor<20x30xf32>
    %11 = stablehlo.multiply %9, %10 : tensor<20x30xf32>
    %12 = stablehlo.multiply %10, %10 : tensor<20x30xf32>
    %13 = stablehlo.multiply %11, %12 : tensor<20x30xf32>
    %14 = stablehlo.constant dense<1.000000e+00> : tensor<f32>
    %15 = stablehlo.broadcast_in_dim %14, dims = [] : (tensor<f32>) -> tensor<20x30xf32>
    %16 = stablehlo.divide %15, %13 : tensor<20x30xf32>
    %17 = stablehlo.custom_call @check.eq(%16, %1) : (tensor<20x30xf32>, tensor<20x30xf32>) -> tensor<i1>
    return %17 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0x1EB528BF4EBF2BC09227354028CDD2BF93408A40E5AA9640A0D2C53CB3CEC13F5954253F35B0D33F85DCB9400D3B2D3E9DFCD53F0C16F2BFA4515BC00C5C1EC0C3434DC093EB29BE788415C074A145402D067EBFEDA82CC0E3AF5F3F20903FBF3082ADC0018D5E4091D23D3F37671340E8220CBFCEC3903FBBBE3940824F7640B472EBC0999003C066A204C02921EEC0DF6ECFBFB1F40B4059278440972DA2C01B0B8740227088BFFEF23A4020502E4093C54040439ADC3F0143B2BE1EB980409CEE1FBE2DD2E6BED02434C0A9D9563FBB6509C088D639407BFE4EC0D9050AC002E844BF73FD57C098118ABFCE0E5C40A398BA3F29FA5B4048BDE8BFA9ED023F1C7DF5BF014CAF3F6FB4B0BFAB94B64049E4CA3F44CEBF40C16138BFCBA7B6C01C9F18408C00EF3FD3C62DC0FE7B10C06C0558BF473F13C001241DC04EAA2B4049E7CE3DF14E58BF95BC8D407A1912407BA09AC01B41514019D102C0C86A3FC0328779C063EAEB40011A4BBD07B432C0DFD9FABF3C0BA240F78AF63EA819F1BFC0D0A3BE42D05A404A7546BE8E7FAAC0AB8752407CB72AC053FE5DC0ABC088BFB85CD9BFEB2BCE3E1E322EBBFD68B0BFB40673C051EB0B4077E8C23F06ADE3404F6F5B3F5C6476BEC16F9ABD8AC8B840960090C0764E5C402B7F4E3FEF665040F61908C06E45A5C08EF52FC0271F3DC060F9B7C0101F94C078D695409BC05340E0212F408BB7B8C033F6C040FE536BC037F19B3F933EABBF533136C00D5D1EC01C9E86409980D23FAB083A3EF2E184C0B65E3E4000B393407142C93F96E414C11C058FBF42AA0FC07DE7A340253D22408409BBBF74AF4E40481FAF3E1F5F88C0493E72C0CB598B40BCF0D740568F3E3F82581440921D6DC0F1E33FBF6F956DBEE9E737C043DEC5BFA6EB0840C29916C0060CFEBEF0B9A23FA204BE3F0884A03F9476274002431840788838408715D1C0BE87F4BFD120B7C0C9B1834063E7F43F886493BFF93A27BF4AE07540221AC2BED6C7B7BFB516393FB9A9B9BFBCD61C3F263091C0E2F0343F75FC11400D93B4BE593D0B3FEE4430C08DB17540FF036AC09A3842C0045852C0E44200C0AD361E40E01B453D110CF43E86D7A3C0A8A344C0B13E85BC33692040913B37C0FD2765C0DCBD0BC0A686A8C0555C9ABD22C38EC0BF1C0ABF4F4DA24096C0C3C09B55A5BE998FFCBF5FA222C077FE94C02E7EDABF9B5D44405134BD40434C3940BC6D9A3F3A9B383FBD624F4095B0EE3E5A3EB0C0DDD435C0A6DDFB3FCEE0A9BFE8020DC0EBB101BF3C6964C0D879BE3E20ECB040DA454B3FA2FC0F3FC91454C050E1A43F8CC80FBF37FBB7BF2FFBC2C05A8834C0F93D96C0273B26BFFE4959C0683FE44068D0A840B9CD923F694745BFF02A1740375561C0FD8A3FC002C11AC054535D3D0255EE40E32181BF4B182DBE70A21CC061EFAD4034CE02C02518A83F4C1787C0F810FEBE0615A73F2BF184C0B43CD83FC522B23FEEBFFABF20D30A40873653C08BF20B3E89AAC7BF67EE99BF0AA571C08A49ACBF1CA55940A79A0E40A07DC33F744A17C0F2500140F33321BF3D61543E824B85C0AE7F00C08686C9C071BE2CC0C408F13F8879FC3FD59EE3BF900728BF6492DBBF1FCB96BFCB5CA7BF2F9714C0AEC40DC0B58C14C0C048D0BF93CABA3F70CD9DBFCCBE90BDCDA094C0295541BFF6BE5440C63E5E3FFD75BB406A600CBE2C99F5C0FF3BEFBD5AB0DD3FA74E0ABE3DC1F63EE8789B405177E13F75D0B840159D03C01962813DE3940E40F1E6ACC0D563D0BFC777DCBF51C7D1C0C66BDA3E206A3240662B873DCF8D7C40C1D106BEAFE353C035F55D40A59B0FC09A1C743F73EA0B3F567D694094FB5640A5190E4067A1A9404A1FCCBF2C0853BE783E4CBF2D9663BDA5E4B43F21F5C83F47ABC13F15246D40546A44C0480990C075DA0B410F55804038758D3FF513A1BFD6098E3F6F4E1BC0DF89EBBEDB269340E457AB3EB8E6D5BF224CCC3ED7330EBE02F8FBBF2164F3BFF922DE3D7B2D09BF2C2540402B6B9E3E4A5A72BDB6A961C0DB2B0EC0D4183D400E3017BFCFF86940C6CB68BFC7C080405D533940005344C0F153913E1053AA3FBEC929C00C3AAFBF85D5A1C064FEF7BE43106BC00520E5BE29D34B406C8FF5C04D18A8BF48B1A6C0BBD529BFC4883BC00937CC4015C9D53E959913BFCB4FC14002958240A94547BF3379F0BFFA2F29BFDDF034C0CCD859C08630C13F13666FBA567281406922843F1EC472407F7B41407F70C140AAB6E13EC0215CC0E5C32B4005ED8E40CD34393E3495F83FC241783FC7F79DBF8E629540B00F95BF079699BF1ADD85C0BB9BD03F72B4CABF623A6A3E532663C057DA8FC0D19D5C402352A23F110EEB3F620952C007CD8A401F788DC07575C8C0535528C02CEC803FAAC43FC087BFD7BF285BC33FEA49AABEC74445C0000E9740A1F17EC04CC8ECBEB7B492BF6E34613F55F51D4068A8AB3F948B764036D234C09A2DF23EAB588540FDBEECBF7A96F33F97BCADC0CBFCB53FC6A1683F2A421C40BD57A1C0CF83FB3F6AA2DABE2BC686C0E66DC2C0726ED14018311840AA748BC0691C62BFB14CD63E446A6ABE1F4886BE7617103FCDC843C08DCB5EBFA54A0340EF507EBF4A3512BE6E609540CF6A75BFD8ED613F12CB82C0579914BE0B84C23FA9A15640E47E0240BF7D653E37733EC0A5BF0C40CAA6093E28203540A149B0BF6B1DA6BF31288D40219B7240CB5F953F9BA81440A09D803F32DA5B4064C2853D921CA43FE698453F5162AA3F387F604090D55BBFB8EC98C0EC094040881A7F408E1BCC408F77DCBFE781DC3FC0BA3EC0E4DD883F7691FC3DED0CBD3F2E3A204004D25B40217E84BF63C1733E5F43493F5F66CA3F0B4FC33FD9B02BC050B2C740CEA30F4024881EC0996D003FDFB8A23EE90400C0A5DA37C0C0626B3F8DCB84BFD26127BE5DBB80C07B71DABF8CD599C07E4861C021FEB8BE2EA86BBCDB96C83E2A372F400E7B36400B577FBF9553FC3F73523FC0D5456940BDE9E53E1F0592C0FC6802C013CAA7BF53C43EBE02DF77C0775348C087A8CEBF351D08C0C4B3483F616423C05DB4BBBE3E6F44409360C7BF825EC3BF1632B33FAE5C48C046CF15C0744A8E40EE2A32BF4484483F1BF4933E98BEA840D8DA69BFBB10C4403A26C43F494B3DC0504409C0CCE567BF70E2F33F0F2B4DC0089F873F9DAC93BFD7CD44BFAF3B4CC04214E93FE8A2B83F9A9A003EE1093BC0294C8BBF6AD2A2BE594FC2BE4AE54E40861480BF51658740576E373FB9D1BFC0263748407EF709BF2052153FAF3DB93FA6B3B340AA3CD5BF8DF916401D3D49BEF2F736402ED3F33F2A89FD40E88137C08556E03F3DBE6CBF77A630400C8F993E206C65C0"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
  func.func private @expected() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0x3491A9E50000008000000000BE10C19100000000000000000000807F96C47E19C24A8A67818C6211000000000000807FADEC65109B141785000000800000008000000080000080FF000000800000000075362BC000000080B024D34BFACD0BDA00000080000000003ACBDE5A000000008936A9F67DB82E340000000000000000000000800000008000000080000000801CA73A9300000000000000000000008000000000DDEB9DB90000000000000000000000009DEE990D000080FF00000000000080FF000080FF0000008012DF894F0000008000000000000000800000008059EB87D700000080C9B28BB8000000004FA5F51C00000000A744AF88FF99E77CDD56CD839538A722D62CF2A1000000009505421500000000D7DA8BDD0000008000000000307140060000008000000080A6440ACF0000008000000080000000000000807F019AE9CE0000000000000000000000800000000000000080000000800000008000000000000080FF00000080C53CD381000000000000807F92AE7D85000080FF00000000000080FF00000080000000000000008000000080D0BE6BB91F07FC8E0000807F000080FF21AE15A200000080000000007E37F818000000002A06974D000080FF000080FF00000000000000800000000035C82553000000000000008000000080000000800000008000000080000000800000000000000000000000000000008000000000000000808C3F622D0ECDCBA4000000800000008000000000C335E7110000807F0000008000000000000000006E4C07160000008012C44BB50000008000000000000000003306B69C000000000000807F00000080000000800000000000000000EB29885A0000000000000080EE17E1D9000080FF00000080A16492970000000000000080000080FF03BC8129007B431BAA3EB82A0000000000000000000000000000008074BC28840000008000000000E3FE0A04114D8EB22C8481E600000000000080FF49C0539EF30D2C5DE92E689DCD7B5A6C0000008069413F5F00000000000080FFFD303F77000000800000000000000080000000800000008000000080000000000000807F0000807F0000008000000080000080FF0000000000000080000000800000008000000080000080FF00000080493606F80000000000000080000080FFB849328100000080000000804B66828E0000000000000000000000001834432EADA86F5D000000000000807F000000800000008024027D017CEB8CA500000080BCA0C0FD000000800000807F000000008EE0985417322D74000000809D64432848444FF4D157389E00000080000000800000008051A20AE700000080000000000000000051A4EC3269CE55D7000000000000008000000080000000800000807F00000000AC4AA7BE000080FF00000080000000000000008046A1862600000080000080FFEEF4102700000080E194730F36E62D21135CDE8100000000000000800000807F97A3B996590693AE00000080EE863CA40000000000000000AFE6A91800000080000000006731D6E90000807F00000080000000800000008000000080D753830504303A010A99B88A51620DE609830B8E0D537BB08650EAA60000008000000080000000807AEFDD92901ED71CEBB748AC000080FF0000008008F02DD9000000003501704C00000000000080FF00000080000080FFBAFA240D000080FF0000807F000000007F699A0B00000000000000800000807F00000000000000805B13D0924659A68D000000800000807F000000000000807F00000000000080FF00000080000000000000008046BED14377AECE7600000000000000000000000000000000480CB494000080FFB1E926D4000080FF79C8C51F1FBA2316677A8B1900000000000000800000008000000000000000000B7E4D36025D6CAA314EF43500000080000080FF000000000000807F56E671900000807F000080FFAA357081C8A798840000807FC9F49EF8000000000000807F000080FF000000800000008000000000A763B4EF00000000E5EF29C80000000000000000000000800000807FECF7492500000080CAF0AFA200000080000080FF00000080000080FF0000000000000080689186A600000080568D11E500000080000000000000807F7517EEF100000000000000008D936ED62589B085086D6CE50000008000000080EA16BF19000080FF00000000D78D903C0000000000000000000000000000807F0000008000000000000000000000807F4061A7020BBB45420BB72FAC000000007B4388B1AE88C3AE000000807B29B6123F1C5A950000807F0000008000000080000000003819B2291766C70700000080000000000000008000000080000000802FABCD3E00000080C55BA28FE66FB918000080FF000000800000000000000080000080FF39C200B3EAE8324B00000000F00A962400000000000000800000807F00000000E5742087C9C58904000000808AE3371FABDA39480000000000000080B8029701000080FF000000800000008000000000000000000000008095DED6CA0000807F000080FF000080FFDDE81D7400000080B55A2FCC000000009DF713C0000080FF00000000AF1355C341FEED4A00000080000080FF4B4B201900000000000000000000807F00000080000000000000807F000000002E7C23A2C38097A700000000000000003DCF503100000000BF2C0B3F000000000000807F87D5B02898382E5759314125000000007EC16FCD00000080000000000000000000000000226EA68D229AA20D00000080C90A54390000807F37EBBA1B00000000000000001FFB4CBC0000807F33FD865528098415053BBF18000000800000000000000000000000800000807F0000807F0000008000000080C5C826472E7219BC000080FF00000080FD36868E0000008000000080000080FF000080FF0000807F0000000000000000C4A8B1BF0A9B480100000080000000000000807F0000008000000080B58CA9A6000080FF0000008000000080671B969300000080C16AC05500000080000080FF000000007A1EDF9680DDB798DEBCA320000000800000008000000000F4FDA9E02A66D8550000807F00000000D2FDBEC7000000000DAD5D180000008000000080BFD68AC8E3126C0400000080E246293AD7575FB2322F91D700000080ADA0910862C3EA1D0000807F00000080A55DB5B7000080FF000080FF000000009C6E6CBF00000000B9D6065E0000008000000000857019F80C82DA7083FE9A1D00000000FB89B39000000000000080FF0000000003847304000000000000008080FC110C7CB5A0C6000000000000807F00000080"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
}
