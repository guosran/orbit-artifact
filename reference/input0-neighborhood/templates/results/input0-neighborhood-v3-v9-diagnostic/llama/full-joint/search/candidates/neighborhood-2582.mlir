module {
  func.func @_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg5: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg6: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg7: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg8: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-50", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/llama/shape-temporal-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/llama/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 320 : i64, amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.static_bound.arg.0 = 320 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c320 = arith.constant 320 : index
    %c1024_i32 = arith.constant 1024 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<512x256xi32>
    %alloca_0 = memref.alloca() : memref<512x256xi32>
    %alloca_1 = memref.alloca() : memref<512x256xi32>
    %alloca_2 = memref.alloca() : memref<512xi32>
    %alloca_3 = memref.alloca() : memref<512x512xi32>
    %alloca_4 = memref.alloca() : memref<512x512xi32>
    %alloca_5 = memref.alloca() : memref<512x256xi32>
    %alloca_6 = memref.alloca() : memref<512x256xi32>
    %alloca_7 = memref.alloca() : memref<512x256xi32>
    %done_writes = taskflow.task @Task_0.tile.1.0 will_reads(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_7 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_7 : memref<512x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, root = "Task_0", steps = [{after = array<i64: 0, 320, 1, 0, 128, 1, 0, 256, 1>, axis = 1 : i64, before = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 0, 128>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 256>, amoeba.neura.tiling.parent_task = "Task_0", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 128>]} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_23 = arith.constant 0 : index
      %c320_24 = arith.constant 320 : index
      %5 = taskflow.counter from %c0_23 to %c320_24 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_25 = arith.constant 0 : index
      %c128 = arith.constant 128 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_25 to %c128 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c256_27 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_26 to %c256_27 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c0_28 = arith.constant 0 : index
        %c320_29 = arith.constant 320 : index
        %13 = neura.counter from %c0_28 : index to %c320_29 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %c0_30 = arith.constant 0 : index
        %c128_31 = arith.constant 128 : index
        %14 = neura.counter from %c0_30 : index to %c128_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %c0_32 = arith.constant 0 : index
        %c256_33 = arith.constant 256 : index
        %15 = neura.counter from %c0_32 : index to %c256_33 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_8 = taskflow.task @Task_0.tile.1.1 will_reads(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_7 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_7 : memref<512x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, root = "Task_0", steps = [{after = array<i64: 0, 320, 1, 128, 256, 1, 0, 256, 1>, axis = 1 : i64, before = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 1 : i64, amoeba.neura.tiling.derived_range = array<i64: 128, 256>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 256>, amoeba.neura.tiling.parent_task = "Task_0", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 128>], amoeba.tiling.output_region_uppers = [array<i64: 320, 256>]} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_23 = arith.constant 0 : index
      %c320_24 = arith.constant 320 : index
      %5 = taskflow.counter from %c0_23 to %c320_24 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c128 = arith.constant 128 : index
      %c256_25 = arith.constant 256 : index
      %6 = taskflow.counter parent(%5 : index) from %c128 to %c256_25 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c256_27 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_26 to %c256_27 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c0_28 = arith.constant 0 : index
        %c320_29 = arith.constant 320 : index
        %13 = neura.counter from %c0_28 : index to %c320_29 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %c128_30 = arith.constant 128 : index
        %c256_31 = arith.constant 256 : index
        %14 = neura.counter from %c128_30 : index to %c256_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 128 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %c0_32 = arith.constant 0 : index
        %c256_33 = arith.constant 256 : index
        %15 = neura.counter from %c0_32 : index to %c256_33 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %0 = taskflow.join states(%done_writes, %done_writes_8) base(%alloca_7) axis(1) region([0, 0], [320, 256]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<512x256xi32>
    %done_writes_9 = taskflow.task @Task_1.tile.0.0 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, root = "Task_1", steps = [{after = array<i64: 0, 80, 1, 0, 256, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, factor = 4 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 0, 80>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_1", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 80, 256>]} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_23 = arith.constant 0 : index
      %c80 = arith.constant 80 : index
      %5 = taskflow.counter from %c0_23 to %c80 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_24 = arith.constant 0 : index
      %c256_25 = arith.constant 256 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_24 to %c256_25 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c256_27 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_26 to %c256_27 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c0_28 = arith.constant 0 : index
        %c80_29 = arith.constant 80 : index
        %13 = neura.counter from %c0_28 : index to %c80_29 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 80 : index} -> !neura.data<index, i1>
        %c0_30 = arith.constant 0 : index
        %c256_31 = arith.constant 256 : index
        %14 = neura.counter from %c0_30 : index to %c256_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %c0_32 = arith.constant 0 : index
        %c256_33 = arith.constant 256 : index
        %15 = neura.counter from %c0_32 : index to %c256_33 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_10 = taskflow.task @Task_1.tile.0.1 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, root = "Task_1", steps = [{after = array<i64: 80, 160, 1, 0, 256, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, factor = 4 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 80, 160>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_1", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 80, 0>], amoeba.tiling.output_region_uppers = [array<i64: 160, 256>]} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c80 = arith.constant 80 : index
      %c160 = arith.constant 160 : index
      %5 = taskflow.counter from %c80 to %c160 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_23 = arith.constant 0 : index
      %c256_24 = arith.constant 256 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_23 to %c256_24 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_25 = arith.constant 0 : index
      %c256_26 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_25 to %c256_26 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c80_27 = arith.constant 80 : index
        %c160_28 = arith.constant 160 : index
        %13 = neura.counter from %c80_27 : index to %c160_28 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 80 : index, step_value = 1 : index, upper_bound_value = 160 : index} -> !neura.data<index, i1>
        %c0_29 = arith.constant 0 : index
        %c256_30 = arith.constant 256 : index
        %14 = neura.counter from %c0_29 : index to %c256_30 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %c0_31 = arith.constant 0 : index
        %c256_32 = arith.constant 256 : index
        %15 = neura.counter from %c0_31 : index to %c256_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_11 = taskflow.task @Task_1.tile.0.2 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, root = "Task_1", steps = [{after = array<i64: 160, 240, 1, 0, 256, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, factor = 4 : i64, family = "tiling", part = 2 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 160, 240>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_1", amoeba.neura.tiling.part_index = 2 : i64, amoeba.tiling.output_region_lowers = [array<i64: 160, 0>], amoeba.tiling.output_region_uppers = [array<i64: 240, 256>]} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c160 = arith.constant 160 : index
      %c240 = arith.constant 240 : index
      %5 = taskflow.counter from %c160 to %c240 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_23 = arith.constant 0 : index
      %c256_24 = arith.constant 256 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_23 to %c256_24 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_25 = arith.constant 0 : index
      %c256_26 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_25 to %c256_26 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c160_27 = arith.constant 160 : index
        %c240_28 = arith.constant 240 : index
        %13 = neura.counter from %c160_27 : index to %c240_28 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 160 : index, step_value = 1 : index, upper_bound_value = 240 : index} -> !neura.data<index, i1>
        %c0_29 = arith.constant 0 : index
        %c256_30 = arith.constant 256 : index
        %14 = neura.counter from %c0_29 : index to %c256_30 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %c0_31 = arith.constant 0 : index
        %c256_32 = arith.constant 256 : index
        %15 = neura.counter from %c0_31 : index to %c256_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_12 = taskflow.task @Task_1.tile.0.3 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, root = "Task_1", steps = [{after = array<i64: 240, 320, 1, 0, 256, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 0, 256, 1, 0, 256, 1>, factor = 4 : i64, family = "tiling", part = 3 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 240, 320>, amoeba.neura.tiling.factor = 4 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_1", amoeba.neura.tiling.part_index = 3 : i64, amoeba.tiling.output_region_lowers = [array<i64: 240, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 256>]} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c240 = arith.constant 240 : index
      %c320_23 = arith.constant 320 : index
      %5 = taskflow.counter from %c240 to %c320_23 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_24 = arith.constant 0 : index
      %c256_25 = arith.constant 256 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_24 to %c256_25 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c256_27 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_26 to %c256_27 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c240_28 = arith.constant 240 : index
        %c320_29 = arith.constant 320 : index
        %13 = neura.counter from %c240_28 : index to %c320_29 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 240 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %c0_30 = arith.constant 0 : index
        %c256_31 = arith.constant 256 : index
        %14 = neura.counter from %c0_30 : index to %c256_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %c0_32 = arith.constant 0 : index
        %c256_33 = arith.constant 256 : index
        %15 = neura.counter from %c0_32 : index to %c256_33 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %1 = taskflow.join states(%done_writes_9, %done_writes_10, %done_writes_11, %done_writes_12) base(%alloca_6) axis(0) region([0, 0], [320, 256]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<512x256xi32>
    %done_writes_13 = taskflow.task @Task_2 will_reads(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_5 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_5 : memref<512x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %7 = taskflow.counter parent(%6 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %13 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %14 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %15 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%29, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_14 = taskflow.task @Task_3.tile.1.0.tile.0.0 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, root = "Task_3", steps = [{after = array<i64: 0, 320, 1, 0, 160, 1, 0, 256, 1>, axis = 1 : i64, before = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}, {after = array<i64: 0, 160, 1, 0, 160, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 0, 160, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 0, 160>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_3.tile.1.0", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 160, 160>]} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_23 = arith.constant 0 : index
      %c320_24 = arith.constant 320 : index
      %c0_25 = arith.constant 0 : index
      %c160 = arith.constant 160 : index
      %5 = taskflow.counter from %c0_25 to %c160 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c160_27 = arith.constant 160 : index
      %c0_28 = arith.constant 0 : index
      %c160_29 = arith.constant 160 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_28 to %c160_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_30 = arith.constant 0 : index
      %c256_31 = arith.constant 256 : index
      %c0_32 = arith.constant 0 : index
      %c256_33 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_32 to %c256_33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c0_34 = arith.constant 0 : index
        %c320_35 = arith.constant 320 : index
        %c0_36 = arith.constant 0 : index
        %c160_37 = arith.constant 160 : index
        %13 = neura.counter from %c0_36 : index to %c160_37 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 160 : index} -> !neura.data<index, i1>
        %c0_38 = arith.constant 0 : index
        %c160_39 = arith.constant 160 : index
        %c0_40 = arith.constant 0 : index
        %c160_41 = arith.constant 160 : index
        %14 = neura.counter from %c0_40 : index to %c160_41 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 160 : index} -> !neura.data<index, i1>
        %c0_42 = arith.constant 0 : index
        %c256_43 = arith.constant 256 : index
        %c0_44 = arith.constant 0 : index
        %c256_45 = arith.constant 256 : index
        %15 = neura.counter from %c0_44 : index to %c256_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_15 = taskflow.task @Task_3.tile.1.0.tile.0.1 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, root = "Task_3", steps = [{after = array<i64: 0, 320, 1, 0, 160, 1, 0, 256, 1>, axis = 1 : i64, before = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}, {after = array<i64: 160, 320, 1, 0, 160, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 0, 160, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 160, 320>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_3.tile.1.0", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 160, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 160>]} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_23 = arith.constant 0 : index
      %c320_24 = arith.constant 320 : index
      %c160 = arith.constant 160 : index
      %c320_25 = arith.constant 320 : index
      %5 = taskflow.counter from %c160 to %c320_25 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_26 = arith.constant 0 : index
      %c160_27 = arith.constant 160 : index
      %c0_28 = arith.constant 0 : index
      %c160_29 = arith.constant 160 : index
      %6 = taskflow.counter parent(%5 : index) from %c0_28 to %c160_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_30 = arith.constant 0 : index
      %c256_31 = arith.constant 256 : index
      %c0_32 = arith.constant 0 : index
      %c256_33 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_32 to %c256_33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c0_34 = arith.constant 0 : index
        %c320_35 = arith.constant 320 : index
        %c160_36 = arith.constant 160 : index
        %c320_37 = arith.constant 320 : index
        %13 = neura.counter from %c160_36 : index to %c320_37 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 160 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %c0_38 = arith.constant 0 : index
        %c160_39 = arith.constant 160 : index
        %c0_40 = arith.constant 0 : index
        %c160_41 = arith.constant 160 : index
        %14 = neura.counter from %c0_40 : index to %c160_41 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 160 : index} -> !neura.data<index, i1>
        %c0_42 = arith.constant 0 : index
        %c256_43 = arith.constant 256 : index
        %c0_44 = arith.constant 0 : index
        %c256_45 = arith.constant 256 : index
        %15 = neura.counter from %c0_44 : index to %c256_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %2 = taskflow.join states(%done_writes_14, %done_writes_15) base(%alloca_4) axis(0) region([0, 0], [320, 160]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<512x512xi32>
    %done_writes_16 = taskflow.task @Task_3.tile.1.1.tile.0.0 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, root = "Task_3", steps = [{after = array<i64: 0, 320, 1, 160, 320, 1, 0, 256, 1>, axis = 1 : i64, before = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}, {after = array<i64: 0, 160, 1, 160, 320, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 160, 320, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 0 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 0, 160>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_3.tile.1.1", amoeba.neura.tiling.part_index = 0 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 160>], amoeba.tiling.output_region_uppers = [array<i64: 160, 320>]} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_23 = arith.constant 0 : index
      %c320_24 = arith.constant 320 : index
      %c0_25 = arith.constant 0 : index
      %c160 = arith.constant 160 : index
      %5 = taskflow.counter from %c0_25 to %c160 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c160_26 = arith.constant 160 : index
      %c320_27 = arith.constant 320 : index
      %c160_28 = arith.constant 160 : index
      %c320_29 = arith.constant 320 : index
      %6 = taskflow.counter parent(%5 : index) from %c160_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_30 = arith.constant 0 : index
      %c256_31 = arith.constant 256 : index
      %c0_32 = arith.constant 0 : index
      %c256_33 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_32 to %c256_33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c0_34 = arith.constant 0 : index
        %c320_35 = arith.constant 320 : index
        %c0_36 = arith.constant 0 : index
        %c160_37 = arith.constant 160 : index
        %13 = neura.counter from %c0_36 : index to %c160_37 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 160 : index} -> !neura.data<index, i1>
        %c160_38 = arith.constant 160 : index
        %c320_39 = arith.constant 320 : index
        %c160_40 = arith.constant 160 : index
        %c320_41 = arith.constant 320 : index
        %14 = neura.counter from %c160_40 : index to %c320_41 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 160 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %c0_42 = arith.constant 0 : index
        %c256_43 = arith.constant 256 : index
        %c0_44 = arith.constant 0 : index
        %c256_45 = arith.constant 256 : index
        %15 = neura.counter from %c0_44 : index to %c256_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_17 = taskflow.task @Task_3.tile.1.1.tile.0.1 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.neighborhood.partition_lineage.v1 = [{original = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, root = "Task_3", steps = [{after = array<i64: 0, 320, 1, 160, 320, 1, 0, 256, 1>, axis = 1 : i64, before = array<i64: 0, 320, 1, 0, 320, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}, {after = array<i64: 160, 320, 1, 160, 320, 1, 0, 256, 1>, axis = 0 : i64, before = array<i64: 0, 320, 1, 160, 320, 1, 0, 256, 1>, factor = 2 : i64, family = "tiling", part = 1 : i64}]}], amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.neura.tiling.axis = 0 : i64, amoeba.neura.tiling.derived_range = array<i64: 160, 320>, amoeba.neura.tiling.factor = 2 : i64, amoeba.neura.tiling.original_range = array<i64: 0, 320>, amoeba.neura.tiling.parent_task = "Task_3.tile.1.1", amoeba.neura.tiling.part_index = 1 : i64, amoeba.tiling.output_region_lowers = [array<i64: 160, 160>], amoeba.tiling.output_region_uppers = [array<i64: 320, 320>]} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_23 = arith.constant 0 : index
      %c320_24 = arith.constant 320 : index
      %c160 = arith.constant 160 : index
      %c320_25 = arith.constant 320 : index
      %5 = taskflow.counter from %c160 to %c320_25 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c160_26 = arith.constant 160 : index
      %c320_27 = arith.constant 320 : index
      %c160_28 = arith.constant 160 : index
      %c320_29 = arith.constant 320 : index
      %6 = taskflow.counter parent(%5 : index) from %c160_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %c0_30 = arith.constant 0 : index
      %c256_31 = arith.constant 256 : index
      %c0_32 = arith.constant 0 : index
      %c256_33 = arith.constant 256 : index
      %7 = taskflow.counter parent(%6 : index) from %c0_32 to %c256_33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %c0_34 = arith.constant 0 : index
        %c320_35 = arith.constant 320 : index
        %c160_36 = arith.constant 160 : index
        %c320_37 = arith.constant 320 : index
        %13 = neura.counter from %c160_36 : index to %c320_37 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 160 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %c160_38 = arith.constant 160 : index
        %c320_39 = arith.constant 320 : index
        %c160_40 = arith.constant 160 : index
        %c320_41 = arith.constant 320 : index
        %14 = neura.counter from %c160_40 : index to %c320_41 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 160 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %c0_42 = arith.constant 0 : index
        %c256_43 = arith.constant 256 : index
        %c0_44 = arith.constant 0 : index
        %c256_45 = arith.constant 256 : index
        %15 = neura.counter from %c0_44 : index to %c256_45 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %18 = neura.grant_predicate %13, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %14, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %13, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %15, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %12, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %17 to %17[%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %27 = "neura.phi"(%26, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.phi"(%25, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.phi"(%24, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.phi"(%23, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = neura.load_indexed [%30, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %32 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %33 = "neura.mul"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.add"(%27, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %34 to [%30, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %34 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        %35 = neura.extract_predicate %13 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %36 = "neura.not"(%35) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %12, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %37 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %3 = taskflow.join states(%done_writes_16, %done_writes_17) base(%alloca_4) axis(0) region([0, 160], [320, 320]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<512x512xi32>
    %4 = taskflow.join states(%2, %3) base(%alloca_4) axis(1) region([0, 0], [320, 320]) {amoeba.neura.joint_rewrite = "post-neura-mn-tiling", amoeba.semantic.completion_only} : memref<512x512xi32>
    %done_writes_18:2 = taskflow.task @Task_4 will_reads(%4 : memref<512x512xi32>) will_writes(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>) value_inputs(%c320, %c0_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%alloca_4 : memref<512x512xi32>), original_write_memrefs(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>)] : (memref<512x512xi32>, memref<512xi32>, memref<512x512xi32>, index, i32, i32) -> (memref<512xi32>, memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x512xi32>, %arg10: memref<512xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %7 = neura.kernel inputs(%arg13, %arg10, %arg9, %arg14, %arg11, %arg12 : i32, memref<512xi32>, memref<512x512xi32>, i32, memref<512x512xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<i32, i1>, %arg16: !neura.data<memref<512xi32>, i1>, %arg17: !neura.data<memref<512x512xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<memref<512x512xi32>, i1>, %arg20: !neura.data<index, i1>, %arg21: !neura.data<i32, i1>):
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512xi32>, i1>
        %9 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %10 = neura.reserve : !neura.data<i32, i1>
        %11 = neura.phi_start %9, %10 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %12 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %8, %14 : !neura.data<memref<512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512xi32>, i1>
        %16 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %11, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %12, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %13, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %11, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16 : !neura.data<index, i1>] !neura.data<memref<512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512xi32>, i1>
        %23 = "neura.phi"(%22, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.phi"(%21, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%20, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%25, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %27 = "neura.mul"(%26, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%27) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%25, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %29 = "neura.add"(%23, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %29 to [%25 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %29 -> %10 : !neura.data<i32, i1> !neura.data<i32, i1>
        %30 = neura.extract_predicate %12 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %31 = "neura.not"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %11, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %32 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg10, %arg11 : memref<512xi32>, memref<512x512xi32>)
    }
    %done_writes_19 = taskflow.task @Task_5 will_reads(%done_writes_18#0, %done_writes_18#1 : memref<512xi32>, memref<512x512xi32>) will_writes(%done_writes_18#1 : memref<512x512xi32>) value_inputs(%c320, %c1_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>), original_write_memrefs(%alloca_3 : memref<512x512xi32>)] : (memref<512xi32>, memref<512x512xi32>, memref<512x512xi32>, index, i32, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512xi32>, %arg10: memref<512x512xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg9, %arg13, %arg11, %arg14, %arg12 : memref<512xi32>, i32, memref<512x512xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<512xi32>, i1>, %arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x512xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<index, i1>):
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%7 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.add"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = neura.load_indexed [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.div"(%12, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%7, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_20 = taskflow.task @Task_6 will_reads(%done_writes_19, %done_writes_13, %alloca_1 : memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_1 : memref<512x256xi32>) value_inputs(%c320, %c0_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%alloca_3, %alloca_5, %alloca_1 : memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_1 : memref<512x256xi32>)] : (memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<512x512xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x256xi32>, %arg12: memref<512x256xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0 to %arg13 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg12, %arg9, %arg10, %arg13, %arg15, %arg13 : i32, memref<512x256xi32>, memref<512x512xi32>, memref<512x256xi32>, index, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<memref<512x512xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<index, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<index, i1>):
        %7 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %9 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %10 = "neura.cast"(%9) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        neura.store_indexed %8 to %8[%11, %12 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {amoeba.source_owned_once_init, lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %13 = neura.reserve : !neura.data<index, i1>
        %14 = "neura.phi"(%13, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.reserve : !neura.data<index, i1>
        %16 = "neura.phi"(%15, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = neura.reserve : !neura.data<i32, i1>
        %18 = "neura.phi"(%17, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = neura.reserve : !neura.data<i64, i1>
        %20 = "neura.phi"(%19, %10) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %21 = "neura.cast"(%20) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %22 = "neura.icmp"(%21) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %16, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %21, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %18, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = "neura.not"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %16, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = neura.grant_predicate %14, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %30 = neura.load_indexed [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %31 = neura.load_indexed [%24, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %32 = "neura.mul"(%30, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.add"(%26, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %33 to [%23, %25 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %34 = "neura.add"(%24) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %35 = "neura.cast"(%34) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %35 -> %19 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %33 -> %17 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %23 -> %15 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %25 -> %13 : !neura.data<index, i1> !neura.data<index, i1>
        %36 = neura.load_indexed [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %37 = "neura.div"(%36) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %37 to [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<512x256xi32>)
    }
    %done_writes_21:2 = taskflow.task @Task_7 will_reads(%done_writes_20, %arg5, %arg6 : memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_0, %alloca : memref<512x256xi32>, memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_1, %arg5, %arg6 : memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_0, %alloca : memref<512x256xi32>, memref<512x256xi32>)] : (memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>, memref<512x256xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<512x256xi32>, %arg13: memref<512x256xi32>, %arg14: index, %arg15: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0 to %arg14 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %7 = taskflow.counter parent(%6 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %8:2 = neura.kernel inputs(%arg15, %arg12, %arg13, %arg9, %arg10, %arg11, %arg14 : i32, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg15, %arg15 : i32, i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<memref<512x256xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<index, i1>, %arg23: !neura.data<i32, i1>, %arg24: !neura.data<i32, i1>):
        %9 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %11 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %12 = neura.reserve : !neura.data<i32, i1>
        %13 = neura.phi_start %11, %12 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %14 = "neura.grant_once"() <{constant_value = "%iter_arg_init1"}> : () -> !neura.data<i32, i1>
        %15 = neura.reserve : !neura.data<i32, i1>
        %16 = neura.phi_start %14, %15 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %17 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %18 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %19 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %20 = "neura.icmp"(%19) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %9, %20 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %22 = neura.grant_predicate %17, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %18, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %25 = neura.grant_predicate %19, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %16, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %13, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = "neura.not"(%20) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %29 = neura.grant_predicate %17, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %30 = neura.grant_predicate %19, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = neura.grant_predicate %18, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %32 = neura.grant_predicate %16, %28 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %13, %28 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %21 to %21[%22, %23 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        neura.store_indexed %24 to %24[%22, %23 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %34 = "neura.phi"(%33, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.phi"(%32, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.phi"(%31, %23) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %37 = "neura.phi"(%30, %25) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.phi"(%29, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %39 = neura.load_indexed [%38, %37 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %40 = neura.load_indexed [%37, %36 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %41 = "neura.mul"(%39, %40) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %42 = "neura.add"(%35, %41) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %42 to [%38, %36 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %43 = neura.load_indexed [%37, %36 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %44 = "neura.mul"(%39, %43) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %45 = "neura.add"(%34, %44) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %45 to [%38, %36 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.ctrl_mov %45 -> %12 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %42 -> %15 : !neura.data<i32, i1> !neura.data<i32, i1>
        %46 = neura.extract_predicate %17 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %47 = "neura.not"(%46) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %48 = neura.grant_predicate %13, %47 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %49 = neura.grant_predicate %16, %47 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %48, %49 : !neura.data<i32, i1>, !neura.data<i32, i1>
        neura.yield
      } : i32, i32
      taskflow.yield done_writes(%arg12, %arg13 : memref<512x256xi32>, memref<512x256xi32>)
    }
    %done_writes_22 = taskflow.task @Task_8 will_reads(%done_writes_21#0, %done_writes_21#1, %arg7, %arg8 : memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg8 : memref<?x256xi32>) value_inputs(%c320, %c0_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%alloca_0, %alloca, %arg7, %arg8 : memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?x256xi32>)] : (memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<?x256xi32>, %arg13: memref<?x256xi32>, %arg14: index, %arg15: i32, %arg16: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %5 = taskflow.counter from %c0 to %arg14 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %7 = taskflow.counter parent(%6 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg15, %arg13, %arg9, %arg16, %arg10, %arg11, %arg14 : i32, memref<?x256xi32>, memref<512x256xi32>, i32, memref<512x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x256xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<512x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256xi32>, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %12 = "neura.icmp"(%11) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %8, %12 : !neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256xi32>, i1>
        %14 = neura.grant_predicate %9, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %10, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %11, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = "neura.not"(%12) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %9, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %11, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %10, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %13 to %13[%14, %15 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256xi32>, i1>
        %21 = "neura.phi"(%20, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%19, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%18, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = neura.load_indexed [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %25 = "neura.add"(%24) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.mul"(%24, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = neura.load_indexed [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %28 = "neura.mul"(%26, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = neura.load_indexed [%22, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %30 = "neura.mul"(%28, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = neura.load_indexed [%23, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %32 = "neura.add"(%31, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%23, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?x256xi32>)
    }
    return
  }
}

