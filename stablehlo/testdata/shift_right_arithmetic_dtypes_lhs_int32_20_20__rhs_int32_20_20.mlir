// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi32>, tensor<20x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.shift_right_arithmetic %0#0, %0#1 : tensor<20x20xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi32>, tensor<20x20xi32>) {
    %0 = stablehlo.constant dense<"0x0000000000000000FDFFFFFF0000000004000000FEFFFFFF03000000010000000000000001000000000000000200000000000000FBFFFFFF03000000FFFFFFFF0100000001000000000000000000000003000000030000000100000003000000FFFFFFFFFEFFFFFF020000000100000001000000FCFFFFFFFCFFFFFF01000000010000000200000000000000FFFFFFFF0000000001000000FEFFFFFF0100000003000000010000000100000000000000010000000000000002000000050000000100000000000000FEFFFFFF0300000005000000FCFFFFFFFEFFFFFFFCFFFFFF0200000003000000FFFFFFFFFEFFFFFF0000000000000000F9FFFFFFFFFFFFFF00000000FFFFFFFFFBFFFFFF010000000200000004000000000000000000000004000000FAFFFFFF00000000000000000000000000000000FFFFFFFF0000000000000000FCFFFFFF000000000200000001000000FBFFFFFF00000000FEFFFFFF01000000FFFFFFFF03000000FEFFFFFF00000000FDFFFFFF00000000FFFFFFFF02000000FEFFFFFFFBFFFFFF02000000FFFFFFFF0300000004000000000000000400000002000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFF02000000FFFFFFFF0200000000000000FDFFFFFF020000000000000000000000FDFFFFFFFDFFFFFFFFFFFFFF05000000FEFFFFFF00000000FEFFFFFFFCFFFFFF0000000001000000FCFFFFFF00000000000000000000000000000000FCFFFFFF02000000F8FFFFFFFFFFFFFF0000000000000000FFFFFFFF04000000000000000000000003000000FCFFFFFF01000000FFFFFFFF02000000FCFFFFFF00000000FEFFFFFF02000000000000000100000000000000FCFFFFFFFDFFFFFF01000000F9FFFFFFFFFFFFFF06000000010000000000000001000000000000000000000000000000FCFFFFFF0300000000000000FCFFFFFF0100000004000000080000000500000000000000FEFFFFFF04000000FCFFFFFF0000000000000000010000000200000003000000FCFFFFFFFEFFFFFFFFFFFFFF01000000FDFFFFFF00000000FFFFFFFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FEFFFFFF00000000000000000000000000000000FDFFFFFFFEFFFFFF00000000010000000700000004000000000000000100000002000000030000000100000003000000FCFFFFFFFFFFFFFF04000000FEFFFFFFFCFFFFFFF8FFFFFF00000000FEFFFFFFFEFFFFFF03000000FFFFFFFF0300000001000000FDFFFFFF01000000FDFFFFFF02000000000000000500000005000000000000000000000000000000FFFFFFFF010000000100000001000000FBFFFFFFFEFFFFFF03000000FFFFFFFFFCFFFFFF010000000000000006000000FEFFFFFF000000000000000000000000000000000200000000000000FCFFFFFF00000000FDFFFFFF040000000100000001000000FFFFFFFF00000000000000000600000003000000FFFFFFFFFFFFFFFF0100000001000000FBFFFFFFFEFFFFFFFDFFFFFF010000000200000001000000FDFFFFFF0000000000000000FCFFFFFF000000000000000002000000000000000300000001000000030000000000000001000000FCFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF0200000004000000FFFFFFFF00000000FDFFFFFFFEFFFFFF06000000FCFFFFFF02000000000000000000000002000000FFFFFFFF070000000000000004000000000000000100000006000000000000000300000001000000FCFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFBFFFFFF040000000000000000000000FFFFFFFF00000000FDFFFFFF000000000500000002000000FEFFFFFFFFFFFFFF010000000100000001000000FBFFFFFF0300000000000000FFFFFFFFFDFFFFFF02000000000000000500000000000000FDFFFFFF0300000002000000FFFFFFFFFCFFFFFFFFFFFFFF0200000001000000FCFFFFFFFFFFFFFF06000000010000000400000002000000FFFFFFFFFEFFFFFFFFFFFFFF04000000FFFFFFFFFFFFFFFF0000000003000000FDFFFFFF01000000FFFFFFFF00000000FEFFFFFFFFFFFFFF02000000FFFFFFFF0100000001000000020000000500000000000000040000000000000000000000FEFFFFFF000000000000000006000000FDFFFFFF00000000000000000000000000000000FDFFFFFF00000000FBFFFFFF0200000003000000030000000100000002000000"> : tensor<20x20xi32>
    %1 = stablehlo.constant dense<"0x0000000000000000FEFFFFFFFEFFFFFF00000000FDFFFFFF030000000600000001000000020000000000000000000000010000000100000001000000000000000100000003000000FEFFFFFF00000000FFFFFFFFFEFFFFFFFDFFFFFF00000000FCFFFFFFFEFFFFFF0100000000000000FDFFFFFF03000000FFFFFFFFFFFFFFFFFCFFFFFF0100000001000000FCFFFFFF04000000FCFFFFFFFEFFFFFFFFFFFFFF030000000200000002000000FBFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFAFFFFFF000000000300000000000000FFFFFFFF01000000FFFFFFFFFEFFFFFFFDFFFFFF03000000FFFFFFFF0000000004000000FDFFFFFF01000000FEFFFFFFFBFFFFFF00000000FEFFFFFF010000000000000002000000FDFFFFFF000000000000000003000000FDFFFFFF03000000FFFFFFFF060000000100000000000000FDFFFFFFFEFFFFFFFFFFFFFFFEFFFFFF050000000300000001000000010000000400000004000000FFFFFFFF020000000000000003000000000000000300000004000000FCFFFFFF0600000001000000FDFFFFFF0000000000000000FCFFFFFF06000000FEFFFFFF00000000FFFFFFFF00000000FDFFFFFFFCFFFFFF00000000FEFFFFFFFCFFFFFF00000000FFFFFFFF01000000FDFFFFFFFCFFFFFFFFFFFFFF02000000FDFFFFFFFFFFFFFF0000000002000000FAFFFFFF00000000000000000000000002000000FAFFFFFFFFFFFFFFFFFFFFFF0200000000000000FEFFFFFF01000000FFFFFFFF010000000600000001000000FFFFFFFF0000000003000000FFFFFFFF04000000FCFFFFFFFEFFFFFF00000000050000000200000000000000FDFFFFFF010000000000000000000000FEFFFFFFFDFFFFFFFEFFFFFFFBFFFFFF01000000FEFFFFFF00000000010000000000000002000000FFFFFFFF00000000FCFFFFFF04000000FEFFFFFF0500000000000000FEFFFFFF02000000FAFFFFFF0400000000000000FFFFFFFF0000000002000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFF0000000001000000FFFFFFFF0000000002000000FBFFFFFF00000000FFFFFFFF00000000FDFFFFFF01000000FCFFFFFF0000000003000000010000000300000002000000FEFFFFFF00000000FDFFFFFF030000000200000004000000000000000000000000000000FFFFFFFF0200000001000000FEFFFFFF02000000020000000300000003000000050000000000000001000000FFFFFFFFFEFFFFFF04000000FFFFFFFFFFFFFFFF050000000000000003000000FFFFFFFF0300000002000000FFFFFFFF00000000FDFFFFFFFEFFFFFFFFFFFFFF000000000000000001000000FFFFFFFF0700000002000000020000000300000002000000FFFFFFFF0300000000000000FBFFFFFFFBFFFFFF0000000000000000FCFFFFFF06000000FEFFFFFF03000000FCFFFFFF0300000002000000000000000300000000000000000000000300000004000000FDFFFFFF00000000FEFFFFFF04000000FDFFFFFF06000000000000000000000003000000FCFFFFFF000000000700000001000000FEFFFFFF0400000000000000FFFFFFFF01000000FCFFFFFFFCFFFFFF0200000002000000FBFFFFFF01000000FFFFFFFFFDFFFFFF000000000000000004000000FEFFFFFF0200000000000000000000000000000000000000FDFFFFFF0600000001000000FAFFFFFF0200000005000000010000000000000000000000F8FFFFFFFFFFFFFFFCFFFFFF0000000000000000FDFFFFFF00000000FEFFFFFFFBFFFFFF00000000FDFFFFFF0000000000000000FDFFFFFFFDFFFFFF050000000000000004000000FCFFFFFF02000000F9FFFFFF00000000FDFFFFFF01000000FCFFFFFF01000000FFFFFFFF0100000004000000020000000100000000000000FFFFFFFF00000000FBFFFFFF00000000FDFFFFFF010000000000000004000000000000000300000000000000FBFFFFFF0100000001000000FFFFFFFFFCFFFFFF020000000000000000000000FBFFFFFF05000000FFFFFFFF000000000300000003000000FDFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000100000001000000FBFFFFFFFFFFFFFF02000000FFFFFFFFFEFFFFFF040000000500000001000000FCFFFFFF0100000001000000FFFFFFFFFEFFFFFFFBFFFFFFFFFFFFFF010000000000000000000000FFFFFFFF0000000003000000"> : tensor<20x20xi32>
    return %0, %1 : tensor<20x20xi32>, tensor<20x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x0000000000000000FFFFFFFF0000000004000000FFFFFFFF00000000000000000000000000000000000000000200000000000000FDFFFFFF01000000FFFFFFFF0000000000000000000000000000000000000000000000000000000003000000FFFFFFFFFFFFFFFF010000000100000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFF0000000000000000FFFFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000100000000000000FEFFFFFF0000000002000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFFFDFFFFFF010000000000000000000000000000000000000000000000FFFFFFFF00000000000000000000000000000000FFFFFFFF0000000000000000FFFFFFFF000000000000000000000000FDFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FEFFFFFF00000000FDFFFFFF00000000FFFFFFFF00000000FFFFFFFFFDFFFFFF00000000FFFFFFFF0300000000000000000000000000000002000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFF0200000000000000FEFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF05000000FFFFFFFF00000000FEFFFFFFFCFFFFFF0000000000000000FFFFFFFF00000000000000000000000000000000FFFFFFFF01000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFF04000000000000000000000000000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFF00000000FCFFFFFFFFFFFFFF06000000000000000000000000000000000000000000000000000000FFFFFFFF0000000000000000FCFFFFFF0000000001000000000000000000000000000000FFFFFFFF04000000FFFFFFFF0000000000000000000000000200000000000000FCFFFFFFFFFFFFFFFFFFFFFF01000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000000000000000000000000000FDFFFFFFFFFFFFFF00000000000000000000000004000000000000000100000000000000000000000000000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFF8FFFFFF00000000FFFFFFFFFFFFFFFF00000000FFFFFFFF0000000000000000FDFFFFFF00000000FFFFFFFF00000000000000000000000005000000000000000000000000000000FFFFFFFF010000000000000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF000000000000000006000000FFFFFFFF000000000000000000000000000000000000000000000000FFFFFFFF00000000FFFFFFFF010000000100000000000000FFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFEFFFFFFFDFFFFFF000000000000000001000000FFFFFFFF0000000000000000FFFFFFFF000000000000000001000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FDFFFFFFFEFFFFFF06000000FFFFFFFF00000000000000000000000000000000FFFFFFFF030000000000000004000000000000000000000000000000000000000300000000000000FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF040000000000000000000000FFFFFFFF00000000FDFFFFFF000000000000000000000000FFFFFFFFFFFFFFFF000000000000000000000000FDFFFFFF0000000000000000FFFFFFFFFFFFFFFF01000000000000000000000000000000FFFFFFFF0300000000000000FFFFFFFFFCFFFFFFFFFFFFFF0200000000000000FCFFFFFFFFFFFFFF03000000000000000000000000000000FFFFFFFFFEFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFF00000000FEFFFFFFFFFFFFFF00000000FFFFFFFF0000000001000000010000000200000000000000000000000000000000000000FFFFFFFF000000000000000003000000FFFFFFFF00000000000000000000000000000000FFFFFFFF00000000FDFFFFFF0200000003000000000000000100000000000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
