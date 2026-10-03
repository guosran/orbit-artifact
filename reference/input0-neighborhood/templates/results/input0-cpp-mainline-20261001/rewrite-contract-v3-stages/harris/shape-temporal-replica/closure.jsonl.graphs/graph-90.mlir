module {
  func.func @_Z11harris_funciPA128_KiS1_S1_PA128_iS3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_(%arg0: i32, %arg1: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg2: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg3: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg4: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg5: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg6: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg7: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg8: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg9: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg10: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg11: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg12: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg13: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg14: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg15: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg16: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg17: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg18: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg19: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg20: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg21: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg22: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg23: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg24: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg25: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg26: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg27: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-90", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/harris/shape-temporal-replica-mainline-v6-rank-3/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/harris/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 63 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_2", amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.total_trip_count = 7938 : i64, amoeba.static_bound.arg.0 = 63 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %c30_i32 = arith.constant 30 : i32
    %c59_i32 = arith.constant 59 : i32
    %c11_i32 = arith.constant 11 : i32
    %c25500_i32 = arith.constant 25500 : i32
    %c2_i32 = arith.constant 2 : i32
    %c25_i32 = arith.constant 25 : i32
    %c4096_i32 = arith.constant 4096 : i32
    %c16_i32 = arith.constant 16 : i32
    %false = arith.constant false
    %c63 = arith.constant 63 : index
    %cast = memref.cast %arg4 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes = taskflow.task @Task_0.replica.0 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg4 : memref<?x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg4 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 2048 : i64, amoeba.replica.shard_upper = 16 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 16, 128>], trip_count = 2048 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_49 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %3 = taskflow.counter from %c0_49 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_50 = arith.constant 0 : index
      %c128_51 = arith.constant 128 : index
      %4 = taskflow.counter parent(%3 : index) from %c0_50 to %c128_51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<?x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c0_52 = arith.constant 0 : index
        %c16_53 = arith.constant 16 : index
        %5 = neura.counter from %c0_52 : index to %c16_53 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %c0_54 = arith.constant 0 : index
        %c128_55 = arith.constant 128 : index
        %6 = neura.counter from %c0_54 : index to %c128_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.mul"(%7) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %done_writes_0 = taskflow.task @Task_0.replica.1 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg4 : memref<?x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg4 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 16 : i64, amoeba.replica.shard_trip_count = 2048 : i64, amoeba.replica.shard_upper = 32 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 16, 0>], amoeba.tiling.output_region_uppers = [array<i64: 32, 128>], trip_count = 2048 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %3 = taskflow.counter from %c16 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_49 = arith.constant 0 : index
      %c128_50 = arith.constant 128 : index
      %4 = taskflow.counter parent(%3 : index) from %c0_49 to %c128_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<?x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c16_51 = arith.constant 16 : index
        %c32_52 = arith.constant 32 : index
        %5 = neura.counter from %c16_51 : index to %c32_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 16 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %c0_53 = arith.constant 0 : index
        %c128_54 = arith.constant 128 : index
        %6 = neura.counter from %c0_53 : index to %c128_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.mul"(%7) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %done_writes_1 = taskflow.task @Task_0.replica.2 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg4 : memref<?x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg4 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 32 : i64, amoeba.replica.shard_trip_count = 2048 : i64, amoeba.replica.shard_upper = 48 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 32, 0>], amoeba.tiling.output_region_uppers = [array<i64: 48, 128>], trip_count = 2048 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32 = arith.constant 32 : index
      %c48 = arith.constant 48 : index
      %3 = taskflow.counter from %c32 to %c48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_49 = arith.constant 0 : index
      %c128_50 = arith.constant 128 : index
      %4 = taskflow.counter parent(%3 : index) from %c0_49 to %c128_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<?x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c32_51 = arith.constant 32 : index
        %c48_52 = arith.constant 48 : index
        %5 = neura.counter from %c32_51 : index to %c48_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 32 : index, step_value = 1 : index, upper_bound_value = 48 : index} -> !neura.data<index, i1>
        %c0_53 = arith.constant 0 : index
        %c128_54 = arith.constant 128 : index
        %6 = neura.counter from %c0_53 : index to %c128_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.mul"(%7) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %done_writes_2 = taskflow.task @Task_0.replica.3 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg4 : memref<?x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg4 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 48 : i64, amoeba.replica.shard_trip_count = 1920 : i64, amoeba.replica.shard_upper = 63 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 48, 0>], amoeba.tiling.output_region_uppers = [array<i64: 63, 128>], trip_count = 1920 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c48 = arith.constant 48 : index
      %c63_49 = arith.constant 63 : index
      %3 = taskflow.counter from %c48 to %c63_49 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_50 = arith.constant 0 : index
      %c128_51 = arith.constant 128 : index
      %4 = taskflow.counter parent(%3 : index) from %c0_50 to %c128_51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<?x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c48_52 = arith.constant 48 : index
        %c63_53 = arith.constant 63 : index
        %5 = neura.counter from %c48_52 : index to %c63_53 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 48 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c0_54 = arith.constant 0 : index
        %c128_55 = arith.constant 128 : index
        %6 = neura.counter from %c0_54 : index to %c128_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.mul"(%7) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %cast_3 = memref.cast %done_writes : memref<?x128xi32> to memref<256x128xi32>
    %cast_4 = memref.cast %done_writes_0 : memref<?x128xi32> to memref<256x128xi32>
    %cast_5 = memref.cast %done_writes_1 : memref<?x128xi32> to memref<256x128xi32>
    %cast_6 = memref.cast %done_writes_2 : memref<?x128xi32> to memref<256x128xi32>
    %0 = taskflow.join states(%cast_3, %cast_4, %cast_5, %cast_6) base(%cast) axis(0) region([0, 0], [63, 128]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_7 = memref.cast %0 : memref<256x128xi32> to memref<?x128xi32>
    %cast_8 = memref.cast %arg5 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_9 = taskflow.task @Task_1.replica.0 will_reads(%cast_7 : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 2016 : i64, amoeba.replica.shard_upper = 32 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.semantic.incoming_edges = ["Task_0.replica.0|producer_consumer|tensor_wide", "Task_0.replica.1|producer_consumer|tensor_wide", "Task_0.replica.2|producer_consumer|tensor_wide", "Task_0.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 63, 32>], trip_count = 2016 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_49 = arith.constant 0 : index
      %c63_50 = arith.constant 63 : index
      %3 = taskflow.counter from %c0_49 to %c63_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_51 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %4 = taskflow.counter parent(%3 : index) from %c0_51 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %7 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_52 = arith.constant 0 : index
        %c63_53 = arith.constant 63 : index
        %8 = neura.counter from %c0_52 : index to %c63_53 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c0_54 = arith.constant 0 : index
        %c32_55 = arith.constant 32 : index
        %9 = neura.counter from %c0_54 : index to %c32_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %12 = "neura.sel"(%11, %5, %10) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.grant_predicate %6, %11 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %12, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %12, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = "neura.icmp"(%19) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.phi"(%17, %23) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%14, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.phi"(%13, %24) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = "neura.sel"(%29, %28, %27) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %30 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_10 = taskflow.task @Task_1.replica.1 will_reads(%cast_7 : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 32 : i64, amoeba.replica.shard_trip_count = 2016 : i64, amoeba.replica.shard_upper = 64 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.semantic.incoming_edges = ["Task_0.replica.0|producer_consumer|tensor_wide", "Task_0.replica.1|producer_consumer|tensor_wide", "Task_0.replica.2|producer_consumer|tensor_wide", "Task_0.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 32>], amoeba.tiling.output_region_uppers = [array<i64: 63, 64>], trip_count = 2016 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_49 = arith.constant 0 : index
      %c63_50 = arith.constant 63 : index
      %3 = taskflow.counter from %c0_49 to %c63_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %4 = taskflow.counter parent(%3 : index) from %c32 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %7 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_51 = arith.constant 0 : index
        %c63_52 = arith.constant 63 : index
        %8 = neura.counter from %c0_51 : index to %c63_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c32_53 = arith.constant 32 : index
        %c64_54 = arith.constant 64 : index
        %9 = neura.counter from %c32_53 : index to %c64_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 32 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %12 = "neura.sel"(%11, %5, %10) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.grant_predicate %6, %11 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %12, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %12, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = "neura.icmp"(%19) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.phi"(%17, %23) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%14, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.phi"(%13, %24) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = "neura.sel"(%29, %28, %27) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %30 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_11 = taskflow.task @Task_1.replica.2 will_reads(%cast_7 : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 64 : i64, amoeba.replica.shard_trip_count = 2016 : i64, amoeba.replica.shard_upper = 96 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.semantic.incoming_edges = ["Task_0.replica.0|producer_consumer|tensor_wide", "Task_0.replica.1|producer_consumer|tensor_wide", "Task_0.replica.2|producer_consumer|tensor_wide", "Task_0.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 64>], amoeba.tiling.output_region_uppers = [array<i64: 63, 96>], trip_count = 2016 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_49 = arith.constant 0 : index
      %c63_50 = arith.constant 63 : index
      %3 = taskflow.counter from %c0_49 to %c63_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c96 = arith.constant 96 : index
      %4 = taskflow.counter parent(%3 : index) from %c64 to %c96 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %7 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_51 = arith.constant 0 : index
        %c63_52 = arith.constant 63 : index
        %8 = neura.counter from %c0_51 : index to %c63_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c64_53 = arith.constant 64 : index
        %c96_54 = arith.constant 96 : index
        %9 = neura.counter from %c64_53 : index to %c96_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 96 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %12 = "neura.sel"(%11, %5, %10) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.grant_predicate %6, %11 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %12, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %12, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = "neura.icmp"(%19) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.phi"(%17, %23) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%14, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.phi"(%13, %24) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = "neura.sel"(%29, %28, %27) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %30 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_12 = taskflow.task @Task_1.replica.3 will_reads(%cast_7 : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 96 : i64, amoeba.replica.shard_trip_count = 2016 : i64, amoeba.replica.shard_upper = 128 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.semantic.incoming_edges = ["Task_0.replica.0|producer_consumer|tensor_wide", "Task_0.replica.1|producer_consumer|tensor_wide", "Task_0.replica.2|producer_consumer|tensor_wide", "Task_0.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 96>], amoeba.tiling.output_region_uppers = [array<i64: 63, 128>], trip_count = 2016 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_49 = arith.constant 0 : index
      %c63_50 = arith.constant 63 : index
      %3 = taskflow.counter from %c0_49 to %c63_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c96 = arith.constant 96 : index
      %c128_51 = arith.constant 128 : index
      %4 = taskflow.counter parent(%3 : index) from %c96 to %c128_51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %7 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_52 = arith.constant 0 : index
        %c63_53 = arith.constant 63 : index
        %8 = neura.counter from %c0_52 : index to %c63_53 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c96_54 = arith.constant 96 : index
        %c128_55 = arith.constant 128 : index
        %9 = neura.counter from %c96_54 : index to %c128_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 96 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %12 = "neura.sel"(%11, %5, %10) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.grant_predicate %6, %11 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %12, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %7, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %12, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %8, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = "neura.icmp"(%19) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.phi"(%17, %23) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%14, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.phi"(%13, %24) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = "neura.sel"(%29, %28, %27) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %30 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %cast_13 = memref.cast %done_writes_9 : memref<?x128xi32> to memref<256x128xi32>
    %cast_14 = memref.cast %done_writes_10 : memref<?x128xi32> to memref<256x128xi32>
    %cast_15 = memref.cast %done_writes_11 : memref<?x128xi32> to memref<256x128xi32>
    %cast_16 = memref.cast %done_writes_12 : memref<?x128xi32> to memref<256x128xi32>
    %1 = taskflow.join states(%cast_13, %cast_14, %cast_15, %cast_16) base(%cast_8) axis(1) region([0, 0], [63, 128]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_17 = memref.cast %1 : memref<256x128xi32> to memref<?x128xi32>
    %cast_18 = memref.cast %arg6 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_19 = taskflow.task @Task_2.replica.0 will_reads(%cast_17 : memref<?x128xi32>) will_writes(%arg6 : memref<?x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%arg6 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 2016 : i64, amoeba.replica.shard_upper = 16 : i64, amoeba.replica.total_trip_count = 7938 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide", "Task_1.replica.2|producer_consumer|tensor_wide", "Task_1.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 1>], amoeba.tiling.output_region_uppers = [array<i64: 16, 127>], trip_count = 2016 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_49 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %3 = taskflow.counter from %c0_49 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_50 = arith.constant 1 : index
      %c127_51 = arith.constant 127 : index
      %4 = taskflow.counter parent(%3 : index) from %c1_50 to %c127_51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c0_52 = arith.constant 0 : index
        %c16_53 = arith.constant 16 : index
        %5 = neura.counter from %c0_52 : index to %c16_53 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %c1_54 = arith.constant 1 : index
        %c127_55 = arith.constant 127 : index
        %6 = neura.counter from %c1_54 : index to %c127_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %7 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%5, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%5, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_20 = taskflow.task @Task_2.replica.1 will_reads(%cast_17 : memref<?x128xi32>) will_writes(%arg6 : memref<?x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%arg6 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 16 : i64, amoeba.replica.shard_trip_count = 2016 : i64, amoeba.replica.shard_upper = 32 : i64, amoeba.replica.total_trip_count = 7938 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide", "Task_1.replica.2|producer_consumer|tensor_wide", "Task_1.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 16, 1>], amoeba.tiling.output_region_uppers = [array<i64: 32, 127>], trip_count = 2016 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %3 = taskflow.counter from %c16 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_49 = arith.constant 1 : index
      %c127_50 = arith.constant 127 : index
      %4 = taskflow.counter parent(%3 : index) from %c1_49 to %c127_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c16_51 = arith.constant 16 : index
        %c32_52 = arith.constant 32 : index
        %5 = neura.counter from %c16_51 : index to %c32_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 16 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %c1_53 = arith.constant 1 : index
        %c127_54 = arith.constant 127 : index
        %6 = neura.counter from %c1_53 : index to %c127_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %7 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%5, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%5, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_21 = taskflow.task @Task_2.replica.2 will_reads(%cast_17 : memref<?x128xi32>) will_writes(%arg6 : memref<?x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%arg6 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 32 : i64, amoeba.replica.shard_trip_count = 2016 : i64, amoeba.replica.shard_upper = 48 : i64, amoeba.replica.total_trip_count = 7938 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide", "Task_1.replica.2|producer_consumer|tensor_wide", "Task_1.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 32, 1>], amoeba.tiling.output_region_uppers = [array<i64: 48, 127>], trip_count = 2016 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32 = arith.constant 32 : index
      %c48 = arith.constant 48 : index
      %3 = taskflow.counter from %c32 to %c48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_49 = arith.constant 1 : index
      %c127_50 = arith.constant 127 : index
      %4 = taskflow.counter parent(%3 : index) from %c1_49 to %c127_50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c32_51 = arith.constant 32 : index
        %c48_52 = arith.constant 48 : index
        %5 = neura.counter from %c32_51 : index to %c48_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 32 : index, step_value = 1 : index, upper_bound_value = 48 : index} -> !neura.data<index, i1>
        %c1_53 = arith.constant 1 : index
        %c127_54 = arith.constant 127 : index
        %6 = neura.counter from %c1_53 : index to %c127_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %7 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%5, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%5, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_22 = taskflow.task @Task_2.replica.3 will_reads(%cast_17 : memref<?x128xi32>) will_writes(%arg6 : memref<?x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%arg6 : memref<?x128xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 48 : i64, amoeba.replica.shard_trip_count = 1890 : i64, amoeba.replica.shard_upper = 63 : i64, amoeba.replica.total_trip_count = 7938 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide", "Task_1.replica.2|producer_consumer|tensor_wide", "Task_1.replica.3|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 48, 1>], amoeba.tiling.output_region_uppers = [array<i64: 63, 127>], trip_count = 1890 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c48 = arith.constant 48 : index
      %c63_49 = arith.constant 63 : index
      %3 = taskflow.counter from %c48 to %c63_49 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_50 = arith.constant 1 : index
      %c127_51 = arith.constant 127 : index
      %4 = taskflow.counter parent(%3 : index) from %c1_50 to %c127_51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c48_52 = arith.constant 48 : index
        %c63_53 = arith.constant 63 : index
        %5 = neura.counter from %c48_52 : index to %c63_53 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 48 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c1_54 = arith.constant 1 : index
        %c127_55 = arith.constant 127 : index
        %6 = neura.counter from %c1_54 : index to %c127_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %7 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%5, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%5, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %cast_23 = memref.cast %done_writes_19 : memref<?x128xi32> to memref<256x128xi32>
    %cast_24 = memref.cast %done_writes_20 : memref<?x128xi32> to memref<256x128xi32>
    %cast_25 = memref.cast %done_writes_21 : memref<?x128xi32> to memref<256x128xi32>
    %cast_26 = memref.cast %done_writes_22 : memref<?x128xi32> to memref<256x128xi32>
    %2 = taskflow.join states(%cast_23, %cast_24, %cast_25, %cast_26) base(%cast_18) axis(0) region([0, 1], [63, 127]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_27 = memref.cast %2 : memref<256x128xi32> to memref<?x128xi32>
    %done_writes_28 = taskflow.task @Task_3 will_reads(%cast_27 : memref<?x128xi32>) will_writes(%arg7 : memref<?x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg6 : memref<?x128xi32>), original_write_memrefs(%arg7 : memref<?x128xi32>)] {amoeba.semantic.incoming_edges = ["Task_2.replica.0|producer_consumer|tensor_wide", "Task_2.replica.1|producer_consumer|tensor_wide", "Task_2.replica.2|producer_consumer|tensor_wide", "Task_2.replica.3|producer_consumer|tensor_wide"]} : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %3 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.mul"(%10) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%9, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%13, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_29 = taskflow.task @Task_4 will_reads(%done_writes_28 : memref<?x128xi32>) will_writes(%arg8 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg8 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %3 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.sub"(%10) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%11, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%6, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.mul"(%17) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.sub"(%15, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = neura.load_indexed [%6, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.mul"(%21) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%19, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%24, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %27 = "neura.sub"(%23, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %31 = "neura.add"(%27, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %31 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_30 = taskflow.task @Task_5 will_reads(%done_writes_28 : memref<?x128xi32>) will_writes(%arg9 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg9 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %3 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.sub"(%10) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.sub"(%11, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %19 = "neura.sub"(%15, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = neura.load_indexed [%20, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %23 = "neura.add"(%19, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = neura.load_indexed [%24, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %26 = "neura.mul"(%25) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.add"(%23, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %31 = "neura.add"(%27, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %31 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_31 = taskflow.task @Task_6 will_reads(%done_writes_29, %done_writes_30 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg10 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg10 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg31, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg32, %arg30, %3 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%8) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %8, %10 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %12 = neura.grant_predicate %9, %10 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %13 = neura.grant_predicate %6, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %16 = neura.grant_predicate %8, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %9, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %6, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %7, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = "neura.sub"(%11) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.phi"(%14, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%13, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%12, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.phi"(%20, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.icmp"(%23) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %23, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %24, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = neura.grant_predicate %22, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = neura.grant_predicate %21, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %30 = "neura.not"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %31 = neura.grant_predicate %23, %30 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %24, %30 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %22, %30 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = neura.grant_predicate %21, %30 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %35 = "neura.sub"(%26) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.phi"(%29, %34) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %37 = "neura.phi"(%28, %33) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.phi"(%27, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.phi"(%35, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %40 = "neura.add"(%38, %39) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %40 to [%37, %36 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_32 = taskflow.task @Task_7 will_reads(%done_writes_29 : memref<?x128xi32>) will_writes(%arg11 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8 : memref<?x128xi32>), original_write_memrefs(%arg11 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.mul"(%8, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_33 = taskflow.task @Task_8 will_reads(%done_writes_30 : memref<?x128xi32>) will_writes(%arg12 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg9 : memref<?x128xi32>), original_write_memrefs(%arg12 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.mul"(%8, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_34 = taskflow.task @Task_9 will_reads(%done_writes_29, %done_writes_30 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg13 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg13 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg31, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_35 = taskflow.task @Task_10 will_reads(%done_writes_32 : memref<?x128xi32>) will_writes(%arg14 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg11 : memref<?x128xi32>), original_write_memrefs(%arg14 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%6, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%6, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_36 = taskflow.task @Task_11 will_reads(%done_writes_33 : memref<?x128xi32>) will_writes(%arg15 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg12 : memref<?x128xi32>), original_write_memrefs(%arg15 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%6, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%6, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_37 = taskflow.task @Task_12 will_reads(%done_writes_34 : memref<?x128xi32>) will_writes(%arg16 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg13 : memref<?x128xi32>), original_write_memrefs(%arg16 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%6, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%6, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_38 = taskflow.task @Task_13 will_reads(%done_writes_35 : memref<?x128xi32>) will_writes(%arg17 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg14 : memref<?x128xi32>), original_write_memrefs(%arg17 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_39 = taskflow.task @Task_14 will_reads(%done_writes_36 : memref<?x128xi32>) will_writes(%arg18 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg15 : memref<?x128xi32>), original_write_memrefs(%arg18 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_40 = taskflow.task @Task_15 will_reads(%done_writes_37 : memref<?x128xi32>) will_writes(%arg19 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg16 : memref<?x128xi32>), original_write_memrefs(%arg19 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_41 = taskflow.task @Task_16 will_reads(%done_writes_38, %done_writes_39, %done_writes_40 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg20 : memref<?x128xi32>) value_inputs(%c63, %c25_i32 : index, i32) [original_read_memrefs(%arg17, %arg18, %arg19 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg20 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg32, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %arg33, %arg31, %3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.sub"(%10, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%8, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.mul"(%14, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.div"(%15) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.sub"(%13, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %done_writes_42 = taskflow.task @Task_17 will_reads(%done_writes_41 : memref<?x128xi32>) will_writes(%arg21 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg20 : memref<?x128xi32>), original_write_memrefs(%arg21 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %3 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %6) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_43 = taskflow.task @Task_18 will_reads(%done_writes_42 : memref<?x128xi32>) will_writes(%arg22 : memref<?x128xi32>) value_inputs(%c63, %c4096_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg21 : memref<?x128xi32>), original_write_memrefs(%arg22 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %3 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %6) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_44 = taskflow.task @Task_19 will_reads(%done_writes_43 : memref<?x128xi32>) will_writes(%arg23 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg22 : memref<?x128xi32>), original_write_memrefs(%arg23 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%7) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%6, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%6, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%10, %9) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = "neura.sel"(%13, %10, %9) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.icmp"(%12, %14) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %16 = "neura.sel"(%15, %12, %14) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %16 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_45 = taskflow.task @Task_20 will_reads(%done_writes_44 : memref<?x128xi32>) will_writes(%arg24 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg23 : memref<?x128xi32>), original_write_memrefs(%arg24 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %3 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = "neura.add"(%6) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%6) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%10, %9) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = "neura.sel"(%13, %10, %9) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.icmp"(%12, %14) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %16 = "neura.sel"(%15, %12, %14) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %16 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_46 = taskflow.task @Task_21 will_reads(%done_writes_43, %done_writes_45 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg31, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %3 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%9) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %7, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %8, %10 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %9, %10 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %14 = neura.grant_predicate %6, %10 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = "neura.not"(%10) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %16 = neura.grant_predicate %6, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %7, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %8, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %20 = "neura.icmp"(%13, %19) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %21 = "neura.sel"(%20, %13, %14) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.phi"(%12, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%11, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%21, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %24 to [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_47 = taskflow.task @Task_22 will_reads(%done_writes_46, %done_writes_31 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg26 : memref<?x128xi32>) value_inputs(%c63, %c16_i32 : index, i32) [original_read_memrefs(%arg25, %arg10 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg26 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg31, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg32, %arg30, %3 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.div"(%9) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_48 = taskflow.task @Task_23 will_reads(%done_writes_47 : memref<?x128xi32>) will_writes(%arg27 : memref<?x128xi32>) value_inputs(%c63, %c4096_i32 : index, i32) [original_read_memrefs(%arg26 : memref<?x128xi32>), original_write_memrefs(%arg27 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %3 = arith.addi %arg30, %c-1 : index
      %4 = taskflow.counter from %c1 to %3 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %3 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.icmp"(%8) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %10 = "neura.cast"(%9) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    return
  }
}

