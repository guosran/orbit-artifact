module {
  func.func @_Z8gcn_funciPA256_KiS1_S1_S1_PA16_S_S3_S3_S3_PA256_iPA256_S4_PA256_A16_iSA_SA_Pi(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, %arg5: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 256, 16>, amoeba.noalias}, %arg6: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 16, 16>, amoeba.noalias}, %arg7: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 16, 16>, amoeba.noalias}, %arg8: memref<?x16xi32> {amoeba.logical_transfer_shape = array<i64: 16, 16>, amoeba.noalias}, %arg9: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 4, 256>, amoeba.noalias}, %arg10: memref<?x256x256xi32> {amoeba.logical_transfer_shape = array<i64: 4, 256, 256>, amoeba.noalias}, %arg11: memref<?x256x16xi32> {amoeba.logical_transfer_shape = array<i64: 3, 256, 16>, amoeba.noalias}, %arg12: memref<?x256x16xi32> {amoeba.logical_transfer_shape = array<i64: 12, 256, 16>, amoeba.noalias}, %arg13: memref<?x256x16xi32> {amoeba.logical_transfer_shape = array<i64: 3, 256, 16>, amoeba.noalias}, %arg14: memref<?xi32> {amoeba.logical_transfer_shape = array<i64: 16>, amoeba.noalias}) attributes {amoeba.graph_variant_id = "graph-1", amoeba.input0_caller_evidence_path = "${ARTIFACT_ROOT}/results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates/gcn/shape-temporal-rank-1/host.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "${ARTIFACT_ROOT}/.work/input0-source-owned-once-mainline-v1/prepared/gcn/shaped-specialized-before-noalias.mlir", amoeba.input0_caller_static_bound = 5 : i64, amoeba.replica.count = 2 : i64, amoeba.replica.materialized_task = "Task_27", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_trip_count = 8 : i64, amoeba.replica.total_trip_count = 16 : i64, amoeba.static_bound.arg.0 = 5 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c5_i32 = arith.constant 5 : i32
    %c1024_i32 = arith.constant 1024 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c5 = arith.constant 5 : index
    %0 = "taskflow.task"(%arg1, %arg9, %arg9, %c5, %c1_i32, %arg1, %arg9, %arg9) <"Task_0"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg19, %arg17, %arg15, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %32 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256xi32>, i1>
        %33 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %36 = "neura.icmp"(%35) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %37 = "neura.grant_predicate"(%32, %36) : (!neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256xi32>, i1>
        %38 = "neura.grant_predicate"(%33, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %39 = "neura.grant_predicate"(%34, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %40 = "neura.grant_predicate"(%35, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.not"(%36) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = "neura.grant_predicate"(%34, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%35, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%33, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%37, %37, %38, %39) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256xi32>, i1>, !neura.data<memref<?x256xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %45 = "neura.phi"(%44, %38) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.phi"(%43, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.phi"(%42, %39) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = "neura.load_indexed"(%47, %46) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %49 = "neura.load_indexed"(%45, %47) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %50 = "neura.add"(%49, %48) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%50, %45, %47) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256xi32>, memref<?x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %1 = "taskflow.task"(%arg2, %0, %0, %c5, %c1_i32, %arg2, %arg9, %arg9) <"Task_1"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg19, %arg17, %arg15, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %32 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256xi32>, i1>
        %33 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %36 = "neura.icmp"(%35) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %37 = "neura.grant_predicate"(%32, %36) : (!neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256xi32>, i1>
        %38 = "neura.grant_predicate"(%33, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %39 = "neura.grant_predicate"(%34, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %40 = "neura.grant_predicate"(%35, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.not"(%36) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = "neura.grant_predicate"(%34, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%35, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%33, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%37, %37, %38, %39) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256xi32>, i1>, !neura.data<memref<?x256xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %45 = "neura.phi"(%44, %38) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.phi"(%43, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.phi"(%42, %39) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = "neura.load_indexed"(%47, %46) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %49 = "neura.load_indexed"(%45, %47) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %50 = "neura.add"(%49, %48) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%50, %45, %47) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256xi32>, memref<?x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %2 = "taskflow.task"(%arg3, %1, %1, %c5, %c1_i32, %arg3, %arg9, %arg9) <"Task_2"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg19, %arg17, %arg15, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %32 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256xi32>, i1>
        %33 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %36 = "neura.icmp"(%35) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %37 = "neura.grant_predicate"(%32, %36) : (!neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256xi32>, i1>
        %38 = "neura.grant_predicate"(%33, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %39 = "neura.grant_predicate"(%34, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %40 = "neura.grant_predicate"(%35, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.not"(%36) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = "neura.grant_predicate"(%34, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%35, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%33, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%37, %37, %38, %39) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256xi32>, i1>, !neura.data<memref<?x256xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %45 = "neura.phi"(%44, %38) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.phi"(%43, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.phi"(%42, %39) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = "neura.load_indexed"(%47, %46) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %49 = "neura.load_indexed"(%45, %47) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %50 = "neura.add"(%49, %48) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%50, %45, %47) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256xi32>, memref<?x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %3 = "taskflow.task"(%arg4, %2, %2, %c5, %c1_i32, %arg4, %arg9, %arg9) <"Task_3"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg19, %arg17, %arg15, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<i32, i1>, %arg21: !neura.data<memref<?x256xi32>, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<index, i1>):
        %32 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256xi32>, i1>
        %33 = "neura.constant"() <3 : index> : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input3"} : () -> !neura.data<index, i1>
        %36 = "neura.icmp"(%35) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %37 = "neura.grant_predicate"(%32, %36) : (!neura.data<memref<?x256xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256xi32>, i1>
        %38 = "neura.grant_predicate"(%33, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %39 = "neura.grant_predicate"(%34, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %40 = "neura.grant_predicate"(%35, %36) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.not"(%36) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %42 = "neura.grant_predicate"(%34, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%35, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%33, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%37, %37, %38, %39) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256xi32>, i1>, !neura.data<memref<?x256xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %45 = "neura.phi"(%44, %38) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %46 = "neura.phi"(%43, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %47 = "neura.phi"(%42, %39) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %48 = "neura.load_indexed"(%47, %46) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %49 = "neura.load_indexed"(%45, %47) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %50 = "neura.add"(%49, %48) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%50, %45, %47) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256xi32>, memref<?x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %4 = "taskflow.task"(%arg1, %3, %arg10, %c5, %c1024_i32, %arg1, %arg9, %arg10) <"Task_4"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg15, %arg19, %arg16, %arg17, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %32 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %33 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %35 = "neura.load_indexed"(%33, %34) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %36 = "neura.mul"(%35) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.load_indexed"(%32, %33) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %38 = "neura.div"(%36, %37) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%38, %32, %33, %34) <"root"> {rhs_value = "%input3"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %5 = "taskflow.task"(%arg2, %3, %4, %c5, %c1024_i32, %arg2, %arg9, %arg10) <"Task_5"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg15, %arg19, %arg16, %arg17, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %32 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %33 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %35 = "neura.load_indexed"(%33, %34) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %36 = "neura.mul"(%35) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.load_indexed"(%32, %33) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %38 = "neura.div"(%36, %37) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%38, %32, %33, %34) <"root"> {rhs_value = "%input3"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %6 = "taskflow.task"(%arg3, %3, %5, %c5, %c1024_i32, %arg3, %arg9, %arg10) <"Task_6"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg15, %arg19, %arg16, %arg17, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %32 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %33 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %35 = "neura.load_indexed"(%33, %34) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %36 = "neura.mul"(%35) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.load_indexed"(%32, %33) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %38 = "neura.div"(%36, %37) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%38, %32, %33, %34) <"root"> {rhs_value = "%input3"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %7 = "taskflow.task"(%arg4, %3, %6, %c5, %c1024_i32, %arg4, %arg9, %arg10) <"Task_7"> ({
    ^bb0(%arg15: memref<?x256xi32>, %arg16: memref<?x256xi32>, %arg17: memref<?x256x256xi32>, %arg18: index, %arg19: i32):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %arg18, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg15, %arg19, %arg16, %arg17, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<memref<?x256xi32>, i1>, %arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<index, i1>):
        %32 = "neura.constant"() <3 : index> : () -> !neura.data<index, i1>
        %33 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %34 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %35 = "neura.load_indexed"(%33, %34) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %36 = "neura.mul"(%35) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        %37 = "neura.load_indexed"(%32, %33) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %38 = "neura.div"(%36, %37) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%38, %32, %33, %34) <"root"> {rhs_value = "%input3"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?x256xi32>, i32, memref<?x256xi32>, memref<?x256x256xi32>, index) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?x256x256xi32>) -> ()
    }) : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %8 = "taskflow.task"(%arg5, %arg6, %arg11, %arg11, %c5, %c0_i32, %arg5, %arg6, %arg11, %arg11) <"Task_8"> ({
    ^bb0(%arg15: memref<?x16xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x16xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %38 = "neura.icmp"(%37) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %39 = "neura.grant_predicate"(%33, %38) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %40 = "neura.grant_predicate"(%34, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.grant_predicate"(%35, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.not"(%38) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = "neura.grant_predicate"(%35, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%37, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%36, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%34, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%39, %39, %40, %41, %42) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %49 = "neura.phi"(%48, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.phi"(%47, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%46, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.phi"(%45, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.load_indexed"(%52, %51) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %54 = "neura.load_indexed"(%51, %50) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %55 = "neura.mul"(%53, %54) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.load_indexed"(%49, %52, %50) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %57 = "neura.add"(%56, %55) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%57, %49, %52, %50) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x16xi32>, memref<?x16xi32>, index) -> ()
      "taskflow.yield"(%arg18) <"leaf"> : (memref<?x256x16xi32>) -> ()
    }) : (memref<?x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %9 = "taskflow.task"(%7, %arg5, %arg12, %arg12, %c5, %c0_i32, %arg10, %arg5, %arg12, %arg12) <"Task_9"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.icmp"(%37) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %39 = "neura.grant_predicate"(%33, %38) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %40 = "neura.grant_predicate"(%34, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.grant_predicate"(%35, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.not"(%38) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = "neura.grant_predicate"(%34, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%35, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%37, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%39, %39, %40, %41, %42) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %49 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.phi"(%47, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%46, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.phi"(%45, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.load_indexed"(%52, %51, %50) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %54 = "neura.load_indexed"(%50, %49) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %55 = "neura.mul"(%53, %54) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.load_indexed"(%52, %51, %49) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %57 = "neura.add"(%56, %55) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%57, %52, %51, %49) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) -> ()
      "taskflow.yield"(%arg18) <"leaf"> : (memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %10 = "taskflow.task"(%7, %arg5, %9, %9, %c5, %c0_i32, %arg10, %arg5, %arg12, %arg12) <"Task_10"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.icmp"(%37) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %39 = "neura.grant_predicate"(%33, %38) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %40 = "neura.grant_predicate"(%34, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.grant_predicate"(%35, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.not"(%38) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = "neura.grant_predicate"(%34, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%35, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%37, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%39, %39, %40, %41, %42) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %49 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.phi"(%47, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%46, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.phi"(%45, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.load_indexed"(%52, %51, %50) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %54 = "neura.load_indexed"(%50, %49) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %55 = "neura.mul"(%53, %54) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.load_indexed"(%52, %51, %49) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %57 = "neura.add"(%56, %55) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%57, %52, %51, %49) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) -> ()
      "taskflow.yield"(%arg18) <"leaf"> : (memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %11 = "taskflow.task"(%7, %arg5, %10, %10, %c5, %c0_i32, %arg10, %arg5, %arg12, %arg12) <"Task_11"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.icmp"(%37) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %39 = "neura.grant_predicate"(%33, %38) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %40 = "neura.grant_predicate"(%34, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.grant_predicate"(%35, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.not"(%38) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = "neura.grant_predicate"(%34, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%35, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%37, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%39, %39, %40, %41, %42) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %49 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.phi"(%47, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%46, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.phi"(%45, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.load_indexed"(%52, %51, %50) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %54 = "neura.load_indexed"(%50, %49) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %55 = "neura.mul"(%53, %54) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.load_indexed"(%52, %51, %49) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %57 = "neura.add"(%56, %55) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%57, %52, %51, %49) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) -> ()
      "taskflow.yield"(%arg18) <"leaf"> : (memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %12 = "taskflow.task"(%7, %arg5, %11, %11, %c5, %c0_i32, %arg10, %arg5, %arg12, %arg12) <"Task_12"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <3 : index> : () -> !neura.data<index, i1>
        %35 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.icmp"(%37) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %39 = "neura.grant_predicate"(%33, %38) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %40 = "neura.grant_predicate"(%34, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %41 = "neura.grant_predicate"(%35, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %38) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.not"(%38) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %45 = "neura.grant_predicate"(%34, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%35, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%37, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%39, %39, %40, %41, %42) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %49 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %50 = "neura.phi"(%47, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %51 = "neura.phi"(%46, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %52 = "neura.phi"(%45, %40) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.load_indexed"(%52, %51, %50) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %54 = "neura.load_indexed"(%50, %49) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %55 = "neura.mul"(%53, %54) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %56 = "neura.load_indexed"(%52, %51, %49) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %57 = "neura.add"(%56, %55) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%57, %52, %51, %49) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x16xi32>, index) -> ()
      "taskflow.yield"(%arg18) <"leaf"> : (memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %13:3 = "taskflow.task"(%8, %12, %arg13, %c5, %c0_i32, %arg11, %arg12, %arg13) <"Task_13"> ({
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: index, %arg19: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg18, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg15, %arg16, %arg19, %arg17, %arg18) <"amoeba.noalias"> ({
      ^bb0(%arg20: !neura.data<memref<?x256x16xi32>, i1>, %arg21: !neura.data<memref<?x256x16xi32>, i1>, %arg22: !neura.data<i32, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<index, i1>):
        %32 = "neura.constant"() <"%input2"> : () -> !neura.data<i32, i1>
        %33 = "neura.constant"() <3 : index> : () -> !neura.data<index, i1>
        %34 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.load_indexed"(%35, %37, %38) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %40 = "neura.load_indexed"(%35, %37, %38) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %41 = "neura.add"(%39, %40) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %42 = "neura.load_indexed"(%36, %37, %38) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %43 = "neura.add"(%41, %42) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.load_indexed"(%34, %37, %38) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %45 = "neura.add"(%43, %44) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %46 = "neura.load_indexed"(%33, %37, %38) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %47 = "neura.add"(%45, %46) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %48 = "neura.icmp"(%47) <"sgt"> {rhs_value = "%input2"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %49 = "neura.sel"(%48, %47, %32) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%49, %35, %37, %38) <"root"> {rhs_value = "%input3"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?x256x16xi32>, memref<?x256x16xi32>, i32, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg15, %arg16, %arg17) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>)
    %14:2 = "taskflow.task"(%13#2, %arg7, %8, %13#0, %c5, %c0_i32, %arg13, %arg7, %arg11, %arg11) <"Task_14"> ({
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.icmp"(%38) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %40 = "neura.grant_predicate"(%33, %39) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %41 = "neura.grant_predicate"(%35, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%34, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%38, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = "neura.grant_predicate"(%34, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %49 = "neura.grant_predicate"(%38, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%35, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%40, %40, %41, %42, %43) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %52 = "neura.phi"(%51, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %54 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %55 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%47, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.load_indexed"(%56, %55, %54) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %58 = "neura.load_indexed"(%54, %53) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %59 = "neura.mul"(%57, %58) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %60 = "neura.load_indexed"(%52, %55, %53) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %61 = "neura.add"(%60, %59) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%61, %52, %55, %53) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x16xi32>, index) -> ()
      "taskflow.yield"(%arg15, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %15:2 = "taskflow.task"(%7, %13#2, %12, %13#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_15"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <4 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %39 = "neura.icmp"(%38) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %40 = "neura.grant_predicate"(%33, %39) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %41 = "neura.grant_predicate"(%34, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%35, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%38, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = "neura.grant_predicate"(%35, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %49 = "neura.grant_predicate"(%38, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%34, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%40, %40, %41, %42, %43) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %52 = "neura.phi"(%51, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %54 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %55 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%47, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.load_indexed"(%56, %55, %54) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %58 = "neura.load_indexed"(%56, %54, %53) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %59 = "neura.mul"(%57, %58) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %60 = "neura.load_indexed"(%52, %55, %53) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %61 = "neura.add"(%60, %59) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%61, %52, %55, %53) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %16:2 = "taskflow.task"(%7, %13#2, %15#1, %15#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_16"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <5 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.icmp"(%39) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %41 = "neura.grant_predicate"(%33, %40) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %42 = "neura.grant_predicate"(%34, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%38, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%36, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%39, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%35, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.not"(%40) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %49 = "neura.grant_predicate"(%36, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%39, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %52 = "neura.grant_predicate"(%35, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %53 = "neura.grant_predicate"(%38, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %54 = "neura.grant_predicate"(%34, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%41, %41, %42, %43, %44) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %55 = "neura.phi"(%54, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%53, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.phi"(%52, %47) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.phi"(%51, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.load_indexed"(%60, %59, %58) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %62 = "neura.load_indexed"(%57, %58, %56) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %63 = "neura.mul"(%61, %62) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.load_indexed"(%55, %59, %56) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %65 = "neura.add"(%64, %63) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%65, %55, %59, %56) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %17:2 = "taskflow.task"(%7, %13#2, %16#1, %16#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_17"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <6 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.icmp"(%39) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %41 = "neura.grant_predicate"(%33, %40) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %42 = "neura.grant_predicate"(%34, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%38, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%35, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%39, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%36, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.not"(%40) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %49 = "neura.grant_predicate"(%35, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%39, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %52 = "neura.grant_predicate"(%36, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %53 = "neura.grant_predicate"(%38, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %54 = "neura.grant_predicate"(%34, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%41, %41, %42, %43, %44) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %55 = "neura.phi"(%54, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%53, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.phi"(%52, %47) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.phi"(%51, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.load_indexed"(%60, %59, %58) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %62 = "neura.load_indexed"(%57, %58, %56) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %63 = "neura.mul"(%61, %62) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.load_indexed"(%55, %59, %56) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %65 = "neura.add"(%64, %63) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%65, %55, %59, %56) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %18:2 = "taskflow.task"(%7, %13#2, %17#1, %17#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_18"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <7 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <3 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.icmp"(%39) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %41 = "neura.grant_predicate"(%33, %40) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %42 = "neura.grant_predicate"(%34, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%38, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%35, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%39, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%36, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.not"(%40) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %49 = "neura.grant_predicate"(%35, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%39, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %52 = "neura.grant_predicate"(%36, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %53 = "neura.grant_predicate"(%38, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %54 = "neura.grant_predicate"(%34, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%41, %41, %42, %43, %44) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %55 = "neura.phi"(%54, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%53, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.phi"(%52, %47) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.phi"(%51, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.load_indexed"(%60, %59, %58) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %62 = "neura.load_indexed"(%57, %58, %56) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %63 = "neura.mul"(%61, %62) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.load_indexed"(%55, %59, %56) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %65 = "neura.add"(%64, %63) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%65, %55, %59, %56) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %19:3 = "taskflow.task"(%14#1, %18#1, %13#2, %14#0, %15#0, %16#0, %17#0, %18#0, %c5, %c0_i32, %arg11, %arg12, %arg13, %arg13) <"Task_19"> ({
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: memref<?x256x16xi32>, %arg20: memref<?x256x16xi32>, %arg21: memref<?x256x16xi32>, %arg22: memref<?x256x16xi32>, %arg23: index, %arg24: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg23, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg15, %arg16, %arg22, %arg24, %arg23) <"amoeba.noalias"> ({
      ^bb0(%arg25: !neura.data<memref<?x256x16xi32>, i1>, %arg26: !neura.data<memref<?x256x16xi32>, i1>, %arg27: !neura.data<memref<?x256x16xi32>, i1>, %arg28: !neura.data<i32, i1>, %arg29: !neura.data<index, i1>):
        %32 = "neura.constant"() <"%input3"> : () -> !neura.data<i32, i1>
        %33 = "neura.constant"() <7 : index> : () -> !neura.data<index, i1>
        %34 = "neura.constant"() <6 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <5 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <4 : index> : () -> !neura.data<index, i1>
        %37 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %38 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %41 = "neura.load_indexed"(%38, %39, %40) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %42 = "neura.load_indexed"(%36, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %43 = "neura.add"(%41, %42) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.load_indexed"(%35, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %45 = "neura.add"(%43, %44) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %46 = "neura.load_indexed"(%34, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %47 = "neura.add"(%45, %46) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %48 = "neura.load_indexed"(%33, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %49 = "neura.add"(%47, %48) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.load_indexed"(%37, %39, %40) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %51 = "neura.add"(%49, %50) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.icmp"(%51) <"sgt"> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %53 = "neura.sel"(%52, %51, %32) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%53, %38, %39, %40) <"root"> {rhs_value = "%input2"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, i32, index) -> ()
      "taskflow.yield"(%arg15, %arg16, %arg22) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>)
    %20:2 = "taskflow.task"(%19#2, %arg8, %14#1, %19#0, %c5, %c0_i32, %arg13, %arg8, %arg11, %arg11) <"Task_20"> ({
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<memref<?x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.icmp"(%38) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %40 = "neura.grant_predicate"(%33, %39) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %41 = "neura.grant_predicate"(%34, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%35, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%38, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = "neura.grant_predicate"(%35, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %49 = "neura.grant_predicate"(%38, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%34, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%40, %40, %41, %42, %43) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %52 = "neura.phi"(%51, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %54 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %55 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%47, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.load_indexed"(%56, %55, %54) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %58 = "neura.load_indexed"(%54, %53) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %59 = "neura.mul"(%57, %58) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %60 = "neura.load_indexed"(%52, %55, %53) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %61 = "neura.add"(%60, %59) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%61, %52, %55, %53) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x16xi32>, index) -> ()
      "taskflow.yield"(%arg15, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %21:2 = "taskflow.task"(%7, %19#2, %18#1, %19#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_21"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <8 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.icmp"(%39) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %41 = "neura.grant_predicate"(%33, %40) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %42 = "neura.grant_predicate"(%34, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%38, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%35, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%39, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%36, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.not"(%40) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %49 = "neura.grant_predicate"(%35, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%39, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %52 = "neura.grant_predicate"(%36, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %53 = "neura.grant_predicate"(%38, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %54 = "neura.grant_predicate"(%34, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%41, %41, %42, %43, %44) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %55 = "neura.phi"(%54, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%53, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.phi"(%52, %47) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.phi"(%51, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.load_indexed"(%60, %59, %58) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %62 = "neura.load_indexed"(%57, %58, %56) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %63 = "neura.mul"(%61, %62) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.load_indexed"(%55, %59, %56) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %65 = "neura.add"(%64, %63) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%65, %55, %59, %56) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %22:2 = "taskflow.task"(%7, %19#2, %21#1, %21#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_22"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <9 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %36 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %39 = "neura.icmp"(%38) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %40 = "neura.grant_predicate"(%33, %39) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %41 = "neura.grant_predicate"(%34, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %42 = "neura.grant_predicate"(%36, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%35, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%38, %39) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.not"(%39) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %47 = "neura.grant_predicate"(%35, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.grant_predicate"(%36, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %49 = "neura.grant_predicate"(%38, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%34, %46) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%40, %40, %41, %42, %43) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %52 = "neura.phi"(%51, %41) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %54 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %55 = "neura.phi"(%48, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%47, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.load_indexed"(%56, %55, %54) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %58 = "neura.load_indexed"(%56, %54, %53) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %59 = "neura.mul"(%57, %58) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %60 = "neura.load_indexed"(%52, %55, %53) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %61 = "neura.add"(%60, %59) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%61, %52, %55, %53) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %23:2 = "taskflow.task"(%7, %19#2, %22#1, %22#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_23"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <10 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.icmp"(%39) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %41 = "neura.grant_predicate"(%33, %40) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %42 = "neura.grant_predicate"(%34, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%38, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%35, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%39, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%36, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.not"(%40) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %49 = "neura.grant_predicate"(%35, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%39, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %52 = "neura.grant_predicate"(%36, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %53 = "neura.grant_predicate"(%38, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %54 = "neura.grant_predicate"(%34, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%41, %41, %42, %43, %44) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %55 = "neura.phi"(%54, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%53, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.phi"(%52, %47) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.phi"(%51, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.load_indexed"(%60, %59, %58) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %62 = "neura.load_indexed"(%57, %58, %56) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %63 = "neura.mul"(%61, %62) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.load_indexed"(%55, %59, %56) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %65 = "neura.add"(%64, %63) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%65, %55, %59, %56) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %24:2 = "taskflow.task"(%7, %19#2, %23#1, %23#1, %c5, %c0_i32, %arg10, %arg13, %arg12, %arg12) <"Task_24"> ({
    ^bb0(%arg15: memref<?x256x256xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: index, %arg20: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg19, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      %32 = "taskflow.counter"(%31, %c0, %arg19, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg20, %arg18, %arg15, %arg16, %arg19) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?x256x16xi32>, i1>, %arg23: !neura.data<memref<?x256x256xi32>, i1>, %arg24: !neura.data<memref<?x256x16xi32>, i1>, %arg25: !neura.data<index, i1>):
        %33 = "neura.constant"() <"%input1"> : () -> !neura.data<memref<?x256x16xi32>, i1>
        %34 = "neura.constant"() <11 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <3 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %37 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %38 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.icmp"(%39) <"eq"> {rhs_value = 0 : index} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %41 = "neura.grant_predicate"(%33, %40) : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<i1, i1>) -> !neura.data<memref<?x256x16xi32>, i1>
        %42 = "neura.grant_predicate"(%34, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %43 = "neura.grant_predicate"(%37, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %44 = "neura.grant_predicate"(%38, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%35, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%39, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.grant_predicate"(%36, %40) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %48 = "neura.not"(%40) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %49 = "neura.grant_predicate"(%35, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %50 = "neura.grant_predicate"(%37, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %51 = "neura.grant_predicate"(%39, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %52 = "neura.grant_predicate"(%36, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %53 = "neura.grant_predicate"(%38, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %54 = "neura.grant_predicate"(%34, %48) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        "neura.store_indexed"(%41, %41, %42, %43, %44) <"root"> {lhs_value = "%input0"} : (!neura.data<memref<?x256x16xi32>, i1>, !neura.data<memref<?x256x16xi32>, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %55 = "neura.phi"(%54, %42) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %56 = "neura.phi"(%53, %44) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %57 = "neura.phi"(%52, %47) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %58 = "neura.phi"(%51, %46) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %59 = "neura.phi"(%50, %43) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %60 = "neura.phi"(%49, %45) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %61 = "neura.load_indexed"(%60, %59, %58) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %62 = "neura.load_indexed"(%57, %58, %56) <"leaf"> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %63 = "neura.mul"(%61, %62) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %64 = "neura.load_indexed"(%55, %59, %56) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %65 = "neura.add"(%64, %63) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%65, %55, %59, %56) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?x256x16xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, index) -> ()
      "taskflow.yield"(%arg16, %arg18) <"root"> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %25 = "taskflow.task"(%20#1, %24#1, %19#2, %20#0, %21#0, %22#0, %23#0, %24#0, %c5, %c0_i32, %arg11, %arg12, %arg13, %arg13) <"Task_25"> ({
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?x256x16xi32>, %arg17: memref<?x256x16xi32>, %arg18: memref<?x256x16xi32>, %arg19: memref<?x256x16xi32>, %arg20: memref<?x256x16xi32>, %arg21: memref<?x256x16xi32>, %arg22: memref<?x256x16xi32>, %arg23: index, %arg24: i32):
      %c16 = arith.constant 16 : index
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %arg23, %c1) <"leaf"> : (index, index, index) -> index
      %31 = "taskflow.counter"(%30, %c0, %c16, %c1) <"leaf"> : (index, index, index, index) -> index
      "neura.kernel"(%arg15, %arg16, %arg22, %arg24, %arg23) <"amoeba.noalias"> ({
      ^bb0(%arg25: !neura.data<memref<?x256x16xi32>, i1>, %arg26: !neura.data<memref<?x256x16xi32>, i1>, %arg27: !neura.data<memref<?x256x16xi32>, i1>, %arg28: !neura.data<i32, i1>, %arg29: !neura.data<index, i1>):
        %32 = "neura.constant"() <"%input3"> : () -> !neura.data<i32, i1>
        %33 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %34 = "neura.constant"() <11 : index> : () -> !neura.data<index, i1>
        %35 = "neura.constant"() <10 : index> : () -> !neura.data<index, i1>
        %36 = "neura.constant"() <9 : index> : () -> !neura.data<index, i1>
        %37 = "neura.constant"() <8 : index> : () -> !neura.data<index, i1>
        %38 = "neura.constant"() <1 : index> : () -> !neura.data<index, i1>
        %39 = "neura.counter"() <{rhs_value = "%input1"}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input4"} : () -> !neura.data<index, i1>
        %40 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        %41 = "neura.load_indexed"(%33, %39, %40) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %42 = "neura.load_indexed"(%37, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %43 = "neura.add"(%41, %42) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %44 = "neura.load_indexed"(%36, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %45 = "neura.add"(%43, %44) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %46 = "neura.load_indexed"(%35, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %47 = "neura.add"(%45, %46) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %48 = "neura.load_indexed"(%34, %39, %40) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %49 = "neura.add"(%47, %48) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %50 = "neura.load_indexed"(%38, %39, %40) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %51 = "neura.add"(%49, %50) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        %52 = "neura.icmp"(%51) <"sgt"> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
        %53 = "neura.sel"(%52, %51, %32) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%53, %33, %39, %40) <"root"> {rhs_value = "%input2"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, i32, index) -> ()
      "taskflow.yield"(%arg22) <"leaf"> : (memref<?x256x16xi32>) -> ()
    }) : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %26 = "taskflow.task"(%25, %arg14, %arg14, %c0_i32, %c5, %c5_i32, %arg13, %arg14, %arg14) <"Task_26"> ({
    ^bb0(%arg15: memref<?x256x16xi32>, %arg16: memref<?xi32>, %arg17: memref<?xi32>, %arg18: i32, %arg19: index, %arg20: i32):
      %c0 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %c1 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0, %c16, %c1) <"leaf"> : (index, index, index) -> index
      "neura.kernel"(%arg18, %arg17, %arg15, %arg19, %arg20) <"amoeba.noalias"> ({
      ^bb0(%arg21: !neura.data<i32, i1>, %arg22: !neura.data<memref<?xi32>, i1>, %arg23: !neura.data<memref<?x256x16xi32>, i1>, %arg24: !neura.data<index, i1>, %arg25: !neura.data<i32, i1>):
        %31 = "neura.grant_once"() <"lhs_value"> : () -> !neura.data<memref<?xi32>, i1>
        %32 = "neura.constant"() <2 : index> : () -> !neura.data<index, i1>
        %33 = "neura.constant"() <0 : index> : () -> !neura.data<index, i1>
        %34 = "neura.cast"(%33) <"index_to_int"> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        %35 = "neura.counter"() <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 16 : index} : () -> !neura.data<index, i1>
        "neura.store_indexed"(%31, %31, %35) <"root"> {amoeba.source_owned_once_init, lhs_value = "%input0"} : (!neura.data<memref<?xi32>, i1>, !neura.data<memref<?xi32>, i1>, !neura.data<index, i1>) -> ()
        %36 = "neura.reserve"() : () -> !neura.data<index, i1>
        %37 = "neura.phi"(%36, %35) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %38 = "neura.reserve"() : () -> !neura.data<index, i1>
        %39 = "neura.phi"(%38, %32) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
        %40 = "neura.reserve"() : () -> !neura.data<i64, i1>
        %41 = "neura.phi"(%40, %34) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> !neura.data<i64, i1>
        %42 = "neura.cast"(%41) <"int_to_index"> : (!neura.data<i64, i1>) -> !neura.data<index, i1>
        %43 = "neura.icmp"(%42) <"slt"> {rhs_value = "%input3"} : (!neura.data<index, i1>) -> !neura.data<i1, i1>
        %44 = "neura.grant_predicate"(%39, %43) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %45 = "neura.grant_predicate"(%42, %43) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %46 = "neura.grant_predicate"(%37, %43) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %47 = "neura.not"(%43) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
        %48 = "neura.grant_predicate"(%37, %47) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
        %49 = "neura.load_indexed"(%44, %45, %46) <"leaf"> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
        %50 = "neura.load_indexed"(%46) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %51 = "neura.add"(%50, %49) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%51, %46) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>) -> ()
        %52 = "neura.add"(%45) {rhs_value = 1 : index} : (!neura.data<index, i1>) -> !neura.data<index, i1>
        %53 = "neura.cast"(%52) <"index_to_int"> : (!neura.data<index, i1>) -> !neura.data<i64, i1>
        "neura.ctrl_mov"(%53, %40) : (!neura.data<i64, i1>, !neura.data<i64, i1>) -> ()
        "neura.ctrl_mov"(%44, %38) : (!neura.data<index, i1>, !neura.data<index, i1>) -> ()
        "neura.ctrl_mov"(%46, %36) : (!neura.data<index, i1>, !neura.data<index, i1>) -> ()
        %54 = "neura.load_indexed"(%48) <"leaf"> {lhs_value = "%input1"} : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %55 = "neura.div"(%54) {rhs_value = "%input4"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%55, %48) <"root"> {rhs_value = "%input1"} : (!neura.data<i32, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (i32, memref<?xi32>, memref<?x256x16xi32>, index, i32) -> ()
      "taskflow.yield"(%arg17) <"leaf"> : (memref<?xi32>) -> ()
    }) : (memref<?x256x16xi32>, memref<?xi32>, memref<?xi32>, i32, index, i32, memref<?x256x16xi32>, memref<?xi32>, memref<?xi32>) -> memref<?xi32>
    %cast = memref.cast %26 : memref<?xi32> to memref<16xi32>
    %27 = "taskflow.task"(%26, %26, %c1024_i32, %arg14, %arg14) <"Task_27.replica.0"> ({
    ^bb0(%arg15: memref<?xi32>, %arg16: memref<?xi32>, %arg17: i32):
      %c0 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %c1 = arith.constant 1 : index
      %c0_3 = arith.constant 0 : index
      %c8 = arith.constant 8 : index
      %c1_4 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c0_3, %c8, %c1_4) <"leaf"> : (index, index, index) -> index
      "neura.kernel"(%arg16, %arg17) <"amoeba.noalias"> ({
      ^bb0(%arg18: !neura.data<memref<?xi32>, i1>, %arg19: !neura.data<i32, i1>):
        %c0_5 = arith.constant 0 : index
        %c8_6 = arith.constant 8 : index
        %c1_7 = arith.constant 1 : index
        %31 = "neura.counter"(%c0_5, %c8_6, %c1_7) <"leaf"> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 8 : index} : (index, index, index) -> !neura.data<index, i1>
        %32 = "neura.load_indexed"(%31) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %33 = "neura.div"(%32) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%33, %31) <"root"> {rhs_value = "%input0"} : (!neura.data<i32, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?xi32>, i32) -> ()
      "taskflow.yield"(%arg16) <"leaf"> : (memref<?xi32>) -> ()
    }) {amoeba.replica.count = 2 : i64, amoeba.replica.id = 0 : i64, amoeba.replica.parent_task = "Task_27", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 0 : i64, amoeba.replica.shard_upper = 8 : i64, amoeba.tiling.input_region_lowers = [array<i64: 0>], amoeba.tiling.input_region_reasons = ["proved_replica_counter_coordinate"], amoeba.tiling.input_region_uppers = [array<i64: 8>], amoeba.tiling.output_region_lowers = [array<i64: 0>], amoeba.tiling.output_region_uppers = [array<i64: 8>], trip_count = 8 : i64} : (memref<?xi32>, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>) -> memref<?xi32>
    %cast_0 = memref.cast %27 : memref<?xi32> to memref<16xi32>
    %28 = "taskflow.task"(%26, %26, %c1024_i32, %arg14, %arg14) <"Task_27.replica.1"> ({
    ^bb0(%arg15: memref<?xi32>, %arg16: memref<?xi32>, %arg17: i32):
      %c0 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %c1 = arith.constant 1 : index
      %c8 = arith.constant 8 : index
      %c16_3 = arith.constant 16 : index
      %c1_4 = arith.constant 1 : index
      %30 = "taskflow.counter"(%c8, %c16_3, %c1_4) <"leaf"> : (index, index, index) -> index
      "neura.kernel"(%arg16, %arg17) <"amoeba.noalias"> ({
      ^bb0(%arg18: !neura.data<memref<?xi32>, i1>, %arg19: !neura.data<i32, i1>):
        %c8_5 = arith.constant 8 : index
        %c16_6 = arith.constant 16 : index
        %c1_7 = arith.constant 1 : index
        %31 = "neura.counter"(%c8_5, %c16_6, %c1_7) <"leaf"> {lower_bound_value = 8 : index, step_value = 1 : index, upper_bound_value = 16 : index} : (index, index, index) -> !neura.data<index, i1>
        %32 = "neura.load_indexed"(%31) <"leaf"> {lhs_value = "%input0"} : (!neura.data<index, i1>) -> !neura.data<i32, i1>
        %33 = "neura.div"(%32) {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
        "neura.store_indexed"(%33, %31) <"root"> {rhs_value = "%input0"} : (!neura.data<i32, i1>, !neura.data<index, i1>) -> ()
        "neura.yield"() <"constant_bound"> {yield_type = "void"} : () -> ()
      }) {dataflow_mode = "predicate"} : (memref<?xi32>, i32) -> ()
      "taskflow.yield"(%arg16) <"leaf"> : (memref<?xi32>) -> ()
    }) {amoeba.replica.count = 2 : i64, amoeba.replica.id = 1 : i64, amoeba.replica.parent_task = "Task_27", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_lower = 8 : i64, amoeba.replica.shard_upper = 16 : i64, amoeba.tiling.input_region_lowers = [array<i64: 8>], amoeba.tiling.input_region_reasons = ["proved_replica_counter_coordinate"], amoeba.tiling.input_region_uppers = [array<i64: 16>], amoeba.tiling.output_region_lowers = [array<i64: 8>], amoeba.tiling.output_region_uppers = [array<i64: 16>], trip_count = 8 : i64} : (memref<?xi32>, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>) -> memref<?xi32>
    %cast_1 = memref.cast %28 : memref<?xi32> to memref<16xi32>
    %29 = "taskflow.join"(%cast_0, %cast_1, %cast) <0 : i64> {amoeba.replica.completion_only, amoeba.semantic.completion_only} : (memref<16xi32>, memref<16xi32>, memref<16xi32>) -> memref<16xi32>
    %cast_2 = memref.cast %29 : memref<16xi32> to memref<?xi32>
    return
  }
}

