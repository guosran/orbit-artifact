module attributes {amoeba.lu_affine_repair_input_status = "malformed-determinant-carry", amoeba.lu_affine_repair_pass = "repair-lu-affine-determinant-carry-v1", amoeba.lu_affine_repair_reason = "inserted determinant carry load and rewired product", amoeba.lu_affine_repair_source_file = "${ARTIFACT_ROOT}/.work/amoeba-test/Evaluation/LU/lu_func.cpp", amoeba.lu_affine_repair_source_verified = true, amoeba.lu_affine_repair_status = "repaired"} {
  func.func @_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_(%arg0: i32, %arg1: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg2: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg3: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg4: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg5: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg6: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg7: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, %arg8: memref<?x100xi32> {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, %arg9: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 1>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-1", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/lu/shape-temporal-replica-tiling-source-corrected-v1-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/lu/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 8 : i64, amoeba.static_bound.arg.0 = 8 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c8_i32 = arith.constant 8 : i32
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c1024_i32 = arith.constant 1024 : i32
    %c-1_i32 = arith.constant -1 : i32
    %c-1024_i32 = arith.constant -1024 : i32
    %0 = arith.index_cast %c8_i32 : i32 to index
    %done_writes = taskflow.task @Task_0 will_reads(%arg1 : memref<?x100xi32>) will_writes(%arg3 : memref<?x100xi32>) value_inputs(%0 : index) [original_read_memrefs(%arg1 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, index) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg12 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0_8 to %arg12 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg13: !neura.data<memref<?x100xi32>, i1>, %arg14: !neura.data<memref<?x100xi32>, i1>, %arg15: !neura.data<index, i1>):
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %6 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = neura.load_indexed [%6, %7 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %9 = "neura.data_mov"(%8) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %9 to [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %done_writes_0:3 = taskflow.task @Task_1 will_writes(%arg4, %arg5, %arg8 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c0_i32 : index, i32, i32) [original_write_memrefs(%arg4, %arg5, %arg8 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg15, %arg10, %arg11, %arg12, %arg13 : i32, i32, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<memref<?x100xi32>, i1>, %arg21: !neura.data<index, i1>):
        %4 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %5 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<memref<?x100xi32>, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.cast"(%9) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.cast"(%11) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.icmp"(%13, %14) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %16 = "neura.data_mov"(%15) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = "neura.data_mov"(%4) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.data_mov"(%5) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.sel"(%16, %17, %18) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.data_mov"(%19) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %20 to [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %23 = "neura.data_mov"(%6) : (!neura.data<memref<?x100xi32>, i1>) -> !neura.data<memref<?x100xi32>, i1>
        %24 = "neura.data_mov"(%6) : (!neura.data<memref<?x100xi32>, i1>) -> !neura.data<memref<?x100xi32>, i1>
        %25 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %23 to %24[%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>] !neura.data<memref<?x100xi32>, i1> {lhs_value = "%input1"} : !neura.data<memref<?x100xi32>, i1>
        %27 = "neura.data_mov"(%19) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %27 to [%28, %29 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg10, %arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>)
    }
    %done_writes_1 = taskflow.task @Task_2 will_reads(%done_writes : memref<?x100xi32>) will_writes(%done_writes : memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c-1024_i32 : index, i32, i32) [original_read_memrefs(%arg3 : memref<?x100xi32>), original_write_memrefs(%arg3 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: index, %arg13: i32, %arg14: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg12 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg11, %arg13, %arg12, %arg14, %arg12 : memref<?x100xi32>, i32, index, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<?x100xi32>, i1>, %arg16: !neura.data<i32, i1>, %arg17: !neura.data<index, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.data_mov"(%3) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %7 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = "neura.cast"(%7) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %9 = neura.reserve : !neura.data<index, i1>
        %10 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.phi"(%9, %10) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = neura.reserve : !neura.data<i32, i1>
        %13 = "neura.data_mov"(%8) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.phi"(%12, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = neura.reserve : !neura.data<i64, i1>
        %16 = "neura.data_mov"(%5) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %17 = "neura.phi"(%15, %16) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %18 = neura.reserve : !neura.data<i64, i1>
        %19 = "neura.data_mov"(%5) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %20 = "neura.phi"(%18, %19) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %21 = "neura.data_mov"(%20) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %22 = "neura.cast"(%21) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %23 = "neura.data_mov"(%22) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.icmp"(%23) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %25 = "neura.data_mov"(%22) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %27 = neura.grant_predicate %25, %26 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %28 = "neura.data_mov"(%17) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %29 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %30 = neura.grant_predicate %28, %29 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %31 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %33 = neura.grant_predicate %31, %32 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %34 = "neura.data_mov"(%11) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %36 = neura.grant_predicate %34, %35 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %37 = "neura.data_mov"(%27) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.cast"(%37) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %39 = neura.reserve : !neura.data<i64, i1>
        %40 = "neura.data_mov"(%30) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %41 = "neura.phi"(%39, %40) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %42 = neura.reserve : !neura.data<index, i1>
        %43 = "neura.data_mov"(%27) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %44 = "neura.phi"(%42, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %45 = neura.reserve : !neura.data<index, i1>
        %46 = "neura.data_mov"(%36) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.phi"(%45, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = neura.reserve : !neura.data<i32, i1>
        %49 = "neura.data_mov"(%38) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.phi"(%48, %49) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %51 = neura.reserve : !neura.data<i32, i1>
        %52 = "neura.data_mov"(%33) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.phi"(%51, %52) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %54 = neura.reserve : !neura.data<i64, i1>
        %55 = "neura.data_mov"(%30) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %56 = "neura.phi"(%54, %55) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %57 = "neura.data_mov"(%56) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %58 = "neura.cast"(%57) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %59 = "neura.data_mov"(%58) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.icmp"(%59) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %61 = "neura.data_mov"(%58) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %63 = neura.grant_predicate %61, %62 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %64 = "neura.data_mov"(%53) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %65 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %66 = neura.grant_predicate %64, %65 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %67 = "neura.data_mov"(%50) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %68 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %69 = neura.grant_predicate %67, %68 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %70 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %71 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %72 = neura.grant_predicate %70, %71 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %73 = "neura.data_mov"(%44) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %74 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %75 = neura.grant_predicate %73, %74 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %76 = "neura.data_mov"(%41) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %77 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %78 = neura.grant_predicate %76, %77 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %79 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %80 = "neura.not"(%79) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %81 = "neura.data_mov"(%53) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %82 = "neura.data_mov"(%80) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %83 = neura.grant_predicate %81, %82 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %84 = "neura.data_mov"(%50) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.data_mov"(%80) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %86 = neura.grant_predicate %84, %85 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %87 = "neura.data_mov"(%44) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %88 = "neura.data_mov"(%80) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %89 = neura.grant_predicate %87, %88 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %90 = "neura.data_mov"(%47) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %91 = "neura.data_mov"(%80) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %92 = neura.grant_predicate %90, %91 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %93 = "neura.data_mov"(%41) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %94 = "neura.data_mov"(%80) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %95 = neura.grant_predicate %93, %94 : !neura.data<i64, i1>, !neura.data<i1, i1> -> !neura.data<i64, i1>
        %96 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %97 = "neura.cast"(%96) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %98 = "neura.data_mov"(%97) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %99 = "neura.data_mov"(%66) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %100 = "neura.icmp"(%98, %99) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %101 = "neura.data_mov"(%100) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %102 = "neura.cast"(%101) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %103 = "neura.data_mov"(%97) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %104 = "neura.data_mov"(%69) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %105 = "neura.icmp"(%103, %104) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %106 = "neura.data_mov"(%105) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %107 = "neura.cast"(%106) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %108 = "neura.data_mov"(%102) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %109 = "neura.data_mov"(%107) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %110 = "neura.mul"(%108, %109) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %111 = "neura.data_mov"(%72) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %112 = "neura.data_mov"(%75) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %113 = neura.load_indexed [%111, %112 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %114 = "neura.data_mov"(%72) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %115 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %116 = neura.load_indexed [%114, %115 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %117 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = "neura.data_mov"(%75) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = neura.load_indexed [%117, %118 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %120 = "neura.data_mov"(%116) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %121 = "neura.data_mov"(%119) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %122 = "neura.mul"(%120, %121) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %123 = "neura.data_mov"(%122) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %124 = "neura.div"(%123) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %125 = "neura.data_mov"(%110) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %126 = "neura.data_mov"(%124) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %127 = "neura.mul"(%125, %126) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %128 = "neura.data_mov"(%113) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %129 = "neura.data_mov"(%127) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %130 = "neura.sub"(%128, %129) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %131 = "neura.data_mov"(%130) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %132 = "neura.data_mov"(%72) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %133 = "neura.data_mov"(%75) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %131 to [%132, %133 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input0"} : !neura.data<i32, i1>
        %134 = "neura.data_mov"(%63) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %135 = "neura.add"(%134) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %136 = "neura.data_mov"(%135) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %137 = "neura.cast"(%136) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %137 -> %54 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %66 -> %51 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %69 -> %48 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %72 -> %45 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %75 -> %42 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %78 -> %39 : !neura.data<i64, i1> !neura.data<i64, i1>
        %138 = "neura.data_mov"(%83) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %139 = "neura.data_mov"(%86) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %140 = "neura.icmp"(%138, %139) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %141 = "neura.data_mov"(%140) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %142 = "neura.cast"(%141) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %143 = "neura.data_mov"(%89) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %144 = "neura.data_mov"(%89) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %145 = neura.load_indexed [%143, %144 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %146 = "neura.data_mov"(%145) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %147 = "neura.add"(%146) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %148 = "neura.data_mov"(%142) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %149 = "neura.data_mov"(%147) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %150 = "neura.mul"(%148, %149) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %151 = "neura.data_mov"(%150) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %152 = "neura.add"(%151) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %153 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %154 = "neura.data_mov"(%89) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %155 = neura.load_indexed [%153, %154 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %156 = "neura.data_mov"(%155) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %157 = "neura.mul"(%156) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %158 = "neura.data_mov"(%157) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %159 = "neura.data_mov"(%152) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %160 = "neura.div"(%158, %159) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %161 = "neura.data_mov"(%160) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %162 = "neura.data_mov"(%92) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %163 = "neura.data_mov"(%89) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %161 to [%162, %163 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input0"} : !neura.data<i32, i1>
        %164 = "neura.data_mov"(%89) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %165 = "neura.add"(%164) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %166 = "neura.data_mov"(%165) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %167 = "neura.cast"(%166) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %167 -> %18 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %95 -> %15 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %83 -> %12 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %92 -> %9 : !neura.data<index, i1> !neura.data<index, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11 : memref<?x100xi32>)
    }
    %done_writes_2:2 = taskflow.task @Task_3 will_reads(%done_writes_1 : memref<?x100xi32>) will_writes(%done_writes_0#0, %done_writes_0#1 : memref<?x100xi32>, memref<?x100xi32>) value_inputs(%0, %c1_i32, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg3 : memref<?x100xi32>), original_write_memrefs(%arg4, %arg5 : memref<?x100xi32>, memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>, memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg10, %arg15, %arg11, %arg12, %arg13 : i32, memref<?x100xi32>, i32, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<memref<?x100xi32>, i1>, %arg18: !neura.data<i32, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<memref<?x100xi32>, i1>, %arg21: !neura.data<index, i1>):
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %6 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %8 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = "neura.cast"(%8) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %10 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.icmp"(%10, %11) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %13 = "neura.data_mov"(%12) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %14 = "neura.cast"(%13) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.icmp"(%15, %16) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %18 = "neura.data_mov"(%17) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %19 = "neura.cast"(%18) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %20 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.sub"(%20) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = neura.load_indexed [%22, %23 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %25 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.data_mov"(%24) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.mul"(%25, %26) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.data_mov"(%19) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %29 = "neura.mul"(%28) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.data_mov"(%27) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %31 = "neura.data_mov"(%29) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %32 = "neura.add"(%30, %31) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.data_mov"(%32) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %33 to [%34, %35 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %36 = "neura.data_mov"(%21) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.data_mov"(%24) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %38 = "neura.mul"(%36, %37) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %39 = "neura.data_mov"(%38) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %40 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %39 to [%40, %41 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg11, %arg12 : memref<?x100xi32>, memref<?x100xi32>)
    }
    %done_writes_3 = taskflow.task @Task_4 will_reads(%arg2, %arg6, %done_writes_2#0 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>) will_writes(%arg6 : memref<?xi32>) value_inputs(%0, %c1024_i32 : index, i32) [original_read_memrefs(%arg2, %arg6, %arg4 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>), original_write_memrefs(%arg6 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?xi32>, %arg11: memref<?xi32>, %arg12: memref<?x100xi32>, %arg13: memref<?xi32>, %arg14: index, %arg15: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0_8 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg10, %arg13, %arg12, %arg15, %arg14 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<memref<?xi32>, i1>, %arg17: !neura.data<memref<?xi32>, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<i32, i1>, %arg20: !neura.data<index, i1>):
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %6 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = "neura.cast"(%6) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %8 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8 : !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.icmp"(%10) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %12 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %14 = neura.grant_predicate %12, %13 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.data_mov"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %17 = neura.grant_predicate %15, %16 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %18 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = "neura.data_mov"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %20 = neura.grant_predicate %18, %19 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.data_mov"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %21, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %24 = "neura.data_mov"(%11) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %25 = "neura.not"(%24) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %26 = "neura.data_mov"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %26, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %30 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %31 = neura.grant_predicate %29, %30 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %32 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.data_mov"(%25) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = neura.grant_predicate %32, %33 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.data_mov"(%17) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %35 to [%36 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        %37 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.data_mov"(%17) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %39 = "neura.phi"(%37, %38) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %40 = "neura.data_mov"(%31) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %41 = "neura.data_mov"(%23) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %42 = "neura.phi"(%40, %41) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %43 = "neura.data_mov"(%28) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %44 = "neura.data_mov"(%20) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %45 = "neura.phi"(%43, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.cast"(%46) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %48 = "neura.data_mov"(%47) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %49 = "neura.data_mov"(%42) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.icmp"(%48, %49) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %51 = "neura.data_mov"(%50) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %52 = "neura.cast"(%51) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %53 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %54 = neura.load_indexed [%53 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %55 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = neura.load_indexed [%55, %56 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %58 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = neura.load_indexed [%58 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %60 = "neura.data_mov"(%57) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %61 = "neura.data_mov"(%59) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %62 = "neura.mul"(%60, %61) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %63 = "neura.data_mov"(%62) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.div"(%63) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %65 = "neura.data_mov"(%52) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %66 = "neura.data_mov"(%64) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %67 = "neura.mul"(%65, %66) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %68 = "neura.data_mov"(%54) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %69 = "neura.data_mov"(%67) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %70 = "neura.sub"(%68, %69) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %71 = "neura.data_mov"(%70) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %72 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %71 to [%72 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?xi32>)
    }
    %1 = arith.addi %c8_i32, %c-1_i32 : i32
    %done_writes_4 = taskflow.task @Task_5 will_reads(%done_writes_3, %arg7, %done_writes_2#1 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>) will_writes(%arg7 : memref<?xi32>) value_inputs(%0, %1, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg6, %arg7, %arg5 : memref<?xi32>, memref<?xi32>, memref<?x100xi32>), original_write_memrefs(%arg7 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?xi32>, %arg11: memref<?xi32>, %arg12: memref<?x100xi32>, %arg13: memref<?xi32>, %arg14: index, %arg15: i32, %arg16: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg14 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg15, %arg14, %arg10, %arg13, %arg12, %arg16, %arg14 : i32, index, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg17: !neura.data<i32, i1>, %arg18: !neura.data<index, i1>, %arg19: !neura.data<memref<?xi32>, i1>, %arg20: !neura.data<memref<?xi32>, i1>, %arg21: !neura.data<memref<?x100xi32>, i1>, %arg22: !neura.data<i32, i1>, %arg23: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = "neura.data_mov"(%3) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %5 = "neura.cast"(%4) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %6 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input6"} -> !neura.data<index, i1>
        %7 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %8 = "neura.cast"(%7) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %9 = "neura.data_mov"(%8) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.sub"(%9) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %12 = "neura.mul"(%11) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.data_mov"(%12) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.add"(%13) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = "neura.data_mov"(%14) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = "neura.add"(%15) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %17 = "neura.data_mov"(%16) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%17 : !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %19 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.mul"(%19) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.data_mov"(%20) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.add"(%21) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.data_mov"(%22) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.add"(%23) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %25 = "neura.data_mov"(%18) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.grant_once"(%25) {amoeba.source_owned_once_init} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %27 = "neura.data_mov"(%26) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %28 = "neura.data_mov"(%24) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %27 to [%28 : !neura.data<index, i1>]  {amoeba.source_owned_once_init, rhs_value = "%input3"} : !neura.data<i32, i1>
        %29 = neura.reserve : !neura.data<index, i1>
        %30 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %31 = "neura.phi"(%29, %30) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %32 = neura.reserve : !neura.data<i32, i1>
        %33 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %34 = "neura.phi"(%32, %33) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %35 = neura.reserve : !neura.data<i64, i1>
        %36 = "neura.data_mov"(%5) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %37 = "neura.phi"(%35, %36) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %38 = "neura.data_mov"(%37) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %39 = "neura.cast"(%38) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %40 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.icmp"(%40) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %42 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %43 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %44 = neura.grant_predicate %42, %43 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %45 = "neura.data_mov"(%34) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %46 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = neura.grant_predicate %45, %46 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %48 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %49 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %50 = neura.grant_predicate %48, %49 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %51 = "neura.data_mov"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %52 = "neura.not"(%51) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %53 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %54 = "neura.data_mov"(%52) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %55 = neura.grant_predicate %53, %54 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %56 = "neura.data_mov"(%44) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.cast"(%56) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %58 = "neura.data_mov"(%57) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %59 = "neura.data_mov"(%47) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %60 = "neura.icmp"(%58, %59) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %61 = "neura.data_mov"(%60) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %62 = "neura.cast"(%61) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %63 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %64 = "neura.mul"(%63) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %65 = "neura.data_mov"(%64) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %66 = "neura.add"(%65) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %67 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.add"(%67) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.data_mov"(%68) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = neura.load_indexed [%69 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %71 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %72 = "neura.mul"(%71) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %73 = "neura.data_mov"(%72) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %74 = "neura.add"(%73) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %75 = "neura.data_mov"(%74) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %76 = "neura.add"(%75) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %77 = "neura.data_mov"(%76) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = "neura.data_mov"(%44) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %79 = neura.load_indexed [%77, %78 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %80 = "neura.data_mov"(%44) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %81 = neura.load_indexed [%80 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %82 = "neura.data_mov"(%79) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %83 = "neura.data_mov"(%81) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %84 = "neura.mul"(%82, %83) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.data_mov"(%84) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.div"(%85) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.data_mov"(%62) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%86) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.mul"(%87, %88) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.data_mov"(%70) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %91 = "neura.data_mov"(%89) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %92 = "neura.sub"(%90, %91) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %93 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %94 = "neura.mul"(%93) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %95 = "neura.data_mov"(%94) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %96 = "neura.add"(%95) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %97 = "neura.data_mov"(%96) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %98 = "neura.add"(%97) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %99 = "neura.data_mov"(%92) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %100 = "neura.data_mov"(%98) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %99 to [%100 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        %101 = "neura.data_mov"(%44) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %102 = "neura.add"(%101) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %103 = "neura.data_mov"(%102) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %104 = "neura.cast"(%103) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %104 -> %35 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %47 -> %32 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %50 -> %29 : !neura.data<index, i1> !neura.data<index, i1>
        %105 = "neura.data_mov"(%55) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %106 = "neura.mul"(%105) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %107 = "neura.data_mov"(%106) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %108 = "neura.add"(%107) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %109 = "neura.data_mov"(%108) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %110 = "neura.add"(%109) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %111 = "neura.data_mov"(%110) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %112 = neura.load_indexed [%111 : !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %113 = "neura.data_mov"(%112) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %114 = "neura.mul"(%113) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %115 = "neura.data_mov"(%55) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %116 = "neura.mul"(%115) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %117 = "neura.data_mov"(%116) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = "neura.add"(%117) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = "neura.data_mov"(%118) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %120 = "neura.add"(%119) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = "neura.data_mov"(%55) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %122 = "neura.mul"(%121) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %123 = "neura.data_mov"(%122) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %124 = "neura.add"(%123) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %125 = "neura.data_mov"(%124) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %126 = "neura.add"(%125) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %127 = "neura.data_mov"(%120) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %128 = "neura.data_mov"(%126) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %129 = neura.load_indexed [%127, %128 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %130 = "neura.data_mov"(%114) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %131 = "neura.data_mov"(%129) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %132 = "neura.div"(%130, %131) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %133 = "neura.data_mov"(%55) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %134 = "neura.mul"(%133) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %135 = "neura.data_mov"(%134) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %136 = "neura.add"(%135) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %137 = "neura.data_mov"(%136) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.add"(%137) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %139 = "neura.data_mov"(%132) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %140 = "neura.data_mov"(%138) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %139 to [%140 : !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg13 : memref<?xi32>)
    }
    %done_writes_5 = taskflow.task @Task_6 will_reads(%done_writes_0#2, %done_writes_2#0 : memref<?x100xi32>, memref<?x100xi32>) will_writes(%done_writes_0#2 : memref<?x100xi32>) value_inputs(%0, %c1024_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg8, %arg4 : memref<?x100xi32>, memref<?x100xi32>), original_write_memrefs(%arg8 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32} : index
      %4 = taskflow.counter parent(%3 : index) from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32} : index
      neura.kernel inputs(%arg14, %arg15, %arg12, %arg11, %arg13 : i32, i32, memref<?x100xi32>, memref<?x100xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<index, i1>):
        %5 = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i32, i1>
        %6 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %9 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %10 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = "neura.cast"(%10) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %12 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %13 = "neura.cast"(%12) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %14 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%11) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.icmp"(%14, %15) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %17 = "neura.data_mov"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %18 = "neura.data_mov"(%5) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.data_mov"(%6) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.sel"(%17, %18, %19) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.icmp"(%21) <{cmpType = "eq"}> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %23 = "neura.data_mov"(%20) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.data_mov"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %25 = neura.grant_predicate %23, %24 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %26 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = "neura.data_mov"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %26, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %29 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.data_mov"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %31 = neura.grant_predicate %29, %30 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %32 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %33 = "neura.data_mov"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = neura.grant_predicate %32, %33 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %35 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.data_mov"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %35, %36 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %38 = "neura.data_mov"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %39 = "neura.not"(%38) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %40 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %41 = "neura.data_mov"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = neura.grant_predicate %40, %41 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %43 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.data_mov"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = neura.grant_predicate %43, %44 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %46 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.data_mov"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %48 = neura.grant_predicate %46, %47 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %49 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.data_mov"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %51 = neura.grant_predicate %49, %50 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %52 = "neura.data_mov"(%25) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.data_mov"(%28) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %54 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %52 to [%53, %54 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %55 = "neura.data_mov"(%51) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.phi"(%55, %56) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.data_mov"(%28) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%58, %59) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.data_mov"(%45) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %62 = "neura.data_mov"(%37) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %63 = "neura.phi"(%61, %62) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %65 = "neura.data_mov"(%34) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %66 = "neura.phi"(%64, %65) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %67 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.cast"(%67) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %69 = "neura.data_mov"(%68) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %70 = "neura.data_mov"(%63) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %71 = "neura.icmp"(%69, %70) <{cmpType = "slt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %72 = "neura.data_mov"(%71) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %73 = "neura.cast"(%72) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %74 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %75 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %76 = neura.load_indexed [%74, %75 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %77 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %78 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %79 = neura.load_indexed [%77, %78 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %80 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %81 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %82 = neura.load_indexed [%80, %81 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %83 = "neura.data_mov"(%79) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %84 = "neura.data_mov"(%82) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.mul"(%83, %84) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.data_mov"(%85) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.div"(%86) {rhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%73) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %89 = "neura.data_mov"(%87) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %90 = "neura.mul"(%88, %89) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %91 = "neura.data_mov"(%76) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %92 = "neura.data_mov"(%90) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %93 = "neura.sub"(%91, %92) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %94 = "neura.data_mov"(%93) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %95 = "neura.data_mov"(%60) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %96 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %94 to [%95, %96 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?x100xi32>)
    }
    %done_writes_6 = taskflow.task @Task_7 will_reads(%done_writes_5, %done_writes_2#1 : memref<?x100xi32>, memref<?x100xi32>) will_writes(%done_writes_5 : memref<?x100xi32>) value_inputs(%0, %1, %c1024_i32 : index, i32, i32) [original_read_memrefs(%arg8, %arg5 : memref<?x100xi32>, memref<?x100xi32>), original_write_memrefs(%arg8 : memref<?x100xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32) -> (memref<?x100xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?x100xi32>, %arg12: memref<?x100xi32>, %arg13: index, %arg14: i32, %arg15: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %3 = taskflow.counter parent(%2 : index) from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg14, %arg13, %arg12, %arg11, %arg15, %arg13 : i32, index, memref<?x100xi32>, memref<?x100xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg16: !neura.data<i32, i1>, %arg17: !neura.data<index, i1>, %arg18: !neura.data<memref<?x100xi32>, i1>, %arg19: !neura.data<memref<?x100xi32>, i1>, %arg20: !neura.data<i32, i1>, %arg21: !neura.data<index, i1>):
        %4 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %5 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = "neura.cast"(%5) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %7 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %8 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %9 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.cast"(%9) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%10) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.sub"(%11) {lhs_value = "%input0"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = neura.reserve : !neura.data<index, i1>
        %14 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = "neura.phi"(%13, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %16 = neura.reserve : !neura.data<index, i1>
        %17 = "neura.data_mov"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = "neura.phi"(%16, %17) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = neura.reserve : !neura.data<i32, i1>
        %20 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.phi"(%19, %20) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = neura.reserve : !neura.data<i64, i1>
        %23 = "neura.data_mov"(%6) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %24 = "neura.phi"(%22, %23) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %25 = "neura.data_mov"(%24) : (!neura.data<i64, i1>) -> !neura.data<i64, i1>
        %26 = "neura.cast"(%25) <{cast_type = "int_to_index"}> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %27 = "neura.data_mov"(%26) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %28 = "neura.icmp"(%27) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %29 = "neura.data_mov"(%26) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %30 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %31 = neura.grant_predicate %29, %30 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %32 = "neura.data_mov"(%21) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %34 = neura.grant_predicate %32, %33 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %35 = "neura.data_mov"(%18) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %36 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %37 = neura.grant_predicate %35, %36 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %38 = "neura.data_mov"(%15) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %39 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %40 = neura.grant_predicate %38, %39 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %41 = "neura.data_mov"(%28) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = "neura.not"(%41) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %43 = "neura.data_mov"(%18) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %44 = "neura.data_mov"(%42) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = neura.grant_predicate %43, %44 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %46 = "neura.data_mov"(%15) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.data_mov"(%42) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %48 = neura.grant_predicate %46, %47 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %49 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.cast"(%49) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %51 = "neura.data_mov"(%50) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.data_mov"(%34) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %53 = "neura.icmp"(%51, %52) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %54 = "neura.data_mov"(%53) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %55 = "neura.cast"(%54) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        %56 = "neura.data_mov"(%37) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.mul"(%56) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.data_mov"(%57) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.add"(%58) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.data_mov"(%59) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.add"(%60) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %62 = "neura.data_mov"(%61) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %63 = "neura.data_mov"(%40) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %64 = neura.load_indexed [%62, %63 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %65 = "neura.data_mov"(%37) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %66 = "neura.mul"(%65) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %67 = "neura.data_mov"(%66) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %68 = "neura.add"(%67) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %69 = "neura.data_mov"(%68) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %70 = "neura.add"(%69) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %71 = "neura.data_mov"(%70) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %72 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %73 = neura.load_indexed [%71, %72 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %74 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %75 = "neura.data_mov"(%40) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %76 = neura.load_indexed [%74, %75 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %77 = "neura.data_mov"(%73) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %78 = "neura.data_mov"(%76) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %79 = "neura.mul"(%77, %78) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %80 = "neura.data_mov"(%79) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %81 = "neura.div"(%80) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %82 = "neura.data_mov"(%55) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %83 = "neura.data_mov"(%81) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %84 = "neura.mul"(%82, %83) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %85 = "neura.data_mov"(%64) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %86 = "neura.data_mov"(%84) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %87 = "neura.sub"(%85, %86) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %88 = "neura.data_mov"(%37) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %89 = "neura.mul"(%88) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %90 = "neura.data_mov"(%89) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %91 = "neura.add"(%90) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %92 = "neura.data_mov"(%91) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %93 = "neura.add"(%92) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %94 = "neura.data_mov"(%87) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %95 = "neura.data_mov"(%93) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %96 = "neura.data_mov"(%40) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %94 to [%95, %96 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        %97 = "neura.data_mov"(%31) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %98 = "neura.add"(%97) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %99 = "neura.data_mov"(%98) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %100 = "neura.cast"(%99) <{cast_type = "index_to_int"}> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        neura.ctrl_mov %100 -> %22 : !neura.data<i64, i1> !neura.data<i64, i1>
        neura.ctrl_mov %34 -> %19 : !neura.data<i32, i1> !neura.data<i32, i1>
        neura.ctrl_mov %37 -> %16 : !neura.data<index, i1> !neura.data<index, i1>
        neura.ctrl_mov %40 -> %13 : !neura.data<index, i1> !neura.data<index, i1>
        %101 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %102 = "neura.mul"(%101) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %103 = "neura.data_mov"(%102) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %104 = "neura.add"(%103) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %105 = "neura.data_mov"(%104) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %106 = "neura.add"(%105) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %107 = "neura.data_mov"(%106) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %108 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %109 = neura.load_indexed [%107, %108 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %110 = "neura.data_mov"(%109) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %111 = "neura.mul"(%110) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %112 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %113 = "neura.mul"(%112) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %114 = "neura.data_mov"(%113) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %115 = "neura.add"(%114) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %116 = "neura.data_mov"(%115) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %117 = "neura.add"(%116) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %118 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %119 = "neura.mul"(%118) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %120 = "neura.data_mov"(%119) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %121 = "neura.add"(%120) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %122 = "neura.data_mov"(%121) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %123 = "neura.add"(%122) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %124 = "neura.data_mov"(%117) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %125 = "neura.data_mov"(%123) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %126 = neura.load_indexed [%124, %125 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input3"} : !neura.data<i32, i1>
        %127 = "neura.data_mov"(%111) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %128 = "neura.data_mov"(%126) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %129 = "neura.div"(%127, %128) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %130 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %131 = "neura.mul"(%130) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %132 = "neura.data_mov"(%131) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %133 = "neura.add"(%132) {rhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %134 = "neura.data_mov"(%133) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %135 = "neura.add"(%134) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %136 = "neura.data_mov"(%129) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %137 = "neura.data_mov"(%135) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %138 = "neura.data_mov"(%48) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %136 to [%137, %138 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?x100xi32>)
    }
    memref.store %c1024_i32, %arg9[%c0] : memref<?xi32>
    %done_writes_7 = taskflow.task @Task_8 will_reads(%done_writes_2#1, %arg9 : memref<?x100xi32>, memref<?xi32>) will_writes(%arg9 : memref<?xi32>) value_inputs(%0, %c1024_i32 : index, i32) [original_read_memrefs(%arg5, %arg9 : memref<?x100xi32>, memref<?xi32>), original_write_memrefs(%arg9 : memref<?xi32>)] {dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?xi32>, memref<?xi32>, index, i32) -> (memref<?xi32>) {
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?xi32>, %arg12: memref<?xi32>, %arg13: index, %arg14: i32):
      %c0_8 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %2 = taskflow.counter from %c0_8 to %arg13 step %c1 attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32} : index
      neura.kernel inputs(%arg10, %arg12, %arg14, %arg13 : memref<?x100xi32>, memref<?xi32>, i32, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg15: !neura.data<memref<?x100xi32>, i1>, %arg16: !neura.data<memref<?xi32>, i1>, %arg17: !neura.data<i32, i1>, %arg18: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = 0 : index}> : () -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %5 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.data_mov"(%3) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8 : !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %10 = "neura.data_mov"(%9) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.mul"(%10, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.div"(%13) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %15 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.data_mov"(%3) : (!neura.data<index, i1>) -> !neura.data<index, i1>
        neura.store_indexed %15 to [%16 : !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg12 : memref<?xi32>)
    }
    return
  }
}

