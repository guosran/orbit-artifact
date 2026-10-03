module {
  func.func @_Z10radar_funciPA256_KiS1_S1_S1_PA32_S_S3_PiS4_PA256_iS6_S6_S6_S6_S6_S4_S4_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S4_(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg5: memref<?x32xi32> {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, %arg6: memref<?x32xi32> {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, %arg8: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, %arg9: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg10: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg11: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg12: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg13: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg14: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg15: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, %arg16: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, %arg17: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg18: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg19: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg20: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg21: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg22: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg23: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg24: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg25: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg26: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg27: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg28: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg29: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg30: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-6", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/radar/shape-temporal-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/radar/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 64 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_1", amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_trip_count = 8 : i64, amoeba.replica.total_trip_count = 32 : i64, amoeba.static_bound.arg.0 = 64 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c63_i32 = arith.constant 63 : i32
    %c64_i32 = arith.constant 64 : i32
    %c0_i32 = arith.constant 0 : i32
    %c32_i32 = arith.constant 32 : i32
    %c1_i32 = arith.constant 1 : i32
    %c6_i32 = arith.constant 6 : i32
    %c3_i32 = arith.constant 3 : i32
    %c64 = arith.constant 64 : index
    %done_writes = taskflow.task @Task_0.replica.0 will_reads(%arg1 : memref<?x256xi32>) will_writes(%arg7 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg1 : memref<?x256xi32>), original_write_memrefs(%arg7 : memref<?xi32>)] {amoeba.replica.count = 2 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_upper = 16 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0>], amoeba.tiling.output_region_uppers = [array<i64: 16>]} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c0_33 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %2 = taskflow.counter from %c0_33 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %c0_34 = arith.constant 0 : index
        %c16_35 = arith.constant 16 : index
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter from %c0_34 : index to %c16_35 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i64, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %13 = "neura.cast"(%12) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.add"(%17, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%16) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.cast"(%23) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %15 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        %25 = "neura.div"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %25 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_0 = taskflow.task @Task_0.replica.1 will_reads(%arg1 : memref<?x256xi32>) will_writes(%arg7 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg1 : memref<?x256xi32>), original_write_memrefs(%arg7 : memref<?xi32>)] {amoeba.replica.count = 2 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 16 : i64, amoeba.replica.shard_upper = 32 : i64, amoeba.tiling.output_region_lowers = [array<i64: 16>], amoeba.tiling.output_region_uppers = [array<i64: 32>]} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c16 = arith.constant 16 : index
      %c32_33 = arith.constant 32 : index
      %2 = taskflow.counter from %c16 to %c32_33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %c16_34 = arith.constant 16 : index
        %c32_35 = arith.constant 32 : index
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter from %c16_34 : index to %c32_35 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 16 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i64, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %13 = "neura.cast"(%12) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.add"(%17, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%16) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.cast"(%23) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %15 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        %25 = "neura.div"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %25 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %cast = memref.cast %arg7 : memref<?xi32> to memref<32xi32>
    %cast_1 = memref.cast %done_writes : memref<?xi32> to memref<32xi32>
    %cast_2 = memref.cast %done_writes_0 : memref<?xi32> to memref<32xi32>
    %0 = taskflow.join states(%cast_1, %cast_2) base(%cast) axis(0) region([0], [32]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<32xi32>
    %cast_3 = memref.cast %0 : memref<32xi32> to memref<?xi32>
    %done_writes_4 = taskflow.task @Task_1.replica.0 will_reads(%arg2 : memref<?x256xi32>) will_writes(%arg8 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg2 : memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_upper = 8 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0>], amoeba.tiling.output_region_uppers = [array<i64: 8>]} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c0_33 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %2 = taskflow.counter from %c0_33 to %c8 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %c0_34 = arith.constant 0 : index
        %c8_35 = arith.constant 8 : index
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter from %c0_34 : index to %c8_35 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i64, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %13 = "neura.cast"(%12) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.add"(%17, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%16) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.cast"(%23) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %15 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        %25 = "neura.div"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %25 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_5 = taskflow.task @Task_1.replica.1 will_reads(%arg2 : memref<?x256xi32>) will_writes(%arg8 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg2 : memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 8 : i64, amoeba.replica.shard_upper = 16 : i64, amoeba.tiling.output_region_lowers = [array<i64: 8>], amoeba.tiling.output_region_uppers = [array<i64: 16>]} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %2 = taskflow.counter from %c8 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %c8_33 = arith.constant 8 : index
        %c16_34 = arith.constant 16 : index
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter from %c8_33 : index to %c16_34 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 8 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i64, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %13 = "neura.cast"(%12) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.add"(%17, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%16) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.cast"(%23) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %15 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        %25 = "neura.div"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %25 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_6 = taskflow.task @Task_1.replica.2 will_reads(%arg2 : memref<?x256xi32>) will_writes(%arg8 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg2 : memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 16 : i64, amoeba.replica.shard_upper = 24 : i64, amoeba.tiling.output_region_lowers = [array<i64: 16>], amoeba.tiling.output_region_uppers = [array<i64: 24>]} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c16 = arith.constant 16 : index
      %c24 = arith.constant 24 : index
      %2 = taskflow.counter from %c16 to %c24 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %c16_33 = arith.constant 16 : index
        %c24_34 = arith.constant 24 : index
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter from %c16_33 : index to %c24_34 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 16 : index, step_value = 1 : index, upper_bound_value = 24 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i64, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %13 = "neura.cast"(%12) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.add"(%17, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%16) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.cast"(%23) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %15 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        %25 = "neura.div"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %25 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_7 = taskflow.task @Task_1.replica.3 will_reads(%arg2 : memref<?x256xi32>) will_writes(%arg8 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg2 : memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 24 : i64, amoeba.replica.shard_upper = 32 : i64, amoeba.tiling.output_region_lowers = [array<i64: 24>], amoeba.tiling.output_region_uppers = [array<i64: 32>]} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c24 = arith.constant 24 : index
      %c32_33 = arith.constant 32 : index
      %2 = taskflow.counter from %c24 to %c32_33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %c24_34 = arith.constant 24 : index
        %c32_35 = arith.constant 32 : index
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter from %c24_34 : index to %c32_35 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 24 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i64, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %13 = "neura.cast"(%12) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.add"(%17, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%16) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.cast"(%23) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %15 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        %25 = "neura.div"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %25 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %cast_8 = memref.cast %arg8 : memref<?xi32> to memref<32xi32>
    %cast_9 = memref.cast %done_writes_4 : memref<?xi32> to memref<32xi32>
    %cast_10 = memref.cast %done_writes_5 : memref<?xi32> to memref<32xi32>
    %cast_11 = memref.cast %done_writes_6 : memref<?xi32> to memref<32xi32>
    %cast_12 = memref.cast %done_writes_7 : memref<?xi32> to memref<32xi32>
    %1 = taskflow.join states(%cast_9, %cast_10, %cast_11, %cast_12) base(%cast_8) axis(0) region([0], [32]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<32xi32>
    %cast_13 = memref.cast %1 : memref<32xi32> to memref<?xi32>
    %done_writes_14:2 = taskflow.task @Task_2 will_reads(%arg1, %cast_3, %arg2, %cast_13 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg1, %arg7, %arg2, %arg8 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>)] {amoeba.semantic.incoming_edges = ["Task_0.replica.0|producer_consumer|tensor_wide", "Task_0.replica.1|producer_consumer|tensor_wide", "Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide", "Task_1.replica.2|producer_consumer|tensor_wide", "Task_1.replica.3|producer_consumer|tensor_wide"]} : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg37 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%5 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %8 = "neura.sub"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%5 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %11 = "neura.sub"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_15:2 = taskflow.task @Task_3 will_reads(%done_writes_14#0, %done_writes_14#1 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64, %c63_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: index, %arg36: i32, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg35 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg36, %arg37, %arg31, %arg33, %arg32, %arg34, %arg35 : i32, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %6 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %7 = "neura.sub"(%6) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.icmp"(%6, %7) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = "neura.sel"(%8, %6, %7) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.add"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %12 to [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33, %arg34 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_16 = taskflow.task @Task_4 will_reads(%done_writes_15#0, %arg3, %done_writes_15#1, %arg4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg13 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg3, %arg12, %arg4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg13 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg36, %arg37, %arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<index, i1>, %arg43: !neura.data<i32, i1>, %arg44: !neura.data<memref<?x256xi32>, i1>, %arg45: !neura.data<index, i1>):
        %4 = "neura.constant"() <{value = "%input5"}> : () -> !neura.data<i32, i1>
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.cast"(%5) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.phi"(%9, %7) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<index, i1>
        %12 = "neura.phi"(%11, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.reserve : !neura.data<i32, i1>
        %14 = "neura.phi"(%13, %4) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.reserve : !neura.data<i64, i1>
        %16 = "neura.phi"(%15, %6) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %17 = "neura.cast"(%16) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %18 = "neura.icmp"(%17) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %12, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %17, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %14, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = "neura.not"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %14, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %12, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %10, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = neura.load_indexed [%19, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %28 = neura.load_indexed [%21, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.add"(%22, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = neura.load_indexed [%19, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%21, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.sub"(%30, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.add"(%20) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.cast"(%35) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %36 -> %15 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %34 -> %13 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %19 -> %11 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %21 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        neura.store_indexed %24 to [%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_17 = taskflow.task @Task_5 will_reads(%done_writes_15#0, %arg4, %done_writes_15#1, %arg3 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg14 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg4, %arg12, %arg3 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg14 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg36, %arg37, %arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<index, i1>, %arg43: !neura.data<i32, i1>, %arg44: !neura.data<memref<?x256xi32>, i1>, %arg45: !neura.data<index, i1>):
        %4 = "neura.constant"() <{value = "%input5"}> : () -> !neura.data<i32, i1>
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.cast"(%5) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.phi"(%9, %7) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<index, i1>
        %12 = "neura.phi"(%11, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.reserve : !neura.data<i32, i1>
        %14 = "neura.phi"(%13, %4) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.reserve : !neura.data<i64, i1>
        %16 = "neura.phi"(%15, %6) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %17 = "neura.cast"(%16) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %18 = "neura.icmp"(%17) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %12, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %17, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %14, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = "neura.not"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %14, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %12, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %10, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = neura.load_indexed [%19, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %28 = neura.load_indexed [%21, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.add"(%22, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = neura.load_indexed [%19, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%21, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%30, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.add"(%20) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.cast"(%35) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %36 -> %15 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %34 -> %13 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %19 -> %11 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %21 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        neura.store_indexed %24 to [%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_18 = taskflow.task @Task_6 will_reads(%done_writes_16 : memref<?x256xi32>) will_writes(%arg15 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c32_i32 : index, i32, i32) [original_read_memrefs(%arg13 : memref<?x256xi32>), original_write_memrefs(%arg15 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %4 = neura.kernel inputs(%arg31, %arg35, %arg32, %arg33 : memref<?x256xi32>, i32, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>):
        %5 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %6 = neura.reserve : !neura.data<i32, i1>
        %7 = neura.phi_start %5, %6 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%7, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.div"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %12, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %11, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %11, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%16 : !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %20 = "neura.phi"(%19, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %20 -> %6 : !neura.data<i32, i1> !neura.data<i32, i1>
        %21 = neura.extract_predicate %8 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %22 = "neura.not"(%21) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %7, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %23 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_19 = taskflow.task @Task_7 will_reads(%done_writes_17 : memref<?x256xi32>) will_writes(%arg16 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c32_i32 : index, i32, i32) [original_read_memrefs(%arg14 : memref<?x256xi32>), original_write_memrefs(%arg16 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %4 = neura.kernel inputs(%arg31, %arg35, %arg32, %arg33 : memref<?x256xi32>, i32, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>):
        %5 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %6 = neura.reserve : !neura.data<i32, i1>
        %7 = neura.phi_start %5, %6 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%7, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.div"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %12, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %11, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %11, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%16 : !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %20 = "neura.phi"(%19, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %20 -> %6 : !neura.data<i32, i1> !neura.data<i32, i1>
        %21 = neura.extract_predicate %8 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %22 = "neura.not"(%21) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %7, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %23 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_20:2 = taskflow.task @Task_8 will_reads(%done_writes_16, %done_writes_18, %done_writes_17, %done_writes_19 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg17, %arg18 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg13, %arg15, %arg14, %arg16 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg17, %arg18 : memref<?x256xi32>, memref<?x256xi32>)] : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg37 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%4 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %8 = "neura.sub"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%4 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %11 = "neura.sub"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_21 = taskflow.task @Task_9 will_reads(%done_writes_20#0, %arg5, %done_writes_20#1, %arg6 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>) will_writes(%arg19 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg5, %arg18, %arg6 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>), original_write_memrefs(%arg19 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x32xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x32xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %5 = neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg35, %arg36 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index) iter_args_init(%arg37 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x32xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x32xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<index, i1>, %arg44: !neura.data<i32, i1>):
        %6 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %7 = neura.reserve : !neura.data<i32, i1>
        %8 = neura.phi_start %6, %7 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%8, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%11, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %17 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %18 = "neura.mul"(%16, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.sub"(%15, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.icmp"(%20) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %19, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = neura.grant_predicate %10, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %9, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = "neura.not"(%21) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %19, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %22 to [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %27 = "neura.phi"(%26, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %27 -> %7 : !neura.data<i32, i1> !neura.data<i32, i1>
        %28 = neura.extract_predicate %9 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %29 = "neura.not"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %8, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %30 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_22 = taskflow.task @Task_10 will_reads(%done_writes_20#0, %arg6, %done_writes_20#1, %arg5 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>) will_writes(%arg20 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg6, %arg18, %arg5 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>), original_write_memrefs(%arg20 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x32xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x32xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %5 = neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg35, %arg36 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index) iter_args_init(%arg37 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x32xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x32xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<index, i1>, %arg44: !neura.data<i32, i1>):
        %6 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %7 = neura.reserve : !neura.data<i32, i1>
        %8 = neura.phi_start %6, %7 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%8, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%11, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %17 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %18 = "neura.mul"(%16, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.add"(%15, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.icmp"(%20) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %19, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = neura.grant_predicate %10, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %9, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = "neura.not"(%21) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %19, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %22 to [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %27 = "neura.phi"(%26, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %27 -> %7 : !neura.data<i32, i1> !neura.data<i32, i1>
        %28 = neura.extract_predicate %9 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %29 = "neura.not"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %8, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %30 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_23 = taskflow.task @Task_11 will_reads(%done_writes_21, %done_writes_22 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg21 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg19, %arg20 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg21 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index, %arg35: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0 to %arg34 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34 : memref<?x256xi32>, memref<?x256xi32>, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %8 = "neura.icmp"(%6) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = "neura.cast"(%8) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%7) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.cast"(%10) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %12 = "neura.sub"(%6) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.sub"(%12, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.mul"(%9, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%6, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.sub"(%7) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.sub"(%16, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.mul"(%11, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.add"(%7, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%15, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_24 = taskflow.task @Task_12 will_reads(%done_writes_23 : memref<?x256xi32>) will_writes(%arg22 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21 : memref<?x256xi32>), original_write_memrefs(%arg22 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg33, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %2 : memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x256xi32>, i1>, %arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = "neura.add"(%5) {rhs_value = -2 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.add"(%5) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%6, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%5) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%6, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%5) {rhs_value = 2 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%6, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_25 = taskflow.task @Task_13 will_reads(%done_writes_23 : memref<?x256xi32>) will_writes(%arg23 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21 : memref<?x256xi32>), original_write_memrefs(%arg23 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg33, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %2 : memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x256xi32>, i1>, %arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %7 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_26 = taskflow.task @Task_14 will_reads(%done_writes_24, %done_writes_25 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg24 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg22, %arg23 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg24 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg34, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %2 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %9 = "neura.add"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_27 = taskflow.task @Task_15 will_reads(%done_writes_26 : memref<?x256xi32>) will_writes(%arg25 : memref<?x256xi32>) value_inputs(%c64, %c6_i32, %c3_i32 : index, i32, i32) [original_read_memrefs(%arg24 : memref<?x256xi32>), original_write_memrefs(%arg25 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg33, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg34, %arg35, %arg32, %2 : memref<?x256xi32>, i32, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.div"(%7) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.mul"(%8) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_28 = taskflow.task @Task_16 will_reads(%done_writes_23, %done_writes_27 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg26 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21, %arg25 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg26 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg34, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %2 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %9 = "neura.icmp"(%7, %8) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %10 = "neura.cast"(%9) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_29 = taskflow.task @Task_17 will_reads(%done_writes_23, %done_writes_28 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg27 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21, %arg26 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg27 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg34, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %2 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%5) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%6, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%7, %9) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.cast"(%10) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%5) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%6, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%7, %13) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.cast"(%14) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %16 = "neura.mul"(%11, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %18 = "neura.mul"(%17, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.mul"(%18, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_30 = taskflow.task @Task_18 will_reads(%done_writes_29, %done_writes_23 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg28 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg27, %arg21 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg28 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index, %arg35: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg34, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg35, %arg32, %arg33, %2 : memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = "neura.cast"(%8) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %10 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%10, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %12 = "neura.icmp"(%7, %11) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %13 = "neura.cast"(%12) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.load_indexed [%14, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %16 = "neura.icmp"(%7, %15) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %17 = "neura.cast"(%16) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %18 = "neura.mul"(%9, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.mul"(%18, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.mul"(%19, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_31 = taskflow.task @Task_19 will_reads(%done_writes_30 : memref<?x256xi32>) will_writes(%arg29 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg28 : memref<?x256xi32>), original_write_memrefs(%arg29 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index, %arg34: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg33, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg34, %arg32, %2 : memref<?x256xi32>, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<i32, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = "neura.cast"(%8) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%6, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_32 = taskflow.task @Task_20 will_reads(%done_writes_30 : memref<?x256xi32>) will_writes(%arg30 : memref<?xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg28 : memref<?x256xi32>), original_write_memrefs(%arg30 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %2 = arith.addi %arg33, %c-2 : index
      %3 = taskflow.counter from %c2 to %2 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %5 = neura.kernel inputs(%arg31, %arg32, %2 : memref<?x256xi32>, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>):
        %6 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %7 = neura.reserve : !neura.data<i32, i1>
        %8 = neura.phi_start %6, %7 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%10, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.add"(%8, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "sge"}> {rhs_value = 15 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %12, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %9, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %12, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%16 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %19 = "neura.phi"(%18, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %19 -> %7 : !neura.data<i32, i1> !neura.data<i32, i1>
        %20 = neura.extract_predicate %9 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %21 = "neura.not"(%20) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %8, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %22 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    return
  }
}

