module attributes {amoeba.lu_affine_repair_input_status = "malformed-determinant-carry", amoeba.lu_affine_repair_pass = "repair-lu-affine-determinant-carry-v1", amoeba.lu_affine_repair_reason = "inserted determinant carry load and rewired product", amoeba.lu_affine_repair_source_file = "${ARTIFACT_ROOT}/.work/amoeba-test/Evaluation/LU/lu_func.cpp", amoeba.lu_affine_repair_source_verified = true, amoeba.lu_affine_repair_status = "repaired"} {
  func.func @_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_(%arg0: i32, %arg1: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg2: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg3: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg4: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg5: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg6: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg8: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg9: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-16", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/lu/shape-temporal-replica-tiling-source-corrected-v1-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/lu/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 8 : i64, amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_0", amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.static_bound.arg.0 = 8 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c8_i32 = arith.constant 8 : i32
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c1024_i32 = arith.constant 1024 : i32
    %c-1_i32 = arith.constant -1 : i32
    %c-1024_i32 = arith.constant -1024 : i32
    %0 = arith.index_cast %c8_i32 : i32 to index
    %cast = memref.cast %arg3 : memref<?x100xi32> to memref<8x100xi32>
    %cast_0 = memref.cast %arg3 : memref<?x100xi32> to memref<8x100xi32>
    %done_writes = taskflow.task @Task_0.replica.0.tile.1.0 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_0 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_0 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 0, 2, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}, {after = array<i64: 0, 2, 1, 0, 2, 1>, axis = 1 : i64, before = array<i64: 0, 2, 1, 0, 8, 1>, factor = 4 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 0, 2>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 8>, amoeba.neura.tiling.parent_task = "Task_0.replica.0", amoeba.neura.tiling.part_index = 0 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 2 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 2, 2>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_25 = arith.constant 0 : index
      %c2 = arith.constant 2 : index
      %c0_26 = arith.constant 0 : index
      %c2_27 = arith.constant 2 : index
      %5 = taskflow.counter from %c0_26 to %c2_27 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_28 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c0_29 = arith.constant 0 : index
      %c2_30 = arith.constant 2 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_29 to %c2_30 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c0_31 = arith.constant 0 : index
        %c2_32 = arith.constant 2 : index
        %c0_33 = arith.constant 0 : index
        %c2_34 = arith.constant 2 : index
        %7 = neura.counter from %c0_33 : index to %c2_34 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 2 : index} -> !neura.data<index, i1>
        %c0_35 = arith.constant 0 : index
        %c8_36 = arith.constant 8 : index
        %c0_37 = arith.constant 0 : index
        %c2_38 = arith.constant 2 : index
        %8 = neura.counter from %c0_37 : index to %c2_38 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 2 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %done_writes_1 = taskflow.task @Task_0.replica.0.tile.1.1 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_0 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_0 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 0, 2, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}, {after = array<i64: 0, 2, 1, 2, 4, 1>, axis = 1 : i64, before = array<i64: 0, 2, 1, 0, 8, 1>, factor = 4 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 2, 4>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 8>, amoeba.neura.tiling.parent_task = "Task_0.replica.0", amoeba.neura.tiling.part_index = 1 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 2 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 2>], amoeba.tiling.output_region_uppers = [array<i64: 2, 4>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_25 = arith.constant 0 : index
      %c2 = arith.constant 2 : index
      %c0_26 = arith.constant 0 : index
      %c2_27 = arith.constant 2 : index
      %5 = taskflow.counter from %c0_26 to %c2_27 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_28 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c2_29 = arith.constant 2 : index
      %c4 = arith.constant 4 : index
      %6 = taskflow.counter parent(%5 : index) from %c2_29 to %c4 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c0_30 = arith.constant 0 : index
        %c2_31 = arith.constant 2 : index
        %c0_32 = arith.constant 0 : index
        %c2_33 = arith.constant 2 : index
        %7 = neura.counter from %c0_32 : index to %c2_33 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 2 : index} -> !neura.data<index, i1>
        %c0_34 = arith.constant 0 : index
        %c8_35 = arith.constant 8 : index
        %c2_36 = arith.constant 2 : index
        %c4_37 = arith.constant 4 : index
        %8 = neura.counter from %c2_36 : index to %c4_37 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = 4 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %done_writes_2 = taskflow.task @Task_0.replica.0.tile.1.2 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_0 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_0 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 0, 2, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}, {after = array<i64: 0, 2, 1, 4, 6, 1>, axis = 1 : i64, before = array<i64: 0, 2, 1, 0, 8, 1>, factor = 4 : i64, family = "tiling", part = 2 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 4, 6>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 8>, amoeba.neura.tiling.parent_task = "Task_0.replica.0", amoeba.neura.tiling.part_index = 2 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 2 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 4>], amoeba.tiling.output_region_uppers = [array<i64: 2, 6>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_25 = arith.constant 0 : index
      %c2 = arith.constant 2 : index
      %c0_26 = arith.constant 0 : index
      %c2_27 = arith.constant 2 : index
      %5 = taskflow.counter from %c0_26 to %c2_27 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_28 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c6 = arith.constant 6 : index
      %6 = taskflow.counter parent(%5 : index) from %c4 to %c6 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c0_29 = arith.constant 0 : index
        %c2_30 = arith.constant 2 : index
        %c0_31 = arith.constant 0 : index
        %c2_32 = arith.constant 2 : index
        %7 = neura.counter from %c0_31 : index to %c2_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 2 : index} -> !neura.data<index, i1>
        %c0_33 = arith.constant 0 : index
        %c8_34 = arith.constant 8 : index
        %c4_35 = arith.constant 4 : index
        %c6_36 = arith.constant 6 : index
        %8 = neura.counter from %c4_35 : index to %c6_36 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 4 : index, step_value = 1 : index, upper_bound_value = 6 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %done_writes_3 = taskflow.task @Task_0.replica.0.tile.1.3 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_0 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_0 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 0, 2, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}, {after = array<i64: 0, 2, 1, 6, 8, 1>, axis = 1 : i64, before = array<i64: 0, 2, 1, 0, 8, 1>, factor = 4 : i64, family = "tiling", part = 3 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 6, 8>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 8>, amoeba.neura.tiling.parent_task = "Task_0.replica.0", amoeba.neura.tiling.part_index = 3 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 2 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 6>], amoeba.tiling.output_region_uppers = [array<i64: 2, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_25 = arith.constant 0 : index
      %c2 = arith.constant 2 : index
      %c0_26 = arith.constant 0 : index
      %c2_27 = arith.constant 2 : index
      %5 = taskflow.counter from %c0_26 to %c2_27 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_28 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c6 = arith.constant 6 : index
      %c8_29 = arith.constant 8 : index
      %6 = taskflow.counter parent(%5 : index) from %c6 to %c8_29 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c0_30 = arith.constant 0 : index
        %c2_31 = arith.constant 2 : index
        %c0_32 = arith.constant 0 : index
        %c2_33 = arith.constant 2 : index
        %7 = neura.counter from %c0_32 : index to %c2_33 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 2 : index} -> !neura.data<index, i1>
        %c0_34 = arith.constant 0 : index
        %c8_35 = arith.constant 8 : index
        %c6_36 = arith.constant 6 : index
        %c8_37 = arith.constant 8 : index
        %8 = neura.counter from %c6_36 : index to %c8_37 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 6 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %1 = taskflow.join states(%done_writes, %done_writes_1, %done_writes_2, %done_writes_3) base(%cast_0) axis(1) region([0, 0], [2, 8]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<8x100xi32>
    %cast_4 = memref.cast %1 : memref<8x100xi32> to memref<?x100xi32>
    %cast_5 = memref.cast %arg3 : memref<?x100xi32> to memref<8x100xi32>
    %done_writes_6 = taskflow.task @Task_0.replica.1.tile.0.0 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_5 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_5 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 2, 4, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 1 : i64}, {after = array<i64: 2, 3, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 2, 4, 1, 0, 8, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 2, 3>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 2, 4>, amoeba.neura.tiling.parent_task = "Task_0.replica.1", amoeba.neura.tiling.part_index = 0 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 2 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 4 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 2, 0>], amoeba.tiling.output_region_uppers = [array<i64: 3, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c4 = arith.constant 4 : index
      %c2_25 = arith.constant 2 : index
      %c3 = arith.constant 3 : index
      %5 = taskflow.counter from %c2_25 to %c3 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c0_27 = arith.constant 0 : index
      %c8_28 = arith.constant 8 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_27 to %c8_28 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c2_29 = arith.constant 2 : index
        %c4_30 = arith.constant 4 : index
        %c2_31 = arith.constant 2 : index
        %c3_32 = arith.constant 3 : index
        %7 = neura.counter from %c2_31 : index to %c3_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = 3 : index} -> !neura.data<index, i1>
        %c0_33 = arith.constant 0 : index
        %c8_34 = arith.constant 8 : index
        %c0_35 = arith.constant 0 : index
        %c8_36 = arith.constant 8 : index
        %8 = neura.counter from %c0_35 : index to %c8_36 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %done_writes_7 = taskflow.task @Task_0.replica.1.tile.0.1 will_reads(%arg1 : memref<?x100xi32>) will_writes(%cast_5 : memref<8x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%cast_5 : memref<8x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 2, 4, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 1 : i64}, {after = array<i64: 3, 4, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 2, 4, 1, 0, 8, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 3, 4>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 2, 4>, amoeba.neura.tiling.parent_task = "Task_0.replica.1", amoeba.neura.tiling.part_index = 1 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 2 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 4 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 3, 0>], amoeba.tiling.output_region_uppers = [array<i64: 4, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<8x100xi32>, index) -> (memref<8x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<8x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c4 = arith.constant 4 : index
      %c3 = arith.constant 3 : index
      %c4_25 = arith.constant 4 : index
      %5 = taskflow.counter from %c3 to %c4_25 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c0_27 = arith.constant 0 : index
      %c8_28 = arith.constant 8 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_27 to %c8_28 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<8x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<8x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c2_29 = arith.constant 2 : index
        %c4_30 = arith.constant 4 : index
        %c3_31 = arith.constant 3 : index
        %c4_32 = arith.constant 4 : index
        %7 = neura.counter from %c3_31 : index to %c4_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 3 : index, step_value = 1 : index, upper_bound_value = 4 : index} -> !neura.data<index, i1>
        %c0_33 = arith.constant 0 : index
        %c8_34 = arith.constant 8 : index
        %c0_35 = arith.constant 0 : index
        %c8_36 = arith.constant 8 : index
        %8 = neura.counter from %c0_35 : index to %c8_36 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<8x100xi32>)
    }
    %2 = taskflow.join states(%done_writes_6, %done_writes_7) base(%cast_5) axis(0) region([2, 0], [4, 8]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<8x100xi32>
    %cast_8 = memref.cast %2 : memref<8x100xi32> to memref<?x100xi32>
    %done_writes_9 = taskflow.task @Task_0.replica.2 will_reads(%arg1 : memref<?x100xi32>) will_writes(%arg3 : memref<?x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 4, 6, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 2 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 4 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 6 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 4, 0>], amoeba.tiling.output_region_uppers = [array<i64: 6, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<?x100xi32>, index) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c4 = arith.constant 4 : index
      %c6 = arith.constant 6 : index
      %5 = taskflow.counter from %c4 to %c6 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_25 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_25 to %c8 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<?x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c4_26 = arith.constant 4 : index
        %c6_27 = arith.constant 6 : index
        %7 = neura.counter from %c4_26 : index to %c6_27 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 4 : index, step_value = 1 : index, upper_bound_value = 6 : index} -> !neura.data<index, i1>
        %c0_28 = arith.constant 0 : index
        %c8_29 = arith.constant 8 : index
        %8 = neura.counter from %c0_28 : index to %c8_29 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %done_writes_10 = taskflow.task @Task_0.replica.3 will_reads(%arg1 : memref<?x100xi32>) will_writes(%arg3 : memref<?x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 8, 1, 0, 8, 1>, root = "Task_0", steps = [{after = array<i64: 6, 8, 1, 0, 8, 1>, axis = 0 : i64, before = array<i64: 0, 8, 1, 0, 8, 1>, factor = 4 : i64, family = "replica", part = 3 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 6 : i64, amoeba.replica.shard_trip_count = 16 : i64, amoeba.replica.shard_upper = 8 : i64, amoeba.replica.total_trip_count = 64 : i64, amoeba.tiling.output_region_lowers = [array<i64: 6, 0>], amoeba.tiling.output_region_uppers = [array<i64: 8, 8>], dlp_replicable = true, runtime_managable = true, trip_count = 16 : i64} : (memref<?x100xi32>, memref<?x100xi32>, index) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c6 = arith.constant 6 : index
      %c8 = arith.constant 8 : index
      %5 = taskflow.counter from %c6 to %c8 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_25 = arith.constant 0 : index
      %c8_26 = arith.constant 8 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_25 to %c8_26 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<?x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %c6_27 = arith.constant 6 : index
        %c8_28 = arith.constant 8 : index
        %7 = neura.counter from %c6_27 : index to %c8_28 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 6 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %c0_29 = arith.constant 0 : index
        %c8_30 = arith.constant 8 : index
        %8 = neura.counter from %c0_29 : index to %c8_30 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %12 to [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %cast_11 = memref.cast %cast_4 : memref<?x100xi32> to memref<8x100xi32>
    %cast_12 = memref.cast %cast_8 : memref<?x100xi32> to memref<8x100xi32>
    %cast_13 = memref.cast %done_writes_9 : memref<?x100xi32> to memref<8x100xi32>
    %cast_14 = memref.cast %done_writes_10 : memref<?x100xi32> to memref<8x100xi32>
    %3 = taskflow.join states(%cast_11, %cast_12, %cast_13, %cast_14) base(%cast) axis(0) region([0, 0], [8, 8]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<8x100xi32>
    %cast_15 = memref.cast %3 : memref<8x100xi32> to memref<?x100xi32>
    %done_writes_16:3 = taskflow.task @Task_1 will_writes(%arg4, %arg5, %arg8 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c0_i32 : index, i32, i32) [original_write_memrefs(%arg4, %arg5, %arg8 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg15, %arg10, %arg11, %arg12, %arg13 : i32, i32, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<memref<?x100xi32>, i1>, %arg21: !neura.data<index, i1>):
        %7 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %9 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<memref<?x100xi32>, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %12 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.cast"(%12) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = "neura.cast"(%14) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %16 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.data_mov"(%15) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.icmp"(%16, %17) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %19 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.data_mov"(%8) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.sel"(%19, %20, %21) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.data_mov"(%22) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %23 to [%24, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %26 = "neura.data_mov"(%9) : (!neura.data<memref<?x100xi32>, i1>) -> !neura.data<memref<?x100xi32>, i1>
        %27 = "neura.data_mov"(%9) : (!neura.data<memref<?x100xi32>, i1>) -> !neura.data<memref<?x100xi32>, i1>
        %28 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %26 to %27[%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x100xi32>, i1> {lhs_value = "%input1"} : !neura.data<memref<?x100xi32>, i1>
        %30 = "neura.data_mov"(%22) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %32 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %30 to [%31, %32 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>)
    }
    %done_writes_17 = taskflow.task @Task_2 will_reads(%cast_15 : memref<?x100xi32>) will_writes(%cast_15 : memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c-1024_i32 : index, i32, i32) [original_read_memrefs(%arg3 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {amoeba.semantic.incoming_edges = ["Task_0.replica.0.tile.1.0|producer_consumer|tensor_wide|raw", "Task_0.replica.0.tile.1.0|producer_consumer|tensor_wide|waw", "Task_0.replica.0.tile.1.1|producer_consumer|tensor_wide|raw", "Task_0.replica.0.tile.1.1|producer_consumer|tensor_wide|waw", "Task_0.replica.0.tile.1.2|producer_consumer|tensor_wide|raw", "Task_0.replica.0.tile.1.2|producer_consumer|tensor_wide|waw", "Task_0.replica.0.tile.1.3|producer_consumer|tensor_wide|raw", "Task_0.replica.0.tile.1.3|producer_consumer|tensor_wide|waw", "Task_0.replica.1.tile.0.0|producer_consumer|tensor_wide|raw", "Task_0.replica.1.tile.0.0|producer_consumer|tensor_wide|waw", "Task_0.replica.1.tile.0.1|producer_consumer|tensor_wide|raw", "Task_0.replica.1.tile.0.1|producer_consumer|tensor_wide|waw", "Task_0.replica.2|producer_consumer|tensor_wide|raw", "Task_0.replica.2|producer_consumer|tensor_wide|waw", "Task_0.replica.3|producer_consumer|tensor_wide|raw", "Task_0.replica.3|producer_consumer|tensor_wide|waw"], dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg12 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg11, %arg13, %arg12, %arg14, %arg12 : memref<?x100xi32>, i32, index, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<?x100xi32>, i1>, %arg16: !neura.data<i32, i1>, %arg17: !neura.data<index, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = "neura.cast"(%7) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.cast"(%10) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %12 = neura.reserve : !neura.data<index, i1>
        %13 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.phi"(%12, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.reserve : !neura.data<i32, i1>
        %16 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.phi"(%15, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.reserve : !neura.data<i64, i1>
        %19 = "neura.data_mov"(%8) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %20 = "neura.phi"(%18, %19) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %21 = neura.reserve : !neura.data<i64, i1>
        %22 = "neura.data_mov"(%8) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %23 = "neura.phi"(%21, %22) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %24 = "neura.data_mov"(%23) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %25 = "neura.cast"(%24) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %26 = "neura.data_mov"(%25) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.icmp"(%26) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %28 = "neura.data_mov"(%25) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %28, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = "neura.data_mov"(%20) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %32 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %33 = neura.grant_predicate %31, %32 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %34 = "neura.data_mov"(%17) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %36 = neura.grant_predicate %34, %35 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %37 = "neura.data_mov"(%14) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %39 = neura.grant_predicate %37, %38 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %40 = "neura.data_mov"(%30) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.cast"(%40) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %42 = neura.reserve : !neura.data<i64, i1>
        %43 = "neura.data_mov"(%33) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %44 = "neura.phi"(%42, %43) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %45 = neura.reserve : !neura.data<index, i1>
        %46 = "neura.data_mov"(%30) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.phi"(%45, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = neura.reserve : !neura.data<index, i1>
        %49 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.phi"(%48, %49) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = neura.reserve : !neura.data<i32, i1>
        %52 = "neura.data_mov"(%41) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.phi"(%51, %52) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %54 = neura.reserve : !neura.data<i32, i1>
        %55 = "neura.data_mov"(%36) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.phi"(%54, %55) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %57 = neura.reserve : !neura.data<i64, i1>
        %58 = "neura.data_mov"(%33) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %59 = "neura.phi"(%57, %58) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %60 = "neura.data_mov"(%59) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %61 = "neura.cast"(%60) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %62 = "neura.data_mov"(%61) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %63 = "neura.icmp"(%62) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %64 = "neura.data_mov"(%61) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %65 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %66 = neura.grant_predicate %64, %65 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %67 = "neura.data_mov"(%56) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %68 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %69 = neura.grant_predicate %67, %68 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %70 = "neura.data_mov"(%53) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %71 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %72 = neura.grant_predicate %70, %71 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %73 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %74 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %75 = neura.grant_predicate %73, %74 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %76 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %77 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %78 = neura.grant_predicate %76, %77 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %79 = "neura.data_mov"(%44) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %80 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %81 = neura.grant_predicate %79, %80 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %82 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %83 = "neura.not"(%82) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %84 = "neura.data_mov"(%56) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.data_mov"(%83) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %86 = neura.grant_predicate %84, %85 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %87 = "neura.data_mov"(%53) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%83) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %89 = neura.grant_predicate %87, %88 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %90 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %91 = "neura.data_mov"(%83) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %92 = neura.grant_predicate %90, %91 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %93 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %94 = "neura.data_mov"(%83) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %95 = neura.grant_predicate %93, %94 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %96 = "neura.data_mov"(%44) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %97 = "neura.data_mov"(%83) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %98 = neura.grant_predicate %96, %97 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %99 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %100 = "neura.cast"(%99) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %101 = "neura.data_mov"(%100) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %102 = "neura.data_mov"(%69) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %103 = "neura.icmp"(%101, %102) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %104 = "neura.data_mov"(%103) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %105 = "neura.cast"(%104) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %106 = "neura.data_mov"(%100) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %107 = "neura.data_mov"(%72) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %108 = "neura.icmp"(%106, %107) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %109 = "neura.data_mov"(%108) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %110 = "neura.cast"(%109) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %111 = "neura.data_mov"(%105) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %112 = "neura.data_mov"(%110) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %113 = "neura.mul"(%111, %112) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %114 = "neura.data_mov"(%75) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %115 = "neura.data_mov"(%78) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %116 = neura.load_indexed [%114, %115 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %117 = "neura.data_mov"(%75) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = neura.load_indexed [%117, %118 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %120 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = "neura.data_mov"(%78) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %122 = neura.load_indexed [%120, %121 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %123 = "neura.data_mov"(%119) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %124 = "neura.data_mov"(%122) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %125 = "neura.mul"(%123, %124) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %126 = "neura.data_mov"(%125) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %127 = "neura.div"(%126) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %128 = "neura.data_mov"(%113) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %129 = "neura.data_mov"(%127) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %130 = "neura.mul"(%128, %129) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %131 = "neura.data_mov"(%116) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %132 = "neura.data_mov"(%130) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %133 = "neura.sub"(%131, %132) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %134 = "neura.data_mov"(%133) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %135 = "neura.data_mov"(%75) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %136 = "neura.data_mov"(%78) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %134 to [%135, %136 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input0"} : !neura.data<i32, i1>
        %137 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.add"(%137) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %139 = "neura.data_mov"(%138) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %140 = "neura.cast"(%139) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %140 -> %57 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %69 -> %54 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %72 -> %51 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %75 -> %48 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %78 -> %45 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %81 -> %42 : !neura.data<i64, i1> !neura.data<i64, i1>
        %141 = "neura.data_mov"(%86) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %142 = "neura.data_mov"(%89) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %143 = "neura.icmp"(%141, %142) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %144 = "neura.data_mov"(%143) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %145 = "neura.cast"(%144) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %146 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %147 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %148 = neura.load_indexed [%146, %147 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %149 = "neura.data_mov"(%148) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %150 = "neura.add"(%149) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %151 = "neura.data_mov"(%145) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %152 = "neura.data_mov"(%150) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %153 = "neura.mul"(%151, %152) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %154 = "neura.data_mov"(%153) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %155 = "neura.add"(%154) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %156 = "neura.data_mov"(%95) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %157 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %158 = neura.load_indexed [%156, %157 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %159 = "neura.data_mov"(%158) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %160 = "neura.mul"(%159) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %161 = "neura.data_mov"(%160) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %162 = "neura.data_mov"(%155) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %163 = "neura.div"(%161, %162) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %164 = "neura.data_mov"(%163) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %165 = "neura.data_mov"(%95) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %166 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %164 to [%165, %166 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input0"} : !neura.data<i32, i1>
        %167 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %168 = "neura.add"(%167) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %169 = "neura.data_mov"(%168) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %170 = "neura.cast"(%169) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %170 -> %21 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %98 -> %18 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %86 -> %15 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %95 -> %12 : !neura.data<index, i1> !neura.data<index, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %done_writes_18:2 = taskflow.task @Task_3 will_reads(%done_writes_17 : memref<?x100xi32>) will_writes(%done_writes_16#0, %done_writes_16#1 : memref<?x100xi32>, memref<?x100xi32>) value_inputs(%0, %c1_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg3 : memref<?x100xi32>), original_write_memrefs(%arg4, %arg5 : memref<?x100xi32>, memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>, memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg10, %arg15, %arg11, %arg12, %arg13 : i32, memref<?x100xi32>, i32, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<?x100xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<memref<?x100xi32>, i1>, %arg21: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.cast"(%9) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.cast"(%11) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.icmp"(%13, %14) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %16 = "neura.data_mov"(%15) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = "neura.cast"(%16) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %18 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.icmp"(%18, %19) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %21 = "neura.data_mov"(%20) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %22 = "neura.cast"(%21) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %23 = "neura.data_mov"(%17) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.sub"(%23) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = neura.load_indexed [%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %28 = "neura.data_mov"(%17) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.data_mov"(%27) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.mul"(%28, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.data_mov"(%22) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.mul"(%31) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.data_mov"(%30) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.data_mov"(%32) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.add"(%33, %34) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.data_mov"(%35) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %36 to [%37, %38 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %39 = "neura.data_mov"(%24) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %40 = "neura.data_mov"(%27) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %41 = "neura.mul"(%39, %40) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %42 = "neura.data_mov"(%41) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %43 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %44 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %42 to [%43, %44 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>)
    }
    %done_writes_19 = taskflow.task @Task_4 will_reads(%arg2, %arg6, %done_writes_18#0 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>) will_writes(%arg6 : memref<?xi32>) value_inputs(%0, %c1024_i32 : index, i32) [original_read_memrefs(%arg2, %arg6, %arg4 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>), original_write_memrefs(%arg6 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?xi32>, %arg11: memref<?xi32>, %arg12: memref<?x100xi32>, %arg13: memref<?xi32>, %arg14: index, %arg15: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0_24 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg13, %arg12, %arg15, %arg14 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<memref<?xi32>, i1>, %arg17: !neura.data<memref<?xi32>, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<i32, i1>, %arg20: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.cast"(%9) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.data_mov"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %15, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = "neura.data_mov"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %18, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.data_mov"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %21, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.data_mov"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %24, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = "neura.data_mov"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = "neura.not"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %29 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %31 = neura.grant_predicate %29, %30 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %32 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = neura.grant_predicate %32, %33 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %35 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %35, %36 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %38 = "neura.data_mov"(%17) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.data_mov"(%20) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %38 to [%39 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %40 = "neura.data_mov"(%37) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.data_mov"(%20) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %42 = "neura.phi"(%40, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %43 = "neura.data_mov"(%34) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.data_mov"(%26) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %45 = "neura.phi"(%43, %44) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %46 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.data_mov"(%23) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = "neura.phi"(%46, %47) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %49 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.cast"(%49) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %51 = "neura.data_mov"(%50) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.data_mov"(%45) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.icmp"(%51, %52) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %54 = "neura.data_mov"(%53) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %55 = "neura.cast"(%54) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %56 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = neura.load_indexed [%56 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %58 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = neura.load_indexed [%58, %59 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %61 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = neura.load_indexed [%61 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %63 = "neura.data_mov"(%60) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.data_mov"(%62) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %65 = "neura.mul"(%63, %64) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %66 = "neura.data_mov"(%65) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %67 = "neura.div"(%66) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %68 = "neura.data_mov"(%55) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %69 = "neura.data_mov"(%67) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %70 = "neura.mul"(%68, %69) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %71 = "neura.data_mov"(%57) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %72 = "neura.data_mov"(%70) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %73 = "neura.sub"(%71, %72) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %74 = "neura.data_mov"(%73) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %75 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %74 to [%75 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?xi32>)
    }
    %4 = arith.addi %c8_i32, %c-1_i32 : i32
    %done_writes_20 = taskflow.task @Task_5 will_reads(%done_writes_19, %arg7, %done_writes_18#1 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>) will_writes(%arg7 : memref<?xi32>) value_inputs(%0, %4, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg6, %arg7, %arg5 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>), original_write_memrefs(%arg7 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?xi32>, %arg11: memref<?xi32>, %arg12: memref<?x100xi32>, %arg13: memref<?xi32>, %arg14: index, %arg15: i32, %arg16: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg15, %arg14, %arg10, %arg13, %arg12, %arg16, %arg14 : i32, index, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg17: !neura.data<i32, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<memref<?xi32>, i1>, %arg20: !neura.data<memref<?xi32>, i1>, %arg21: !neura.data<memref<?x100xi32>, i1>, %arg22: !neura.data<i32, i1>, %arg23: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = "neura.cast"(%7) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.cast"(%10) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.sub"(%12) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = "neura.mul"(%14) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.data_mov"(%15) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.add"(%16) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = "neura.data_mov"(%17) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = "neura.add"(%18) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.data_mov"(%19) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = neura.load_indexed [%20 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %22 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.mul"(%22) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.data_mov"(%23) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.add"(%24) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.data_mov"(%25) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.add"(%26) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.data_mov"(%21) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.grant_once"(%28) {amoeba.source_owned_once_init} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.data_mov"(%29) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.data_mov"(%27) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %30 to [%31 : !neura.data<index, i1>]  {amoeba.source_owned_once_init, rhs_value = "%input3"} : !neura.data<i32, i1>
        %32 = neura.reserve : !neura.data<index, i1>
        %33 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = "neura.phi"(%32, %33) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %35 = neura.reserve : !neura.data<i32, i1>
        %36 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.phi"(%35, %36) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = neura.reserve : !neura.data<i64, i1>
        %39 = "neura.data_mov"(%8) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %40 = "neura.phi"(%38, %39) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %41 = "neura.data_mov"(%40) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %42 = "neura.cast"(%41) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %43 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %44 = "neura.icmp"(%43) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %45 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = neura.grant_predicate %45, %46 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %48 = "neura.data_mov"(%37) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %49 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %50 = neura.grant_predicate %48, %49 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %51 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %53 = neura.grant_predicate %51, %52 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %54 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %55 = "neura.not"(%54) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %56 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.data_mov"(%55) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %58 = neura.grant_predicate %56, %57 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %59 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.cast"(%59) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %61 = "neura.data_mov"(%60) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %62 = "neura.data_mov"(%50) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %63 = "neura.icmp"(%61, %62) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %64 = "neura.data_mov"(%63) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %65 = "neura.cast"(%64) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %66 = "neura.data_mov"(%53) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %67 = "neura.mul"(%66) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.data_mov"(%67) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.add"(%68) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = "neura.data_mov"(%69) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %71 = "neura.add"(%70) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %72 = "neura.data_mov"(%71) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %73 = neura.load_indexed [%72 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %74 = "neura.data_mov"(%53) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %75 = "neura.mul"(%74) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %76 = "neura.data_mov"(%75) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %77 = "neura.add"(%76) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = "neura.data_mov"(%77) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %79 = "neura.add"(%78) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %80 = "neura.data_mov"(%79) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %81 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %82 = neura.load_indexed [%80, %81 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %83 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %84 = neura.load_indexed [%83 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %85 = "neura.data_mov"(%82) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.data_mov"(%84) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.mul"(%85, %86) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%87) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.div"(%88) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.data_mov"(%65) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %91 = "neura.data_mov"(%89) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %92 = "neura.mul"(%90, %91) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %93 = "neura.data_mov"(%73) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %94 = "neura.data_mov"(%92) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %95 = "neura.sub"(%93, %94) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %96 = "neura.data_mov"(%53) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %97 = "neura.mul"(%96) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %98 = "neura.data_mov"(%97) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %99 = "neura.add"(%98) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %100 = "neura.data_mov"(%99) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %101 = "neura.add"(%100) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %102 = "neura.data_mov"(%95) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %103 = "neura.data_mov"(%101) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %102 to [%103 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %104 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %105 = "neura.add"(%104) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %106 = "neura.data_mov"(%105) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %107 = "neura.cast"(%106) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %107 -> %38 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %50 -> %35 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %53 -> %32 : !neura.data<index, i1> !neura.data<index, i1>
        %108 = "neura.data_mov"(%58) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %109 = "neura.mul"(%108) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %110 = "neura.data_mov"(%109) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %111 = "neura.add"(%110) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %112 = "neura.data_mov"(%111) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %113 = "neura.add"(%112) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %114 = "neura.data_mov"(%113) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %115 = neura.load_indexed [%114 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %116 = "neura.data_mov"(%115) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %117 = "neura.mul"(%116) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %118 = "neura.data_mov"(%58) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = "neura.mul"(%118) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %120 = "neura.data_mov"(%119) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = "neura.add"(%120) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %122 = "neura.data_mov"(%121) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %123 = "neura.add"(%122) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %124 = "neura.data_mov"(%58) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %125 = "neura.mul"(%124) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %126 = "neura.data_mov"(%125) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %127 = "neura.add"(%126) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %128 = "neura.data_mov"(%127) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %129 = "neura.add"(%128) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %130 = "neura.data_mov"(%123) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %131 = "neura.data_mov"(%129) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %132 = neura.load_indexed [%130, %131 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %133 = "neura.data_mov"(%117) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %134 = "neura.data_mov"(%132) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %135 = "neura.div"(%133, %134) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %136 = "neura.data_mov"(%58) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %137 = "neura.mul"(%136) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.data_mov"(%137) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %139 = "neura.add"(%138) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %140 = "neura.data_mov"(%139) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %141 = "neura.add"(%140) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %142 = "neura.data_mov"(%135) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %143 = "neura.data_mov"(%141) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %142 to [%143 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?xi32>)
    }
    %done_writes_21 = taskflow.task @Task_6 will_reads(%done_writes_16#2, %done_writes_18#0 : memref<?x100xi32>, memref<?x100xi32>) will_writes(%done_writes_16#2 : memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg8, %arg4 : memref<?x100xi32>, memref<?x100xi32>), original_write_memrefs(%arg8 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %7 = taskflow.counter parent(%6 : index) from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg14, %arg15, %arg12, %arg11, %arg13 : i32, i32, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<index, i1>):
        %8 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %13 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.cast"(%13) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.cast"(%15) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %17 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.icmp"(%17, %18) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %20 = "neura.data_mov"(%19) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = "neura.data_mov"(%8) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.sel"(%20, %21, %22) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.data_mov"(%12) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.icmp"(%24) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %26 = "neura.data_mov"(%23) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %26, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %29 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %31 = neura.grant_predicate %29, %30 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %32 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = neura.grant_predicate %32, %33 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%12) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %35, %36 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %38 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %40 = neura.grant_predicate %38, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %41 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = "neura.not"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %43 = "neura.data_mov"(%12) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %44 = "neura.data_mov"(%42) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = neura.grant_predicate %43, %44 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %46 = "neura.data_mov"(%16) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %47 = "neura.data_mov"(%42) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %48 = neura.grant_predicate %46, %47 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %49 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.data_mov"(%42) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %51 = neura.grant_predicate %49, %50 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %52 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.data_mov"(%42) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %54 = neura.grant_predicate %52, %53 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %55 = "neura.data_mov"(%28) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %55 to [%56, %57 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %58 = "neura.data_mov"(%54) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%58, %59) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.data_mov"(%51) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %63 = "neura.phi"(%61, %62) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %64 = "neura.data_mov"(%48) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %65 = "neura.data_mov"(%40) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %66 = "neura.phi"(%64, %65) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %67 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.data_mov"(%37) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.phi"(%67, %68) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = "neura.data_mov"(%69) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %71 = "neura.cast"(%70) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %72 = "neura.data_mov"(%71) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %73 = "neura.data_mov"(%66) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %74 = "neura.icmp"(%72, %73) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %75 = "neura.data_mov"(%74) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %76 = "neura.cast"(%75) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %77 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %79 = neura.load_indexed [%77, %78 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %80 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %81 = "neura.data_mov"(%69) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %82 = neura.load_indexed [%80, %81 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %83 = "neura.data_mov"(%69) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %84 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %85 = neura.load_indexed [%83, %84 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %86 = "neura.data_mov"(%82) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.data_mov"(%85) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.mul"(%86, %87) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.data_mov"(%88) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.div"(%89) {rhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %91 = "neura.data_mov"(%76) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %92 = "neura.data_mov"(%90) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %93 = "neura.mul"(%91, %92) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %94 = "neura.data_mov"(%79) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %95 = "neura.data_mov"(%93) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %96 = "neura.sub"(%94, %95) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %97 = "neura.data_mov"(%96) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %98 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %99 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %97 to [%98, %99 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?x100xi32>)
    }
    %done_writes_22 = taskflow.task @Task_7 will_reads(%done_writes_21, %done_writes_18#1 : memref<?x100xi32>, memref<?x100xi32>) will_writes(%done_writes_21 : memref<?x100xi32>) value_inputs(%0, %4, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg8, %arg5 : memref<?x100xi32>, memref<?x100xi32>), original_write_memrefs(%arg8 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg13, %arg12, %arg11, %arg15, %arg13 : i32, index, memref<?x100xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<index, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<i32, i1>, %arg21: !neura.data<index, i1>):
        %7 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.cast"(%8) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %12 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.cast"(%12) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.sub"(%14) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.reserve : !neura.data<index, i1>
        %17 = "neura.data_mov"(%10) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = "neura.phi"(%16, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = neura.reserve : !neura.data<index, i1>
        %20 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%19, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = neura.reserve : !neura.data<i32, i1>
        %23 = "neura.data_mov"(%15) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.phi"(%22, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = neura.reserve : !neura.data<i64, i1>
        %26 = "neura.data_mov"(%9) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %27 = "neura.phi"(%25, %26) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %28 = "neura.data_mov"(%27) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %29 = "neura.cast"(%28) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %30 = "neura.data_mov"(%29) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = "neura.icmp"(%30) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %32 = "neura.data_mov"(%29) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.data_mov"(%31) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = neura.grant_predicate %32, %33 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%24) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.data_mov"(%31) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %35, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %38 = "neura.data_mov"(%21) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %39 = "neura.data_mov"(%31) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %40 = neura.grant_predicate %38, %39 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %41 = "neura.data_mov"(%18) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %42 = "neura.data_mov"(%31) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %43 = neura.grant_predicate %41, %42 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %44 = "neura.data_mov"(%31) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = "neura.not"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %46 = "neura.data_mov"(%21) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.data_mov"(%45) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %48 = neura.grant_predicate %46, %47 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %49 = "neura.data_mov"(%18) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.data_mov"(%45) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %51 = neura.grant_predicate %49, %50 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %52 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.cast"(%52) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %54 = "neura.data_mov"(%53) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.data_mov"(%37) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.icmp"(%54, %55) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %57 = "neura.data_mov"(%56) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %58 = "neura.cast"(%57) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %59 = "neura.data_mov"(%40) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.mul"(%59) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = "neura.add"(%61) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %63 = "neura.data_mov"(%62) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %64 = "neura.add"(%63) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %65 = "neura.data_mov"(%64) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %66 = "neura.data_mov"(%43) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %67 = neura.load_indexed [%65, %66 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %68 = "neura.data_mov"(%40) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.mul"(%68) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = "neura.data_mov"(%69) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %71 = "neura.add"(%70) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %72 = "neura.data_mov"(%71) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %73 = "neura.add"(%72) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %74 = "neura.data_mov"(%73) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %75 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %76 = neura.load_indexed [%74, %75 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %77 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = "neura.data_mov"(%43) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %79 = neura.load_indexed [%77, %78 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %80 = "neura.data_mov"(%76) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %81 = "neura.data_mov"(%79) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %82 = "neura.mul"(%80, %81) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %83 = "neura.data_mov"(%82) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %84 = "neura.div"(%83) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.data_mov"(%58) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.data_mov"(%84) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.mul"(%85, %86) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%67) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.data_mov"(%87) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.sub"(%88, %89) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %91 = "neura.data_mov"(%40) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %92 = "neura.mul"(%91) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %93 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %94 = "neura.add"(%93) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %95 = "neura.data_mov"(%94) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %96 = "neura.add"(%95) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %97 = "neura.data_mov"(%90) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %98 = "neura.data_mov"(%96) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %99 = "neura.data_mov"(%43) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %97 to [%98, %99 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %100 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %101 = "neura.add"(%100) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %102 = "neura.data_mov"(%101) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %103 = "neura.cast"(%102) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %103 -> %25 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %37 -> %22 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %40 -> %19 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %43 -> %16 : !neura.data<index, i1> !neura.data<index, i1>
        %104 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %105 = "neura.mul"(%104) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %106 = "neura.data_mov"(%105) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %107 = "neura.add"(%106) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %108 = "neura.data_mov"(%107) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %109 = "neura.add"(%108) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %110 = "neura.data_mov"(%109) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %111 = "neura.data_mov"(%51) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %112 = neura.load_indexed [%110, %111 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %113 = "neura.data_mov"(%112) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %114 = "neura.mul"(%113) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %115 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %116 = "neura.mul"(%115) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %117 = "neura.data_mov"(%116) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = "neura.add"(%117) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = "neura.data_mov"(%118) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %120 = "neura.add"(%119) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %122 = "neura.mul"(%121) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %123 = "neura.data_mov"(%122) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %124 = "neura.add"(%123) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %125 = "neura.data_mov"(%124) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %126 = "neura.add"(%125) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %127 = "neura.data_mov"(%120) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %128 = "neura.data_mov"(%126) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %129 = neura.load_indexed [%127, %128 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %130 = "neura.data_mov"(%114) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %131 = "neura.data_mov"(%129) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %132 = "neura.div"(%130, %131) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %133 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %134 = "neura.mul"(%133) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %135 = "neura.data_mov"(%134) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %136 = "neura.add"(%135) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %137 = "neura.data_mov"(%136) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.add"(%137) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %139 = "neura.data_mov"(%132) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %140 = "neura.data_mov"(%138) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %141 = "neura.data_mov"(%51) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %139 to [%140, %141 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?x100xi32>)
    }
    memref.store %c1024_i32, %arg9[%c0] : memref<?xi32>
    %done_writes_23 = taskflow.task @Task_8 will_reads(%done_writes_18#1, %arg9 : memref<?x100xi32>, memref<?xi32>) will_writes(%arg9 : memref<?xi32>) value_inputs(%0, %c1024_i32 : index, i32) [original_read_memrefs(%arg5, %arg9 : memref<?x100xi32>, memref<?xi32>), original_write_memrefs(%arg9 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?xi32>, %arg12: memref<?xi32>, %arg13: index, %arg14: i32):
      %c0_24 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0_24 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg10, %arg12, %arg14, %arg13 : memref<?x100xi32>, memref<?xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<?x100xi32>, i1>, %arg16: !neura.data<memref<?xi32>, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %8 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.mul"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.data_mov"(%15) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.div"(%16) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.data_mov"(%17) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %18 to [%19 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?xi32>)
    }
    return
  }
}

