// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x2xi32>, tensor<5x2x2xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>) {
    %0 = stablehlo.constant dense<"0xA3D50EC095F533400E9D683F586E17C0C0DD593FD3A549C03AA2C7C00A1F02BF8A99B6C0165802405F63CBBF8AFF0740830289BEA8FA85404C3891BFDCF3F2BCE522D4C025092DC0C9384DBF3771BA3F1B97B53EE45D07BEA252044128F45E409D4384C0D9DD15C023D087BF604D064041C26FBFF7A31DC06732E03F07F683BFCD52D13E113094C0DB4F2840A5DD013F18F11340D0AB153F83F432405D9B06C02DF3B63FA225A5BFBA29B140FA3A30C0BFD1CEBF5FB0813F99C2EF3F282FEEC0F48CA4406B5D2440FB8EC03E1E2C503F742155C0A7379BC0F06DB74004F8A740965EADBEE2CF674098CB184021A13C405D35C440185F7BC0F39314C0E43B173FB348C83FBB9C1440D82F99BF97364B3FAEF86540E60E043F79DEB23F4CD4C7C00B7CA03C8223AEBFCC96F3BE5D2A383FFC14C240F34DA2C06B3D2F40432F16BF51DE4540CC27AFC09BEB44BE25F11BC00E0064406282884064A780BE025209403720304004C8A8BFA8C4C1C0A351983FBCCC3EBFB0771340BC113540611CB34092EA1BC0C74980BFEB7B6F4087900CC0A6D51CC022452D409559883FB6BD23C0ADB96AC0359DAABFBD4B7240F589AC3FBEE2FDC035C57740E4FB82C08419BC3F890D6A3FB595C83F2F99A5BFB8C4F3BF15EAD140023C3D409F5B06C0E32E9A3DD7DAB9BF2158B7C0D76460C096B06440BE7ACFBF2EB5F5BF502387403E500A3FDB1662405B3C18C03BD1E13F296F703F3A28BC3F5DCB3F40EDDB04401EC13DC0F3C1D7BF19111B3E03779BBFBF168BBF6F8900C14E24D5BFB8339F40741E6340C3AB4C40EFAE50C04ED25C40D6468EBFE94402C0D2644CC099B439405F88A0C025DC16C0BF83423EF2D1AC3E44F6153F0B5BEABFDA41A93F912B11417D2109C08CE2F0BF35900F40625902C042148540A34A49C0C6DA513F84E60DBF5659F63FE0ED06C0DA1604BF98853F401AC4E7C029239FC0F42BA240F3448640210990C05E88AF40FBB16AC04C49323F613466C0394875BFBAA6C43F766703C0DB5CAC3FCF33A540B73ECFBEC84E9EC0AE5216C016B2C9C0C35D333F6D5D87C0E5F9EE3E8D98AAC06F919D40891E83C06AF3E93E285604BF2BA4A4BFD600D9BF56CA4BC046EAC63F89E8B040CD6CC7C0AD4B52BFB683D5BF83641F40887E63BEC1D5703F53E0F5BF2DFCD4BE"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[[-1.42241132, 3.97979498], [-1.43272102, -3.084700e+00]], [[5.72927332, -0.559780061], [-0.654012143, 1.46970785]], [[0.640869379, -0.44839102], [-2.78331232, 0.946452617]], [[-1.14823163, -2.46767449], [-2.67389703, 1.66365623]], [[3.34375358, -3.61365438], [-6.054650e+00, 0.241316348]]]> : tensor<5x2x2xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0xA3D50EC09311B6BF0E9D683F586E17C0C0DD593FD3A549C03AA2C7C00A1F02BF8A99B6C0BA6B45C05F63CBBF8AFF0740830289BEA8FA85404C3891BFDCF3F2BCE522D4C025092DC0C9384DBF3771BA3F1B97B53EE45D07BEA252044128F45E409D4384C0D9DD15C023D087BF604D06406763B7BFF7A31DC06732E03F07F683BFCD52D13E113094C0DB4F2840A5DD013F18F11340D0AB153F83F432405D9B06C02DF3B63FA225A5BFBA29B140FA3A30C0BFD1CEBF5FB0813F99C2EF3F282FEEC0F48CA4406B5D2440FB8EC03E1E2C503F742155C0A7379BC0F06DB74004F8A740965EADBEE2CF674098CB1840BF4D0FBF5D35C440185F7BC0F39314C0E43B173FB348C83FBB9C1440D82F99BF97364B3FAEF86540E60E043F576D27BF4CD4C7C00B7CA03C8223AEBFCC96F3BE5D2A383FFC14C240F34DA2C06B3D2F40432F16BF51DE4540CC27AFC09BEB44BE25F11BC00E0064400410243F64A780BE025209403720304004C8A8BFA8C4C1C0A351983FBCCC3EBFB84A723FBC113540611CB34092EA1BC0C74980BFEB7B6F4087900CC0A6D51CC08293E5BE9559883FB6BD23C0ADB96AC0359DAABFBD4B7240F589AC3FBEE2FDC035C57740E4FB82C08419BC3FCA2132C0B595C83F2F99A5BFB8C4F3BF15EAD140023C3D409F5B06C0E32E9A3DD7DAB9BF2158B7C0D76460C096B06440BE7ACFBF2EB5F5BF5023874041F992BFDB1662405B3C18C03BD1E13F296F703F3A28BC3F5DCB3F40EDDB04401EC13DC0F3C1D7BF19111B3E03779BBFBF168BBF6F8900C14E24D5BFB8339F4061EE1DC0C3AB4C40EFAE50C04ED25C40D6468EBFE94402C0D2644CC099B439405F88A0C025DC16C0BF83423E21212BC044F6153F0B5BEABFDA41A93F912B11417D2109C08CE2F0BF35900F40625902C042148540A34A49C0C6DA513F84E60DBF5659F63FE0ED06C0DA1604BF98853F401AC4E7C029239FC0F42BA240F3448640210990C05E88AF40FBB16AC04C49323F613466C0394875BFBAA6C43F766703C0DB5CAC3FCF33A5401D4667C0C84E9EC0AE5216C016B2C9C0C35D333F6D5D87C0E5F9EE3E8D98AAC06F919D40891E83C06AF3E93EB1BFC1C02BA4A4BFD600D9BF56CA4BC046EAC63F89E8B040CD6CC7C0AD4B52BFB683D5BF83641F40887E63BEC1D5703F53E0F5BF2DFCD4BE"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

