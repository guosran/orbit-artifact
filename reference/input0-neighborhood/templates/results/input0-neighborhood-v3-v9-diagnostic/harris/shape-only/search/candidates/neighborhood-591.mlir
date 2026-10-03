module {
  func.func @_Z11harris_funciPA128_KiS1_S1_PA128_iS3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_(%arg0: i32, %arg1: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg2: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg3: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg4: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg5: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg6: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg7: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg8: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg9: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg10: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg11: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg12: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg13: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg14: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg15: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg16: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg17: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg18: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg19: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg20: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg21: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg22: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg23: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg24: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg25: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg26: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, %arg27: memref<?x128xi32> {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-0", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/harris/shape-temporal-replica-mainline-v6-rank-3/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/harris/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 63 : i64, amoeba.static_bound.arg.0 = 63 : i64, llvm.linkage = #llvm.linkage<external>} {
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
      %0 = taskflow.counter from %c0 to %arg32 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c128 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg33, %arg29, %arg34, %arg30, %arg35, %arg31, %arg32 : memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<i32, i1>, %arg40: !neura.data<memref<?x128xi32>, i1>, %arg41: !neura.data<i32, i1>, %arg42: !neura.data<memref<?x128xi32>, i1>, %arg43: !neura.data<index, i1>):
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input7"} -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %4 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %5 = "neura.mul"(%4) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %6 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %7 = "neura.mul"(%6) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.add"(%5, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input4"} : !neura.data<i32, i1>
        %10 = "neura.mul"(%9) {rhs_value = "%input5"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input6"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %done_writes_0 = taskflow.task @Task_1 will_reads(%done_writes : memref<?x128xi32>) will_writes(%arg5 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %false, %c25500_i32 : index, i32, i1, i32) [original_read_memrefs(%arg4 : memref<?x128xi32>), original_write_memrefs(%arg5 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i1, %arg33: i32):
      %c128 = arith.constant 128 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg30 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c128 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg33, %arg29, %arg30 : memref<?x128xi32>, i32, i1, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<i1, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %2 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
        %4 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
        %5 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %6 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.icmp"(%7) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %9 = "neura.sel"(%8, %2, %7) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = neura.grant_predicate %3, %8 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
        %11 = neura.grant_predicate %4, %8 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %12 = neura.grant_predicate %9, %8 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %13 = neura.grant_predicate %5, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %14 = neura.grant_predicate %6, %8 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = "neura.not"(%8) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %16 = neura.grant_predicate %7, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %17 = neura.grant_predicate %4, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %18 = neura.grant_predicate %9, %15 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %19 = neura.grant_predicate %5, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %20 = neura.grant_predicate %6, %15 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %21 = "neura.icmp"(%16) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %22 = "neura.phi"(%14, %20) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = "neura.phi"(%13, %19) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %24 = "neura.phi"(%12, %18) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.phi"(%11, %17) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %26 = "neura.phi"(%10, %21) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
        %27 = "neura.sel"(%26, %25, %24) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %27 to [%23, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_1 = taskflow.task @Task_2 will_reads(%done_writes_0 : memref<?x128xi32>) will_writes(%arg6 : memref<?x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg5 : memref<?x128xi32>), original_write_memrefs(%arg6 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %0 = taskflow.counter from %c0 to %arg30 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %1 = taskflow.counter parent(%0 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %arg30 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %2 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %3 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %4 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %5 = neura.load_indexed [%2, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = "neura.mul"(%6) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.add"(%5, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%2, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%2, %3 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_2 = taskflow.task @Task_3 will_reads(%done_writes_1 : memref<?x128xi32>) will_writes(%arg7 : memref<?x128xi32>) value_inputs(%c63, %c2_i32 : index, i32) [original_read_memrefs(%arg6 : memref<?x128xi32>), original_write_memrefs(%arg7 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %0 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.mul"(%7) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%6, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%10, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.add"(%9, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %12 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_3 = taskflow.task @Task_4 will_reads(%done_writes_2 : memref<?x128xi32>) will_writes(%arg8 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg8 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %0 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.sub"(%7) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %11 = neura.load_indexed [%9, %10 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %12 = "neura.add"(%8, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = neura.load_indexed [%3, %13 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %15 = "neura.mul"(%14) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %16 = "neura.sub"(%12, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = neura.load_indexed [%3, %17 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %19 = "neura.mul"(%18) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %20 = "neura.add"(%16, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %23 = neura.load_indexed [%21, %22 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %24 = "neura.sub"(%20, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = neura.load_indexed [%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %28 = "neura.add"(%24, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_4 = taskflow.task @Task_5 will_reads(%done_writes_2 : memref<?x128xi32>) will_writes(%arg9 : memref<?x128xi32>) value_inputs(%c63, %c0_i32, %c2_i32 : index, i32, i32) [original_read_memrefs(%arg7 : memref<?x128xi32>), original_write_memrefs(%arg9 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %0 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %7 = neura.load_indexed [%5, %6 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.sub"(%7) {lhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.mul"(%10) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.sub"(%8, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %14 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %15 = neura.load_indexed [%13, %14 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %16 = "neura.sub"(%12, %15) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %17 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %18 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = neura.load_indexed [%17, %18 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %20 = "neura.add"(%16, %19) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %22 = neura.load_indexed [%21, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %23 = "neura.mul"(%22) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %24 = "neura.add"(%20, %23) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %25 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %26 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %27 = neura.load_indexed [%25, %26 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %28 = "neura.add"(%24, %27) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %28 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_5 = taskflow.task @Task_6 will_reads(%done_writes_3, %done_writes_4 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg10 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg10 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg31, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg32, %arg30, %0 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.icmp"(%5) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %8 = neura.grant_predicate %5, %7 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %9 = neura.grant_predicate %6, %7 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %10 = neura.grant_predicate %3, %7 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %11 = neura.grant_predicate %4, %7 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %12 = "neura.not"(%7) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %5, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %14 = neura.grant_predicate %6, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %15 = neura.grant_predicate %3, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.grant_predicate %4, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %17 = "neura.sub"(%8) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %18 = "neura.phi"(%11, %16) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %19 = "neura.phi"(%10, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%9, %14) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %21 = "neura.phi"(%17, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %22 = "neura.icmp"(%20) <{cmpType = "slt"}> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %23 = neura.grant_predicate %20, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %24 = neura.grant_predicate %21, %22 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %25 = neura.grant_predicate %19, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %26 = neura.grant_predicate %18, %22 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %27 = "neura.not"(%22) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %28 = neura.grant_predicate %20, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %29 = neura.grant_predicate %21, %27 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %30 = neura.grant_predicate %19, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %31 = neura.grant_predicate %18, %27 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %32 = "neura.sub"(%23) {lhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %33 = "neura.phi"(%26, %31) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %34 = "neura.phi"(%25, %30) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %35 = "neura.phi"(%24, %29) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %36 = "neura.phi"(%32, %28) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.add"(%35, %36) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %37 to [%34, %33 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_6 = taskflow.task @Task_7 will_reads(%done_writes_3 : memref<?x128xi32>) will_writes(%arg11 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8 : memref<?x128xi32>), original_write_memrefs(%arg11 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.mul"(%5, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %6 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_7 = taskflow.task @Task_8 will_reads(%done_writes_4 : memref<?x128xi32>) will_writes(%arg12 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg9 : memref<?x128xi32>), original_write_memrefs(%arg12 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.mul"(%5, %5) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %6 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_8 = taskflow.task @Task_9 will_reads(%done_writes_3, %done_writes_4 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg13 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg8, %arg9 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg13 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg31, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %0 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.mul"(%5, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %7 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_9 = taskflow.task @Task_10 will_reads(%done_writes_6 : memref<?x128xi32>) will_writes(%arg14 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg11 : memref<?x128xi32>), original_write_memrefs(%arg14 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%3, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%3, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_10 = taskflow.task @Task_11 will_reads(%done_writes_7 : memref<?x128xi32>) will_writes(%arg15 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg12 : memref<?x128xi32>), original_write_memrefs(%arg15 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%3, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%3, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_11 = taskflow.task @Task_12 will_reads(%done_writes_8 : memref<?x128xi32>) will_writes(%arg16 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg13 : memref<?x128xi32>), original_write_memrefs(%arg16 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%3, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%3, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_12 = taskflow.task @Task_13 will_reads(%done_writes_9 : memref<?x128xi32>) will_writes(%arg17 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg14 : memref<?x128xi32>), original_write_memrefs(%arg17 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_13 = taskflow.task @Task_14 will_reads(%done_writes_10 : memref<?x128xi32>) will_writes(%arg18 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg15 : memref<?x128xi32>), original_write_memrefs(%arg18 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_14 = taskflow.task @Task_15 will_reads(%done_writes_11 : memref<?x128xi32>) will_writes(%arg19 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg16 : memref<?x128xi32>), original_write_memrefs(%arg19 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%6, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %9 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %10 = neura.load_indexed [%9, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %11 = "neura.add"(%8, %10) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %11 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_15 = taskflow.task @Task_16 will_reads(%done_writes_12, %done_writes_13, %done_writes_14 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg20 : memref<?x128xi32>) value_inputs(%c63, %c25_i32 : index, i32) [original_read_memrefs(%arg17, %arg18, %arg19 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg20 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: memref<?x128xi32>, %arg32: index, %arg33: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg32, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg30, %arg33, %arg31, %0 : memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<i32, i1>, %arg38: !neura.data<memref<?x128xi32>, i1>, %arg39: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input5"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.mul"(%5, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %9 = "neura.mul"(%8, %8) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %10 = "neura.sub"(%7, %9) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %11 = "neura.add"(%5, %6) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.mul"(%11, %11) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %13 = "neura.div"(%12) {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %14 = "neura.sub"(%10, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %14 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input4"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg31 : memref<?x128xi32>)
    }
    %done_writes_16 = taskflow.task @Task_17 will_reads(%done_writes_15 : memref<?x128xi32>) will_writes(%arg21 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg20 : memref<?x128xi32>), original_write_memrefs(%arg21 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %0 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %6 = neura.load_indexed [%4, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = "neura.icmp"(%6) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %8 = "neura.sel"(%7, %6, %3) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%4, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_17 = taskflow.task @Task_18 will_reads(%done_writes_16 : memref<?x128xi32>) will_writes(%arg22 : memref<?x128xi32>) value_inputs(%c63, %c4096_i32, %c0_i32 : index, i32, i32) [original_read_memrefs(%arg21 : memref<?x128xi32>), original_write_memrefs(%arg22 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg32, %arg29, %0 : memref<?x128xi32>, i32, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %6 = neura.load_indexed [%4, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = "neura.icmp"(%6) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %8 = "neura.sel"(%7, %6, %3) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%4, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_18 = taskflow.task @Task_19 will_reads(%done_writes_17 : memref<?x128xi32>) will_writes(%arg23 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg22 : memref<?x128xi32>), original_write_memrefs(%arg23 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%4) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%3, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%4) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%3, %8 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%7, %6) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %7, %6) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.icmp"(%9, %11) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %13 = "neura.sel"(%12, %9, %11) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_19 = taskflow.task @Task_20 will_reads(%done_writes_18 : memref<?x128xi32>) will_writes(%arg24 : memref<?x128xi32>) value_inputs(%c63 : index) [original_read_memrefs(%arg23 : memref<?x128xi32>), original_write_memrefs(%arg24 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %0 : memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg31: !neura.data<memref<?x128xi32>, i1>, %arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input2"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = "neura.add"(%3) {rhs_value = -1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %6 = neura.load_indexed [%5, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %8 = "neura.add"(%3) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %9 = neura.load_indexed [%8, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %10 = "neura.icmp"(%7, %6) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %11 = "neura.sel"(%10, %7, %6) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %12 = "neura.icmp"(%9, %11) <{cmpType = "sgt"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %13 = "neura.sel"(%12, %9, %11) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %13 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input1"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    %done_writes_20 = taskflow.task @Task_21 will_reads(%done_writes_17, %done_writes_19 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg25 : memref<?x128xi32>) value_inputs(%c63, %c0_i32 : index, i32) [original_read_memrefs(%arg22, %arg24 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg25 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg31, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg32, %arg29, %arg30, %0 : memref<?x128xi32>, i32, memref<?x128xi32>, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<i32, i1>, %arg35: !neura.data<memref<?x128xi32>, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %3 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
        %4 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %5 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %6 = neura.load_indexed [%4, %5 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %7 = "neura.icmp"(%6) <{cmpType = "ne"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %8 = neura.grant_predicate %4, %7 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %9 = neura.grant_predicate %5, %7 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %10 = neura.grant_predicate %6, %7 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %11 = neura.grant_predicate %3, %7 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %12 = "neura.not"(%7) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %13 = neura.grant_predicate %3, %12 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
        %14 = neura.grant_predicate %4, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %15 = neura.grant_predicate %5, %12 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
        %16 = neura.load_indexed [%8, %9 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input2"} : !neura.data<i32, i1>
        %17 = "neura.icmp"(%10, %16) <{cmpType = "eq"}> : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i1, i1>
        %18 = "neura.sel"(%17, %10, %11) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %19 = "neura.phi"(%9, %15) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %20 = "neura.phi"(%8, %14) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %21 = "neura.phi"(%18, %13) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %21 to [%20, %19 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_21 = taskflow.task @Task_22 will_reads(%done_writes_20, %done_writes_5 : memref<?x128xi32>, memref<?x128xi32>) will_writes(%arg26 : memref<?x128xi32>) value_inputs(%c63, %c16_i32 : index, i32) [original_read_memrefs(%arg25, %arg10 : memref<?x128xi32>, memref<?x128xi32>), original_write_memrefs(%arg26 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: memref<?x128xi32>, %arg31: index, %arg32: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg31, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg29, %arg32, %arg30, %0 : memref<?x128xi32>, memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg33: !neura.data<memref<?x128xi32>, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<i32, i1>, %arg36: !neura.data<memref<?x128xi32>, i1>, %arg37: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input4"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input1"} : !neura.data<i32, i1>
        %7 = "neura.div"(%6) {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %8 = "neura.add"(%5, %7) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %8 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input3"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg30 : memref<?x128xi32>)
    }
    %done_writes_22 = taskflow.task @Task_23 will_reads(%done_writes_21 : memref<?x128xi32>) will_writes(%arg27 : memref<?x128xi32>) value_inputs(%c63, %c4096_i32 : index, i32) [original_read_memrefs(%arg26 : memref<?x128xi32>), original_write_memrefs(%arg27 : memref<?x128xi32>)] : (memref<?x128xi32>, memref<?x128xi32>, index, i32) -> (memref<?x128xi32>) {
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %c127 = arith.constant 127 : index
      %c1 = arith.constant 1 : index
      %c-1 = arith.constant -1 : index
      %0 = arith.addi %arg30, %c-1 : index
      %1 = taskflow.counter from %c1 to %0 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32} : index
      %2 = taskflow.counter parent(%1 : index) from %c1 to %c127 step %c1 attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32} : index
      neura.kernel inputs(%arg28, %arg31, %arg29, %0 : memref<?x128xi32>, i32, memref<?x128xi32>, index) attributes {accelerator = "neura", dataflow_mode = "predicate"} {
      ^bb0(%arg32: !neura.data<memref<?x128xi32>, i1>, %arg33: !neura.data<i32, i1>, %arg34: !neura.data<memref<?x128xi32>, i1>, %arg35: !neura.data<index, i1>):
        %3 = neura.counter attributes {counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = "%input3"} -> !neura.data<index, i1>
        %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 1 : index, step_value = 1 : index, upper_bound_value = 127 : index} -> !neura.data<index, i1>
        %5 = neura.load_indexed [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%input0"} : !neura.data<i32, i1>
        %6 = "neura.icmp"(%5) <{cmpType = "sgt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %7 = "neura.cast"(%6) <{cast_type = "extui"}> : (!neura.data<i1, i1>) -> !neura.data<i32, i1>
        neura.store_indexed %7 to [%3, %4 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%input2"} : !neura.data<i32, i1>
        neura.yield {yield_type = "void"}
      }
      taskflow.yield done_writes(%arg29 : memref<?x128xi32>)
    }
    return
  }
}

