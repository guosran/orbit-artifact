"builtin.module"() ({
  "func.func"() <{arg_attrs = [{}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 32>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 32, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 16, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256>, amoeba.noalias}], function_type = (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x32xi32>, memref<?xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?xi32>) -> (), sym_name = "_Z10radar_funciPA256_KiS1_S1_S1_PA32_S_S3_PiS4_PA256_iS6_S6_S6_S6_S6_S4_S4_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S4_"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?x256xi32>, %arg2: memref<?x256xi32>, %arg3: memref<?x256xi32>, %arg4: memref<?x256xi32>, %arg5: memref<?x32xi32>, %arg6: memref<?x32xi32>, %arg7: memref<?xi32>, %arg8: memref<?xi32>, %arg9: memref<?x256xi32>, %arg10: memref<?x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<?x256xi32>, %arg13: memref<?x256xi32>, %arg14: memref<?x256xi32>, %arg15: memref<?xi32>, %arg16: memref<?xi32>, %arg17: memref<?x256xi32>, %arg18: memref<?x256xi32>, %arg19: memref<?x256xi32>, %arg20: memref<?x256xi32>, %arg21: memref<?x256xi32>, %arg22: memref<?x256xi32>, %arg23: memref<?x256xi32>, %arg24: memref<?x256xi32>, %arg25: memref<?x256xi32>, %arg26: memref<?x256xi32>, %arg27: memref<?x256xi32>, %arg28: memref<?x256xi32>, %arg29: memref<?x256xi32>, %arg30: memref<?xi32>):
    %0 = "arith.constant"() <{value = 63 : i32}> : () -> i32
    %1 = "arith.constant"() <{value = 64 : i32}> : () -> i32
    %2 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 32 : i32}> : () -> i32
    %4 = "arith.constant"() <{value = 1 : i32}> : () -> i32
    %5 = "arith.constant"() <{value = 6 : i32}> : () -> i32
    %6 = "arith.constant"() <{value = 3 : i32}> : () -> i32
    %7 = "arith.constant"() <{value = 64 : index}> : () -> index
    %8 = "taskflow.task"(%arg1, %arg7, %7, %2, %1, %arg1, %arg7) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_0"}> ({
    ^bb0(%arg188: memref<?x256xi32>, %arg189: memref<?xi32>, %arg190: index, %arg191: i32, %arg192: i32):
      %317 = "arith.constant"() <{value = 0 : index}> : () -> index
      %318 = "arith.constant"() <{value = 32 : index}> : () -> index
      %319 = "arith.constant"() <{value = 1 : index}> : () -> index
      %320 = "taskflow.counter"(%317, %318, %319) <{counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %321 = "taskflow.counter"(%320, %317, %arg190, %319) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %322 = "taskflow.hyperblock"(%320, %321, %arg191) <{operandSegmentSizes = array<i32: 2, 1>}> ({
      ^bb0(%arg193: index, %arg194: index, %arg195: i32):
        %323 = "memref.load"(%arg188, %arg193, %arg194) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %324 = "arith.addi"(%arg195, %323) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %325 = "arith.divsi"(%324, %arg192) : (i32, i32) -> i32
        %326 = "arith.addi"(%arg194, %319) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %327 = "arith.cmpi"(%326, %arg190) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%327) ({
          "memref.store"(%325, %arg189, %arg193) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%324, %324) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, i32) -> i32
      "taskflow.yield"(%arg189) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=2048\0Ainternal_multiplicity=1\0Asource_multiplicity=2048\0Aaxis_count=2\0Aaxis=T,0,0,32,1,32,0,-1,0,0\0Aaxis=T,1,0,64,1,64,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 2048 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 2048 : i64}} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32, memref<?x256xi32>, memref<?xi32>) -> memref<?xi32>
    %9 = "taskflow.task"(%arg2, %arg8, %7, %2, %1, %arg2, %arg8) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_1"}> ({
    ^bb0(%arg180: memref<?x256xi32>, %arg181: memref<?xi32>, %arg182: index, %arg183: i32, %arg184: i32):
      %306 = "arith.constant"() <{value = 0 : index}> : () -> index
      %307 = "arith.constant"() <{value = 32 : index}> : () -> index
      %308 = "arith.constant"() <{value = 1 : index}> : () -> index
      %309 = "taskflow.counter"(%306, %307, %308) <{counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %310 = "taskflow.counter"(%309, %306, %arg182, %308) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %311 = "taskflow.hyperblock"(%309, %310, %arg183) <{operandSegmentSizes = array<i32: 2, 1>}> ({
      ^bb0(%arg185: index, %arg186: index, %arg187: i32):
        %312 = "memref.load"(%arg180, %arg185, %arg186) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %313 = "arith.addi"(%arg187, %312) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %314 = "arith.divsi"(%313, %arg184) : (i32, i32) -> i32
        %315 = "arith.addi"(%arg186, %308) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %316 = "arith.cmpi"(%315, %arg182) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%316) ({
          "memref.store"(%314, %arg181, %arg185) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%313, %313) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, i32) -> i32
      "taskflow.yield"(%arg181) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=2048\0Ainternal_multiplicity=1\0Asource_multiplicity=2048\0Aaxis_count=2\0Aaxis=T,0,0,32,1,32,0,-1,0,0\0Aaxis=T,1,0,64,1,64,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 2048 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 2048 : i64}} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32, memref<?x256xi32>, memref<?xi32>) -> memref<?xi32>
    %10:2 = "taskflow.task"(%arg1, %8, %arg2, %9, %arg9, %arg10, %7, %arg1, %arg7, %arg2, %arg8, %arg9, %arg10) <{operandSegmentSizes = array<i32: 4, 2, 1, 4, 2>, resultSegmentSizes = array<i32: 0, 2, 0>, task_name = "Task_2"}> ({
    ^bb0(%arg171: memref<?x256xi32>, %arg172: memref<?xi32>, %arg173: memref<?x256xi32>, %arg174: memref<?xi32>, %arg175: memref<?x256xi32>, %arg176: memref<?x256xi32>, %arg177: index):
      %295 = "arith.constant"() <{value = 32 : index}> : () -> index
      %296 = "arith.constant"() <{value = 0 : index}> : () -> index
      %297 = "arith.constant"() <{value = 1 : index}> : () -> index
      %298 = "taskflow.counter"(%296, %arg177, %297) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %299 = "taskflow.counter"(%298, %296, %295, %297) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%298, %299) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg178: index, %arg179: index):
        %300 = "memref.load"(%arg171, %arg179, %arg178) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %301 = "memref.load"(%arg172, %arg179) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %302 = "arith.subi"(%300, %301) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%302, %arg175, %arg179, %arg178) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        %303 = "memref.load"(%arg173, %arg179, %arg178) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %304 = "memref.load"(%arg174, %arg179) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %305 = "arith.subi"(%303, %304) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%305, %arg176, %arg179, %arg178) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg175, %arg176) <{operandSegmentSizes = array<i32: 0, 2, 0>}> : (memref<?x256xi32>, memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=2048\0Ainternal_multiplicity=1\0Asource_multiplicity=2048\0Aaxis_count=2\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,32,1,32,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 2048 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 2048 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>) -> (memref<?x256xi32>, memref<?x256xi32>)
    %11:2 = "taskflow.task"(%10#0, %10#1, %arg11, %arg12, %7, %0, %4, %arg9, %arg10, %arg11, %arg12) <{operandSegmentSizes = array<i32: 2, 2, 3, 2, 2>, resultSegmentSizes = array<i32: 0, 2, 0>, task_name = "Task_3"}> ({
    ^bb0(%arg162: memref<?x256xi32>, %arg163: memref<?x256xi32>, %arg164: memref<?x256xi32>, %arg165: memref<?x256xi32>, %arg166: index, %arg167: i32, %arg168: i32):
      %281 = "arith.constant"() <{value = 32 : index}> : () -> index
      %282 = "arith.constant"() <{value = 0 : index}> : () -> index
      %283 = "arith.constant"() <{value = 1 : index}> : () -> index
      %284 = "taskflow.counter"(%282, %arg166, %283) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %285 = "taskflow.counter"(%284, %282, %281, %283) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%284, %285) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg169: index, %arg170: index):
        %286 = "arith.index_cast"(%arg169) : (index) -> i32
        %287 = "arith.subi"(%arg167, %286) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %288 = "arith.cmpi"(%286, %287) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %289 = "arith.select"(%288, %286, %287) : (i1, i32, i32) -> i32
        %290 = "arith.addi"(%289, %arg168) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %291 = "memref.load"(%arg162, %arg170, %arg169) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %292 = "arith.muli"(%291, %290) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%292, %arg164, %arg170, %arg169) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        %293 = "memref.load"(%arg163, %arg170, %arg169) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %294 = "arith.muli"(%293, %290) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%294, %arg165, %arg170, %arg169) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg164, %arg165) <{operandSegmentSizes = array<i32: 0, 2, 0>}> : (memref<?x256xi32>, memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=2048\0Ainternal_multiplicity=1\0Asource_multiplicity=2048\0Aaxis_count=2\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,32,1,32,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 2048 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 2048 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> (memref<?x256xi32>, memref<?x256xi32>)
    %12 = "taskflow.task"(%11#0, %arg3, %11#1, %arg4, %arg13, %7, %2, %arg11, %arg3, %arg12, %arg4, %arg13) <{operandSegmentSizes = array<i32: 4, 1, 2, 4, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_4"}> ({
    ^bb0(%arg151: memref<?x256xi32>, %arg152: memref<?x256xi32>, %arg153: memref<?x256xi32>, %arg154: memref<?x256xi32>, %arg155: memref<?x256xi32>, %arg156: index, %arg157: i32):
      %264 = "arith.constant"() <{value = 32 : index}> : () -> index
      %265 = "arith.constant"() <{value = 0 : index}> : () -> index
      %266 = "arith.constant"() <{value = 1 : index}> : () -> index
      %267 = "taskflow.counter"(%265, %arg156, %266) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %268 = "taskflow.counter"(%267, %265, %264, %266) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %269 = "taskflow.counter"(%268, %265, %arg156, %266) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %270 = "taskflow.hyperblock"(%267, %268, %269, %arg157) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg158: index, %arg159: index, %arg160: index, %arg161: i32):
        %271 = "memref.load"(%arg151, %arg159, %arg160) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %272 = "memref.load"(%arg152, %arg158, %arg160) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %273 = "arith.muli"(%271, %272) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %274 = "arith.addi"(%arg161, %273) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %275 = "memref.load"(%arg153, %arg159, %arg160) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %276 = "memref.load"(%arg154, %arg158, %arg160) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %277 = "arith.muli"(%275, %276) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %278 = "arith.subi"(%274, %277) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %279 = "arith.addi"(%arg160, %266) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %280 = "arith.cmpi"(%279, %arg156) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%280) ({
          "memref.store"(%278, %arg155, %arg159, %arg158) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%278, %278) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg155) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=131072\0Ainternal_multiplicity=1\0Asource_multiplicity=131072\0Aaxis_count=3\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,32,1,32,0,-1,0,0\0Aaxis=T,2,0,64,1,64,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 131072 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 131072 : i64}} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %13 = "taskflow.task"(%11#0, %arg4, %11#1, %arg3, %arg14, %7, %2, %arg11, %arg4, %arg12, %arg3, %arg14) <{operandSegmentSizes = array<i32: 4, 1, 2, 4, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_5"}> ({
    ^bb0(%arg140: memref<?x256xi32>, %arg141: memref<?x256xi32>, %arg142: memref<?x256xi32>, %arg143: memref<?x256xi32>, %arg144: memref<?x256xi32>, %arg145: index, %arg146: i32):
      %247 = "arith.constant"() <{value = 32 : index}> : () -> index
      %248 = "arith.constant"() <{value = 0 : index}> : () -> index
      %249 = "arith.constant"() <{value = 1 : index}> : () -> index
      %250 = "taskflow.counter"(%248, %arg145, %249) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %251 = "taskflow.counter"(%250, %248, %247, %249) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %252 = "taskflow.counter"(%251, %248, %arg145, %249) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %253 = "taskflow.hyperblock"(%250, %251, %252, %arg146) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg147: index, %arg148: index, %arg149: index, %arg150: i32):
        %254 = "memref.load"(%arg140, %arg148, %arg149) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %255 = "memref.load"(%arg141, %arg147, %arg149) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %256 = "arith.muli"(%254, %255) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %257 = "arith.addi"(%arg150, %256) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %258 = "memref.load"(%arg142, %arg148, %arg149) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %259 = "memref.load"(%arg143, %arg147, %arg149) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %260 = "arith.muli"(%258, %259) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %261 = "arith.addi"(%257, %260) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %262 = "arith.addi"(%arg149, %249) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %263 = "arith.cmpi"(%262, %arg145) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%263) ({
          "memref.store"(%261, %arg144, %arg148, %arg147) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%261, %261) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg144) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=131072\0Ainternal_multiplicity=1\0Asource_multiplicity=131072\0Aaxis_count=3\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,32,1,32,0,-1,0,0\0Aaxis=T,2,0,64,1,64,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 131072 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 131072 : i64}} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %14 = "taskflow.task"(%12, %arg15, %7, %2, %3, %arg13, %arg15) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_6"}> ({
    ^bb0(%arg132: memref<?x256xi32>, %arg133: memref<?xi32>, %arg134: index, %arg135: i32, %arg136: i32):
      %236 = "arith.constant"() <{value = 32 : index}> : () -> index
      %237 = "arith.constant"() <{value = 0 : index}> : () -> index
      %238 = "arith.constant"() <{value = 1 : index}> : () -> index
      %239 = "taskflow.counter"(%237, %arg134, %238) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %240 = "taskflow.counter"(%239, %237, %236, %238) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %241 = "taskflow.hyperblock"(%239, %240, %arg135) <{operandSegmentSizes = array<i32: 2, 1>}> ({
      ^bb0(%arg137: index, %arg138: index, %arg139: i32):
        %242 = "memref.load"(%arg132, %arg138, %arg137) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %243 = "arith.addi"(%arg139, %242) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %244 = "arith.divsi"(%243, %arg136) : (i32, i32) -> i32
        %245 = "arith.addi"(%arg138, %238) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %246 = "arith.cmpi"(%245, %236) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%246) ({
          "memref.store"(%244, %arg133, %arg137) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%243, %243) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, i32) -> i32
      "taskflow.yield"(%arg133) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=2048\0Ainternal_multiplicity=1\0Asource_multiplicity=2048\0Aaxis_count=2\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,32,1,32,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 2048 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 2048 : i64}} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32, memref<?x256xi32>, memref<?xi32>) -> memref<?xi32>
    %15 = "taskflow.task"(%13, %arg16, %7, %2, %3, %arg14, %arg16) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_7"}> ({
    ^bb0(%arg124: memref<?x256xi32>, %arg125: memref<?xi32>, %arg126: index, %arg127: i32, %arg128: i32):
      %225 = "arith.constant"() <{value = 32 : index}> : () -> index
      %226 = "arith.constant"() <{value = 0 : index}> : () -> index
      %227 = "arith.constant"() <{value = 1 : index}> : () -> index
      %228 = "taskflow.counter"(%226, %arg126, %227) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %229 = "taskflow.counter"(%228, %226, %225, %227) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %230 = "taskflow.hyperblock"(%228, %229, %arg127) <{operandSegmentSizes = array<i32: 2, 1>}> ({
      ^bb0(%arg129: index, %arg130: index, %arg131: i32):
        %231 = "memref.load"(%arg124, %arg130, %arg129) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %232 = "arith.addi"(%arg131, %231) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %233 = "arith.divsi"(%232, %arg128) : (i32, i32) -> i32
        %234 = "arith.addi"(%arg130, %227) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %235 = "arith.cmpi"(%234, %225) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%235) ({
          "memref.store"(%233, %arg125, %arg129) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%232, %232) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, i32) -> i32
      "taskflow.yield"(%arg125) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=2048\0Ainternal_multiplicity=1\0Asource_multiplicity=2048\0Aaxis_count=2\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,32,1,32,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 2048 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 2048 : i64}} : (memref<?x256xi32>, memref<?xi32>, index, i32, i32, memref<?x256xi32>, memref<?xi32>) -> memref<?xi32>
    %16:2 = "taskflow.task"(%12, %14, %13, %15, %arg17, %arg18, %7, %arg13, %arg15, %arg14, %arg16, %arg17, %arg18) <{operandSegmentSizes = array<i32: 4, 2, 1, 4, 2>, resultSegmentSizes = array<i32: 0, 2, 0>, task_name = "Task_8"}> ({
    ^bb0(%arg115: memref<?x256xi32>, %arg116: memref<?xi32>, %arg117: memref<?x256xi32>, %arg118: memref<?xi32>, %arg119: memref<?x256xi32>, %arg120: memref<?x256xi32>, %arg121: index):
      %214 = "arith.constant"() <{value = 32 : index}> : () -> index
      %215 = "arith.constant"() <{value = 0 : index}> : () -> index
      %216 = "arith.constant"() <{value = 1 : index}> : () -> index
      %217 = "taskflow.counter"(%215, %arg121, %216) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %218 = "taskflow.counter"(%217, %215, %214, %216) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%217, %218) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg122: index, %arg123: index):
        %219 = "memref.load"(%arg115, %arg123, %arg122) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %220 = "memref.load"(%arg116, %arg122) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %221 = "arith.subi"(%219, %220) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%221, %arg119, %arg123, %arg122) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        %222 = "memref.load"(%arg117, %arg123, %arg122) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %223 = "memref.load"(%arg118, %arg122) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %224 = "arith.subi"(%222, %223) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%224, %arg120, %arg123, %arg122) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg119, %arg120) <{operandSegmentSizes = array<i32: 0, 2, 0>}> : (memref<?x256xi32>, memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=2048\0Ainternal_multiplicity=1\0Asource_multiplicity=2048\0Aaxis_count=2\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,32,1,32,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 2048 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 2048 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>, index, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?xi32>, memref<?x256xi32>, memref<?x256xi32>) -> (memref<?x256xi32>, memref<?x256xi32>)
    %17 = "taskflow.task"(%16#0, %arg5, %16#1, %arg6, %arg19, %7, %2, %arg17, %arg5, %arg18, %arg6, %arg19) <{operandSegmentSizes = array<i32: 4, 1, 2, 4, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_9"}> ({
    ^bb0(%arg104: memref<?x256xi32>, %arg105: memref<?x32xi32>, %arg106: memref<?x256xi32>, %arg107: memref<?x32xi32>, %arg108: memref<?x256xi32>, %arg109: index, %arg110: i32):
      %196 = "arith.constant"() <{value = 32 : index}> : () -> index
      %197 = "arith.constant"() <{value = 16 : index}> : () -> index
      %198 = "arith.constant"() <{value = 0 : index}> : () -> index
      %199 = "arith.constant"() <{value = 1 : index}> : () -> index
      %200 = "taskflow.counter"(%198, %arg109, %199) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %201 = "taskflow.counter"(%200, %198, %197, %199) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %202 = "taskflow.counter"(%201, %198, %196, %199) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %203 = "taskflow.hyperblock"(%200, %201, %202, %arg110) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg111: index, %arg112: index, %arg113: index, %arg114: i32):
        %204 = "memref.load"(%arg104, %arg113, %arg111) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %205 = "memref.load"(%arg105, %arg112, %arg113) <{nontemporal = false}> : (memref<?x32xi32>, index, index) -> i32
        %206 = "arith.muli"(%204, %205) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %207 = "arith.addi"(%arg114, %206) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %208 = "memref.load"(%arg106, %arg113, %arg111) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %209 = "memref.load"(%arg107, %arg112, %arg113) <{nontemporal = false}> : (memref<?x32xi32>, index, index) -> i32
        %210 = "arith.muli"(%208, %209) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %211 = "arith.subi"(%207, %210) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %212 = "arith.addi"(%arg113, %199) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %213 = "arith.cmpi"(%212, %196) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%213) ({
          "memref.store"(%211, %arg108, %arg112, %arg111) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%211, %211) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg108) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=32768\0Ainternal_multiplicity=1\0Asource_multiplicity=32768\0Aaxis_count=3\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,32,1,32,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 32768 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 32768 : i64}} : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %18 = "taskflow.task"(%16#0, %arg6, %16#1, %arg5, %arg20, %7, %2, %arg17, %arg6, %arg18, %arg5, %arg20) <{operandSegmentSizes = array<i32: 4, 1, 2, 4, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_10"}> ({
    ^bb0(%arg93: memref<?x256xi32>, %arg94: memref<?x32xi32>, %arg95: memref<?x256xi32>, %arg96: memref<?x32xi32>, %arg97: memref<?x256xi32>, %arg98: index, %arg99: i32):
      %178 = "arith.constant"() <{value = 32 : index}> : () -> index
      %179 = "arith.constant"() <{value = 16 : index}> : () -> index
      %180 = "arith.constant"() <{value = 0 : index}> : () -> index
      %181 = "arith.constant"() <{value = 1 : index}> : () -> index
      %182 = "taskflow.counter"(%180, %arg98, %181) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %183 = "taskflow.counter"(%182, %180, %179, %181) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %184 = "taskflow.counter"(%183, %180, %178, %181) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %185 = "taskflow.hyperblock"(%182, %183, %184, %arg99) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg100: index, %arg101: index, %arg102: index, %arg103: i32):
        %186 = "memref.load"(%arg93, %arg102, %arg100) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %187 = "memref.load"(%arg94, %arg101, %arg102) <{nontemporal = false}> : (memref<?x32xi32>, index, index) -> i32
        %188 = "arith.muli"(%186, %187) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %189 = "arith.addi"(%arg103, %188) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %190 = "memref.load"(%arg95, %arg102, %arg100) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %191 = "memref.load"(%arg96, %arg101, %arg102) <{nontemporal = false}> : (memref<?x32xi32>, index, index) -> i32
        %192 = "arith.muli"(%190, %191) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %193 = "arith.addi"(%189, %192) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %194 = "arith.addi"(%arg102, %181) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %195 = "arith.cmpi"(%194, %178) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%195) ({
          "memref.store"(%193, %arg97, %arg101, %arg100) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%193, %193) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg97) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 32 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 32 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=32768\0Ainternal_multiplicity=1\0Asource_multiplicity=32768\0Aaxis_count=3\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Aaxis=T,2,0,32,1,32,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 32768 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 32768 : i64}} : (memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>, memref<?x32xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %19 = "taskflow.task"(%17, %18, %arg21, %7, %2, %arg19, %arg20, %arg21) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_11"}> ({
    ^bb0(%arg86: memref<?x256xi32>, %arg87: memref<?x256xi32>, %arg88: memref<?x256xi32>, %arg89: index, %arg90: i32):
      %158 = "arith.constant"() <{value = 16 : index}> : () -> index
      %159 = "arith.constant"() <{value = 0 : index}> : () -> index
      %160 = "arith.constant"() <{value = 1 : index}> : () -> index
      %161 = "taskflow.counter"(%159, %arg89, %160) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %162 = "taskflow.counter"(%161, %159, %158, %160) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%161, %162) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg91: index, %arg92: index):
        %163 = "memref.load"(%arg86, %arg92, %arg91) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %164 = "memref.load"(%arg87, %arg92, %arg91) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %165 = "arith.cmpi"(%163, %arg90) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %166 = "arith.extui"(%165) : (i1) -> i32
        %167 = "arith.cmpi"(%164, %arg90) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %168 = "arith.extui"(%167) : (i1) -> i32
        %169 = "arith.subi"(%arg90, %163) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %170 = "arith.subi"(%169, %163) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %171 = "arith.muli"(%166, %170) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %172 = "arith.addi"(%163, %171) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %173 = "arith.subi"(%arg90, %164) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %174 = "arith.subi"(%173, %164) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %175 = "arith.muli"(%168, %174) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %176 = "arith.addi"(%164, %175) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %177 = "arith.addi"(%172, %176) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%177, %arg88, %arg92, %arg91) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg88) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 64 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 64 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=1024\0Ainternal_multiplicity=1\0Asource_multiplicity=1024\0Aaxis_count=2\0Aaxis=T,0,0,64,1,64,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 1024 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 1024 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %20 = "taskflow.task"(%19, %arg22, %7, %arg21, %arg22) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_12"}> ({
    ^bb0(%arg81: memref<?x256xi32>, %arg82: memref<?x256xi32>, %arg83: index):
      %138 = "arith.constant"() <{value = -1 : index}> : () -> index
      %139 = "arith.constant"() <{value = 16 : index}> : () -> index
      %140 = "arith.constant"() <{value = 0 : index}> : () -> index
      %141 = "arith.constant"() <{value = 1 : index}> : () -> index
      %142 = "arith.constant"() <{value = 2 : index}> : () -> index
      %143 = "arith.constant"() <{value = -2 : index}> : () -> index
      %144 = "arith.addi"(%arg83, %143) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %145 = "taskflow.counter"(%142, %144, %141) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %146 = "taskflow.counter"(%145, %140, %139, %141) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%145, %146) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg84: index, %arg85: index):
        %147 = "arith.addi"(%arg84, %143) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %148 = "memref.load"(%arg81, %arg85, %147) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %149 = "arith.addi"(%arg84, %138) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %150 = "memref.load"(%arg81, %arg85, %149) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %151 = "arith.addi"(%148, %150) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %152 = "arith.addi"(%arg84, %141) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %153 = "memref.load"(%arg81, %arg85, %152) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %154 = "arith.addi"(%151, %153) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %155 = "arith.addi"(%arg84, %142) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %156 = "memref.load"(%arg81, %arg85, %155) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %157 = "arith.addi"(%154, %156) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%157, %arg82, %arg85, %arg84) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg82) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 16 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 16 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=960\0Ainternal_multiplicity=1\0Asource_multiplicity=960\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,0,16,1,16,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 960 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 960 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, index, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %21 = "taskflow.task"(%19, %arg23, %7, %arg21, %arg23) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_13"}> ({
    ^bb0(%arg76: memref<?x256xi32>, %arg77: memref<?x256xi32>, %arg78: index):
      %125 = "arith.constant"() <{value = -1 : index}> : () -> index
      %126 = "arith.constant"() <{value = 15 : index}> : () -> index
      %127 = "arith.constant"() <{value = 1 : index}> : () -> index
      %128 = "arith.constant"() <{value = 2 : index}> : () -> index
      %129 = "arith.constant"() <{value = -2 : index}> : () -> index
      %130 = "arith.addi"(%arg78, %129) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %131 = "taskflow.counter"(%128, %130, %127) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %132 = "taskflow.counter"(%131, %127, %126, %127) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%131, %132) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg79: index, %arg80: index):
        %133 = "arith.addi"(%arg80, %125) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %134 = "memref.load"(%arg76, %133, %arg79) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %135 = "arith.addi"(%arg80, %127) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %136 = "memref.load"(%arg76, %135, %arg79) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %137 = "arith.addi"(%134, %136) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%137, %arg77, %arg80, %arg79) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg77) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, index, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %22 = "taskflow.task"(%20, %21, %arg24, %7, %arg22, %arg23, %arg24) <{operandSegmentSizes = array<i32: 2, 1, 1, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_14"}> ({
    ^bb0(%arg70: memref<?x256xi32>, %arg71: memref<?x256xi32>, %arg72: memref<?x256xi32>, %arg73: index):
      %115 = "arith.constant"() <{value = 15 : index}> : () -> index
      %116 = "arith.constant"() <{value = 1 : index}> : () -> index
      %117 = "arith.constant"() <{value = 2 : index}> : () -> index
      %118 = "arith.constant"() <{value = -2 : index}> : () -> index
      %119 = "arith.addi"(%arg73, %118) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %120 = "taskflow.counter"(%117, %119, %116) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %121 = "taskflow.counter"(%120, %116, %115, %116) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%120, %121) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg74: index, %arg75: index):
        %122 = "memref.load"(%arg70, %arg75, %arg74) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %123 = "memref.load"(%arg71, %arg75, %arg74) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %124 = "arith.addi"(%122, %123) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%124, %arg72, %arg75, %arg74) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg72) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %23 = "taskflow.task"(%22, %arg25, %7, %5, %6, %arg24, %arg25) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_15"}> ({
    ^bb0(%arg63: memref<?x256xi32>, %arg64: memref<?x256xi32>, %arg65: index, %arg66: i32, %arg67: i32):
      %105 = "arith.constant"() <{value = 15 : index}> : () -> index
      %106 = "arith.constant"() <{value = 1 : index}> : () -> index
      %107 = "arith.constant"() <{value = 2 : index}> : () -> index
      %108 = "arith.constant"() <{value = -2 : index}> : () -> index
      %109 = "arith.addi"(%arg65, %108) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %110 = "taskflow.counter"(%107, %109, %106) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %111 = "taskflow.counter"(%110, %106, %105, %106) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%110, %111) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg68: index, %arg69: index):
        %112 = "memref.load"(%arg63, %arg69, %arg68) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %113 = "arith.divsi"(%112, %arg66) : (i32, i32) -> i32
        %114 = "arith.muli"(%113, %arg67) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%114, %arg64, %arg69, %arg68) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg64) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, index, i32, i32, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %24 = "taskflow.task"(%19, %23, %arg26, %7, %arg21, %arg25, %arg26) <{operandSegmentSizes = array<i32: 2, 1, 1, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_16"}> ({
    ^bb0(%arg57: memref<?x256xi32>, %arg58: memref<?x256xi32>, %arg59: memref<?x256xi32>, %arg60: index):
      %94 = "arith.constant"() <{value = 15 : index}> : () -> index
      %95 = "arith.constant"() <{value = 1 : index}> : () -> index
      %96 = "arith.constant"() <{value = 2 : index}> : () -> index
      %97 = "arith.constant"() <{value = -2 : index}> : () -> index
      %98 = "arith.addi"(%arg60, %97) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %99 = "taskflow.counter"(%96, %98, %95) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %100 = "taskflow.counter"(%99, %95, %94, %95) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%99, %100) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg61: index, %arg62: index):
        %101 = "memref.load"(%arg57, %arg62, %arg61) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %102 = "memref.load"(%arg58, %arg62, %arg61) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %103 = "arith.cmpi"(%101, %102) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %104 = "arith.extui"(%103) : (i1) -> i32
        "memref.store"(%104, %arg59, %arg62, %arg61) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg59) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %25 = "taskflow.task"(%19, %24, %arg27, %7, %arg21, %arg26, %arg27) <{operandSegmentSizes = array<i32: 2, 1, 1, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_17"}> ({
    ^bb0(%arg51: memref<?x256xi32>, %arg52: memref<?x256xi32>, %arg53: memref<?x256xi32>, %arg54: index):
      %73 = "arith.constant"() <{value = -1 : index}> : () -> index
      %74 = "arith.constant"() <{value = 15 : index}> : () -> index
      %75 = "arith.constant"() <{value = 1 : index}> : () -> index
      %76 = "arith.constant"() <{value = 2 : index}> : () -> index
      %77 = "arith.constant"() <{value = -2 : index}> : () -> index
      %78 = "arith.addi"(%arg54, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %79 = "taskflow.counter"(%76, %78, %75) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %80 = "taskflow.counter"(%79, %75, %74, %75) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%79, %80) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg55: index, %arg56: index):
        %81 = "memref.load"(%arg51, %arg56, %arg55) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %82 = "arith.addi"(%arg55, %73) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %83 = "memref.load"(%arg51, %arg56, %82) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %84 = "arith.cmpi"(%81, %83) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %85 = "arith.extui"(%84) : (i1) -> i32
        %86 = "arith.addi"(%arg55, %75) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %87 = "memref.load"(%arg51, %arg56, %86) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %88 = "arith.cmpi"(%81, %87) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %89 = "arith.extui"(%88) : (i1) -> i32
        %90 = "arith.muli"(%85, %89) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %91 = "memref.load"(%arg52, %arg56, %arg55) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %92 = "arith.muli"(%91, %90) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %93 = "arith.muli"(%92, %81) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%93, %arg53, %arg56, %arg55) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg53) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %26 = "taskflow.task"(%25, %19, %arg28, %7, %2, %arg27, %arg21, %arg28) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_18"}> ({
    ^bb0(%arg44: memref<?x256xi32>, %arg45: memref<?x256xi32>, %arg46: memref<?x256xi32>, %arg47: index, %arg48: i32):
      %51 = "arith.constant"() <{value = -1 : index}> : () -> index
      %52 = "arith.constant"() <{value = 15 : index}> : () -> index
      %53 = "arith.constant"() <{value = 1 : index}> : () -> index
      %54 = "arith.constant"() <{value = 2 : index}> : () -> index
      %55 = "arith.constant"() <{value = -2 : index}> : () -> index
      %56 = "arith.addi"(%arg47, %55) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %57 = "taskflow.counter"(%54, %56, %53) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %58 = "taskflow.counter"(%57, %53, %52, %53) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%57, %58) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg49: index, %arg50: index):
        %59 = "memref.load"(%arg44, %arg50, %arg49) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %60 = "arith.cmpi"(%59, %arg48) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %61 = "arith.extui"(%60) : (i1) -> i32
        %62 = "arith.addi"(%arg50, %51) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %63 = "memref.load"(%arg45, %62, %arg49) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %64 = "arith.cmpi"(%59, %63) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %65 = "arith.extui"(%64) : (i1) -> i32
        %66 = "arith.addi"(%arg50, %53) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %67 = "memref.load"(%arg45, %66, %arg49) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %68 = "arith.cmpi"(%59, %67) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %69 = "arith.extui"(%68) : (i1) -> i32
        %70 = "arith.muli"(%61, %65) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %71 = "arith.muli"(%70, %69) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %72 = "arith.muli"(%71, %59) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%72, %arg46, %arg50, %arg49) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg46) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %27 = "taskflow.task"(%26, %arg29, %7, %2, %arg28, %arg29) <{operandSegmentSizes = array<i32: 1, 1, 2, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_19"}> ({
    ^bb0(%arg38: memref<?x256xi32>, %arg39: memref<?x256xi32>, %arg40: index, %arg41: i32):
      %41 = "arith.constant"() <{value = 15 : index}> : () -> index
      %42 = "arith.constant"() <{value = 1 : index}> : () -> index
      %43 = "arith.constant"() <{value = 2 : index}> : () -> index
      %44 = "arith.constant"() <{value = -2 : index}> : () -> index
      %45 = "arith.addi"(%arg40, %44) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %46 = "taskflow.counter"(%43, %45, %42) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %47 = "taskflow.counter"(%46, %42, %41, %42) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%46, %47) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg42: index, %arg43: index):
        %48 = "memref.load"(%arg38, %arg43, %arg42) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %49 = "arith.cmpi"(%48, %arg41) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %50 = "arith.extui"(%49) : (i1) -> i32
        "memref.store"(%50, %arg39, %arg43, %arg42) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg39) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x256xi32>, memref<?x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    %28 = "taskflow.task"(%26, %arg30, %7, %2, %arg28, %arg30) <{operandSegmentSizes = array<i32: 1, 1, 2, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_20"}> ({
    ^bb0(%arg31: memref<?x256xi32>, %arg32: memref<?xi32>, %arg33: index, %arg34: i32):
      %29 = "arith.constant"() <{value = 15 : index}> : () -> index
      %30 = "arith.constant"() <{value = 1 : index}> : () -> index
      %31 = "arith.constant"() <{value = 2 : index}> : () -> index
      %32 = "arith.constant"() <{value = -2 : index}> : () -> index
      %33 = "arith.addi"(%arg33, %32) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
      %34 = "taskflow.counter"(%31, %33, %30) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %35 = "taskflow.counter"(%34, %30, %29, %30) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %36 = "taskflow.hyperblock"(%34, %35, %arg34) <{operandSegmentSizes = array<i32: 2, 1>}> ({
      ^bb0(%arg35: index, %arg36: index, %arg37: i32):
        %37 = "memref.load"(%arg31, %arg36, %arg35) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %38 = "arith.addi"(%arg37, %37) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %39 = "arith.addi"(%arg36, %30) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %40 = "arith.cmpi"(%39, %29) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%40) ({
          "memref.store"(%38, %arg32, %arg35) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%38, %38) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, i32) -> i32
      "taskflow.yield"(%arg32) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 60 : i64, kind = "taskflow-counter", lower = 2 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 62 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 14 : i64, kind = "taskflow-counter", lower = 1 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 15 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=840\0Ainternal_multiplicity=1\0Asource_multiplicity=840\0Aaxis_count=2\0Aaxis=T,0,2,62,1,60,0,-1,0,0\0Aaxis=T,1,1,15,1,14,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 840 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 840 : i64}} : (memref<?x256xi32>, memref<?xi32>, index, i32, memref<?x256xi32>, memref<?xi32>) -> memref<?xi32>
    "func.return"() : () -> ()
  }) {amoeba.input0_caller_evidence_path = "/home/shiran/project/orbit-artifact/reference/input0-source-domains/callers/radar.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "/home/shiran/project/orbit-repair-study/full_prepared-v4/radar/taskflow-affine.mlir", amoeba.input0_caller_static_bound = 64 : i64, amoeba.static_bound.arg.0 = 64 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) : () -> ()

