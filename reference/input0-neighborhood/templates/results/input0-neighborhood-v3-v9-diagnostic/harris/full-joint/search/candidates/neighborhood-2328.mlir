module {
  func.func @_Z11harris_funciPA128_KiS1_S1_PA128_iS3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_(%arg0: i32, %arg1: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg2: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg3: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg4: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg5: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg6: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg7: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg8: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg9: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg10: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg11: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg12: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg13: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg14: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg15: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg16: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg17: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg18: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg19: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg20: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg21: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg22: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg23: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg24: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg25: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg26: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg27: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-414", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/harris/shape-temporal-replica-mainline-v6-rank-3/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/harris/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 63 : i64, amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_21", amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.static_bound.arg.0 = 63 : i64, llvm.linkage = #llvm.linkage<external>} {
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
    %done_writes = taskflow.task @Task_0.tile.0.0 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%cast : memref<256x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%cast : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_0", steps = [{after = array<i64: 0, 16, 1, 0, 128, 1>, axis = 0 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 4 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 0, 16>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 63>, amoeba.neura.tiling.parent_task = "Task_0", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 16, 128>]} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<256x128xi32>, index, i32, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<256x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_52 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %7 = taskflow.counter from %c0_52 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_53 = arith.constant 0 : index
      %c128_54 = arith.constant 128 : index
      %8 = taskflow.counter parent(%7 : index) from %c0_53 to %c128_54 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<256x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c0_55 = arith.constant 0 : index
        %c16_56 = arith.constant 16 : index
        %9 = neura.counter from %c0_55 : index to %c16_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %c0_57 = arith.constant 0 : index
        %c128_58 = arith.constant 128 : index
        %10 = neura.counter from %c0_57 : index to %c128_58 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %17 = "neura.mul"(%16) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<256x128xi32>)
    }
    %done_writes_0 = taskflow.task @Task_0.tile.0.1 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%cast : memref<256x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%cast : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_0", steps = [{after = array<i64: 16, 32, 1, 0, 128, 1>, axis = 0 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 4 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 16, 32>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 63>, amoeba.neura.tiling.parent_task = "Task_0", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 16, 0>], amoeba.tiling.output_region_uppers = [array<i64: 32, 128>]} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<256x128xi32>, index, i32, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<256x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %7 = taskflow.counter from %c16 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_52 = arith.constant 0 : index
      %c128_53 = arith.constant 128 : index
      %8 = taskflow.counter parent(%7 : index) from %c0_52 to %c128_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<256x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c16_54 = arith.constant 16 : index
        %c32_55 = arith.constant 32 : index
        %9 = neura.counter from %c16_54 : index to %c32_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 16 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %c0_56 = arith.constant 0 : index
        %c128_57 = arith.constant 128 : index
        %10 = neura.counter from %c0_56 : index to %c128_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %17 = "neura.mul"(%16) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<256x128xi32>)
    }
    %done_writes_1 = taskflow.task @Task_0.tile.0.2 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%cast : memref<256x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%cast : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_0", steps = [{after = array<i64: 32, 48, 1, 0, 128, 1>, axis = 0 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 4 : i64, family = "tiling", part = 2 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 32, 48>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 63>, amoeba.neura.tiling.parent_task = "Task_0", amoeba.neura.tiling.part_index = 2 : i64, amoeba.tiling.output_region_lowers = [array<i64: 32, 0>], amoeba.tiling.output_region_uppers = [array<i64: 48, 128>]} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<256x128xi32>, index, i32, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<256x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32 = arith.constant 32 : index
      %c48 = arith.constant 48 : index
      %7 = taskflow.counter from %c32 to %c48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_52 = arith.constant 0 : index
      %c128_53 = arith.constant 128 : index
      %8 = taskflow.counter parent(%7 : index) from %c0_52 to %c128_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<256x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c32_54 = arith.constant 32 : index
        %c48_55 = arith.constant 48 : index
        %9 = neura.counter from %c32_54 : index to %c48_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 32 : index, step_value = 1 : index, upper_bound_value = 48 : index} -> !neura.data<index, i1>
        %c0_56 = arith.constant 0 : index
        %c128_57 = arith.constant 128 : index
        %10 = neura.counter from %c0_56 : index to %c128_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %17 = "neura.mul"(%16) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<256x128xi32>)
    }
    %done_writes_2 = taskflow.task @Task_0.tile.0.3 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%cast : memref<256x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%cast : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_0", steps = [{after = array<i64: 48, 63, 1, 0, 128, 1>, axis = 0 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 4 : i64, family = "tiling", part = 3 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 48, 63>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 63>, amoeba.neura.tiling.parent_task = "Task_0", amoeba.neura.tiling.part_index = 3 : i64, amoeba.tiling.output_region_lowers = [array<i64: 48, 0>], amoeba.tiling.output_region_uppers = [array<i64: 63, 128>]} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<256x128xi32>, index, i32, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<256x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c48 = arith.constant 48 : index
      %c63_52 = arith.constant 63 : index
      %7 = taskflow.counter from %c48 to %c63_52 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_53 = arith.constant 0 : index
      %c128_54 = arith.constant 128 : index
      %8 = taskflow.counter parent(%7 : index) from %c0_53 to %c128_54 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<256x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %c48_55 = arith.constant 48 : index
        %c63_56 = arith.constant 63 : index
        %9 = neura.counter from %c48_55 : index to %c63_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 48 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c0_57 = arith.constant 0 : index
        %c128_58 = arith.constant 128 : index
        %10 = neura.counter from %c0_57 : index to %c128_58 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %17 = "neura.mul"(%16) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<256x128xi32>)
    }
    %0 = taskflow.join states(%done_writes, %done_writes_0, %done_writes_1, %done_writes_2) base(%cast) axis(0) region([0, 0], [63, 128]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_3 = memref.cast %0 : memref<256x128xi32> to memref<?x128xi32>
    %cast_4 = memref.cast %arg5 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_5 = taskflow.task @Task_1.replica.0 will_reads(%cast_3 : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_1", steps = [{after = array<i64: 0, 63, 1, 0, 64, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 2 : i64, family = "replica", part = 0 : i64}]}], amoeba.replica.count = 2 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 4032 : i64, amoeba.replica.shard_upper = 64 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 63, 64>], trip_count = 4032 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_52 = arith.constant 0 : index
      %c63_53 = arith.constant 63 : index
      %7 = taskflow.counter from %c0_52 to %c63_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_54 = arith.constant 0 : index
      %c64 = arith.constant 64 : index
      %8 = taskflow.counter parent(%7 : index) from %c0_54 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %10 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %11 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_55 = arith.constant 0 : index
        %c63_56 = arith.constant 63 : index
        %12 = neura.counter from %c0_55 : index to %c63_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c0_57 = arith.constant 0 : index
        %c64_58 = arith.constant 64 : index
        %13 = neura.counter from %c0_57 : index to %c64_58 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %14 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.icmp"(%14) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %16 = "neura.sel"(%15, %9, %14) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %10, %15 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %11, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = neura.grant_predicate %16, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %12, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %13, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = "neura.not"(%15) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %14, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %24 = neura.grant_predicate %11, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %16, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = "neura.icmp"(%23) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %29 = "neura.phi"(%21, %27) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%20, %26) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = "neura.phi"(%19, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.phi"(%18, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.phi"(%17, %28) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = "neura.sel"(%33, %32, %31) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_6 = taskflow.task @Task_1.replica.1 will_reads(%cast_3 : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_1", steps = [{after = array<i64: 0, 63, 1, 64, 128, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 2 : i64, family = "replica", part = 1 : i64}]}], amoeba.replica.count = 2 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 64 : i64, amoeba.replica.shard_trip_count = 4032 : i64, amoeba.replica.shard_upper = 128 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 64>], amoeba.tiling.output_region_uppers = [array<i64: 63, 128>], trip_count = 4032 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_52 = arith.constant 0 : index
      %c63_53 = arith.constant 63 : index
      %7 = taskflow.counter from %c0_52 to %c63_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c128_54 = arith.constant 128 : index
      %8 = taskflow.counter parent(%7 : index) from %c64 to %c128_54 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %10 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %11 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_55 = arith.constant 0 : index
        %c63_56 = arith.constant 63 : index
        %12 = neura.counter from %c0_55 : index to %c63_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c64_57 = arith.constant 64 : index
        %c128_58 = arith.constant 128 : index
        %13 = neura.counter from %c64_57 : index to %c128_58 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %14 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.icmp"(%14) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %16 = "neura.sel"(%15, %9, %14) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %10, %15 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %11, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = neura.grant_predicate %16, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %12, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %13, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = "neura.not"(%15) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %14, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %24 = neura.grant_predicate %11, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %16, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = "neura.icmp"(%23) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %29 = "neura.phi"(%21, %27) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%20, %26) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = "neura.phi"(%19, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.phi"(%18, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.phi"(%17, %28) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = "neura.sel"(%33, %32, %31) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %cast_7 = memref.cast %done_writes_5 : memref<?x128xi32> to memref<256x128xi32>
    %cast_8 = memref.cast %done_writes_6 : memref<?x128xi32> to memref<256x128xi32>
    %1 = taskflow.join states(%cast_7, %cast_8) base(%cast_4) axis(1) region([0, 0], [63, 128]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_9 = memref.cast %1 : memref<256x128xi32> to memref<?x128xi32>
    %cast_10 = memref.cast %arg6 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_11 = taskflow.task @Task_2.tile.1.0 will_reads(%cast_9 : memref<?x128xi32>) will_writes(%cast_10 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%cast_10 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 1, 127, 1>, root = "Task_2", steps = [{after = array<i64: 0, 63, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_2", amoeba.neura.tiling.part_index = 0 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 1>], amoeba.tiling.output_region_uppers = [array<i64: 63, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_52 = arith.constant 0 : index
      %c63_53 = arith.constant 63 : index
      %7 = taskflow.counter from %c0_52 to %c63_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_54 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %8 = taskflow.counter parent(%7 : index) from %c1_54 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c0_55 = arith.constant 0 : index
        %c63_56 = arith.constant 63 : index
        %9 = neura.counter from %c0_55 : index to %c63_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c1_57 = arith.constant 1 : index
        %c64_58 = arith.constant 64 : index
        %10 = neura.counter from %c1_57 : index to %c64_58 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%9, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%9, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_12 = taskflow.task @Task_2.tile.1.1 will_reads(%cast_9 : memref<?x128xi32>) will_writes(%cast_10 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%cast_10 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 1, 127, 1>, root = "Task_2", steps = [{after = array<i64: 0, 63, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_2", amoeba.neura.tiling.part_index = 1 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 64>], amoeba.tiling.output_region_uppers = [array<i64: 63, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_52 = arith.constant 0 : index
      %c63_53 = arith.constant 63 : index
      %7 = taskflow.counter from %c0_52 to %c63_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_54 = arith.constant 127 : index
      %8 = taskflow.counter parent(%7 : index) from %c64 to %c127_54 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c0_55 = arith.constant 0 : index
        %c63_56 = arith.constant 63 : index
        %9 = neura.counter from %c0_55 : index to %c63_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c64_57 = arith.constant 64 : index
        %c127_58 = arith.constant 127 : index
        %10 = neura.counter from %c64_57 : index to %c127_58 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%9, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%9, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %2 = taskflow.join states(%done_writes_11, %done_writes_12) base(%cast_10) axis(1) region([0, 1], [63, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_13 = memref.cast %2 : memref<256x128xi32> to memref<?x128xi32>
    %cast_14 = memref.cast %arg7 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_15 = taskflow.task @Task_3.tile.1.0 will_reads(%cast_13 : memref<?x128xi32>) will_writes(%cast_14 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg6 : memref<?x128xi32>), original_write_memrefs(%cast_14 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_3", steps = [{after = array<i64: 1, 62, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_3", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_53 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %9 = taskflow.counter parent(%8 : index) from %c1_53 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %7 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %10 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_56 = arith.constant 1 : index
        %c64_57 = arith.constant 64 : index
        %11 = neura.counter from %c1_56 : index to %c64_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.mul"(%14) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%13, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%17, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %19 = "neura.add"(%16, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_16 = taskflow.task @Task_3.tile.1.1 will_reads(%cast_13 : memref<?x128xi32>) will_writes(%cast_14 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg6 : memref<?x128xi32>), original_write_memrefs(%cast_14 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_3", steps = [{after = array<i64: 1, 62, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_3", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 64>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_53 = arith.constant 127 : index
      %9 = taskflow.counter parent(%8 : index) from %c64 to %c127_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %7 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %10 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c64_56 = arith.constant 64 : index
        %c127_57 = arith.constant 127 : index
        %11 = neura.counter from %c64_56 : index to %c127_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.mul"(%14) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%13, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%17, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %19 = "neura.add"(%16, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %3 = taskflow.join states(%done_writes_15, %done_writes_16) base(%cast_14) axis(1) region([1, 1], [62, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_17 = memref.cast %3 : memref<256x128xi32> to memref<?x128xi32>
    %done_writes_18 = taskflow.task @Task_4 will_reads(%cast_17 : memref<?x128xi32>) will_writes(%arg8 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg8 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %7 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.sub"(%14) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %19 = "neura.add"(%15, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = neura.load_indexed [%10, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.mul"(%21) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.sub"(%19, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = neura.load_indexed [%10, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %26 = "neura.mul"(%25) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.add"(%23, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %31 = "neura.sub"(%27, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = neura.load_indexed [%32, %33 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %35 = "neura.add"(%31, %34) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_19 = taskflow.task @Task_5 will_reads(%cast_17 : memref<?x128xi32>) will_writes(%arg9 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg9 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %7 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%12, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.sub"(%14) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%16, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.mul"(%17) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.sub"(%15, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = neura.load_indexed [%20, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %23 = "neura.sub"(%19, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%24, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %27 = "neura.add"(%23, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %30 = "neura.mul"(%29) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.add"(%27, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = neura.load_indexed [%32, %33 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %35 = "neura.add"(%31, %34) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %35 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_20 = taskflow.task @Task_6 will_reads(%done_writes_18, %done_writes_19 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg10 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg10 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg31, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg32, %arg30, %7 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%12) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %12, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %13, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %12, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %13, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %10, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %11, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = "neura.sub"(%15) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.phi"(%18, %23) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%17, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%16, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%24, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.icmp"(%27) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %27, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %31 = neura.grant_predicate %28, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %26, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %33 = neura.grant_predicate %25, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = "neura.not"(%29) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %27, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %36 = neura.grant_predicate %28, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %37 = neura.grant_predicate %26, %34 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %38 = neura.grant_predicate %25, %34 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %39 = "neura.sub"(%30) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %40 = "neura.phi"(%33, %38) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.phi"(%32, %37) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %42 = "neura.phi"(%31, %36) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %43 = "neura.phi"(%39, %35) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.add"(%42, %43) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %44 to [%41, %40 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_21 = taskflow.task @Task_7 will_reads(%done_writes_18 : memref<?x128xi32>) will_writes(%arg11 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8 : memref<?x128xi32>), original_write_memrefs(%arg11 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_22 = taskflow.task @Task_8 will_reads(%done_writes_19 : memref<?x128xi32>) will_writes(%arg12 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg9 : memref<?x128xi32>), original_write_memrefs(%arg12 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_23 = taskflow.task @Task_9 will_reads(%done_writes_18, %done_writes_19 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg13 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg13 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg31, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %7 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_24 = taskflow.task @Task_10 will_reads(%done_writes_21 : memref<?x128xi32>) will_writes(%arg14 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg11 : memref<?x128xi32>), original_write_memrefs(%arg14 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%10, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%10, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_25 = taskflow.task @Task_11 will_reads(%done_writes_22 : memref<?x128xi32>) will_writes(%arg15 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg12 : memref<?x128xi32>), original_write_memrefs(%arg15 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%10, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%10, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_26 = taskflow.task @Task_12 will_reads(%done_writes_23 : memref<?x128xi32>) will_writes(%arg16 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg13 : memref<?x128xi32>), original_write_memrefs(%arg16 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%10, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%10, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_27 = taskflow.task @Task_13 will_reads(%done_writes_24 : memref<?x128xi32>) will_writes(%arg17 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg14 : memref<?x128xi32>), original_write_memrefs(%arg17 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%16, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_28 = taskflow.task @Task_14 will_reads(%done_writes_25 : memref<?x128xi32>) will_writes(%arg18 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg15 : memref<?x128xi32>), original_write_memrefs(%arg18 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%16, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_29 = taskflow.task @Task_15 will_reads(%done_writes_26 : memref<?x128xi32>) will_writes(%arg19 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg16 : memref<?x128xi32>), original_write_memrefs(%arg19 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%13, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%16, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_30 = taskflow.task @Task_16 will_reads(%done_writes_27, %done_writes_28, %done_writes_29 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg20 : memref<?x128xi32>) value_inputs(%c63, %c25_i32 : index, i32) [original_read_memrefs(%arg17, %arg18, %arg19 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg20 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg32, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %arg33, %arg31, %7 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%15, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.sub"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.mul"(%18, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.div"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.sub"(%17, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %21 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %done_writes_31 = taskflow.task @Task_17 will_reads(%done_writes_30 : memref<?x128xi32>) will_writes(%arg21 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg20 : memref<?x128xi32>), original_write_memrefs(%arg21 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %7 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %10 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.sel"(%14, %13, %10) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %cast_32 = memref.cast %arg22 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_33 = taskflow.task @Task_18.tile.1.0 will_reads(%done_writes_31 : memref<?x128xi32>) will_writes(%cast_32 : memref<256x128xi32>) value_inputs(%c63, %c4096_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg21 : memref<?x128xi32>), original_write_memrefs(%cast_32 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_18", steps = [{after = array<i64: 1, 62, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_18", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_53 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %9 = taskflow.counter parent(%8 : index) from %c1_53 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %7 : memref<?x128xi32>, i32, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<256x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %11 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_56 = arith.constant 1 : index
        %c64_57 = arith.constant 64 : index
        %12 = neura.counter from %c1_56 : index to %c64_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.sel"(%14, %13, %10) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_34 = taskflow.task @Task_18.tile.1.1 will_reads(%done_writes_31 : memref<?x128xi32>) will_writes(%cast_32 : memref<256x128xi32>) value_inputs(%c63, %c4096_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg21 : memref<?x128xi32>), original_write_memrefs(%cast_32 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_18", steps = [{after = array<i64: 1, 62, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_18", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 64>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_53 = arith.constant 127 : index
      %9 = taskflow.counter parent(%8 : index) from %c64 to %c127_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %7 : memref<?x128xi32>, i32, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<256x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %11 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c64_56 = arith.constant 64 : index
        %c127_57 = arith.constant 127 : index
        %12 = neura.counter from %c64_56 : index to %c127_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.sel"(%14, %13, %10) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %4 = taskflow.join states(%done_writes_33, %done_writes_34) base(%cast_32) axis(1) region([1, 1], [62, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_35 = memref.cast %4 : memref<256x128xi32> to memref<?x128xi32>
    %cast_36 = memref.cast %arg23 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_37 = taskflow.task @Task_19.tile.1.0 will_reads(%cast_35 : memref<?x128xi32>) will_writes(%cast_36 : memref<256x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg22 : memref<?x128xi32>), original_write_memrefs(%cast_36 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_19", steps = [{after = array<i64: 1, 62, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_19", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_53 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %9 = taskflow.counter parent(%8 : index) from %c1_53 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<256x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %10 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_56 = arith.constant 1 : index
        %c64_57 = arith.constant 64 : index
        %11 = neura.counter from %c1_56 : index to %c64_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%10, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%10, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.icmp"(%14, %13) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %18 = "neura.sel"(%17, %14, %13) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.icmp"(%16, %18) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %20 = "neura.sel"(%19, %16, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_38 = taskflow.task @Task_19.tile.1.1 will_reads(%cast_35 : memref<?x128xi32>) will_writes(%cast_36 : memref<256x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg22 : memref<?x128xi32>), original_write_memrefs(%cast_36 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_19", steps = [{after = array<i64: 1, 62, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_19", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 64>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_53 = arith.constant 127 : index
      %9 = taskflow.counter parent(%8 : index) from %c64 to %c127_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<256x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %10 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c64_56 = arith.constant 64 : index
        %c127_57 = arith.constant 127 : index
        %11 = neura.counter from %c64_56 : index to %c127_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%10, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%11) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%10, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.icmp"(%14, %13) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %18 = "neura.sel"(%17, %14, %13) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.icmp"(%16, %18) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %20 = "neura.sel"(%19, %16, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %5 = taskflow.join states(%done_writes_37, %done_writes_38) base(%cast_36) axis(1) region([1, 1], [62, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_39 = memref.cast %5 : memref<256x128xi32> to memref<?x128xi32>
    %done_writes_40 = taskflow.task @Task_20 will_reads(%cast_39 : memref<?x128xi32>) will_writes(%arg24 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg23 : memref<?x128xi32>), original_write_memrefs(%arg24 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg30, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %7 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%15, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.icmp"(%14, %13) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %18 = "neura.sel"(%17, %14, %13) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.icmp"(%16, %18) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %20 = "neura.sel"(%19, %16, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %cast_41 = memref.cast %arg25 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_42 = taskflow.task @Task_21.replica.0 will_reads(%cast_35, %done_writes_40 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 1, 33, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 1 : i64, amoeba.replica.shard_trip_count = 1952 : i64, amoeba.replica.shard_upper = 33 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 33>], trip_count = 1952 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg31, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_53 = arith.constant 1 : index
      %c33 = arith.constant 33 : index
      %9 = taskflow.counter parent(%8 : index) from %c1_53 to %c33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %7 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %11 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_56 = arith.constant 1 : index
        %c33_57 = arith.constant 33 : index
        %12 = neura.counter from %c1_56 : index to %c33_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 33 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %13, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %10, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %11, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %12, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = "neura.icmp"(%17, %23) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.sel"(%24, %17, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%25, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_43 = taskflow.task @Task_21.replica.1 will_reads(%cast_35, %done_writes_40 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 33, 65, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 1 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 33 : i64, amoeba.replica.shard_trip_count = 1952 : i64, amoeba.replica.shard_upper = 65 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 33>], amoeba.tiling.output_region_uppers = [array<i64: 62, 65>], trip_count = 1952 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg31, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c33 = arith.constant 33 : index
      %c65 = arith.constant 65 : index
      %9 = taskflow.counter parent(%8 : index) from %c33 to %c65 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %7 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_53 = arith.constant 1 : index
        %c62_54 = arith.constant 62 : index
        %11 = neura.counter from %c1_53 : index to %c62_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c33_55 = arith.constant 33 : index
        %c65_56 = arith.constant 65 : index
        %12 = neura.counter from %c33_55 : index to %c65_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 33 : index, step_value = 1 : index, upper_bound_value = 65 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %13, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %10, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %11, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %12, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = "neura.icmp"(%17, %23) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.sel"(%24, %17, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%25, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_44 = taskflow.task @Task_21.replica.2 will_reads(%cast_35, %done_writes_40 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 65, 96, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 2 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 65 : i64, amoeba.replica.shard_trip_count = 1891 : i64, amoeba.replica.shard_upper = 96 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 65>], amoeba.tiling.output_region_uppers = [array<i64: 62, 96>], trip_count = 1891 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg31, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c65 = arith.constant 65 : index
      %c96 = arith.constant 96 : index
      %9 = taskflow.counter parent(%8 : index) from %c65 to %c96 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %7 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_53 = arith.constant 1 : index
        %c62_54 = arith.constant 62 : index
        %11 = neura.counter from %c1_53 : index to %c62_54 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c65_55 = arith.constant 65 : index
        %c96_56 = arith.constant 96 : index
        %12 = neura.counter from %c65_55 : index to %c96_56 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 65 : index, step_value = 1 : index, upper_bound_value = 96 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %13, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %10, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %11, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %12, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = "neura.icmp"(%17, %23) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.sel"(%24, %17, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%25, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_45 = taskflow.task @Task_21.replica.3 will_reads(%cast_35, %done_writes_40 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 96, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 3 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 96 : i64, amoeba.replica.shard_trip_count = 1891 : i64, amoeba.replica.shard_upper = 127 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 96>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>], trip_count = 1891 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg31, %c-1 : index
      %c1_52 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %8 = taskflow.counter from %c1_52 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c96 = arith.constant 96 : index
      %c127_53 = arith.constant 127 : index
      %9 = taskflow.counter parent(%8 : index) from %c96 to %c127_53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %7 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %10 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_54 = arith.constant 1 : index
        %c62_55 = arith.constant 62 : index
        %11 = neura.counter from %c1_54 : index to %c62_55 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c96_56 = arith.constant 96 : index
        %c127_57 = arith.constant 127 : index
        %12 = neura.counter from %c96_56 : index to %c127_57 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 96 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %13, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %10, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %11, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %12, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = "neura.icmp"(%17, %23) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = "neura.sel"(%24, %17, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%16, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%25, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %cast_46 = memref.cast %done_writes_42 : memref<?x128xi32> to memref<256x128xi32>
    %cast_47 = memref.cast %done_writes_43 : memref<?x128xi32> to memref<256x128xi32>
    %cast_48 = memref.cast %done_writes_44 : memref<?x128xi32> to memref<256x128xi32>
    %cast_49 = memref.cast %done_writes_45 : memref<?x128xi32> to memref<256x128xi32>
    %6 = taskflow.join states(%cast_46, %cast_47, %cast_48, %cast_49) base(%cast_41) axis(1) region([1, 1], [62, 127]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_50 = memref.cast %6 : memref<256x128xi32> to memref<?x128xi32>
    %done_writes_51:2 = taskflow.task @Task_22.fuse.Task_23 will_reads(%cast_50, %done_writes_20 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg26, %arg27 : memref<?x128xi32>, memref<?x128xi32>) value_inputs(%c63, %c16_i32, %c4096_i32 : index, i32, i32) [original_read_memrefs(%arg25, %arg10 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg26, %arg27 : memref<?x128xi32>, memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_22", steps = []}, {original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_23", steps = []}], amoeba.neura.fusion.eliminated_loads = 0 : i64, amoeba.neura.fusion.eliminated_stores = 0 : i64, amoeba.neura.fusion.mode = "retained", amoeba.neura.joint_rewrite = "post-neura-producer-consumer-retained", amoeba.semantic.incoming_edges = ["Task_21.replica.0|producer_consumer|tensor_wide", "Task_21.replica.1|producer_consumer|tensor_wide", "Task_21.replica.2|producer_consumer|tensor_wide", "Task_21.replica.3|producer_consumer|tensor_wide", "Task_6|producer_consumer|tensor_wide"]} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>, memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32, %arg34: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %7 = arith.addi %arg32, %c-1 : index
      %8 = taskflow.counter from %c1 to %7 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %9 = taskflow.counter parent(%8 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg33, %arg30, %7, %arg34, %arg31 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index, i32, memref<?x128xi32>) attributes {accelerator = "neura"} {
      ^bb0(%arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>, %arg41: !neura.data<memref<?x128xi32>, i1>):
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %14 = "neura.div"(%13) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %16 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %17 = "neura.icmp"(%16) <{cmpType = "sgt"}> {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %18 = "neura.cast"(%17) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield
      }
      taskflow.yield done_writes(%arg30, %arg31 : memref<?x128xi32>, memref<?x128xi32>)
    }
    return
  }
}

