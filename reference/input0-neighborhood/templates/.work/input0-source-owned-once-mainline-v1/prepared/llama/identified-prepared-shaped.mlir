module {
  func.func @_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg5: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg6: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg7: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg8: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "identity", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/llama/shape-temporal-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/llama/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 320 : i64, amoeba.static_bound.arg.0 = 320 : i64, llvm.linkage = #llvm.linkage<external>} {
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
    %done_writes = taskflow.task @Task_0 will_reads(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_7 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg2 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_7 : memref<512x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %3 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %4 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %5 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %6 = neura.reserve : !neura.data<i32, i1>
        %7 = neura.phi_start %5, %6 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %13 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %10, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %8, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %9, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %7, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %12 to %12[%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %22 = "neura.phi"(%21, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.phi"(%20, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%25, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %27 = neura.load_indexed [%24, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %28 = "neura.mul"(%26, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.add"(%22, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %29 to [%25, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %29 -> %6 : !neura.data<i32, i1> !neura.data<i32, i1>
        %30 = neura.extract_predicate %8 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %31 = "neura.not"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %7, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %32 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_8 = taskflow.task @Task_1 will_reads(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_6 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg3 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_6 : memref<512x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %3 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %4 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %5 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %6 = neura.reserve : !neura.data<i32, i1>
        %7 = neura.phi_start %5, %6 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %13 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %10, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %8, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %9, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %7, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %12 to %12[%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %22 = "neura.phi"(%21, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.phi"(%20, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%25, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %27 = neura.load_indexed [%24, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %28 = "neura.mul"(%26, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.add"(%22, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %29 to [%25, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %29 -> %6 : !neura.data<i32, i1> !neura.data<i32, i1>
        %30 = neura.extract_predicate %8 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %31 = "neura.not"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %7, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %32 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_9 = taskflow.task @Task_2 will_reads(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_5 : memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%arg1, %arg4 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_5 : memref<512x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<512x256xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %3 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x256xi32>, i1>, %arg16: !neura.data<memref<?x256xi32>, i1>, %arg17: !neura.data<memref<?x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %4 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %5 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %6 = neura.reserve : !neura.data<i32, i1>
        %7 = neura.phi_start %5, %6 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %13 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %10, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %8, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %9, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %7, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %12 to %12[%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %22 = "neura.phi"(%21, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.phi"(%20, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%25, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %27 = neura.load_indexed [%24, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %28 = "neura.mul"(%26, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.add"(%22, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %29 to [%25, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %29 -> %6 : !neura.data<i32, i1> !neura.data<i32, i1>
        %30 = neura.extract_predicate %8 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %31 = "neura.not"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %7, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %32 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x256xi32>)
    }
    %done_writes_10 = taskflow.task @Task_3 will_reads(%done_writes, %done_writes_8 : memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_4 : memref<512x512xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_7, %alloca_6 : memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_4 : memref<512x512xi32>)] : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %3 = neura.kernel inputs(%arg13, %arg11, %arg9, %arg10, %arg12 : i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg14: !neura.data<i32, i1>, %arg15: !neura.data<memref<512x512xi32>, i1>, %arg16: !neura.data<memref<512x256xi32>, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<i32, i1>):
        %4 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x512xi32>, i1>
        %5 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %6 = neura.reserve : !neura.data<i32, i1>
        %7 = neura.phi_start %5, %6 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %12 = neura.grant_predicate %4, %11 : !neura.data<memref<512x512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x512xi32>, i1>
        %13 = neura.grant_predicate %8, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %9, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %10, %11 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %7, %11 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = "neura.not"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %8, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %10, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %9, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %7, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %12 to %12[%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x512xi32>, i1>
        %22 = "neura.phi"(%21, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.phi"(%20, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%19, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.phi"(%18, %13) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = neura.load_indexed [%25, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %27 = neura.load_indexed [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %28 = "neura.mul"(%26, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.add"(%22, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %29 to [%25, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %29 -> %6 : !neura.data<i32, i1> !neura.data<i32, i1>
        %30 = neura.extract_predicate %8 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %31 = "neura.not"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %7, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %32 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_11:2 = taskflow.task @Task_4 will_reads(%done_writes_10 : memref<512x512xi32>) will_writes(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>) value_inputs(%c320, %c0_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%alloca_4 : memref<512x512xi32>), original_write_memrefs(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>)] : (memref<512x512xi32>, memref<512xi32>, memref<512x512xi32>, index, i32, i32) -> (memref<512xi32>, memref<512x512xi32>) {
    ^bb0(%arg9: memref<512x512xi32>, %arg10: memref<512xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %2 = neura.kernel inputs(%arg13, %arg10, %arg9, %arg14, %arg11, %arg12 : i32, memref<512xi32>, memref<512x512xi32>, i32, memref<512x512xi32>, index) iter_args_init(%arg13 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<i32, i1>, %arg16: !neura.data<memref<512xi32>, i1>, %arg17: !neura.data<memref<512x512xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<memref<512x512xi32>, i1>, %arg20: !neura.data<index, i1>, %arg21: !neura.data<i32, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512xi32>, i1>
        %4 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %5 = neura.reserve : !neura.data<i32, i1>
        %6 = neura.phi_start %4, %5 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %9 = "neura.icmp"(%8) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %3, %9 : !neura.data<memref<512xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512xi32>, i1>
        %11 = neura.grant_predicate %7, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %8, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = neura.grant_predicate %6, %9 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %14 = "neura.not"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %15 = neura.grant_predicate %7, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %8, %14 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = neura.grant_predicate %6, %14 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %10 to %10[%11 : !neura.data<index, i1>] !neura.data<memref<512xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512xi32>, i1>
        %18 = "neura.phi"(%17, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.phi"(%16, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%15, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = neura.load_indexed [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %22 = "neura.mul"(%21, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.add"(%22) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %23 to [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %24 = "neura.add"(%18, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %24 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.ctrl_mov %24 -> %5 : !neura.data<i32, i1> !neura.data<i32, i1>
        %25 = neura.extract_predicate %7 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %26 = "neura.not"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %27 = neura.grant_predicate %6, %26 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %27 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg10, %arg11 : memref<512xi32>, memref<512x512xi32>)
    }
    %done_writes_12 = taskflow.task @Task_5 will_reads(%done_writes_11#0, %done_writes_11#1 : memref<512xi32>, memref<512x512xi32>) will_writes(%done_writes_11#1 : memref<512x512xi32>) value_inputs(%c320, %c1_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%alloca_2, %alloca_3 : memref<512xi32>, memref<512x512xi32>), original_write_memrefs(%alloca_3 : memref<512x512xi32>)] : (memref<512xi32>, memref<512x512xi32>, memref<512x512xi32>, index, i32, i32) -> (memref<512x512xi32>) {
    ^bb0(%arg9: memref<512xi32>, %arg10: memref<512x512xi32>, %arg11: memref<512x512xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %arg12 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg9, %arg13, %arg11, %arg14, %arg12 : memref<512xi32>, i32, memref<512x512xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<512xi32>, i1>, %arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x512xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<index, i1>):
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = "neura.add"(%4) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %6 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %7 = "neura.mul"(%6) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.div"(%7, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<512x512xi32>)
    }
    %done_writes_13 = taskflow.task @Task_6 will_reads(%done_writes_12, %done_writes_9, %alloca_1 : memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>) will_writes(%alloca_1 : memref<512x256xi32>) value_inputs(%c320, %c0_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%alloca_3, %alloca_5, %alloca_1 : memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>), original_write_memrefs(%alloca_1 : memref<512x256xi32>)] : (memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32, i32) -> (memref<512x256xi32>) {
    ^bb0(%arg9: memref<512x512xi32>, %arg10: memref<512x256xi32>, %arg11: memref<512x256xi32>, %arg12: memref<512x256xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg13 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg12, %arg9, %arg10, %arg13, %arg15, %arg13 : i32, memref<512x256xi32>, memref<512x512xi32>, memref<512x256xi32>, index, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<memref<512x512xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<index, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        neura.store_indexed %3 to %3[%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {amoeba.source_owned_once_init, lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %8 = neura.reserve : !neura.data<index, i1>
        %9 = "neura.phi"(%8, %7) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.reserve : !neura.data<index, i1>
        %11 = "neura.phi"(%10, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.reserve : !neura.data<i32, i1>
        %13 = "neura.phi"(%12, %2) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = neura.reserve : !neura.data<i64, i1>
        %15 = "neura.phi"(%14, %5) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %16 = "neura.cast"(%15) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %17 = "neura.icmp"(%16) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %11, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %16, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %9, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %13, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = "neura.not"(%17) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %11, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %9, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.load_indexed [%18, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %26 = neura.load_indexed [%19, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %27 = "neura.mul"(%25, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%21, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%18, %20 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %29 = "neura.add"(%19) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.cast"(%29) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %30 -> %14 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %28 -> %12 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %18 -> %10 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %20 -> %8 : !neura.data<index, i1> !neura.data<index, i1>
        %31 = neura.load_indexed [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %32 = "neura.div"(%31) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %32 to [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<512x256xi32>)
    }
    %done_writes_14:2 = taskflow.task @Task_7 will_reads(%done_writes_13, %arg5, %arg6 : memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%alloca_0, %alloca : memref<512x256xi32>, memref<512x256xi32>) value_inputs(%c320, %c0_i32 : index, i32) [original_read_memrefs(%alloca_1, %arg5, %arg6 : memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%alloca_0, %alloca : memref<512x256xi32>, memref<512x256xi32>)] : (memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32) -> (memref<512x256xi32>, memref<512x256xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<512x256xi32>, %arg13: memref<512x256xi32>, %arg14: index, %arg15: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg14 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %3:2 = neura.kernel inputs(%arg15, %arg12, %arg13, %arg9, %arg10, %arg11, %arg14 : i32, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) iter_args_init(%arg15, %arg15 : i32, i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<512x256xi32>, i1>, %arg18: !neura.data<memref<512x256xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<index, i1>, %arg23: !neura.data<i32, i1>, %arg24: !neura.data<i32, i1>):
        %4 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %5 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<memref<512x256xi32>, i1>
        %6 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %7 = neura.reserve : !neura.data<i32, i1>
        %8 = neura.phi_start %6, %7 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %9 = "neura.grant_once"() <{constant_value = "%iter_arg_init1"}> : () -> !neura.data<i32, i1>
        %10 = neura.reserve : !neura.data<i32, i1>
        %11 = neura.phi_start %9, %10 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %12 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %13 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %14 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %15 = "neura.icmp"(%14) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %16 = neura.grant_predicate %4, %15 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %17 = neura.grant_predicate %12, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %13, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %5, %15 : !neura.data<memref<512x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<512x256xi32>, i1>
        %20 = neura.grant_predicate %14, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %11, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %8, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = "neura.not"(%15) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %12, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.grant_predicate %14, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %13, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = neura.grant_predicate %11, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = neura.grant_predicate %8, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %16 to %16[%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        neura.store_indexed %19 to %19[%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<512x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<512x256xi32>, i1>
        %29 = "neura.phi"(%28, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.phi"(%27, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.phi"(%26, %18) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %32 = "neura.phi"(%25, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.phi"(%24, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = neura.load_indexed [%33, %32 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %35 = neura.load_indexed [%32, %31 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %36 = "neura.mul"(%34, %35) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.add"(%30, %36) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %37 to [%33, %31 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %38 = neura.load_indexed [%32, %31 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %39 = "neura.mul"(%34, %38) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %40 = "neura.add"(%29, %39) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %40 to [%33, %31 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.ctrl_mov %40 -> %7 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %37 -> %10 : !neura.data<i32, i1> !neura.data<i32, i1>
        %41 = neura.extract_predicate %12 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %42 = "neura.not"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %43 = neura.grant_predicate %8, %42 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %44 = neura.grant_predicate %11, %42 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %43, %44 : !neura.data<i32, i1>, !neura.data<i32, i1>
        neura.yield
      } : i32, i32
      taskflow.yield done_writes(%arg12, %arg13 : memref<512x256xi32>, memref<512x256xi32>)
    }
    %done_writes_15 = taskflow.task @Task_8 will_reads(%done_writes_14#0, %done_writes_14#1, %arg7, %arg8 : memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg8 : memref<?x256xi32>) value_inputs(%c320, %c0_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%alloca_0, %alloca, %arg7, %arg8 : memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?x256xi32>)] : (memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<?x256xi32>, %arg13: memref<?x256xi32>, %arg14: index, %arg15: i32, %arg16: i32):
      %c256 = arith.constant 256 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg14 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c256 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg15, %arg13, %arg9, %arg16, %arg10, %arg11, %arg14 : i32, memref<?x256xi32>, memref<512x256xi32>, i32, memref<512x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x256xi32>, i1>, %arg19: !neura.data<memref<512x256xi32>, i1>, %arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<512x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<memref<?x256xi32>, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 256 : index} -> !neura.data<index, i1>
        %7 = "neura.icmp"(%6) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %8 = neura.grant_predicate %3, %7 : !neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?x256xi32>, i1>
        %9 = neura.grant_predicate %4, %7 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %10 = neura.grant_predicate %5, %7 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %6, %7 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = "neura.not"(%7) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %4, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %6, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %5, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        neura.store_indexed %8 to %8[%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x256xi32>, i1> {lhs_value = "%input0"} : !neura.data<memref<?x256xi32>, i1>
        %16 = "neura.phi"(%15, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%14, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = "neura.phi"(%13, %9) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = neura.load_indexed [%18, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %20 = "neura.add"(%19) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.mul"(%19, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = neura.load_indexed [%18, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %23 = "neura.mul"(%21, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = neura.load_indexed [%17, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %25 = "neura.mul"(%23, %24) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = neura.load_indexed [%18, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.add"(%26, %25) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%18, %16 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?x256xi32>)
    }
    return
  }
}

