#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg30: index, %arg31: index, %arg32: index, %arg33: index, %arg34: memref<32x128xf32>, %arg35: memref<128x64xf32>, %arg36: memref<32x64xf32>, %arg37: memref<32x64xf32>):
      "air.segment"(%arg34, %arg35, %arg36, %arg37) ({
      ^bb0(%arg38: memref<32x128xf32>, %arg39: memref<128x64xf32>, %arg40: memref<32x64xf32>, %arg41: memref<32x64xf32>):
        %89 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%89, %89, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<32x128xf32>, %arg47: memref<128x64xf32>, %arg48: memref<32x64xf32>, %arg49: memref<32x64xf32>):
          %90 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %91 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %92 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %93 = "air.wait_all"() : () -> !air.async.token
          %94 = "arith.constant"() <{value = 0 : index}> : () -> index
          %95 = "arith.constant"() <{value = 4 : index}> : () -> index
          %96 = "arith.constant"() <{value = 1 : index}> : () -> index
          %97 = "scf.for"(%94, %95, %96, %93) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %98 = "arith.constant"() <{value = 8 : index}> : () -> index
            %99 = "arith.muli"(%arg50, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %100 = "arith.constant"() <{value = 8 : index}> : () -> index
            %101 = "arith.muli"(%arg50, %100) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %102 = "arith.constant"() <{value = 8 : index}> : () -> index
            %103 = "arith.muli"(%arg50, %102) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %104 = "arith.constant"() <{value = 0 : index}> : () -> index
            %105 = "arith.constant"() <{value = 2 : index}> : () -> index
            %106 = "arith.constant"() <{value = 1 : index}> : () -> index
            %107 = "scf.for"(%104, %105, %106, %arg51) ({
            ^bb0(%arg52: index, %arg53: !air.async.token):
              %108 = "arith.constant"() <{value = 32 : index}> : () -> index
              %109 = "arith.muli"(%arg52, %108) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %110 = "arith.constant"() <{value = 32 : index}> : () -> index
              %111 = "arith.muli"(%arg52, %110) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %112 = "arith.constant"() <{value = 32 : index}> : () -> index
              %113 = "arith.muli"(%arg52, %112) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %114 = "memref.reinterpret_cast"(%92) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %115 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %116 = "arith.constant"() <{value = 0 : index}> : () -> index
              %117 = "arith.constant"() <{value = 8 : index}> : () -> index
              %118 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%116, %117, %118) ({
              ^bb0(%arg59: index):
                %205 = "arith.addi"(%arg59, %99) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %206 = "arith.constant"() <{value = 0 : index}> : () -> index
                %207 = "arith.constant"() <{value = 32 : index}> : () -> index
                %208 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%206, %207, %208) ({
                ^bb0(%arg60: index):
                  %209 = "arith.addi"(%arg60, %109) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %210 = "arith.subi"(%205, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %211 = "arith.subi"(%209, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%115, %114, %210, %211) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %119 = "arith.constant"() <{value = 0 : index}> : () -> index
              %120 = "arith.constant"() <{value = 4 : index}> : () -> index
              %121 = "arith.constant"() <{value = 1 : index}> : () -> index
              %122 = "scf.for"(%119, %120, %121, %arg53) ({
              ^bb0(%arg54: index, %arg55: !air.async.token):
                %129 = "arith.constant"() <{value = 32 : index}> : () -> index
                %130 = "arith.muli"(%arg54, %129) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %131 = "arith.constant"() <{value = 32 : index}> : () -> index
                %132 = "arith.muli"(%arg54, %131) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %133 = "arith.constant"() <{value = 32 : index}> : () -> index
                %134 = "arith.muli"(%arg54, %133) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %135 = "memref.reinterpret_cast"(%90) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %136 = "arith.constant"() <{value = 0 : index}> : () -> index
                %137 = "arith.addi"(%136, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %138 = "arith.constant"() <{value = 0 : index}> : () -> index
                %139 = "arith.addi"(%138, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %140 = "air.dma_memcpy_nd"(%arg55, %135, %arg46, %137, %139) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 24>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
                %141 = "memref.reinterpret_cast"(%91) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                %142 = "arith.constant"() <{value = 0 : index}> : () -> index
                %143 = "arith.addi"(%142, %134) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %144 = "arith.constant"() <{value = 0 : index}> : () -> index
                %145 = "arith.addi"(%144, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %146 = "air.dma_memcpy_nd"(%arg55, %141, %arg47, %143, %145) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 25>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<128x64xf32>, index, index) -> !air.async.token
                "air.wait_all"(%140, %146) {orbit.computation_event = 3 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.read_copies = array<i64: 24, 25, 26>, orbit.task = "gemm", orbit.write_copies = array<i64: 27>} : (!air.async.token, !air.async.token) -> ()
                %147 = "memref.cast"(%135) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
                %148 = "memref.cast"(%141) : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<32x32xf32, 2 : i32>
                %149 = "memref.cast"(%114) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
                %150 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                %151 = "arith.constant"() <{value = 0 : index}> : () -> index
                %152 = "arith.constant"() <{value = 8 : index}> : () -> index
                %153 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%151, %152, %153) ({
                ^bb0(%arg56: index):
                  %155 = "arith.addi"(%arg56, %99) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %156 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %157 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %158 = "arith.constant"() <{value = 8 : index}> : () -> index
                  "scf.for"(%156, %157, %158) ({
                  ^bb0(%arg57: index):
                    %159 = "arith.addi"(%arg57, %109) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %160 = "arith.constant"() <{value = 0 : index}> : () -> index
                    %161 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %162 = "arith.constant"() <{value = 1 : index}> : () -> index
                    "scf.for"(%160, %161, %162) ({
                    ^bb0(%arg58: index):
                      %163 = "arith.addi"(%arg58, %130) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %164 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                      %165 = "arith.subi"(%155, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %166 = "arith.subi"(%163, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %167 = "memref.load"(%147, %165, %166) <{nontemporal = false}> : (memref<8x32xf32, 2 : i32>, index, index) -> f32
                      %168 = "vector.broadcast"(%167) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                      %169 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                      %170 = "arith.subi"(%163, %134) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %171 = "arith.subi"(%159, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %172 = "vector.transfer_read"(%148, %170, %171, %169) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x32xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                      %173 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                      %174 = "arith.subi"(%155, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %175 = "arith.subi"(%159, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %176 = "vector.transfer_read"(%149, %174, %175, %173) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                      %177 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                      %178 = "vector.extract"(%172) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                      %179 = "func.call"(%167, %178) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %180 = "vector.insert"(%179, %177) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %181 = "vector.extract"(%172) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                      %182 = "func.call"(%167, %181) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %183 = "vector.insert"(%182, %180) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %184 = "vector.extract"(%172) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                      %185 = "func.call"(%167, %184) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %186 = "vector.insert"(%185, %183) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %187 = "vector.extract"(%172) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                      %188 = "func.call"(%167, %187) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %189 = "vector.insert"(%188, %186) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %190 = "vector.extract"(%172) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                      %191 = "func.call"(%167, %190) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %192 = "vector.insert"(%191, %189) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %193 = "vector.extract"(%172) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                      %194 = "func.call"(%167, %193) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %195 = "vector.insert"(%194, %192) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %196 = "vector.extract"(%172) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                      %197 = "func.call"(%167, %196) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %198 = "vector.insert"(%197, %195) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %199 = "vector.extract"(%172) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                      %200 = "func.call"(%167, %199) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %201 = "vector.insert"(%200, %198) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %202 = "arith.addf"(%176, %201) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                      %203 = "arith.subi"(%155, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %204 = "arith.subi"(%159, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      "vector.transfer_write"(%202, %149, %203, %204) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, 2 : i32>, index, index) -> ()
                      "scf.yield"() : () -> ()
                    }) : (index, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                %154 = "air.wait_all"(%arg55) : (!air.async.token) -> !air.async.token
                "scf.yield"(%154) : (!air.async.token) -> ()
              }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
              %123 = "arith.constant"() <{value = 0 : index}> : () -> index
              %124 = "arith.addi"(%123, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %125 = "arith.constant"() <{value = 0 : index}> : () -> index
              %126 = "arith.addi"(%125, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %127 = "air.dma_memcpy_nd"(%122, %arg49, %124, %126, %114) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 11 : i64, orbit.retained_begin = 8 : i64, orbit.retained_end = 12 : i64, orbit.source_copies = array<i64: 36>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 37>, orbit.transfer = "l1_to_host", orbit.transfer_event = 13 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %128 = "air.wait_all"(%127) : (!air.async.token) -> !air.async.token
              "scf.yield"(%128) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%107) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%97) : (!air.async.token) -> ()
          "memref.dealloc"(%90) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%91) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%92) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<32x128xf32>, %arg9: memref<128x64xf32>, %arg10: memref<32x64xf32>, %arg11: memref<32x64xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<32x128xf32>, %arg13: memref<128x64xf32>, %arg14: memref<32x64xf32>, %arg15: memref<32x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<32x128xf32>, %arg21: memref<128x64xf32>, %arg22: memref<32x64xf32>, %arg23: memref<32x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<256xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : () -> memref<256xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 4 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "scf.for"(%5, %6, %7, %4) ({
          ^bb0(%arg24: index, %arg25: !air.async.token):
            %9 = "arith.constant"() <{value = 8 : index}> : () -> index
            %10 = "arith.muli"(%arg24, %9) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %11 = "arith.constant"() <{value = 8 : index}> : () -> index
            %12 = "arith.muli"(%arg24, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 8 : index}> : () -> index
            %14 = "arith.muli"(%arg24, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 0 : index}> : () -> index
            %16 = "arith.constant"() <{value = 2 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg25) ({
            ^bb0(%arg26: index, %arg27: !air.async.token):
              %19 = "arith.constant"() <{value = 32 : index}> : () -> index
              %20 = "arith.muli"(%arg26, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 32 : index}> : () -> index
              %22 = "arith.muli"(%arg26, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 32 : index}> : () -> index
              %24 = "arith.muli"(%arg26, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 40 : i64, orbit.storage = "Y"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %26 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 40 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0 : index}> : () -> index
              %28 = "arith.addi"(%27, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %29 = "arith.constant"() <{value = 0 : index}> : () -> index
              %30 = "arith.addi"(%29, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "air.dma_memcpy_nd"(%arg27, %26, %arg23, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 37>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 136>, orbit.transfer = "host_to_l1", orbit.transfer_event = 112 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%31) {orbit.computation_event = 113 : i64, orbit.phase = 40 : i64, orbit.phase_dependencies = array<i64: 39>, orbit.read_copies = array<i64: 136>, orbit.task = "scale", orbit.write_copies = array<i64: 137>} : (!air.async.token) -> ()
              %32 = "memref.cast"(%25) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
              %33 = "memref.cast"(%26) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
              %34 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.constant"() <{value = 8 : index}> : () -> index
              %37 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%35, %36, %37) ({
              ^bb0(%arg28: index):
                %44 = "arith.addi"(%arg28, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %45 = "arith.constant"() <{value = 0 : index}> : () -> index
                %46 = "arith.constant"() <{value = 32 : index}> : () -> index
                %47 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%45, %46, %47) ({
                ^bb0(%arg29: index):
                  %48 = "arith.addi"(%arg29, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %49 = "arith.constant"() <{value = dense<5.000000e-01> : vector<8xf32>}> : () -> vector<8xf32>
                  %50 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                  %51 = "arith.subi"(%44, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "arith.subi"(%48, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %53 = "vector.transfer_read"(%33, %51, %52, %50) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %54 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                  %55 = "vector.extract"(%53) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %56 = "vector.extract"(%49) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %57 = "func.call"(%55, %56) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %58 = "vector.insert"(%57, %54) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %59 = "vector.extract"(%53) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %60 = "vector.extract"(%49) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %61 = "func.call"(%59, %60) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %62 = "vector.insert"(%61, %58) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %63 = "vector.extract"(%53) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %64 = "vector.extract"(%49) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %65 = "func.call"(%63, %64) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %66 = "vector.insert"(%65, %62) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %67 = "vector.extract"(%53) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %68 = "vector.extract"(%49) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %69 = "func.call"(%67, %68) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %70 = "vector.insert"(%69, %66) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %71 = "vector.extract"(%53) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %72 = "vector.extract"(%49) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %73 = "func.call"(%71, %72) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %74 = "vector.insert"(%73, %70) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %75 = "vector.extract"(%53) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %76 = "vector.extract"(%49) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %77 = "func.call"(%75, %76) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %78 = "vector.insert"(%77, %74) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %79 = "vector.extract"(%53) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %80 = "vector.extract"(%49) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %81 = "func.call"(%79, %80) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %82 = "vector.insert"(%81, %78) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %83 = "vector.extract"(%53) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %84 = "vector.extract"(%49) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %85 = "func.call"(%83, %84) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %86 = "vector.insert"(%85, %82) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %87 = "arith.subi"(%44, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %88 = "arith.subi"(%48, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%86, %32, %87, %88) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %38 = "arith.constant"() <{value = 0 : index}> : () -> index
              %39 = "arith.addi"(%38, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %40 = "arith.constant"() <{value = 0 : index}> : () -> index
              %41 = "arith.addi"(%40, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %42 = "air.dma_memcpy_nd"(%arg27, %arg22, %39, %41, %25) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 137>, orbit.storage = "Y", orbit.target_copies = array<i64: 138>, orbit.transfer = "l1_to_host", orbit.transfer_event = 114 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %43 = "air.wait_all"(%42) : (!air.async.token) -> !air.async.token
              "scf.yield"(%43) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_40"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_40"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_40"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "f3407e593c914de91966c717eda95fbddab6d5c16fb2596c783b252742fb4c53", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} : () -> ()

