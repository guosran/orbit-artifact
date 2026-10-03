module {
  func.func @_Z10radar_funciPA256_KiS1_S1_S1_PA32_S_S3_PiS4_PA256_iS6_S6_S6_S6_S6_S4_S4_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S4_(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg5: memref<?x32xi32> {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, %arg6: memref<?x32xi32> {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, %arg8: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, %arg9: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg10: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg11: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg12: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg13: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg14: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg15: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, %arg16: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, %arg17: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg18: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg19: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg20: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg21: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg22: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg23: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg24: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg25: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg26: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg27: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg28: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg29: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg30: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-13", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/radar/shape-temporal-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/radar/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 64 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_2", amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_trip_count = 512 : i64, amoeba.replica.total_trip_count = 2048 : i64, amoeba.static_bound.arg.0 = 64 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c63_i32 = arith.constant 63 : i32
    %c64_i32 = arith.constant 64 : i32
    %c0_i32 = arith.constant 0 : i32
    %c32_i32 = arith.constant 32 : i32
    %c1_i32 = arith.constant 1 : i32
    %c6_i32 = arith.constant 6 : i32
    %c3_i32 = arith.constant 3 : i32
    %c64 = arith.constant 64 : index
    %done_writes = taskflow.task @Task_0 will_reads(%arg1 : memref<?x256xi32>) will_writes(%arg7 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg1 : memref<?x256xi32>), original_write_memrefs(%arg7 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %5 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.phi"(%9, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.reserve : !neura.data<i64, i1>
        %14 = "neura.phi"(%13, %7) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %15 = "neura.cast"(%14) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %10, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %12, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %10, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.load_indexed [%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %24 = "neura.add"(%19, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.add"(%18) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.cast"(%25) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %26 -> %13 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %17 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        %27 = "neura.div"(%21) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%22 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_0 = taskflow.task @Task_1 will_reads(%arg2 : memref<?x256xi32>) will_writes(%arg8 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg2 : memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %5 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.phi"(%9, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = "neura.phi"(%11, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.reserve : !neura.data<i64, i1>
        %14 = "neura.phi"(%13, %7) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %15 = "neura.cast"(%14) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %10, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %12, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %10, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.load_indexed [%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %24 = "neura.add"(%19, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.add"(%18) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.cast"(%25) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %26 -> %13 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %24 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %17 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        %27 = "neura.div"(%21) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%22 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_1:2 = taskflow.task @Task_2.replica.0 will_reads(%arg1, %done_writes, %arg2, %done_writes_0 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg1, %arg7, %arg2, %arg8 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 64, 1, 0, 32, 1>, root = "Task_2", steps = [{after = array<i64: 0, 16, 1, 0, 32, 1>, axis = 0 : i64, before = array<i64: 0, 64, 1, 0, 32, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.output_counter_axes = array<i64: 1, 0>, amoeba.replica.output_shard_axis = 1 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 512 : i64, amoeba.replica.shard_upper = 16 : i64, amoeba.replica.total_trip_count = 2048 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>, array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 32, 16>, array<i64: 32, 16>], trip_count = 512 : i64} : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_43 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %4 = taskflow.counter from %c0_43 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %c0_44 = arith.constant 0 : index
        %c16_45 = arith.constant 16 : index
        %6 = neura.counter from %c0_44 : index to %c16_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.sub"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.sub"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_2:2 = taskflow.task @Task_2.replica.1 will_reads(%arg1, %done_writes, %arg2, %done_writes_0 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg1, %arg7, %arg2, %arg8 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 64, 1, 0, 32, 1>, root = "Task_2", steps = [{after = array<i64: 16, 32, 1, 0, 32, 1>, axis = 0 : i64, before = array<i64: 0, 64, 1, 0, 32, 1>, factor = 4 : i64, family = "replica", part = 1 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.output_counter_axes = array<i64: 1, 0>, amoeba.replica.output_shard_axis = 1 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 16 : i64, amoeba.replica.shard_trip_count = 512 : i64, amoeba.replica.shard_upper = 32 : i64, amoeba.replica.total_trip_count = 2048 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 16>, array<i64: 0, 16>], amoeba.tiling.output_region_uppers = [array<i64: 32, 32>, array<i64: 32, 32>], trip_count = 512 : i64} : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c16 = arith.constant 16 : index
      %c32_43 = arith.constant 32 : index
      %4 = taskflow.counter from %c16 to %c32_43 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %c16_44 = arith.constant 16 : index
        %c32_45 = arith.constant 32 : index
        %6 = neura.counter from %c16_44 : index to %c32_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 16 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.sub"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.sub"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_3:2 = taskflow.task @Task_2.replica.2 will_reads(%arg1, %done_writes, %arg2, %done_writes_0 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg1, %arg7, %arg2, %arg8 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 64, 1, 0, 32, 1>, root = "Task_2", steps = [{after = array<i64: 32, 48, 1, 0, 32, 1>, axis = 0 : i64, before = array<i64: 0, 64, 1, 0, 32, 1>, factor = 4 : i64, family = "replica", part = 2 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.output_counter_axes = array<i64: 1, 0>, amoeba.replica.output_shard_axis = 1 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 32 : i64, amoeba.replica.shard_trip_count = 512 : i64, amoeba.replica.shard_upper = 48 : i64, amoeba.replica.total_trip_count = 2048 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 32>, array<i64: 0, 32>], amoeba.tiling.output_region_uppers = [array<i64: 32, 48>, array<i64: 32, 48>], trip_count = 512 : i64} : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32_43 = arith.constant 32 : index
      %c48 = arith.constant 48 : index
      %4 = taskflow.counter from %c32_43 to %c48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %c32_44 = arith.constant 32 : index
        %c48_45 = arith.constant 48 : index
        %6 = neura.counter from %c32_44 : index to %c48_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 32 : index, step_value = 1 : index, upper_bound_value = 48 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.sub"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.sub"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_4:2 = taskflow.task @Task_2.replica.3 will_reads(%arg1, %done_writes, %arg2, %done_writes_0 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg1, %arg7, %arg2, %arg8 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 64, 1, 0, 32, 1>, root = "Task_2", steps = [{after = array<i64: 48, 64, 1, 0, 32, 1>, axis = 0 : i64, before = array<i64: 0, 64, 1, 0, 32, 1>, factor = 4 : i64, family = "replica", part = 3 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.output_counter_axes = array<i64: 1, 0>, amoeba.replica.output_shard_axis = 1 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 48 : i64, amoeba.replica.shard_trip_count = 512 : i64, amoeba.replica.shard_upper = 64 : i64, amoeba.replica.total_trip_count = 2048 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 48>, array<i64: 0, 48>], amoeba.tiling.output_region_uppers = [array<i64: 32, 64>, array<i64: 32, 64>], trip_count = 512 : i64} : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c48 = arith.constant 48 : index
      %c64_43 = arith.constant 64 : index
      %4 = taskflow.counter from %c48 to %c64_43 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %c48_44 = arith.constant 48 : index
        %c64_45 = arith.constant 64 : index
        %6 = neura.counter from %c48_44 : index to %c64_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 48 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.sub"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.sub"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %cast = memref.cast %arg9 : memref<?x256xi32> to memref<32x256xi32>
    %cast_5 = memref.cast %done_writes_1#0 : memref<?x256xi32> to memref<32x256xi32>
    %cast_6 = memref.cast %done_writes_2#0 : memref<?x256xi32> to memref<32x256xi32>
    %cast_7 = memref.cast %done_writes_3#0 : memref<?x256xi32> to memref<32x256xi32>
    %cast_8 = memref.cast %done_writes_4#0 : memref<?x256xi32> to memref<32x256xi32>
    %0 = taskflow.join states(%cast_5, %cast_6, %cast_7, %cast_8) base(%cast) axis(1) region([0, 0], [32, 64]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<32x256xi32>
    %cast_9 = memref.cast %0 : memref<32x256xi32> to memref<?x256xi32>
    %cast_10 = memref.cast %arg10 : memref<?x256xi32> to memref<32x256xi32>
    %cast_11 = memref.cast %done_writes_1#1 : memref<?x256xi32> to memref<32x256xi32>
    %cast_12 = memref.cast %done_writes_2#1 : memref<?x256xi32> to memref<32x256xi32>
    %cast_13 = memref.cast %done_writes_3#1 : memref<?x256xi32> to memref<32x256xi32>
    %cast_14 = memref.cast %done_writes_4#1 : memref<?x256xi32> to memref<32x256xi32>
    %1 = taskflow.join states(%cast_11, %cast_12, %cast_13, %cast_14) base(%cast_10) axis(1) region([0, 0], [32, 64]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<32x256xi32>
    %cast_15 = memref.cast %1 : memref<32x256xi32> to memref<?x256xi32>
    %done_writes_16:2 = taskflow.task @Task_3.replica.0 will_reads(%cast_9, %cast_15 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64, %c63_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 64, 1, 0, 32, 1>, root = "Task_3", steps = [{after = array<i64: 0, 32, 1, 0, 32, 1>, axis = 0 : i64, before = array<i64: 0, 64, 1, 0, 32, 1>, factor = 2 : i64, family = "replica", part = 0 : i64}]}], amoeba.replica.count = 2 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.output_counter_axes = array<i64: 1, 0>, amoeba.replica.output_shard_axis = 1 : i64, amoeba.replica.parent_task = "Task_3", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 1024 : i64, amoeba.replica.shard_upper = 32 : i64, amoeba.replica.total_trip_count = 2048 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>, array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 32, 32>, array<i64: 32, 32>], trip_count = 1024 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: index, %arg36: i32, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_43 = arith.constant 0 : index
      %c32_44 = arith.constant 32 : index
      %4 = taskflow.counter from %c0_43 to %c32_44 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg36, %arg37, %arg31, %arg33, %arg32, %arg34, %arg35 : i32, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %c0_45 = arith.constant 0 : index
        %c32_46 = arith.constant 32 : index
        %6 = neura.counter from %c0_45 : index to %c32_46 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %9 = "neura.sub"(%8) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%8, %9) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %8, %9) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %15 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%15, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %16 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33, %arg34 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_17:2 = taskflow.task @Task_3.replica.1 will_reads(%cast_9, %cast_15 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64, %c63_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 64, 1, 0, 32, 1>, root = "Task_3", steps = [{after = array<i64: 32, 64, 1, 0, 32, 1>, axis = 0 : i64, before = array<i64: 0, 64, 1, 0, 32, 1>, factor = 2 : i64, family = "replica", part = 1 : i64}]}], amoeba.replica.count = 2 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.output_counter_axes = array<i64: 1, 0>, amoeba.replica.output_shard_axis = 1 : i64, amoeba.replica.parent_task = "Task_3", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 32 : i64, amoeba.replica.shard_trip_count = 1024 : i64, amoeba.replica.shard_upper = 64 : i64, amoeba.replica.total_trip_count = 2048 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 32>, array<i64: 0, 32>], amoeba.tiling.output_region_uppers = [array<i64: 32, 64>, array<i64: 32, 64>], trip_count = 1024 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: index, %arg36: i32, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32_43 = arith.constant 32 : index
      %c64_44 = arith.constant 64 : index
      %4 = taskflow.counter from %c32_43 to %c64_44 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg36, %arg37, %arg31, %arg33, %arg32, %arg34, %arg35 : i32, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %c32_45 = arith.constant 32 : index
        %c64_46 = arith.constant 64 : index
        %6 = neura.counter from %c32_45 : index to %c64_46 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 32 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %9 = "neura.sub"(%8) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%8, %9) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %8, %9) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %15 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%15, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %16 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33, %arg34 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %cast_18 = memref.cast %arg11 : memref<?x256xi32> to memref<32x256xi32>
    %cast_19 = memref.cast %done_writes_16#0 : memref<?x256xi32> to memref<32x256xi32>
    %cast_20 = memref.cast %done_writes_17#0 : memref<?x256xi32> to memref<32x256xi32>
    %2 = taskflow.join states(%cast_19, %cast_20) base(%cast_18) axis(1) region([0, 0], [32, 64]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<32x256xi32>
    %cast_21 = memref.cast %2 : memref<32x256xi32> to memref<?x256xi32>
    %cast_22 = memref.cast %arg12 : memref<?x256xi32> to memref<32x256xi32>
    %cast_23 = memref.cast %done_writes_16#1 : memref<?x256xi32> to memref<32x256xi32>
    %cast_24 = memref.cast %done_writes_17#1 : memref<?x256xi32> to memref<32x256xi32>
    %3 = taskflow.join states(%cast_23, %cast_24) base(%cast_22) axis(1) region([0, 0], [32, 64]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<32x256xi32>
    %cast_25 = memref.cast %3 : memref<32x256xi32> to memref<?x256xi32>
    %done_writes_26 = taskflow.task @Task_4 will_reads(%cast_21, %arg3, %cast_25, %arg4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg13 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg3, %arg12, %arg4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg13 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg36, %arg37, %arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<index, i1>, %arg43: !neura.data<i32, i1>, %arg44: !neura.data<memref<?x256xi32>, i1>, %arg45: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = "%input5"}> : () -> !neura.data<i32, i1>
        %7 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %8 = "neura.cast"(%7) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<index, i1>
        %12 = "neura.phi"(%11, %9) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.reserve : !neura.data<index, i1>
        %14 = "neura.phi"(%13, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.reserve : !neura.data<i32, i1>
        %16 = "neura.phi"(%15, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = neura.reserve : !neura.data<i64, i1>
        %18 = "neura.phi"(%17, %8) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %19 = "neura.cast"(%18) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %20 = "neura.icmp"(%19) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %14, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %19, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %16, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = "neura.not"(%20) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %16, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %14, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = neura.grant_predicate %12, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = neura.load_indexed [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%24, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = neura.load_indexed [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %34 = neura.load_indexed [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %35 = "neura.mul"(%33, %34) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.sub"(%32, %35) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.add"(%22) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.cast"(%37) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %38 -> %17 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %36 -> %15 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %21 -> %13 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %23 -> %11 : !neura.data<index, i1> !neura.data<index, i1>
        neura.store_indexed %26 to [%27, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_27 = taskflow.task @Task_5 will_reads(%cast_21, %arg4, %cast_25, %arg3 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg14 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg4, %arg12, %arg3 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg14 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg36, %arg37, %arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<index, i1>, %arg43: !neura.data<i32, i1>, %arg44: !neura.data<memref<?x256xi32>, i1>, %arg45: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = "%input5"}> : () -> !neura.data<i32, i1>
        %7 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %8 = "neura.cast"(%7) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<index, i1>
        %12 = "neura.phi"(%11, %9) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.reserve : !neura.data<index, i1>
        %14 = "neura.phi"(%13, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.reserve : !neura.data<i32, i1>
        %16 = "neura.phi"(%15, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = neura.reserve : !neura.data<i64, i1>
        %18 = "neura.phi"(%17, %8) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %19 = "neura.cast"(%18) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %20 = "neura.icmp"(%19) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %14, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %19, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %16, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = "neura.not"(%20) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %16, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %14, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = neura.grant_predicate %12, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = neura.load_indexed [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%24, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = neura.load_indexed [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %34 = neura.load_indexed [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %35 = "neura.mul"(%33, %34) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.add"(%32, %35) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.add"(%22) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.cast"(%37) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %38 -> %17 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %36 -> %15 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %21 -> %13 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %23 -> %11 : !neura.data<index, i1> !neura.data<index, i1>
        neura.store_indexed %26 to [%27, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_28 = taskflow.task @Task_6 will_reads(%done_writes_26 : memref<?x256xi32>) will_writes(%arg15 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c32_i32 : index, i32, i32) [original_read_memrefs(%arg13 : memref<?x256xi32>), original_write_memrefs(%arg15 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg31, %arg35, %arg32, %arg33 : memref<?x256xi32>, i32, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>):
        %7 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %8 = neura.reserve : !neura.data<i32, i1>
        %9 = neura.phi_start %7, %8 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.add"(%9, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.div"(%13) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %14, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %10, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %13, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %13, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%18 : !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %22 = "neura.phi"(%21, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %22 -> %8 : !neura.data<i32, i1> !neura.data<i32, i1>
        %23 = neura.extract_predicate %10 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %24 = "neura.not"(%23) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %9, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %25 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_29 = taskflow.task @Task_7 will_reads(%done_writes_27 : memref<?x256xi32>) will_writes(%arg16 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c32_i32 : index, i32, i32) [original_read_memrefs(%arg14 : memref<?x256xi32>), original_write_memrefs(%arg16 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg31, %arg35, %arg32, %arg33 : memref<?x256xi32>, i32, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>):
        %7 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %8 = neura.reserve : !neura.data<i32, i1>
        %9 = neura.phi_start %7, %8 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.add"(%9, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.div"(%13) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %14, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %10, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %13, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %13, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%18 : !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %22 = "neura.phi"(%21, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %22 -> %8 : !neura.data<i32, i1> !neura.data<i32, i1>
        %23 = neura.extract_predicate %10 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %24 = "neura.not"(%23) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %9, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %25 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_30:2 = taskflow.task @Task_8 will_reads(%done_writes_26, %done_writes_28, %done_writes_27, %done_writes_29 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg17, %arg18 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg13, %arg15, %arg14, %arg16 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg17, %arg18 : memref<?x256xi32>, memref<?x256xi32>)] : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg37 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%6 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.sub"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%6 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.sub"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_31 = taskflow.task @Task_9 will_reads(%done_writes_30#0, %arg5, %done_writes_30#1, %arg6 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>) will_writes(%arg19 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg5, %arg18, %arg6 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>), original_write_memrefs(%arg19 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x32xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x32xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %7 = neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg35, %arg36 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index) iter_args_init(%arg37 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x32xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x32xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<index, i1>, %arg44: !neura.data<i32, i1>):
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %14 = neura.load_indexed [%13, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%14, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%10, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%13, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %20 = "neura.mul"(%18, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.sub"(%17, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.add"(%13) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.icmp"(%22) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %21, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %12, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %11, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = "neura.not"(%23) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %21, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %24 to [%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %29 = "neura.phi"(%28, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %29 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %30 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %31 = "neura.not"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %10, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %32 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_32 = taskflow.task @Task_10 will_reads(%done_writes_30#0, %arg6, %done_writes_30#1, %arg5 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>) will_writes(%arg20 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg6, %arg18, %arg5 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>), original_write_memrefs(%arg20 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x32xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x32xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %7 = neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg35, %arg36 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index) iter_args_init(%arg37 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x32xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x32xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<index, i1>, %arg44: !neura.data<i32, i1>):
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %14 = neura.load_indexed [%13, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%14, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%10, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%13, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %20 = "neura.mul"(%18, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.add"(%17, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.add"(%13) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.icmp"(%22) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %21, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %12, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %11, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = "neura.not"(%23) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %21, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %24 to [%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %29 = "neura.phi"(%28, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %29 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %30 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %31 = "neura.not"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %10, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %32 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_33 = taskflow.task @Task_11 will_reads(%done_writes_31, %done_writes_32 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg21 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg19, %arg20 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg21 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index, %arg35: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg34 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34 : memref<?x256xi32>, memref<?x256xi32>, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%8) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.cast"(%10) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %12 = "neura.icmp"(%9) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %13 = "neura.cast"(%12) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %14 = "neura.sub"(%8) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.sub"(%14, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.mul"(%11, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%8, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.sub"(%9) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.sub"(%18, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.mul"(%13, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.add"(%9, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.add"(%17, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %22 to [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_34 = taskflow.task @Task_12 will_reads(%done_writes_33 : memref<?x256xi32>) will_writes(%arg22 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21 : memref<?x256xi32>), original_write_memrefs(%arg22 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg33, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %4 : memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x256xi32>, i1>, %arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = "neura.add"(%7) {rhs_value = -2 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%8, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.add"(%10, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.load_indexed [%8, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %16 = "neura.add"(%13, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%7) {rhs_value = 2 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%8, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %19 = "neura.add"(%16, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_35 = taskflow.task @Task_13 will_reads(%done_writes_33 : memref<?x256xi32>) will_writes(%arg23 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21 : memref<?x256xi32>), original_write_memrefs(%arg23 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg33, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %4 : memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x256xi32>, i1>, %arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = "neura.add"(%8) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.add"(%10, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_36 = taskflow.task @Task_14 will_reads(%done_writes_34, %done_writes_35 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg24 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg22, %arg23 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg24 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg34, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_37 = taskflow.task @Task_15 will_reads(%done_writes_36 : memref<?x256xi32>) will_writes(%arg25 : memref<?x256xi32>) value_inputs(%c64, %c6_i32, %c3_i32 : index, i32, i32) [original_read_memrefs(%arg24 : memref<?x256xi32>), original_write_memrefs(%arg25 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg33, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg34, %arg35, %arg32, %4 : memref<?x256xi32>, i32, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.div"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.mul"(%10) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_38 = taskflow.task @Task_16 will_reads(%done_writes_33, %done_writes_37 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg26 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21, %arg25 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg26 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg34, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %11 = "neura.icmp"(%9, %10) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %12 = "neura.cast"(%11) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %12 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_39 = taskflow.task @Task_17 will_reads(%done_writes_33, %done_writes_38 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg27 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21, %arg26 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg27 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg34, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%8, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.icmp"(%9, %11) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %13 = "neura.cast"(%12) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.load_indexed [%8, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %16 = "neura.icmp"(%9, %15) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %17 = "neura.cast"(%16) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %18 = "neura.mul"(%13, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %20 = "neura.mul"(%19, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.mul"(%20, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %21 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_40 = taskflow.task @Task_18 will_reads(%done_writes_39, %done_writes_33 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg28 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg27, %arg21 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg28 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index, %arg35: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg34, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg35, %arg32, %arg33, %4 : memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.cast"(%10) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%8) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%9, %13) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.cast"(%14) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%8) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%16, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %18 = "neura.icmp"(%9, %17) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %19 = "neura.cast"(%18) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %20 = "neura.mul"(%11, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.mul"(%20, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.mul"(%21, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %22 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_41 = taskflow.task @Task_19 will_reads(%done_writes_40 : memref<?x256xi32>) will_writes(%arg29 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg28 : memref<?x256xi32>), original_write_memrefs(%arg29 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index, %arg34: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg33, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg34, %arg32, %4 : memref<?x256xi32>, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<i32, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.cast"(%10) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_42 = taskflow.task @Task_20 will_reads(%done_writes_40 : memref<?x256xi32>) will_writes(%arg30 : memref<?xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg28 : memref<?x256xi32>), original_write_memrefs(%arg30 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %4 = arith.addi %arg33, %c-2 : index
      %5 = taskflow.counter from %c2 to %4 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %7 = neura.kernel inputs(%arg31, %arg32, %4 : memref<?x256xi32>, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>):
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%10, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "sge"}> {rhs_value = 15 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %14, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %11, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %14, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%18 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %21 = "neura.phi"(%20, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %21 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %22 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %23 = "neura.not"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %10, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %24 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    return
  }
}

