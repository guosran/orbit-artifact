"builtin.module"() ({
  "func.func"() <{arg_attrs = [{}, {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 256, 256>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 512, 256>, amoeba.noalias}], function_type = (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> (), sym_name = "_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?x256xi32>, %arg2: memref<?x256xi32>, %arg3: memref<?x256xi32>, %arg4: memref<?x256xi32>, %arg5: memref<?x256xi32>, %arg6: memref<?x256xi32>, %arg7: memref<?x256xi32>, %arg8: memref<?x256xi32>):
    %0 = "arith.constant"() <{value = 320 : index}> : () -> index
    %1 = "arith.constant"() <{value = 1024 : i32}> : () -> i32
    %2 = "arith.constant"() <{value = 1 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %4 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %5 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %6 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %7 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512xi32>
    %8 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x512xi32>
    %9 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x512xi32>
    %10 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %11 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %12 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %13 = "taskflow.task"(%arg1, %arg2, %12, %0, %3, %arg1, %arg2, %12) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_0"}> ({
    ^bb0(%arg87: memref<?x256xi32>, %arg88: memref<?x256xi32>, %arg89: memref<512x256xi32>, %arg90: index, %arg91: i32):
      %124 = "arith.constant"() <{value = 256 : index}> : () -> index
      %125 = "arith.constant"() <{value = 0 : index}> : () -> index
      %126 = "arith.constant"() <{value = 1 : index}> : () -> index
      %127 = "taskflow.counter"(%125, %arg90, %126) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %128 = "taskflow.counter"(%127, %125, %124, %126) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %129 = "taskflow.counter"(%128, %125, %124, %126) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %130 = "taskflow.hyperblock"(%127, %128, %129, %arg91) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg92: index, %arg93: index, %arg94: index, %arg95: i32):
        %131 = "arith.cmpi"(%arg94, %125) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%131) ({
          "memref.store"(%arg91, %arg89, %arg92, %arg93) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %132 = "memref.load"(%arg87, %arg92, %arg94) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %133 = "memref.load"(%arg88, %arg94, %arg93) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %134 = "arith.muli"(%132, %133) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %135 = "arith.addi"(%arg95, %134) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%135, %arg89, %arg92, %arg93) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"(%135, %135) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg89) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<512x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=20971520\0Ainternal_multiplicity=1\0Asource_multiplicity=20971520\0Aaxis_count=3\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,256,1,256,0,-1,0,0\0Aaxis=T,2,0,256,1,256,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 20971520 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 20971520 : i64}} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>) -> memref<512x256xi32>
    %14 = "taskflow.task"(%arg1, %arg3, %11, %0, %3, %arg1, %arg3, %11) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_1"}> ({
    ^bb0(%arg78: memref<?x256xi32>, %arg79: memref<?x256xi32>, %arg80: memref<512x256xi32>, %arg81: index, %arg82: i32):
      %112 = "arith.constant"() <{value = 256 : index}> : () -> index
      %113 = "arith.constant"() <{value = 0 : index}> : () -> index
      %114 = "arith.constant"() <{value = 1 : index}> : () -> index
      %115 = "taskflow.counter"(%113, %arg81, %114) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %116 = "taskflow.counter"(%115, %113, %112, %114) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %117 = "taskflow.counter"(%116, %113, %112, %114) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %118 = "taskflow.hyperblock"(%115, %116, %117, %arg82) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg83: index, %arg84: index, %arg85: index, %arg86: i32):
        %119 = "arith.cmpi"(%arg85, %113) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%119) ({
          "memref.store"(%arg82, %arg80, %arg83, %arg84) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %120 = "memref.load"(%arg78, %arg83, %arg85) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %121 = "memref.load"(%arg79, %arg85, %arg84) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %122 = "arith.muli"(%120, %121) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %123 = "arith.addi"(%arg86, %122) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%123, %arg80, %arg83, %arg84) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"(%123, %123) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg80) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<512x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=20971520\0Ainternal_multiplicity=1\0Asource_multiplicity=20971520\0Aaxis_count=3\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,256,1,256,0,-1,0,0\0Aaxis=T,2,0,256,1,256,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 20971520 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 20971520 : i64}} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>) -> memref<512x256xi32>
    %15 = "taskflow.task"(%arg1, %arg4, %10, %0, %3, %arg1, %arg4, %10) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_2"}> ({
    ^bb0(%arg69: memref<?x256xi32>, %arg70: memref<?x256xi32>, %arg71: memref<512x256xi32>, %arg72: index, %arg73: i32):
      %100 = "arith.constant"() <{value = 256 : index}> : () -> index
      %101 = "arith.constant"() <{value = 0 : index}> : () -> index
      %102 = "arith.constant"() <{value = 1 : index}> : () -> index
      %103 = "taskflow.counter"(%101, %arg72, %102) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %104 = "taskflow.counter"(%103, %101, %100, %102) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %105 = "taskflow.counter"(%104, %101, %100, %102) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %106 = "taskflow.hyperblock"(%103, %104, %105, %arg73) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg74: index, %arg75: index, %arg76: index, %arg77: i32):
        %107 = "arith.cmpi"(%arg76, %101) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%107) ({
          "memref.store"(%arg73, %arg71, %arg74, %arg75) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %108 = "memref.load"(%arg69, %arg74, %arg76) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %109 = "memref.load"(%arg70, %arg76, %arg75) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %110 = "arith.muli"(%108, %109) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %111 = "arith.addi"(%arg77, %110) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%111, %arg71, %arg74, %arg75) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"(%111, %111) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg71) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<512x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=20971520\0Ainternal_multiplicity=1\0Asource_multiplicity=20971520\0Aaxis_count=3\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,256,1,256,0,-1,0,0\0Aaxis=T,2,0,256,1,256,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 20971520 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 20971520 : i64}} : (memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, index, i32, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>) -> memref<512x256xi32>
    %16 = "taskflow.task"(%13, %14, %9, %0, %3, %12, %11, %9) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_3"}> ({
    ^bb0(%arg60: memref<512x256xi32>, %arg61: memref<512x256xi32>, %arg62: memref<512x512xi32>, %arg63: index, %arg64: i32):
      %88 = "arith.constant"() <{value = 256 : index}> : () -> index
      %89 = "arith.constant"() <{value = 0 : index}> : () -> index
      %90 = "arith.constant"() <{value = 1 : index}> : () -> index
      %91 = "taskflow.counter"(%89, %arg63, %90) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %92 = "taskflow.counter"(%91, %89, %arg63, %90) <{counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %93 = "taskflow.counter"(%92, %89, %88, %90) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %94 = "taskflow.hyperblock"(%91, %92, %93, %arg64) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg65: index, %arg66: index, %arg67: index, %arg68: i32):
        %95 = "arith.cmpi"(%arg67, %89) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%95) ({
          "memref.store"(%arg64, %arg62, %arg65, %arg66) <{nontemporal = false}> : (i32, memref<512x512xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %96 = "memref.load"(%arg60, %arg65, %arg67) <{nontemporal = false}> : (memref<512x256xi32>, index, index) -> i32
        %97 = "memref.load"(%arg61, %arg66, %arg67) <{nontemporal = false}> : (memref<512x256xi32>, index, index) -> i32
        %98 = "arith.muli"(%96, %97) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %99 = "arith.addi"(%arg68, %98) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%99, %arg62, %arg65, %arg66) <{nontemporal = false}> : (i32, memref<512x512xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"(%99, %99) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg62) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<512x512xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=26214400\0Ainternal_multiplicity=1\0Asource_multiplicity=26214400\0Aaxis_count=3\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,320,1,320,0,-1,0,0\0Aaxis=T,2,0,256,1,256,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 26214400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 26214400 : i64}} : (memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>, index, i32, memref<512x256xi32>, memref<512x256xi32>, memref<512x512xi32>) -> memref<512x512xi32>
    %17:2 = "taskflow.task"(%16, %7, %8, %0, %3, %2, %9, %7, %8) <{operandSegmentSizes = array<i32: 1, 2, 3, 1, 2>, resultSegmentSizes = array<i32: 0, 2, 0>, task_name = "Task_4"}> ({
    ^bb0(%arg51: memref<512x512xi32>, %arg52: memref<512xi32>, %arg53: memref<512x512xi32>, %arg54: index, %arg55: i32, %arg56: i32):
      %78 = "arith.constant"() <{value = 0 : index}> : () -> index
      %79 = "arith.constant"() <{value = 1 : index}> : () -> index
      %80 = "taskflow.counter"(%78, %arg54, %79) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %81 = "taskflow.counter"(%80, %78, %arg54, %79) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %82 = "taskflow.hyperblock"(%80, %81, %arg55) <{operandSegmentSizes = array<i32: 2, 1>}> ({
      ^bb0(%arg57: index, %arg58: index, %arg59: i32):
        %83 = "arith.cmpi"(%arg58, %78) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%83) ({
          "memref.store"(%arg55, %arg52, %arg57) <{nontemporal = false}> : (i32, memref<512xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %84 = "memref.load"(%arg51, %arg57, %arg58) <{nontemporal = false}> : (memref<512x512xi32>, index, index) -> i32
        %85 = "arith.muli"(%84, %84) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %86 = "arith.addi"(%85, %arg56) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%86, %arg53, %arg57, %arg58) <{nontemporal = false}> : (i32, memref<512x512xi32>, index, index) -> ()
        %87 = "arith.addi"(%arg59, %86) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%87, %arg52, %arg57) <{nontemporal = false}> : (i32, memref<512xi32>, index) -> ()
        "taskflow.hyperblock.yield"(%87, %87) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, i32) -> i32
      "taskflow.yield"(%arg52, %arg53) <{operandSegmentSizes = array<i32: 0, 2, 0>}> : (memref<512xi32>, memref<512x512xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=102400\0Ainternal_multiplicity=1\0Asource_multiplicity=102400\0Aaxis_count=2\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,320,1,320,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 102400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 102400 : i64}} : (memref<512x512xi32>, memref<512xi32>, memref<512x512xi32>, index, i32, i32, memref<512x512xi32>, memref<512xi32>, memref<512x512xi32>) -> (memref<512xi32>, memref<512x512xi32>)
    %18 = "taskflow.task"(%17#0, %17#1, %17#1, %0, %2, %1, %7, %8, %8) <{operandSegmentSizes = array<i32: 2, 1, 3, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_5"}> ({
    ^bb0(%arg43: memref<512xi32>, %arg44: memref<512x512xi32>, %arg45: memref<512x512xi32>, %arg46: index, %arg47: i32, %arg48: i32):
      %69 = "arith.constant"() <{value = 0 : index}> : () -> index
      %70 = "arith.constant"() <{value = 1 : index}> : () -> index
      %71 = "taskflow.counter"(%69, %arg46, %70) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %72 = "taskflow.counter"(%71, %69, %arg46, %70) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%71, %72) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg49: index, %arg50: index):
        %73 = "memref.load"(%arg43, %arg49) <{nontemporal = false}> : (memref<512xi32>, index) -> i32
        %74 = "arith.addi"(%73, %arg47) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %75 = "memref.load"(%arg45, %arg49, %arg50) <{nontemporal = false}> : (memref<512x512xi32>, index, index) -> i32
        %76 = "arith.muli"(%75, %arg48) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %77 = "arith.divsi"(%76, %74) : (i32, i32) -> i32
        "memref.store"(%77, %arg45, %arg49, %arg50) <{nontemporal = false}> : (i32, memref<512x512xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg45) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<512x512xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=102400\0Ainternal_multiplicity=1\0Asource_multiplicity=102400\0Aaxis_count=2\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,320,1,320,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 102400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 102400 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<512xi32>, memref<512x512xi32>, memref<512x512xi32>, index, i32, i32, memref<512xi32>, memref<512x512xi32>, memref<512x512xi32>) -> memref<512x512xi32>
    %19 = "taskflow.task"(%18, %15, %6, %6, %0, %3, %1, %8, %10, %6, %6) <{operandSegmentSizes = array<i32: 3, 1, 3, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_6"}> ({
    ^bb0(%arg32: memref<512x512xi32>, %arg33: memref<512x256xi32>, %arg34: memref<512x256xi32>, %arg35: memref<512x256xi32>, %arg36: index, %arg37: i32, %arg38: i32):
      %53 = "arith.constant"() <{value = 256 : index}> : () -> index
      %54 = "arith.constant"() <{value = 0 : index}> : () -> index
      %55 = "arith.constant"() <{value = 1 : index}> : () -> index
      %56 = "taskflow.counter"(%54, %arg36, %55) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %57 = "taskflow.counter"(%56, %54, %53, %55) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %58 = "taskflow.counter"(%57, %54, %arg36, %55) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %59 = "taskflow.hyperblock"(%56, %57, %58, %arg37) <{operandSegmentSizes = array<i32: 3, 1>}> ({
      ^bb0(%arg39: index, %arg40: index, %arg41: index, %arg42: i32):
        %60 = "arith.cmpi"(%arg41, %54) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%60) ({
          "memref.store"(%arg37, %arg35, %arg39, %arg40) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %61 = "memref.load"(%arg32, %arg39, %arg41) <{nontemporal = false}> : (memref<512x512xi32>, index, index) -> i32
        %62 = "memref.load"(%arg33, %arg41, %arg40) <{nontemporal = false}> : (memref<512x256xi32>, index, index) -> i32
        %63 = "arith.muli"(%61, %62) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %64 = "arith.addi"(%arg42, %63) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%64, %arg35, %arg39, %arg40) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
        %65 = "memref.load"(%arg35, %arg39, %arg40) <{nontemporal = false}> : (memref<512x256xi32>, index, index) -> i32
        %66 = "arith.divsi"(%65, %arg38) : (i32, i32) -> i32
        %67 = "arith.addi"(%arg41, %55) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %68 = "arith.cmpi"(%67, %arg36) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%68) ({
          "memref.store"(%66, %arg35, %arg39, %arg40) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"(%64, %64) <{operandSegmentSizes = array<i32: 1, 1>}> : (i32, i32) -> ()
      }) : (index, index, index, i32) -> i32
      "taskflow.yield"(%arg35) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<512x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=26214400\0Ainternal_multiplicity=1\0Asource_multiplicity=26214400\0Aaxis_count=3\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,256,1,256,0,-1,0,0\0Aaxis=T,2,0,320,1,320,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 26214400 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 26214400 : i64}} : (memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32, i32, memref<512x512xi32>, memref<512x256xi32>, memref<512x256xi32>, memref<512x256xi32>) -> memref<512x256xi32>
    %20:2 = "taskflow.task"(%19, %arg5, %arg6, %5, %4, %0, %3, %6, %arg5, %arg6, %5, %4) <{operandSegmentSizes = array<i32: 3, 2, 2, 3, 2>, resultSegmentSizes = array<i32: 0, 2, 0>, task_name = "Task_7"}> ({
    ^bb0(%arg20: memref<512x256xi32>, %arg21: memref<?x256xi32>, %arg22: memref<?x256xi32>, %arg23: memref<512x256xi32>, %arg24: memref<512x256xi32>, %arg25: index, %arg26: i32):
      %38 = "arith.constant"() <{value = 256 : index}> : () -> index
      %39 = "arith.constant"() <{value = 0 : index}> : () -> index
      %40 = "arith.constant"() <{value = 1 : index}> : () -> index
      %41 = "taskflow.counter"(%39, %arg25, %40) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %42 = "taskflow.counter"(%41, %39, %38, %40) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %43 = "taskflow.counter"(%42, %39, %38, %40) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      %44:2 = "taskflow.hyperblock"(%41, %42, %43, %arg26, %arg26) <{operandSegmentSizes = array<i32: 3, 2>}> ({
      ^bb0(%arg27: index, %arg28: index, %arg29: index, %arg30: i32, %arg31: i32):
        %45 = "arith.cmpi"(%arg29, %39) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%45) ({
          "memref.store"(%arg26, %arg23, %arg27, %arg28) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
          "memref.store"(%arg26, %arg24, %arg27, %arg28) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %46 = "memref.load"(%arg20, %arg27, %arg29) <{nontemporal = false}> : (memref<512x256xi32>, index, index) -> i32
        %47 = "memref.load"(%arg21, %arg29, %arg28) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %48 = "arith.muli"(%46, %47) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %49 = "arith.addi"(%arg31, %48) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%49, %arg23, %arg27, %arg28) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
        %50 = "memref.load"(%arg22, %arg29, %arg28) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %51 = "arith.muli"(%46, %50) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %52 = "arith.addi"(%arg30, %51) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%52, %arg24, %arg27, %arg28) <{nontemporal = false}> : (i32, memref<512x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"(%52, %49, %52, %49) <{operandSegmentSizes = array<i32: 2, 2>}> : (i32, i32, i32, i32) -> ()
      }) : (index, index, index, i32, i32) -> (i32, i32)
      "taskflow.yield"(%arg23, %arg24) <{operandSegmentSizes = array<i32: 0, 2, 0>}> : (memref<512x256xi32>, memref<512x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=20971520\0Ainternal_multiplicity=1\0Asource_multiplicity=20971520\0Aaxis_count=3\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,256,1,256,0,-1,0,0\0Aaxis=T,2,0,256,1,256,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 20971520 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 20971520 : i64}} : (memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, memref<512x256xi32>, index, i32, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<512x256xi32>, memref<512x256xi32>) -> (memref<512x256xi32>, memref<512x256xi32>)
    %21 = "taskflow.task"(%20#0, %20#1, %arg7, %arg8, %arg8, %0, %3, %2, %5, %4, %arg7, %arg8, %arg8) <{operandSegmentSizes = array<i32: 4, 1, 3, 4, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_8"}> ({
    ^bb0(%arg9: memref<512x256xi32>, %arg10: memref<512x256xi32>, %arg11: memref<?x256xi32>, %arg12: memref<?x256xi32>, %arg13: memref<?x256xi32>, %arg14: index, %arg15: i32, %arg16: i32):
      %22 = "arith.constant"() <{value = 256 : index}> : () -> index
      %23 = "arith.constant"() <{value = 0 : index}> : () -> index
      %24 = "arith.constant"() <{value = 1 : index}> : () -> index
      %25 = "taskflow.counter"(%23, %arg14, %24) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %26 = "taskflow.counter"(%25, %23, %22, %24) <{counter_dynamism = "constant_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %27 = "taskflow.counter"(%26, %23, %22, %24) <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%25, %26, %27) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg17: index, %arg18: index, %arg19: index):
        %28 = "arith.cmpi"(%arg19, %23) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%28) ({
          "memref.store"(%arg15, %arg13, %arg17, %arg18) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %29 = "memref.load"(%arg9, %arg17, %arg19) <{nontemporal = false}> : (memref<512x256xi32>, index, index) -> i32
        %30 = "arith.addi"(%29, %arg16) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %31 = "arith.muli"(%29, %30) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %32 = "memref.load"(%arg10, %arg17, %arg19) <{nontemporal = false}> : (memref<512x256xi32>, index, index) -> i32
        %33 = "arith.muli"(%31, %32) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %34 = "memref.load"(%arg11, %arg19, %arg18) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %35 = "arith.muli"(%33, %34) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %36 = "memref.load"(%arg13, %arg17, %arg18) <{nontemporal = false}> : (memref<?x256xi32>, index, index) -> i32
        %37 = "arith.addi"(%36, %35) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%37, %arg13, %arg17, %arg18) <{nontemporal = false}> : (i32, memref<?x256xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg13) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x256xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 320 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 320 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 256 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 256 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=20971520\0Ainternal_multiplicity=1\0Asource_multiplicity=20971520\0Aaxis_count=3\0Aaxis=T,0,0,320,1,320,0,-1,0,0\0Aaxis=T,1,0,256,1,256,0,-1,0,0\0Aaxis=T,2,0,256,1,256,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 20971520 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 20971520 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, index, i32, i32, memref<512x256xi32>, memref<512x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> memref<?x256xi32>
    "func.return"() : () -> ()
  }) {amoeba.input0_caller_evidence_path = "/home/shiran/project/orbit-artifact/reference/input0-source-domains/callers/llama.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "/home/shiran/project/orbit-repair-study/full_prepared-v4/llama/taskflow-affine.mlir", amoeba.input0_caller_static_bound = 320 : i64, amoeba.static_bound.arg.0 = 320 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) : () -> ()

