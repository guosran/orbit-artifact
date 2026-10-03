module attributes {amoeba.lu_affine_repair_input_status = "malformed-determinant-carry", amoeba.lu_affine_repair_pass = "repair-lu-affine-determinant-carry-v1", amoeba.lu_affine_repair_reason = "inserted determinant carry load and rewired product", amoeba.lu_affine_repair_source_file = "${ARTIFACT_ROOT}/.work/amoeba-test/Evaluation/LU/lu_func.cpp", amoeba.lu_affine_repair_source_verified = true, amoeba.lu_affine_repair_status = "repaired"} {
  func.func @_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_(%arg0: i32, %arg1: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg2: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg3: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg4: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg5: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg6: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg8: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg9: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-5", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/lu/shape-temporal-replica-tiling-source-corrected-v1-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/lu/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 8 : i64, amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_0", amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.static_bound.arg.0 = 8 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c8_i32 = arith.constant 8 : i32
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c1024_i32 = arith.constant 1024 : i32
    %c-1_i32 = arith.constant -1 : i32
    %c-1024_i32 = arith.constant -1024 : i32
    %0 = arith.index_cast %c8_i32 : i32 to index
    %cast = memref.cast %arg3 : memref<?x100xi32> to memref<8x100xi32>
    %done_writes = taskflow.task @Task_0.replica.0 will_reads(%arg1 : memref<?x100xi32>) will_writes(%arg3 : memref<?x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 0, 2, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 2 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 2, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<?x100xi32>, index) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_20 = arith.constant 0 : index
      %c2 = arith.constant 2 : index
      %4 = taskflow.counter from %c0_20 to %c2 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_21 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_21 to %c8 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<?x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c0_22 = arith.constant 0 : index
        %c2_23 = arith.constant 2 : index
        %6 = neura.counter from %c0_22 : index to %c2_23 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 2 : index} -> !neura.data<index, i1>
        %c0_24 = arith.constant 0 : index
        %c8_25 = arith.constant 8 : index
        %7 = neura.counter from %c0_24 : index to %c8_25 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %11 to [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %cast_0 = memref.cast %arg3 : memref<?x100xi32> to memref<8x100xi32>
    %done_writes_1 = taskflow.task @Task_0.replica.1.tile.1.0 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_0 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_0 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 2, 4, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 1 : i64}, {after = array<i64: 2, 4, 1, 0, 4, 1>, axis = 1 : i64, before = array<i64: 2, 4, 1, 0, 8, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 0, 4>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 8>, amoeba.neura.tiling.parent_task = "Task_0.replica.1", amoeba.neura.tiling.part_index = 0 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 2 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 4 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 2, 0>], amoeba.tiling.output_region_uppers = [array<i64: 4, 4>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c4 = arith.constant 4 : index
      %c2_20 = arith.constant 2 : index
      %c4_21 = arith.constant 4 : index
      %4 = taskflow.counter from %c2_20 to %c4_21 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_22 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c0_23 = arith.constant 0 : index
      %c4_24 = arith.constant 4 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_23 to %c4_24 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c2_25 = arith.constant 2 : index
        %c4_26 = arith.constant 4 : index
        %c2_27 = arith.constant 2 : index
        %c4_28 = arith.constant 4 : index
        %6 = neura.counter from %c2_27 : index to %c4_28 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = 4 : index} -> !neura.data<index, i1>
        %c0_29 = arith.constant 0 : index
        %c8_30 = arith.constant 8 : index
        %c0_31 = arith.constant 0 : index
        %c4_32 = arith.constant 4 : index
        %7 = neura.counter from %c0_31 : index to %c4_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 4 : index} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %11 to [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %done_writes_2 = taskflow.task @Task_0.replica.1.tile.1.1 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_0 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_0 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 2, 4, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 1 : i64}, {after = array<i64: 2, 4, 1, 4, 8, 1>, axis = 1 : i64, before = array<i64: 2, 4, 1, 0, 8, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 4, 8>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 8>, amoeba.neura.tiling.parent_task = "Task_0.replica.1", amoeba.neura.tiling.part_index = 1 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 2 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 4 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 2, 4>], amoeba.tiling.output_region_uppers = [array<i64: 4, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c4 = arith.constant 4 : index
      %c2_20 = arith.constant 2 : index
      %c4_21 = arith.constant 4 : index
      %4 = taskflow.counter from %c2_20 to %c4_21 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_22 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c4_23 = arith.constant 4 : index
      %c8_24 = arith.constant 8 : index
      %5 = taskflow.counter parent(%4 : index) from %c4_23 to %c8_24 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c2_25 = arith.constant 2 : index
        %c4_26 = arith.constant 4 : index
        %c2_27 = arith.constant 2 : index
        %c4_28 = arith.constant 4 : index
        %6 = neura.counter from %c2_27 : index to %c4_28 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = 4 : index} -> !neura.data<index, i1>
        %c0_29 = arith.constant 0 : index
        %c8_30 = arith.constant 8 : index
        %c4_31 = arith.constant 4 : index
        %c8_32 = arith.constant 8 : index
        %7 = neura.counter from %c4_31 : index to %c8_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 4 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %11 to [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %1 = taskflow.join states(%done_writes_1, %done_writes_2) base(%cast_0) axis(1) region([2, 0], [4, 8]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<8x100xi32>
    %cast_3 = memref.cast %1 : memref<8x100xi32> to memref<?x100xi32>
    %done_writes_4 = taskflow.task @Task_0.replica.2 will_reads(%arg1 : memref<?x100xi32>) will_writes(%arg3 : memref<?x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 4, 6, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 2 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 4 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 6 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 4, 0>], amoeba.tiling.output_region_uppers = [array<i64: 6, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<?x100xi32>, index) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c4 = arith.constant 4 : index
      %c6 = arith.constant 6 : index
      %4 = taskflow.counter from %c4 to %c6 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_20 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_20 to %c8 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<?x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c4_21 = arith.constant 4 : index
        %c6_22 = arith.constant 6 : index
        %6 = neura.counter from %c4_21 : index to %c6_22 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 4 : index, step_value = 1 : index, upper_bound_value = 6 : index} -> !neura.data<index, i1>
        %c0_23 = arith.constant 0 : index
        %c8_24 = arith.constant 8 : index
        %7 = neura.counter from %c0_23 : index to %c8_24 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %11 to [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %done_writes_5 = taskflow.task @Task_0.replica.3 will_reads(%arg1 : memref<?x100xi32>) will_writes(%arg3 : memref<?x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 6, 8, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 3 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 6 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 8 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 6, 0>], amoeba.tiling.output_region_uppers = [array<i64: 8, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<?x100xi32>, index) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c6 = arith.constant 6 : index
      %c8 = arith.constant 8 : index
      %4 = taskflow.counter from %c6 to %c8 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_20 = arith.constant 0 : index
      %c8_21 = arith.constant 8 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_20 to %c8_21 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<?x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c6_22 = arith.constant 6 : index
        %c8_23 = arith.constant 8 : index
        %6 = neura.counter from %c6_22 : index to %c8_23 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 6 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %c0_24 = arith.constant 0 : index
        %c8_25 = arith.constant 8 : index
        %7 = neura.counter from %c0_24 : index to %c8_25 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %11 to [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %cast_6 = memref.cast %done_writes : memref<?x100xi32> to memref<8x100xi32>
    %cast_7 = memref.cast %cast_3 : memref<?x100xi32> to memref<8x100xi32>
    %cast_8 = memref.cast %done_writes_4 : memref<?x100xi32> to memref<8x100xi32>
    %cast_9 = memref.cast %done_writes_5 : memref<?x100xi32> to memref<8x100xi32>
    %2 = taskflow.join states(%cast_6, %cast_7, %cast_8, %cast_9) base(%cast) axis(0) region([0, 0], [8, 8]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<8x100xi32>
    %cast_10 = memref.cast %2 : memref<8x100xi32> to memref<?x100xi32>
    %done_writes_11:3 = taskflow.task @Task_1 will_writes(%arg4, %arg5, %arg8 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c0_i32 : index, i32, i32) [original_write_memrefs(%arg4, %arg5, %arg8 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg15, %arg10, %arg11, %arg12, %arg13 : i32, i32, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<memref<?x100xi32>, i1>, %arg21: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %8 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<memref<?x100xi32>, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %11 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.cast"(%11) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.cast"(%13) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.icmp"(%15, %16) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %18 = "neura.data_mov"(%17) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = "neura.data_mov"(%6) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.sel"(%18, %19, %20) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.data_mov"(%21) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %22 to [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %25 = "neura.data_mov"(%8) : (!neura.data<memref<?x100xi32>, i1>) -> !neura.data<memref<?x100xi32>, i1>
        %26 = "neura.data_mov"(%8) : (!neura.data<memref<?x100xi32>, i1>) -> !neura.data<memref<?x100xi32>, i1>
        %27 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %25 to %26[%27, %28 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x100xi32>, i1> {lhs_value = "%input1"} : !neura.data<memref<?x100xi32>, i1>
        %29 = "neura.data_mov"(%21) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %29 to [%30, %31 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>)
    }
    %done_writes_12 = taskflow.task @Task_2 will_reads(%cast_10 : memref<?x100xi32>) will_writes(%cast_10 : memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c-1024_i32 : index, i32, i32) [original_read_memrefs(%arg3 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {amoeba.semantic.incoming_edges = ["Task_0.replica.0|producer_consumer|tensor_wide|raw", "Task_0.replica.0|producer_consumer|tensor_wide|waw", "Task_0.replica.1.tile.1.0|producer_consumer|tensor_wide|raw", "Task_0.replica.1.tile.1.0|producer_consumer|tensor_wide|waw", "Task_0.replica.1.tile.1.1|producer_consumer|tensor_wide|raw", "Task_0.replica.1.tile.1.1|producer_consumer|tensor_wide|waw", "Task_0.replica.2|producer_consumer|tensor_wide|raw", "Task_0.replica.2|producer_consumer|tensor_wide|waw", "Task_0.replica.3|producer_consumer|tensor_wide|raw", "Task_0.replica.3|producer_consumer|tensor_wide|waw"], dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg12 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg11, %arg13, %arg12, %arg14, %arg12 : memref<?x100xi32>, i32, index, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<?x100xi32>, i1>, %arg16: !neura.data<i32, i1>, %arg17: !neura.data<index, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.cast"(%9) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<index, i1>
        %12 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.phi"(%11, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.reserve : !neura.data<i32, i1>
        %15 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.phi"(%14, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = neura.reserve : !neura.data<i64, i1>
        %18 = "neura.data_mov"(%7) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %19 = "neura.phi"(%17, %18) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %20 = neura.reserve : !neura.data<i64, i1>
        %21 = "neura.data_mov"(%7) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %22 = "neura.phi"(%20, %21) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %23 = "neura.data_mov"(%22) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %24 = "neura.cast"(%23) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %25 = "neura.data_mov"(%24) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.icmp"(%25) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %27 = "neura.data_mov"(%24) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.data_mov"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %29 = neura.grant_predicate %27, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %30 = "neura.data_mov"(%19) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %31 = "neura.data_mov"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %30, %31 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %33 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.data_mov"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %33, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %36 = "neura.data_mov"(%13) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %37 = "neura.data_mov"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %38 = neura.grant_predicate %36, %37 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %39 = "neura.data_mov"(%29) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %40 = "neura.cast"(%39) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %41 = neura.reserve : !neura.data<i64, i1>
        %42 = "neura.data_mov"(%32) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %43 = "neura.phi"(%41, %42) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %44 = neura.reserve : !neura.data<index, i1>
        %45 = "neura.data_mov"(%29) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.phi"(%44, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = neura.reserve : !neura.data<index, i1>
        %48 = "neura.data_mov"(%38) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %49 = "neura.phi"(%47, %48) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = neura.reserve : !neura.data<i32, i1>
        %51 = "neura.data_mov"(%40) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.phi"(%50, %51) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = neura.reserve : !neura.data<i32, i1>
        %54 = "neura.data_mov"(%35) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.phi"(%53, %54) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = neura.reserve : !neura.data<i64, i1>
        %57 = "neura.data_mov"(%32) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %58 = "neura.phi"(%56, %57) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %59 = "neura.data_mov"(%58) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %60 = "neura.cast"(%59) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %61 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = "neura.icmp"(%61) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %63 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %64 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %65 = neura.grant_predicate %63, %64 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %66 = "neura.data_mov"(%55) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %67 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %68 = neura.grant_predicate %66, %67 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %69 = "neura.data_mov"(%52) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %70 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %71 = neura.grant_predicate %69, %70 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %72 = "neura.data_mov"(%49) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %73 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %74 = neura.grant_predicate %72, %73 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %75 = "neura.data_mov"(%46) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %76 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %77 = neura.grant_predicate %75, %76 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %78 = "neura.data_mov"(%43) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %79 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %80 = neura.grant_predicate %78, %79 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %81 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %82 = "neura.not"(%81) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %83 = "neura.data_mov"(%55) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %84 = "neura.data_mov"(%82) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %85 = neura.grant_predicate %83, %84 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %86 = "neura.data_mov"(%52) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.data_mov"(%82) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %88 = neura.grant_predicate %86, %87 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %89 = "neura.data_mov"(%46) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %90 = "neura.data_mov"(%82) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %91 = neura.grant_predicate %89, %90 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %92 = "neura.data_mov"(%49) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %93 = "neura.data_mov"(%82) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %94 = neura.grant_predicate %92, %93 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %95 = "neura.data_mov"(%43) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %96 = "neura.data_mov"(%82) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %97 = neura.grant_predicate %95, %96 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %98 = "neura.data_mov"(%65) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %99 = "neura.cast"(%98) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %100 = "neura.data_mov"(%99) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %101 = "neura.data_mov"(%68) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %102 = "neura.icmp"(%100, %101) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %103 = "neura.data_mov"(%102) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %104 = "neura.cast"(%103) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %105 = "neura.data_mov"(%99) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %106 = "neura.data_mov"(%71) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %107 = "neura.icmp"(%105, %106) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %108 = "neura.data_mov"(%107) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %109 = "neura.cast"(%108) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %110 = "neura.data_mov"(%104) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %111 = "neura.data_mov"(%109) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %112 = "neura.mul"(%110, %111) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %113 = "neura.data_mov"(%74) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %114 = "neura.data_mov"(%77) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %115 = neura.load_indexed [%113, %114 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %116 = "neura.data_mov"(%74) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %117 = "neura.data_mov"(%65) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = neura.load_indexed [%116, %117 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %119 = "neura.data_mov"(%65) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %120 = "neura.data_mov"(%77) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = neura.load_indexed [%119, %120 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %122 = "neura.data_mov"(%118) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %123 = "neura.data_mov"(%121) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %124 = "neura.mul"(%122, %123) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %125 = "neura.data_mov"(%124) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %126 = "neura.div"(%125) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %127 = "neura.data_mov"(%112) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %128 = "neura.data_mov"(%126) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %129 = "neura.mul"(%127, %128) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %130 = "neura.data_mov"(%115) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %131 = "neura.data_mov"(%129) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %132 = "neura.sub"(%130, %131) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %133 = "neura.data_mov"(%132) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %134 = "neura.data_mov"(%74) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %135 = "neura.data_mov"(%77) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %133 to [%134, %135 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input0"} : !neura.data<i32, i1>
        %136 = "neura.data_mov"(%65) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %137 = "neura.add"(%136) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.data_mov"(%137) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %139 = "neura.cast"(%138) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %139 -> %56 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %68 -> %53 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %71 -> %50 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %74 -> %47 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %77 -> %44 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %80 -> %41 : !neura.data<i64, i1> !neura.data<i64, i1>
        %140 = "neura.data_mov"(%85) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %141 = "neura.data_mov"(%88) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %142 = "neura.icmp"(%140, %141) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %143 = "neura.data_mov"(%142) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %144 = "neura.cast"(%143) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %145 = "neura.data_mov"(%91) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %146 = "neura.data_mov"(%91) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %147 = neura.load_indexed [%145, %146 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %148 = "neura.data_mov"(%147) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %149 = "neura.add"(%148) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %150 = "neura.data_mov"(%144) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %151 = "neura.data_mov"(%149) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %152 = "neura.mul"(%150, %151) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %153 = "neura.data_mov"(%152) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %154 = "neura.add"(%153) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %155 = "neura.data_mov"(%94) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %156 = "neura.data_mov"(%91) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %157 = neura.load_indexed [%155, %156 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %158 = "neura.data_mov"(%157) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %159 = "neura.mul"(%158) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %160 = "neura.data_mov"(%159) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %161 = "neura.data_mov"(%154) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %162 = "neura.div"(%160, %161) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %163 = "neura.data_mov"(%162) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %164 = "neura.data_mov"(%94) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %165 = "neura.data_mov"(%91) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %163 to [%164, %165 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input0"} : !neura.data<i32, i1>
        %166 = "neura.data_mov"(%91) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %167 = "neura.add"(%166) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %168 = "neura.data_mov"(%167) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %169 = "neura.cast"(%168) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %169 -> %20 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %97 -> %17 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %85 -> %14 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %94 -> %11 : !neura.data<index, i1> !neura.data<index, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %done_writes_13:2 = taskflow.task @Task_3 will_reads(%done_writes_12 : memref<?x100xi32>) will_writes(%done_writes_11#0, %done_writes_11#1 : memref<?x100xi32>, memref<?x100xi32>) value_inputs(%0, %c1_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg3 : memref<?x100xi32>), original_write_memrefs(%arg4, %arg5 : memref<?x100xi32>, memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>, memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg10, %arg15, %arg11, %arg12, %arg13 : i32, memref<?x100xi32>, i32, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<?x100xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<memref<?x100xi32>, i1>, %arg21: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.cast"(%8) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %10 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.cast"(%10) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.icmp"(%12, %13) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.data_mov"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %16 = "neura.cast"(%15) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %17 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.icmp"(%17, %18) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %20 = "neura.data_mov"(%19) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = "neura.cast"(%20) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %22 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.sub"(%22) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%24, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.data_mov"(%26) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.data_mov"(%21) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.mul"(%30) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.data_mov"(%29) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.data_mov"(%31) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%32, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.data_mov"(%34) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %37 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %35 to [%36, %37 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %38 = "neura.data_mov"(%23) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.data_mov"(%26) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %40 = "neura.mul"(%38, %39) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %41 = "neura.data_mov"(%40) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %42 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %43 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %41 to [%42, %43 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>)
    }
    %done_writes_14 = taskflow.task @Task_4 will_reads(%arg2, %arg6, %done_writes_13#0 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>) will_writes(%arg6 : memref<?xi32>) value_inputs(%0, %c1024_i32 : index, i32) [original_read_memrefs(%arg2, %arg6, %arg4 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>), original_write_memrefs(%arg6 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?xi32>, %arg11: memref<?xi32>, %arg12: memref<?x100xi32>, %arg13: memref<?xi32>, %arg14: index, %arg15: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0_19 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg13, %arg12, %arg15, %arg14 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<memref<?xi32>, i1>, %arg17: !neura.data<memref<?xi32>, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<i32, i1>, %arg20: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.cast"(%8) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %10 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%10 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %14 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %16 = neura.grant_predicate %14, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = "neura.data_mov"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %17, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.data_mov"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %20, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.data_mov"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %23, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = "neura.data_mov"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %27 = "neura.not"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %28, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %33 = neura.grant_predicate %31, %32 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %34 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %36 = neura.grant_predicate %34, %35 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %37 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = "neura.data_mov"(%19) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %37 to [%38 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %39 = "neura.data_mov"(%36) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %40 = "neura.data_mov"(%19) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.phi"(%39, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %42 = "neura.data_mov"(%33) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %43 = "neura.data_mov"(%25) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.phi"(%42, %43) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %45 = "neura.data_mov"(%30) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.data_mov"(%22) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.phi"(%45, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %49 = "neura.cast"(%48) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %50 = "neura.data_mov"(%49) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %51 = "neura.data_mov"(%44) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.icmp"(%50, %51) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %53 = "neura.data_mov"(%52) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %54 = "neura.cast"(%53) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %55 = "neura.data_mov"(%41) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = neura.load_indexed [%55 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %57 = "neura.data_mov"(%41) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = neura.load_indexed [%57, %58 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %60 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = neura.load_indexed [%60 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %62 = "neura.data_mov"(%59) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %63 = "neura.data_mov"(%61) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.mul"(%62, %63) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %65 = "neura.data_mov"(%64) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %66 = "neura.div"(%65) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %67 = "neura.data_mov"(%54) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %68 = "neura.data_mov"(%66) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %69 = "neura.mul"(%67, %68) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %70 = "neura.data_mov"(%56) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %71 = "neura.data_mov"(%69) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %72 = "neura.sub"(%70, %71) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %73 = "neura.data_mov"(%72) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %74 = "neura.data_mov"(%41) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %73 to [%74 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?xi32>)
    }
    %3 = arith.addi %c8_i32, %c-1_i32 : i32
    %done_writes_15 = taskflow.task @Task_5 will_reads(%done_writes_14, %arg7, %done_writes_13#1 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>) will_writes(%arg7 : memref<?xi32>) value_inputs(%0, %3, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg6, %arg7, %arg5 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>), original_write_memrefs(%arg7 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?xi32>, %arg11: memref<?xi32>, %arg12: memref<?x100xi32>, %arg13: memref<?xi32>, %arg14: index, %arg15: i32, %arg16: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg15, %arg14, %arg10, %arg13, %arg12, %arg16, %arg14 : i32, index, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg17: !neura.data<i32, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<memref<?xi32>, i1>, %arg20: !neura.data<memref<?xi32>, i1>, %arg21: !neura.data<memref<?x100xi32>, i1>, %arg22: !neura.data<i32, i1>, %arg23: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.cast"(%9) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.sub"(%11) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.mul"(%13) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = "neura.data_mov"(%14) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.add"(%15) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.data_mov"(%16) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = "neura.add"(%17) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = "neura.data_mov"(%18) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = neura.load_indexed [%19 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %21 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.mul"(%21) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.data_mov"(%22) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.add"(%23) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.data_mov"(%24) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.add"(%25) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.data_mov"(%20) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.grant_once"(%27) {amoeba.source_owned_once_init} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.data_mov"(%28) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.data_mov"(%26) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %29 to [%30 : !neura.data<index, i1>]  {amoeba.source_owned_once_init, rhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = neura.reserve : !neura.data<index, i1>
        %32 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.phi"(%31, %32) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = neura.reserve : !neura.data<i32, i1>
        %35 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.phi"(%34, %35) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = neura.reserve : !neura.data<i64, i1>
        %38 = "neura.data_mov"(%7) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %39 = "neura.phi"(%37, %38) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %40 = "neura.data_mov"(%39) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %41 = "neura.cast"(%40) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %42 = "neura.data_mov"(%41) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %43 = "neura.icmp"(%42) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %44 = "neura.data_mov"(%41) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %45 = "neura.data_mov"(%43) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %46 = neura.grant_predicate %44, %45 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %47 = "neura.data_mov"(%36) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %48 = "neura.data_mov"(%43) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %49 = neura.grant_predicate %47, %48 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %50 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.data_mov"(%43) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %52 = neura.grant_predicate %50, %51 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %53 = "neura.data_mov"(%43) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %54 = "neura.not"(%53) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %55 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.data_mov"(%54) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %57 = neura.grant_predicate %55, %56 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %58 = "neura.data_mov"(%46) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.cast"(%58) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %60 = "neura.data_mov"(%59) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %61 = "neura.data_mov"(%49) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %62 = "neura.icmp"(%60, %61) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %63 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %64 = "neura.cast"(%63) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %65 = "neura.data_mov"(%52) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %66 = "neura.mul"(%65) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %67 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.add"(%67) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.data_mov"(%68) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = "neura.add"(%69) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %71 = "neura.data_mov"(%70) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %72 = neura.load_indexed [%71 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %73 = "neura.data_mov"(%52) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %74 = "neura.mul"(%73) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %75 = "neura.data_mov"(%74) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %76 = "neura.add"(%75) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %77 = "neura.data_mov"(%76) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = "neura.add"(%77) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %79 = "neura.data_mov"(%78) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %80 = "neura.data_mov"(%46) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %81 = neura.load_indexed [%79, %80 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %82 = "neura.data_mov"(%46) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %83 = neura.load_indexed [%82 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %84 = "neura.data_mov"(%81) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.data_mov"(%83) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.mul"(%84, %85) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.data_mov"(%86) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.div"(%87) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.data_mov"(%64) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.data_mov"(%88) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %91 = "neura.mul"(%89, %90) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %92 = "neura.data_mov"(%72) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %93 = "neura.data_mov"(%91) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %94 = "neura.sub"(%92, %93) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %95 = "neura.data_mov"(%52) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %96 = "neura.mul"(%95) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %97 = "neura.data_mov"(%96) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %98 = "neura.add"(%97) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %99 = "neura.data_mov"(%98) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %100 = "neura.add"(%99) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %101 = "neura.data_mov"(%94) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %102 = "neura.data_mov"(%100) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %101 to [%102 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %103 = "neura.data_mov"(%46) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %104 = "neura.add"(%103) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %105 = "neura.data_mov"(%104) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %106 = "neura.cast"(%105) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %106 -> %37 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %49 -> %34 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %52 -> %31 : !neura.data<index, i1> !neura.data<index, i1>
        %107 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %108 = "neura.mul"(%107) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %109 = "neura.data_mov"(%108) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %110 = "neura.add"(%109) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %111 = "neura.data_mov"(%110) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %112 = "neura.add"(%111) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %113 = "neura.data_mov"(%112) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %114 = neura.load_indexed [%113 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %115 = "neura.data_mov"(%114) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %116 = "neura.mul"(%115) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %117 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = "neura.mul"(%117) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = "neura.data_mov"(%118) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %120 = "neura.add"(%119) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = "neura.data_mov"(%120) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %122 = "neura.add"(%121) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %123 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %124 = "neura.mul"(%123) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %125 = "neura.data_mov"(%124) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %126 = "neura.add"(%125) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %127 = "neura.data_mov"(%126) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %128 = "neura.add"(%127) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %129 = "neura.data_mov"(%122) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %130 = "neura.data_mov"(%128) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %131 = neura.load_indexed [%129, %130 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %132 = "neura.data_mov"(%116) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %133 = "neura.data_mov"(%131) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %134 = "neura.div"(%132, %133) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %135 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %136 = "neura.mul"(%135) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %137 = "neura.data_mov"(%136) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.add"(%137) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %139 = "neura.data_mov"(%138) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %140 = "neura.add"(%139) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %141 = "neura.data_mov"(%134) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %142 = "neura.data_mov"(%140) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %141 to [%142 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?xi32>)
    }
    %done_writes_16 = taskflow.task @Task_6 will_reads(%done_writes_11#2, %done_writes_13#0 : memref<?x100xi32>, memref<?x100xi32>) will_writes(%done_writes_11#2 : memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg8, %arg4 : memref<?x100xi32>, memref<?x100xi32>), original_write_memrefs(%arg8 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg14, %arg15, %arg12, %arg11, %arg13 : i32, i32, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<index, i1>):
        %7 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.cast"(%12) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = "neura.cast"(%14) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %16 = "neura.data_mov"(%15) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.icmp"(%16, %17) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %19 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.data_mov"(%8) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.sel"(%19, %20, %21) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.icmp"(%23) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %25 = "neura.data_mov"(%22) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %27 = neura.grant_predicate %25, %26 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %28, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %32 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %33 = neura.grant_predicate %31, %32 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %36 = neura.grant_predicate %34, %35 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %37 = "neura.data_mov"(%15) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %39 = neura.grant_predicate %37, %38 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %40 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %41 = "neura.not"(%40) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %43 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %44 = neura.grant_predicate %42, %43 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %45 = "neura.data_mov"(%15) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %46 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = neura.grant_predicate %45, %46 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %48 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %49 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %50 = neura.grant_predicate %48, %49 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %51 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %53 = neura.grant_predicate %51, %52 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %54 = "neura.data_mov"(%27) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.data_mov"(%30) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %54 to [%55, %56 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %57 = "neura.data_mov"(%53) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.phi"(%57, %58) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.data_mov"(%30) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = "neura.phi"(%60, %61) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %63 = "neura.data_mov"(%47) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.data_mov"(%39) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %65 = "neura.phi"(%63, %64) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %66 = "neura.data_mov"(%44) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %67 = "neura.data_mov"(%36) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.phi"(%66, %67) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.data_mov"(%68) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = "neura.cast"(%69) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %71 = "neura.data_mov"(%70) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %72 = "neura.data_mov"(%65) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %73 = "neura.icmp"(%71, %72) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %74 = "neura.data_mov"(%73) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %75 = "neura.cast"(%74) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %76 = "neura.data_mov"(%62) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %77 = "neura.data_mov"(%59) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = neura.load_indexed [%76, %77 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %79 = "neura.data_mov"(%62) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %80 = "neura.data_mov"(%68) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %81 = neura.load_indexed [%79, %80 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %82 = "neura.data_mov"(%68) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %83 = "neura.data_mov"(%59) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %84 = neura.load_indexed [%82, %83 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %85 = "neura.data_mov"(%81) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.data_mov"(%84) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.mul"(%85, %86) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%87) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.div"(%88) {rhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.data_mov"(%75) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %91 = "neura.data_mov"(%89) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %92 = "neura.mul"(%90, %91) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %93 = "neura.data_mov"(%78) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %94 = "neura.data_mov"(%92) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %95 = "neura.sub"(%93, %94) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %96 = "neura.data_mov"(%95) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %97 = "neura.data_mov"(%62) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %98 = "neura.data_mov"(%59) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %96 to [%97, %98 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?x100xi32>)
    }
    %done_writes_17 = taskflow.task @Task_7 will_reads(%done_writes_16, %done_writes_13#1 : memref<?x100xi32>, memref<?x100xi32>) will_writes(%done_writes_16 : memref<?x100xi32>) value_inputs(%0, %3, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg8, %arg5 : memref<?x100xi32>, memref<?x100xi32>), original_write_memrefs(%arg8 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg13, %arg12, %arg11, %arg15, %arg13 : i32, index, memref<?x100xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<index, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<i32, i1>, %arg21: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = "neura.cast"(%7) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.cast"(%11) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.sub"(%13) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.reserve : !neura.data<index, i1>
        %16 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%15, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.reserve : !neura.data<index, i1>
        %19 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%18, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = neura.reserve : !neura.data<i32, i1>
        %22 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.phi"(%21, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = neura.reserve : !neura.data<i64, i1>
        %25 = "neura.data_mov"(%8) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %26 = "neura.phi"(%24, %25) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %27 = "neura.data_mov"(%26) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %28 = "neura.cast"(%27) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%28) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.icmp"(%29) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %31 = "neura.data_mov"(%28) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %32 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %33 = neura.grant_predicate %31, %32 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = "neura.data_mov"(%23) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %36 = neura.grant_predicate %34, %35 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %37 = "neura.data_mov"(%20) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %39 = neura.grant_predicate %37, %38 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %40 = "neura.data_mov"(%17) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = neura.grant_predicate %40, %41 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %43 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %44 = "neura.not"(%43) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = "neura.data_mov"(%20) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = neura.grant_predicate %45, %46 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %48 = "neura.data_mov"(%17) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %49 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %50 = neura.grant_predicate %48, %49 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %51 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.cast"(%51) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %53 = "neura.data_mov"(%52) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %54 = "neura.data_mov"(%36) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.icmp"(%53, %54) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %56 = "neura.data_mov"(%55) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %57 = "neura.cast"(%56) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %58 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.mul"(%58) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.data_mov"(%59) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.add"(%60) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = "neura.data_mov"(%61) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %63 = "neura.add"(%62) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %64 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %65 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %66 = neura.load_indexed [%64, %65 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %67 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.mul"(%67) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.data_mov"(%68) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = "neura.add"(%69) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %71 = "neura.data_mov"(%70) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %72 = "neura.add"(%71) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %73 = "neura.data_mov"(%72) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %74 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %75 = neura.load_indexed [%73, %74 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %76 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %77 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = neura.load_indexed [%76, %77 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %79 = "neura.data_mov"(%75) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %80 = "neura.data_mov"(%78) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %81 = "neura.mul"(%79, %80) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %82 = "neura.data_mov"(%81) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %83 = "neura.div"(%82) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %84 = "neura.data_mov"(%57) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.data_mov"(%83) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.mul"(%84, %85) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.data_mov"(%66) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%86) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.sub"(%87, %88) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %91 = "neura.mul"(%90) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %92 = "neura.data_mov"(%91) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %93 = "neura.add"(%92) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %94 = "neura.data_mov"(%93) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %95 = "neura.add"(%94) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %96 = "neura.data_mov"(%89) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %97 = "neura.data_mov"(%95) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %98 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %96 to [%97, %98 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %99 = "neura.data_mov"(%33) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %100 = "neura.add"(%99) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %101 = "neura.data_mov"(%100) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %102 = "neura.cast"(%101) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %102 -> %24 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %36 -> %21 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %39 -> %18 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %42 -> %15 : !neura.data<index, i1> !neura.data<index, i1>
        %103 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %104 = "neura.mul"(%103) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %105 = "neura.data_mov"(%104) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %106 = "neura.add"(%105) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %107 = "neura.data_mov"(%106) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %108 = "neura.add"(%107) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %109 = "neura.data_mov"(%108) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %110 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %111 = neura.load_indexed [%109, %110 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %112 = "neura.data_mov"(%111) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %113 = "neura.mul"(%112) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %114 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %115 = "neura.mul"(%114) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %116 = "neura.data_mov"(%115) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %117 = "neura.add"(%116) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = "neura.data_mov"(%117) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = "neura.add"(%118) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %120 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = "neura.mul"(%120) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %122 = "neura.data_mov"(%121) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %123 = "neura.add"(%122) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %124 = "neura.data_mov"(%123) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %125 = "neura.add"(%124) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %126 = "neura.data_mov"(%119) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %127 = "neura.data_mov"(%125) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %128 = neura.load_indexed [%126, %127 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %129 = "neura.data_mov"(%113) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %130 = "neura.data_mov"(%128) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %131 = "neura.div"(%129, %130) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %132 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %133 = "neura.mul"(%132) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %134 = "neura.data_mov"(%133) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %135 = "neura.add"(%134) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %136 = "neura.data_mov"(%135) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %137 = "neura.add"(%136) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.data_mov"(%131) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %139 = "neura.data_mov"(%137) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %140 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %138 to [%139, %140 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?x100xi32>)
    }
    memref.store %c1024_i32, %arg9[%c0] : memref<?xi32>
    %done_writes_18 = taskflow.task @Task_8 will_reads(%done_writes_13#1, %arg9 : memref<?x100xi32>, memref<?xi32>) will_writes(%arg9 : memref<?xi32>) value_inputs(%0, %c1024_i32 : index, i32) [original_read_memrefs(%arg5, %arg9 : memref<?x100xi32>, memref<?xi32>), original_write_memrefs(%arg9 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?xi32>, %arg12: memref<?xi32>, %arg13: index, %arg14: i32):
      %c0_19 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0_19 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg10, %arg12, %arg14, %arg13 : memref<?x100xi32>, memref<?xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<?x100xi32>, i1>, %arg16: !neura.data<memref<?xi32>, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %7 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%10 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.mul"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.div"(%15) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %17 to [%18 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?xi32>)
    }
    return
  }
}

