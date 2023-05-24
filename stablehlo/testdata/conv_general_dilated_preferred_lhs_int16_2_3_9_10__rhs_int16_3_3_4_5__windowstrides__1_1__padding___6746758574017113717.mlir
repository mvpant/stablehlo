// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xi32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>) -> tensor<2x3x6x6xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xi32>, tensor<2x3x6x6xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>) {
    %0 = stablehlo.constant dense<"0x030000000000000003000400FFFFFBFFFBFF0100FCFF000001000100060002000000060001000000FEFFFEFF01000000FFFFFBFF030000000400FCFF00000500040000000000FCFFFFFF0200FDFF010002000100FCFFFEFFFCFF00000300FAFFFDFF00000200FFFFFDFFFFFF0000000001000000000000000400FDFFFDFFFFFF0200010003000200FFFF0000010002000200000005000100FFFF000002000200FEFFFFFF05000200FEFF01000400030001000400FCFF00000300FBFFFCFF0100FAFF0000000001000000FFFFFFFFFCFF0000FCFFFCFFFDFF000000000000FDFFFDFF00000000FFFF0100FDFF000003000300FFFFFCFF0700000000000400FEFF0000000000000000FEFF0500FDFF010002000000FEFF00000000050002000300FFFF0300FCFF0200FEFF01000100FCFF0000010002000100FFFFFDFF000000000200010002000000000000000600FFFF030000000200000004000000060003000100000004000200FBFF01000000010000000100000000000300010000000300FFFF01000200000003000000FEFF01000000FDFFFFFF0100FDFFFEFFFEFF000000000300FAFF00000000FEFFFAFF0300FEFF00000000010000000000FEFF03000600FDFF0100FCFF0700FFFF0200000002000000000000000000010000000200FFFFFEFF0000FFFF0100000001000000000002000200FCFF0000FEFF000000000000020000000000050002000400FFFF0200000003000200FEFFFFFF0200FEFF0100FDFF0000FFFF0600FEFF0000000000000400FCFFFFFFFDFF02000000FFFF0300010003000000F9FF0000FEFF020001000100FEFF0200FFFFFEFF040005000200FEFFFCFFFFFF0000FEFF000000000200FDFFFEFF0000000000000000FDFF00000000FEFFFBFF000002000200040001000200010000000500FFFFFEFF0000FBFFFEFFFFFFFDFF00000100FFFFFFFF02000100FCFFFCFF0600FBFFFCFF00000100FBFFFFFF000001000700FEFFFEFFFCFF020005000000FFFFFFFFFFFF0100FFFFFFFF000002000200FDFF03000200FFFF0300FCFFFEFFFCFF0500000001000000FFFF000000000000030002000400FCFFFFFF010000000200FFFF0400FFFF02000100FFFF01000300020003000200030003000000FEFF0000FCFF020001000000FEFF00000300FBFFFFFF0000FCFFFDFF0100FEFF0000040004000400020004000400FDFFFCFFFAFF0300FEFF0200FCFF00000200FFFF00000400FBFFFFFF0200FBFF00000100FEFF0200FDFF0000FFFFFBFFFFFF000000000300FCFF0500FFFF050002000300FBFF0400FFFF000004000000FFFFFEFFFEFF03000100FEFF0200FDFF0100000002000100FEFF00000000FFFF020000000500FEFFFEFF0000FDFF000000000100000003000400FFFFFDFF0100FEFF01000100020001000300000000000200FFFF0200FDFFFEFFFDFF0000FEFF000002000000000000000100000000000000000000000100FFFF0000030001000000FFFF"> : tensor<2x3x9x10xi16>
    %1 = stablehlo.constant dense<"0x0000FDFF000001000300FEFF03000000FFFF0000FDFFF9FF0200FBFF05000300FFFF0000000001000000FFFF0300FEFF00000000FBFFFAFF03000100FFFFFAFF0100FCFF0100FCFF04000300FFFFFDFFFCFF0000FBFFFEFF00000000FEFF000000000000000004000100FCFF0300FDFF00000100FCFFFEFF000002000000FDFF04000100FFFF01000000FEFFFEFF0500FBFF01000100FBFF020001000000040001000000FFFFFEFFFAFFFEFF00000200FEFFFAFFFEFFFEFF000001000200FFFFFFFFFDFF0700010003000100FEFFFFFF0000FCFF0500000000000200FEFF0000040000000000FCFF020006000700010001000000FEFF01000000FFFF020000000600FFFFFFFF0300FFFFFCFF010000000000FCFFFCFF000001000000FDFF0100FFFFFDFF0100FEFFFDFF0000000002000100FEFF02000000FCFF02000200020000000000FFFFFDFF03000500000003000000FEFFFFFF01000200FEFF0500000000000200FCFF0100"> : tensor<3x3x4x5xi16>
    return %0, %1 : tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>
  }
  func.func private @expected() -> tensor<2x3x6x6xi32> {
    %0 = stablehlo.constant dense<"0x320000003600000042000000DFFFFFFF4C000000DBFFFFFFE4FFFFFF00000000E0FFFFFFAAFFFFFFECFFFFFF1D0000002A000000FFFFFFFF1C0000001400000045000000A0FFFFFFE1FFFFFF16000000FAFFFFFF1800000015000000F2FFFFFFF0FFFFFF00000000EEFFFFFFCBFFFFFFEEFFFFFF25000000D6FFFFFFC2FFFFFFDAFFFFFFEFFFFFFFB5FFFFFFF5FFFFFF65000000BFFFFFFF220000002C000000B8FFFFFF55000000370000003A0000003800000032000000D3FFFFFFEDFFFFFFECFFFFFFF7FFFFFF4A0000009EFFFFFF46000000C7FFFFFFF9FFFFFF0B000000FEFFFFFF20000000B6FFFFFF37000000F3FFFFFFF2FFFFFFE2FFFFFF27000000F5FFFFFF2D000000E6FFFFFF3F000000FDFFFFFF41000000350000002F000000D3FFFFFF8000000017000000210000004D00000012000000F4FFFFFF37000000F5FFFFFF05000000080000002B000000EEFFFFFFE6FFFFFF00000000B7FFFFFFF4FFFFFF3300000010000000FFFFFFFFEDFFFFFF0A000000CDFFFFFFE9FFFFFF1B0000008CFFFFFF07000000030000001A000000E2FFFFFFF0FFFFFFE5FFFFFF25000000E9FFFFFF0E000000FEFFFFFFB5FFFFFF160000004100000013000000F1FFFFFFE6FFFFFFC6FFFFFF9DFFFFFFF0FFFFFFDCFFFFFF04000000EDFFFFFFECFFFFFF4E000000E1FFFFFF31000000D8FFFFFFB1FFFFFF5500000006000000E7FFFFFFF8FFFFFFEBFFFFFFD4FFFFFF010000002900000000000000060000000700000020000000C1FFFFFF0A0000001F0000003100000044000000EEFFFFFF3B000000E0FFFFFF55000000A6FFFFFFEEFFFFFF4F000000E9FFFFFF14000000B6FFFFFFF2FFFFFF22000000F1FFFFFFC1FFFFFF2D000000EAFFFFFF33000000DBFFFFFFF0FFFFFFD4FFFFFF070000008AFFFFFF00000000D6FFFFFFBAFFFFFFEDFFFFFFF4FFFFFFB4FFFFFFB6FFFFFF640000007EFFFFFF4F000000EBFFFFFFF3FFFFFF2F0000001600000019000000B6FFFFFFD7FFFFFFE8FFFFFF4500000011000000380000000D000000140000003700000004000000F8FFFFFFF9FFFFFF6A00000024000000FBFFFFFFF5FFFFFFCDFFFFFFDEFFFFFF18000000DAFFFFFFDBFFFFFF0E0000000500000022000000FFFFFFFF11000000B8FFFFFF1B00000034000000040000001000000067000000F2FFFFFFF7FFFFFFE6FFFFFFAFFFFFFF"> : tensor<2x3x6x6xi32>
    return %0 : tensor<2x3x6x6xi32>
  }
}

