// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi32>, tensor<1x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.broadcast_in_dim %0#1, dims = [0, 1] : (tensor<1x20xi32>) -> tensor<20x20xi32>
    %3 = stablehlo.shift_right_arithmetic %0#0, %2 : tensor<20x20xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi32>, tensor<1x20xi32>) {
    %0 = stablehlo.constant dense<"0x0200000005000000FFFFFFFF0200000002000000FFFFFFFFFDFFFFFFFCFFFFFFFAFFFFFF0300000004000000FFFFFFFFFBFFFFFFFFFFFFFFFBFFFFFF01000000FCFFFFFFFDFFFFFF06000000020000000200000001000000FDFFFFFF040000000000000000000000000000000000000000000000FDFFFFFF030000000000000001000000FFFFFFFF01000000FEFFFFFFFDFFFFFF00000000FEFFFFFFFEFFFFFF0000000003000000FCFFFFFFFDFFFFFF040000000000000003000000010000000000000000000000FEFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFF000000000000000001000000FEFFFFFFFFFFFFFF0200000002000000FCFFFFFFFBFFFFFF00000000FFFFFFFF02000000FBFFFFFFFDFFFFFF0000000002000000FFFFFFFF0100000000000000000000000000000000000000020000000200000000000000FFFFFFFFF9FFFFFFFCFFFFFFFDFFFFFF00000000FEFFFFFF000000000000000002000000FEFFFFFF0000000002000000F8FFFFFF0100000002000000FEFFFFFFFFFFFFFF00000000FAFFFFFFF9FFFFFFFFFFFFFFFFFFFFFF0000000000000000FAFFFFFF0000000000000000FCFFFFFFFDFFFFFF00000000FDFFFFFF03000000070000000000000004000000050000000100000001000000030000000000000004000000FFFFFFFFFEFFFFFFFEFFFFFF010000000300000001000000FBFFFFFF0000000000000000FFFFFFFF000000000700000002000000F8FFFFFF05000000FDFFFFFF02000000010000000000000000000000010000000500000000000000FEFFFFFF0000000001000000FBFFFFFFFBFFFFFF0000000000000000FFFFFFFFFFFFFFFFFEFFFFFF01000000FFFFFFFF0000000000000000FFFFFFFFFEFFFFFF040000000100000001000000000000000000000000000000000000000200000001000000FEFFFFFFFEFFFFFFFCFFFFFFFEFFFFFFFBFFFFFFFCFFFFFFFEFFFFFF00000000FDFFFFFFFBFFFFFF03000000FDFFFFFFFFFFFFFF010000000100000003000000FDFFFFFF0000000000000000000000000200000001000000FBFFFFFFFFFFFFFFFFFFFFFF010000000500000000000000FFFFFFFF03000000FEFFFFFF00000000FAFFFFFF050000000300000001000000FFFFFFFFFFFFFFFF02000000FFFFFFFF04000000000000000100000000000000FDFFFFFF030000000000000000000000FFFFFFFFFCFFFFFF0400000000000000000000000200000004000000FEFFFFFF00000000FDFFFFFF01000000020000000000000000000000FFFFFFFFFCFFFFFFFCFFFFFF00000000010000000000000001000000000000000100000002000000030000000200000002000000FDFFFFFFFFFFFFFF00000000FCFFFFFF01000000FFFFFFFFFFFFFFFF0000000001000000FEFFFFFF00000000000000000400000001000000FFFFFFFF02000000FEFFFFFF04000000FEFFFFFFFCFFFFFF0200000003000000FFFFFFFF000000000200000001000000FEFFFFFF00000000050000000100000000000000FFFFFFFF0400000005000000FDFFFFFF00000000FAFFFFFFFDFFFFFFFFFFFFFF0000000000000000FFFFFFFFFEFFFFFF0100000000000000010000000000000002000000FBFFFFFFFDFFFFFFFBFFFFFF00000000F6FFFFFFFFFFFFFF000000000000000001000000FFFFFFFFFDFFFFFFFEFFFFFF020000000000000000000000FFFFFFFF010000000000000002000000FFFFFFFFFEFFFFFFFBFFFFFF0300000000000000FEFFFFFF00000000FFFFFFFF0000000002000000000000000200000003000000FEFFFFFF02000000FBFFFFFF04000000000000000000000002000000FFFFFFFF00000000020000000300000000000000FFFFFFFF00000000FEFFFFFFFEFFFFFF000000000100000000000000FEFFFFFFFEFFFFFF00000000FEFFFFFF01000000FBFFFFFFFDFFFFFF0000000002000000000000000100000004000000FBFFFFFF00000000FEFFFFFFFBFFFFFFFDFFFFFF01000000FFFFFFFF01000000020000000100000001000000020000000000000002000000FEFFFFFF0200000000000000FFFFFFFFFFFFFFFF02000000FEFFFFFFFCFFFFFFFCFFFFFF020000000500000000000000FEFFFFFF070000000400000000000000040000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000000002000000FBFFFFFF01000000FEFFFFFFF9FFFFFFFCFFFFFF00000000FEFFFFFF"> : tensor<20x20xi32>
    %1 = stablehlo.constant dense<[[0, 1, 2, 0, -1, 1, -3, 1, -3, -7, 5, 0, -1, -3, -7, 2, 3, 0, 0, -2]]> : tensor<1x20xi32>
    return %0, %1 : tensor<20x20xi32>, tensor<1x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x0200000002000000FFFFFFFF0200000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFDFFFFFF06000000000000000200000000000000FFFFFFFF040000000000000000000000000000000000000000000000FFFFFFFF000000000000000000000000FFFFFFFF00000000FFFFFFFFFFFFFFFF00000000FEFFFFFFFFFFFFFF0000000001000000FFFFFFFFFDFFFFFF000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000001000000FEFFFFFFFFFFFFFF0200000001000000FFFFFFFFFBFFFFFF00000000FFFFFFFF00000000FDFFFFFFFFFFFFFF0000000000000000FFFFFFFF0000000000000000000000000000000000000000020000000200000000000000FFFFFFFFFCFFFFFFFFFFFFFFFDFFFFFF00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000002000000FFFFFFFF0000000000000000FFFFFFFFFFFFFFFF00000000FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF0000000000000000FEFFFFFFFFFFFFFF00000000FFFFFFFF03000000000000000000000000000000010000000000000001000000030000000000000004000000FFFFFFFFFFFFFFFFFEFFFFFF000000000100000000000000FDFFFFFF0000000000000000FFFFFFFF000000000000000000000000FFFFFFFF01000000FFFFFFFF02000000010000000000000000000000000000000100000000000000FFFFFFFF0000000000000000FDFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0000000000000000FFFFFFFFFFFFFFFF040000000000000000000000000000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FDFFFFFFFBFFFFFF00000000FDFFFFFFFFFFFFFF000000000100000000000000FEFFFFFF0000000000000000000000000000000000000000FBFFFFFFFFFFFFFFFFFFFFFF000000000100000000000000FFFFFFFF03000000FFFFFFFF00000000FDFFFFFF010000000300000000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF00000000000000000100000000000000FFFFFFFF000000000000000000000000FFFFFFFFFCFFFFFF0000000000000000000000000000000004000000FFFFFFFF00000000FFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000001000000000000000000000002000000010000000000000002000000FFFFFFFFFFFFFFFF00000000FEFFFFFF00000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000000000000000000001000000FFFFFFFF00000000FEFFFFFF02000000FFFFFFFFFCFFFFFF0000000001000000FFFFFFFF000000000000000000000000FFFFFFFF00000000000000000000000000000000FFFFFFFF0000000005000000FDFFFFFF00000000FAFFFFFFFEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000000000000000000002000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFFFFFFFFFF000000000000000001000000FFFFFFFFFFFFFFFFFEFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFF0000000002000000000000000000000003000000FFFFFFFF01000000FFFFFFFF02000000000000000000000000000000FFFFFFFF00000000000000000000000000000000FFFFFFFF00000000FEFFFFFFFFFFFFFF000000000000000000000000FEFFFFFFFFFFFFFF00000000FFFFFFFF00000000FFFFFFFFFFFFFFFF0000000002000000000000000000000000000000FEFFFFFF00000000FEFFFFFFFBFFFFFFFFFFFFFF01000000FFFFFFFF00000000020000000000000000000000000000000000000000000000FFFFFFFF0000000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFCFFFFFF020000000000000000000000FFFFFFFF010000000400000000000000020000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFCFFFFFF00000000FFFFFFFF"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
