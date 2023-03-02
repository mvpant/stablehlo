// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      stablehlo.return %arg1 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>) {
    %0 = stablehlo.constant dense<"0xFE3C21BE8BC5F1325AC637BD75443AC0A8BD6D3BBCBC8DBC53BD3DBE1EC20D3CE7412D47054174410D2C19BCD036F1C1B9372CC65040E5C50842FF396A3B97B42B303E3D7341AA41DF3D58B9B9C6A7B27E3120AD3DC3A9B926B9C64191B920AF083910C8C2AECABDE437B4C027B59EB9D940B9C0084303BC68C24944AAC26EBD3BBCBE3F99C1CFA84839814367C23D3DC83C45458040D9BDD540793B7E3D5DBB6BBD24BFCFB76E425F411E41B7B7713ABEC48F30233BAF42DC3F403AD4C479C68340FC3E334135C31A3F1CC018B214C2613F9B39FAC08BB9C5C33947CCBCBCC151BE91C38BC32E3C7BC4734100455B46B0C42BB512BE82C4CEBCB945D34115C5A4BC4BBA4B48FCC435BEE4BA9BC0834202B79843D5B860BF28412440663D92C69BC01548B1A8B2BD9FC05041D73E6340DFBFB13C9746B23CEEC2BFC57CC0C03EC5445AC18BC10AC578BF07B2EE39F6B47FC500C5CB385E31E5450B3DC439E53D9B3284C178BBC4343FC19343E53A7835A8B932C0EDBDCA454832BF3AD53B23C3D5312F41AB401A448743293D963D79C15DC0833CE2C19E4176406D40894382B8B840F544"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<"0x46BE87C11FB54ABA7EBC52C2863203BED83B0746F440A5C1DF405937C6C06FC45330B143BF43934020369FC760C0D43C56C471BACC407FB63CBF82BF0737AD3EB6C321432F443EC1DA429440BEC165BF424589C56BAE0ABA99C1193E8D400FBF61C41743CBB85DC17F45F4392F43503DB936D43F1BB9794449C140C8F4427A3E1AC40D383AC041BC9E4493B617389ABFABBE1C44C43C6C43C23B0C3C24B691350DC2FEC06AC047B96CC3FAC61AC1FDC5AB40E14011C4913CCB3C1DBB62BE09C4E43C0BC492C0E7BBA5BD0CC1E434F7BB80BE78C2594476BE16C4AFB924C490B95BBED3BAC528E2416D42D1C3CB43B143C0BDCCBF9CBCC63EF4C5B0C4D2BE7DC0781D5FC26F43CEC3EA4382BDA13C9542814675C68B43FBC6"> : tensor<5x2x2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x46BE87C11FB54ABA7EBC52C2863203BED83B0746F440A5C1DF405937C6C06FC45330B143BF43934020369FC760C0D43C56C471BACC407FB60842FF396A3B97B42B303E3D7341AA41DF3D58B9B9C6A7B27E3120AD3CBF82BF0737AD3EB6C321432F443EC1DA429440BEC165BF424589C56BAE0ABA99C1193E8D400FBF61C41743CBB85DC17F45F4392F43503D67C23D3DC83C45458040D9BDD540793B7E3D5DBB6BBD24BFCFB76E42B936D43F1BB9794449C140C8F4427A3E1AC40D383AC041BC9E4493B617389ABFABBE1C44C43C6C43C23B0C3C24B691350DC2FEC06AC047B951BE91C38BC32E3C7BC4734100455B46B0C42BB512BE82C4CEBCB9456CC3FAC61AC1FDC5AB40E14011C4913CCB3C1DBB62BE09C4E43C0BC492C0E7BBA5BD0CC1E434F7BB80BE78C2594476BE16C4AFB924C490B99746B23CEEC2BFC57CC0C03EC5445AC18BC10AC578BF07B2EE39F6B45BBED3BAC528E2416D42D1C3CB43B143C0BDCCBF9CBCC63EF4C5B0C4D2BE7DC0781D5FC26F43CEC3EA4382BDA13C9542814675C68B43FBC68743293D963D79C15DC0833CE2C19E4176406D40894382B8B840F544"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

