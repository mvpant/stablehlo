// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.sine %0 : tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x10C0CF40813F383EEC402340803ECF3F06C1BBBF9EC002C0343E62BE95C08D402CC043BF93401AC08F40F2BF14BECD3F28C038C02CBF5640823F63C022409E40D2BF8BC0EC3F54403140F1BF2CC065C06D4055C0373F943E5640B83F88C08F3F1C4062C074C0A2BFA6C01740F4BD0440DCBE0EC0A23E193FB33E7C4049BFE4BF084073BF2DC09F3E02400FBEAB407BBFB840214036C0CB3F5BC0A4405640723F31C08B3D82C07840ECBF98C030407FBF69C08B405540E340623F28406C3FDAC036C068BFD73FAEBF9AC0D1C0FBBF50C04EC0A7400240F5BF7840BA3FC7C04C3F944054BF76BD574043C073C09A404CBFE2C08EBFCFC0DA4069C0BEBF6F3F79C0DDBE20C001C002C02EBF88C0AEC0A7C0CEBFDE3E134044BFA0C00EC0A3BEE9C014BF343E974047C04ABF9C3F4F3F6C40A840D93F184078C00C3FFFBF494048C07D3E7B3FDF402D3F1EC18A4057C0B340E1C08BBF60BD6E3EB73FA7BD99BF5CBF7F40E2BD7BBF884072C0453F8DC0C0BFB2BF7C3FEEBE02C023C0DBC0E13F10BD06404ABF803F604023C00A3EAAC0F33FD4BFA6BF87408EBD1A40E83F6B40C73F28C0E4BF24C09B3FB23F6B3F9D40D73FA6BF2140933E54400640A63F99C0973F4EC0743F1D3E9BC0A23E1340BA3F2BC0903EA6C0BABFEDBFE33EE93FF8BD01C0DABFFF3F34BF9DBF81408240FFBF5A3F994084C0713E2AC04CC09640D4BFB9BEFCBE194045C036C0253E504036BFAABEFABFBD3F41C0ABC0C53FFC3FA13F89BE6CC03CBF8DC06CBFA2BF6EC095C0CDBF05C0D5409D3FA8BFAFBE4CBF93C00CC115C0C7BF67C0B4BFBDBF484032C005BECE3E7EC0CDBF04C050BFFB3F8A4048BF80403BC060C05C3E61BF164084C0D93F63BD4AC099C0CCBF0DC066C0434001403EC019408B40AE40C8BF3040733F8A4089BFF8C069BF74C007C096BF2BC00640CABFBB3F7E40683F78C057BF09C0013F244083C0043FDD3E0A3F4DC06FC0DA3F2FBF13BF53C02540F7BE1DC07A40C5C06940A03F34C05A3FA5C09B40B14074C06AC08FC0EB3EA94010C0ED3E5F4024407240EFBF33C0314098BF64BE32C084C0CD3F1AC01EC0B6BFFDBF04C0513EC33F9840194063BFE1BFB13FCFBE6B403140"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x47BF3D3E583F373E633F0F3F7D3E803F5EBF7EBF7A3F65BF333E60BE803F74BFE1BE31BF7EBF2CBF78BF73BF13BE803FFDBE87BE1FBF4EBE5A3FCA3E133F7ABF7FBF6F3F773F2EBEBC3E74BFE1BED83E08BF3E3E283F923E4EBE7E3F653F663F263FC23E1F3F74BF643F343FF3BD623FD5BE4CBF9F3E103FAF3E37BF35BF7ABF5A3F50BFD9BE9C3E653F0FBE4FBF55BF02BF163F96BE803F8E3E6BBF4EBE503FBCBE8B3D4C3F2BBF77BF803FC33E57BFF53E6FBF3EBE3A3F463FFD3E4C3F01BF96BE4ABF7E3F7ABF7F3F7BBE6DBFDE3D9E3D60BF653F71BF2BBF7E3F843D373F7FBF3DBF76BD5DBEC2BD1C3F7FBF37BF34BF65BF3DBE013FF53E7FBF4E3F2E3FD6BE19BF67BF65BF21BF653F403F603F80BFD73E3F3F31BF753F4CBFA0BE57BF0CBF333E80BF04BD36BF703F393F05BF5CBF7E3F323F2B3F053F6ABF7E3A88BC7A3E553F223F203FDF3E6CBF5D3E23BF2EBF62BF60BD6C3E7D3FA7BD6EBF42BF3FBFE2BD55BF65BF193F323F743F7FBF7CBF553FE6BE65BF0FBF08BF7C3F10BD5E3F36BF573FB4BE0FBF0A3E533F723F7FBF76BF61BF8EBD2C3F793F01BF803FFDBE7ABF0CBF703F7C3F4B3F7BBF7E3F76BF163F913E2EBE5E3F763F7F3F6D3F9E3D513F1C3E7E3F9F3E3F3F7E3FE8BE8E3E643F7EBF76BFDC3E783FF7BD67BF7EBF6A3F26BF71BF47BF4CBF6ABF413F7FBF553F6F3EEFBE3C3D80BF7FBFB5BEF2BE2F3F82BD96BE243EDEBD27BFA7BE6EBF7F3F01BE4F3F803F6C3F743F87BE053F2CBF743F4CBF74BF0C3F803F80BF60BFBB3E713F78BFACBE37BF7E3F20BF3ABF80BFE73E7DBF7FBF883CB5BE05BEC83E3C3F80BF62BF3ABF6D3F6CBF34BF42BF5FBEB43E5A3E45BF373F553F7E3F63BD703C7F3F80BF4FBFE03EC23D673F30BE2F3F6FBF40BF80BFC33E503F6CBF61BF7FBF4ABF1F3F5CBF6CBFE8BE5E3F80BF7E3F3CBF4A3F2B3F3FBF58BFF73E0C3F513FFC3ED63E033F7C3D0F3F7E3F22BF0BBF1E3E093FEEBE23BF31BF023EF5BE733FA5BE413F673F7EBF2FBF1F3FFC3E783FE33E58BF47BFE53EACBE0C3F19BF75BFADBEBC3E6DBF62BEB5BE553F803F2CBF20BF7DBF6BBF62BF503E803F80BF2F3F46BF7CBF7B3FC9BE01BFBC3E"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
