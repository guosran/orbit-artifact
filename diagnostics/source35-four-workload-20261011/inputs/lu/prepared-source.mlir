"builtin.module"() ({
  "func.func"() <{arg_attrs = [{}, {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 8>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 8, 100>, amoeba.noalias}, {amoeba.logical_transfer_shape = array<i64: 1>, amoeba.noalias}], function_type = (i32, memref<?x100xi32>, memref<?xi32>, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>) -> (), sym_name = "_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?x100xi32>, %arg2: memref<?xi32>, %arg3: memref<?x100xi32>, %arg4: memref<?x100xi32>, %arg5: memref<?x100xi32>, %arg6: memref<?xi32>, %arg7: memref<?xi32>, %arg8: memref<?x100xi32>, %arg9: memref<?xi32>):
    %0 = "arith.constant"() <{value = 7 : i32}> : () -> i32
    %1 = "arith.constant"() <{value = 0 : index}> : () -> index
    %2 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 1 : i32}> : () -> i32
    %4 = "arith.constant"() <{value = 1024 : i32}> : () -> i32
    %5 = "arith.constant"() <{value = -1024 : i32}> : () -> i32
    %6 = "arith.constant"() <{value = 8 : index}> : () -> index
    %7 = "taskflow.task"(%arg1, %arg3, %6, %arg1, %arg3) <{operandSegmentSizes = array<i32: 1, 1, 1, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_0"}> ({
    ^bb0(%arg75: memref<?x100xi32>, %arg76: memref<?x100xi32>, %arg77: index):
      %196 = "arith.constant"() <{value = 0 : index}> : () -> index
      %197 = "arith.constant"() <{value = 1 : index}> : () -> index
      %198 = "taskflow.counter"(%196, %arg77, %197) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %199 = "taskflow.counter"(%198, %196, %arg77, %197) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%198, %199) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg78: index, %arg79: index):
        %200 = "memref.load"(%arg75, %arg78, %arg79) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        "memref.store"(%200, %arg76, %arg78, %arg79) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg76) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x100xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=64\0Ainternal_multiplicity=1\0Asource_multiplicity=64\0Aaxis_count=2\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 64 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 64 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, index, memref<?x100xi32>, memref<?x100xi32>) -> memref<?x100xi32>
    %8:3 = "taskflow.task"(%arg4, %arg5, %arg8, %6, %4, %2, %arg4, %arg5, %arg8) <{operandSegmentSizes = array<i32: 0, 3, 3, 0, 3>, resultSegmentSizes = array<i32: 0, 3, 0>, task_name = "Task_1"}> ({
    ^bb0(%arg67: memref<?x100xi32>, %arg68: memref<?x100xi32>, %arg69: memref<?x100xi32>, %arg70: index, %arg71: i32, %arg72: i32):
      %188 = "arith.constant"() <{value = 0 : index}> : () -> index
      %189 = "arith.constant"() <{value = 1 : index}> : () -> index
      %190 = "taskflow.counter"(%188, %arg70, %189) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %191 = "taskflow.counter"(%190, %188, %arg70, %189) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%190, %191) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg73: index, %arg74: index):
        %192 = "arith.index_cast"(%arg73) : (index) -> i32
        %193 = "arith.index_cast"(%arg74) : (index) -> i32
        %194 = "arith.cmpi"(%192, %193) <{predicate = 0 : i64}> : (i32, i32) -> i1
        %195 = "arith.select"(%194, %arg71, %arg72) : (i1, i32, i32) -> i32
        "memref.store"(%195, %arg67, %arg73, %arg74) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        "memref.store"(%arg72, %arg68, %arg73, %arg74) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        "memref.store"(%195, %arg69, %arg73, %arg74) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg67, %arg68, %arg69) <{operandSegmentSizes = array<i32: 0, 3, 0>}> : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=64\0Ainternal_multiplicity=1\0Asource_multiplicity=64\0Aaxis_count=2\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 64 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 64 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) -> (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>)
    %9 = "taskflow.task"(%7, %7, %6, %4, %5, %arg3, %arg3) <{operandSegmentSizes = array<i32: 1, 1, 3, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_2"}> ({
    ^bb0(%arg59: memref<?x100xi32>, %arg60: memref<?x100xi32>, %arg61: index, %arg62: i32, %arg63: i32):
      %157 = "arith.constant"() <{value = 0 : index}> : () -> index
      %158 = "arith.constant"() <{value = 1 : index}> : () -> index
      %159 = "taskflow.counter"(%157, %arg61, %158) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %160 = "taskflow.counter"(%159, %157, %arg61, %158) <{counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %161 = "taskflow.counter"(%160, %157, %arg61, %158) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%159, %160, %161) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg64: index, %arg65: index, %arg66: index):
        %162 = "arith.index_cast"(%arg64) : (index) -> i32
        %163 = "arith.index_cast"(%arg65) : (index) -> i32
        %164 = "arith.index_cast"(%arg66) : (index) -> i32
        %165 = "arith.cmpi"(%164, %162) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %166 = "arith.extui"(%165) : (i1) -> i32
        %167 = "arith.cmpi"(%164, %163) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %168 = "arith.extui"(%167) : (i1) -> i32
        %169 = "arith.muli"(%166, %168) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %170 = "memref.load"(%arg60, %arg64, %arg65) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %171 = "memref.load"(%arg60, %arg64, %arg66) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %172 = "memref.load"(%arg60, %arg66, %arg65) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %173 = "arith.muli"(%171, %172) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %174 = "arith.divsi"(%173, %arg62) : (i32, i32) -> i32
        %175 = "arith.muli"(%169, %174) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %176 = "arith.subi"(%170, %175) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%176, %arg60, %arg64, %arg65) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        %177 = "arith.cmpi"(%162, %163) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %178 = "arith.extui"(%177) : (i1) -> i32
        %179 = "memref.load"(%arg60, %arg65, %arg65) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %180 = "arith.addi"(%179, %arg63) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %181 = "arith.muli"(%178, %180) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %182 = "arith.addi"(%181, %arg62) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %183 = "memref.load"(%arg60, %arg64, %arg65) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %184 = "arith.muli"(%183, %arg62) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %185 = "arith.divsi"(%184, %182) : (i32, i32) -> i32
        %186 = "arith.addi"(%arg66, %158) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %187 = "arith.cmpi"(%186, %arg61) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%187) ({
          "memref.store"(%185, %arg60, %arg64, %arg65) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg60) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x100xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=512\0Ainternal_multiplicity=1\0Asource_multiplicity=512\0Aaxis_count=3\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Aaxis=T,2,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 512 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 512 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, index, i32, i32, memref<?x100xi32>, memref<?x100xi32>) -> memref<?x100xi32>
    %10:2 = "taskflow.task"(%9, %8#0, %8#1, %6, %3, %4, %arg3, %arg4, %arg5) <{operandSegmentSizes = array<i32: 1, 2, 3, 1, 2>, resultSegmentSizes = array<i32: 0, 2, 0>, task_name = "Task_3"}> ({
    ^bb0(%arg51: memref<?x100xi32>, %arg52: memref<?x100xi32>, %arg53: memref<?x100xi32>, %arg54: index, %arg55: i32, %arg56: i32):
      %141 = "arith.constant"() <{value = 0 : index}> : () -> index
      %142 = "arith.constant"() <{value = 1 : index}> : () -> index
      %143 = "taskflow.counter"(%141, %arg54, %142) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %144 = "taskflow.counter"(%143, %141, %arg54, %142) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%143, %144) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg57: index, %arg58: index):
        %145 = "arith.index_cast"(%arg57) : (index) -> i32
        %146 = "arith.index_cast"(%arg58) : (index) -> i32
        %147 = "arith.cmpi"(%145, %146) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %148 = "arith.extui"(%147) : (i1) -> i32
        %149 = "arith.cmpi"(%145, %146) <{predicate = 0 : i64}> : (i32, i32) -> i1
        %150 = "arith.extui"(%149) : (i1) -> i32
        %151 = "arith.subi"(%arg55, %148) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %152 = "memref.load"(%arg51, %arg57, %arg58) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %153 = "arith.muli"(%148, %152) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %154 = "arith.muli"(%150, %arg56) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %155 = "arith.addi"(%153, %154) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%155, %arg52, %arg57, %arg58) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        %156 = "arith.muli"(%151, %152) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%156, %arg53, %arg57, %arg58) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg52, %arg53) <{operandSegmentSizes = array<i32: 0, 2, 0>}> : (memref<?x100xi32>, memref<?x100xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=64\0Ainternal_multiplicity=1\0Asource_multiplicity=64\0Aaxis_count=2\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 64 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 64 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) -> (memref<?x100xi32>, memref<?x100xi32>)
    %11 = "taskflow.task"(%arg2, %arg6, %10#0, %arg6, %6, %4, %arg2, %arg6, %arg4, %arg6) <{operandSegmentSizes = array<i32: 3, 1, 2, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_4"}> ({
    ^bb0(%arg43: memref<?xi32>, %arg44: memref<?xi32>, %arg45: memref<?x100xi32>, %arg46: memref<?xi32>, %arg47: index, %arg48: i32):
      %124 = "arith.constant"() <{value = 0 : index}> : () -> index
      %125 = "arith.constant"() <{value = 1 : index}> : () -> index
      %126 = "taskflow.counter"(%124, %arg47, %125) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %127 = "taskflow.counter"(%126, %124, %arg47, %125) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%126, %127) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg49: index, %arg50: index):
        %128 = "arith.index_cast"(%arg49) : (index) -> i32
        %129 = "memref.load"(%arg43, %arg49) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %130 = "arith.cmpi"(%arg50, %124) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%130) ({
          "memref.store"(%129, %arg46, %arg49) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %131 = "arith.index_cast"(%arg50) : (index) -> i32
        %132 = "arith.cmpi"(%131, %128) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %133 = "arith.extui"(%132) : (i1) -> i32
        %134 = "memref.load"(%arg46, %arg49) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %135 = "memref.load"(%arg45, %arg49, %arg50) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %136 = "memref.load"(%arg46, %arg50) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %137 = "arith.muli"(%135, %136) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %138 = "arith.divsi"(%137, %arg48) : (i32, i32) -> i32
        %139 = "arith.muli"(%133, %138) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %140 = "arith.subi"(%134, %139) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%140, %arg46, %arg49) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg46) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=64\0Ainternal_multiplicity=1\0Asource_multiplicity=64\0Aaxis_count=2\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 64 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 64 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>) -> memref<?xi32>
    %12 = "taskflow.task"(%11, %arg7, %10#1, %arg7, %6, %0, %4, %arg6, %arg7, %arg5, %arg7) <{operandSegmentSizes = array<i32: 3, 1, 3, 3, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_5"}> ({
    ^bb0(%arg34: memref<?xi32>, %arg35: memref<?xi32>, %arg36: memref<?x100xi32>, %arg37: memref<?xi32>, %arg38: index, %arg39: i32, %arg40: i32):
      %81 = "arith.constant"() <{value = -1 : index}> : () -> index
      %82 = "arith.constant"() <{value = 0 : index}> : () -> index
      %83 = "arith.constant"() <{value = 1 : index}> : () -> index
      %84 = "taskflow.counter"(%82, %arg38, %83) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %85 = "taskflow.counter"(%84, %82, %arg38, %83) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 1 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%84, %85) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg41: index, %arg42: index):
        %86 = "arith.index_cast"(%arg41) : (index) -> i32
        %87 = "arith.subi"(%arg39, %86) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %88 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %89 = "arith.addi"(%88, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %90 = "memref.load"(%arg34, %89) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %91 = "arith.cmpi"(%arg42, %82) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%91) ({
          %122 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          %123 = "arith.addi"(%122, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          "memref.store"(%90, %arg37, %123) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %92 = "arith.index_cast"(%arg42) : (index) -> i32
        %93 = "arith.cmpi"(%92, %87) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %94 = "arith.extui"(%93) : (i1) -> i32
        %95 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %96 = "arith.addi"(%95, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %97 = "memref.load"(%arg37, %96) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %98 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %99 = "arith.addi"(%98, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %100 = "memref.load"(%arg36, %99, %arg42) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %101 = "memref.load"(%arg37, %arg42) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %102 = "arith.muli"(%100, %101) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %103 = "arith.divsi"(%102, %arg40) : (i32, i32) -> i32
        %104 = "arith.muli"(%94, %103) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %105 = "arith.subi"(%97, %104) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %106 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %107 = "arith.addi"(%106, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        "memref.store"(%105, %arg37, %107) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
        %108 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %109 = "arith.addi"(%108, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %110 = "memref.load"(%arg37, %109) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %111 = "arith.muli"(%110, %arg40) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %112 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %113 = "arith.addi"(%112, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %114 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %115 = "arith.addi"(%114, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %116 = "memref.load"(%arg36, %113, %115) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %117 = "arith.divsi"(%111, %116) : (i32, i32) -> i32
        %118 = "arith.addi"(%arg42, %83) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %119 = "arith.cmpi"(%118, %arg38) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%119) ({
          %120 = "arith.subi"(%arg38, %arg41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          %121 = "arith.addi"(%120, %81) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          "memref.store"(%117, %arg37, %121) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg37) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=64\0Ainternal_multiplicity=1\0Asource_multiplicity=64\0Aaxis_count=2\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 64 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 64 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>, index, i32, i32, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>) -> memref<?xi32>
    %13 = "taskflow.task"(%8#2, %10#0, %8#2, %6, %4, %2, %arg8, %arg4, %arg8) <{operandSegmentSizes = array<i32: 2, 1, 3, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_6"}> ({
    ^bb0(%arg25: memref<?x100xi32>, %arg26: memref<?x100xi32>, %arg27: memref<?x100xi32>, %arg28: index, %arg29: i32, %arg30: i32):
      %61 = "arith.constant"() <{value = 0 : index}> : () -> index
      %62 = "arith.constant"() <{value = 1 : index}> : () -> index
      %63 = "taskflow.counter"(%61, %arg28, %62) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %64 = "taskflow.counter"(%63, %61, %arg28, %62) <{counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %65 = "taskflow.counter"(%64, %61, %arg28, %62) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%63, %64, %65) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg31: index, %arg32: index, %arg33: index):
        %66 = "arith.index_cast"(%arg31) : (index) -> i32
        %67 = "arith.index_cast"(%arg32) : (index) -> i32
        %68 = "arith.cmpi"(%67, %66) <{predicate = 0 : i64}> : (i32, i32) -> i1
        %69 = "arith.select"(%68, %arg29, %arg30) : (i1, i32, i32) -> i32
        %70 = "arith.cmpi"(%arg33, %61) <{predicate = 0 : i64}> : (index, index) -> i1
        "scf.if"(%70) ({
          "memref.store"(%69, %arg27, %arg32, %arg31) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        %71 = "arith.index_cast"(%arg33) : (index) -> i32
        %72 = "arith.cmpi"(%71, %67) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %73 = "arith.extui"(%72) : (i1) -> i32
        %74 = "memref.load"(%arg27, %arg32, %arg31) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %75 = "memref.load"(%arg26, %arg32, %arg33) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %76 = "memref.load"(%arg27, %arg33, %arg31) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %77 = "arith.muli"(%75, %76) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %78 = "arith.divsi"(%77, %arg29) : (i32, i32) -> i32
        %79 = "arith.muli"(%73, %78) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %80 = "arith.subi"(%74, %79) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "memref.store"(%80, %arg27, %arg32, %arg31) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg27) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x100xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=512\0Ainternal_multiplicity=1\0Asource_multiplicity=512\0Aaxis_count=3\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Aaxis=T,2,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 512 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 512 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) -> memref<?x100xi32>
    %14 = "taskflow.task"(%13, %10#1, %13, %6, %0, %4, %arg8, %arg5, %arg8) <{operandSegmentSizes = array<i32: 2, 1, 3, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_7"}> ({
    ^bb0(%arg16: memref<?x100xi32>, %arg17: memref<?x100xi32>, %arg18: memref<?x100xi32>, %arg19: index, %arg20: i32, %arg21: i32):
      %23 = "arith.constant"() <{value = -1 : index}> : () -> index
      %24 = "arith.constant"() <{value = 0 : index}> : () -> index
      %25 = "arith.constant"() <{value = 1 : index}> : () -> index
      %26 = "taskflow.counter"(%24, %arg19, %25) <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32}> : (index, index, index) -> index
      %27 = "taskflow.counter"(%26, %24, %arg19, %25) <{counter_dynamism = "symbol_bound", counter_hierarchy = "relay", counter_id = 1 : i32}> : (index, index, index, index) -> index
      %28 = "taskflow.counter"(%27, %24, %arg19, %25) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 2 : i32}> : (index, index, index, index) -> index
      "taskflow.hyperblock"(%26, %27, %28) <{operandSegmentSizes = array<i32: 3, 0>}> ({
      ^bb0(%arg22: index, %arg23: index, %arg24: index):
        %29 = "arith.index_cast"(%arg23) : (index) -> i32
        %30 = "arith.subi"(%arg20, %29) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %31 = "arith.index_cast"(%arg24) : (index) -> i32
        %32 = "arith.cmpi"(%31, %30) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %33 = "arith.extui"(%32) : (i1) -> i32
        %34 = "arith.subi"(%arg19, %arg23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %35 = "arith.addi"(%34, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %36 = "memref.load"(%arg18, %35, %arg22) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %37 = "arith.subi"(%arg19, %arg23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %38 = "arith.addi"(%37, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %39 = "memref.load"(%arg17, %38, %arg24) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %40 = "memref.load"(%arg18, %arg24, %arg22) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %41 = "arith.muli"(%39, %40) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %42 = "arith.divsi"(%41, %arg21) : (i32, i32) -> i32
        %43 = "arith.muli"(%33, %42) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %44 = "arith.subi"(%36, %43) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %45 = "arith.subi"(%arg19, %arg23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %46 = "arith.addi"(%45, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        "memref.store"(%44, %arg18, %46, %arg22) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
        %47 = "arith.subi"(%arg19, %arg23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %48 = "arith.addi"(%47, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %49 = "memref.load"(%arg18, %48, %arg22) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %50 = "arith.muli"(%49, %arg21) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %51 = "arith.subi"(%arg19, %arg23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %52 = "arith.addi"(%51, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %53 = "arith.subi"(%arg19, %arg23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %54 = "arith.addi"(%53, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %55 = "memref.load"(%arg17, %52, %54) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %56 = "arith.divsi"(%50, %55) : (i32, i32) -> i32
        %57 = "arith.addi"(%arg24, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %58 = "arith.cmpi"(%57, %arg19) <{predicate = 5 : i64}> : (index, index) -> i1
        "scf.if"(%58) ({
          %59 = "arith.subi"(%arg19, %arg23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          %60 = "arith.addi"(%59, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          "memref.store"(%56, %arg18, %60, %arg22) <{nontemporal = false}> : (i32, memref<?x100xi32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }, {
        }) : (i1) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index, index) -> ()
      "taskflow.yield"(%arg18) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?x100xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 1 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}, {carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 2 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=512\0Ainternal_multiplicity=1\0Asource_multiplicity=512\0Aaxis_count=3\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Aaxis=T,1,0,8,1,8,0,-1,0,0\0Aaxis=T,2,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 512 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 512 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, index, i32, i32, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>) -> memref<?x100xi32>
    "memref.store"(%4, %arg9, %1) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
    %15 = "taskflow.task"(%10#1, %arg9, %arg9, %6, %4, %arg5, %arg9, %arg9) <{operandSegmentSizes = array<i32: 2, 1, 2, 2, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Task_8"}> ({
    ^bb0(%arg10: memref<?x100xi32>, %arg11: memref<?xi32>, %arg12: memref<?xi32>, %arg13: index, %arg14: i32):
      %16 = "arith.constant"() <{value = 0 : index}> : () -> index
      %17 = "arith.constant"() <{value = 1 : index}> : () -> index
      %18 = "taskflow.counter"(%16, %arg13, %17) <{counter_dynamism = "symbol_bound", counter_hierarchy = "leaf", counter_id = 0 : i32}> : (index, index, index) -> index
      "taskflow.hyperblock"(%18) <{operandSegmentSizes = array<i32: 1, 0>}> ({
      ^bb0(%arg15: index):
        %19 = "memref.load"(%arg10, %arg15, %arg15) <{nontemporal = false}> : (memref<?x100xi32>, index, index) -> i32
        %20 = "memref.load"(%arg12, %16) <{nontemporal = false}> : (memref<?xi32>, index) -> i32
        %21 = "arith.muli"(%20, %19) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %22 = "arith.divsi"(%21, %arg14) : (i32, i32) -> i32
        "memref.store"(%22, %arg12, %16) <{nontemporal = false}> : (i32, memref<?xi32>, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index) -> ()
      "taskflow.yield"(%arg12) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<?xi32>) -> ()
    }) {amoeba.source_iteration_capture_pending, amoeba.source_iteration_domain = {axes = [{carried_values = 0 : i64, expanded_inside_mapper_firing = false, extent = 8 : i64, kind = "taskflow-counter", lower = 0 : i64, ordinal = 0 : i64, parent_counter_ordinal = -1 : i64, result_uses = 0 : i64, step = 1 : i64, upper = 8 : i64}], canonical_witness = "amoeba-source-iteration-domain-v1\0Acomplete=1\0Arepresented_multiplicity=8\0Ainternal_multiplicity=1\0Asource_multiplicity=8\0Aaxis_count=1\0Aaxis=T,0,0,8,1,8,0,-1,0,0\0Areason_bytes=0:\0A", complete = true, internal_multiplicity = 1 : i64, represented_multiplicity = 8 : i64, schema = "amoeba-source-iteration-domain-v1", source_multiplicity = 8 : i64}, dlp_replicable = true, runtime_managable = true} : (memref<?x100xi32>, memref<?xi32>, memref<?xi32>, index, i32, memref<?x100xi32>, memref<?xi32>, memref<?xi32>) -> memref<?xi32>
    "func.return"() : () -> ()
  }) {amoeba.input0_caller_evidence_path = "/home/shiran/project/orbit-artifact/reference/input0-source-domains/callers/lu.mlir", amoeba.input0_caller_function = "main", amoeba.input0_caller_noalias_proof_mode = "prepared-external-caller", amoeba.input0_caller_noalias_proven, amoeba.input0_caller_prepared_input_path = "/home/shiran/project/orbit-repair-study/full_prepared-v4/lu/taskflow-affine.mlir", amoeba.input0_caller_static_bound = 8 : i64, amoeba.static_bound.arg.0 = 8 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) {amoeba.lu_affine_repair_input_status = "malformed-determinant-carry", amoeba.lu_affine_repair_pass = "repair-lu-affine-determinant-carry-v1", amoeba.lu_affine_repair_reason = "inserted determinant carry load and rewired product", amoeba.lu_affine_repair_source_file = "reference/input0-source-domains/source/lu_func.cpp", amoeba.lu_affine_repair_source_verified = true, amoeba.lu_affine_repair_status = "repaired"} : () -> ()

