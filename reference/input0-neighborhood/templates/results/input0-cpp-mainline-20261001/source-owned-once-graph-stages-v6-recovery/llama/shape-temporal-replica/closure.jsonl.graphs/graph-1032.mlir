module {
  func.func @_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg5: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg6: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg7: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg8: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-1032", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/llama/shape-temporal-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/llama/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 320 : i64, amoeba.replica.count = 4 : i64, amoeba.replica.materialized_task = "Task_3", amoeba.replica.parent_task = "Task_3", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_trip_count = 6553600 : i64, amoeba.replica.total_trip_count = 26214400 : i64, amoeba.static_bound.arg.0 = 320 : i64, llvm.linkage = #llvm.linkage<external>} {
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
    %done_writes = taskflow.task @Task_0.replica.0 will_reads(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_7 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_7 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_upper = 64 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 64>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_30 = arith.constant 0 : index
      %c64 = arith.constant 64 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_30 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c0_31 = arith.constant 0 : index
        %c64_32 = arith.constant 64 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c0_31 : index to %c64_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_8 = taskflow.task @Task_0.replica.1 will_reads(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_7 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_7 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 64 : i64, amoeba.replica.shard_upper = 128 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 64>], amoeba.tiling.output_region_uppers = [array<i64: 320, 128>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c128 = arith.constant 128 : index
      %5 = taskflow.counter parent(%4 : index) from %c64 to %c128 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c64_30 = arith.constant 64 : index
        %c128_31 = arith.constant 128 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c64_30 : index to %c128_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_9 = taskflow.task @Task_0.replica.2 will_reads(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_7 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_7 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 128 : i64, amoeba.replica.shard_upper = 192 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 128>], amoeba.tiling.output_region_uppers = [array<i64: 320, 192>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c128 = arith.constant 128 : index
      %c192 = arith.constant 192 : index
      %5 = taskflow.counter parent(%4 : index) from %c128 to %c192 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c128_30 = arith.constant 128 : index
        %c192_31 = arith.constant 192 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c128_30 : index to %c192_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 128 : index, step_value = 1 : index, upper_bound_value = 192 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_10 = taskflow.task @Task_0.replica.3 will_reads(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_7 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_7 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_0", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 192 : i64, amoeba.replica.shard_upper = 256 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 192>], amoeba.tiling.output_region_uppers = [array<i64: 320, 256>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c192 = arith.constant 192 : index
      %c256_30 = arith.constant 256 : index
      %5 = taskflow.counter parent(%4 : index) from %c192 to %c256_30 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c192_31 = arith.constant 192 : index
        %c256_32 = arith.constant 256 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c192_31 : index to %c256_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 192 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %0 = taskflow.join states(%done_writes, %done_writes_8, %done_writes_9, %done_writes_10) base(%alloca_7) axis(1) region([0, 0], [320, 256]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<512x256xi32>
    %done_writes_11 = taskflow.task @Task_1.replica.0 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_upper = 64 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 64>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_30 = arith.constant 0 : index
      %c64 = arith.constant 64 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_30 to %c64 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c0_31 = arith.constant 0 : index
        %c64_32 = arith.constant 64 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c0_31 : index to %c64_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 64 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_12 = taskflow.task @Task_1.replica.1 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 64 : i64, amoeba.replica.shard_upper = 128 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 64>], amoeba.tiling.output_region_uppers = [array<i64: 320, 128>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c64 = arith.constant 64 : index
      %c128 = arith.constant 128 : index
      %5 = taskflow.counter parent(%4 : index) from %c64 to %c128 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c64_30 = arith.constant 64 : index
        %c128_31 = arith.constant 128 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c64_30 : index to %c128_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 64 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_13 = taskflow.task @Task_1.replica.2 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 128 : i64, amoeba.replica.shard_upper = 192 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 128>], amoeba.tiling.output_region_uppers = [array<i64: 320, 192>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c128 = arith.constant 128 : index
      %c192 = arith.constant 192 : index
      %5 = taskflow.counter parent(%4 : index) from %c128 to %c192 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c128_30 = arith.constant 128 : index
        %c192_31 = arith.constant 192 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c128_30 : index to %c192_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 128 : index, step_value = 1 : index, upper_bound_value = 192 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_14 = taskflow.task @Task_1.replica.3 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 192 : i64, amoeba.replica.shard_upper = 256 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 192>], amoeba.tiling.output_region_uppers = [array<i64: 320, 256>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c192 = arith.constant 192 : index
      %c256_30 = arith.constant 256 : index
      %5 = taskflow.counter parent(%4 : index) from %c192 to %c256_30 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c192_31 = arith.constant 192 : index
        %c256_32 = arith.constant 256 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c192_31 : index to %c256_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 192 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %1 = taskflow.join states(%done_writes_11, %done_writes_12, %done_writes_13, %done_writes_14) base(%alloca_6) axis(1) region([0, 0], [320, 256]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<512x256xi32>
    %done_writes_15 = taskflow.task @Task_2.replica.0 will_reads(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_5 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_5 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_upper = 80 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 80, 256>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c80 = arith.constant 80 : index
      %4 = taskflow.counter from %c0_28 to %c80 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_29 = arith.constant 0 : index
      %c256_30 = arith.constant 256 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_29 to %c256_30 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c0_31 = arith.constant 0 : index
        %c80_32 = arith.constant 80 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter from %c0_31 : index to %c80_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 80 : index} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_16 = taskflow.task @Task_2.replica.1 will_reads(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_5 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_5 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 80 : i64, amoeba.replica.shard_upper = 160 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 80, 0>], amoeba.tiling.output_region_uppers = [array<i64: 160, 256>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c80 = arith.constant 80 : index
      %c160 = arith.constant 160 : index
      %4 = taskflow.counter from %c80 to %c160 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_28 = arith.constant 0 : index
      %c256_29 = arith.constant 256 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_28 to %c256_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c80_30 = arith.constant 80 : index
        %c160_31 = arith.constant 160 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter from %c80_30 : index to %c160_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 80 : index, step_value = 1 : index, upper_bound_value = 160 : index} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_17 = taskflow.task @Task_2.replica.2 will_reads(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_5 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_5 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 160 : i64, amoeba.replica.shard_upper = 240 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 160, 0>], amoeba.tiling.output_region_uppers = [array<i64: 240, 256>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c160 = arith.constant 160 : index
      %c240 = arith.constant 240 : index
      %4 = taskflow.counter from %c160 to %c240 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_28 = arith.constant 0 : index
      %c256_29 = arith.constant 256 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_28 to %c256_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c160_30 = arith.constant 160 : index
        %c240_31 = arith.constant 240 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter from %c160_30 : index to %c240_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 160 : index, step_value = 1 : index, upper_bound_value = 240 : index} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_18 = taskflow.task @Task_2.replica.3 will_reads(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_5 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_5 : memref<512x256xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_2", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 240 : i64, amoeba.replica.shard_upper = 320 : i64, amoeba.selected_trip_count = 5242880 : i64, amoeba.tiling.output_region_lowers = [array<i64: 240, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 256>], trip_count = 5242880 : i64} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c240 = arith.constant 240 : index
      %c320_28 = arith.constant 320 : index
      %4 = taskflow.counter from %c240 to %c320_28 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_29 = arith.constant 0 : index
      %c256_30 = arith.constant 256 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_29 to %c256_30 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c240_31 = arith.constant 240 : index
        %c320_32 = arith.constant 320 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter from %c240_31 : index to %c320_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 240 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%27, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %2 = taskflow.join states(%done_writes_15, %done_writes_16, %done_writes_17, %done_writes_18) base(%alloca_5) axis(0) region([0, 0], [320, 256]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<512x256xi32>
    %done_writes_19 = taskflow.task @Task_3.replica.0 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_3", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_upper = 80 : i64, amoeba.selected_trip_count = 6553600 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 80>], trip_count = 6553600 : i64} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c0_30 = arith.constant 0 : index
      %c80 = arith.constant 80 : index
      %5 = taskflow.counter parent(%4 : index) from %c0_30 to %c80 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c0_31 = arith.constant 0 : index
        %c80_32 = arith.constant 80 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c0_31 : index to %c80_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 80 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%26, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_20 = taskflow.task @Task_3.replica.1 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_3", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 80 : i64, amoeba.replica.shard_upper = 160 : i64, amoeba.selected_trip_count = 6553600 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 80>], amoeba.tiling.output_region_uppers = [array<i64: 320, 160>], trip_count = 6553600 : i64} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c80 = arith.constant 80 : index
      %c160 = arith.constant 160 : index
      %5 = taskflow.counter parent(%4 : index) from %c80 to %c160 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c80_30 = arith.constant 80 : index
        %c160_31 = arith.constant 160 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c80_30 : index to %c160_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 80 : index, step_value = 1 : index, upper_bound_value = 160 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%26, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_21 = taskflow.task @Task_3.replica.2 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 2 : i64, amoeba.replica.parent_task = "Task_3", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 160 : i64, amoeba.replica.shard_upper = 240 : i64, amoeba.selected_trip_count = 6553600 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 160>], amoeba.tiling.output_region_uppers = [array<i64: 320, 240>], trip_count = 6553600 : i64} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c160 = arith.constant 160 : index
      %c240 = arith.constant 240 : index
      %5 = taskflow.counter parent(%4 : index) from %c160 to %c240 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c160_30 = arith.constant 160 : index
        %c240_31 = arith.constant 240 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c160_30 : index to %c240_31 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 160 : index, step_value = 1 : index, upper_bound_value = 240 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%26, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_22 = taskflow.task @Task_3.replica.3 will_reads(%0, %1 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] {amoeba.replica.count = 4 : i64, amoeba.replica.id = 3 : i64, amoeba.replica.parent_task = "Task_3", amoeba.replica.shard_axis = 1 : i64, amoeba.replica.shard_lower = 240 : i64, amoeba.replica.shard_upper = 320 : i64, amoeba.selected_trip_count = 6553600 : i64, amoeba.tiling.output_region_lowers = [array<i64: 0, 240>], amoeba.tiling.output_region_uppers = [array<i64: 320, 320>], trip_count = 6553600 : i64} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c0_28 = arith.constant 0 : index
      %c320_29 = arith.constant 320 : index
      %4 = taskflow.counter from %c0_28 to %c320_29 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %c240 = arith.constant 240 : index
      %c320_30 = arith.constant 320 : index
      %5 = taskflow.counter parent(%4 : index) from %c240 to %c320_30 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %c240_31 = arith.constant 240 : index
        %c320_32 = arith.constant 320 : index
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %12 = neura.counter from %c240_31 : index to %c320_32 : index attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 240 : index, step_value = 1 : index, upper_bound_value = 320 : index} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = "neura.icmp"(%13) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %16 = neura.grant_predicate %11, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %12, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %20 = "neura.not"(%14) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %11, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %13, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %12, %20 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %10, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %15 to %15[%16, %17 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %25 = "neura.phi"(%24, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%23, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.phi"(%22, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.phi"(%21, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = neura.load_indexed [%28, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%26, %27 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%28, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %32 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %33 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %34 = "neura.not"(%33) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %35 = neura.grant_predicate %10, %34 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %35 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %3 = taskflow.join states(%done_writes_19, %done_writes_20, %done_writes_21, %done_writes_22) base(%alloca_4) axis(1) region([0, 0], [320, 320]) {amoeba.replica.completion_only, amoeba.semantic.completion_only} : memref<512x512xi32>
    %done_writes_23:2 = taskflow.task @Task_4 will_reads(%3 : memref<512x512xi32>) will_writes(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>) value_inputs(%c320, %c0_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%alloca_4 : memref<512x512xi32>), original_write_memrefs(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>)] {amoeba.semantic.incoming_edges = ["Task_3.replica.0|producer_consumer|tensor_wide", "Task_3.replica.1|producer_consumer|tensor_wide", "Task_3.replica.2|producer_consumer|tensor_wide", "Task_3.replica.3|producer_consumer|tensor_wide"]} : (memref<512x512xi32>, memref<512xi32>, memref<512x512xi32>, index, i32, i32) -> (memref<512xi32>, memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x512xi32>, %arg10: memref<512xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %6 = neura.kernel inputs(%arg13, %arg10, %arg9, %arg14, %arg11, %arg12 : i32, memref<512xi32>, memref<512x512xi32>, i32, memref<512x512xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<i32, i1>, %arg16: !neura.data<memref<512xi32>, i1>, %arg17: !neura.data<memref<512x512xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<memref<512x512xi32>, i1>, %arg20: !neura.data<index, i1>, %arg21: !neura.data<i32, i1>):
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512xi32>, i1>
        %8 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i32, i1>
        %10 = neura.phi_start %8, %9 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %11 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %12 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %7, %13 : !neura.data<memref<512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512xi32>, i1>
        %15 = neura.grant_predicate %11, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %12, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %10, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %11, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %12, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %10, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %14 to %14[%15 : !neura.data<index, i1>] !neura.data<memref<512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512xi32>, i1>
        %22 = "neura.phi"(%21, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.phi"(%20, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = neura.load_indexed [%24, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %26 = "neura.mul"(%25, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.add"(%26) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%24, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %28 = "neura.add"(%22, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%24 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %28 -> %9 : !neura.data<i32, i1> !neura.data<i32, i1>
        %29 = neura.extract_predicate %11 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %30 = "neura.not"(%29) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %31 = neura.grant_predicate %10, %30 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %31 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg10, %arg11 : memref<512xi32>, memref<512x512xi32>)
    }
    %done_writes_24 = taskflow.task @Task_5 will_reads(%done_writes_23#0, %done_writes_23#1 : memref<512xi32>, memref<512x512xi32>) will_writes(%done_writes_23#1 : memref<512x512xi32>) value_inputs(%c320, %c1_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>), original_write_memrefs(%alloca_3 : memref<512x512xi32>)] : (memref<512xi32>, memref<512x512xi32>, memref<512x512xi32>, index, i32, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512xi32>, %arg10: memref<512x512xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg9, %arg13, %arg11, %arg14, %arg12 : memref<512xi32>, i32, memref<512x512xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<512xi32>, i1>, %arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x512xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<index, i1>):
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.add"(%8) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %11 = "neura.mul"(%10) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.div"(%11, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %12 to [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_25 = taskflow.task @Task_6 will_reads(%done_writes_24, %2, %alloca_1 : memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_1 : memref<512x256xi32>) value_inputs(%c320, %c0_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%alloca_3, %alloca_5, %alloca_1 : memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_1 : memref<512x256xi32>)] {amoeba.semantic.incoming_edges = ["Task_2.replica.0|producer_consumer|tensor_wide", "Task_2.replica.1|producer_consumer|tensor_wide", "Task_2.replica.2|producer_consumer|tensor_wide", "Task_2.replica.3|producer_consumer|tensor_wide", "Task_5|producer_consumer|tensor_wide"]} : (memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<512x512xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x256xi32>, %arg12: memref<512x256xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg13 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg12, %arg9, %arg10, %arg13, %arg15, %arg13 : i32, memref<512x256xi32>, memref<512x512xi32>, memref<512x256xi32>, index, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<memref<512x512xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<index, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<index, i1>):
        %6 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %8 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %9 = "neura.cast"(%8) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %10 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %11 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        neura.store_indexed %7 to %7[%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {amoeba.source_owned_once_init, lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %12 = neura.reserve : !neura.data<index, i1>
        %13 = "neura.phi"(%12, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.reserve : !neura.data<index, i1>
        %15 = "neura.phi"(%14, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.reserve : !neura.data<i32, i1>
        %17 = "neura.phi"(%16, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.reserve : !neura.data<i64, i1>
        %19 = "neura.phi"(%18, %9) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %20 = "neura.cast"(%19) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %21 = "neura.icmp"(%20) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %15, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %20, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %13, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %17, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = "neura.not"(%21) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %27 = neura.grant_predicate %15, %26 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = neura.grant_predicate %13, %26 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = neura.load_indexed [%22, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%25, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%22, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %33 = "neura.add"(%23) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = "neura.cast"(%33) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %34 -> %18 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %32 -> %16 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %22 -> %14 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %24 -> %12 : !neura.data<index, i1> !neura.data<index, i1>
        %35 = neura.load_indexed [%27, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %36 = "neura.div"(%35) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %36 to [%27, %28 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<512x256xi32>)
    }
    %done_writes_26:2 = taskflow.task @Task_7 will_reads(%done_writes_25, %arg5, %arg6 : memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_0, %alloca : memref<512x256xi32>, memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_1, %arg5, %arg6 : memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_0, %alloca : memref<512x256xi32>, memref<512x256xi32>)] : (memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>, memref<512x256xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<512x256xi32>, %arg13: memref<512x256xi32>, %arg14: index, %arg15: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg14 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %7:2 = neura.kernel inputs(%arg15, %arg12, %arg13, %arg9, %arg10, %arg11, %arg14 : i32, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg15, %arg15 : i32, i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<memref<512x256xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<index, i1>, %arg23: !neura.data<i32, i1>, %arg24: !neura.data<i32, i1>):
        %8 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %9 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %10 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = neura.phi_start %10, %11 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %13 = "neura.grant_once"() <{constant_value = "%iter_arg_init1"}> : () -> !neura.data<i32, i1>
        %14 = neura.reserve : !neura.data<i32, i1>
        %15 = neura.phi_start %13, %14 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %16 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %17 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %18 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %19 = "neura.icmp"(%18) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %8, %19 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %21 = neura.grant_predicate %16, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %17, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = neura.grant_predicate %9, %19 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %24 = neura.grant_predicate %18, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %15, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = neura.grant_predicate %12, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = "neura.not"(%19) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %16, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = neura.grant_predicate %18, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %30 = neura.grant_predicate %17, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = neura.grant_predicate %15, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %12, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %20 to %20[%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        neura.store_indexed %23 to %23[%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %33 = "neura.phi"(%32, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.phi"(%31, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.phi"(%30, %22) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.phi"(%29, %24) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %37 = "neura.phi"(%28, %21) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = neura.load_indexed [%37, %36 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %39 = neura.load_indexed [%36, %35 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %40 = "neura.mul"(%38, %39) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %41 = "neura.add"(%34, %40) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %41 to [%37, %35 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %42 = neura.load_indexed [%36, %35 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %43 = "neura.mul"(%38, %42) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.add"(%33, %43) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %44 to [%37, %35 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.ctrl_mov %44 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %41 -> %14 : !neura.data<i32, i1> !neura.data<i32, i1>
        %45 = neura.extract_predicate %16 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %46 = "neura.not"(%45) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = neura.grant_predicate %12, %46 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %48 = neura.grant_predicate %15, %46 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %47, %48 : !neura.data<i32, i1>, !neura.data<i32, i1>
        neura.yield
      } : i32, i32
      taskflow.yield done_writes(%arg12, %arg13 : memref<512x256xi32>, memref<512x256xi32>)
    }
    %done_writes_27 = taskflow.task @Task_8 will_reads(%done_writes_26#0, %done_writes_26#1, %arg7, %arg8 : memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg8 : memref<?x256xi32>) value_inputs(%c320, %c0_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%alloca_0, %alloca, %arg7, %arg8 : memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?x256xi32>)] : (memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<?x256xi32>, %arg13: memref<?x256xi32>, %arg14: index, %arg15: i32, %arg16: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %4 = taskflow.counter from %c0 to %arg14 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %5 = taskflow.counter parent(%4 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %6 = taskflow.counter parent(%5 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg15, %arg13, %arg9, %arg16, %arg10, %arg11, %arg14 : i32, memref<?x256xi32>, memref<512x256xi32>, i32, memref<512x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x256xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<512x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %7 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256xi32>, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %7, %11 : !neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256xi32>, i1>
        %13 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %10, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %8, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %10, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %9, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %12 to %12[%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256xi32>, i1>
        %20 = "neura.phi"(%19, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%18, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.phi"(%17, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = neura.load_indexed [%22, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %24 = "neura.add"(%23) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.mul"(%23, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = neura.load_indexed [%22, %21 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %27 = "neura.mul"(%25, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = neura.load_indexed [%21, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %29 = "neura.mul"(%27, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = neura.load_indexed [%22, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %31 = "neura.add"(%30, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %31 to [%22, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?x256xi32>)
    }
    return
  }
}

