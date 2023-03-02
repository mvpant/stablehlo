// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf32>
    %1 = call @expected() : () -> tensor<20x30xf32>
    %2 = stablehlo.constant dense<1.000000e+00> : tensor<f32>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<f32>) -> tensor<20x30xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x30xf32>, tensor<20x30xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0x6342E63F084FA84010A9F33FFF436ABEEA7397BF9B08B6400CFA7FC058A5E64084453DC00566D33C2B1A25C0C8352441E84663C07B4D06C0C9452FC0C9F71140CB03D23F5349AC3C93235AC0CD739A40330F59BF8D2ABF3D941B2DC0669B21C0B464C840D83FD83FED2AD7BE03E725BF2FD51FC06DF8A33E6BD055C0B710674013429C3F8D5EA03F5C22C4C0226A88C0959D843F2D2C8740767E163F5F18A4C03EE3BEBF56F60A3F1A1891BF2DEF0BC0285A2DC00B7626405F10B23E3081BD40AFB53D40B04BAFBF1B9ABD3F44AEF23E692167C0060802C076D62740CD1F0EC0F71024C09C2F1D405AE78840562DD3BFF9C119C0EAE446C03CE5F8BFF411F53F64D382C0999D1040100A3A401952AA3EDB61BE3E29AD91406F3F76BFAB10C3BF400FB5BF977934BFCA1E9DBFA89907BFE6D437C0B08320BE5DA5B03F9A59493F0F77AFC078658FC013FAF03F306D1B3FA2058340160E6F405634DE3FBEAF20C08A8A04C09BC32640EC169ABF374C984044F5CEBE425F9DBE60BD18BF1A55A4C0153B81C0B666614034BE8DC0A8DA2C409CECBFBF8659F73FF7C511C0B7F320C06C8E4F3FC5AE2A40152B65C0D842C94084EB73C0EB2B7DC08CC897BF18E463BF9CB19FC0193A0DBE6D549BBD3FA8024071E0BDBE326C00404D452EC0F4E6AABE8DAA87C0BE9F75C0026A02C0768019C04EFB61C0EC7E414028768AC0CBBDF43F78BABCBF4C5EF2BFB17B573C47A38040794824C00AF0CDBF4D6F9C3E0C0F0FBF371EAEBF1D37343ED8E770BE881977C0BB706EBFBBD49EBD86710D40C3EE8C4037F80A409F4EE8BF222896BE6EA5A93D4372A9BE725450C05EBEFDBF9D7040406C3AAF3F2C1E463FD36BEF3FF5759AC05AF0953FB86A223F52FAACBF56F66A4067488EBFC07387C0A662F3C05D8412BF3DA76A3F3AFE1B405C16AD4087DC1BC0E69E85C0D12618C0A0D8A1BFFAF66140E4F6B53F78391A4072D8BABFF7217BC0F88ACBC0DB9ACD3E8F8D5EBF4C44C1BF9BEB5C3F82B570BF2D944D3FA5D95140433F7EBEA0EF8E3E6FD80AC004B258C096461CBF05F5B13F139118409D4A96407AEE1FC012124ABFC536413E47946F3E091651C0E7FFA8BFE56150C0E0272C40D359BC3F9E65C13F7EDC033EFD9410C0409688C016EB73C0999404C0D0D61EC040E92FC0ECA13040B7EA6FC0F5BB7C4053AFA43F8377CA3F5E23E73F2425CA404F2DFB3F689DBFBE781444BF92661D3FFCE71CC08F8A5FBF23F60EC09225A0C0908146C0422DC23FD8C295C023277FBF62422FC04338ED3FD01E484072D524C0A76F0EC1C52DC5C07BE6CF3F812EFABFB5F613BFDE9697BE3BC70340FAC1A7C0C72D33405AED96C0711B48BFAB8AD3BE095E96C0EE6E08C071278BBF990E0D408D49A5402A91D93FBBF092BB13702F40580D24406B56094120791BBF1715D13FB6C5CABFAD18504046E331C070F1E13FE1D35F3FB2A15EC0C73D4AC0F558C3BFE38C79BD33DDC23F238ED03F4C954BBFF0B20C405FC790BFB7F14A40A42B01C152E0544052F53ABF45104C3B9F5C5BC085A3353F663BBD3E876722406854F83F6BA9F3BFAAE7D53F89ACDABEDD58FC3F5F2F56BF99D280BFBC2442400984963DB1993AC07580A3BF8EA7FCBF2CAB3AC000E8473F91622340254D003E72B843BFC16A2B40D2A91F3E600287C0B192353F237F6B3F5B2991BFC558623EBD410A404DC3113FD6483DC0DEDBC7BFC4D8C33D46B337C0D8FF7C4014FFCB3FABA275BF119BB8BFA6B2CD3F000236C080C233BC50773E407B2368C0F8738F3EC0DC4FBF5DBBA240FD89BEBE3B3098407B8F33407DCE78C0F7F2C3BF17AEA6404B50AA40999DE73F85ED1D40CB86013F93967E3F0DE3FD3FE372FCBF07F265BFB6DF72C0F557C13FCD45F93D2982F7BFA093D2C021F209C0F1021FC030024D407913B140F699C53DCFC47E408A32BCBF59F5BEBFF669F43E2CD002C0D7BB26BFA21F2BC0126921BF681F8AC0B3897A3E82CECEBFB95725409A49EB3F6BF7B0BE687A5F3F5602CC3F824E0FC036DC95C01B40D0C061829EBF7F9A5DC0E46DB440BFECF53FA37584BF2671DF3F00C8124072D2BDBD98219DBE52D097C0E8C9EEBF6DB29FBFC5D73BC0350EB33FC0CC21C03AB2FDBFC8FC12C01123CFC0BB7AEF3FF91564BF5FE2BF3F144090C05C27FABEBAF30F403847D3BF1686B8C06D379E3FB648903FF909ED3F1C9DF93F131896C0DA1194BFA07723BF2C163240D9B69140F9623C404F0BB0BF0DCE8A3F1EA69FC04282A840945306C1A95B9BBFE38228C0688CB0C0CA8A68C0C8BB9240FE5CD93E90DBA5BFA510E93FB10165406CE85CC092090EC0DF639D3F8F1A694092EA48407FB7E6BFF644613F30E42240D5B4A3C00612A74034AE43BE5BA4893ED45E97BF3E5CCA3F2A4785BFDA6FEABE6253CD3F98F0E23F26969E3FA3E00EC0638E18C018BF2F409D2C2F401440D3C057AB99405C95BDC036444BC0016189BED0593F40CB0DE93F48646840898A91BF3EEFEC403A070BC09B403B4093BB07C06D230A407AA2F9BF04504ABFB48499C0F8FBA43EA8EE1640BF757640CA86643DAB236040BF5A8B3F025DDEBE2CF85D3F74D2B33E90D9C3BFC7785BC00ED487BF07F26E3F1C4F77C069611940FAB7C7C0B3B964C0E7EC503F696F0AC143109A3F704EE6C0BC7A7D40A8BF15C03448F5BFE6544B40AFBCD83FEDE3B5BF63EA98C0AF23A9C0EBFA56C0DFF1A5BF33EB86BCC483AA3FBABD9040DEB22EC0D8DD81BE8BF74FC0F6BD4C40028001C0F9827AC0B80B1D4017BD5CC0C17964C070D3F5BF1502B3BF80F498C028881ABF952ACA40DFDDFABF8F10D8BEA74199BF91B48D4018E3514011E975BF4650F8BFD652353E870CE5C096E4733F64FC63407EE34CBF43B6C6BFA7DED83ECF76D140D430B3BEE00DAFBFB8F0B2BFF2E88F3E48BD3D4063559240E53230BF864A80C07D4144400FB9A6C0AE3BE23FD64D34BFEC2582BFA3DF10C07F5CC640C4928F4069CAC03F86D1F0BFD3AE54C09B9BD2C0FDA15BBF4D9F15C01CCE7E408E05EEBF88B457BFE7B0D6BFA997E63E686F20BE42AF713FBD302F40B3733A40687A35408BED4BC0541681C043BDF5BF05043CC0B2F68AC087061B40F0A202C0EBC74D40115A46BFA94D2A4029E6A33E46270CC07B60AF3FE07EA4C0371EC83F6019B83F1558A53EA22019C0DED23140C0BAA8BFAE94C5BFA96F5DC037873E3FD1B2EA4012EE07C08AC4A9BF27643E3F63F984BF1385CE3F112A07BFFAB4423F38B68240A022D5BEC673FEBFF23819BFCE341D3FCC1421409EA5184070F160C05B512A3F383BDA3FF8D1833E75280CC0643E3B4062DA9A40ECEB9FC0D0318BC080BA6DC0FFFD813F3C69A63F3D5D87C0"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
  func.func private @expected() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<1.000000e+00> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
}
