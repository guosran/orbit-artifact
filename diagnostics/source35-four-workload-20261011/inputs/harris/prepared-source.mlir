"builtin.module"() ({
  "func.func"() <{arg_attrs = [{}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 128>, amoeba.noalias}], function_type = (i32, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) -> (), sym_name = "_Z11harris_funciPA128_KiS1_S1_PA128_iS3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?x128xi32>, %arg2: memref<?x128xi32>, %arg3: memref<?x128xi32>, %arg4: memref<?x128xi32>, %arg5: memref<?x128xi32>, %arg6: memref<?x128xi32>, %arg7: memref<?x128xi32>, %arg8: memref<?x128xi32>, %arg9: memref<?x128xi32>, %arg10: memref<?x128xi32>, %arg11: memref<?x128xi32>, %arg12: memref<?x128xi32>, %arg13: memref<?x128xi32>, %arg14: memref<?x128xi32>, %arg15: memref<?x128xi32>, %arg16: memref<?x128xi32>, %arg17: memref<?x128xi32>, %arg18: memref<?x128xi32>, %arg19: memref<?x128xi32>, %arg20: memref<?x128xi32>, %arg21: memref<?x128xi32>, %arg22: memref<?x128xi32>, %arg23: memref<?x128xi32>, %arg24: memref<?x128xi32>, %arg25: memref<?x128xi32>, %arg26: memref<?x128xi32>, %arg27: memref<?x128xi32>):
    %0 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %1 = "arith.constant"() <{value = 30 : i32}> : () -> i32
    %2 = "arith.constant"() <{value = 59 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 11 : i32}> : () -> i32
    %4 = "arith.constant"() <{value = 25500 : i32}> : () -> i32
    %5 = "arith.constant"() <{value = 2 : i32}> : () -> i32
    %6 = "arith.constant"() <{value = 25 : i32}> : () -> i32
    %7 = "arith.constant"() <{value = 4096 : i32}> : () -> i32
    %8 = "arith.constant"() <{value = 16 : i32}> : () -> i32
    %9 = "arith.constant"() <{value = false}> : () -> i1
    %10 = "arith.constant"() <{value = 63 : index}> : () -> index
    %11 = "taskflow.task"(%arg1, %arg2, %arg3, %arg4, %10, %1, %2, %3, %arg1, %arg2, %arg3, %arg4) <{operandSegmentSizes = array<i32: 3, 1, 4, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_0"}> ({
    ^bb0(%arg166: memref<?x128xi32>, %arg167: memref<?x128xi32>, %arg168: memref<?x128xi32>, %arg169: memref<?x128xi32>, %arg170: index, %arg171: i32, %arg172: i32, %arg173: i32):
      %347 = "arith.constant"() <{value = 128 : index}> : () -> index
      %348 = "arith.constant"() <{value = 0 : index}> : () -> index
      %349 = "arith.constant"() <{value = 1 : index}> : () -> index
      %350 = "taskflow.counter"(%348, %arg170, %349) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %351 = "taskflow.counter"(%350, %348, %347, %349) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%350, %351) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg174: index, %arg175: index):
        %352 = "memref.load"(%arg166, %arg174, %arg175) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %353 = "arith.muli"(%352, %arg171) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %354 = "memref.load"(%arg167, %arg174, %arg175) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %355 = "arith.muli"(%354, %arg172) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %356 = "arith.addi"(%353, %355) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %357 = "memref.load"(%arg168, %arg174, %arg175) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %358 = "arith.muli"(%357, %arg173) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %359 = "arith.addi"(%356, %358) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%359, %arg169, %arg174, %arg175) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg169) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 63 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 63 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 128 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 128 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=8064\0Ainternal_multiplicity=1\0Asource_multiplicity=8064\0Aaxis_count=2\0Aaxis=T,0,0,63,1,63,0,-1,0,0\0Aaxis=T,1,0,128,1,128,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 8064 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 8064 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, i32, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %12 = "taskflow.task"(%11, %arg5, %10, %0, %9, %4, %arg4, %arg5) <{operandSegmentSizes = array<i32: 1, 1, 4, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_1"}> ({
    ^bb0(%arg158: memref<?x128xi32>, %arg159: memref<?x128xi32>, %arg160: index, %arg161: i32, %arg162: i1, %arg163: i32):
      %336 = "arith.constant"() <{value = 128 : index}> : () -> index
      %337 = "arith.constant"() <{value = 0 : index}> : () -> index
      %338 = "arith.constant"() <{value = 1 : index}> : () -> index
      %339 = "taskflow.counter"(%337, %arg160, %338) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %340 = "taskflow.counter"(%339, %337, %336, %338) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%339, %340) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg164: index, %arg165: index):
        %341 = "memref.load"(%arg158, %arg164, %arg165) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %342 = "arith.cmpi"(%341, %arg161) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %343 = "arith.select"(%342, %arg161, %341) : (i1, i32, i32) -> i32
        %344 = "scf.if"(%342) ({
          "scf.yield"(%arg162) : (i1) -> ()
        }, {
          %346 = "arith.cmpi"(%341, %arg163) <{predicate = 4 : i64}> : (i32, i32) -> i1
          "scf.yield"(%346) : (i1) -> ()
        }) : (i1) -> i1
        %345 = "arith.select"(%344, %arg163, %343) : (i1, i32, i32) -> i32
        "memref.store"(%345, %arg159, %arg164, %arg165) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg159) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 63 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 63 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 128 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 128 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=8064\0Ainternal_multiplicity=1\0Asource_multiplicity=8064\0Aaxis_count=2\0Aaxis=T,0,0,63,1,63,0,-1,0,0\0Aaxis=T,1,0,128,1,128,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 8064 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 8064 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i1, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %13 = "taskflow.task"(%12, %arg6, %10, %5, %arg5, %arg6) <{operandSegmentSizes = array<i32: 1, 1, 2, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_2"}> ({
    ^bb0(%arg152: memref<?x128xi32>, %arg153: memref<?x128xi32>, %arg154: index, %arg155: i32):
      %322 = "arith.constant"() <{value = -1 : index}> : () -> index
      %323 = "arith.constant"() <{value = 127 : index}> : () -> index
      %324 = "arith.constant"() <{value = 0 : index}> : () -> index
      %325 = "arith.constant"() <{value = 1 : index}> : () -> index
      %326 = "taskflow.counter"(%324, %arg154, %325) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %327 = "taskflow.counter"(%326, %325, %323, %325) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%326, %327) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg156: index, %arg157: index):
        %328 = "arith.addi"(%arg157, %322) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %329 = "memref.load"(%arg152, %arg156, %328) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %330 = "memref.load"(%arg152, %arg156, %arg157) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %331 = "arith.muli"(%330, %arg155) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %332 = "arith.addi"(%329, %331) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %333 = "arith.addi"(%arg157, %325) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %334 = "memref.load"(%arg152, %arg156, %333) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %335 = "arith.addi"(%332, %334) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%335, %arg153, %arg156, %arg157) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg153) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 63 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 63 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7938\0Ainternal_multiplicity=1\0Asource_multiplicity=7938\0Aaxis_count=2\0Aaxis=T,0,0,63,1,63,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7938 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7938 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %14 = "taskflow.task"(%13, %arg7, %10, %5, %arg6, %arg7) <{operandSegmentSizes = array<i32: 1, 1, 2, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_3"}> ({
    ^bb0(%arg146: memref<?x128xi32>, %arg147: memref<?x128xi32>, %arg148: index, %arg149: i32):
      %308 = "arith.constant"() <{value = 127 : index}> : () -> index
      %309 = "arith.constant"() <{value = 1 : index}> : () -> index
      %310 = "arith.constant"() <{value = -1 : index}> : () -> index
      %311 = "arith.addi"(%arg148, %310) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %312 = "taskflow.counter"(%309, %311, %309) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %313 = "taskflow.counter"(%312, %309, %308, %309) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%312, %313) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg150: index, %arg151: index):
        %314 = "arith.addi"(%arg150, %310) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %315 = "memref.load"(%arg146, %314, %arg151) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %316 = "memref.load"(%arg146, %arg150, %arg151) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %317 = "arith.muli"(%316, %arg149) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %318 = "arith.addi"(%315, %317) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %319 = "arith.addi"(%arg150, %309) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %320 = "memref.load"(%arg146, %319, %arg151) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %321 = "arith.addi"(%318, %320) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%321, %arg147, %arg150, %arg151) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg147) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %15 = "taskflow.task"(%14, %arg8, %10, %0, %5, %arg7, %arg8) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_4"}> ({
    ^bb0(%arg139: memref<?x128xi32>, %arg140: memref<?x128xi32>, %arg141: index, %arg142: i32, %arg143: i32):
      %278 = "arith.constant"() <{value = 127 : index}> : () -> index
      %279 = "arith.constant"() <{value = 1 : index}> : () -> index
      %280 = "arith.constant"() <{value = -1 : index}> : () -> index
      %281 = "arith.addi"(%arg141, %280) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %282 = "taskflow.counter"(%279, %281, %279) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %283 = "taskflow.counter"(%282, %279, %278, %279) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%282, %283) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg144: index, %arg145: index):
        %284 = "arith.addi"(%arg144, %280) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %285 = "arith.addi"(%arg145, %280) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %286 = "memref.load"(%arg139, %284, %285) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %287 = "arith.subi"(%arg142, %286) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %288 = "arith.addi"(%arg144, %280) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %289 = "arith.addi"(%arg145, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %290 = "memref.load"(%arg139, %288, %289) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %291 = "arith.addi"(%287, %290) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %292 = "arith.addi"(%arg145, %280) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %293 = "memref.load"(%arg139, %arg144, %292) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %294 = "arith.muli"(%293, %arg143) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %295 = "arith.subi"(%291, %294) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %296 = "arith.addi"(%arg145, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %297 = "memref.load"(%arg139, %arg144, %296) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %298 = "arith.muli"(%297, %arg143) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %299 = "arith.addi"(%295, %298) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %300 = "arith.addi"(%arg144, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %301 = "arith.addi"(%arg145, %280) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %302 = "memref.load"(%arg139, %300, %301) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %303 = "arith.subi"(%299, %302) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %304 = "arith.addi"(%arg144, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %305 = "arith.addi"(%arg145, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %306 = "memref.load"(%arg139, %304, %305) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %307 = "arith.addi"(%303, %306) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%307, %arg140, %arg144, %arg145) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg140) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %16 = "taskflow.task"(%14, %arg9, %10, %0, %5, %arg7, %arg9) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_5"}> ({
    ^bb0(%arg132: memref<?x128xi32>, %arg133: memref<?x128xi32>, %arg134: index, %arg135: i32, %arg136: i32):
      %248 = "arith.constant"() <{value = 127 : index}> : () -> index
      %249 = "arith.constant"() <{value = 1 : index}> : () -> index
      %250 = "arith.constant"() <{value = -1 : index}> : () -> index
      %251 = "arith.addi"(%arg134, %250) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %252 = "taskflow.counter"(%249, %251, %249) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %253 = "taskflow.counter"(%252, %249, %248, %249) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%252, %253) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg137: index, %arg138: index):
        %254 = "arith.addi"(%arg137, %250) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %255 = "arith.addi"(%arg138, %250) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %256 = "memref.load"(%arg132, %254, %255) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %257 = "arith.subi"(%arg135, %256) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %258 = "arith.addi"(%arg137, %250) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %259 = "memref.load"(%arg132, %258, %arg138) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %260 = "arith.muli"(%259, %arg136) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %261 = "arith.subi"(%257, %260) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %262 = "arith.addi"(%arg137, %250) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %263 = "arith.addi"(%arg138, %249) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %264 = "memref.load"(%arg132, %262, %263) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %265 = "arith.subi"(%261, %264) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %266 = "arith.addi"(%arg137, %249) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %267 = "arith.addi"(%arg138, %250) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %268 = "memref.load"(%arg132, %266, %267) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %269 = "arith.addi"(%265, %268) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %270 = "arith.addi"(%arg137, %249) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %271 = "memref.load"(%arg132, %270, %arg138) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %272 = "arith.muli"(%271, %arg136) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %273 = "arith.addi"(%269, %272) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %274 = "arith.addi"(%arg137, %249) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %275 = "arith.addi"(%arg138, %249) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %276 = "memref.load"(%arg132, %274, %275) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %277 = "arith.addi"(%273, %276) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%277, %arg133, %arg137, %arg138) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg133) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %17 = "taskflow.task"(%15, %16, %arg10, %10, %0, %arg8, %arg9, %arg10) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_6"}> ({
    ^bb0(%arg125: memref<?x128xi32>, %arg126: memref<?x128xi32>, %arg127: memref<?x128xi32>, %arg128: index, %arg129: i32):
      %233 = "arith.constant"() <{value = 127 : index}> : () -> index
      %234 = "arith.constant"() <{value = 1 : index}> : () -> index
      %235 = "arith.constant"() <{value = -1 : index}> : () -> index
      %236 = "arith.addi"(%arg128, %235) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %237 = "taskflow.counter"(%234, %236, %234) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %238 = "taskflow.counter"(%237, %234, %233, %234) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%237, %238) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg130: index, %arg131: index):
        %239 = "memref.load"(%arg125, %arg130, %arg131) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %240 = "memref.load"(%arg126, %arg130, %arg131) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %241 = "arith.cmpi"(%239, %arg129) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %242 = "scf.if"(%241) ({
          %247 = "arith.subi"(%arg129, %239) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "scf.yield"(%247) : (i32) -> ()
        }, {
          "scf.yield"(%239) : (i32) -> ()
        }) : (i1) -> i32
        %243 = "arith.cmpi"(%240, %arg129) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %244 = "scf.if"(%243) ({
          %246 = "arith.subi"(%arg129, %240) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "scf.yield"(%246) : (i32) -> ()
        }, {
          "scf.yield"(%240) : (i32) -> ()
        }) : (i1) -> i32
        %245 = "arith.addi"(%242, %244) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%245, %arg127, %arg130, %arg131) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg127) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %18 = "taskflow.task"(%15, %arg11, %10, %arg8, %arg11) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_7"}> ({
    ^bb0(%arg120: memref<?x128xi32>, %arg121: memref<?x128xi32>, %arg122: index):
      %225 = "arith.constant"() <{value = 127 : index}> : () -> index
      %226 = "arith.constant"() <{value = 1 : index}> : () -> index
      %227 = "arith.constant"() <{value = -1 : index}> : () -> index
      %228 = "arith.addi"(%arg122, %227) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %229 = "taskflow.counter"(%226, %228, %226) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %230 = "taskflow.counter"(%229, %226, %225, %226) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%229, %230) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg123: index, %arg124: index):
        %231 = "memref.load"(%arg120, %arg123, %arg124) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %232 = "arith.muli"(%231, %231) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%232, %arg121, %arg123, %arg124) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg121) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %19 = "taskflow.task"(%16, %arg12, %10, %arg9, %arg12) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_8"}> ({
    ^bb0(%arg115: memref<?x128xi32>, %arg116: memref<?x128xi32>, %arg117: index):
      %217 = "arith.constant"() <{value = 127 : index}> : () -> index
      %218 = "arith.constant"() <{value = 1 : index}> : () -> index
      %219 = "arith.constant"() <{value = -1 : index}> : () -> index
      %220 = "arith.addi"(%arg117, %219) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %221 = "taskflow.counter"(%218, %220, %218) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %222 = "taskflow.counter"(%221, %218, %217, %218) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%221, %222) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg118: index, %arg119: index):
        %223 = "memref.load"(%arg115, %arg118, %arg119) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %224 = "arith.muli"(%223, %223) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%224, %arg116, %arg118, %arg119) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg116) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %20 = "taskflow.task"(%15, %16, %arg13, %10, %arg8, %arg9, %arg13) <{operandSegmentSizes = array<i32: 2, 1, 1, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_9"}> ({
    ^bb0(%arg109: memref<?x128xi32>, %arg110: memref<?x128xi32>, %arg111: memref<?x128xi32>, %arg112: index):
      %208 = "arith.constant"() <{value = 127 : index}> : () -> index
      %209 = "arith.constant"() <{value = 1 : index}> : () -> index
      %210 = "arith.constant"() <{value = -1 : index}> : () -> index
      %211 = "arith.addi"(%arg112, %210) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %212 = "taskflow.counter"(%209, %211, %209) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %213 = "taskflow.counter"(%212, %209, %208, %209) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%212, %213) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg113: index, %arg114: index):
        %214 = "memref.load"(%arg109, %arg113, %arg114) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %215 = "memref.load"(%arg110, %arg113, %arg114) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %216 = "arith.muli"(%214, %215) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%216, %arg111, %arg113, %arg114) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg111) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %21 = "taskflow.task"(%18, %arg14, %10, %arg11, %arg14) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_10"}> ({
    ^bb0(%arg104: memref<?x128xi32>, %arg105: memref<?x128xi32>, %arg106: index):
      %195 = "arith.constant"() <{value = 127 : index}> : () -> index
      %196 = "arith.constant"() <{value = 1 : index}> : () -> index
      %197 = "arith.constant"() <{value = -1 : index}> : () -> index
      %198 = "arith.addi"(%arg106, %197) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %199 = "taskflow.counter"(%196, %198, %196) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %200 = "taskflow.counter"(%199, %196, %195, %196) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%199, %200) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg107: index, %arg108: index):
        %201 = "arith.addi"(%arg108, %197) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %202 = "memref.load"(%arg104, %arg107, %201) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %203 = "memref.load"(%arg104, %arg107, %arg108) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %204 = "arith.addi"(%202, %203) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %205 = "arith.addi"(%arg108, %196) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %206 = "memref.load"(%arg104, %arg107, %205) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %207 = "arith.addi"(%204, %206) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%207, %arg105, %arg107, %arg108) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg105) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %22 = "taskflow.task"(%19, %arg15, %10, %arg12, %arg15) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_11"}> ({
    ^bb0(%arg99: memref<?x128xi32>, %arg100: memref<?x128xi32>, %arg101: index):
      %182 = "arith.constant"() <{value = 127 : index}> : () -> index
      %183 = "arith.constant"() <{value = 1 : index}> : () -> index
      %184 = "arith.constant"() <{value = -1 : index}> : () -> index
      %185 = "arith.addi"(%arg101, %184) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %186 = "taskflow.counter"(%183, %185, %183) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %187 = "taskflow.counter"(%186, %183, %182, %183) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%186, %187) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg102: index, %arg103: index):
        %188 = "arith.addi"(%arg103, %184) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %189 = "memref.load"(%arg99, %arg102, %188) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %190 = "memref.load"(%arg99, %arg102, %arg103) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %191 = "arith.addi"(%189, %190) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %192 = "arith.addi"(%arg103, %183) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %193 = "memref.load"(%arg99, %arg102, %192) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %194 = "arith.addi"(%191, %193) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%194, %arg100, %arg102, %arg103) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg100) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %23 = "taskflow.task"(%20, %arg16, %10, %arg13, %arg16) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_12"}> ({
    ^bb0(%arg94: memref<?x128xi32>, %arg95: memref<?x128xi32>, %arg96: index):
      %169 = "arith.constant"() <{value = 127 : index}> : () -> index
      %170 = "arith.constant"() <{value = 1 : index}> : () -> index
      %171 = "arith.constant"() <{value = -1 : index}> : () -> index
      %172 = "arith.addi"(%arg96, %171) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %173 = "taskflow.counter"(%170, %172, %170) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %174 = "taskflow.counter"(%173, %170, %169, %170) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%173, %174) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg97: index, %arg98: index):
        %175 = "arith.addi"(%arg98, %171) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %176 = "memref.load"(%arg94, %arg97, %175) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %177 = "memref.load"(%arg94, %arg97, %arg98) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %178 = "arith.addi"(%176, %177) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %179 = "arith.addi"(%arg98, %170) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %180 = "memref.load"(%arg94, %arg97, %179) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %181 = "arith.addi"(%178, %180) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%181, %arg95, %arg97, %arg98) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg95) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %24 = "taskflow.task"(%21, %arg17, %10, %arg14, %arg17) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_13"}> ({
    ^bb0(%arg89: memref<?x128xi32>, %arg90: memref<?x128xi32>, %arg91: index):
      %156 = "arith.constant"() <{value = 127 : index}> : () -> index
      %157 = "arith.constant"() <{value = 1 : index}> : () -> index
      %158 = "arith.constant"() <{value = -1 : index}> : () -> index
      %159 = "arith.addi"(%arg91, %158) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %160 = "taskflow.counter"(%157, %159, %157) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %161 = "taskflow.counter"(%160, %157, %156, %157) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%160, %161) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg92: index, %arg93: index):
        %162 = "arith.addi"(%arg92, %158) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %163 = "memref.load"(%arg89, %162, %arg93) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %164 = "memref.load"(%arg89, %arg92, %arg93) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %165 = "arith.addi"(%163, %164) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %166 = "arith.addi"(%arg92, %157) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %167 = "memref.load"(%arg89, %166, %arg93) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %168 = "arith.addi"(%165, %167) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%168, %arg90, %arg92, %arg93) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg90) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %25 = "taskflow.task"(%22, %arg18, %10, %arg15, %arg18) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_14"}> ({
    ^bb0(%arg84: memref<?x128xi32>, %arg85: memref<?x128xi32>, %arg86: index):
      %143 = "arith.constant"() <{value = 127 : index}> : () -> index
      %144 = "arith.constant"() <{value = 1 : index}> : () -> index
      %145 = "arith.constant"() <{value = -1 : index}> : () -> index
      %146 = "arith.addi"(%arg86, %145) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %147 = "taskflow.counter"(%144, %146, %144) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %148 = "taskflow.counter"(%147, %144, %143, %144) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%147, %148) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg87: index, %arg88: index):
        %149 = "arith.addi"(%arg87, %145) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %150 = "memref.load"(%arg84, %149, %arg88) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %151 = "memref.load"(%arg84, %arg87, %arg88) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %152 = "arith.addi"(%150, %151) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %153 = "arith.addi"(%arg87, %144) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %154 = "memref.load"(%arg84, %153, %arg88) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %155 = "arith.addi"(%152, %154) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%155, %arg85, %arg87, %arg88) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg85) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %26 = "taskflow.task"(%23, %arg19, %10, %arg16, %arg19) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_15"}> ({
    ^bb0(%arg79: memref<?x128xi32>, %arg80: memref<?x128xi32>, %arg81: index):
      %130 = "arith.constant"() <{value = 127 : index}> : () -> index
      %131 = "arith.constant"() <{value = 1 : index}> : () -> index
      %132 = "arith.constant"() <{value = -1 : index}> : () -> index
      %133 = "arith.addi"(%arg81, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %134 = "taskflow.counter"(%131, %133, %131) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %135 = "taskflow.counter"(%134, %131, %130, %131) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%134, %135) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg82: index, %arg83: index):
        %136 = "arith.addi"(%arg82, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %137 = "memref.load"(%arg79, %136, %arg83) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %138 = "memref.load"(%arg79, %arg82, %arg83) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %139 = "arith.addi"(%137, %138) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %140 = "arith.addi"(%arg82, %131) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %141 = "memref.load"(%arg79, %140, %arg83) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %142 = "arith.addi"(%139, %141) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%142, %arg80, %arg82, %arg83) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg80) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %27 = "taskflow.task"(%24, %25, %26, %arg20, %10, %6, %arg17, %arg18, %arg19, %arg20) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_16"}> ({
    ^bb0(%arg71: memref<?x128xi32>, %arg72: memref<?x128xi32>, %arg73: memref<?x128xi32>, %arg74: memref<?x128xi32>, %arg75: index, %arg76: i32):
      %114 = "arith.constant"() <{value = 127 : index}> : () -> index
      %115 = "arith.constant"() <{value = 1 : index}> : () -> index
      %116 = "arith.constant"() <{value = -1 : index}> : () -> index
      %117 = "arith.addi"(%arg75, %116) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %118 = "taskflow.counter"(%115, %117, %115) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %119 = "taskflow.counter"(%118, %115, %114, %115) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%118, %119) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg77: index, %arg78: index):
        %120 = "memref.load"(%arg71, %arg77, %arg78) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %121 = "memref.load"(%arg72, %arg77, %arg78) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %122 = "arith.muli"(%120, %121) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %123 = "memref.load"(%arg73, %arg77, %arg78) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %124 = "arith.muli"(%123, %123) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %125 = "arith.subi"(%122, %124) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %126 = "arith.addi"(%120, %121) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %127 = "arith.muli"(%126, %126) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %128 = "arith.divsi"(%127, %arg76) : (i32, i32) -> i32
        %129 = "arith.subi"(%125, %128) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%129, %arg74, %arg77, %arg78) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg74) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %28 = "taskflow.task"(%27, %arg21, %10, %0, %arg20, %arg21) <{operandSegmentSizes = array<i32: 1, 1, 2, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_17"}> ({
    ^bb0(%arg65: memref<?x128xi32>, %arg66: memref<?x128xi32>, %arg67: index, %arg68: i32):
      %105 = "arith.constant"() <{value = 127 : index}> : () -> index
      %106 = "arith.constant"() <{value = 1 : index}> : () -> index
      %107 = "arith.constant"() <{value = -1 : index}> : () -> index
      %108 = "arith.addi"(%arg67, %107) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %109 = "taskflow.counter"(%106, %108, %106) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %110 = "taskflow.counter"(%109, %106, %105, %106) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%109, %110) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg69: index, %arg70: index):
        %111 = "memref.load"(%arg65, %arg69, %arg70) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %112 = "arith.cmpi"(%111, %arg68) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %113 = "arith.select"(%112, %111, %arg68) : (i1, i32, i32) -> i32
        "memref.store"(%113, %arg66, %arg69, %arg70) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg66) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %29 = "taskflow.task"(%28, %arg22, %10, %7, %0, %arg21, %arg22) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_18"}> ({
    ^bb0(%arg58: memref<?x128xi32>, %arg59: memref<?x128xi32>, %arg60: index, %arg61: i32, %arg62: i32):
      %96 = "arith.constant"() <{value = 127 : index}> : () -> index
      %97 = "arith.constant"() <{value = 1 : index}> : () -> index
      %98 = "arith.constant"() <{value = -1 : index}> : () -> index
      %99 = "arith.addi"(%arg60, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %100 = "taskflow.counter"(%97, %99, %97) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %101 = "taskflow.counter"(%100, %97, %96, %97) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%100, %101) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg63: index, %arg64: index):
        %102 = "memref.load"(%arg58, %arg63, %arg64) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %103 = "arith.cmpi"(%102, %arg61) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %104 = "arith.select"(%103, %102, %arg62) : (i1, i32, i32) -> i32
        "memref.store"(%104, %arg59, %arg63, %arg64) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg59) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %30 = "taskflow.task"(%29, %arg23, %10, %arg22, %arg23) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_19"}> ({
    ^bb0(%arg53: memref<?x128xi32>, %arg54: memref<?x128xi32>, %arg55: index):
      %81 = "arith.constant"() <{value = 127 : index}> : () -> index
      %82 = "arith.constant"() <{value = 1 : index}> : () -> index
      %83 = "arith.constant"() <{value = -1 : index}> : () -> index
      %84 = "arith.addi"(%arg55, %83) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %85 = "taskflow.counter"(%82, %84, %82) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %86 = "taskflow.counter"(%85, %82, %81, %82) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%85, %86) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg56: index, %arg57: index):
        %87 = "arith.addi"(%arg57, %83) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %88 = "memref.load"(%arg53, %arg56, %87) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %89 = "memref.load"(%arg53, %arg56, %arg57) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %90 = "arith.addi"(%arg57, %82) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %91 = "memref.load"(%arg53, %arg56, %90) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %92 = "arith.cmpi"(%89, %88) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %93 = "arith.select"(%92, %89, %88) : (i1, i32, i32) -> i32
        %94 = "arith.cmpi"(%91, %93) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %95 = "arith.select"(%94, %91, %93) : (i1, i32, i32) -> i32
        "memref.store"(%95, %arg54, %arg56, %arg57) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg54) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %31 = "taskflow.task"(%30, %arg24, %10, %arg23, %arg24) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_20"}> ({
    ^bb0(%arg48: memref<?x128xi32>, %arg49: memref<?x128xi32>, %arg50: index):
      %66 = "arith.constant"() <{value = 127 : index}> : () -> index
      %67 = "arith.constant"() <{value = 1 : index}> : () -> index
      %68 = "arith.constant"() <{value = -1 : index}> : () -> index
      %69 = "arith.addi"(%arg50, %68) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %70 = "taskflow.counter"(%67, %69, %67) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %71 = "taskflow.counter"(%70, %67, %66, %67) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%70, %71) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg51: index, %arg52: index):
        %72 = "arith.addi"(%arg51, %68) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %73 = "memref.load"(%arg48, %72, %arg52) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %74 = "memref.load"(%arg48, %arg51, %arg52) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %75 = "arith.addi"(%arg51, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %76 = "memref.load"(%arg48, %75, %arg52) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %77 = "arith.cmpi"(%74, %73) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %78 = "arith.select"(%77, %74, %73) : (i1, i32, i32) -> i32
        %79 = "arith.cmpi"(%76, %78) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %80 = "arith.select"(%79, %76, %78) : (i1, i32, i32) -> i32
        "memref.store"(%80, %arg49, %arg51, %arg52) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg49) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %32 = "taskflow.task"(%29, %31, %arg25, %10, %0, %arg22, %arg24, %arg25) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_21"}> ({
    ^bb0(%arg41: memref<?x128xi32>, %arg42: memref<?x128xi32>, %arg43: memref<?x128xi32>, %arg44: index, %arg45: i32):
      %54 = "arith.constant"() <{value = 127 : index}> : () -> index
      %55 = "arith.constant"() <{value = 1 : index}> : () -> index
      %56 = "arith.constant"() <{value = -1 : index}> : () -> index
      %57 = "arith.addi"(%arg44, %56) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %58 = "taskflow.counter"(%55, %57, %55) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %59 = "taskflow.counter"(%58, %55, %54, %55) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%58, %59) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg46: index, %arg47: index):
        %60 = "memref.load"(%arg41, %arg46, %arg47) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %61 = "arith.cmpi"(%60, %arg45) <{predicate = 1 : i64}> : (i32, i32) -> i1
        %62 = "scf.if"(%61) ({
          %63 = "memref.load"(%arg42, %arg46, %arg47) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
          %64 = "arith.cmpi"(%60, %63) <{predicate = 0 : i64}> : (i32, i32) -> i1
          %65 = "arith.select"(%64, %60, %arg45) : (i1, i32, i32) -> i32
          "scf.yield"(%65) : (i32) -> ()
        }, {
          "scf.yield"(%arg45) : (i32) -> ()
        }) : (i1) -> i32
        "memref.store"(%62, %arg43, %arg46, %arg47) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg43) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %33 = "taskflow.task"(%32, %17, %arg26, %10, %8, %arg25, %arg10, %arg26) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_22"}> ({
    ^bb0(%arg34: memref<?x128xi32>, %arg35: memref<?x128xi32>, %arg36: memref<?x128xi32>, %arg37: index, %arg38: i32):
      %44 = "arith.constant"() <{value = 127 : index}> : () -> index
      %45 = "arith.constant"() <{value = 1 : index}> : () -> index
      %46 = "arith.constant"() <{value = -1 : index}> : () -> index
      %47 = "arith.addi"(%arg37, %46) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %48 = "taskflow.counter"(%45, %47, %45) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %49 = "taskflow.counter"(%48, %45, %44, %45) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%48, %49) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg39: index, %arg40: index):
        %50 = "memref.load"(%arg34, %arg39, %arg40) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %51 = "memref.load"(%arg35, %arg39, %arg40) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %52 = "arith.divsi"(%51, %arg38) : (i32, i32) -> i32
        %53 = "arith.addi"(%50, %52) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%53, %arg36, %arg39, %arg40) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg36) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    %34 = "taskflow.task"(%33, %arg27, %10, %7, %arg26, %arg27) <{operandSegmentSizes = array<i32: 1, 1, 2, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_23"}> ({
    ^bb0(%arg28: memref<?x128xi32>, %arg29: memref<?x128xi32>, %arg30: index, %arg31: i32):
      %35 = "arith.constant"() <{value = 127 : index}> : () -> index
      %36 = "arith.constant"() <{value = 1 : index}> : () -> index
      %37 = "arith.constant"() <{value = -1 : index}> : () -> index
      %38 = "arith.addi"(%arg30, %37) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %39 = "taskflow.counter"(%36, %38, %36) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %40 = "taskflow.counter"(%39, %36, %35, %36) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%39, %40) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg32: index, %arg33: index):
        %41 = "memref.load"(%arg28, %arg32, %arg33) <{nontemporal = false}> : (memref<?x128xi32>, index, index) -> i32
        %42 = "arith.cmpi"(%41, %arg31) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %43 = "arith.extui"(%42) : (i1) -> i32
        "memref.store"(%43, %arg29, %arg32, %arg33) <{nontemporal = false}> : (i32, memref<?x128xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg29) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x128xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 61 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 126 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 127 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=7686\0Ainternal_multiplicity=1\0Asource_multiplicity=7686\0Aaxis_count=2\0Aaxis=T,0,1,62,1,61,0,-1,0,0\0Aaxis=T,1,1,127,1,126,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 7686 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 7686 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x128xi32>, memref<?x128xi32>, index, i32, memref<?x128xi32>, memref<?x128xi32>) -> memref<?x128xi32>
    "func.return"() : () -> ()
  }) {amoeba.input0_caller_evidence_path = "/home/shiran/project/orbit-artifact/reference/input0-source-domains/callers/harris.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "/home/shiran/project/orbit-repair-study/full_prepared-v4/harris/taskflow-affine.mlir", amoeba.input0_caller_static_bound = 63 : i64, amoeba.static_bound.arg.0 = 63 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) : () -> ()

