module {
  func.func @_Z8gcn_funciPA256_KiS1_S1_S1_PA16_S_S3_S3_S3_PA256_iPA256_S4_PA256_A16_iSA_SA_Pi(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg5: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 256, 16>}, %arg6: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 16, 16>}, %arg7: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 16, 16>}, %arg8: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 16, 16>}, %arg9: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 4, 256>}, %arg10: memref<?x256x256xi32> {amoeba.logical_transfer_shape = array<i64: 4, 256, 256>}, %arg11: memref<?x256x16xi32> {amoeba.logical_transfer_shape = array<i64: 3, 256, 16>}, %arg12: memref<?x256x16xi32> {amoeba.logical_transfer_shape = array<i64: 12, 256, 16>}, %arg13: memref<?x256x16xi32> {amoeba.logical_transfer_shape = array<i64: 3, 256, 16>}, %arg14: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 16>}) attributes {amoeba.graph_variant_id = "identity", amoeba.static_bound.arg.0 = 5 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c5_i32 = arith.constant 5 : i32
    %c1024_i32 = arith.constant 1024 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c5 = arith.constant 5 : index
    %done_writes = taskflow.task @Task_0 will_reads(%arg1, %arg9 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg9 : memref<?x256xi32>) value_inputs(%c5, %c1_i32 : index, i32) [original_read_memrefs(%arg1, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg9 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg19, %arg17, %arg15, %arg18 : i32, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256xi32>, i1>
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %7 = neura.grant_predicate %2, %6 : !neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256xi32>, i1>
        %8 = neura.grant_predicate %3, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = neura.grant_predicate %4, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %10 = neura.grant_predicate %5, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = "neura.not"(%6) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %5, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %3, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %7 to %7[%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256xi32>, i1>
        %15 = "neura.phi"(%14, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%13, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%12, %9) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%17, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %20 = "neura.add"(%19, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256xi32>)
    }
    %done_writes_0 = taskflow.task @Task_1 will_reads(%arg2, %done_writes : memref<?x256xi32>, memref<?x256xi32>) will_writes(%done_writes : memref<?x256xi32>) value_inputs(%c5, %c1_i32 : index, i32) [original_read_memrefs(%arg2, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg9 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg19, %arg17, %arg15, %arg18 : i32, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256xi32>, i1>
        %3 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %7 = neura.grant_predicate %2, %6 : !neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256xi32>, i1>
        %8 = neura.grant_predicate %3, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = neura.grant_predicate %4, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %10 = neura.grant_predicate %5, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = "neura.not"(%6) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %5, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %3, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %7 to %7[%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256xi32>, i1>
        %15 = "neura.phi"(%14, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%13, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%12, %9) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%17, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %20 = "neura.add"(%19, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256xi32>)
    }
    %done_writes_1 = taskflow.task @Task_2 will_reads(%arg3, %done_writes_0 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%done_writes_0 : memref<?x256xi32>) value_inputs(%c5, %c1_i32 : index, i32) [original_read_memrefs(%arg3, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg9 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg19, %arg17, %arg15, %arg18 : i32, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256xi32>, i1>
        %3 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %7 = neura.grant_predicate %2, %6 : !neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256xi32>, i1>
        %8 = neura.grant_predicate %3, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = neura.grant_predicate %4, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %10 = neura.grant_predicate %5, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = "neura.not"(%6) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %5, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %3, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %7 to %7[%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256xi32>, i1>
        %15 = "neura.phi"(%14, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%13, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%12, %9) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%17, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %20 = "neura.add"(%19, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256xi32>)
    }
    %done_writes_2 = taskflow.task @Task_3 will_reads(%arg4, %done_writes_1 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%done_writes_1 : memref<?x256xi32>) value_inputs(%c5, %c1_i32 : index, i32) [original_read_memrefs(%arg4, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg9 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg19, %arg17, %arg15, %arg18 : i32, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256xi32>, i1>
        %3 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %7 = neura.grant_predicate %2, %6 : !neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256xi32>, i1>
        %8 = neura.grant_predicate %3, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = neura.grant_predicate %4, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %10 = neura.grant_predicate %5, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = "neura.not"(%6) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %5, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %3, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %7 to %7[%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256xi32>, i1>
        %15 = "neura.phi"(%14, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%13, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%12, %9) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%17, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %20 = "neura.add"(%19, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%15, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256xi32>)
    }
    %done_writes_3 = taskflow.task @Task_4 will_reads(%arg1, %done_writes_2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg10 : memref<?x256x256xi32>) value_inputs(%c5, %c1024_i32 : index, i32) [original_read_memrefs(%arg1, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg10 : memref<?x256x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32) -> (memref<?x256x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg15, %arg19, %arg16, %arg17, %arg18 : memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.mul"(%5) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = "neura.div"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%2, %3, %4 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256x256xi32>)
    }
    %done_writes_4 = taskflow.task @Task_5 will_reads(%arg2, %done_writes_2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%done_writes_3 : memref<?x256x256xi32>) value_inputs(%c5, %c1024_i32 : index, i32) [original_read_memrefs(%arg2, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg10 : memref<?x256x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32) -> (memref<?x256x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg15, %arg19, %arg16, %arg17, %arg18 : memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.mul"(%5) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = "neura.div"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%2, %3, %4 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256x256xi32>)
    }
    %done_writes_5 = taskflow.task @Task_6 will_reads(%arg3, %done_writes_2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%done_writes_4 : memref<?x256x256xi32>) value_inputs(%c5, %c1024_i32 : index, i32) [original_read_memrefs(%arg3, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg10 : memref<?x256x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32) -> (memref<?x256x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg15, %arg19, %arg16, %arg17, %arg18 : memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.mul"(%5) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = "neura.div"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%2, %3, %4 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256x256xi32>)
    }
    %done_writes_6 = taskflow.task @Task_7 will_reads(%arg4, %done_writes_2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%done_writes_5 : memref<?x256x256xi32>) value_inputs(%c5, %c1024_i32 : index, i32) [original_read_memrefs(%arg4, %arg9 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg10 : memref<?x256x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32) -> (memref<?x256x256xi32>) {
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg15, %arg19, %arg16, %arg17, %arg18 : memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.mul"(%5) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = "neura.div"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%2, %3, %4 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?x256x256xi32>)
    }
    %done_writes_7 = taskflow.task @Task_8 will_reads(%arg5, %arg6, %arg11 : memref<?x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>) will_writes(%arg11 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg5, %arg6, %arg11 : memref<?x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg11 : memref<?x256x16xi32>)] : (memref<?x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x16xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x16xi32>, memref<?x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x16xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %9 = neura.grant_predicate %3, %8 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %10 = neura.grant_predicate %4, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %5, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %5, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %7, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %6, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %4, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %9 to %9[%10, %11, %12 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %19 = "neura.phi"(%18, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%17, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%16, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%15, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = neura.load_indexed [%22, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = neura.load_indexed [%21, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %25 = "neura.mul"(%23, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = neura.load_indexed [%19, %22, %20 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.add"(%26, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%19, %22, %20 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_writes_8 = taskflow.task @Task_9 will_reads(%done_writes_6, %arg5, %arg12 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>) will_writes(%arg12 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg5, %arg12 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %9 = neura.grant_predicate %3, %8 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %10 = neura.grant_predicate %4, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %5, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %4, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %5, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %7, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %9 to %9[%10, %11, %12 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %19 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%17, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%16, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%15, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = neura.load_indexed [%22, %21, %20 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = neura.load_indexed [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %25 = "neura.mul"(%23, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = neura.load_indexed [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.add"(%26, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_writes_9 = taskflow.task @Task_10 will_reads(%done_writes_6, %arg5, %done_writes_8 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_8 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg5, %arg12 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %9 = neura.grant_predicate %3, %8 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %10 = neura.grant_predicate %4, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %5, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %4, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %5, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %7, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %9 to %9[%10, %11, %12 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %19 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%17, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%16, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%15, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = neura.load_indexed [%22, %21, %20 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = neura.load_indexed [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %25 = "neura.mul"(%23, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = neura.load_indexed [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.add"(%26, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_writes_10 = taskflow.task @Task_11 will_reads(%done_writes_6, %arg5, %done_writes_9 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_9 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg5, %arg12 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %9 = neura.grant_predicate %3, %8 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %10 = neura.grant_predicate %4, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %5, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %4, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %5, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %7, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %9 to %9[%10, %11, %12 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %19 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%17, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%16, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%15, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = neura.load_indexed [%22, %21, %20 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = neura.load_indexed [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %25 = "neura.mul"(%23, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = neura.load_indexed [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.add"(%26, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_writes_11 = taskflow.task @Task_12 will_reads(%done_writes_6, %arg5, %done_writes_10 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_10 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg5, %arg12 : memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %9 = neura.grant_predicate %3, %8 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %10 = neura.grant_predicate %4, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %5, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %4, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %5, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %7, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %9 to %9[%10, %11, %12 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %19 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%17, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%16, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%15, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = neura.load_indexed [%22, %21, %20 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = neura.load_indexed [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %25 = "neura.mul"(%23, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = neura.load_indexed [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.add"(%26, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%22, %21, %19 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads:2, %done_writes_12 = taskflow.task @Task_13 will_reads(%done_writes_7, %done_writes_11 : memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%arg13 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg12 : memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg13 : memref<?x256x16xi32>)] : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: index, %arg19: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg18 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg15, %arg16, %arg19, %arg17, %arg18 : memref<?x256x16xi32>, memref<?x256x16xi32>, i32, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg20: !neura.data<memref<?x256x16xi32>, i1>, %arg21: !neura.data<memref<?x256x16xi32>, i1>, %arg22: !neura.data<i32, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%5, %7, %8 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%5, %7, %8 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%6, %7, %8 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.add"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = neura.load_indexed [%4, %7, %8 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%3, %7, %8 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %17 = "neura.add"(%15, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.icmp"(%17) <{cmpType = "sgt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %19 = "neura.sel"(%18, %17, %2) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%5, %7, %8 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg15, %arg16 : memref<?x256x16xi32>, memref<?x256x16xi32>) done_writes(%arg17 : memref<?x256x16xi32>)
    }
    %done_reads_13, %done_writes_14 = taskflow.task @Task_14 will_reads(%done_writes_12, %arg7, %done_writes_7 : memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>) will_writes(%done_reads#0 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg13, %arg7, %arg11 : memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg11 : memref<?x256x16xi32>)] : (memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = "neura.icmp"(%8) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %3, %9 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %11 = neura.grant_predicate %5, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %4, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %8, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = "neura.not"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %4, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %8, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %5, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %10 to %10[%11, %12, %13 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %22 = "neura.phi"(%21, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%17, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = neura.load_indexed [%26, %25, %24 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %28 = neura.load_indexed [%24, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = neura.load_indexed [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %31 = "neura.add"(%30, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %31 to [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg15 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_15, %done_writes_16 = taskflow.task @Task_15 will_reads(%done_writes_6, %done_writes_12, %done_writes_11 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_reads#1 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 4 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = "neura.icmp"(%8) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %3, %9 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %11 = neura.grant_predicate %4, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %5, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %8, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = "neura.not"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %5, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %8, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %4, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %10 to %10[%11, %12, %13 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %22 = "neura.phi"(%21, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%17, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = neura.load_indexed [%26, %25, %24 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %28 = neura.load_indexed [%26, %24, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = neura.load_indexed [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %31 = "neura.add"(%30, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %31 to [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_17, %done_writes_18 = taskflow.task @Task_16 will_reads(%done_writes_6, %done_writes_12, %done_writes_16 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_16 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 5 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %3, %10 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %12 = neura.grant_predicate %4, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %8, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %6, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %9, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %5, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %6, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %5, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %4, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %11 to %11[%12, %13, %14 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %25 = "neura.phi"(%24, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%23, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29, %28 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%27, %28, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = neura.load_indexed [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %35 = "neura.add"(%34, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_19, %done_writes_20 = taskflow.task @Task_17 will_reads(%done_writes_6, %done_writes_12, %done_writes_18 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_18 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 6 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %3, %10 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %12 = neura.grant_predicate %4, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %8, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %5, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %9, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %6, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %5, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %6, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %4, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %11 to %11[%12, %13, %14 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %25 = "neura.phi"(%24, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%23, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29, %28 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%27, %28, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = neura.load_indexed [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %35 = "neura.add"(%34, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_21, %done_writes_22 = taskflow.task @Task_18 will_reads(%done_writes_6, %done_writes_12, %done_writes_20 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_20 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 7 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %3, %10 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %12 = neura.grant_predicate %4, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %8, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %5, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %9, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %6, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %5, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %6, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %4, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %11 to %11[%12, %13, %14 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %25 = "neura.phi"(%24, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%23, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29, %28 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%27, %28, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = neura.load_indexed [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %35 = "neura.add"(%34, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_23:2, %done_writes_24 = taskflow.task @Task_19 will_reads(%done_writes_14, %done_writes_22, %done_writes_12 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_reads_13, %done_reads_15, %done_reads_17, %done_reads_19, %done_reads_21 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg12, %arg13 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg13 : memref<?x256x16xi32>)] : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: memref<?x256x16xi32>, %arg20: memref<?x256x16xi32>, %arg21: memref<?x256x16xi32>, %arg22: memref<?x256x16xi32>, %arg23: index, %arg24: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg23 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg15, %arg16, %arg22, %arg24, %arg23 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg25: !neura.data<memref<?x256x16xi32>, i1>, %arg26: !neura.data<memref<?x256x16xi32>, i1>, %arg27: !neura.data<memref<?x256x16xi32>, i1>, %arg28: !neura.data<i32, i1>, %arg29: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = 7 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.constant"() <{value = 6 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 5 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 4 : index}> : () -> !neura.data<index, i1>
        %7 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %8 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%8, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%6, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.add"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = neura.load_indexed [%5, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%4, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %17 = "neura.add"(%15, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%3, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %19 = "neura.add"(%17, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = neura.load_indexed [%7, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %21 = "neura.add"(%19, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.icmp"(%21) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %23 = "neura.sel"(%22, %21, %2) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %23 to [%8, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg15, %arg16 : memref<?x256x16xi32>, memref<?x256x16xi32>) done_writes(%arg22 : memref<?x256x16xi32>)
    }
    %done_reads_25, %done_writes_26 = taskflow.task @Task_20 will_reads(%done_writes_24, %arg8, %done_writes_14 : memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>) will_writes(%done_reads_23#0 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg13, %arg8, %arg11 : memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg11 : memref<?x256x16xi32>)] : (memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = "neura.icmp"(%8) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %3, %9 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %11 = neura.grant_predicate %4, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %5, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %8, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = "neura.not"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %5, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %8, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %4, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %10 to %10[%11, %12, %13 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %22 = "neura.phi"(%21, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%17, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = neura.load_indexed [%26, %25, %24 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %28 = neura.load_indexed [%24, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = neura.load_indexed [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %31 = "neura.add"(%30, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %31 to [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg15 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_27, %done_writes_28 = taskflow.task @Task_21 will_reads(%done_writes_6, %done_writes_24, %done_writes_22 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_reads_23#1 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 8 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %3, %10 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %12 = neura.grant_predicate %4, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %8, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %5, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %9, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %6, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %5, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %6, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %4, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %11 to %11[%12, %13, %14 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %25 = "neura.phi"(%24, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%23, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29, %28 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%27, %28, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = neura.load_indexed [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %35 = "neura.add"(%34, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_29, %done_writes_30 = taskflow.task @Task_22 will_reads(%done_writes_6, %done_writes_24, %done_writes_28 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_28 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 9 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = "neura.icmp"(%8) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %3, %9 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %11 = neura.grant_predicate %4, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %6, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %5, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %8, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = "neura.not"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %5, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %6, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %8, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %4, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %10 to %10[%11, %12, %13 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %22 = "neura.phi"(%21, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%17, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = neura.load_indexed [%26, %25, %24 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %28 = neura.load_indexed [%26, %24, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = neura.load_indexed [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %31 = "neura.add"(%30, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %31 to [%22, %25, %23 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_31, %done_writes_32 = taskflow.task @Task_23 will_reads(%done_writes_6, %done_writes_24, %done_writes_30 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_30 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 10 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %3, %10 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %12 = neura.grant_predicate %4, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %8, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %5, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %9, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %6, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %5, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %6, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %4, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %11 to %11[%12, %13, %14 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %25 = "neura.phi"(%24, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%23, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29, %28 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%27, %28, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = neura.load_indexed [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %35 = "neura.add"(%34, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_reads_33, %done_writes_34 = taskflow.task @Task_24 will_reads(%done_writes_6, %done_writes_24, %done_writes_32 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_writes_32 : memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg10, %arg13, %arg12 : memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg12 : memref<?x256x16xi32>)] : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>, memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %arg19 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg20, %arg18, %arg15, %arg16, %arg19 : i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %4 = "neura.constant"() <{value = 11 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %3, %10 : !neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256x16xi32>, i1>
        %12 = neura.grant_predicate %4, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %8, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %5, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %9, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %6, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %5, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %6, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %4, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %11 to %11[%12, %13, %14 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256x16xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256x16xi32>, i1>
        %25 = "neura.phi"(%24, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%23, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%20, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29, %28 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%27, %28, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = neura.load_indexed [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %35 = "neura.add"(%34, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%25, %29, %26 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_reads(%arg16 : memref<?x256x16xi32>) done_writes(%arg18 : memref<?x256x16xi32>)
    }
    %done_writes_35 = taskflow.task @Task_25 will_reads(%done_writes_26, %done_writes_34, %done_writes_24 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) will_writes(%done_reads_25, %done_reads_27, %done_reads_29, %done_reads_31, %done_reads_33 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) value_inputs(%c5, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg12, %arg13 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>), original_write_memrefs(%arg13 : memref<?x256x16xi32>)] : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32) -> (memref<?x256x16xi32>) {
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: memref<?x256x16xi32>, %arg20: memref<?x256x16xi32>, %arg21: memref<?x256x16xi32>, %arg22: memref<?x256x16xi32>, %arg23: index, %arg24: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg23 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg15, %arg16, %arg22, %arg24, %arg23 : memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg25: !neura.data<memref<?x256x16xi32>, i1>, %arg26: !neura.data<memref<?x256x16xi32>, i1>, %arg27: !neura.data<memref<?x256x16xi32>, i1>, %arg28: !neura.data<i32, i1>, %arg29: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.constant"() <{value = 11 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.constant"() <{value = 10 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.constant"() <{value = 9 : index}> : () -> !neura.data<index, i1>
        %7 = "neura.constant"() <{value = 8 : index}> : () -> !neura.data<index, i1>
        %8 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%3, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%7, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.add"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = neura.load_indexed [%6, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%5, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %17 = "neura.add"(%15, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%4, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %19 = "neura.add"(%17, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = neura.load_indexed [%8, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %21 = "neura.add"(%19, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.icmp"(%21) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %23 = "neura.sel"(%22, %21, %2) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %23 to [%3, %9, %10 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg22 : memref<?x256x16xi32>)
    }
    %done_writes_36 = taskflow.task @Task_26 will_reads(%done_writes_35, %arg14 : memref<?x256x16xi32>, memref<?xi32>) will_writes(%arg14 : memref<?xi32>) value_inputs(%c0_i32, %c5, %c5_i32 : i32, index, i32) [original_read_memrefs(%arg13, %arg14 : memref<?x256x16xi32>, memref<?xi32>), original_write_memrefs(%arg14 : memref<?xi32>)] : (memref<?x256x16xi32>, memref<?xi32>, memref<?xi32>, i32, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?xi32>, %arg17: memref<?xi32>, %arg18: i32, %arg19: index, %arg20: i32):
      %c0 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg18, %arg17, %arg15, %arg19, %arg20 : i32, memref<?xi32>, memref<?x256x16xi32>, index, i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?xi32>, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<index, i1>, %arg25: !neura.data<i32, i1>):
        %1 = "neura.grant_once"() <{constant_value = "%input1"}> : () -> !neura.data<memref<?xi32>, i1>
        %2 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.cast"(%3) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        neura.store_indexed %1 to %1[%5 : !neura.data<index, i1>] !neura.data<memref<?xi32>, i1> {amoeba.source_owned_once_init, lhs_value = "%input0"} : !neura.data<memref<?xi32>, i1>
        %6 = neura.reserve : !neura.data<index, i1>
        %7 = "neura.phi"(%6, %5) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.reserve : !neura.data<index, i1>
        %9 = "neura.phi"(%8, %2) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.reserve : !neura.data<i64, i1>
        %11 = "neura.phi"(%10, %4) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %12 = "neura.cast"(%11) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %9, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %12, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %7, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %7, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.load_indexed [%14, %15, %16 : !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %20 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %21 = "neura.add"(%20, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %21 to [%16 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %22 = "neura.add"(%15) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.cast"(%22) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %23 -> %10 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %14 -> %8 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %16 -> %6 : !neura.data<index, i1> !neura.data<index, i1>
        %24 = neura.load_indexed [%18 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %25 = "neura.div"(%24) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %25 to [%18 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg17 : memref<?xi32>)
    }
    %done_writes_37 = taskflow.task @Task_27 will_reads(%done_writes_36 : memref<?xi32>) will_writes(%done_writes_36 : memref<?xi32>) value_inputs(%c1024_i32 : i32) [original_read_memrefs(%arg14 : memref<?xi32>), original_write_memrefs(%arg14 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, i32) -> (memref<?xi32>) {
    ^bb0(%arg15: memref<?xi32>, %arg16: memref<?xi32>, %arg17: i32):
      %c0 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg16, %arg17 : memref<?xi32>, i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg18: !neura.data<memref<?xi32>, i1>, %arg19: !neura.data<i32, i1>):
        %1 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %3 = "neura.div"(%2) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %3 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input0"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg16 : memref<?xi32>)
    }
    return
  }
}

