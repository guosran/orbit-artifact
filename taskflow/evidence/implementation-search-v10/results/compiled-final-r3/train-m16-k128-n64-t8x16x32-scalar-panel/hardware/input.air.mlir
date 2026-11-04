"builtin.module"() ({
  "func.func"() <{function_type = (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg117: index, %arg118: index, %arg119: index, %arg120: index, %arg121: memref<16x128xf32>, %arg122: memref<128x64xf32>, %arg123: memref<16x64xf32>, %arg124: memref<16x64xf32>):
      "air.segment"(%arg121, %arg122, %arg123, %arg124) ({
      ^bb0(%arg125: memref<16x128xf32>, %arg126: memref<128x64xf32>, %arg127: memref<16x64xf32>, %arg128: memref<16x64xf32>):
        %284 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%284, %284, %arg125, %arg126, %arg127, %arg128) ({
        ^bb0(%arg129: index, %arg130: index, %arg131: index, %arg132: index, %arg133: memref<16x128xf32>, %arg134: memref<128x64xf32>, %arg135: memref<16x64xf32>, %arg136: memref<16x64xf32>):
          %285 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %286 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %287 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %288 = "air.wait_all"() : () -> !air.async.token
          %289 = "memref.reinterpret_cast"(%286) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 8 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %290 = "air.dma_memcpy_nd"(%288, %289, %arg134) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 8 : i64, orbit.readonly_retained_begin = 8 : i64, orbit.readonly_retained_end = 16 : i64, orbit.source_copies = array<i64: 8, 12, 16, 20>, orbit.storage = "B", orbit.target_copies = array<i64: 25, 26, 27, 28>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%290) : (!air.async.token) -> ()
          %291 = "arith.constant"() <{value = 0 : index}> : () -> index
          %292 = "arith.constant"() <{value = 2 : index}> : () -> index
          %293 = "arith.constant"() <{value = 1 : index}> : () -> index
          %294 = "scf.for"(%291, %292, %293, %290) ({
          ^bb0(%arg137: index, %arg138: !air.async.token):
            %295 = "arith.constant"() <{value = 8 : index}> : () -> index
            %296 = "arith.muli"(%arg137, %295) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %297 = "arith.constant"() <{value = 8 : index}> : () -> index
            %298 = "arith.muli"(%arg137, %297) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %299 = "arith.constant"() <{value = 8 : index}> : () -> index
            %300 = "arith.muli"(%arg137, %299) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %301 = "memref.reinterpret_cast"(%287) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %302 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %303 = "arith.constant"() <{value = 0 : index}> : () -> index
            %304 = "arith.constant"() <{value = 8 : index}> : () -> index
            %305 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%303, %304, %305) ({
            ^bb0(%arg144: index):
              %348 = "arith.addi"(%arg144, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %349 = "arith.constant"() <{value = 0 : index}> : () -> index
              %350 = "arith.constant"() <{value = 16 : index}> : () -> index
              %351 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%349, %350, %351) ({
              ^bb0(%arg145: index):
                %352 = "arith.subi"(%348, %300) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%302, %301, %352, %arg145) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %306 = "arith.constant"() <{value = 0 : index}> : () -> index
            %307 = "arith.constant"() <{value = 4 : index}> : () -> index
            %308 = "arith.constant"() <{value = 1 : index}> : () -> index
            %309 = "scf.for"(%306, %307, %308, %arg138) ({
            ^bb0(%arg139: index, %arg140: !air.async.token):
              %314 = "arith.constant"() <{value = 32 : index}> : () -> index
              %315 = "arith.muli"(%arg139, %314) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %316 = "arith.constant"() <{value = 32 : index}> : () -> index
              %317 = "arith.muli"(%arg139, %316) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %318 = "arith.constant"() <{value = 32 : index}> : () -> index
              %319 = "arith.muli"(%arg139, %318) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %320 = "memref.reinterpret_cast"(%285) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %321 = "arith.constant"() <{value = 0 : index}> : () -> index
              %322 = "arith.addi"(%321, %298) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %323 = "arith.constant"() <{value = 0 : index}> : () -> index
              %324 = "arith.addi"(%323, %317) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %325 = "air.dma_memcpy_nd"(%arg140, %320, %arg133, %322, %324) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 24>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<16x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%325) {orbit.computation_event = 3 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.read_copies = array<i64: 24, 25, 29>, orbit.task = "gemm", orbit.write_copies = array<i64: 30>} : (!air.async.token) -> ()
              %326 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %327 = "arith.constant"() <{value = 0 : index}> : () -> index
              %328 = "arith.constant"() <{value = 8 : index}> : () -> index
              %329 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%327, %328, %329) ({
              ^bb0(%arg141: index):
                %331 = "arith.addi"(%arg141, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %332 = "arith.constant"() <{value = 0 : index}> : () -> index
                %333 = "arith.constant"() <{value = 16 : index}> : () -> index
                %334 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%332, %333, %334) ({
                ^bb0(%arg142: index):
                  %335 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %336 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %337 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%335, %336, %337) ({
                  ^bb0(%arg143: index):
                    %338 = "arith.addi"(%arg143, %315) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %339 = "arith.subi"(%331, %298) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %340 = "arith.subi"(%338, %317) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %341 = "memref.load"(%320, %339, %340) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %342 = "memref.load"(%289, %338, %arg142) <{nontemporal = false}> : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %343 = "arith.subi"(%331, %300) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %344 = "memref.load"(%301, %343, %arg142) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %345 = "arith.mulf"(%341, %342) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %346 = "arith.addf"(%344, %345) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %347 = "arith.subi"(%331, %300) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%346, %301, %347, %arg142) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %330 = "air.wait_all"(%arg140) : (!air.async.token) -> !air.async.token
              "scf.yield"(%330) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %310 = "arith.constant"() <{value = 0 : index}> : () -> index
            %311 = "arith.addi"(%310, %300) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %312 = "air.dma_memcpy_nd"(%309, %arg136, %311, %301) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11 : i64, orbit.retained_begin = 8 : i64, orbit.retained_end = 12 : i64, orbit.source_copies = array<i64: 36>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 37>, orbit.transfer = "l1_to_host", orbit.transfer_event = 10 : i64, static_dst_offsets = array<i64: -9223372036854775808, 0>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<16x64xf32>, index, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %313 = "air.wait_all"(%312) : (!air.async.token) -> !air.async.token
            "scf.yield"(%313) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%294) : (!air.async.token) -> ()
          "memref.dealloc"(%285) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%286) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%287) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg88: index, %arg89: index, %arg90: index, %arg91: index, %arg92: memref<16x128xf32>, %arg93: memref<128x64xf32>, %arg94: memref<16x64xf32>, %arg95: memref<16x64xf32>):
      "air.segment"(%arg92, %arg93, %arg94, %arg95) ({
      ^bb0(%arg96: memref<16x128xf32>, %arg97: memref<128x64xf32>, %arg98: memref<16x64xf32>, %arg99: memref<16x64xf32>):
        %207 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%207, %207, %arg96, %arg97, %arg98, %arg99) ({
        ^bb0(%arg100: index, %arg101: index, %arg102: index, %arg103: index, %arg104: memref<16x128xf32>, %arg105: memref<128x64xf32>, %arg106: memref<16x64xf32>, %arg107: memref<16x64xf32>):
          %208 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %209 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %210 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %211 = "air.wait_all"() : () -> !air.async.token
          %212 = "memref.reinterpret_cast"(%209) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 16 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %213 = "air.dma_memcpy_nd"(%211, %212, %arg105) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 16 : i64, orbit.readonly_retained_begin = 16 : i64, orbit.readonly_retained_end = 24 : i64, orbit.source_copies = array<i64: 9, 13, 17, 21>, orbit.storage = "B", orbit.target_copies = array<i64: 49, 50, 51, 52>, orbit.transfer = "host_to_l1", orbit.transfer_event = 22 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 16>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%213) : (!air.async.token) -> ()
          %214 = "arith.constant"() <{value = 0 : index}> : () -> index
          %215 = "arith.constant"() <{value = 2 : index}> : () -> index
          %216 = "arith.constant"() <{value = 1 : index}> : () -> index
          %217 = "scf.for"(%214, %215, %216, %213) ({
          ^bb0(%arg108: index, %arg109: !air.async.token):
            %218 = "arith.constant"() <{value = 8 : index}> : () -> index
            %219 = "arith.muli"(%arg108, %218) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %220 = "arith.constant"() <{value = 8 : index}> : () -> index
            %221 = "arith.muli"(%arg108, %220) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %222 = "arith.constant"() <{value = 8 : index}> : () -> index
            %223 = "arith.muli"(%arg108, %222) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %224 = "memref.reinterpret_cast"(%210) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %225 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %226 = "arith.constant"() <{value = 0 : index}> : () -> index
            %227 = "arith.constant"() <{value = 8 : index}> : () -> index
            %228 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%226, %227, %228) ({
            ^bb0(%arg115: index):
              %277 = "arith.addi"(%arg115, %219) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %278 = "arith.constant"() <{value = 16 : index}> : () -> index
              %279 = "arith.constant"() <{value = 32 : index}> : () -> index
              %280 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%278, %279, %280) ({
              ^bb0(%arg116: index):
                %281 = "arith.constant"() <{value = 16 : index}> : () -> index
                %282 = "arith.subi"(%arg116, %281) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %283 = "arith.subi"(%277, %223) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%225, %224, %283, %282) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %229 = "arith.constant"() <{value = 0 : index}> : () -> index
            %230 = "arith.constant"() <{value = 4 : index}> : () -> index
            %231 = "arith.constant"() <{value = 1 : index}> : () -> index
            %232 = "scf.for"(%229, %230, %231, %arg109) ({
            ^bb0(%arg110: index, %arg111: !air.async.token):
              %237 = "arith.constant"() <{value = 32 : index}> : () -> index
              %238 = "arith.muli"(%arg110, %237) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %239 = "arith.constant"() <{value = 32 : index}> : () -> index
              %240 = "arith.muli"(%arg110, %239) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %241 = "arith.constant"() <{value = 32 : index}> : () -> index
              %242 = "arith.muli"(%arg110, %241) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %243 = "memref.reinterpret_cast"(%208) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 16 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %244 = "arith.constant"() <{value = 0 : index}> : () -> index
              %245 = "arith.addi"(%244, %221) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %246 = "arith.constant"() <{value = 0 : index}> : () -> index
              %247 = "arith.addi"(%246, %240) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %248 = "air.dma_memcpy_nd"(%arg111, %243, %arg104, %245, %247) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 16 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 48>, orbit.transfer = "host_to_l1", orbit.transfer_event = 21 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<16x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%248) {orbit.computation_event = 24 : i64, orbit.phase = 16 : i64, orbit.phase_dependencies = array<i64: 15>, orbit.read_copies = array<i64: 48, 49, 53>, orbit.task = "gemm", orbit.write_copies = array<i64: 54>} : (!air.async.token) -> ()
              %249 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %250 = "arith.constant"() <{value = 0 : index}> : () -> index
              %251 = "arith.constant"() <{value = 8 : index}> : () -> index
              %252 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%250, %251, %252) ({
              ^bb0(%arg112: index):
                %254 = "arith.addi"(%arg112, %219) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %255 = "arith.constant"() <{value = 16 : index}> : () -> index
                %256 = "arith.constant"() <{value = 32 : index}> : () -> index
                %257 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%255, %256, %257) ({
                ^bb0(%arg113: index):
                  %258 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %259 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %260 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%258, %259, %260) ({
                  ^bb0(%arg114: index):
                    %261 = "arith.addi"(%arg114, %238) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %262 = "arith.subi"(%254, %221) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %263 = "arith.subi"(%261, %240) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %264 = "memref.load"(%243, %262, %263) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %265 = "arith.constant"() <{value = 16 : index}> : () -> index
                    %266 = "arith.subi"(%arg113, %265) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %267 = "memref.load"(%212, %261, %266) <{nontemporal = false}> : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %268 = "arith.constant"() <{value = 16 : index}> : () -> index
                    %269 = "arith.subi"(%arg113, %268) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %270 = "arith.subi"(%254, %223) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %271 = "memref.load"(%224, %270, %269) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %272 = "arith.mulf"(%264, %267) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %273 = "arith.addf"(%271, %272) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %274 = "arith.constant"() <{value = 16 : index}> : () -> index
                    %275 = "arith.subi"(%arg113, %274) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %276 = "arith.subi"(%254, %223) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%273, %224, %276, %275) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %253 = "air.wait_all"(%arg111) : (!air.async.token) -> !air.async.token
              "scf.yield"(%253) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %233 = "arith.constant"() <{value = 0 : index}> : () -> index
            %234 = "arith.addi"(%233, %223) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %235 = "air.dma_memcpy_nd"(%232, %arg107, %234, %224) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 19 : i64, orbit.retained_begin = 16 : i64, orbit.retained_end = 20 : i64, orbit.source_copies = array<i64: 60>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 61>, orbit.transfer = "l1_to_host", orbit.transfer_event = 31 : i64, static_dst_offsets = array<i64: -9223372036854775808, 16>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<16x64xf32>, index, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %236 = "air.wait_all"(%235) : (!air.async.token) -> !air.async.token
            "scf.yield"(%236) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%217) : (!air.async.token) -> ()
          "memref.dealloc"(%208) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%209) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%210) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_16"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_16"} : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_16"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg59: index, %arg60: index, %arg61: index, %arg62: index, %arg63: memref<16x128xf32>, %arg64: memref<128x64xf32>, %arg65: memref<16x64xf32>, %arg66: memref<16x64xf32>):
      "air.segment"(%arg63, %arg64, %arg65, %arg66) ({
      ^bb0(%arg67: memref<16x128xf32>, %arg68: memref<128x64xf32>, %arg69: memref<16x64xf32>, %arg70: memref<16x64xf32>):
        %130 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%130, %130, %arg67, %arg68, %arg69, %arg70) ({
        ^bb0(%arg71: index, %arg72: index, %arg73: index, %arg74: index, %arg75: memref<16x128xf32>, %arg76: memref<128x64xf32>, %arg77: memref<16x64xf32>, %arg78: memref<16x64xf32>):
          %131 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %132 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %133 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %134 = "air.wait_all"() : () -> !air.async.token
          %135 = "memref.reinterpret_cast"(%132) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 24 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %136 = "air.dma_memcpy_nd"(%134, %135, %arg76) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 24 : i64, orbit.readonly_retained_begin = 24 : i64, orbit.readonly_retained_end = 32 : i64, orbit.source_copies = array<i64: 10, 14, 18, 22>, orbit.storage = "B", orbit.target_copies = array<i64: 73, 74, 75, 76>, orbit.transfer = "host_to_l1", orbit.transfer_event = 43 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 32>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%136) : (!air.async.token) -> ()
          %137 = "arith.constant"() <{value = 0 : index}> : () -> index
          %138 = "arith.constant"() <{value = 2 : index}> : () -> index
          %139 = "arith.constant"() <{value = 1 : index}> : () -> index
          %140 = "scf.for"(%137, %138, %139, %136) ({
          ^bb0(%arg79: index, %arg80: !air.async.token):
            %141 = "arith.constant"() <{value = 8 : index}> : () -> index
            %142 = "arith.muli"(%arg79, %141) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %143 = "arith.constant"() <{value = 8 : index}> : () -> index
            %144 = "arith.muli"(%arg79, %143) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %145 = "arith.constant"() <{value = 8 : index}> : () -> index
            %146 = "arith.muli"(%arg79, %145) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %147 = "memref.reinterpret_cast"(%133) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %148 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %149 = "arith.constant"() <{value = 0 : index}> : () -> index
            %150 = "arith.constant"() <{value = 8 : index}> : () -> index
            %151 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%149, %150, %151) ({
            ^bb0(%arg86: index):
              %200 = "arith.addi"(%arg86, %142) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %201 = "arith.constant"() <{value = 32 : index}> : () -> index
              %202 = "arith.constant"() <{value = 48 : index}> : () -> index
              %203 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%201, %202, %203) ({
              ^bb0(%arg87: index):
                %204 = "arith.constant"() <{value = 32 : index}> : () -> index
                %205 = "arith.subi"(%arg87, %204) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %206 = "arith.subi"(%200, %146) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%148, %147, %206, %205) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %152 = "arith.constant"() <{value = 0 : index}> : () -> index
            %153 = "arith.constant"() <{value = 4 : index}> : () -> index
            %154 = "arith.constant"() <{value = 1 : index}> : () -> index
            %155 = "scf.for"(%152, %153, %154, %arg80) ({
            ^bb0(%arg81: index, %arg82: !air.async.token):
              %160 = "arith.constant"() <{value = 32 : index}> : () -> index
              %161 = "arith.muli"(%arg81, %160) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %162 = "arith.constant"() <{value = 32 : index}> : () -> index
              %163 = "arith.muli"(%arg81, %162) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %164 = "arith.constant"() <{value = 32 : index}> : () -> index
              %165 = "arith.muli"(%arg81, %164) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %166 = "memref.reinterpret_cast"(%131) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %167 = "arith.constant"() <{value = 0 : index}> : () -> index
              %168 = "arith.addi"(%167, %144) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %169 = "arith.constant"() <{value = 0 : index}> : () -> index
              %170 = "arith.addi"(%169, %163) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %171 = "air.dma_memcpy_nd"(%arg82, %166, %arg75, %168, %170) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 24 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 72>, orbit.transfer = "host_to_l1", orbit.transfer_event = 42 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<16x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%171) {orbit.computation_event = 45 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 72, 73, 77>, orbit.task = "gemm", orbit.write_copies = array<i64: 78>} : (!air.async.token) -> ()
              %172 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %173 = "arith.constant"() <{value = 0 : index}> : () -> index
              %174 = "arith.constant"() <{value = 8 : index}> : () -> index
              %175 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%173, %174, %175) ({
              ^bb0(%arg83: index):
                %177 = "arith.addi"(%arg83, %142) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %178 = "arith.constant"() <{value = 32 : index}> : () -> index
                %179 = "arith.constant"() <{value = 48 : index}> : () -> index
                %180 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%178, %179, %180) ({
                ^bb0(%arg84: index):
                  %181 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %182 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %183 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%181, %182, %183) ({
                  ^bb0(%arg85: index):
                    %184 = "arith.addi"(%arg85, %161) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %185 = "arith.subi"(%177, %144) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %186 = "arith.subi"(%184, %163) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %187 = "memref.load"(%166, %185, %186) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %188 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %189 = "arith.subi"(%arg84, %188) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %190 = "memref.load"(%135, %184, %189) <{nontemporal = false}> : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %191 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %192 = "arith.subi"(%arg84, %191) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %193 = "arith.subi"(%177, %146) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %194 = "memref.load"(%147, %193, %192) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %195 = "arith.mulf"(%187, %190) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %196 = "arith.addf"(%194, %195) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %197 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %198 = "arith.subi"(%arg84, %197) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %199 = "arith.subi"(%177, %146) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%196, %147, %199, %198) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %176 = "air.wait_all"(%arg82) : (!air.async.token) -> !air.async.token
              "scf.yield"(%176) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %156 = "arith.constant"() <{value = 0 : index}> : () -> index
            %157 = "arith.addi"(%156, %146) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %158 = "air.dma_memcpy_nd"(%155, %arg78, %157, %147) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 27 : i64, orbit.retained_begin = 24 : i64, orbit.retained_end = 28 : i64, orbit.source_copies = array<i64: 84>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 85>, orbit.transfer = "l1_to_host", orbit.transfer_event = 52 : i64, static_dst_offsets = array<i64: -9223372036854775808, 32>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<16x64xf32>, index, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %159 = "air.wait_all"(%158) : (!air.async.token) -> !air.async.token
            "scf.yield"(%159) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%140) : (!air.async.token) -> ()
          "memref.dealloc"(%131) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%132) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%133) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_24"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_24"} : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_24"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg30: index, %arg31: index, %arg32: index, %arg33: index, %arg34: memref<16x128xf32>, %arg35: memref<128x64xf32>, %arg36: memref<16x64xf32>, %arg37: memref<16x64xf32>):
      "air.segment"(%arg34, %arg35, %arg36, %arg37) ({
      ^bb0(%arg38: memref<16x128xf32>, %arg39: memref<128x64xf32>, %arg40: memref<16x64xf32>, %arg41: memref<16x64xf32>):
        %53 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%53, %53, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<16x128xf32>, %arg47: memref<128x64xf32>, %arg48: memref<16x64xf32>, %arg49: memref<16x64xf32>):
          %54 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %55 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %56 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %57 = "air.wait_all"() : () -> !air.async.token
          %58 = "memref.reinterpret_cast"(%55) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 32 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %59 = "air.dma_memcpy_nd"(%57, %58, %arg47) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 32 : i64, orbit.readonly_retained_begin = 32 : i64, orbit.readonly_retained_end = 40 : i64, orbit.source_copies = array<i64: 11, 15, 19, 23>, orbit.storage = "B", orbit.target_copies = array<i64: 97, 98, 99, 100>, orbit.transfer = "host_to_l1", orbit.transfer_event = 64 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 48>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%59) : (!air.async.token) -> ()
          %60 = "arith.constant"() <{value = 0 : index}> : () -> index
          %61 = "arith.constant"() <{value = 2 : index}> : () -> index
          %62 = "arith.constant"() <{value = 1 : index}> : () -> index
          %63 = "scf.for"(%60, %61, %62, %59) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %64 = "arith.constant"() <{value = 8 : index}> : () -> index
            %65 = "arith.muli"(%arg50, %64) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %66 = "arith.constant"() <{value = 8 : index}> : () -> index
            %67 = "arith.muli"(%arg50, %66) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %68 = "arith.constant"() <{value = 8 : index}> : () -> index
            %69 = "arith.muli"(%arg50, %68) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %70 = "memref.reinterpret_cast"(%56) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %71 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %72 = "arith.constant"() <{value = 0 : index}> : () -> index
            %73 = "arith.constant"() <{value = 8 : index}> : () -> index
            %74 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%72, %73, %74) ({
            ^bb0(%arg57: index):
              %123 = "arith.addi"(%arg57, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %124 = "arith.constant"() <{value = 48 : index}> : () -> index
              %125 = "arith.constant"() <{value = 64 : index}> : () -> index
              %126 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%124, %125, %126) ({
              ^bb0(%arg58: index):
                %127 = "arith.constant"() <{value = 48 : index}> : () -> index
                %128 = "arith.subi"(%arg58, %127) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %129 = "arith.subi"(%123, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%71, %70, %129, %128) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %75 = "arith.constant"() <{value = 0 : index}> : () -> index
            %76 = "arith.constant"() <{value = 4 : index}> : () -> index
            %77 = "arith.constant"() <{value = 1 : index}> : () -> index
            %78 = "scf.for"(%75, %76, %77, %arg51) ({
            ^bb0(%arg52: index, %arg53: !air.async.token):
              %83 = "arith.constant"() <{value = 32 : index}> : () -> index
              %84 = "arith.muli"(%arg52, %83) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %85 = "arith.constant"() <{value = 32 : index}> : () -> index
              %86 = "arith.muli"(%arg52, %85) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %87 = "arith.constant"() <{value = 32 : index}> : () -> index
              %88 = "arith.muli"(%arg52, %87) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %89 = "memref.reinterpret_cast"(%54) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 32 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %90 = "arith.constant"() <{value = 0 : index}> : () -> index
              %91 = "arith.addi"(%90, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %92 = "arith.constant"() <{value = 0 : index}> : () -> index
              %93 = "arith.addi"(%92, %86) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %94 = "air.dma_memcpy_nd"(%arg53, %89, %arg46, %91, %93) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 32 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 96>, orbit.transfer = "host_to_l1", orbit.transfer_event = 63 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<16x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%94) {orbit.computation_event = 66 : i64, orbit.phase = 32 : i64, orbit.phase_dependencies = array<i64: 31>, orbit.read_copies = array<i64: 96, 97, 101>, orbit.task = "gemm", orbit.write_copies = array<i64: 102>} : (!air.async.token) -> ()
              %95 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %96 = "arith.constant"() <{value = 0 : index}> : () -> index
              %97 = "arith.constant"() <{value = 8 : index}> : () -> index
              %98 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%96, %97, %98) ({
              ^bb0(%arg54: index):
                %100 = "arith.addi"(%arg54, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %101 = "arith.constant"() <{value = 48 : index}> : () -> index
                %102 = "arith.constant"() <{value = 64 : index}> : () -> index
                %103 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%101, %102, %103) ({
                ^bb0(%arg55: index):
                  %104 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %105 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %106 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%104, %105, %106) ({
                  ^bb0(%arg56: index):
                    %107 = "arith.addi"(%arg56, %84) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %108 = "arith.subi"(%100, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %109 = "arith.subi"(%107, %86) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %110 = "memref.load"(%89, %108, %109) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %111 = "arith.constant"() <{value = 48 : index}> : () -> index
                    %112 = "arith.subi"(%arg55, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %113 = "memref.load"(%58, %107, %112) <{nontemporal = false}> : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %114 = "arith.constant"() <{value = 48 : index}> : () -> index
                    %115 = "arith.subi"(%arg55, %114) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %116 = "arith.subi"(%100, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %117 = "memref.load"(%70, %116, %115) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                    %118 = "arith.mulf"(%110, %113) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %119 = "arith.addf"(%117, %118) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %120 = "arith.constant"() <{value = 48 : index}> : () -> index
                    %121 = "arith.subi"(%arg55, %120) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %122 = "arith.subi"(%100, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%119, %70, %122, %121) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %99 = "air.wait_all"(%arg53) : (!air.async.token) -> !air.async.token
              "scf.yield"(%99) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %79 = "arith.constant"() <{value = 0 : index}> : () -> index
            %80 = "arith.addi"(%79, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %81 = "air.dma_memcpy_nd"(%78, %arg49, %80, %70) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 35 : i64, orbit.retained_begin = 32 : i64, orbit.retained_end = 36 : i64, orbit.source_copies = array<i64: 108>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 109>, orbit.transfer = "l1_to_host", orbit.transfer_event = 73 : i64, static_dst_offsets = array<i64: -9223372036854775808, 48>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<16x64xf32>, index, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %82 = "air.wait_all"(%81) : (!air.async.token) -> !air.async.token
            "scf.yield"(%82) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%63) : (!air.async.token) -> ()
          "memref.dealloc"(%54) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%55) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%56) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_32"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_32"} : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_32"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<16x128xf32>, %arg9: memref<128x64xf32>, %arg10: memref<16x64xf32>, %arg11: memref<16x64xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<16x128xf32>, %arg13: memref<128x64xf32>, %arg14: memref<16x64xf32>, %arg15: memref<16x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<16x128xf32>, %arg21: memref<128x64xf32>, %arg22: memref<16x64xf32>, %arg23: memref<16x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<128xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : () -> memref<128xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 2 : index}> : () -> index
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
            %16 = "arith.constant"() <{value = 4 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg25) ({
            ^bb0(%arg26: index, %arg27: !air.async.token):
              %19 = "arith.constant"() <{value = 16 : index}> : () -> index
              %20 = "arith.muli"(%arg26, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 16 : index}> : () -> index
              %22 = "arith.muli"(%arg26, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 16 : index}> : () -> index
              %24 = "arith.muli"(%arg26, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 40 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %26 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 40 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0 : index}> : () -> index
              %28 = "arith.addi"(%27, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %29 = "arith.constant"() <{value = 0 : index}> : () -> index
              %30 = "arith.addi"(%29, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "air.dma_memcpy_nd"(%arg27, %26, %arg23, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 37>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 120>, orbit.transfer = "host_to_l1", orbit.transfer_event = 84 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, memref<16x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%31) {orbit.computation_event = 85 : i64, orbit.phase = 40 : i64, orbit.phase_dependencies = array<i64: 39>, orbit.read_copies = array<i64: 120>, orbit.task = "scale", orbit.write_copies = array<i64: 121>} : (!air.async.token) -> ()
              %32 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
              %33 = "arith.constant"() <{value = 0 : index}> : () -> index
              %34 = "arith.constant"() <{value = 8 : index}> : () -> index
              %35 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%33, %34, %35) ({
              ^bb0(%arg28: index):
                %42 = "arith.addi"(%arg28, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %43 = "arith.constant"() <{value = 0 : index}> : () -> index
                %44 = "arith.constant"() <{value = 16 : index}> : () -> index
                %45 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%43, %44, %45) ({
                ^bb0(%arg29: index):
                  %46 = "arith.addi"(%arg29, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %47 = "arith.subi"(%42, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %48 = "arith.subi"(%46, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %49 = "memref.load"(%26, %47, %48) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %50 = "arith.mulf"(%49, %32) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %51 = "arith.subi"(%42, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "arith.subi"(%46, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%50, %25, %51, %52) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %36 = "arith.constant"() <{value = 0 : index}> : () -> index
              %37 = "arith.addi"(%36, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %38 = "arith.constant"() <{value = 0 : index}> : () -> index
              %39 = "arith.addi"(%38, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %40 = "air.dma_memcpy_nd"(%arg27, %arg22, %37, %39, %25) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 121>, orbit.storage = "Y", orbit.target_copies = array<i64: 122>, orbit.transfer = "l1_to_host", orbit.transfer_event = 86 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<16x64xf32>, index, index, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
              %41 = "air.wait_all"(%40) : (!air.async.token) -> !air.async.token
              "scf.yield"(%41) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<128xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_40"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_40"} : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_40"} : (index, index, memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.mapping_plan = "5c4478413012fb3cc41e079c227a93e1774c5756c5e5ee9dd5e8768e56bbd6c4", orbit.source_fingerprint = "60fbbfc305db9d3a0222fda474d495f9bcd30577ace8a68d554bcd4f73a110a9"} : () -> ()

