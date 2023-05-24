// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.sign %0 : tensor<20x20xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xAA5A6D3F25D78EBF301289C09F5BC5BFC98A013F40AEAC3FB9C2DF3F1ABDAE406A478E40CDAABABF238205C04A541BC045B0B340A49145BF51AE09C1BA5691BF3C933A401DA9F6C0A4CE44409FDAC5409213AAC0A454A1BF0ED78F3F7C07813F410DCFBF5C1258C029B733BFDE9E493D4F54BC3F06D1C8BE213E7140CEA8923F92D1CDBFFD88C940EFC9A1C04783013F10677DC001933040D26FA03E323D85C08D8C5F4051C371BED5D096C0F63BAD3F39E3123F43A12E40B6BC32C0A78533BF92343740B27C63C012EFC03E9884AD40DA26803DA4DDFBBDCBF7453FE5B77B3F8D80E93F7CDE24C020C9AA40CB4950401C2763BED03CC240C69382BF2B9B7EC0464F1E40CECCA0C0367D54C0C3D10E3FD00D8DBD14E10E40DC421FC0D9360F407AB4D0BF3F5966C0316831403FD80B40FB631F3FAEB8FE3E2ECAABC07AE3243E0706B740363C13C00D796BBFE3170F3E176480C01A01B93E7A9FC7BF11A12640A423453F736DA6C09DA8BE4000BF4A3DC1E35FBF9CF18EC095EF96C0B36C9FC01AB80EBE527C1FC06EB54ABF7036913D580BD7C0AEA70A3FE74EB93E0FE3A53F7548FF3DA8CD27C0FE8E9740E77C9040F2D907C04EDA8FC0775213C0E9160041A4FDC4BE6B17F23D92FEA3C0676C9440E896B540B5BCC84041A297C0258D98C05D69DB3E378F0D41C7CF3740F164FF3C11E47E3FD4ECB940E53030BEBCDD3ABFF46A523FAE67493F9E8A243FA6DFD440028843C0581FCD3F446FBBC0658122C05DC7A3C09EDB6C3E25A6A4C0BE219B3F479ECD3D907D7EBEB62ABD40F11CB03FC811C6BF2BB5F1BF6722CC4043D58C40EF4F4BC04BD15A40295B373FA8A10EBF195845BFE6C48A40072A52C039CC1AC0CBA5C1BF2E7CE3BEFB8CFEBFB9A7DD3FA8492D3F2D5D02C093E0A640C29090405E4527C0E357C13E0A03DE3FA50A2E40858101BF1A07943E5ACFA93F17E881BE579FB4BF15F1BA3FACEBED3F9FD7333FBC101D40DA12C23F96262040A693B2BF4E9494BF777EDB3E3166A83D49AFBD401C1309C1BF52E33F89AD98C0FFFC35BE6D92D63FEB3E80C05F31D2C03B5499BE57FA77BF0DBDE640B2D18CC0A1D0C240FB32264097477ABF26819DBFE05C9D408F4F3E40B752CB3F132EC43F41A7C03F67BDB6BF9607603FA35B4FBF4BCE9E40AB169A40D4098DBFC08B44C005A53AC0985892BFD26AD5BFA2204140B133BE3E77273340AE65A13F434489BC29229EC042BE883E7FFE42C065AFD8BFD66734BFDAA587C046038B40D2F125400D3C4240003BDF3EF25CC1BF62F1F7BFDE53454008B51FBFE3409EBF55E48840AAD9643E403796C0CA7DB8BF3901CCBDE73AB8BE24ED103FF2749FC098E1A1BFFBA89740410D45C04DE740C02629B4BFF174B24077BAA6BFF08D204035E895C035E81A40E0B974C0B30C4EBFFB180D40474BC7BF2E4D95BFAEDE23C0AD4224C04E91963D13B90040D3AED33FBD26223F0B7B8C3EB97B533E788D9E40BBF9943E3EF859BF083F65C05530D0BFA1F3234059EAA23F95D9F33FB184B5BFD7C916C07C469EC006100040836AA840DA260C3EC8A9863F94B6CA3F1E95643F4CE81FC0D936613F87BE48C0F77DA5402E99A63ED5D77040AC8460C0040FA8BD0FD29A3E9FF167BFF91BDE3E198BAE3F766FA4BF3EBBBC3FF52703BF5ED71CC08B7FB6BF01EE0940E7F40DC06D0BAD40E900A940EB22813EF31BF23F82BE6D4049EC653FCF5024BEDBA203C139ACFA3FFB4393C0407529BFE5169E3EDAEDFDBF1641CCBCE19F0341303988C0E84042C0160CC63FD5E2F23F6EF31040B9348A40099F70C05F37A8BFCC18644079170240BA03AD3F450B91403DF24EC0709A3AC06EECEF3F01EF38403B73D540571457C00DD89B403A288DBE2DA244BF81C50B404A9FDB3D25248F3DC50860BF13C2F6C04B3F83C06EEB97C014CFA73F7593C9C01DE6CFC080860E4035641FC0C0AF6B3F82EE48C0F26640C01C8D44401384B5BF589A3EBFDA6546C063EEFD3FF21A1FBF026179C01ACA353FD38C1441AB5F22BE587F2FC050AD3AC06A1534BF787C12BF10BFE63F4B240E41489104C0F417873FBABACD3F35D497BF16CB0EC023DA624046CAE2C0A469963E8AAA57BF5FDB254077CA4DBDD89326BFBE43ACBFA0DCAB3ED58328C0A6BCD53F1DF3E9BF79C846BF3EEB90C0DD600EC0595DE33E06EFB640B3B44E404803343F64DDF3BEEB38743F4739853FFFD5454065FC583D18A3A33F9879A1BF23B398BFE1CF8C40074CA13EAFC4BE3FDC0523C0D25B6D3EBA35DD3FEC471340E638A53E10E287C0CE138140139B0F40CF1A5E403682BABF8A82844021EC09C0F011B1BF144F7140021996BE76AC6BC029E6B740A8AE9BBFC3D4E83E1B561F3E29FCD8BF2FA0774062A6353F838F8AC064B042C037242D3F4F943FC02BEED1BF094F88BF71390B4042F255BFA7EA574052889A3D5B226B402B5FBC3E7C4DA6BF423ADB40CD97BCBF55958FBF00B7D13E1A88BCC069E99440FC783CC0BDA6B4C0BB34AF40AB0B2D3F7FF94FC01F43A640F8AB52401962D6BFE0D60A3FA607B3BFE71E924031745F4059363640AA2BA040987E3E40D332003FEB27C9BE4BE51DC058AB76C07B863A403EF25F3FAA99FC3FE33798BF186B913F908506C0EF42793F33CA48BF9262E2BF536ED7C00B1A70C0FAA9F33F3E85664071D05CC0ED6C5B40A69F81C03BCC62BF65A6973F18E838C08CA6BE3FA8AD74C01ECE6E3FDD3EC8BEF4B7C93FA4D509C00C983BC050E725C05505E9403E0F56BD65578DBF4A3B78C02D8C2140E04B36C0A82F49406698CB40D84E8D40A3945D40338E5140E4BF933FC452FABFFBF9B7C06D0BD23F372412C0DF4CD63F813EC8BE87F343BF497B203F0900B3C0FC383340010EF940B1A85E3E9885623FE5934840B739DD40CCD18040219E98C0E4D2B6BF4EFD1B4051DA953E858C6A3F5F44E2C001B2D5BE030C00404B4D8D3FE1F060BEE1B7A1BF4A4139405D65BFBFBDA892400A8682409B6586C011CA8640DACB85BEAF623B40C3D6423F9F73EDBFB5E2984013E063BF184A3E403E7A1BC0C972ACBFF30B8EBFC94B1DC0A578BE3E627C493E09626ABF00760EBFDC7F9DC0EB887E3DA93B55C09A49A9C0604C8AC0E064C53E8C749140757D05BF2A844F40A72CB33F2E5F4240904AE93FCB1FCB3FCBD92CBFF82202BEABA2C5405E0F64C0E4C658401632E53E99C8014057BA3640B1421A404AB80B4089816F3F11D5B73EEF0BA1C098E2DA401B93BD3D4A2F6D40A01E15C0D1A0F2BF2ACE6CBE7F3A31C0D1DB7D40AB131CC06528AABF34BF0AC08D950C40E493EB3D8524C54064990F405679E73F9736AA3F13698DC0E1E6E13FD6381CBFA5E43B4020D04640D56F00C0D27C813F20AB4CC0C15C963FD93B4140A05BAFBED8DA883F771208C092E8DF3FFE3E4F3F1215943EE11B58BFE7134040D8339E3F4D8B0340C2707C401A6C70408BA135BF1D5FF4BE742399C0E894E8BFF3D55640DCBBC6BE3D8EA0BF4BCEDC3F29B7CC3C41D31DC00FB54040F47586C0AF7781C0516CCCBF391B304095C885C0A44E5740128ABBBFAA785CBFA26078BF3053893F7598B9C0611ACE3FE9314340A2D535C0299B5B3F4BA03E3D69506CBFB87467C0DCB88BBD382F7540710C23C09BD5C2BF17FDCF408FE7B63FAA50803F62EBD23D7E9C8EC01414C7BF1D4824C020531E3FB42A3740A065BF3E944CBB400C37E0BE0655C2C053364A404667943FFD00E93F8BB124C0B77D8CC0C924AA40269F1FC00758883F3D5943C088CE273FA405F5BEC7BB2AC027FE9E3D9E5D8D3F3A5ABBC015888940153CB0BE0D1D2B3F9C309940DD07F03F3AB80E40BCBEECBF38A5143F095B604095AA0AC070582C408C07DBBE25FD0D40E23E2CC07DCB6DC00BBD31C023430D3FE9D5B63E7DB80B406B6778408D734940E31F8240B09A9E40FE74283F1CAB85C08B941D408CEF9440807CE53F4A9335C02DC6ACC0E552DDBD6C05A640DA19A0C0CAE7F43F4140FA3FA7092DBF92511D3F042AD74038FB3EC09DB842408AF2A0404F1E5DC0ACDD0A3F372605C0422B5ABF870C9CC03252913FF4C47E3D190423C0AEF21E40486DA73DBCAF99C0162B3B3FBDB709C0CE90AC3F312183BF5E6D65BF77670ABF9250BFC02D0F283EB1B239C096EC37BE4676C93FAD5835BF06D9313F584C7D3D9899E7BF14BFA3BF3643F6BE51F606C001D9A6C0F260C1BF7D2440403F65964031F594401A6BE63FC1C9C7BE88CCF33DAD86C2BD0FD889BF78A6833F82734E3FE9EE443F4C1DC7BEBD18D33F0E0D16C0EE5AEABE0528AD3F02662C3C334A403F14DC494067B74FBEC54512C06CC01E406148D93F0032E1BEE96B963F5E1C3940F0B34840E6BCD5BD1E0AE83F7472C93F22089BC075DD203F1CB77F3F89384FC0A477A73F8C646740222DCFBF41CE12C0BABC2CC01E38814088469D408F55AA4067AABCBD551AB43F5FFF184046CA0AC1CCC836BFBAD14F40801270BEFADB0C3F292338BD"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xCF98233FFBE744BFDFDE70BFC767ADBE4ED0B33E6BB16F3FF91A9C3E9ACF733FE93F733FC3919FBE49DE26BF422442BFAA9D7D3F216D0BBECDCC7DBF4EF505BE721EB53E7F726FBFAF00E43E2437653F761779BF5B486CBE71903E3F3DF12A3F163BDDBE52DE66BF7D5F7FBFFB3F8F3D9A5C773FABE183BE3CEF743F5EE7943EB7507DBE140B783F5BBA7EBF3DE9CB3D910952BF565B123F96B1993D32477FBFCE6A7F3F231D8ABD4A0E76BFD6508D3EEAB8523E5F857A3FCE4A78BFF16179BE1E92203FB16147BFF1FA8D3D54627F3F0F2FE83EE82964BF7F411E3F5739493F35F2133FC1EB50BF6F915A3F1748053F419715BD47D47F3FC95A7EBE0EFA77BF8D1FE23E2CAE65BFF4757CBF73AF293E069CFCBCD6E07F3FE65A3EBFD92C2B3FFB46D3BE0A3069BF2E0C493FD97A1E3FC9FE473F49CE1F3F89E27FBFFD9AF53CC7816D3F9F10BFBE8E187DBF76CD193ED5F77EBF8DB2B73DCB8C03BF5A9D5B3F3BFC153E353D7DBFBFFD7F3F3D1C083C87BF44BEF03A7BBF9E0030BFA2E639BFCABA64BDBD997FBFD4FA7EBF5AA8B63D2D2C7FBF5687A43D54B7893EC690763F7682423D10B67FBF374A393F44A5303F579DDABE997D67BF877C8DBE0208763FF1B574BF4F5E963E48CE3DBFB9C82B3F01BD2B3FE2D83D3FF57834BF859035BFA529463D43B37F3F25FC7F3F53D6313C4EF52C3E68527C3FCFEF6ABED52B79BFCBEF383FED03313F7FF5C43D3BD07E3FC3B462BF91D3ED3E4BE16ABFFAA3CBBE2BBD7FBFF6EC383D3D2E79BFFAC66A3EA3C7BF3EE45C6DBFEA55793F3821683EA14222BF550246BFCFB7523F0860113FB7402EBFBC8A3B3F18104A3FEF2E1DBF3D3833BE740C7C3F571F4EBF1ED217BF5AA075BFF24590BE541041BF3B1D283F9E76A13EE2EF72BFDF7D413F1A9F273F7A5E7DBF426E123EA5A9093FE8D5573F33435EBFDD0CFE3E56717B3F4A5B40BE82E131BFB21A383FB1776F3FF802B53ECBC9593F588D063FCB985F3F9852F9BE492570BFBC61B13E4340633CB2F97F3FAFAB7ABFD7DA4F3E97D27FBF967718BDC492C53E052C6CBFFEBB7FBFD38C3ABDB15608BE84B87D3F1BF815BF37794F3F77956F3F1965B4BE219178BEE357783F62CD613FC63DF13E55A7363FC25E333F4E425ABF82C9053F7AF324BE21A87C3FC88C793F376A64BE7EA239BF7A4830BFF3C610BF192153BFF9147E3FA73BFA3DCB69693F4347D23EC0375EBBA0FF7FBFC2D6B23DA8057FBFF7566CBFF9C4C4BEC8C932BF2A39373F084A263F4DA3423FECF98D3EF3F575BFAF2F08BF29C5583FC1A6E6BE4C8D64BFBFA67F3F94B1553D58B974BF314896BEF49988BE75B876BF512FE73D1B5D7EBFE40184BE4E58773F43EF36BF641533BF20967ABE6737783FA0EFEBBE0833633FA26F63BFA005EB3EB5827ABF80EB52BE181C513FDAAD13BF2B41D4BE37F768BF20E57FBF3F90EA3C2DBD453FE096223F58E86A3F6F83CB3E3E952A3D24C77F3F3791A53ED83E72BF691869BF32AFD3BE2F43653F3AD0E33E235A4D3F71DC18BF802FDCBE3D1E67BF33F4B53EF7496F3F901A043E5BDC7D3FA5FF5E3FE674FB3E187871BF050BAA3EB9C104BF26E35A3FB06CB03D600C7F3F13EE7FBF3F92BFBCC016A23E36D572BF88379B3EE6F3733F2E2B28BF2D04413FBC8B51BE28957ABF763F0DBFAC81553F9A4CC2BE9CD96C3F63B57F3F5A63433D6A51E83E2A21643F69027C3F8F1934BEAF0A79BF8B1F6D3E67647DBFEFC911BE8E7B1D3E57F47CBFFAA046BBB4FF7F3F5B7150BF739E14BFEAC6213F7467463F44C8ED3EB8B7623F75A971BFA0F1A8BEF95F5E3F10A8FD3EFE50923EF452753F621F3EBFF36E2BBF1F510B3F82C5563F8E9F643F515EE6BE3C977F3FF68067BD7BDFA9BEC17F713F0578563F4CC80B3F4DF1E6BDFD5D7EBFD75B27BF0FB841BF30A5503E2EA17ABF112B72BFCF04A63E641E70BF0E87B13EBCE638BF610D31BF306B683FC4A3D6BE22246FBED0EB78BFD14A743FD81099BE16DA7BBF9897373E73F67F3F11E48BBC1F592FBFA7843ABF279846BF1F8B21BF97A34B3E08E37A3FF51864BFA271E83EE4FA4D3F900318BF885F08BF11A7583FC4C77FBFC1A3293D65499EBE8775733FA7A99DBD843D7FBFFF6378BF50CF773EED3058BF861A093F3F9E6BBF6733C8BEF8C565BFC6BEE1BE5F9C9E3D293B7F3FE8237A3F9BD6593E81B4E4BE570A653F1861A33ED99D723FBE95293DCFC77F3FBB003ABF0AE52FBFB2587F3F2E3F923D1548013F27F55CBF1420083E59BA7D3F02857D3F87330E3E949B39BFC44F303F76FF0A3F63FA563F5AF2A9BE707C713FFE6E57BF7C4A0ABFCD3A7F3FB2C19EBD871D0ABFD38B573FADC96FBFC64EB33EEA32BB3DA8ED7EBFFACC7B3F6AB6383E177951BFD42913BF78AC613EABB479BFB3B556BF7B690BBFC1F86E3F359DB7BE9DEF7F3FB02CB73CD9B97E3F3411CC3D03CC3EBE58847B3F9CAF4BBF01131BBF020A8E3D32627FBF9452583F66E508BF8EC437BF7F3A323F8F8A503E90A27ABF9240583FD801093FB78C73BF6CBA9D3E89F395BE53C6743F5A66463F46C8213FE4085C3F9ED8023F5A69493F61041EBFC2030ABF529C57BF6A31753F2531933E08445B3F792104BF7773F33E643561BFD45C473F289820BF0F1882BE269977BFBC4A64BFD0ADE73E99DE383FDF1531BF7D63253F586743BF8F4E19BFFF044D3FCF8A63BF519CEA3E25B478BFDEBB723E03A676BE7C76783F3A9417BFDF4C4EBF65B5ABBE9E2C713F2FA341BDB8B67FBF4F9056BFFFA20B3FE9E42BBFC1B43D3FEB4E523F9BF7113FF7FE393FE9E62F3FE21F023F57765CBF452B76BF53868C3E0E744EBFD85E173FC6F5E8BE3FF763BF6A16E43D4C687EBF6D57AD3ED2E1703F495D743E979A783F0566D33E0029693F871F253FCAA043BFAF6E01BF8DDE5C3F26CD9B3E0CDC733F218E7FBF2D5B71BD0725603FEE58F73EBE682FBE54377CBF1372633F2EFCEABEB33B3F3F8F312A3F58C134BF7548353F8110B6BD87FC7E3FB356C23E8DD76CBF55AB7B3F558E3BBE013E463FB3F921BFD99845BF04C322BFEB1D7DBF3540193E0028573E0B497ABF2117E6BD15617EBF23C4983C9AF47FBFDA4046BF37F621BF9F15AD3D8A157F3FE09622BE9EC07C3FC350D63E547E683F4F12413FF51A283F16957BBF92693DBE25BD5D3FC0DFFFBE0CCB7D3F8E2A063E523D143F7AB6503FA6BD3D3F16DB2B3FF9006F3F6472B73ED0B617BF70334E3FA18CCC3C92EB7F3FA39546BF378E21BF5C6FAABDAB1C7FBF66145A3F4B1406BF7AD205BFD03C5ABF53A67F3F6332563D1F8B703F6136AF3EDC3D4E3FA5A8173FCFBD6DBF16E5BD3EFF6450BE85A47A3F2E08573F22EA0ABFDF6B9A3E321474BF9BA5B93E27946E3F8F319CBEFECB733F68B045BF67A6223FAB13713F5541AC3E6DA28ABED46F763FD8EC033FB5635B3FD860393F848D303F006954BF2EE40EBF3F546FBF18BEB5BE384E7E3FD03EEBBDA48D16BFCE0C4F3F4705263CA4FC7FBF5E1D153FA51650BFA01E6EBF67FDBBBE6EBE0C3FCFD655BFFDB46A3FEA6FCCBEB8F129BF73743FBF2B423A3EBFBA7BBFD309EF3E1E63623FA81275BF86FD933E7F3E4E3DE0AC7FBF58F47FBFD4829ABC182B553FFDC10DBFEC7D69BE8E41793F4E92513FE905133F5342BD3C81EE7FBF13A904BF18F25ABF9D49583E71397A3FD588823DBE7A7F3FE54C93BD45567FBF9254703FD860B03E31D7133FDFFE50BFA5FF22BFDA66453F7E6D6BBF5218C93E1F4B7ABF4B01573EF2CE34BE4CFA7BBF2D9B8F3DB15E7F3FC25D4EBF3C7D173F0D68EABE4698633F4C5D6E3FA3BEBA3E720B453F196E23BFD254273E178F7C3F917A20BFA774473F0FE141BE9D5E7B3FBC2C16BF23534FBF6E177BBFBF8F473E274D253E79A47C3F2FD5463FFD3F213F3C60223F0FEA453F26591F3EA5E17CBF9B6BEF3E4749623FB9C1083F256958BFE0F27FBF6EEFA3BC6B46383F36B431BFFE0D333F80F6363F176B3DBF12362C3FC9FD693F49B1CFBEB380043F890A5B3FE6E67CBF94D31E3E22E56CBF6914C2BEFF5479BFF530683E2AFCC73C78EC7FBF88DC7F3F4BC1063D90157DBF3F1C1A3E76F058BFABEA073F7FAD40BF778E28BF8072B8BDADF57EBF5650673D69977FBF1435E8BD62597E3F1BC636BF673F333F12E90B3DC2D97FBF739F6FBF0530B4BE6AF8BFBE08536DBF4A26E6BEA9AD643FF9E2353FDA25343F86307A3F58EE58BE921B483F3FAA1FBF7A2139BFF5CF303F2E3D393FF0B2303FE7056BBE882A793FAB417BBFFB3544BE03FE7F3F30DFFE3BA53A6D3E1309793F780EB5BD65FF7EBFE043533F3094103F4878B3BEE9C16F3FE18F2D3F6C2E3C3F316B6BBDAA937F3F662F9E3EC07973BF9250083F7DB0583FCD5A6DBFFED1BF3EADA7693FA733D1BEC5C825BF721143BFC983223FDFCC453F31F67F3F12C18DBC92DA013F2F9F5C3F1E237FBF7A01A8BDD9557F3F3B7B93BD5A267F3F7CC5A6BD"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
