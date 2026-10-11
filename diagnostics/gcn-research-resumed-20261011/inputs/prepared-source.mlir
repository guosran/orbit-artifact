"builtin.module"() ({
  "func.func"() <{arg_attrs = [{}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 16>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 16>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 16>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 16>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 4, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 4, 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 3, 256, 16>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 12, 256, 16>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 3, 256, 16>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16>, amoeba.noalias}], function_type = (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x16xi32>, memref<?x16xi32>, memref<?x16xi32>, memref<?x16xi32>, memref<?x256xi32>, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?xi32>) -> (), sym_name = "_Z8gcn_funciPA256_KiS1_S1_S1_PA16_S_S3_S3_S3_PA256_iPA256_S4_PA256_A16_iSA_SA_Pi"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?x256xi32>, %arg2: memref<?x256xi32>, %arg3: memref<?x256xi32>, %arg4: memref<?x256xi32>, %arg5: memref<?x16xi32>, %arg6: memref<?x16xi32>, %arg7: memref<?x16xi32>, %arg8: memref<?x16xi32>, %arg9: memref<?x256xi32>, %arg10: memref<?x256x256xi32>, %arg11: memref<?x256x16xi32>, %arg12: memref<?x256x16xi32>, %arg13: memref<?x256x16xi32>, %arg14: memref<?xi32>):
    %0 = "arith.constant"() <{value = 5 : i32}> : () -> i32
    %1 = "arith.constant"() <{value = 1024 : i32}> : () -> i32
    %2 = "arith.constant"() <{value = 1 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %4 = "arith.constant"() <{value = 5 : index}> : () -> index
    %5 = "taskflow.task"(%arg1, %arg9, %arg9, %4, %2, %arg1, %arg9, %arg9) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_0"}> ({
    ^bb0(%arg242: memref<?x256xi32>, %arg243: memref<?x256xi32>, %arg244: memref<?x256xi32>, %arg245: index, %arg246: i32):
      %371 = "arith.constant"() <{value = 0 : index}> : () -> index
      %372 = "arith.constant"() <{value = 1 : index}> : () -> index
      %373 = "taskflow.counter"(%371, %arg245, %372) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %374 = "taskflow.counter"(%373, %371, %arg245, %372) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%373, %374) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg247: index, %arg248: index):
        %375 = "arith.cmpi"(%arg248, %371) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%375) ({
          "memref.store"(%arg246, %arg244, %371, %arg247) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %376 = "memref.load"(%arg242, %arg247, %arg248) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %377 = "memref.load"(%arg244, %371, %arg247) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %378 = "arith.addi"(%377, %376) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%378, %arg244, %371, %arg247) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg244) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %6 = "taskflow.task"(%arg2, %5, %5, %4, %2, %arg2, %arg9, %arg9) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_1"}> ({
    ^bb0(%arg235: memref<?x256xi32>, %arg236: memref<?x256xi32>, %arg237: memref<?x256xi32>, %arg238: index, %arg239: i32):
      %363 = "arith.constant"() <{value = 0 : index}> : () -> index
      %364 = "arith.constant"() <{value = 1 : index}> : () -> index
      %365 = "taskflow.counter"(%363, %arg238, %364) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %366 = "taskflow.counter"(%365, %363, %arg238, %364) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%365, %366) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg240: index, %arg241: index):
        %367 = "arith.cmpi"(%arg241, %363) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%367) ({
          "memref.store"(%arg239, %arg237, %364, %arg240) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %368 = "memref.load"(%arg235, %arg240, %arg241) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %369 = "memref.load"(%arg237, %364, %arg240) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %370 = "arith.addi"(%369, %368) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%370, %arg237, %364, %arg240) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg237) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %7 = "taskflow.task"(%arg3, %6, %6, %4, %2, %arg3, %arg9, %arg9) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_2"}> ({
    ^bb0(%arg228: memref<?x256xi32>, %arg229: memref<?x256xi32>, %arg230: memref<?x256xi32>, %arg231: index, %arg232: i32):
      %354 = "arith.constant"() <{value = 2 : index}> : () -> index
      %355 = "arith.constant"() <{value = 0 : index}> : () -> index
      %356 = "arith.constant"() <{value = 1 : index}> : () -> index
      %357 = "taskflow.counter"(%355, %arg231, %356) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %358 = "taskflow.counter"(%357, %355, %arg231, %356) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%357, %358) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg233: index, %arg234: index):
        %359 = "arith.cmpi"(%arg234, %355) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%359) ({
          "memref.store"(%arg232, %arg230, %354, %arg233) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %360 = "memref.load"(%arg228, %arg233, %arg234) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %361 = "memref.load"(%arg230, %354, %arg233) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %362 = "arith.addi"(%361, %360) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%362, %arg230, %354, %arg233) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg230) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %8 = "taskflow.task"(%arg4, %7, %7, %4, %2, %arg4, %arg9, %arg9) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_3"}> ({
    ^bb0(%arg221: memref<?x256xi32>, %arg222: memref<?x256xi32>, %arg223: memref<?x256xi32>, %arg224: index, %arg225: i32):
      %345 = "arith.constant"() <{value = 3 : index}> : () -> index
      %346 = "arith.constant"() <{value = 0 : index}> : () -> index
      %347 = "arith.constant"() <{value = 1 : index}> : () -> index
      %348 = "taskflow.counter"(%346, %arg224, %347) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %349 = "taskflow.counter"(%348, %346, %arg224, %347) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%348, %349) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg226: index, %arg227: index):
        %350 = "arith.cmpi"(%arg227, %346) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%350) ({
          "memref.store"(%arg225, %arg223, %345, %arg226) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %351 = "memref.load"(%arg221, %arg226, %arg227) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %352 = "memref.load"(%arg223, %345, %arg226) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %353 = "arith.addi"(%352, %351) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%353, %arg223, %345, %arg226) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg223) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %9 = "taskflow.task"(%arg1, %8, %arg10, %4, %1, %arg1, %arg9, %arg10) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_4"}> ({
    ^bb0(%arg214: memref<?x256xi32>, %arg215: memref<?x256xi32>, %arg216: memref<?x256x256xi32>, %arg217: index, %arg218: i32):
      %337 = "arith.constant"() <{value = 0 : index}> : () -> index
      %338 = "arith.constant"() <{value = 1 : index}> : () -> index
      %339 = "taskflow.counter"(%337, %arg217, %338) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %340 = "taskflow.counter"(%339, %337, %arg217, %338) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%339, %340) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg219: index, %arg220: index):
        %341 = "memref.load"(%arg214, %arg219, %arg220) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %342 = "arith.muli"(%341, %arg218) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %343 = "memref.load"(%arg215, %337, %arg219) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %344 = "arith.divsi"(%342, %343) : (i32, i32) -> i32
        "memref.store"(%344, %arg216, %337, %arg219, %arg220) <{nontemporal = false}> : (i32, memref<?x256x256xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg216) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %10 = "taskflow.task"(%arg2, %8, %9, %4, %1, %arg2, %arg9, %arg10) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_5"}> ({
    ^bb0(%arg207: memref<?x256xi32>, %arg208: memref<?x256xi32>, %arg209: memref<?x256x256xi32>, %arg210: index, %arg211: i32):
      %329 = "arith.constant"() <{value = 0 : index}> : () -> index
      %330 = "arith.constant"() <{value = 1 : index}> : () -> index
      %331 = "taskflow.counter"(%329, %arg210, %330) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %332 = "taskflow.counter"(%331, %329, %arg210, %330) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%331, %332) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg212: index, %arg213: index):
        %333 = "memref.load"(%arg207, %arg212, %arg213) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %334 = "arith.muli"(%333, %arg211) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %335 = "memref.load"(%arg208, %330, %arg212) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %336 = "arith.divsi"(%334, %335) : (i32, i32) -> i32
        "memref.store"(%336, %arg209, %330, %arg212, %arg213) <{nontemporal = false}> : (i32, memref<?x256x256xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg209) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %11 = "taskflow.task"(%arg3, %8, %10, %4, %1, %arg3, %arg9, %arg10) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_6"}> ({
    ^bb0(%arg200: memref<?x256xi32>, %arg201: memref<?x256xi32>, %arg202: memref<?x256x256xi32>, %arg203: index, %arg204: i32):
      %320 = "arith.constant"() <{value = 2 : index}> : () -> index
      %321 = "arith.constant"() <{value = 0 : index}> : () -> index
      %322 = "arith.constant"() <{value = 1 : index}> : () -> index
      %323 = "taskflow.counter"(%321, %arg203, %322) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %324 = "taskflow.counter"(%323, %321, %arg203, %322) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%323, %324) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg205: index, %arg206: index):
        %325 = "memref.load"(%arg200, %arg205, %arg206) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %326 = "arith.muli"(%325, %arg204) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %327 = "memref.load"(%arg201, %320, %arg205) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %328 = "arith.divsi"(%326, %327) : (i32, i32) -> i32
        "memref.store"(%328, %arg202, %320, %arg205, %arg206) <{nontemporal = false}> : (i32, memref<?x256x256xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg202) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %12 = "taskflow.task"(%arg4, %8, %11, %4, %1, %arg4, %arg9, %arg10) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_7"}> ({
    ^bb0(%arg193: memref<?x256xi32>, %arg194: memref<?x256xi32>, %arg195: memref<?x256x256xi32>, %arg196: index, %arg197: i32):
      %311 = "arith.constant"() <{value = 3 : index}> : () -> index
      %312 = "arith.constant"() <{value = 0 : index}> : () -> index
      %313 = "arith.constant"() <{value = 1 : index}> : () -> index
      %314 = "taskflow.counter"(%312, %arg196, %313) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %315 = "taskflow.counter"(%314, %312, %arg196, %313) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%314, %315) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg198: index, %arg199: index):
        %316 = "memref.load"(%arg193, %arg198, %arg199) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %317 = "arith.muli"(%316, %arg197) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %318 = "memref.load"(%arg194, %311, %arg198) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %319 = "arith.divsi"(%317, %318) : (i32, i32) -> i32
        "memref.store"(%319, %arg195, %311, %arg198, %arg199) <{nontemporal = false}> : (i32, memref<?x256x256xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg195) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=25\0Ainternal_multiplicity=1\0Asource_multiplicity=25\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 25 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 25 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256x256xi32>) -> memref<?x256x256xi32>
    %13 = "taskflow.task"(%arg5, %arg6, %arg11, %arg11, %4, %3, %arg5, %arg6, %arg11, %arg11) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_8"}> ({
    ^bb0(%arg184: memref<?x16xi32>, %arg185: memref<?x16xi32>, %arg186: memref<?x256x16xi32>, %arg187: memref<?x256x16xi32>, %arg188: index, %arg189: i32):
      %299 = "arith.constant"() <{value = 16 : index}> : () -> index
      %300 = "arith.constant"() <{value = 0 : index}> : () -> index
      %301 = "arith.constant"() <{value = 1 : index}> : () -> index
      %302 = "taskflow.counter"(%300, %arg188, %301) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %303 = "taskflow.counter"(%302, %300, %299, %301) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %304 = "taskflow.counter"(%303, %300, %299, %301) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%302, %303, %304) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg190: index, %arg191: index, %arg192: index):
        %305 = "arith.cmpi"(%arg192, %300) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%305) ({
          "memref.store"(%arg189, %arg187, %300, %arg190, %arg191) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %306 = "memref.load"(%arg184, %arg190, %arg192) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %307 = "memref.load"(%arg185, %arg192, %arg191) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %308 = "arith.muli"(%306, %307) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %309 = "memref.load"(%arg187, %300, %arg190, %arg191) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %310 = "arith.addi"(%309, %308) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%310, %arg187, %300, %arg190, %arg191) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg187) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=1280\0Ainternal_multiplicity=1\0Asource_multiplicity=1280\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 1280 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 1280 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %14 = "taskflow.task"(%12, %arg5, %arg12, %arg12, %4, %3, %arg10, %arg5, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_9"}> ({
    ^bb0(%arg175: memref<?x256x256xi32>, %arg176: memref<?x16xi32>, %arg177: memref<?x256x16xi32>, %arg178: memref<?x256x16xi32>, %arg179: index, %arg180: i32):
      %287 = "arith.constant"() <{value = 16 : index}> : () -> index
      %288 = "arith.constant"() <{value = 0 : index}> : () -> index
      %289 = "arith.constant"() <{value = 1 : index}> : () -> index
      %290 = "taskflow.counter"(%288, %arg179, %289) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %291 = "taskflow.counter"(%290, %288, %287, %289) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %292 = "taskflow.counter"(%291, %288, %arg179, %289) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%290, %291, %292) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg181: index, %arg182: index, %arg183: index):
        %293 = "arith.cmpi"(%arg183, %288) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%293) ({
          "memref.store"(%arg180, %arg178, %288, %arg181, %arg182) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %294 = "memref.load"(%arg175, %288, %arg181, %arg183) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %295 = "memref.load"(%arg176, %arg183, %arg182) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %296 = "arith.muli"(%294, %295) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %297 = "memref.load"(%arg178, %288, %arg181, %arg182) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %298 = "arith.addi"(%297, %296) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%298, %arg178, %288, %arg181, %arg182) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg178) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %15 = "taskflow.task"(%12, %arg5, %14, %14, %4, %3, %arg10, %arg5, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_10"}> ({
    ^bb0(%arg166: memref<?x256x256xi32>, %arg167: memref<?x16xi32>, %arg168: memref<?x256x16xi32>, %arg169: memref<?x256x16xi32>, %arg170: index, %arg171: i32):
      %275 = "arith.constant"() <{value = 16 : index}> : () -> index
      %276 = "arith.constant"() <{value = 0 : index}> : () -> index
      %277 = "arith.constant"() <{value = 1 : index}> : () -> index
      %278 = "taskflow.counter"(%276, %arg170, %277) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %279 = "taskflow.counter"(%278, %276, %275, %277) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %280 = "taskflow.counter"(%279, %276, %arg170, %277) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%278, %279, %280) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg172: index, %arg173: index, %arg174: index):
        %281 = "arith.cmpi"(%arg174, %276) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%281) ({
          "memref.store"(%arg171, %arg169, %277, %arg172, %arg173) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %282 = "memref.load"(%arg166, %277, %arg172, %arg174) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %283 = "memref.load"(%arg167, %arg174, %arg173) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %284 = "arith.muli"(%282, %283) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %285 = "memref.load"(%arg169, %277, %arg172, %arg173) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %286 = "arith.addi"(%285, %284) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%286, %arg169, %277, %arg172, %arg173) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg169) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %16 = "taskflow.task"(%12, %arg5, %15, %15, %4, %3, %arg10, %arg5, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_11"}> ({
    ^bb0(%arg157: memref<?x256x256xi32>, %arg158: memref<?x16xi32>, %arg159: memref<?x256x16xi32>, %arg160: memref<?x256x16xi32>, %arg161: index, %arg162: i32):
      %262 = "arith.constant"() <{value = 2 : index}> : () -> index
      %263 = "arith.constant"() <{value = 16 : index}> : () -> index
      %264 = "arith.constant"() <{value = 0 : index}> : () -> index
      %265 = "arith.constant"() <{value = 1 : index}> : () -> index
      %266 = "taskflow.counter"(%264, %arg161, %265) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %267 = "taskflow.counter"(%266, %264, %263, %265) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %268 = "taskflow.counter"(%267, %264, %arg161, %265) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%266, %267, %268) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg163: index, %arg164: index, %arg165: index):
        %269 = "arith.cmpi"(%arg165, %264) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%269) ({
          "memref.store"(%arg162, %arg160, %262, %arg163, %arg164) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %270 = "memref.load"(%arg157, %262, %arg163, %arg165) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %271 = "memref.load"(%arg158, %arg165, %arg164) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %272 = "arith.muli"(%270, %271) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %273 = "memref.load"(%arg160, %262, %arg163, %arg164) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %274 = "arith.addi"(%273, %272) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%274, %arg160, %262, %arg163, %arg164) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg160) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %17 = "taskflow.task"(%12, %arg5, %16, %16, %4, %3, %arg10, %arg5, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_12"}> ({
    ^bb0(%arg148: memref<?x256x256xi32>, %arg149: memref<?x16xi32>, %arg150: memref<?x256x16xi32>, %arg151: memref<?x256x16xi32>, %arg152: index, %arg153: i32):
      %249 = "arith.constant"() <{value = 3 : index}> : () -> index
      %250 = "arith.constant"() <{value = 16 : index}> : () -> index
      %251 = "arith.constant"() <{value = 0 : index}> : () -> index
      %252 = "arith.constant"() <{value = 1 : index}> : () -> index
      %253 = "taskflow.counter"(%251, %arg152, %252) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %254 = "taskflow.counter"(%253, %251, %250, %252) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %255 = "taskflow.counter"(%254, %251, %arg152, %252) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%253, %254, %255) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg154: index, %arg155: index, %arg156: index):
        %256 = "arith.cmpi"(%arg156, %251) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%256) ({
          "memref.store"(%arg153, %arg151, %249, %arg154, %arg155) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %257 = "memref.load"(%arg148, %249, %arg154, %arg156) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %258 = "memref.load"(%arg149, %arg156, %arg155) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %259 = "arith.muli"(%257, %258) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %260 = "memref.load"(%arg151, %249, %arg154, %arg155) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %261 = "arith.addi"(%260, %259) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%261, %arg151, %249, %arg154, %arg155) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg151) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %18:3 = "taskflow.task"(%13, %17, %arg13, %4, %3, %arg11, %arg12, %arg13) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 2, 1, 0>, task_name = "Task_13"}> ({
    ^bb0(%arg141: memref<?x256x16xi32>, %arg142: memref<?x256x16xi32>, %arg143: memref<?x256x16xi32>, %arg144: index, %arg145: i32):
      %231 = "arith.constant"() <{value = 3 : index}> : () -> index
      %232 = "arith.constant"() <{value = 2 : index}> : () -> index
      %233 = "arith.constant"() <{value = 16 : index}> : () -> index
      %234 = "arith.constant"() <{value = 0 : index}> : () -> index
      %235 = "arith.constant"() <{value = 1 : index}> : () -> index
      %236 = "taskflow.counter"(%234, %arg144, %235) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %237 = "taskflow.counter"(%236, %234, %233, %235) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%236, %237) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg146: index, %arg147: index):
        %238 = "memref.load"(%arg141, %234, %arg146, %arg147) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %239 = "memref.load"(%arg142, %234, %arg146, %arg147) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %240 = "arith.addi"(%238, %239) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %241 = "memref.load"(%arg142, %235, %arg146, %arg147) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %242 = "arith.addi"(%240, %241) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %243 = "memref.load"(%arg142, %232, %arg146, %arg147) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %244 = "arith.addi"(%242, %243) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %245 = "memref.load"(%arg142, %231, %arg146, %arg147) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %246 = "arith.addi"(%244, %245) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %247 = "arith.cmpi"(%246, %arg145) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %248 = "arith.select"(%247, %246, %arg145) : (i1, i32, i32) -> i32
        "memref.store"(%248, %arg143, %234, %arg146, %arg147) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg141, %arg142, %arg143) <{operandSegmentSizes = array<i32: 2, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=80\0Ainternal_multiplicity=1\0Asource_multiplicity=80\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 80 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 80 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>)
    %19:2 = "taskflow.task"(%18#2, %arg7, %13, %18#0, %4, %3, %arg13, %arg7, %arg11, %arg11) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_14"}> ({
    ^bb0(%arg132: memref<?x256x16xi32>, %arg133: memref<?x16xi32>, %arg134: memref<?x256x16xi32>, %arg135: memref<?x256x16xi32>, %arg136: index, %arg137: i32):
      %219 = "arith.constant"() <{value = 16 : index}> : () -> index
      %220 = "arith.constant"() <{value = 0 : index}> : () -> index
      %221 = "arith.constant"() <{value = 1 : index}> : () -> index
      %222 = "taskflow.counter"(%220, %arg136, %221) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %223 = "taskflow.counter"(%222, %220, %219, %221) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %224 = "taskflow.counter"(%223, %220, %219, %221) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%222, %223, %224) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg138: index, %arg139: index, %arg140: index):
        %225 = "arith.cmpi"(%arg140, %220) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%225) ({
          "memref.store"(%arg137, %arg135, %221, %arg138, %arg139) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %226 = "memref.load"(%arg132, %220, %arg138, %arg140) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %227 = "memref.load"(%arg133, %arg140, %arg139) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %228 = "arith.muli"(%226, %227) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %229 = "memref.load"(%arg135, %221, %arg138, %arg139) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %230 = "arith.addi"(%229, %228) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%230, %arg135, %221, %arg138, %arg139) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg132, %arg135) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=1280\0Ainternal_multiplicity=1\0Asource_multiplicity=1280\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 1280 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 1280 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %20:2 = "taskflow.task"(%12, %18#2, %17, %18#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_15"}> ({
    ^bb0(%arg123: memref<?x256x256xi32>, %arg124: memref<?x256x16xi32>, %arg125: memref<?x256x16xi32>, %arg126: memref<?x256x16xi32>, %arg127: index, %arg128: i32):
      %206 = "arith.constant"() <{value = 4 : index}> : () -> index
      %207 = "arith.constant"() <{value = 16 : index}> : () -> index
      %208 = "arith.constant"() <{value = 0 : index}> : () -> index
      %209 = "arith.constant"() <{value = 1 : index}> : () -> index
      %210 = "taskflow.counter"(%208, %arg127, %209) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %211 = "taskflow.counter"(%210, %208, %207, %209) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %212 = "taskflow.counter"(%211, %208, %arg127, %209) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%210, %211, %212) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg129: index, %arg130: index, %arg131: index):
        %213 = "arith.cmpi"(%arg131, %208) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%213) ({
          "memref.store"(%arg128, %arg126, %206, %arg129, %arg130) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %214 = "memref.load"(%arg123, %208, %arg129, %arg131) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %215 = "memref.load"(%arg124, %208, %arg131, %arg130) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %216 = "arith.muli"(%214, %215) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %217 = "memref.load"(%arg126, %206, %arg129, %arg130) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %218 = "arith.addi"(%217, %216) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%218, %arg126, %206, %arg129, %arg130) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg124, %arg126) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %21:2 = "taskflow.task"(%12, %18#2, %20#1, %20#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_16"}> ({
    ^bb0(%arg114: memref<?x256x256xi32>, %arg115: memref<?x256x16xi32>, %arg116: memref<?x256x16xi32>, %arg117: memref<?x256x16xi32>, %arg118: index, %arg119: i32):
      %193 = "arith.constant"() <{value = 5 : index}> : () -> index
      %194 = "arith.constant"() <{value = 16 : index}> : () -> index
      %195 = "arith.constant"() <{value = 0 : index}> : () -> index
      %196 = "arith.constant"() <{value = 1 : index}> : () -> index
      %197 = "taskflow.counter"(%195, %arg118, %196) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %198 = "taskflow.counter"(%197, %195, %194, %196) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %199 = "taskflow.counter"(%198, %195, %arg118, %196) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%197, %198, %199) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg120: index, %arg121: index, %arg122: index):
        %200 = "arith.cmpi"(%arg122, %195) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%200) ({
          "memref.store"(%arg119, %arg117, %193, %arg120, %arg121) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %201 = "memref.load"(%arg114, %196, %arg120, %arg122) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %202 = "memref.load"(%arg115, %195, %arg122, %arg121) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %203 = "arith.muli"(%201, %202) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %204 = "memref.load"(%arg117, %193, %arg120, %arg121) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %205 = "arith.addi"(%204, %203) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%205, %arg117, %193, %arg120, %arg121) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg115, %arg117) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %22:2 = "taskflow.task"(%12, %18#2, %21#1, %21#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_17"}> ({
    ^bb0(%arg105: memref<?x256x256xi32>, %arg106: memref<?x256x16xi32>, %arg107: memref<?x256x16xi32>, %arg108: memref<?x256x16xi32>, %arg109: index, %arg110: i32):
      %179 = "arith.constant"() <{value = 2 : index}> : () -> index
      %180 = "arith.constant"() <{value = 6 : index}> : () -> index
      %181 = "arith.constant"() <{value = 16 : index}> : () -> index
      %182 = "arith.constant"() <{value = 0 : index}> : () -> index
      %183 = "arith.constant"() <{value = 1 : index}> : () -> index
      %184 = "taskflow.counter"(%182, %arg109, %183) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %185 = "taskflow.counter"(%184, %182, %181, %183) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %186 = "taskflow.counter"(%185, %182, %arg109, %183) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%184, %185, %186) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg111: index, %arg112: index, %arg113: index):
        %187 = "arith.cmpi"(%arg113, %182) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%187) ({
          "memref.store"(%arg110, %arg108, %180, %arg111, %arg112) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %188 = "memref.load"(%arg105, %179, %arg111, %arg113) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %189 = "memref.load"(%arg106, %182, %arg113, %arg112) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %190 = "arith.muli"(%188, %189) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %191 = "memref.load"(%arg108, %180, %arg111, %arg112) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %192 = "arith.addi"(%191, %190) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%192, %arg108, %180, %arg111, %arg112) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg106, %arg108) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %23:2 = "taskflow.task"(%12, %18#2, %22#1, %22#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_18"}> ({
    ^bb0(%arg96: memref<?x256x256xi32>, %arg97: memref<?x256x16xi32>, %arg98: memref<?x256x16xi32>, %arg99: memref<?x256x16xi32>, %arg100: index, %arg101: i32):
      %165 = "arith.constant"() <{value = 3 : index}> : () -> index
      %166 = "arith.constant"() <{value = 7 : index}> : () -> index
      %167 = "arith.constant"() <{value = 16 : index}> : () -> index
      %168 = "arith.constant"() <{value = 0 : index}> : () -> index
      %169 = "arith.constant"() <{value = 1 : index}> : () -> index
      %170 = "taskflow.counter"(%168, %arg100, %169) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %171 = "taskflow.counter"(%170, %168, %167, %169) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %172 = "taskflow.counter"(%171, %168, %arg100, %169) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%170, %171, %172) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg102: index, %arg103: index, %arg104: index):
        %173 = "arith.cmpi"(%arg104, %168) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%173) ({
          "memref.store"(%arg101, %arg99, %166, %arg102, %arg103) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %174 = "memref.load"(%arg96, %165, %arg102, %arg104) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %175 = "memref.load"(%arg97, %168, %arg104, %arg103) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %176 = "arith.muli"(%174, %175) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %177 = "memref.load"(%arg99, %166, %arg102, %arg103) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %178 = "arith.addi"(%177, %176) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%178, %arg99, %166, %arg102, %arg103) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg97, %arg99) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %24:3 = "taskflow.task"(%19#1, %23#1, %18#2, %19#0, %20#0, %21#0, %22#0, %23#0, %4, %3, %arg11, %arg12, %arg13, %arg13) <{operandSegmentSizes = array<i32: 3, 5, 2, 3, 1>, resultSegmentSizes = array<i32: 2, 1, 0>, task_name = "Task_19"}> ({
    ^bb0(%arg84: memref<?x256x16xi32>, %arg85: memref<?x256x16xi32>, %arg86: memref<?x256x16xi32>, %arg87: memref<?x256x16xi32>, %arg88: memref<?x256x16xi32>, %arg89: memref<?x256x16xi32>, %arg90: memref<?x256x16xi32>, %arg91: memref<?x256x16xi32>, %arg92: index, %arg93: i32):
      %143 = "arith.constant"() <{value = 7 : index}> : () -> index
      %144 = "arith.constant"() <{value = 6 : index}> : () -> index
      %145 = "arith.constant"() <{value = 5 : index}> : () -> index
      %146 = "arith.constant"() <{value = 4 : index}> : () -> index
      %147 = "arith.constant"() <{value = 16 : index}> : () -> index
      %148 = "arith.constant"() <{value = 0 : index}> : () -> index
      %149 = "arith.constant"() <{value = 1 : index}> : () -> index
      %150 = "taskflow.counter"(%148, %arg92, %149) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %151 = "taskflow.counter"(%150, %148, %147, %149) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%150, %151) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg94: index, %arg95: index):
        %152 = "memref.load"(%arg84, %149, %arg94, %arg95) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %153 = "memref.load"(%arg85, %146, %arg94, %arg95) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %154 = "arith.addi"(%152, %153) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %155 = "memref.load"(%arg85, %145, %arg94, %arg95) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %156 = "arith.addi"(%154, %155) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %157 = "memref.load"(%arg85, %144, %arg94, %arg95) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %158 = "arith.addi"(%156, %157) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %159 = "memref.load"(%arg85, %143, %arg94, %arg95) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %160 = "arith.addi"(%158, %159) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %161 = "memref.load"(%arg91, %148, %arg94, %arg95) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %162 = "arith.addi"(%160, %161) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %163 = "arith.cmpi"(%162, %arg93) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %164 = "arith.select"(%163, %162, %arg93) : (i1, i32, i32) -> i32
        "memref.store"(%164, %arg91, %149, %arg94, %arg95) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg84, %arg85, %arg91) <{operandSegmentSizes = array<i32: 2, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=80\0Ainternal_multiplicity=1\0Asource_multiplicity=80\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 80 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 80 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>)
    %25:2 = "taskflow.task"(%24#2, %arg8, %19#1, %24#0, %4, %3, %arg13, %arg8, %arg11, %arg11) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_20"}> ({
    ^bb0(%arg75: memref<?x256x16xi32>, %arg76: memref<?x16xi32>, %arg77: memref<?x256x16xi32>, %arg78: memref<?x256x16xi32>, %arg79: index, %arg80: i32):
      %130 = "arith.constant"() <{value = 2 : index}> : () -> index
      %131 = "arith.constant"() <{value = 16 : index}> : () -> index
      %132 = "arith.constant"() <{value = 0 : index}> : () -> index
      %133 = "arith.constant"() <{value = 1 : index}> : () -> index
      %134 = "taskflow.counter"(%132, %arg79, %133) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %135 = "taskflow.counter"(%134, %132, %131, %133) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %136 = "taskflow.counter"(%135, %132, %131, %133) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%134, %135, %136) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg81: index, %arg82: index, %arg83: index):
        %137 = "arith.cmpi"(%arg83, %132) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%137) ({
          "memref.store"(%arg80, %arg78, %130, %arg81, %arg82) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %138 = "memref.load"(%arg75, %133, %arg81, %arg83) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %139 = "memref.load"(%arg76, %arg83, %arg82) <{nontemporal = false}> : (memref<?x16xi32>, index, index) -> i32
        %140 = "arith.muli"(%138, %139) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %141 = "memref.load"(%arg78, %130, %arg81, %arg82) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %142 = "arith.addi"(%141, %140) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%142, %arg78, %130, %arg81, %arg82) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg75, %arg78) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=1280\0Ainternal_multiplicity=1\0Asource_multiplicity=1280\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 1280 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 1280 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %26:2 = "taskflow.task"(%12, %24#2, %23#1, %24#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_21"}> ({
    ^bb0(%arg66: memref<?x256x256xi32>, %arg67: memref<?x256x16xi32>, %arg68: memref<?x256x16xi32>, %arg69: memref<?x256x16xi32>, %arg70: index, %arg71: i32):
      %117 = "arith.constant"() <{value = 8 : index}> : () -> index
      %118 = "arith.constant"() <{value = 16 : index}> : () -> index
      %119 = "arith.constant"() <{value = 0 : index}> : () -> index
      %120 = "arith.constant"() <{value = 1 : index}> : () -> index
      %121 = "taskflow.counter"(%119, %arg70, %120) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %122 = "taskflow.counter"(%121, %119, %118, %120) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %123 = "taskflow.counter"(%122, %119, %arg70, %120) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%121, %122, %123) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg72: index, %arg73: index, %arg74: index):
        %124 = "arith.cmpi"(%arg74, %119) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%124) ({
          "memref.store"(%arg71, %arg69, %117, %arg72, %arg73) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %125 = "memref.load"(%arg66, %119, %arg72, %arg74) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %126 = "memref.load"(%arg67, %120, %arg74, %arg73) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %127 = "arith.muli"(%125, %126) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %128 = "memref.load"(%arg69, %117, %arg72, %arg73) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %129 = "arith.addi"(%128, %127) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%129, %arg69, %117, %arg72, %arg73) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg67, %arg69) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %27:2 = "taskflow.task"(%12, %24#2, %26#1, %26#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_22"}> ({
    ^bb0(%arg57: memref<?x256x256xi32>, %arg58: memref<?x256x16xi32>, %arg59: memref<?x256x16xi32>, %arg60: memref<?x256x16xi32>, %arg61: index, %arg62: i32):
      %104 = "arith.constant"() <{value = 9 : index}> : () -> index
      %105 = "arith.constant"() <{value = 16 : index}> : () -> index
      %106 = "arith.constant"() <{value = 0 : index}> : () -> index
      %107 = "arith.constant"() <{value = 1 : index}> : () -> index
      %108 = "taskflow.counter"(%106, %arg61, %107) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %109 = "taskflow.counter"(%108, %106, %105, %107) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %110 = "taskflow.counter"(%109, %106, %arg61, %107) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%108, %109, %110) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg63: index, %arg64: index, %arg65: index):
        %111 = "arith.cmpi"(%arg65, %106) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%111) ({
          "memref.store"(%arg62, %arg60, %104, %arg63, %arg64) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %112 = "memref.load"(%arg57, %107, %arg63, %arg65) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %113 = "memref.load"(%arg58, %107, %arg65, %arg64) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %114 = "arith.muli"(%112, %113) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %115 = "memref.load"(%arg60, %104, %arg63, %arg64) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %116 = "arith.addi"(%115, %114) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%116, %arg60, %104, %arg63, %arg64) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg58, %arg60) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %28:2 = "taskflow.task"(%12, %24#2, %27#1, %27#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_23"}> ({
    ^bb0(%arg48: memref<?x256x256xi32>, %arg49: memref<?x256x16xi32>, %arg50: memref<?x256x16xi32>, %arg51: memref<?x256x16xi32>, %arg52: index, %arg53: i32):
      %90 = "arith.constant"() <{value = 2 : index}> : () -> index
      %91 = "arith.constant"() <{value = 10 : index}> : () -> index
      %92 = "arith.constant"() <{value = 16 : index}> : () -> index
      %93 = "arith.constant"() <{value = 0 : index}> : () -> index
      %94 = "arith.constant"() <{value = 1 : index}> : () -> index
      %95 = "taskflow.counter"(%93, %arg52, %94) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %96 = "taskflow.counter"(%95, %93, %92, %94) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %97 = "taskflow.counter"(%96, %93, %arg52, %94) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%95, %96, %97) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg54: index, %arg55: index, %arg56: index):
        %98 = "arith.cmpi"(%arg56, %93) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%98) ({
          "memref.store"(%arg53, %arg51, %91, %arg54, %arg55) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %99 = "memref.load"(%arg48, %90, %arg54, %arg56) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %100 = "memref.load"(%arg49, %94, %arg56, %arg55) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %101 = "arith.muli"(%99, %100) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %102 = "memref.load"(%arg51, %91, %arg54, %arg55) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %103 = "arith.addi"(%102, %101) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%103, %arg51, %91, %arg54, %arg55) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg49, %arg51) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %29:2 = "taskflow.task"(%12, %24#2, %28#1, %28#1, %4, %3, %arg10, %arg13, %arg12, %arg12) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Task_24"}> ({
    ^bb0(%arg39: memref<?x256x256xi32>, %arg40: memref<?x256x16xi32>, %arg41: memref<?x256x16xi32>, %arg42: memref<?x256x16xi32>, %arg43: index, %arg44: i32):
      %76 = "arith.constant"() <{value = 3 : index}> : () -> index
      %77 = "arith.constant"() <{value = 11 : index}> : () -> index
      %78 = "arith.constant"() <{value = 16 : index}> : () -> index
      %79 = "arith.constant"() <{value = 0 : index}> : () -> index
      %80 = "arith.constant"() <{value = 1 : index}> : () -> index
      %81 = "taskflow.counter"(%79, %arg43, %80) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %82 = "taskflow.counter"(%81, %79, %78, %80) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %83 = "taskflow.counter"(%82, %79, %arg43, %80) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%81, %82, %83) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg45: index, %arg46: index, %arg47: index):
        %84 = "arith.cmpi"(%arg47, %79) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%84) ({
          "memref.store"(%arg44, %arg42, %77, %arg45, %arg46) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %85 = "memref.load"(%arg39, %76, %arg45, %arg47) <{nontemporal = false}> : (memref<?x256x256xi32>, index, index, index) -> i32
        %86 = "memref.load"(%arg40, %80, %arg47, %arg46) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %87 = "arith.muli"(%85, %86) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %88 = "memref.load"(%arg42, %77, %arg45, %arg46) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %89 = "arith.addi"(%88, %87) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%89, %arg42, %77, %arg45, %arg46) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg40, %arg42) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<?x256x16xi32>, memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=400\0Ainternal_multiplicity=1\0Asource_multiplicity=400\0Aaxis_count=3\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x256xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> (memref<?x256x16xi32>, memref<?x256x16xi32>)
    %30 = "taskflow.task"(%25#1, %29#1, %24#2, %25#0, %26#0, %27#0, %28#0, %29#0, %4, %3, %arg11, %arg12, %arg13, %arg13) <{operandSegmentSizes = array<i32: 3, 5, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_25"}> ({
    ^bb0(%arg27: memref<?x256x16xi32>, %arg28: memref<?x256x16xi32>, %arg29: memref<?x256x16xi32>, %arg30: memref<?x256x16xi32>, %arg31: memref<?x256x16xi32>, %arg32: memref<?x256x16xi32>, %arg33: memref<?x256x16xi32>, %arg34: memref<?x256x16xi32>, %arg35: index, %arg36: i32):
      %53 = "arith.constant"() <{value = 11 : index}> : () -> index
      %54 = "arith.constant"() <{value = 10 : index}> : () -> index
      %55 = "arith.constant"() <{value = 9 : index}> : () -> index
      %56 = "arith.constant"() <{value = 8 : index}> : () -> index
      %57 = "arith.constant"() <{value = 2 : index}> : () -> index
      %58 = "arith.constant"() <{value = 16 : index}> : () -> index
      %59 = "arith.constant"() <{value = 0 : index}> : () -> index
      %60 = "arith.constant"() <{value = 1 : index}> : () -> index
      %61 = "taskflow.counter"(%59, %arg35, %60) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %62 = "taskflow.counter"(%61, %59, %58, %60) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%61, %62) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg37: index, %arg38: index):
        %63 = "memref.load"(%arg27, %57, %arg37, %arg38) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %64 = "memref.load"(%arg28, %56, %arg37, %arg38) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %65 = "arith.addi"(%63, %64) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %66 = "memref.load"(%arg28, %55, %arg37, %arg38) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %67 = "arith.addi"(%65, %66) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %68 = "memref.load"(%arg28, %54, %arg37, %arg38) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %69 = "arith.addi"(%67, %68) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %70 = "memref.load"(%arg28, %53, %arg37, %arg38) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %71 = "arith.addi"(%69, %70) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %72 = "memref.load"(%arg34, %60, %arg37, %arg38) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %73 = "arith.addi"(%71, %72) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %74 = "arith.cmpi"(%73, %arg36) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %75 = "arith.select"(%74, %73, %arg36) : (i1, i32, i32) -> i32
        "memref.store"(%75, %arg34, %57, %arg37, %arg38) <{nontemporal = false}> : (i32, memref<?x256x16xi32>, index, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg34) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256x16xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=80\0Ainternal_multiplicity=1\0Asource_multiplicity=80\0Aaxis_count=2\0Aaxis=T,0,0,5,1,5,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 80 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 80 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, index, i32, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>, memref<?x256x16xi32>) -> memref<?x256x16xi32>
    %31 = "taskflow.task"(%30, %arg14, %arg14, %4, %3, %0, %arg13, %arg14, %arg14) <{operandSegmentSizes = array<i32: 2, 1, 3, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_26"}> ({
    ^bb0(%arg19: memref<?x256x16xi32>, %arg20: memref<?xi32>, %arg21: memref<?xi32>, %arg22: index, %arg23: i32, %arg24: i32):
      %39 = "arith.constant"() <{value = 2 : index}> : () -> index
      %40 = "arith.constant"() <{value = 0 : index}> : () -> index
      %41 = "arith.constant"() <{value = 16 : index}> : () -> index
      %42 = "arith.constant"() <{value = 1 : index}> : () -> index
      %43 = "taskflow.counter"(%40, %41, %42) <{counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %44 = "taskflow.counter"(%43, %40, %arg22, %42) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%43, %44) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg25: index, %arg26: index):
        %45 = "arith.cmpi"(%arg26, %40) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%45) ({
          "memref.store"(%arg23, %arg21, %arg25) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %46 = "memref.load"(%arg19, %39, %arg26, %arg25) <{nontemporal = false}> : (memref<?x256x16xi32>, index, index, index) -> i32
        %47 = "memref.load"(%arg21, %arg25) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %48 = "arith.addi"(%47, %46) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%48, %arg21, %arg25) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
        %49 = "memref.load"(%arg21, %arg25) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %50 = "arith.divsi"(%49, %arg24) : (i32, i32) -> i32
        %51 = "arith.addi"(%arg26, %42) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %52 = "arith.cmpi"(%51, %arg22) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%52) ({
          "memref.store"(%50, %arg21, %arg25) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg21) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 5 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 5 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=80\0Ainternal_multiplicity=1\0Asource_multiplicity=80\0Aaxis_count=2\0Aaxis=T,0,0,16,1,16,0,-1,0,0\0Aaxis=T,1,0,5,1,5,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 80 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 80 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256x16xi32>, memref<?xi32>, memref<?xi32>, index, i32, i32, memref<?x256x16xi32>, memref<?xi32>, memref<?xi32>) -> memref<?xi32>
    %32 = "taskflow.task"(%31, %31, %1, %arg14, %arg14) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_27"}> ({
    ^bb0(%arg15: memref<?xi32>, %arg16: memref<?xi32>, %arg17: i32):
      %33 = "arith.constant"() <{value = 0 : index}> : () -> index
      %34 = "arith.constant"() <{value = 16 : index}> : () -> index
      %35 = "arith.constant"() <{value = 1 : index}> : () -> index
      %36 = "taskflow.counter"(%33, %34, %35) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 0 : i32}> : (index, index, index) -> index
      "taskflow.hyperblock"(%36) <{operandSegmentSizes = array<i32: 1, 0>}> ({
      ^bb0(%arg18: index):
        %37 = "memref.load"(%arg16, %arg18) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %38 = "arith.divsi"(%37, %arg17) : (i32, i32) -> i32
        "memref.store"(%38, %arg16, %arg18) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index) -> ()
      "taskflow.yield"(%arg16) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=16\0Ainternal_multiplicity=1\0Asource_multiplicity=16\0Aaxis_count=1\0Aaxis=T,0,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 16 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 16 : i64}, dlp_replicable = true} : (memref<?xi32>, memref<?xi32>, i32, memref<?xi32>, memref<?xi32>) -> memref<?xi32>
    "func.return"() : () -> ()
  }) {amoeba.input0_caller_evidence_path = "/home/shiran/project/orbit-artifact/reference/input0-source-domains/callers/gcn.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "/home/shiran/project/orbit-repair-study/full_prepared-v4/gcn/taskflow-affine.mlir", amoeba.input0_caller_static_bound = 5 : i64, amoeba.static_bound.arg.0 = 5 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) : () -> ()

