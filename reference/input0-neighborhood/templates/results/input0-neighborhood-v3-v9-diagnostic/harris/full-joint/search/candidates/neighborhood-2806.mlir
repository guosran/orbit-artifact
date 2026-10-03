module {
  func.func @_Z11harris_funciPA128_KiS1_S1_PA128_iS3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_(%arg0: i32, %arg1: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg2: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg3: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg4: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg5: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg6: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg7: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg8: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg9: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg10: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg11: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg12: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg13: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg14: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg15: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg16: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg17: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg18: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg19: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg20: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg21: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg22: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg23: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg24: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg25: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg26: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg27: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-555", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/harris/shape-temporal-replica-mainline-v6-rank-3/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/harris/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 63 : i64, amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_21", amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.static_bound.arg.0 = 63 : i64, llvm.linkage = #llvm.linkage<external>} {
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
    %done_writes = taskflow.task @Task_0 will_reads(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg4 : memref<?x128xi32>) value_inputs(%c63, %c30_i32, %c59_i32, %c11_i32 : index, i32, i32, i32) [original_read_memrefs(%arg1, %arg2, %arg3 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg4 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32, %arg34: i32, %arg35: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %6 = taskflow.counter from %c0 to %arg32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %7 = taskflow.counter parent(%6 : index) from %c0 to %c128 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<?x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.mul"(%10) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%15) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %cast = memref.cast %arg5 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_0 = taskflow.task @Task_1.replica.0 will_reads(%done_writes : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_1", steps = [{after = array<i64: 0, 63, 1, 0, 64, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 2 : i64, family = "replica", part = 0 : i64}]}], amoeba.replica.count = 2 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_trip_count = 4032 : i64, amoeba.replica.shard_upper = 64 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 63, 64>], trip_count = 4032 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_46 = arith.constant 0 : index
      %c63_47 = arith.constant 63 : index
      %6 = taskflow.counter from %c0_46 to %c63_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_48 = arith.constant 0 : index
      %c64 = arith.constant 64 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_48 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %9 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %10 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_49 = arith.constant 0 : index
        %c63_50 = arith.constant 63 : index
        %11 = neura.counter from %c0_49 : index to %c63_50 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c0_51 = arith.constant 0 : index
        %c64_52 = arith.constant 64 : index
        %12 = neura.counter from %c0_51 : index to %c64_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.sel"(%14, %8, %13) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %9, %14 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %15, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %13, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = neura.grant_predicate %10, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %24 = neura.grant_predicate %15, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %11, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = "neura.icmp"(%22) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %28 = "neura.phi"(%20, %26) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%19, %25) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%18, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.phi"(%17, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.phi"(%16, %27) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %33 = "neura.sel"(%32, %31, %30) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %33 to [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_1 = taskflow.task @Task_1.replica.1 will_reads(%done_writes : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 0, 128, 1>, root = "Task_1", steps = [{after = array<i64: 0, 63, 1, 64, 128, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 0, 128, 1>, factor = 2 : i64, family = "replica", part = 1 : i64}]}], amoeba.replica.count = 2 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 64 : i64, amoeba.replica.shard_trip_count = 4032 : i64, amoeba.replica.shard_upper = 128 : i64, amoeba.replica.total_trip_count = 8064 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 64>], amoeba.tiling.output_region_uppers = [array<i64: 63, 128>], trip_count = 4032 : i64} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_46 = arith.constant 0 : index
      %c63_47 = arith.constant 63 : index
      %6 = taskflow.counter from %c0_46 to %c63_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c128_48 = arith.constant 128 : index
      %7 = taskflow.counter parent(%6 : index) from %c64 to %c128_48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %9 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %10 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %c0_49 = arith.constant 0 : index
        %c63_50 = arith.constant 63 : index
        %11 = neura.counter from %c0_49 : index to %c63_50 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c64_51 = arith.constant 64 : index
        %c128_52 = arith.constant 128 : index
        %12 = neura.counter from %c64_51 : index to %c128_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.sel"(%14, %8, %13) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %9, %14 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %15, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %13, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = neura.grant_predicate %10, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %24 = neura.grant_predicate %15, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %11, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = "neura.icmp"(%22) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %28 = "neura.phi"(%20, %26) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%19, %25) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%18, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.phi"(%17, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.phi"(%16, %27) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %33 = "neura.sel"(%32, %31, %30) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %33 to [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %cast_2 = memref.cast %done_writes_0 : memref<?x128xi32> to memref<256x128xi32>
    %cast_3 = memref.cast %done_writes_1 : memref<?x128xi32> to memref<256x128xi32>
    %0 = taskflow.join states(%cast_2, %cast_3) base(%cast) axis(1) region([0, 0], [63, 128]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_4 = memref.cast %0 : memref<256x128xi32> to memref<?x128xi32>
    %cast_5 = memref.cast %arg6 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_6 = taskflow.task @Task_2.tile.1.0 will_reads(%cast_4 : memref<?x128xi32>) will_writes(%cast_5 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%cast_5 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 1, 127, 1>, root = "Task_2", steps = [{after = array<i64: 0, 63, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_2", amoeba.neura.tiling.part_index = 0 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 1>], amoeba.tiling.output_region_uppers = [array<i64: 63, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_46 = arith.constant 0 : index
      %c63_47 = arith.constant 63 : index
      %6 = taskflow.counter from %c0_46 to %c63_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_48 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %7 = taskflow.counter parent(%6 : index) from %c1_48 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c0_49 = arith.constant 0 : index
        %c63_50 = arith.constant 63 : index
        %8 = neura.counter from %c0_49 : index to %c63_50 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c1_51 = arith.constant 1 : index
        %c64_52 = arith.constant 64 : index
        %9 = neura.counter from %c1_51 : index to %c64_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %10 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%8, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%8, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_7 = taskflow.task @Task_2.tile.1.1 will_reads(%cast_4 : memref<?x128xi32>) will_writes(%cast_5 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%cast_5 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 63, 1, 1, 127, 1>, root = "Task_2", steps = [{after = array<i64: 0, 63, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 0, 63, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_2", amoeba.neura.tiling.part_index = 1 : i64, amoeba.semantic.incoming_edges = ["Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide"], amoeba.tiling.output_region_lowers = [array<i64: 0, 64>], amoeba.tiling.output_region_uppers = [array<i64: 63, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_46 = arith.constant 0 : index
      %c63_47 = arith.constant 63 : index
      %6 = taskflow.counter from %c0_46 to %c63_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_48 = arith.constant 127 : index
      %7 = taskflow.counter parent(%6 : index) from %c64 to %c127_48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c0_49 = arith.constant 0 : index
        %c63_50 = arith.constant 63 : index
        %8 = neura.counter from %c0_49 : index to %c63_50 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 63 : index} -> !neura.data<index, i1>
        %c64_51 = arith.constant 64 : index
        %c127_52 = arith.constant 127 : index
        %9 = neura.counter from %c64_51 : index to %c127_52 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %10 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%8, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%12) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%8, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %1 = taskflow.join states(%done_writes_6, %done_writes_7) base(%cast_5) axis(1) region([0, 1], [63, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_8 = memref.cast %1 : memref<256x128xi32> to memref<?x128xi32>
    %cast_9 = memref.cast %arg7 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_10 = taskflow.task @Task_3.tile.1.0 will_reads(%cast_8 : memref<?x128xi32>) will_writes(%cast_9 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg6 : memref<?x128xi32>), original_write_memrefs(%cast_9 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_3", steps = [{after = array<i64: 1, 62, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_3", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_47 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %8 = taskflow.counter parent(%7 : index) from %c1_47 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %6 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %9 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_50 = arith.constant 1 : index
        %c64_51 = arith.constant 64 : index
        %10 = neura.counter from %c1_50 : index to %c64_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%16, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_11 = taskflow.task @Task_3.tile.1.1 will_reads(%cast_8 : memref<?x128xi32>) will_writes(%cast_9 : memref<256x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg6 : memref<?x128xi32>), original_write_memrefs(%cast_9 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_3", steps = [{after = array<i64: 1, 62, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_3", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 64>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_47 = arith.constant 127 : index
      %8 = taskflow.counter parent(%7 : index) from %c64 to %c127_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %6 : memref<?x128xi32>, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<256x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %9 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c64_50 = arith.constant 64 : index
        %c127_51 = arith.constant 127 : index
        %10 = neura.counter from %c64_50 : index to %c127_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%13) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%16, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%15, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %2 = taskflow.join states(%done_writes_10, %done_writes_11) base(%cast_9) axis(1) region([1, 1], [62, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_12 = memref.cast %2 : memref<256x128xi32> to memref<?x128xi32>
    %done_writes_13 = taskflow.task @Task_4 will_reads(%cast_12 : memref<?x128xi32>) will_writes(%arg8 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg8 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %6 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.sub"(%13) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.load_indexed [%15, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %18 = "neura.add"(%14, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = neura.load_indexed [%9, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %21 = "neura.mul"(%20) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.sub"(%18, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = neura.load_indexed [%9, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %25 = "neura.mul"(%24) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.add"(%22, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%27, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %30 = "neura.sub"(%26, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %32 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = neura.load_indexed [%31, %32 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %34 = "neura.add"(%30, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_14 = taskflow.task @Task_5 will_reads(%cast_12 : memref<?x128xi32>) will_writes(%arg9 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg9 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %6 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.sub"(%13) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%15, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.mul"(%16) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.sub"(%14, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = neura.load_indexed [%19, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %22 = "neura.sub"(%18, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = neura.load_indexed [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %26 = "neura.add"(%22, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = neura.load_indexed [%27, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%28) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.add"(%26, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %32 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = neura.load_indexed [%31, %32 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %34 = "neura.add"(%30, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_15 = taskflow.task @Task_6 will_reads(%done_writes_13, %done_writes_14 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg10 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg10 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg31, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg32, %arg30, %6 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%11) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %11, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %12, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = neura.grant_predicate %9, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %11, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %12, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %9, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = "neura.sub"(%14) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.phi"(%17, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%16, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%15, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.phi"(%23, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.icmp"(%26) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %29 = neura.grant_predicate %26, %28 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %30 = neura.grant_predicate %27, %28 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %31 = neura.grant_predicate %25, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %32 = neura.grant_predicate %24, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %33 = "neura.not"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = neura.grant_predicate %26, %33 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %35 = neura.grant_predicate %27, %33 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %36 = neura.grant_predicate %25, %33 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %37 = neura.grant_predicate %24, %33 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %38 = "neura.sub"(%29) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.phi"(%32, %37) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %40 = "neura.phi"(%31, %36) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.phi"(%30, %35) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %42 = "neura.phi"(%38, %34) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %43 = "neura.add"(%41, %42) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %43 to [%40, %39 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_16 = taskflow.task @Task_7 will_reads(%done_writes_13 : memref<?x128xi32>) will_writes(%arg11 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8 : memref<?x128xi32>), original_write_memrefs(%arg11 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %12 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_17 = taskflow.task @Task_8 will_reads(%done_writes_14 : memref<?x128xi32>) will_writes(%arg12 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg9 : memref<?x128xi32>), original_write_memrefs(%arg12 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %12 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_18 = taskflow.task @Task_9 will_reads(%done_writes_13, %done_writes_14 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg13 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg13 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg31, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %6 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_19 = taskflow.task @Task_10 will_reads(%done_writes_16 : memref<?x128xi32>) will_writes(%arg14 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg11 : memref<?x128xi32>), original_write_memrefs(%arg14 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%9, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%9, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_20 = taskflow.task @Task_11 will_reads(%done_writes_17 : memref<?x128xi32>) will_writes(%arg15 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg12 : memref<?x128xi32>), original_write_memrefs(%arg15 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%9, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%9, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_21 = taskflow.task @Task_12 will_reads(%done_writes_18 : memref<?x128xi32>) will_writes(%arg16 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg13 : memref<?x128xi32>), original_write_memrefs(%arg16 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%9, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%9, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_22 = taskflow.task @Task_13 will_reads(%done_writes_19 : memref<?x128xi32>) will_writes(%arg17 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg14 : memref<?x128xi32>), original_write_memrefs(%arg17 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%15, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_23 = taskflow.task @Task_14 will_reads(%done_writes_20 : memref<?x128xi32>) will_writes(%arg18 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg15 : memref<?x128xi32>), original_write_memrefs(%arg18 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%15, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_24 = taskflow.task @Task_15 will_reads(%done_writes_21 : memref<?x128xi32>) will_writes(%arg19 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg16 : memref<?x128xi32>), original_write_memrefs(%arg19 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.load_indexed [%15, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %17 = "neura.add"(%14, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_25:2 = taskflow.task @Task_16.fuse.Task_17 will_reads(%done_writes_22, %done_writes_23, %done_writes_24 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg20, %arg21 : memref<?x128xi32>, memref<?x128xi32>) value_inputs(%c63, %c25_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg17, %arg18, %arg19 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg20, %arg21 : memref<?x128xi32>, memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_16", steps = []}, {original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_17", steps = []}], amoeba.neura.fusion.eliminated_loads = 0 : i64, amoeba.neura.fusion.eliminated_stores = 0 : i64, amoeba.neura.fusion.mode = "retained", amoeba.neura.joint_rewrite = "post-neura-producer-consumer-retained"} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>, memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: memref<?x128xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg33, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %arg34, %arg31, %6, %arg35, %arg32 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index, i32, memref<?x128xi32>) attributes {accelerator = "neura"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<memref<?x128xi32>, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<index, i1>, %arg42: !neura.data<i32, i1>, %arg43: !neura.data<memref<?x128xi32>, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.mul"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %15 = "neura.mul"(%14, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.sub"(%13, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.mul"(%17, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.div"(%18) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.sub"(%16, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %21 = "neura.constant"() <{value = "%input6"}> : () -> !neura.data<i32, i1>
        %22 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %23 = "neura.icmp"(%22) <{cmpType = "sgt"}> {rhs_value = "%input6"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %24 = "neura.sel"(%23, %22, %21) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %24 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input7"} : !neura.data<i32, i1>
        neura.yield
      }
      taskflow.yield done_writes(%arg31, %arg32 : memref<?x128xi32>, memref<?x128xi32>)
    }
    %cast_26 = memref.cast %arg22 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_27 = taskflow.task @Task_18.tile.1.0 will_reads(%done_writes_25#1 : memref<?x128xi32>) will_writes(%cast_26 : memref<256x128xi32>) value_inputs(%c63, %c4096_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg21 : memref<?x128xi32>), original_write_memrefs(%cast_26 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_18", steps = [{after = array<i64: 1, 62, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_18", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_47 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %8 = taskflow.counter parent(%7 : index) from %c1_47 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %6 : memref<?x128xi32>, i32, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<256x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %10 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_50 = arith.constant 1 : index
        %c64_51 = arith.constant 64 : index
        %11 = neura.counter from %c1_50 : index to %c64_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = "neura.sel"(%13, %12, %9) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_28 = taskflow.task @Task_18.tile.1.1 will_reads(%done_writes_25#1 : memref<?x128xi32>) will_writes(%cast_26 : memref<256x128xi32>) value_inputs(%c63, %c4096_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg21 : memref<?x128xi32>), original_write_memrefs(%cast_26 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_18", steps = [{after = array<i64: 1, 62, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_18", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 64>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index, i32, i32) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_47 = arith.constant 127 : index
      %8 = taskflow.counter parent(%7 : index) from %c64 to %c127_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %6 : memref<?x128xi32>, i32, i32, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<256x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %10 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c64_50 = arith.constant 64 : index
        %c127_51 = arith.constant 127 : index
        %11 = neura.counter from %c64_50 : index to %c127_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = "neura.sel"(%13, %12, %9) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %3 = taskflow.join states(%done_writes_27, %done_writes_28) base(%cast_26) axis(1) region([1, 1], [62, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_29 = memref.cast %3 : memref<256x128xi32> to memref<?x128xi32>
    %cast_30 = memref.cast %arg23 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_31 = taskflow.task @Task_19.tile.1.0 will_reads(%cast_29 : memref<?x128xi32>) will_writes(%cast_30 : memref<256x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg22 : memref<?x128xi32>), original_write_memrefs(%cast_30 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_19", steps = [{after = array<i64: 1, 62, 1, 1, 64, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 1, 64>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_19", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 64>]} : (memref<?x128xi32>, memref<256x128xi32>, index) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_47 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %8 = taskflow.counter parent(%7 : index) from %c1_47 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<256x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %9 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_50 = arith.constant 1 : index
        %c64_51 = arith.constant 64 : index
        %10 = neura.counter from %c1_50 : index to %c64_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%9, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.load_indexed [%9, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %16 = "neura.icmp"(%13, %12) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %17 = "neura.sel"(%16, %13, %12) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.icmp"(%15, %17) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %19 = "neura.sel"(%18, %15, %17) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %done_writes_32 = taskflow.task @Task_19.tile.1.1 will_reads(%cast_29 : memref<?x128xi32>) will_writes(%cast_30 : memref<256x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg22 : memref<?x128xi32>), original_write_memrefs(%cast_30 : memref<256x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_19", steps = [{after = array<i64: 1, 62, 1, 64, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 64, 127>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 1, 127>, amoeba.neura.tiling.parent_task = "Task_19", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 64>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>]} : (memref<?x128xi32>, memref<256x128xi32>, index) -> (memref<256x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<256x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c127_47 = arith.constant 127 : index
      %8 = taskflow.counter parent(%7 : index) from %c64 to %c127_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<256x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<256x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %9 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c64_50 = arith.constant 64 : index
        %c127_51 = arith.constant 127 : index
        %10 = neura.counter from %c64_50 : index to %c127_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%10) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%9, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%10) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.load_indexed [%9, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %16 = "neura.icmp"(%13, %12) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %17 = "neura.sel"(%16, %13, %12) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.icmp"(%15, %17) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %19 = "neura.sel"(%18, %15, %17) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<256x128xi32>)
    }
    %4 = taskflow.join states(%done_writes_31, %done_writes_32) base(%cast_30) axis(1) region([1, 1], [62, 127]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_33 = memref.cast %4 : memref<256x128xi32> to memref<?x128xi32>
    %done_writes_34 = taskflow.task @Task_20 will_reads(%cast_33 : memref<?x128xi32>) will_writes(%arg24 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg23 : memref<?x128xi32>), original_write_memrefs(%arg24 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg30, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %6 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = "neura.add"(%9) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.load_indexed [%11, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %14 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.load_indexed [%14, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %16 = "neura.icmp"(%13, %12) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %17 = "neura.sel"(%16, %13, %12) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.icmp"(%15, %17) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %19 = "neura.sel"(%18, %15, %17) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %19 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %cast_35 = memref.cast %arg25 : memref<?x128xi32> to memref<256x128xi32>
    %done_writes_36 = taskflow.task @Task_21.replica.0 will_reads(%cast_29, %done_writes_34 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 1, 33, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 0 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 1 : i64, amoeba.replica.shard_trip_count = 1952 : i64, amoeba.replica.shard_upper = 33 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 1>], amoeba.tiling.output_region_uppers = [array<i64: 62, 33>], trip_count = 1952 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg31, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c1_47 = arith.constant 1 : index
      %c33 = arith.constant 33 : index
      %8 = taskflow.counter parent(%7 : index) from %c1_47 to %c33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %6 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %10 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c1_50 = arith.constant 1 : index
        %c33_51 = arith.constant 33 : index
        %11 = neura.counter from %c1_50 : index to %c33_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 33 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %10, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %11, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %9, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %9, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %11, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.load_indexed [%14, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %23 = "neura.icmp"(%16, %22) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %24 = "neura.sel"(%23, %16, %17) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%14, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_37 = taskflow.task @Task_21.replica.1 will_reads(%cast_29, %done_writes_34 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 33, 65, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 1 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 33 : i64, amoeba.replica.shard_trip_count = 1952 : i64, amoeba.replica.shard_upper = 65 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 33>], amoeba.tiling.output_region_uppers = [array<i64: 62, 65>], trip_count = 1952 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg31, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c33 = arith.constant 33 : index
      %c65 = arith.constant 65 : index
      %8 = taskflow.counter parent(%7 : index) from %c33 to %c65 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %6 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_47 = arith.constant 1 : index
        %c62_48 = arith.constant 62 : index
        %10 = neura.counter from %c1_47 : index to %c62_48 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c33_49 = arith.constant 33 : index
        %c65_50 = arith.constant 65 : index
        %11 = neura.counter from %c33_49 : index to %c65_50 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 33 : index, step_value = 1 : index, upper_bound_value = 65 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %10, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %11, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %9, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %9, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %11, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.load_indexed [%14, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %23 = "neura.icmp"(%16, %22) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %24 = "neura.sel"(%23, %16, %17) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%14, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_38 = taskflow.task @Task_21.replica.2 will_reads(%cast_29, %done_writes_34 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 65, 96, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 2 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 65 : i64, amoeba.replica.shard_trip_count = 1891 : i64, amoeba.replica.shard_upper = 96 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 65>], amoeba.tiling.output_region_uppers = [array<i64: 62, 96>], trip_count = 1891 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg31, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c65 = arith.constant 65 : index
      %c96 = arith.constant 96 : index
      %8 = taskflow.counter parent(%7 : index) from %c65 to %c96 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %6 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_47 = arith.constant 1 : index
        %c62_48 = arith.constant 62 : index
        %10 = neura.counter from %c1_47 : index to %c62_48 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c65_49 = arith.constant 65 : index
        %c96_50 = arith.constant 96 : index
        %11 = neura.counter from %c65_49 : index to %c96_50 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 65 : index, step_value = 1 : index, upper_bound_value = 96 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %10, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %11, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %9, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %9, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %11, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.load_indexed [%14, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %23 = "neura.icmp"(%16, %22) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %24 = "neura.sel"(%23, %16, %17) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%14, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_39 = taskflow.task @Task_21.replica.3 will_reads(%cast_29, %done_writes_34 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_21", steps = [{after = array<i64: 1, 62, 1, 96, 127, 1>, axis = 1 : i64, before = array<i64: 1, 62, 1, 1, 127, 1>, factor = 4 : i64, family = "replica", part = 3 : i64}]}], amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_21", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 96 : i64, amoeba.replica.shard_trip_count = 1891 : i64, amoeba.replica.shard_upper = 127 : i64, amoeba.replica.total_trip_count = 7686 : i64, amoeba.tiling.output_region_lowers = [array<i64: 1, 96>], amoeba.tiling.output_region_uppers = [array<i64: 62, 127>], trip_count = 1891 : i64} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg31, %c-1 : index
      %c1_46 = arith.constant 1 : index
      %c62 = arith.constant 62 : index
      %7 = taskflow.counter from %c1_46 to %c62 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c96 = arith.constant 96 : index
      %c127_47 = arith.constant 127 : index
      %8 = taskflow.counter parent(%7 : index) from %c96 to %c127_47 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %6 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %c1_48 = arith.constant 1 : index
        %c62_49 = arith.constant 62 : index
        %10 = neura.counter from %c1_48 : index to %c62_49 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 62 : index} -> !neura.data<index, i1>
        %c96_50 = arith.constant 96 : index
        %c127_51 = arith.constant 127 : index
        %11 = neura.counter from %c96_50 : index to %c127_51 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 96 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %10, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %11, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %9, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %9, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %11, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.load_indexed [%14, %15 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %23 = "neura.icmp"(%16, %22) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %24 = "neura.sel"(%23, %16, %17) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.phi"(%15, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.phi"(%14, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%26, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %cast_40 = memref.cast %done_writes_36 : memref<?x128xi32> to memref<256x128xi32>
    %cast_41 = memref.cast %done_writes_37 : memref<?x128xi32> to memref<256x128xi32>
    %cast_42 = memref.cast %done_writes_38 : memref<?x128xi32> to memref<256x128xi32>
    %cast_43 = memref.cast %done_writes_39 : memref<?x128xi32> to memref<256x128xi32>
    %5 = taskflow.join states(%cast_40, %cast_41, %cast_42, %cast_43) base(%cast_35) axis(1) region([1, 1], [62, 127]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<256x128xi32>
    %cast_44 = memref.cast %5 : memref<256x128xi32> to memref<?x128xi32>
    %done_writes_45:2 = taskflow.task @Task_22.fuse.Task_23 will_reads(%cast_44, %done_writes_15 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg26, %arg27 : memref<?x128xi32>, memref<?x128xi32>) value_inputs(%c63, %c16_i32, %c4096_i32 : index, i32, i32) [original_read_memrefs(%arg25, %arg10 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg26, %arg27 : memref<?x128xi32>, memref<?x128xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_22", steps = []}, {original = array<i64: 1, 62, 1, 1, 127, 1>, root = "Task_23", steps = []}], amoeba.neura.fusion.eliminated_loads = 0 : i64, amoeba.neura.fusion.eliminated_stores = 0 : i64, amoeba.neura.fusion.mode = "retained", amoeba.neura.joint_rewrite = "post-neura-producer-consumer-retained", amoeba.semantic.incoming_edges = ["Task_21.replica.0|producer_consumer|tensor_wide", "Task_21.replica.1|producer_consumer|tensor_wide", "Task_21.replica.2|producer_consumer|tensor_wide", "Task_21.replica.3|producer_consumer|tensor_wide", "Task_6|producer_consumer|tensor_wide"]} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>, memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32, %arg34: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.addi %arg32, %c-1 : index
      %7 = taskflow.counter from %c1 to %6 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %8 = taskflow.counter parent(%7 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg33, %arg30, %6, %arg34, %arg31 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index, i32, memref<?x128xi32>) attributes {accelerator = "neura"} {
      ^bb0(%arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>, %arg41: !neura.data<memref<?x128xi32>, i1>):
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %13 = "neura.div"(%12) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.add"(%11, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %15 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "sgt"}> {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %17 = "neura.cast"(%16) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield
      }
      taskflow.yield done_writes(%arg30, %arg31 : memref<?x128xi32>, memref<?x128xi32>)
    }
    return
  }
}

