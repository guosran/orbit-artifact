#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg59: index, %arg60: index, %arg61: index, %arg62: index, %arg63: memref<32x128xf32>, %arg64: memref<128x64xf32>, %arg65: memref<32x64xf32>, %arg66: memref<32x64xf32>):
      "air.segment"(%arg63, %arg64, %arg65, %arg66) ({
      ^bb0(%arg67: memref<32x128xf32>, %arg68: memref<128x64xf32>, %arg69: memref<32x64xf32>, %arg70: memref<32x64xf32>):
        %197 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%197, %197, %arg67, %arg68, %arg69, %arg70) ({
        ^bb0(%arg71: index, %arg72: index, %arg73: index, %arg74: index, %arg75: memref<32x128xf32>, %arg76: memref<128x64xf32>, %arg77: memref<32x64xf32>, %arg78: memref<32x64xf32>):
          %198 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %199 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<4096xf32, 2 : i32>
          %200 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %201 = "air.wait_all"() : () -> !air.async.token
          %202 = "memref.reinterpret_cast"(%199) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "B"} : (memref<4096xf32, 2 : i32>) -> memref<128x32xf32, strided<[32, 1]>, 2 : i32>
          %203 = "air.dma_memcpy_nd"(%201, %202, %arg76) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 8 : i64, orbit.readonly_retained_begin = 8 : i64, orbit.readonly_retained_end = 24 : i64, orbit.source_copies = array<i64: 16, 18, 20, 22>, orbit.storage = "B", orbit.target_copies = array<i64: 25, 26, 27, 28>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 128, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x32xf32, strided<[32, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%203) : (!air.async.token) -> ()
          %204 = "arith.constant"() <{value = 0 : index}> : () -> index
          %205 = "arith.constant"() <{value = 4 : index}> : () -> index
          %206 = "arith.constant"() <{value = 1 : index}> : () -> index
          %207 = "scf.for"(%204, %205, %206, %203) ({
          ^bb0(%arg79: index, %arg80: !air.async.token):
            %208 = "arith.constant"() <{value = 8 : index}> : () -> index
            %209 = "arith.muli"(%arg79, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %210 = "arith.constant"() <{value = 8 : index}> : () -> index
            %211 = "arith.muli"(%arg79, %210) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %212 = "arith.constant"() <{value = 8 : index}> : () -> index
            %213 = "arith.muli"(%arg79, %212) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %214 = "memref.reinterpret_cast"(%200) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %215 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %216 = "arith.constant"() <{value = 0 : index}> : () -> index
            %217 = "arith.constant"() <{value = 8 : index}> : () -> index
            %218 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%216, %217, %218) ({
            ^bb0(%arg86: index):
              %292 = "arith.addi"(%arg86, %209) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %293 = "arith.constant"() <{value = 0 : index}> : () -> index
              %294 = "arith.constant"() <{value = 32 : index}> : () -> index
              %295 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%293, %294, %295) ({
              ^bb0(%arg87: index):
                %296 = "arith.subi"(%292, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%215, %214, %296, %arg87) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %219 = "arith.constant"() <{value = 0 : index}> : () -> index
            %220 = "arith.constant"() <{value = 4 : index}> : () -> index
            %221 = "arith.constant"() <{value = 1 : index}> : () -> index
            %222 = "scf.for"(%219, %220, %221, %arg80) ({
            ^bb0(%arg81: index, %arg82: !air.async.token):
              %227 = "arith.constant"() <{value = 32 : index}> : () -> index
              %228 = "arith.muli"(%arg81, %227) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %229 = "arith.constant"() <{value = 32 : index}> : () -> index
              %230 = "arith.muli"(%arg81, %229) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %231 = "arith.constant"() <{value = 32 : index}> : () -> index
              %232 = "arith.muli"(%arg81, %231) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %233 = "memref.reinterpret_cast"(%198) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %234 = "arith.constant"() <{value = 0 : index}> : () -> index
              %235 = "arith.addi"(%234, %211) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %236 = "arith.constant"() <{value = 0 : index}> : () -> index
              %237 = "arith.addi"(%236, %230) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %238 = "air.dma_memcpy_nd"(%arg82, %233, %arg75, %235, %237) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 24>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%238) {orbit.computation_event = 3 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.read_copies = array<i64: 24, 25, 29>, orbit.task = "gemm", orbit.write_copies = array<i64: 30>} : (!air.async.token) -> ()
              %239 = "memref.cast"(%233) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
              %240 = "memref.cast"(%202) : (memref<128x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<128x32xf32, 2 : i32>
              %241 = "memref.cast"(%214) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
              %242 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %243 = "arith.constant"() <{value = 0 : index}> : () -> index
              %244 = "arith.constant"() <{value = 8 : index}> : () -> index
              %245 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%243, %244, %245) ({
              ^bb0(%arg83: index):
                %247 = "arith.addi"(%arg83, %209) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %248 = "arith.constant"() <{value = 0 : index}> : () -> index
                %249 = "arith.constant"() <{value = 32 : index}> : () -> index
                %250 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%248, %249, %250) ({
                ^bb0(%arg84: index):
                  %251 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %252 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %253 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%251, %252, %253) ({
                  ^bb0(%arg85: index):
                    %254 = "arith.addi"(%arg85, %228) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %255 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %256 = "arith.subi"(%247, %211) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %257 = "arith.subi"(%254, %230) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %258 = "memref.load"(%239, %256, %257) <{nontemporal = false}> : (memref<8x32xf32, 2 : i32>, index, index) -> f32
                    %259 = "vector.broadcast"(%258) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                    %260 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %261 = "vector.transfer_read"(%240, %254, %arg84, %260) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<128x32xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %262 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %263 = "arith.subi"(%247, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %264 = "vector.transfer_read"(%241, %263, %arg84, %262) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %265 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                    %266 = "vector.extract"(%261) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %267 = "func.call"(%258, %266) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %268 = "vector.insert"(%267, %265) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %269 = "vector.extract"(%261) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %270 = "func.call"(%258, %269) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %271 = "vector.insert"(%270, %268) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %272 = "vector.extract"(%261) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %273 = "func.call"(%258, %272) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %274 = "vector.insert"(%273, %271) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %275 = "vector.extract"(%261) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %276 = "func.call"(%258, %275) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %277 = "vector.insert"(%276, %274) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %278 = "vector.extract"(%261) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %279 = "func.call"(%258, %278) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %280 = "vector.insert"(%279, %277) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %281 = "vector.extract"(%261) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %282 = "func.call"(%258, %281) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %283 = "vector.insert"(%282, %280) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %284 = "vector.extract"(%261) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %285 = "func.call"(%258, %284) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %286 = "vector.insert"(%285, %283) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %287 = "vector.extract"(%261) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %288 = "func.call"(%258, %287) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %289 = "vector.insert"(%288, %286) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %290 = "arith.addf"(%264, %289) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %291 = "arith.subi"(%247, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%290, %241, %291, %arg84) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %246 = "air.wait_all"(%arg82) : (!air.async.token) -> !air.async.token
              "scf.yield"(%246) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %223 = "arith.constant"() <{value = 0 : index}> : () -> index
            %224 = "arith.addi"(%223, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %225 = "air.dma_memcpy_nd"(%222, %arg78, %224, %214) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11 : i64, orbit.retained_begin = 8 : i64, orbit.retained_end = 12 : i64, orbit.source_copies = array<i64: 36>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 37>, orbit.transfer = "l1_to_host", orbit.transfer_event = 10 : i64, static_dst_offsets = array<i64: -9223372036854775808, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %226 = "air.wait_all"(%225) : (!air.async.token) -> !air.async.token
            "scf.yield"(%226) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%207) : (!air.async.token) -> ()
          "memref.dealloc"(%198) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%199) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%200) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg30: index, %arg31: index, %arg32: index, %arg33: index, %arg34: memref<32x128xf32>, %arg35: memref<128x64xf32>, %arg36: memref<32x64xf32>, %arg37: memref<32x64xf32>):
      "air.segment"(%arg34, %arg35, %arg36, %arg37) ({
      ^bb0(%arg38: memref<32x128xf32>, %arg39: memref<128x64xf32>, %arg40: memref<32x64xf32>, %arg41: memref<32x64xf32>):
        %89 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%89, %89, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<32x128xf32>, %arg47: memref<128x64xf32>, %arg48: memref<32x64xf32>, %arg49: memref<32x64xf32>):
          %90 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %91 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<4096xf32, 2 : i32>
          %92 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %93 = "air.wait_all"() : () -> !air.async.token
          %94 = "memref.reinterpret_cast"(%91) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "B"} : (memref<4096xf32, 2 : i32>) -> memref<128x32xf32, strided<[32, 1]>, 2 : i32>
          %95 = "air.dma_memcpy_nd"(%93, %94, %arg47) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 24 : i64, orbit.readonly_retained_begin = 24 : i64, orbit.readonly_retained_end = 40 : i64, orbit.source_copies = array<i64: 17, 19, 21, 23>, orbit.storage = "B", orbit.target_copies = array<i64: 69, 70, 71, 72>, orbit.transfer = "host_to_l1", orbit.transfer_event = 42 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, 32>, static_src_sizes = array<i64: 128, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x32xf32, strided<[32, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%95) : (!air.async.token) -> ()
          %96 = "arith.constant"() <{value = 0 : index}> : () -> index
          %97 = "arith.constant"() <{value = 4 : index}> : () -> index
          %98 = "arith.constant"() <{value = 1 : index}> : () -> index
          %99 = "scf.for"(%96, %97, %98, %95) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %100 = "arith.constant"() <{value = 8 : index}> : () -> index
            %101 = "arith.muli"(%arg50, %100) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %102 = "arith.constant"() <{value = 8 : index}> : () -> index
            %103 = "arith.muli"(%arg50, %102) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %104 = "arith.constant"() <{value = 8 : index}> : () -> index
            %105 = "arith.muli"(%arg50, %104) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %106 = "memref.reinterpret_cast"(%92) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %107 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %108 = "arith.constant"() <{value = 0 : index}> : () -> index
            %109 = "arith.constant"() <{value = 8 : index}> : () -> index
            %110 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%108, %109, %110) ({
            ^bb0(%arg57: index):
              %190 = "arith.addi"(%arg57, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %191 = "arith.constant"() <{value = 32 : index}> : () -> index
              %192 = "arith.constant"() <{value = 64 : index}> : () -> index
              %193 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%191, %192, %193) ({
              ^bb0(%arg58: index):
                %194 = "arith.constant"() <{value = 32 : index}> : () -> index
                %195 = "arith.subi"(%arg58, %194) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %196 = "arith.subi"(%190, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%107, %106, %196, %195) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %111 = "arith.constant"() <{value = 0 : index}> : () -> index
            %112 = "arith.constant"() <{value = 4 : index}> : () -> index
            %113 = "arith.constant"() <{value = 1 : index}> : () -> index
            %114 = "scf.for"(%111, %112, %113, %arg51) ({
            ^bb0(%arg52: index, %arg53: !air.async.token):
              %119 = "arith.constant"() <{value = 32 : index}> : () -> index
              %120 = "arith.muli"(%arg52, %119) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %121 = "arith.constant"() <{value = 32 : index}> : () -> index
              %122 = "arith.muli"(%arg52, %121) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %123 = "arith.constant"() <{value = 32 : index}> : () -> index
              %124 = "arith.muli"(%arg52, %123) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %125 = "memref.reinterpret_cast"(%90) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %126 = "arith.constant"() <{value = 0 : index}> : () -> index
              %127 = "arith.addi"(%126, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %128 = "arith.constant"() <{value = 0 : index}> : () -> index
              %129 = "arith.addi"(%128, %122) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %130 = "air.dma_memcpy_nd"(%arg53, %125, %arg46, %127, %129) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 24 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 68>, orbit.transfer = "host_to_l1", orbit.transfer_event = 41 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%130) {orbit.computation_event = 44 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 68, 69, 73>, orbit.task = "gemm", orbit.write_copies = array<i64: 74>} : (!air.async.token) -> ()
              %131 = "memref.cast"(%125) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
              %132 = "memref.cast"(%94) : (memref<128x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<128x32xf32, 2 : i32>
              %133 = "memref.cast"(%106) : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> memref<8x32xf32, 2 : i32>
              %134 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %135 = "arith.constant"() <{value = 0 : index}> : () -> index
              %136 = "arith.constant"() <{value = 8 : index}> : () -> index
              %137 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%135, %136, %137) ({
              ^bb0(%arg54: index):
                %139 = "arith.addi"(%arg54, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %140 = "arith.constant"() <{value = 32 : index}> : () -> index
                %141 = "arith.constant"() <{value = 64 : index}> : () -> index
                %142 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%140, %141, %142) ({
                ^bb0(%arg55: index):
                  %143 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %144 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %145 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%143, %144, %145) ({
                  ^bb0(%arg56: index):
                    %146 = "arith.addi"(%arg56, %120) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %147 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %148 = "arith.subi"(%139, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %149 = "arith.subi"(%146, %122) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %150 = "memref.load"(%131, %148, %149) <{nontemporal = false}> : (memref<8x32xf32, 2 : i32>, index, index) -> f32
                    %151 = "vector.broadcast"(%150) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                    %152 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %153 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %154 = "arith.subi"(%arg55, %153) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %155 = "vector.transfer_read"(%132, %146, %154, %152) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<128x32xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %156 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %157 = "arith.subi"(%139, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %158 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %159 = "arith.subi"(%arg55, %158) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %160 = "vector.transfer_read"(%133, %157, %159, %156) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %161 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                    %162 = "vector.extract"(%155) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %163 = "func.call"(%150, %162) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %164 = "vector.insert"(%163, %161) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %165 = "vector.extract"(%155) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %166 = "func.call"(%150, %165) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %167 = "vector.insert"(%166, %164) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %168 = "vector.extract"(%155) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %169 = "func.call"(%150, %168) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %170 = "vector.insert"(%169, %167) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %171 = "vector.extract"(%155) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %172 = "func.call"(%150, %171) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %173 = "vector.insert"(%172, %170) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %174 = "vector.extract"(%155) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %175 = "func.call"(%150, %174) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %176 = "vector.insert"(%175, %173) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %177 = "vector.extract"(%155) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %178 = "func.call"(%150, %177) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %179 = "vector.insert"(%178, %176) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %180 = "vector.extract"(%155) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %181 = "func.call"(%150, %180) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %182 = "vector.insert"(%181, %179) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %183 = "vector.extract"(%155) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %184 = "func.call"(%150, %183) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %185 = "vector.insert"(%184, %182) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %186 = "arith.addf"(%160, %185) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %187 = "arith.subi"(%139, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %188 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %189 = "arith.subi"(%arg55, %188) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%186, %133, %187, %189) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %138 = "air.wait_all"(%arg53) : (!air.async.token) -> !air.async.token
              "scf.yield"(%138) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %115 = "arith.constant"() <{value = 0 : index}> : () -> index
            %116 = "arith.addi"(%115, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %117 = "air.dma_memcpy_nd"(%114, %arg49, %116, %106) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 27 : i64, orbit.retained_begin = 24 : i64, orbit.retained_end = 28 : i64, orbit.source_copies = array<i64: 80>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 81>, orbit.transfer = "l1_to_host", orbit.transfer_event = 51 : i64, static_dst_offsets = array<i64: -9223372036854775808, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %118 = "air.wait_all"(%117) : (!air.async.token) -> !air.async.token
            "scf.yield"(%118) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%99) : (!air.async.token) -> ()
          "memref.dealloc"(%90) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%91) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%92) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_24"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_24"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_24"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
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
              %31 = "air.dma_memcpy_nd"(%arg27, %26, %arg23, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 37>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 112>, orbit.transfer = "host_to_l1", orbit.transfer_event = 82 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%31) {orbit.computation_event = 83 : i64, orbit.phase = 40 : i64, orbit.phase_dependencies = array<i64: 39>, orbit.read_copies = array<i64: 112>, orbit.task = "scale", orbit.write_copies = array<i64: 113>} : (!air.async.token) -> ()
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
              %42 = "air.dma_memcpy_nd"(%arg27, %arg22, %39, %41, %25) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 113>, orbit.storage = "Y", orbit.target_copies = array<i64: 114>, orbit.transfer = "l1_to_host", orbit.transfer_event = 84 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
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
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "a74808412f7f1080043fdf5cce5c8d4915a6f7250469f50fd65256bed4ea54f4", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} : () -> ()

