// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xi32>, tensor<1xi32>)
    %2 = call @expected() : () -> tensor<1x125xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<1x125xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xi32>, tensor<1x125xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xi32>, tensor<1xi32>) {
    %0 = stablehlo.constant dense<"0x00000000030000000100000001000000FDFFFFFFFDFFFFFF0200000003000000020000000200000001000000FEFFFFFF0200000001000000FDFFFFFFF9FFFFFF01000000FFFFFFFF02000000000000000100000002000000FAFFFFFF00000000FDFFFFFF05000000FEFFFFFF0000000002000000FFFFFFFFFCFFFFFF0300000000000000FEFFFFFF0000000004000000000000000600000003000000000000000100000000000000010000000100000000000000FEFFFFFFFAFFFFFF000000000200000005000000000000000000000000000000FAFFFFFF05000000FCFFFFFFFFFFFFFF01000000FFFFFFFF0000000003000000FEFFFFFFFEFFFFFFFFFFFFFF03000000FDFFFFFF01000000FBFFFFFF00000000FCFFFFFF06000000FEFFFFFF0000000000000000FDFFFFFF00000000FDFFFFFF0400000002000000FCFFFFFF0100000002000000FEFFFFFF0200000000000000FEFFFFFF0100000002000000FFFFFFFF00000000FFFFFFFF00000000FEFFFFFF01000000FFFFFFFFFFFFFFFFFDFFFFFFFCFFFFFFFFFFFFFF02000000010000000000000004000000FDFFFFFF0300000007000000000000000000000000000000FFFFFFFFF9FFFFFF0100000004000000FFFFFFFF02000000FFFFFFFF0000000000000000030000000000000000000000FFFFFFFFFDFFFFFF02000000FCFFFFFF"> : tensor<1x125xi32>
    %1 = stablehlo.constant dense<-4> : tensor<1xi32>
    return %0, %1 : tensor<1x125xi32>, tensor<1xi32>
  }
  func.func private @expected() -> tensor<1x125xi32> {
    %0 = stablehlo.constant dense<"0xFCFFFFFF030000000100000001000000FDFFFFFFFDFFFFFF0200000003000000020000000200000001000000FEFFFFFF0200000001000000FDFFFFFFF9FFFFFF01000000FFFFFFFF02000000000000000100000002000000FAFFFFFF00000000FDFFFFFF05000000FEFFFFFF0000000002000000FFFFFFFFFCFFFFFF0300000000000000FEFFFFFF0000000004000000000000000600000003000000000000000100000000000000010000000100000000000000FEFFFFFFFAFFFFFF000000000200000005000000000000000000000000000000FAFFFFFF05000000FCFFFFFFFFFFFFFF01000000FFFFFFFF0000000003000000FEFFFFFFFEFFFFFFFFFFFFFF03000000FDFFFFFF01000000FBFFFFFF00000000FCFFFFFF06000000FEFFFFFF0000000000000000FDFFFFFF00000000FDFFFFFF0400000002000000FCFFFFFF0100000002000000FEFFFFFF0200000000000000FEFFFFFF0100000002000000FFFFFFFF00000000FFFFFFFF00000000FEFFFFFF01000000FFFFFFFFFFFFFFFFFDFFFFFFFCFFFFFFFFFFFFFF02000000010000000000000004000000FDFFFFFF0300000007000000000000000000000000000000FFFFFFFFF9FFFFFF0100000004000000FFFFFFFF02000000FFFFFFFF0000000000000000030000000000000000000000FFFFFFFFFDFFFFFF02000000FCFFFFFF"> : tensor<1x125xi32>
    return %0 : tensor<1x125xi32>
  }
}

