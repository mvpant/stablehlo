// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui16>
    %1 = call @expected() : () -> tensor<20x30xui16>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xui16>
    %3 = stablehlo.multiply %0, %2 : tensor<20x30xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x30xui16>, tensor<20x30xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui16> {
    %0 = stablehlo.constant dense<"0x000004000000030003000400010004000200000002000000020000000200030000000100000001000400010001000100000003000400010001000000010002000000010000000000020000000300020007000200020002000100040003000200010000000000010004000400010007000200020000000000000001000000000001000000040000000200000000000200010000000100000000000300000000000600010000000500070007000100000003000500010002000600010000000100030000000000010000000100010001000100050002000200020004000300000002000000000001000000040001000200050002000600040002000100000000000000020000000000030000000000010000000000000000000100020000000400030001000100010002000000020004000100020002000700010002000200000001000100040001000000020001000000010000000200000003000400020001000200000000000000020001000000050000000100020002000400040002000200030000000700030002000100000005000500020000000300010000000100040004000000010000000000020001000600020000000300010002000000000004000000010000000000000000000100030001000100010001000600040001000200010004000200050000000300040002000600040000000100020000000200030003000200030001000400030004000000000000000100010000000000030001000200000004000000040001000000020007000800010003000000070001000000010002000300030000000000040002000000000001000100070003000300000002000000010000000100010001000000030004000200020000000000010003000000010000000200000002000000020007000300020005000200040002000000020003000400050002000300010003000200000000000000000000000200000002000400010000000500020001000300010002000400000002000000060002000600020004000500070002000100000001000200040004000000000000000000010001000500030001000500060004000400000002000200020005000100000002000000050000000300000001000300010001000100000001000000000002000100060001000500010001000400020002000300000002000000070004000200000004000300000002000200000002000200050003000000000000000200040001000000000002000400010001000000010004000000000002000200040002000100010000000100020002000000000004000100000005000200010000000400000002000000030004000200000002000000030001000000000002000200000000000000020001000600000000000100030002000000000001000200000003000100000002000200030000000100020003000200000006000000040000000500010002000200010003000100020002000000020001000400010002000200020000000000010001000300030000000100030004000100020002000100050000000200000001000100010000000200040002000100000000000000000000000200010002000200020001000200020003000000050001000300010000000500000000000100010005000000000001000500"> : tensor<20x30xui16>
    return %0 : tensor<20x30xui16>
  }
  func.func private @expected() -> tensor<20x30xui16> {
    %0 = stablehlo.constant dense<"0x0000400000001B001B0040000100400008000000080000000800000008001B000000010000000100400001000100010000001B004000010001000000010008000000010000000000080000001B0008005701080008000800010040001B000800010000000000010040004000010057010800080000000000000001000000000001000000400000000800000000000800010000000100000000001B0000000000D800010000007D0057015701010000001B007D0001000800D8000100000001001B00000000000100000001000100010001007D0008000800080040001B000000080000000000010000004000010008007D000800D8004000080001000000000000000800000000001B00000000000100000000000000000001000800000040001B000100010001000800000008004000010008000800570101000800080000000100010040000100000008000100000001000000080000001B0040000800010008000000000000000800010000007D00000001000800080040004000080008001B00000057011B000800010000007D007D00080000001B0001000000010040004000000001000000000008000100D800080000001B000100080000000000400000000100000000000000000001001B000100010001000100D8004000010008000100400008007D0000001B0040000800D8004000000001000800000008001B001B0008001B00010040001B00400000000000000001000100000000001B000100080000004000000040000100000008005701000201001B000000570101000000010008001B001B000000000040000800000000000100010057011B001B000000080000000100000001000100010000001B004000080008000000000001001B000000010000000800000008000000080057011B0008007D00080040000800000008001B0040007D0008001B0001001B000800000000000000000000000800000008004000010000007D00080001001B00010008004000000008000000D8000800D800080040007D00570108000100000001000800400040000000000000000000010001007D001B0001007D00D8004000400000000800080008007D0001000000080000007D0000001B00000001001B00010001000100000001000000000008000100D80001007D00010001004000080008001B00000008000000570140000800000040001B000000080008000000080008007D001B00000000000000080040000100000000000800400001000100000001004000000000000800080040000800010001000000010008000800000000004000010000007D0008000100000040000000080000001B00400008000000080000001B000100000000000800080000000000000008000100D8000000000001001B000800000000000100080000001B0001000000080008001B000000010008001B0008000000D8000000400000007D0001000800080001001B000100080008000000080001004000010008000800080000000000010001001B001B00000001001B00400001000800080001007D000000080000000100010001000000080040000800010000000000000000000000080001000800080008000100080008001B0000007D0001001B00010000007D0000000000010001007D000000000001007D00"> : tensor<20x30xui16>
    return %0 : tensor<20x30xui16>
  }
}
