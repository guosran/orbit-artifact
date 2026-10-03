module {
  func.func @_Z15raytracing_funciPKiS0_S0_S0_S0_S0_S0_S0_S0_S0_PiS1_S1_S1_S1_S1_S1_S1_S1_PA8_iS1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_(%arg0: i32, %arg1: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg2: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg3: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg4: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg5: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg6: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg8: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 4>, amoeba.noalias}, %arg9: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 4>, amoeba.noalias}, %arg10: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 4>, amoeba.noalias}, %arg11: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg12: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg13: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg14: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg15: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg16: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg17: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg18: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg19: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg20: memref<?x8xi32> {amoeba.logical_transfer_shape = array<i64: 1472, 8>, amoeba.noalias}, %arg21: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg22: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg23: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg24: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg25: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg26: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg27: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg28: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg29: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg30: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg31: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg32: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg33: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg34: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg35: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg36: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg37: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg38: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg39: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg40: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg41: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg42: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg43: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg44: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}, %arg45: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1472>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-0", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/raytracing/shape-temporal-rank-0/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/raytracing/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 1472 : i64, amoeba.static_bound.arg.0 = 1472 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c-32_i32 = arith.constant -32 : i32
    %c8_i32 = arith.constant 8 : i32
    %c1073741824_i32 = arith.constant 1073741824 : i32
    %c4096_i32 = arith.constant 4096 : i32
    %c1024_i32 = arith.constant 1024 : i32
    %c32_i32 = arith.constant 32 : i32
    %c1_i32 = arith.constant 1 : i32
    %c64_i32 = arith.constant 64 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1472 = arith.constant 1472 : index
    %done_writes:2 = taskflow.task @Task_0 will_writes(%arg11, %arg12 : memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c64_i32 : index, i32) [original_write_memrefs(%arg11, %arg12 : memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: index, %arg49: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg49, %arg46, %arg47, %arg48 : i32, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg50: !neura.data<i32, i1>, %arg51: !neura.data<memref<?xi32>, i1>, %arg52: !neura.data<memref<?xi32>, i1>, %arg53: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %2 = "neura.cast"(%1) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %3 = "neura.div"(%2) {rhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %4 = "neura.mul"(%3) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %5 = "neura.sub"(%2, %4) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %5 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.div"(%2) {rhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %6 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg46, %arg47 : memref<?xi32>, memref<?xi32>)
    }
    %done_writes_0:3 = taskflow.task @Task_1 will_reads(%done_writes#0, %done_writes#1 : memref<?xi32>, memref<?xi32>) will_writes(%arg13, %arg14, %arg15 : memref<?xi32>, memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c-32_i32, %c32_i32, %c1024_i32 : index, i32, i32, i32) [original_read_memrefs(%arg11, %arg12 : memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg13, %arg14, %arg15 : memref<?xi32>, memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32, i32) -> (memref<?xi32>, memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: index, %arg52: i32, %arg53: i32, %arg54: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg52, %arg53, %arg48, %arg47, %arg49, %arg54, %arg50, %arg51 : memref<?xi32>, i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<i32, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<memref<?xi32>, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<i32, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input7"}> : () -> !neura.data<memref<?xi32>, i1>
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input8"} -> !neura.data<index, i1>
        %3 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %4 = "neura.add"(%3) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %5 = "neura.mul"(%4) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %5 to [%2 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %7 = "neura.add"(%6) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.mul"(%7) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%2 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.store_indexed %1 to %1[%2 : !neura.data<index, i1>] !neura.data<memref<?xi32>, i1> {lhs_value = "%input6"} : !neura.data<memref<?xi32>, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg48, %arg49, %arg50 : memref<?xi32>, memref<?xi32>, memref<?xi32>)
    }
    %done_writes_1 = taskflow.task @Task_2 will_reads(%done_writes_0#0, %done_writes_0#1, %done_writes_0#2 : memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg16 : memref<?xi32>) value_inputs(%c1472, %c0_i32, %c1_i32 : index, i32, i32) [original_read_memrefs(%arg13, %arg14, %arg15 : memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg16 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: index, %arg51: i32, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg51, %arg47, %arg48, %arg52, %arg49, %arg50 : memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, i32, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<i32, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %3 = "neura.icmp"(%2) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %4 = neura.grant_predicate %2, %3 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %5 = neura.grant_predicate %1, %3 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %6 = "neura.not"(%3) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %7 = neura.grant_predicate %2, %6 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %8 = neura.grant_predicate %1, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = "neura.sub"(%7) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.phi"(%5, %8) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.phi"(%4, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%10 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %13 = "neura.icmp"(%12) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %12, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %10, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %11, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = "neura.not"(%13) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = neura.grant_predicate %12, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = neura.grant_predicate %10, %17 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %11, %17 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %21 = "neura.sub"(%18) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.phi"(%16, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %23 = "neura.phi"(%15, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%14, %21) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = neura.load_indexed [%23 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %26 = "neura.icmp"(%25) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %27 = neura.grant_predicate %25, %26 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = neura.grant_predicate %22, %26 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %29 = neura.grant_predicate %24, %26 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %30 = neura.grant_predicate %23, %26 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = "neura.not"(%26) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %32 = neura.grant_predicate %25, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %22, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %34 = neura.grant_predicate %24, %31 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %35 = neura.grant_predicate %23, %31 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %36 = "neura.sub"(%32) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.phi"(%30, %35) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.phi"(%29, %34) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.phi"(%28, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %40 = "neura.phi"(%27, %36) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %41 = "neura.add"(%39, %38) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %42 = "neura.add"(%41, %40) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %43 = "neura.add"(%42) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %43 to [%37 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg49 : memref<?xi32>)
    }
    %done_writes_2:3 = taskflow.task @Task_3 will_reads(%done_writes_0#0, %done_writes_1, %done_writes_0#1, %done_writes_0#2 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg17, %arg18, %arg19 : memref<?xi32>, memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c1024_i32 : index, i32) [original_read_memrefs(%arg13, %arg16, %arg14, %arg15 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg17, %arg18, %arg19 : memref<?xi32>, memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>, memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: index, %arg54: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg54, %arg47, %arg50, %arg48, %arg51, %arg49, %arg52, %arg53 : memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<i32, i1>, %arg57: !neura.data<memref<?xi32>, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<memref<?xi32>, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input8"} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %3 = "neura.mul"(%2) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %4 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %5 = "neura.div"(%3, %4) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %5 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %7 = "neura.mul"(%6) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %9 = "neura.div"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input6"} : !neura.data<i32, i1>
        %11 = "neura.mul"(%10) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %13 = "neura.div"(%11, %12) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input7"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50, %arg51, %arg52 : memref<?xi32>, memref<?xi32>, memref<?xi32>)
    }
    %done_writes_3 = taskflow.task @Task_4 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg20 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_4 = taskflow.task @Task_5 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%done_writes_3 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_5 = taskflow.task @Task_6 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%done_writes_4 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_6 = taskflow.task @Task_7 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%done_writes_5 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_7 = taskflow.task @Task_8 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%done_writes_6 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 4 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_8 = taskflow.task @Task_9 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%done_writes_7 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 5 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_9 = taskflow.task @Task_10 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%done_writes_8 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 6 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_10 = taskflow.task @Task_11 will_reads(%done_writes_2#0, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%done_writes_9 : memref<?x8xi32>) value_inputs(%c1472, %c0_i32 : index, i32) [original_read_memrefs(%arg17, %arg1, %arg3, %arg4 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg20 : memref<?x8xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, index, i32) -> (memref<?x8xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?x8xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?x8xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?x8xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 7 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %6 = "neura.sub"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %9 = "neura.sub"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.icmp"(%6, %8) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %9, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %2 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?x8xi32>)
    }
    %done_writes_11 = taskflow.task @Task_12 will_reads(%done_writes_2#1 : memref<?xi32>) will_writes(%arg21 : memref<?xi32>) value_inputs(%c1472, %c0_i32, %c4096_i32, %c1073741824_i32 : index, i32, i32, i32) [original_read_memrefs(%arg18 : memref<?xi32>), original_write_memrefs(%arg21 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, index, i32, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: index, %arg49: i32, %arg50: i32, %arg51: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg48 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg49, %arg50, %arg51, %arg47, %arg48 : memref<?xi32>, i32, i32, i32, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg52: !neura.data<memref<?xi32>, i1>, %arg53: !neura.data<i32, i1>, %arg54: !neura.data<i32, i1>, %arg55: !neura.data<i32, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = "neura.icmp"(%4) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %6 = "neura.sel"(%5, %1, %2) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %6 to [%3 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg47 : memref<?xi32>)
    }
    %done_writes_12:2 = taskflow.task @Task_13 will_reads(%done_writes_11, %done_writes_10 : memref<?xi32>, memref<?x8xi32>) will_writes(%arg22, %arg23 : memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c0_i32, %c1073741824_i32, %c8_i32 : index, i32, i32, i32) [original_read_memrefs(%arg21, %arg20 : memref<?xi32>, memref<?x8xi32>), original_write_memrefs(%arg22, %arg23 : memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?x8xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32, i32) -> (memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?x8xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: index, %arg51: i32, %arg52: i32, %arg53: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg51, %arg52, %arg47, %arg53, %arg48, %arg49, %arg50 : memref<?xi32>, i32, i32, memref<?x8xi32>, i32, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<i32, i1>, %arg56: !neura.data<i32, i1>, %arg57: !neura.data<memref<?x8xi32>, i1>, %arg58: !neura.data<i32, i1>, %arg59: !neura.data<memref<?xi32>, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.cast"(%3) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = "neura.icmp"(%6) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %8 = "neura.sel"(%7, %6, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.phi"(%9, %5) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.reserve : !neura.data<i32, i1>
        %12 = "neura.phi"(%11, %2) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.reserve : !neura.data<i32, i1>
        %14 = "neura.phi"(%13, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.reserve : !neura.data<i64, i1>
        %16 = "neura.phi"(%15, %4) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %17 = "neura.cast"(%16) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %18 = "neura.icmp"(%17) <{cmpType = "slt"}> {rhs_value = 8 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %19 = neura.grant_predicate %17, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %10, %18 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = neura.grant_predicate %14, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %22 = neura.grant_predicate %12, %18 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %23 = "neura.not"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %24 = neura.grant_predicate %12, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %10, %23 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %14, %23 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = "neura.cast"(%19) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %28 = neura.load_indexed [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %29 = "neura.icmp"(%28) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %28, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %31 = neura.grant_predicate %21, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %27, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %22, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %34 = neura.grant_predicate %19, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %35 = neura.grant_predicate %20, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %36 = "neura.not"(%29) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %21, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %38 = neura.grant_predicate %22, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %39 = neura.grant_predicate %19, %36 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %40 = neura.grant_predicate %20, %36 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %41 = "neura.icmp"(%30, %31) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %42 = "neura.sel"(%41, %30, %31) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %43 = "neura.sel"(%41, %32, %33) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.phi"(%35, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %45 = "neura.phi"(%34, %39) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.phi"(%43, %38) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %47 = "neura.phi"(%42, %37) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %48 = "neura.add"(%45) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %49 = "neura.cast"(%48) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %49 -> %15 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %47 -> %13 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %46 -> %11 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %44 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        neura.store_indexed %24 to [%25 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.store_indexed %26 to [%25 : !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg48, %arg49 : memref<?xi32>, memref<?xi32>)
    }
    %done_writes_13:3 = taskflow.task @Task_14 will_reads(%done_writes_2#0, %done_writes_12#1, %done_writes_2#1, %done_writes_2#2 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg24, %arg25, %arg26 : memref<?xi32>, memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c1024_i32 : index, i32) [original_read_memrefs(%arg17, %arg23, %arg18, %arg19 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg24, %arg25, %arg26 : memref<?xi32>, memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>, memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: index, %arg54: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg54, %arg50, %arg48, %arg51, %arg49, %arg52, %arg53 : memref<?xi32>, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<memref<?xi32>, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input8"} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %3 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %4 = "neura.mul"(%2, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %5 = "neura.div"(%4) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %5 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %8 = "neura.mul"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.div"(%8) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        %10 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input6"} : !neura.data<i32, i1>
        %11 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %12 = "neura.mul"(%10, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.div"(%12) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input7"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50, %arg51, %arg52 : memref<?xi32>, memref<?xi32>, memref<?xi32>)
    }
    %done_writes_14:3 = taskflow.task @Task_15 will_reads(%done_writes_2#0, %done_writes_2#1, %done_writes_2#2 : memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg27, %arg28, %arg29 : memref<?xi32>, memref<?xi32>, memref<?xi32>) value_inputs(%c1472 : index) [original_read_memrefs(%arg17, %arg18, %arg19 : memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg27, %arg28, %arg29 : memref<?xi32>, memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) -> (memref<?xi32>, memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: index):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg52 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg49, %arg47, %arg50, %arg48, %arg51, %arg52 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<memref<?xi32>, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        neura.store_indexed %2 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %3 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        neura.store_indexed %3 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %4 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        neura.store_indexed %4 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg49, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>)
    }
    %done_writes_15:3 = taskflow.task @Task_16 will_reads(%done_writes_12#0, %arg5, %arg6, %arg7 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg30, %arg31, %arg32 : memref<?xi32>, memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c8_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg22, %arg5, %arg6, %arg7 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg30, %arg31, %arg32 : memref<?xi32>, memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>, memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: index, %arg54: i32, %arg55: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg54, %arg55, %arg47, %arg50, %arg48, %arg51, %arg49, %arg52, %arg53 : memref<?xi32>, i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<i32, i1>, %arg59: !neura.data<memref<?xi32>, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<memref<?xi32>, i1>, %arg64: !neura.data<memref<?xi32>, i1>, %arg65: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input9"} -> !neura.data<index, i1>
        %3 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %4 = "neura.icmp"(%3) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %5 = "neura.sel"(%4, %3, %1) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %6 = "neura.cast"(%5) <{cast_type = "int_to_index"}> : (!neura.data<i32, i1>) -> !neura.data<index, i1>
        %7 = neura.load_indexed [%6 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        neura.store_indexed %7 to [%2 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%6 : !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        neura.store_indexed %8 to [%2 : !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        %9 = neura.load_indexed [%6 : !neura.data<index, i1>]  {lhs_value = "%input7"} : !neura.data<i32, i1>
        neura.store_indexed %9 to [%2 : !neura.data<index, i1>]  {rhs_value = "%input8"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50, %arg51, %arg52 : memref<?xi32>, memref<?xi32>, memref<?xi32>)
    }
    %done_writes_16:2 = taskflow.task @Task_17 will_reads(%done_writes_14#2, %arg10 : memref<?xi32>, memref<?xi32>) will_writes(%arg33, %arg34 : memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c0_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg29, %arg10 : memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg33, %arg34 : memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: index, %arg51: i32, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg51, %arg52, %arg48, %arg49, %arg50 : memref<?xi32>, memref<?xi32>, i32, i32, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<i32, i1>, %arg56: !neura.data<i32, i1>, %arg57: !neura.data<memref<?xi32>, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %3 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%2 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.add"(%5, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "sgt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = neura.grant_predicate %7, %8 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %10 = neura.grant_predicate %4, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %3, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %1, %8 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %13 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %1, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %4, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %3, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = "neura.div"(%9) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.phi"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.phi"(%11, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%10, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%17, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %21 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %22 = neura.load_indexed [%20 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %23 = neura.load_indexed [%19 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %24 = "neura.add"(%22, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.icmp"(%24) <{cmpType = "sgt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %24, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %20, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = "neura.not"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %29 = neura.grant_predicate %18, %28 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %30 = neura.grant_predicate %20, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = "neura.div"(%26) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.phi"(%27, %30) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.phi"(%31, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %33 to [%32 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg48, %arg49 : memref<?xi32>, memref<?xi32>)
    }
    %done_writes_17:2 = taskflow.task @Task_18 will_reads(%done_writes_14#2, %arg10 : memref<?xi32>, memref<?xi32>) will_writes(%arg35, %arg36 : memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c0_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg29, %arg10 : memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg35, %arg36 : memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: index, %arg51: i32, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg51, %arg52, %arg48, %arg49, %arg50 : memref<?xi32>, memref<?xi32>, i32, i32, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<i32, i1>, %arg56: !neura.data<i32, i1>, %arg57: !neura.data<memref<?xi32>, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %3 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.add"(%5, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "sgt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = neura.grant_predicate %7, %8 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %10 = neura.grant_predicate %4, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %2, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %1, %8 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %13 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %1, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %4, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %2, %13 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = "neura.div"(%9) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.phi"(%12, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.phi"(%11, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%10, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%17, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %21 to [%20 : !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        %22 = neura.load_indexed [%20 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %23 = neura.load_indexed [%19 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %24 = "neura.add"(%22, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.icmp"(%24) <{cmpType = "sgt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %26 = neura.grant_predicate %24, %25 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %20, %25 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = "neura.not"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %29 = neura.grant_predicate %18, %28 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %30 = neura.grant_predicate %20, %28 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = "neura.div"(%26) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.phi"(%27, %30) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.phi"(%31, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %33 to [%32 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg48, %arg49 : memref<?xi32>, memref<?xi32>)
    }
    %done_writes_18 = taskflow.task @Task_19 will_reads(%done_writes_12#0, %arg4, %arg8, %done_writes_13#0, %arg9, %done_writes_13#1 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg37 : memref<?xi32>) value_inputs(%c1472, %c8_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg22, %arg4, %arg8, %arg24, %arg9, %arg25 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg37 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: index, %arg54: i32, %arg55: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg54, %arg47, %arg55, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53 : memref<?xi32>, i32, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<i32, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<memref<?xi32>, i1>, %arg64: !neura.data<memref<?xi32>, i1>, %arg65: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input9"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = "neura.icmp"(%4) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %6 = neura.grant_predicate %4, %5 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %7 = neura.grant_predicate %2, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %8 = neura.grant_predicate %3, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = "neura.not"(%5) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %1, %9 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %11 = neura.grant_predicate %2, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %3, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = "neura.cast"(%6) <{cast_type = "int_to_index"}> : (!neura.data<i32, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%13 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %15 = "neura.phi"(%8, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%7, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%14, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %20 = "neura.sub"(%18, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input6"} : !neura.data<i32, i1>
        %22 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input7"} : !neura.data<i32, i1>
        %23 = "neura.sub"(%21, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.icmp"(%20) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %20, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = neura.grant_predicate %23, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %17, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = neura.grant_predicate %15, %24 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = "neura.not"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %20, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %31 = neura.grant_predicate %23, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %17, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %15, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = "neura.sub"(%25) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.phi"(%28, %33) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.phi"(%27, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.phi"(%26, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = "neura.phi"(%34, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.icmp"(%37) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %40 = neura.grant_predicate %37, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %41 = neura.grant_predicate %38, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %42 = neura.grant_predicate %36, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %43 = neura.grant_predicate %35, %39 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %44 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = neura.grant_predicate %37, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %46 = neura.grant_predicate %38, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %47 = neura.grant_predicate %36, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %48 = neura.grant_predicate %35, %44 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %49 = "neura.sub"(%40) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.phi"(%43, %48) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%42, %47) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.phi"(%41, %46) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.phi"(%49, %45) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %54 = "neura.add"(%52, %53) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.icmp"(%54, %51) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %56 = "neura.cast"(%55) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %56 to [%50 : !neura.data<index, i1>]  {rhs_value = "%input8"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg52 : memref<?xi32>)
    }
    %done_writes_19 = taskflow.task @Task_20 will_reads(%done_writes_12#0, %arg4, %arg8, %done_writes_13#0, %arg9, %done_writes_13#1 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg38 : memref<?xi32>) value_inputs(%c1472, %c8_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg22, %arg4, %arg8, %arg24, %arg9, %arg25 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg38 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: index, %arg54: i32, %arg55: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg54, %arg47, %arg55, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53 : memref<?xi32>, i32, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<i32, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<memref<?xi32>, i1>, %arg64: !neura.data<memref<?xi32>, i1>, %arg65: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 1 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input9"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = "neura.icmp"(%4) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %6 = neura.grant_predicate %4, %5 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %7 = neura.grant_predicate %2, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %8 = neura.grant_predicate %3, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = "neura.not"(%5) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %1, %9 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %11 = neura.grant_predicate %2, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %3, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = "neura.cast"(%6) <{cast_type = "int_to_index"}> : (!neura.data<i32, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%13 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %15 = "neura.phi"(%8, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%7, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%14, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %20 = "neura.sub"(%18, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input6"} : !neura.data<i32, i1>
        %22 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input7"} : !neura.data<i32, i1>
        %23 = "neura.sub"(%21, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.icmp"(%20) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %20, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = neura.grant_predicate %23, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %17, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = neura.grant_predicate %15, %24 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = "neura.not"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %20, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %31 = neura.grant_predicate %23, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %17, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %15, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = "neura.sub"(%25) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.phi"(%28, %33) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.phi"(%27, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.phi"(%26, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = "neura.phi"(%34, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.icmp"(%37) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %40 = neura.grant_predicate %37, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %41 = neura.grant_predicate %38, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %42 = neura.grant_predicate %36, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %43 = neura.grant_predicate %35, %39 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %44 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = neura.grant_predicate %37, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %46 = neura.grant_predicate %38, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %47 = neura.grant_predicate %36, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %48 = neura.grant_predicate %35, %44 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %49 = "neura.sub"(%40) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.phi"(%43, %48) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%42, %47) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.phi"(%41, %46) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.phi"(%49, %45) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %54 = "neura.add"(%52, %53) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.icmp"(%54, %51) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %56 = "neura.cast"(%55) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %56 to [%50 : !neura.data<index, i1>]  {rhs_value = "%input8"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg52 : memref<?xi32>)
    }
    %done_writes_20 = taskflow.task @Task_21 will_reads(%done_writes_12#0, %arg4, %arg8, %done_writes_13#0, %arg9, %done_writes_13#1 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg39 : memref<?xi32>) value_inputs(%c1472, %c8_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg22, %arg4, %arg8, %arg24, %arg9, %arg25 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg39 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: index, %arg54: i32, %arg55: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg54, %arg47, %arg55, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53 : memref<?xi32>, i32, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<i32, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<memref<?xi32>, i1>, %arg64: !neura.data<memref<?xi32>, i1>, %arg65: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 2 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input9"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = "neura.icmp"(%4) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %6 = neura.grant_predicate %4, %5 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %7 = neura.grant_predicate %2, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %8 = neura.grant_predicate %3, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = "neura.not"(%5) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %1, %9 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %11 = neura.grant_predicate %2, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %3, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = "neura.cast"(%6) <{cast_type = "int_to_index"}> : (!neura.data<i32, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%13 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %15 = "neura.phi"(%8, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%7, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%14, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %20 = "neura.sub"(%18, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input6"} : !neura.data<i32, i1>
        %22 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input7"} : !neura.data<i32, i1>
        %23 = "neura.sub"(%21, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.icmp"(%20) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %20, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = neura.grant_predicate %23, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %17, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = neura.grant_predicate %15, %24 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = "neura.not"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %20, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %31 = neura.grant_predicate %23, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %17, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %15, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = "neura.sub"(%25) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.phi"(%28, %33) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.phi"(%27, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.phi"(%26, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = "neura.phi"(%34, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.icmp"(%37) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %40 = neura.grant_predicate %37, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %41 = neura.grant_predicate %38, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %42 = neura.grant_predicate %36, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %43 = neura.grant_predicate %35, %39 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %44 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = neura.grant_predicate %37, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %46 = neura.grant_predicate %38, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %47 = neura.grant_predicate %36, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %48 = neura.grant_predicate %35, %44 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %49 = "neura.sub"(%40) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.phi"(%43, %48) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%42, %47) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.phi"(%41, %46) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.phi"(%49, %45) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %54 = "neura.add"(%52, %53) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.icmp"(%54, %51) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %56 = "neura.cast"(%55) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %56 to [%50 : !neura.data<index, i1>]  {rhs_value = "%input8"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg52 : memref<?xi32>)
    }
    %done_writes_21 = taskflow.task @Task_22 will_reads(%done_writes_12#0, %arg4, %arg8, %done_writes_13#0, %arg9, %done_writes_13#1 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg40 : memref<?xi32>) value_inputs(%c1472, %c8_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg22, %arg4, %arg8, %arg24, %arg9, %arg25 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg40 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: index, %arg54: i32, %arg55: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg53 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg54, %arg47, %arg55, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53 : memref<?xi32>, i32, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<i32, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<memref<?xi32>, i1>, %arg64: !neura.data<memref<?xi32>, i1>, %arg65: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %2 = "neura.constant"() <{value = 3 : index}> : () -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input9"} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%3 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = "neura.icmp"(%4) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %6 = neura.grant_predicate %4, %5 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %7 = neura.grant_predicate %2, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %8 = neura.grant_predicate %3, %5 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = "neura.not"(%5) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %10 = neura.grant_predicate %1, %9 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %11 = neura.grant_predicate %2, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = neura.grant_predicate %3, %9 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %13 = "neura.cast"(%6) <{cast_type = "int_to_index"}> : (!neura.data<i32, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%13 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %15 = "neura.phi"(%8, %12) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.phi"(%7, %11) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.phi"(%14, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %19 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input5"} : !neura.data<i32, i1>
        %20 = "neura.sub"(%18, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = neura.load_indexed [%16 : !neura.data<index, i1>]  {lhs_value = "%input6"} : !neura.data<i32, i1>
        %22 = neura.load_indexed [%15 : !neura.data<index, i1>]  {lhs_value = "%input7"} : !neura.data<i32, i1>
        %23 = "neura.sub"(%21, %22) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.icmp"(%20) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %20, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = neura.grant_predicate %23, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %27 = neura.grant_predicate %17, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %28 = neura.grant_predicate %15, %24 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = "neura.not"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %20, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %31 = neura.grant_predicate %23, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = neura.grant_predicate %17, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %33 = neura.grant_predicate %15, %29 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %34 = "neura.sub"(%25) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = "neura.phi"(%28, %33) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.phi"(%27, %32) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.phi"(%26, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = "neura.phi"(%34, %30) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.icmp"(%37) <{cmpType = "slt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %40 = neura.grant_predicate %37, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %41 = neura.grant_predicate %38, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %42 = neura.grant_predicate %36, %39 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %43 = neura.grant_predicate %35, %39 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %44 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = neura.grant_predicate %37, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %46 = neura.grant_predicate %38, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %47 = neura.grant_predicate %36, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %48 = neura.grant_predicate %35, %44 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %49 = "neura.sub"(%40) {lhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.phi"(%43, %48) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%42, %47) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.phi"(%41, %46) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.phi"(%49, %45) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %54 = "neura.add"(%52, %53) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %55 = "neura.icmp"(%54, %51) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %56 = "neura.cast"(%55) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %56 to [%50 : !neura.data<index, i1>]  {rhs_value = "%input8"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg52 : memref<?xi32>)
    }
    %done_writes_22 = taskflow.task @Task_23 will_reads(%done_writes_16#0, %done_writes_16#1, %done_writes_17#0, %done_writes_17#1 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg41 : memref<?xi32>) value_inputs(%c1472, %c64_i32 : index, i32) [original_read_memrefs(%arg33, %arg34, %arg35, %arg36 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg41 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg52, %arg47, %arg48, %arg49, %arg50, %arg51 : memref<?xi32>, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<i32, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<memref<?xi32>, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %3 = "neura.add"(%2) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %4 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %5 = "neura.add"(%3, %4) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %6 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %7 = "neura.add"(%5, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %9 = "neura.add"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?xi32>)
    }
    %done_writes_23 = taskflow.task @Task_24 will_reads(%done_writes_18, %done_writes_19, %done_writes_20, %done_writes_21 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg42 : memref<?xi32>) value_inputs(%c1472, %c1_i32 : index, i32) [original_read_memrefs(%arg37, %arg38, %arg39, %arg40 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg42 : memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: index, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg51 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg49, %arg52, %arg50, %arg51 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, i32, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<memref<?xi32>, i1>, %arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<i32, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %3 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %4 = "neura.add"(%2, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %5 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %6 = "neura.add"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %7 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %8 = "neura.add"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%8) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %9 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg50 : memref<?xi32>)
    }
    %done_writes_24:3 = taskflow.task @Task_25 will_reads(%done_writes_15#0, %done_writes_22, %done_writes_23, %done_writes_15#1, %done_writes_15#2 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) will_writes(%arg43, %arg44, %arg45 : memref<?xi32>, memref<?xi32>, memref<?xi32>) value_inputs(%c1472 : index) [original_read_memrefs(%arg30, %arg41, %arg42, %arg31, %arg32 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>), original_write_memrefs(%arg43, %arg44, %arg45 : memref<?xi32>, memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) -> (memref<?xi32>, memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: memref<?xi32>, %arg51: memref<?xi32>, %arg52: memref<?xi32>, %arg53: memref<?xi32>, %arg54: index):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg54 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg47, %arg48, %arg51, %arg49, %arg52, %arg50, %arg53, %arg54 : memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg55: !neura.data<memref<?xi32>, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<memref<?xi32>, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<memref<?xi32>, i1>, %arg60: !neura.data<memref<?xi32>, i1>, %arg61: !neura.data<memref<?xi32>, i1>, %arg62: !neura.data<memref<?xi32>, i1>, %arg63: !neura.data<index, i1>):
        %1 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input8"} -> !neura.data<index, i1>
        %2 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %3 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %4 = "neura.mul"(%2, %3) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %5 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %6 = "neura.div"(%4, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %6 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %8 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %9 = "neura.mul"(%7, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %11 = "neura.div"(%9, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input5"} : !neura.data<i32, i1>
        %12 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input6"} : !neura.data<i32, i1>
        %13 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %14 = "neura.mul"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.load_indexed [%1 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %16 = "neura.div"(%14, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %16 to [%1 : !neura.data<index, i1>]  {rhs_value = "%input7"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg51, %arg52, %arg53 : memref<?xi32>, memref<?xi32>, memref<?xi32>)
    }
    %done_writes_25:3 = taskflow.task @Task_26 will_reads(%done_writes_12#1 : memref<?xi32>) will_writes(%done_writes_24#0, %done_writes_24#1, %done_writes_24#2 : memref<?xi32>, memref<?xi32>, memref<?xi32>) value_inputs(%c1472, %c1073741824_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg23 : memref<?xi32>), original_write_memrefs(%arg43, %arg44, %arg45 : memref<?xi32>, memref<?xi32>, memref<?xi32>)] : (memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>, memref<?xi32>, memref<?xi32>) {
    ^bb0(%arg46: memref<?xi32>, %arg47: memref<?xi32>, %arg48: memref<?xi32>, %arg49: memref<?xi32>, %arg50: index, %arg51: i32, %arg52: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg50 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg46, %arg51, %arg52, %arg47, %arg48, %arg49, %arg50 : memref<?xi32>, i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg53: !neura.data<memref<?xi32>, i1>, %arg54: !neura.data<i32, i1>, %arg55: !neura.data<i32, i1>, %arg56: !neura.data<memref<?xi32>, i1>, %arg57: !neura.data<memref<?xi32>, i1>, %arg58: !neura.data<memref<?xi32>, i1>, %arg59: !neura.data<index, i1>):
        %1 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<memref<?xi32>, i1>
        %2 = "neura.constant"() <{value = "%input4"}> : () -> !neura.data<memref<?xi32>, i1>
        %3 = "neura.constant"() <{value = "%input5"}> : () -> !neura.data<memref<?xi32>, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%4 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "eq"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %7 = neura.grant_predicate %1, %6 : !neura.data<memref<?xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?xi32>, i1>
        %8 = neura.grant_predicate %4, %6 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = neura.grant_predicate %2, %6 : !neura.data<memref<?xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?xi32>, i1>
        %10 = neura.grant_predicate %3, %6 : !neura.data<memref<?xi32>, i1>, !neura.data<i1, i1> -> !neura.data<memref<?xi32>, i1>
        neura.store_indexed %7 to %7[%8 : !neura.data<index, i1>] !neura.data<memref<?xi32>, i1> {lhs_value = "%input2"} : !neura.data<memref<?xi32>, i1>
        neura.store_indexed %9 to %9[%8 : !neura.data<index, i1>] !neura.data<memref<?xi32>, i1> {lhs_value = "%input2"} : !neura.data<memref<?xi32>, i1>
        neura.store_indexed %10 to %10[%8 : !neura.data<index, i1>] !neura.data<memref<?xi32>, i1> {lhs_value = "%input2"} : !neura.data<memref<?xi32>, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg47, %arg48, %arg49 : memref<?xi32>, memref<?xi32>, memref<?xi32>)
    }
    return
  }
}

