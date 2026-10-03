module {
  func.func @_Z10radar_funciPA256_KiS1_S1_S1_PA32_S_S3_PiS4_PA256_iS6_S6_S6_S6_S6_S4_S4_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S4_(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg5: memref<?x32xi32> {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, %arg6: memref<?x32xi32> {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, %arg8: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, %arg9: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg10: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg11: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg12: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg13: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg14: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg15: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, %arg16: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, %arg17: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg18: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, %arg19: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg20: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg21: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg22: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg23: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg24: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg25: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg26: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg27: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg28: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg29: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, %arg30: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-0", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/radar/shape-temporal-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/radar/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 64 : i64, amoeba.static_bound.arg.0 = 64 : i64, llvm.linkage = #llvm.linkage<external>} {
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
      %0 = taskflow.counter from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %3 = "neura.cast"(%2) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %5 = neura.reserve : !neura.data<index, i1>
        %6 = "neura.phi"(%5, %4) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<i32, i1>
        %8 = "neura.phi"(%7, %1) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i64, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %11 = "neura.cast"(%10) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %12 = "neura.icmp"(%11) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %6, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %11, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %8, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = "neura.not"(%12) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %8, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %6, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.load_indexed [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %20 = "neura.add"(%15, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.add"(%14) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.cast"(%21) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %20 -> %7 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %13 -> %5 : !neura.data<index, i1> !neura.data<index, i1>
        %23 = "neura.div"(%17) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %23 to [%18 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_0 = taskflow.task @Task_1 will_reads(%arg2 : memref<?x256xi32>) will_writes(%arg8 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c64_i32 : index, i32, i32) [original_read_memrefs(%arg2 : memref<?x256xi32>), original_write_memrefs(%arg8 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg31, %arg33, %arg34, %arg35, %arg32 : memref<?x256xi32>, index, i32, i32, memref<?xi32>) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?xi32>, i1>):
        %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %3 = "neura.cast"(%2) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %5 = neura.reserve : !neura.data<index, i1>
        %6 = "neura.phi"(%5, %4) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<i32, i1>
        %8 = "neura.phi"(%7, %1) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<i64, i1>
        %10 = "neura.phi"(%9, %3) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %11 = "neura.cast"(%10) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %12 = "neura.icmp"(%11) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %6, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %11, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %8, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = "neura.not"(%12) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %8, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %6, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.load_indexed [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %20 = "neura.add"(%15, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.add"(%14) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.cast"(%21) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %22 -> %9 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %20 -> %7 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %13 -> %5 : !neura.data<index, i1> !neura.data<index, i1>
        %23 = "neura.div"(%17) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %23 to [%18 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_1:2 = taskflow.task @Task_2 will_reads(%arg1, %done_writes, %arg2, %done_writes_0 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg1, %arg7, %arg2, %arg8 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>)] : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg37 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %6 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_2:2 = taskflow.task @Task_3 will_reads(%done_writes_1#0, %done_writes_1#1 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64, %c63_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%arg9, %arg10 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg11, %arg12 : memref<?x256xi32>, memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: index, %arg36: i32, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg35 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg36, %arg37, %arg31, %arg33, %arg32, %arg34, %arg35 : i32, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<i32, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %4 = "neura.cast"(%2) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %5 = "neura.sub"(%4) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %6 = "neura.icmp"(%4, %5) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %7 = "neura.sel"(%6, %4, %5) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.add"(%7) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %10 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%11, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %12 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33, %arg34 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_3 = taskflow.task @Task_4 will_reads(%done_writes_2#0, %arg3, %done_writes_2#1, %arg4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg13 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg3, %arg12, %arg4 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg13 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg36, %arg37, %arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<index, i1>, %arg43: !neura.data<i32, i1>, %arg44: !neura.data<memref<?x256xi32>, i1>, %arg45: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input5"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.cast"(%3) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %5) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.phi"(%9, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = "neura.phi"(%11, %2) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.reserve : !neura.data<i64, i1>
        %14 = "neura.phi"(%13, %4) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %15 = "neura.cast"(%14) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %10, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %8, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %12, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = neura.grant_predicate %10, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %8, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.load_indexed [%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %26 = neura.load_indexed [%19, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.mul"(%25, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%20, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = neura.load_indexed [%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%19, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.sub"(%28, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.add"(%18) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = "neura.cast"(%33) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %34 -> %13 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %32 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %17 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %19 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        neura.store_indexed %22 to [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_4 = taskflow.task @Task_5 will_reads(%done_writes_2#0, %arg4, %done_writes_2#1, %arg3 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg14 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg11, %arg4, %arg12, %arg3 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg14 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x256xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg36, %arg37, %arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<index, i1>, %arg43: !neura.data<i32, i1>, %arg44: !neura.data<memref<?x256xi32>, i1>, %arg45: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input5"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.cast"(%3) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %7 = neura.reserve : !neura.data<index, i1>
        %8 = "neura.phi"(%7, %5) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.phi"(%9, %6) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = "neura.phi"(%11, %2) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.reserve : !neura.data<i64, i1>
        %14 = "neura.phi"(%13, %4) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %15 = "neura.cast"(%14) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %16 = "neura.icmp"(%15) <{cmpType = "slt"}> {rhs_value = "%input4"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %10, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %19 = neura.grant_predicate %8, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %12, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = "neura.not"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %22 = neura.grant_predicate %12, %21 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = neura.grant_predicate %10, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %24 = neura.grant_predicate %8, %21 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %25 = neura.load_indexed [%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %26 = neura.load_indexed [%19, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %27 = "neura.mul"(%25, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.add"(%20, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = neura.load_indexed [%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %30 = neura.load_indexed [%19, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %31 = "neura.mul"(%29, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%28, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.add"(%18) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = "neura.cast"(%33) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %34 -> %13 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %32 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %17 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %19 -> %7 : !neura.data<index, i1> !neura.data<index, i1>
        neura.store_indexed %22 to [%23, %24 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_5 = taskflow.task @Task_6 will_reads(%done_writes_3 : memref<?x256xi32>) will_writes(%arg15 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c32_i32 : index, i32, i32) [original_read_memrefs(%arg13 : memref<?x256xi32>), original_write_memrefs(%arg15 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %2 = neura.kernel inputs(%arg31, %arg35, %arg32, %arg33 : memref<?x256xi32>, i32, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>):
        %3 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %4 = neura.reserve : !neura.data<i32, i1>
        %5 = neura.phi_start %3, %4 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.add"(%5, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.div"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.icmp"(%11) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %10, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %14 = neura.grant_predicate %6, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %9, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = "neura.not"(%12) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%14 : !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %18 = "neura.phi"(%17, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %18 -> %4 : !neura.data<i32, i1> !neura.data<i32, i1>
        %19 = neura.extract_predicate %6 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %20 = "neura.not"(%19) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %5, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %21 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_6 = taskflow.task @Task_7 will_reads(%done_writes_4 : memref<?x256xi32>) will_writes(%arg16 : memref<?xi32>) value_inputs(%c64, %c0_i32, %c32_i32 : index, i32, i32) [original_read_memrefs(%arg14 : memref<?x256xi32>), original_write_memrefs(%arg16 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg33 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %2 = neura.kernel inputs(%arg31, %arg35, %arg32, %arg33 : memref<?x256xi32>, i32, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?xi32>, i1>, %arg39: !neura.data<index, i1>, %arg40: !neura.data<i32, i1>):
        %3 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %4 = neura.reserve : !neura.data<i32, i1>
        %5 = neura.phi_start %3, %4 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.add"(%5, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.div"(%9) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%7) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.icmp"(%11) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %10, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %14 = neura.grant_predicate %6, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %9, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %16 = "neura.not"(%12) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %9, %16 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%14 : !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %18 = "neura.phi"(%17, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %18 -> %4 : !neura.data<i32, i1> !neura.data<i32, i1>
        %19 = neura.extract_predicate %6 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %20 = "neura.not"(%19) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %21 = neura.grant_predicate %5, %20 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %21 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    %done_writes_7:2 = taskflow.task @Task_8 will_reads(%done_writes_3, %done_writes_5, %done_writes_4, %done_writes_6 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>) will_writes(%arg17, %arg18 : memref<?x256xi32>, memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg13, %arg15, %arg14, %arg16 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>), original_write_memrefs(%arg17, %arg18 : memref<?x256xi32>, memref<?x256xi32>)] : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>, memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?xi32>, %arg35: memref<?x256xi32>, %arg36: memref<?x256xi32>, %arg37: index):
      %c32 = arith.constant 32 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg37 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34, %arg36, %arg37 : memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x256xi32>, i1>, %arg42: !neura.data<memref<?xi32>, i1>, %arg43: !neura.data<memref<?x256xi32>, i1>, %arg44: !neura.data<index, i1>):
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %6 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg35, %arg36 : memref<?x256xi32>, memref<?x256xi32>)
    }
    %done_writes_8 = taskflow.task @Task_9 will_reads(%done_writes_7#0, %arg5, %done_writes_7#1, %arg6 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>) will_writes(%arg19 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg5, %arg18, %arg6 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>), original_write_memrefs(%arg19 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x32xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x32xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %3 = neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg35, %arg36 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index) iter_args_init(%arg37 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x32xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x32xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<index, i1>, %arg44: !neura.data<i32, i1>):
        %4 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %5 = neura.reserve : !neura.data<i32, i1>
        %6 = neura.phi_start %4, %5 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%10, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%6, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = neura.load_indexed [%9, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %15 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%14, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.sub"(%13, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = "neura.icmp"(%18) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %17, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %8, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %7, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = "neura.not"(%19) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %17, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %25 = "neura.phi"(%24, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %25 -> %5 : !neura.data<i32, i1> !neura.data<i32, i1>
        %26 = neura.extract_predicate %7 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %27 = "neura.not"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %6, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %28 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_9 = taskflow.task @Task_10 will_reads(%done_writes_7#0, %arg6, %done_writes_7#1, %arg5 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>) will_writes(%arg20 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg6, %arg18, %arg5 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>), original_write_memrefs(%arg20 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x32xi32>, %arg33: memref<?x256xi32>, %arg34: memref<?x32xi32>, %arg35: memref<?x256xi32>, %arg36: index, %arg37: i32):
      %c32 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg36 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      %3 = neura.kernel inputs(%arg31, %arg32, %arg33, %arg34, %arg35, %arg36 : memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index) iter_args_init(%arg37 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x32xi32>, i1>, %arg40: !neura.data<memref<?x256xi32>, i1>, %arg41: !neura.data<memref<?x32xi32>, i1>, %arg42: !neura.data<memref<?x256xi32>, i1>, %arg43: !neura.data<index, i1>, %arg44: !neura.data<i32, i1>):
        %4 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %5 = neura.reserve : !neura.data<i32, i1>
        %6 = neura.phi_start %4, %5 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 32 : index} -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%10, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%6, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = neura.load_indexed [%9, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %15 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%14, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%13, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%9) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = "neura.icmp"(%18) <{cmpType = "sge"}> {rhs_value = 32 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %17, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = neura.grant_predicate %8, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %22 = neura.grant_predicate %7, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %23 = "neura.not"(%19) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %17, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %20 to [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %25 = "neura.phi"(%24, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %25 -> %5 : !neura.data<i32, i1> !neura.data<i32, i1>
        %26 = neura.extract_predicate %7 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %27 = "neura.not"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %6, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %28 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg35 : memref<?x256xi32>)
    }
    %done_writes_10 = taskflow.task @Task_11 will_reads(%done_writes_8, %done_writes_9 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg21 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg19, %arg20 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg21 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index, %arg35: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg34 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg35, %arg33, %arg34 : memref<?x256xi32>, memref<?x256xi32>, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.icmp"(%4) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %7 = "neura.cast"(%6) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %8 = "neura.icmp"(%5) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = "neura.cast"(%8) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %10 = "neura.sub"(%4) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.sub"(%10, %4) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.mul"(%7, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%4, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.sub"(%5) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.sub"(%14, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.mul"(%9, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%5, %16) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.add"(%13, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_11 = taskflow.task @Task_12 will_reads(%done_writes_10 : memref<?x256xi32>) will_writes(%arg22 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21 : memref<?x256xi32>), original_write_memrefs(%arg22 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg33, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c16 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %0 : memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x256xi32>, i1>, %arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -2 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%4, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%4, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.add"(%6, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%4, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.add"(%9, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%3) {rhs_value = 2 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%4, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.add"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %15 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_12 = taskflow.task @Task_13 will_reads(%done_writes_10 : memref<?x256xi32>) will_writes(%arg23 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21 : memref<?x256xi32>), original_write_memrefs(%arg23 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg33, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %0 : memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x256xi32>, i1>, %arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%7, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.add"(%6, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_13 = taskflow.task @Task_14 will_reads(%done_writes_11, %done_writes_12 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg24 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg22, %arg23 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg24 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg34, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %0 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.add"(%5, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %7 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_14 = taskflow.task @Task_15 will_reads(%done_writes_13 : memref<?x256xi32>) will_writes(%arg25 : memref<?x256xi32>) value_inputs(%c64, %c6_i32, %c3_i32 : index, i32, i32) [original_read_memrefs(%arg24 : memref<?x256xi32>), original_write_memrefs(%arg25 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index, i32, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index, %arg34: i32, %arg35: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg33, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg34, %arg35, %arg32, %0 : memref<?x256xi32>, i32, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<i32, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.div"(%5) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = "neura.mul"(%6) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %7 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_15 = taskflow.task @Task_16 will_reads(%done_writes_10, %done_writes_14 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg26 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21, %arg25 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg26 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg34, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %0 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.icmp"(%5, %6) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %8 = "neura.cast"(%7) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_16 = taskflow.task @Task_17 will_reads(%done_writes_10, %done_writes_15 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg27 : memref<?x256xi32>) value_inputs(%c64 : index) [original_read_memrefs(%arg21, %arg26 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg27 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg34, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg32, %arg33, %0 : memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = neura.load_indexed [%4, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.icmp"(%5, %7) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = "neura.cast"(%8) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %10 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%4, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.icmp"(%5, %11) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %13 = "neura.cast"(%12) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %14 = "neura.mul"(%9, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %16 = "neura.mul"(%15, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.mul"(%16, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %17 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_17 = taskflow.task @Task_18 will_reads(%done_writes_16, %done_writes_10 : memref<?x256xi32>, memref<?x256xi32>) will_writes(%arg28 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg27, %arg21 : memref<?x256xi32>, memref<?x256xi32>), original_write_memrefs(%arg28 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: memref<?x256xi32>, %arg34: index, %arg35: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg34, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg35, %arg32, %arg33, %0 : memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x256xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x256xi32>, i1>, %arg39: !neura.data<memref<?x256xi32>, i1>, %arg40: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %7 = "neura.cast"(%6) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %8 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%5, %9) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.cast"(%10) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %12 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = neura.load_indexed [%12, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %14 = "neura.icmp"(%5, %13) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %15 = "neura.cast"(%14) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %16 = "neura.mul"(%7, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.mul"(%16, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.mul"(%17, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %18 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg33 : memref<?x256xi32>)
    }
    %done_writes_18 = taskflow.task @Task_19 will_reads(%done_writes_17 : memref<?x256xi32>) will_writes(%arg29 : memref<?x256xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg28 : memref<?x256xi32>), original_write_memrefs(%arg29 : memref<?x256xi32>)] : (memref<?x256xi32>, memref<?x256xi32>, index, i32) -> (memref<?x256xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?x256xi32>, %arg33: index, %arg34: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg33, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg31, %arg34, %arg32, %0 : memref<?x256xi32>, i32, memref<?x256xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<i32, i1>, %arg37: !neura.data<memref<?x256xi32>, i1>, %arg38: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %7 = "neura.cast"(%6) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %7 to [%4, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg32 : memref<?x256xi32>)
    }
    %done_writes_19 = taskflow.task @Task_20 will_reads(%done_writes_17 : memref<?x256xi32>) will_writes(%arg30 : memref<?xi32>) value_inputs(%c64, %c0_i32 : index, i32) [original_read_memrefs(%arg28 : memref<?x256xi32>), original_write_memrefs(%arg30 : memref<?xi32>)] : (memref<?x256xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32):
      %c15 = arith.constant 15 : index
      %c1 = arith.constant 1 : index
      %c2 = arith.constant 2 : index
      %c-2 = arith.constant -2 : index
      %0 = arith.addi %arg33, %c-2 : index
      %1 = taskflow.counter from %c2 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c15 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      %3 = neura.kernel inputs(%arg31, %arg32, %0 : memref<?x256xi32>, memref<?xi32>, index) iter_args_init(%arg34 : i32) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg35: !neura.data<memref<?x256xi32>, i1>, %arg36: !neura.data<memref<?xi32>, i1>, %arg37: !neura.data<index, i1>, %arg38: !neura.data<i32, i1>):
        %4 = "neura.grant_once"() <{constant_value = "%iter_arg_init0"}> : () -> !neura.data<i32, i1>
        %5 = neura.reserve : !neura.data<i32, i1>
        %6 = neura.phi_start %4, %5 : !neura.data<i32, i1>, !neura.data<i32, i1> -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 2 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 15 : index} -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.add"(%6, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.icmp"(%11) <{cmpType = "sge"}> {rhs_value = 15 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %10, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %14 = neura.grant_predicate %7, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = "neura.not"(%12) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %16 = neura.grant_predicate %10, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%14 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %17 = "neura.phi"(%16, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.ctrl_mov %17 -> %5 : !neura.data<i32, i1> !neura.data<i32, i1>
        %18 = neura.extract_predicate %7 : !neura.data<index, i1> -> !neura.data<i1, i1>
        %19 = "neura.not"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %6, %19 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        neura.return_value %20 : !neura.data<i32, i1>
        neura.yield
      } : i32
      taskflow.yield done_writes(%arg32 : memref<?xi32>)
    }
    return
  }
}

