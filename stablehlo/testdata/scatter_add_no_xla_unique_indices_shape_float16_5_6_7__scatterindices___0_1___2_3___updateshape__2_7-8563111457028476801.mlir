// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2xi32>, tensor<2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<2x7xf16>) {
    %0 = stablehlo.constant dense<"0xB73F0441F0BEEB3E1AB54DC4363DA6C110BB34C11A428A440BBCF842A1B834BEFA4137BCAE3444C1F83BE6B7D43FDFBD58C28CB704C07C3BB8B98CC202C4442B95BEC0403EC59243664203B96D425C3472BFEAC01DC1C7C1D5C062C013C1AEBBF2310F3E1E44A4445CC06A3873C45A3B4DB8B7BCCB3624452ABE4D4115C4D0446DB92BC4B93501B6A13F49BDBB3C4DC37DB440BA683682C44FC31DC12A2B5B4332443D3C99BF9FC37F41E5926CB6AFC6503FA83BAC47B735F64160C478C4873D65418ABA4042A44015C461B37DBD4D2C00C2CF3F5B3D173E2B3F5F43DD3F5B44CB462C44A5BCC3C4B2BF6BC12540DA395DB2FABCC9B9294749BEFDC0D5B8BB3BA1346743C9B203B80C3CBBC5193ABE3DFC3F384452BB03C55DC1DAC225BA82C285BC0ABD5C389D36CE3FEE4407BBD442B2B6FFBE653F9BB589C1CDBEA63803435AC06B3A2747B640303B1DBA05B6B3380E44C145CABB1341013D42C09CC1AF32AA445BB895B9D7C4BB3D17C355C02F3DAA42AD388FBA0944F5C05DBCA6443FC3C7C24D42312F143FBB452035C8C8313F8745C9C122362EC105C038B30FAFB23F7BBDD942"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[-8.867180e-01, -2.804690e+00, -1.087890e+00, -9.697260e-01, 2.389530e-02, 6.772460e-01, 1.651370e+00], [-7.226560e-01, -3.729250e-02, 2.537110e+00, 1.040040e-01, 3.509770e+00, 2.003910e+00, -6.748050e-01]]> : tensor<2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0xB73F0441F0BEEB3E1AB54DC4363D6CC360C361C32A40904456B52345A1B834BEFA4137BCAE3444C1F83BE6B7D43FDFBD58C28CB704C07C3BB8B98CC202C4442B95BEC0403EC59243664203B96D425C3472BFEAC01DC1C7C1D5C062C013C1AEBBF2310F3E1E44A4445CC06A3873C45A3B4DB8B7BCCB3624452ABE4D4115C4D0446DB92BC4B93501B6A13F49BDBB3C4DC37DB440BA683682C44FC31DC12A2B5B4332443D3C99BF9FC37F41E5926CB6AFC6503FA83BAC47B735F64160C478C4873D65418ABA4042A44015C461B37DBD4D2C00C2EB3C353D0F44963F3247F0435C43CB462C44A5BCC3C4B2BF6BC12540DA395DB2FABCC9B9294749BEFDC0D5B8BB3BA1346743C9B203B80C3CBBC5193ABE3DFC3F384452BB03C55DC1DAC225BA82C285BC0ABD5C389D36CE3FEE4407BBD442B2B6FFBE653F9BB589C1CDBEA63803435AC06B3A2747B640303B1DBA05B6B3380E44C145CABB1341013D42C09CC1AF32AA445BB895B9D7C4BB3D17C355C02F3DAA42AD388FBA0944F5C05DBCA6443FC3C7C24D42312F143FBB452035C8C8313F8745C9C122362EC105C038B30FAFB23F7BBDD942"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

