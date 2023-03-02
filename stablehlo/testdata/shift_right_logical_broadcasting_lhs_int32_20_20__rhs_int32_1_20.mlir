// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi32>, tensor<1x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.broadcast_in_dim %0#1, dims = [0, 1] : (tensor<1x20xi32>) -> tensor<20x20xi32>
    %3 = stablehlo.shift_right_logical %0#0, %2 : tensor<20x20xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi32>, tensor<1x20xi32>) {
    %0 = stablehlo.constant dense<"0x0100000000000000FEFFFFFF00000000FFFFFFFFFAFFFFFF0000000001000000000000000100000003000000FCFFFFFF0000000006000000FEFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000F8FFFFFFFFFFFFFF00000000000000000200000000000000FCFFFFFFFEFFFFFF02000000FAFFFFFF02000000FEFFFFFF02000000F9FFFFFFFEFFFFFFFDFFFFFFFDFFFFFF0200000002000000FEFFFFFF0000000004000000FFFFFFFF01000000000000000100000000000000FEFFFFFF04000000FEFFFFFFFEFFFFFF0000000001000000000000000000000000000000F9FFFFFF00000000FEFFFFFF010000000500000000000000FFFFFFFFFCFFFFFFFDFFFFFF01000000010000000100000000000000010000000000000000000000FFFFFFFFFFFFFFFF010000000000000000000000FFFFFFFF0100000000000000FFFFFFFF03000000FFFFFFFF00000000FDFFFFFF00000000FCFFFFFF01000000FEFFFFFF0000000000000000FEFFFFFF010000000200000005000000FBFFFFFF0000000004000000FAFFFFFF010000000000000000000000FDFFFFFFFEFFFFFFFFFFFFFF03000000FFFFFFFF06000000FEFFFFFF03000000FCFFFFFF00000000000000000000000004000000FFFFFFFF0200000000000000FEFFFFFFFEFFFFFF0100000001000000FDFFFFFF00000000000000000000000003000000FDFFFFFFFCFFFFFF01000000FFFFFFFF03000000FFFFFFFF00000000020000000000000002000000FEFFFFFF06000000010000000200000003000000FEFFFFFF0200000004000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF01000000FEFFFFFFFEFFFFFF0200000004000000FFFFFFFF000000000100000002000000FDFFFFFFFBFFFFFF030000000000000004000000FFFFFFFFFFFFFFFF0200000001000000FDFFFFFF0400000000000000FCFFFFFFFFFFFFFF03000000FFFFFFFF05000000FEFFFFFF05000000FDFFFFFF0000000000000000F8FFFFFF01000000FEFFFFFFFCFFFFFFFEFFFFFFFBFFFFFF0100000002000000020000000000000003000000FFFFFFFF000000000200000003000000030000000400000000000000FEFFFFFFFEFFFFFFF9FFFFFF0300000005000000010000000000000007000000FEFFFFFF0000000000000000FEFFFFFFFBFFFFFF07000000020000000500000000000000010000000000000001000000FFFFFFFF0000000002000000FAFFFFFFFFFFFFFFFFFFFFFF01000000FBFFFFFF0400000002000000FFFFFFFF00000000050000000000000001000000030000000300000000000000010000000000000000000000000000000300000004000000FBFFFFFFFEFFFFFF0400000000000000FEFFFFFFFCFFFFFFFEFFFFFF0100000002000000FCFFFFFF020000000200000000000000FEFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF01000000FBFFFFFF01000000FBFFFFFF02000000FBFFFFFF0200000004000000FFFFFFFF000000000300000002000000000000000200000000000000FFFFFFFFFBFFFFFFFFFFFFFF0300000000000000FDFFFFFFFDFFFFFFFDFFFFFF00000000020000000000000000000000FAFFFFFF00000000FCFFFFFFFFFFFFFFFCFFFFFF05000000FCFFFFFF0000000000000000FBFFFFFFFDFFFFFF05000000000000000700000001000000FDFFFFFFFCFFFFFFFFFFFFFFFCFFFFFF000000000100000000000000FBFFFFFFFDFFFFFFFEFFFFFF00000000000000000000000000000000FFFFFFFF0400000007000000FCFFFFFFFAFFFFFF02000000FEFFFFFFFDFFFFFF0300000004000000F9FFFFFFFFFFFFFFFEFFFFFF04000000FFFFFFFF000000000000000004000000FFFFFFFF00000000010000000000000005000000FEFFFFFFFFFFFFFF00000000010000000100000000000000010000000200000000000000020000000000000002000000010000000000000001000000040000000000000000000000FEFFFFFFFDFFFFFFFEFFFFFF020000000100000001000000FFFFFFFF00000000FBFFFFFF020000000100000002000000FEFFFFFFFEFFFFFFFAFFFFFF06000000FAFFFFFF010000000000000000000000FEFFFFFFFDFFFFFFFCFFFFFFFDFFFFFF000000000100000000000000FFFFFFFF0000000004000000FBFFFFFFFBFFFFFF00000000FFFFFFFF0500000002000000FFFFFFFFFAFFFFFF00000000FCFFFFFFFFFFFFFF0100000001000000"> : tensor<20x20xi32>
    %1 = stablehlo.constant dense<[[-1, 1, 5, 1, -3, 3, -3, -3, 0, -1, 0, -1, 0, 0, 0, -3, 0, 5, 0, 2]]> : tensor<1x20xi32>
    return %0, %1 : tensor<20x20xi32>, tensor<1x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x0000000000000000FFFFFF070000000000000000FFFFFF1F0000000000000000000000000000000003000000000000000000000006000000FEFFFFFF00000000FFFFFFFF00000000000000000000000000000000FFFFFF7F0000000000000000000000000000000000000000000000000200000000000000020000000000000002000000F9FFFFFFFEFFFFFF00000000FDFFFFFF0000000002000000FFFFFF3F0000000002000000FFFFFF0700000000000000000000000000000000000000000400000000000000FEFFFFFF0000000001000000000000000000000000000000F9FFFFFF00000000FEFFFFFF000000000000000000000000FFFFFF07FEFFFF7F0000000000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF010000000000000000000000FFFFFF0701000000000000000000000001000000FFFFFF070000000000000000000000000000000000000000FEFFFFFF000000000000000000000000010000000200000005000000000000000000000000000000FAFFFFFF000000000000000000000000FFFFFF07FFFFFF7F00000000000000000000000000000000FEFFFFFF00000000FCFFFFFF00000000000000000000000004000000000000000200000000000000FEFFFFFFFFFFFF3F0000000000000000FFFFFF070000000000000000000000000000000000000000FCFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000020000000000000002000000FFFFFF0706000000000000000000000001000000FFFFFF070100000000000000FFFFFF1F0000000000000000FFFFFFFF000000000100000000000000FEFFFFFF020000000400000000000000000000000000000002000000FFFFFF3F0000000001000000000000000200000000000000FFFFFF1F0000000000000000FDFFFFFF000000000000000000000000FFFFFFFF03000000FFFFFFFF00000000FEFFFFFF00000000FDFFFFFF0000000000000000FCFFFF7F00000000FFFFFF7F00000000FFFFFF1F000000000000000002000000000000000000000000000000FFFFFFFF000000000200000000000000030000000000000000000000FFFFFF3F00000000FCFFFF7F0000000002000000000000000000000000000000000000000000000000000000FEFFFFFF0000000007000000020000000500000000000000010000000000000001000000FFFFFF3F0000000001000000FFFFFF07FFFFFF7F00000000000000000000000000000000020000000000000000000000000000000000000001000000030000000000000000000000000000000000000000000000000000000100000000000000FDFFFF7F00000000000000000000000000000000FCFFFFFF000000000100000000000000FCFFFFFF020000000200000000000000FEFFFFFFFFFFFF07FEFFFFFFFFFFFF3F00000000FDFFFF7F00000000FDFFFF7F00000000FFFFFF1F0000000000000000FFFFFFFF00000000030000000000000000000000020000000000000000000000FBFFFFFFFFFFFF07030000000000000000000000FEFFFF7FFFFFFF0700000000000000000000000000000000000000000000000000000000FFFFFFFF0000000005000000FCFFFFFF0000000000000000FBFFFFFFFFFFFF0705000000000000000000000000000000FFFFFF07FEFFFF7F00000000FFFFFF1F00000000000000000000000000000000FDFFFFFF0000000000000000000000000000000000000000FFFFFFFF0000000007000000FFFFFF3F0000000001000000FFFFFF07FEFFFF7F00000000000000000000000000000000FEFFFFFF00000000FFFFFFFF000000000000000004000000FFFFFFFF00000000010000000000000005000000FFFFFF3F0000000000000000000000000000000000000000000000000000000000000000020000000000000002000000000000000000000001000000040000000000000000000000FFFFFF07FDFFFFFFFFFFFF3F000000000000000000000000FFFFFF7F00000000FFFFFF1F00000000000000000200000000000000FEFFFFFF0000000006000000FAFFFFFF010000000000000000000000FFFFFF07FDFFFFFFFFFFFF3F0000000000000000000000000000000000000000000000000000000000000000FBFFFFFF00000000FFFFFFFF0000000002000000FFFFFFFFFAFFFFFF00000000FCFFFFFFFFFFFF070100000000000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
