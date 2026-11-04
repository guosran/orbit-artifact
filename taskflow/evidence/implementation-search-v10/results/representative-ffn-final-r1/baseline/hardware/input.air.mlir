#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> (), sym_name = "ffn"}> ({
  ^bb0(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg126: index, %arg127: index, %arg128: index, %arg129: index, %arg130: memref<5x2048xf32>, %arg131: memref<2048x11008xf32>, %arg132: memref<2048x11008xf32>, %arg133: memref<11008x2048xf32>, %arg134: memref<5x2048xf32>, %arg135: memref<5x11008xf32>, %arg136: memref<5x11008xf32>, %arg137: memref<5x11008xf32>):
      "air.segment"(%arg130, %arg131, %arg132, %arg133, %arg134, %arg135, %arg136, %arg137) ({
      ^bb0(%arg138: memref<5x2048xf32>, %arg139: memref<2048x11008xf32>, %arg140: memref<2048x11008xf32>, %arg141: memref<11008x2048xf32>, %arg142: memref<5x2048xf32>, %arg143: memref<5x11008xf32>, %arg144: memref<5x11008xf32>, %arg145: memref<5x11008xf32>):
        %253 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%253, %253, %arg138, %arg139, %arg140, %arg141, %arg142, %arg143, %arg144, %arg145) ({
        ^bb0(%arg146: index, %arg147: index, %arg148: index, %arg149: index, %arg150: memref<5x2048xf32>, %arg151: memref<2048x11008xf32>, %arg152: memref<2048x11008xf32>, %arg153: memref<11008x2048xf32>, %arg154: memref<5x2048xf32>, %arg155: memref<5x11008xf32>, %arg156: memref<5x11008xf32>, %arg157: memref<5x11008xf32>):
          %254 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %255 = "arith.constant"() <{value = 32 : index}> : () -> index
          %256 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %257 = "arith.constant"() <{value = 64 : index}> : () -> index
          %258 = "arith.constant"() <{value = 1 : index}> : () -> index
          %259 = "arith.constant"() <{value = 172 : index}> : () -> index
          %260 = "arith.constant"() <{value = 0 : index}> : () -> index
          %261 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.5.64.loops.5.64.64"} : () -> memref<320xf32, 2 : i32>
          %262 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.64.loops.5.64.64"} : () -> memref<4096xf32, 2 : i32>
          %263 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : () -> memref<320xf32, 2 : i32>
          %264 = "air.wait_all"() : () -> !air.async.token
          %265 = "scf.for"(%260, %259, %258, %264) ({
          ^bb0(%arg158: index, %arg159: !air.async.token):
            %266 = "arith.muli"(%arg158, %257) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %267 = "arith.muli"(%arg158, %257) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %268 = "arith.muli"(%arg158, %257) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %269 = "memref.reinterpret_cast"(%263) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "gate.initialize", orbit.phase = 172 : i64, orbit.storage = "G"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %270 = "arith.constant"() <{value = 0 : index}> : () -> index
            %271 = "arith.constant"() <{value = 5 : index}> : () -> index
            %272 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%270, %271, %272) ({
            ^bb0(%arg165: index):
              %328 = "arith.constant"() <{value = 0 : index}> : () -> index
              %329 = "arith.constant"() <{value = 64 : index}> : () -> index
              %330 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%328, %329, %330) ({
              ^bb0(%arg166: index):
                %331 = "arith.addi"(%arg166, %266) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %332 = "arith.subi"(%331, %268) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%256, %269, %arg165, %332) <{nontemporal = false}> : (f32, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %273 = "scf.for"(%260, %255, %258, %arg159) ({
            ^bb0(%arg160: index, %arg161: !air.async.token):
              %276 = "arith.muli"(%arg160, %257) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %277 = "arith.muli"(%arg160, %257) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %278 = "arith.muli"(%arg160, %257) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %279 = "memref.reinterpret_cast"(%261) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "X"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
              %280 = "air.dma_memcpy_nd"(%arg161, %279, %arg150, %277) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 16544>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x2048xf32>, index) -> !air.async.token
              %281 = "memref.reinterpret_cast"(%262) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "W_gate"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %282 = "air.dma_memcpy_nd"(%arg161, %281, %arg151, %278, %267) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 32>, orbit.storage = "W_gate", orbit.target_copies = array<i64: 16545>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%280, %282) {orbit.computation_event = 3 : i64, orbit.phase = 172 : i64, orbit.phase_dependencies = array<i64: 171>, orbit.read_copies = array<i64: 16544, 16545, 16546>, orbit.task = "gate", orbit.write_copies = array<i64: 16547>} : (!air.async.token, !air.async.token) -> ()
              %283 = "arith.constant"() <{value = 0 : index}> : () -> index
              %284 = "arith.constant"() <{value = 5 : index}> : () -> index
              %285 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%283, %284, %285) ({
              ^bb0(%arg162: index):
                %287 = "arith.constant"() <{value = 0 : index}> : () -> index
                %288 = "arith.constant"() <{value = 64 : index}> : () -> index
                %289 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%287, %288, %289) ({
                ^bb0(%arg163: index):
                  %290 = "arith.addi"(%arg163, %266) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %291 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %292 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %293 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%291, %292, %293) ({
                  ^bb0(%arg164: index):
                    %294 = "arith.addi"(%arg164, %276) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %295 = "arith.subi"(%294, %277) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %296 = "memref.load"(%279, %arg162, %295) <{nontemporal = false}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %297 = "arith.subi"(%294, %278) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %298 = "arith.subi"(%290, %267) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %299 = "vector.transfer_read"(%281, %297, %298, %256) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %300 = "arith.subi"(%290, %268) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %301 = "vector.transfer_read"(%269, %arg162, %300, %256) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %302 = "vector.extract"(%299) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %303 = "func.call"(%296, %302) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %304 = "vector.insert"(%303, %254) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %305 = "vector.extract"(%299) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %306 = "func.call"(%296, %305) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %307 = "vector.insert"(%306, %304) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %308 = "vector.extract"(%299) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %309 = "func.call"(%296, %308) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %310 = "vector.insert"(%309, %307) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %311 = "vector.extract"(%299) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %312 = "func.call"(%296, %311) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %313 = "vector.insert"(%312, %310) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %314 = "vector.extract"(%299) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %315 = "func.call"(%296, %314) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %316 = "vector.insert"(%315, %313) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %317 = "vector.extract"(%299) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %318 = "func.call"(%296, %317) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %319 = "vector.insert"(%318, %316) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %320 = "vector.extract"(%299) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %321 = "func.call"(%296, %320) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %322 = "vector.insert"(%321, %319) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %323 = "vector.extract"(%299) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %324 = "func.call"(%296, %323) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %325 = "vector.insert"(%324, %322) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %326 = "arith.addf"(%301, %325) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %327 = "arith.subi"(%290, %268) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%326, %269, %arg162, %327) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %286 = "air.wait_all"(%arg161) : (!air.async.token) -> !air.async.token
              "scf.yield"(%286) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %274 = "air.dma_memcpy_nd"(%273, %arg155, %268, %269) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 203 : i64, orbit.retained_begin = 172 : i64, orbit.retained_end = 204 : i64, orbit.source_copies = array<i64: 16640>, orbit.storage = "G", orbit.target_copies = array<i64: 16641>, orbit.transfer = "l1_to_host", orbit.transfer_event = 97 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<5x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %275 = "air.wait_all"(%274) : (!air.async.token) -> !air.async.token
            "scf.yield"(%275) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%265) : (!air.async.token) -> ()
          "memref.dealloc"(%261) : (memref<320xf32, 2 : i32>) -> ()
          "memref.dealloc"(%262) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%263) : (memref<320xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg85: index, %arg86: index, %arg87: index, %arg88: index, %arg89: memref<5x2048xf32>, %arg90: memref<2048x11008xf32>, %arg91: memref<2048x11008xf32>, %arg92: memref<11008x2048xf32>, %arg93: memref<5x2048xf32>, %arg94: memref<5x11008xf32>, %arg95: memref<5x11008xf32>, %arg96: memref<5x11008xf32>):
      "air.segment"(%arg89, %arg90, %arg91, %arg92, %arg93, %arg94, %arg95, %arg96) ({
      ^bb0(%arg97: memref<5x2048xf32>, %arg98: memref<2048x11008xf32>, %arg99: memref<2048x11008xf32>, %arg100: memref<11008x2048xf32>, %arg101: memref<5x2048xf32>, %arg102: memref<5x11008xf32>, %arg103: memref<5x11008xf32>, %arg104: memref<5x11008xf32>):
        %173 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%173, %173, %arg97, %arg98, %arg99, %arg100, %arg101, %arg102, %arg103, %arg104) ({
        ^bb0(%arg105: index, %arg106: index, %arg107: index, %arg108: index, %arg109: memref<5x2048xf32>, %arg110: memref<2048x11008xf32>, %arg111: memref<2048x11008xf32>, %arg112: memref<11008x2048xf32>, %arg113: memref<5x2048xf32>, %arg114: memref<5x11008xf32>, %arg115: memref<5x11008xf32>, %arg116: memref<5x11008xf32>):
          %174 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %175 = "arith.constant"() <{value = 32 : index}> : () -> index
          %176 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %177 = "arith.constant"() <{value = 64 : index}> : () -> index
          %178 = "arith.constant"() <{value = 1 : index}> : () -> index
          %179 = "arith.constant"() <{value = 172 : index}> : () -> index
          %180 = "arith.constant"() <{value = 0 : index}> : () -> index
          %181 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.5.64.loops.5.64.64"} : () -> memref<320xf32, 2 : i32>
          %182 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.64.64.loops.5.64.64"} : () -> memref<4096xf32, 2 : i32>
          %183 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data"} : () -> memref<320xf32, 2 : i32>
          %184 = "air.wait_all"() : () -> !air.async.token
          %185 = "scf.for"(%180, %179, %178, %184) ({
          ^bb0(%arg117: index, %arg118: !air.async.token):
            %186 = "arith.muli"(%arg117, %177) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %187 = "arith.muli"(%arg117, %177) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %188 = "arith.muli"(%arg117, %177) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %189 = "memref.reinterpret_cast"(%183) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "up.initialize", orbit.phase = 5848 : i64, orbit.storage = "U"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %190 = "arith.constant"() <{value = 0 : index}> : () -> index
            %191 = "arith.constant"() <{value = 5 : index}> : () -> index
            %192 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%190, %191, %192) ({
            ^bb0(%arg124: index):
              %248 = "arith.constant"() <{value = 0 : index}> : () -> index
              %249 = "arith.constant"() <{value = 64 : index}> : () -> index
              %250 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%248, %249, %250) ({
              ^bb0(%arg125: index):
                %251 = "arith.addi"(%arg125, %186) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %252 = "arith.subi"(%251, %188) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%176, %189, %arg124, %252) <{nontemporal = false}> : (f32, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %193 = "scf.for"(%180, %175, %178, %arg118) ({
            ^bb0(%arg119: index, %arg120: !air.async.token):
              %196 = "arith.muli"(%arg119, %177) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %197 = "arith.muli"(%arg119, %177) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %198 = "arith.muli"(%arg119, %177) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %199 = "memref.reinterpret_cast"(%181) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 5848 : i64, orbit.storage = "X"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
              %200 = "air.dma_memcpy_nd"(%arg120, %199, %arg109, %197) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 5848 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 33400>, orbit.transfer = "host_to_l1", orbit.transfer_event = 16856 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x2048xf32>, index) -> !air.async.token
              %201 = "memref.reinterpret_cast"(%182) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 5848 : i64, orbit.storage = "W_up"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %202 = "air.dma_memcpy_nd"(%arg120, %201, %arg111, %198, %187) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 5848 : i64, orbit.source_copies = array<i64: 5536>, orbit.storage = "W_up", orbit.target_copies = array<i64: 33401>, orbit.transfer = "host_to_l1", orbit.transfer_event = 16857 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%200, %202) {orbit.computation_event = 16859 : i64, orbit.phase = 5848 : i64, orbit.phase_dependencies = array<i64: 5847>, orbit.read_copies = array<i64: 33400, 33401, 33402>, orbit.task = "up", orbit.write_copies = array<i64: 33403>} : (!air.async.token, !air.async.token) -> ()
              %203 = "arith.constant"() <{value = 0 : index}> : () -> index
              %204 = "arith.constant"() <{value = 5 : index}> : () -> index
              %205 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%203, %204, %205) ({
              ^bb0(%arg121: index):
                %207 = "arith.constant"() <{value = 0 : index}> : () -> index
                %208 = "arith.constant"() <{value = 64 : index}> : () -> index
                %209 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%207, %208, %209) ({
                ^bb0(%arg122: index):
                  %210 = "arith.addi"(%arg122, %186) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %211 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %212 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %213 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%211, %212, %213) ({
                  ^bb0(%arg123: index):
                    %214 = "arith.addi"(%arg123, %196) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %215 = "arith.subi"(%214, %197) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %216 = "memref.load"(%199, %arg121, %215) <{nontemporal = false}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %217 = "arith.subi"(%214, %198) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %218 = "arith.subi"(%210, %187) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %219 = "vector.transfer_read"(%201, %217, %218, %176) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %220 = "arith.subi"(%210, %188) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %221 = "vector.transfer_read"(%189, %arg121, %220, %176) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %222 = "vector.extract"(%219) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %223 = "func.call"(%216, %222) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %224 = "vector.insert"(%223, %174) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %225 = "vector.extract"(%219) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %226 = "func.call"(%216, %225) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %227 = "vector.insert"(%226, %224) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %228 = "vector.extract"(%219) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %229 = "func.call"(%216, %228) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %230 = "vector.insert"(%229, %227) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %231 = "vector.extract"(%219) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %232 = "func.call"(%216, %231) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %233 = "vector.insert"(%232, %230) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %234 = "vector.extract"(%219) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %235 = "func.call"(%216, %234) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %236 = "vector.insert"(%235, %233) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %237 = "vector.extract"(%219) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %238 = "func.call"(%216, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %239 = "vector.insert"(%238, %236) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %240 = "vector.extract"(%219) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %241 = "func.call"(%216, %240) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %242 = "vector.insert"(%241, %239) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %243 = "vector.extract"(%219) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %244 = "func.call"(%216, %243) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %245 = "vector.insert"(%244, %242) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %246 = "arith.addf"(%221, %245) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %247 = "arith.subi"(%210, %188) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%246, %189, %arg121, %247) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %206 = "air.wait_all"(%arg120) : (!air.async.token) -> !air.async.token
              "scf.yield"(%206) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %194 = "air.dma_memcpy_nd"(%193, %arg115, %188, %189) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 5879 : i64, orbit.retained_begin = 5848 : i64, orbit.retained_end = 5880 : i64, orbit.source_copies = array<i64: 33496>, orbit.storage = "U", orbit.target_copies = array<i64: 33497>, orbit.transfer = "l1_to_host", orbit.transfer_event = 16953 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<5x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %195 = "air.wait_all"(%194) : (!air.async.token) -> !air.async.token
            "scf.yield"(%195) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%185) : (!air.async.token) -> ()
          "memref.dealloc"(%181) : (memref<320xf32, 2 : i32>) -> ()
          "memref.dealloc"(%182) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%183) : (memref<320xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_5848"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_5848"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_5848"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg49: index, %arg50: index, %arg51: index, %arg52: index, %arg53: memref<5x2048xf32>, %arg54: memref<2048x11008xf32>, %arg55: memref<2048x11008xf32>, %arg56: memref<11008x2048xf32>, %arg57: memref<5x2048xf32>, %arg58: memref<5x11008xf32>, %arg59: memref<5x11008xf32>, %arg60: memref<5x11008xf32>):
      "air.segment"(%arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60) ({
      ^bb0(%arg61: memref<5x2048xf32>, %arg62: memref<2048x11008xf32>, %arg63: memref<2048x11008xf32>, %arg64: memref<11008x2048xf32>, %arg65: memref<5x2048xf32>, %arg66: memref<5x11008xf32>, %arg67: memref<5x11008xf32>, %arg68: memref<5x11008xf32>):
        %81 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%81, %81, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68) ({
        ^bb0(%arg69: index, %arg70: index, %arg71: index, %arg72: index, %arg73: memref<5x2048xf32>, %arg74: memref<2048x11008xf32>, %arg75: memref<2048x11008xf32>, %arg76: memref<11008x2048xf32>, %arg77: memref<5x2048xf32>, %arg78: memref<5x11008xf32>, %arg79: memref<5x11008xf32>, %arg80: memref<5x11008xf32>):
          %82 = "arith.constant"() <{value = 127 : i32}> : () -> i32
          %83 = "arith.constant"() <{value = 23 : i32}> : () -> i32
          %84 = "arith.constant"() <{value = 1.270000e+02 : f32}> : () -> f32
          %85 = "arith.constant"() <{value = -1.270000e+02 : f32}> : () -> f32
          %86 = "arith.constant"() <{value = 8.880000e+01 : f32}> : () -> f32
          %87 = "arith.constant"() <{value = -8.780000e+01 : f32}> : () -> f32
          %88 = "arith.constant"() <{value = 0.166666657 : f32}> : () -> f32
          %89 = "arith.constant"() <{value = 0.0416657962 : f32}> : () -> f32
          %90 = "arith.constant"() <{value = 0.00833345205 : f32}> : () -> f32
          %91 = "arith.constant"() <{value = 0.00139819994 : f32}> : () -> f32
          %92 = "arith.constant"() <{value = 1.98756912E-4 : f32}> : () -> f32
          %93 = "arith.constant"() <{value = 2.12194442E-4 : f32}> : () -> f32
          %94 = "arith.constant"() <{value = -0.693359375 : f32}> : () -> f32
          %95 = "arith.constant"() <{value = 1.44269502 : f32}> : () -> f32
          %96 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %97 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
          %98 = "arith.constant"() <{value = 64 : index}> : () -> index
          %99 = "arith.constant"() <{value = 1 : index}> : () -> index
          %100 = "arith.constant"() <{value = 172 : index}> : () -> index
          %101 = "arith.constant"() <{value = 0 : index}> : () -> index
          %102 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data.input.5.64.loops.5.64"} : () -> memref<320xf32, 2 : i32>
          %103 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data.input.5.64.loops.5.64"} : () -> memref<320xf32, 2 : i32>
          %104 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data"} : () -> memref<320xf32, 2 : i32>
          %105 = "air.wait_all"() : () -> !air.async.token
          %106 = "scf.for"(%101, %100, %99, %105) ({
          ^bb0(%arg81: index, %arg82: !air.async.token):
            %107 = "arith.muli"(%arg81, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %108 = "arith.muli"(%arg81, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %109 = "arith.muli"(%arg81, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %110 = "arith.muli"(%arg81, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %111 = "memref.reinterpret_cast"(%102) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11352 : i64, orbit.storage = "G"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %112 = "air.dma_memcpy_nd"(%arg82, %111, %arg78, %108) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 11352 : i64, orbit.source_copies = array<i64: 16641>, orbit.storage = "G", orbit.target_copies = array<i64: 50256>, orbit.transfer = "host_to_l1", orbit.transfer_event = 33712 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
            %113 = "memref.reinterpret_cast"(%103) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11352 : i64, orbit.storage = "U"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %114 = "air.dma_memcpy_nd"(%arg82, %113, %arg79, %109) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 11352 : i64, orbit.source_copies = array<i64: 33497>, orbit.storage = "U", orbit.target_copies = array<i64: 50257>, orbit.transfer = "host_to_l1", orbit.transfer_event = 33713 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
            %115 = "memref.reinterpret_cast"(%104) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11352 : i64, orbit.storage = "H"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            "air.wait_all"(%112, %114) {orbit.computation_event = 33714 : i64, orbit.phase = 11352 : i64, orbit.phase_dependencies = array<i64: 11351>, orbit.read_copies = array<i64: 50256, 50257>, orbit.task = "swiglu", orbit.write_copies = array<i64: 50258>} : (!air.async.token, !air.async.token) -> ()
            %116 = "arith.constant"() <{value = 0 : index}> : () -> index
            %117 = "arith.constant"() <{value = 5 : index}> : () -> index
            %118 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%116, %117, %118) ({
            ^bb0(%arg83: index):
              %121 = "arith.constant"() <{value = 0 : index}> : () -> index
              %122 = "arith.constant"() <{value = 64 : index}> : () -> index
              %123 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%121, %122, %123) ({
              ^bb0(%arg84: index):
                %124 = "arith.addi"(%arg84, %107) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %125 = "arith.subi"(%124, %108) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %126 = "memref.load"(%111, %arg83, %125) <{nontemporal = false}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                %127 = "arith.subi"(%124, %109) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %128 = "memref.load"(%113, %arg83, %127) <{nontemporal = false}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                %129 = "arith.negf"(%126) <{fastmath = #arith.fastmath<none>}> : (f32) -> f32
                %130 = "arith.cmpf"(%129, %87) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %131 = "arith.select"(%130, %129, %87) : (i1, f32, f32) -> f32
                %132 = "arith.cmpf"(%131, %86) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %133 = "arith.select"(%132, %131, %86) : (i1, f32, f32) -> f32
                %134 = "arith.mulf"(%133, %95) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %135 = "arith.addf"(%134, %96) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %136 = "arith.fptosi"(%135) : (f32) -> i32
                %137 = "arith.sitofp"(%136) : (i32) -> f32
                %138 = "arith.cmpf"(%135, %137) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f32, f32) -> i1
                %139 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
                %140 = "arith.subf"(%137, %139) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %141 = "arith.select"(%138, %140, %137) : (i1, f32, f32) -> f32
                %142 = "arith.cmpf"(%141, %85) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %143 = "arith.select"(%142, %141, %85) : (i1, f32, f32) -> f32
                %144 = "arith.cmpf"(%143, %84) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %145 = "arith.select"(%144, %143, %84) : (i1, f32, f32) -> f32
                %146 = "arith.mulf"(%145, %94) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %147 = "arith.addf"(%146, %133) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %148 = "arith.mulf"(%145, %93) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %149 = "arith.addf"(%148, %147) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %150 = "arith.mulf"(%149, %92) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %151 = "arith.addf"(%150, %91) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %152 = "arith.mulf"(%151, %149) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %153 = "arith.addf"(%152, %90) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %154 = "arith.mulf"(%153, %149) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %155 = "arith.addf"(%154, %89) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %156 = "arith.mulf"(%155, %149) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %157 = "arith.addf"(%156, %88) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %158 = "arith.mulf"(%157, %149) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %159 = "arith.addf"(%158, %96) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %160 = "arith.mulf"(%149, %149) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %161 = "arith.mulf"(%159, %160) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %162 = "arith.addf"(%161, %149) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %163 = "arith.addf"(%162, %97) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %164 = "arith.fptosi"(%145) : (f32) -> i32
                %165 = "arith.addi"(%164, %82) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %166 = "arith.shli"(%165, %83) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %167 = "arith.bitcast"(%166) : (i32) -> f32
                %168 = "arith.mulf"(%163, %167) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %169 = "arith.addf"(%168, %97) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %170 = "arith.divf"(%126, %169) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %171 = "arith.mulf"(%170, %128) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %172 = "arith.subi"(%124, %110) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%171, %115, %arg83, %172) <{nontemporal = false}> : (f32, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %119 = "air.dma_memcpy_nd"(%arg82, %arg80, %110, %115) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11352 : i64, orbit.source_copies = array<i64: 50258>, orbit.storage = "H", orbit.target_copies = array<i64: 50259>, orbit.transfer = "l1_to_host", orbit.transfer_event = 33715 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<5x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %120 = "air.wait_all"(%119) : (!air.async.token) -> !air.async.token
            "scf.yield"(%120) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%106) : (!air.async.token) -> ()
          "memref.dealloc"(%102) : (memref<320xf32, 2 : i32>) -> ()
          "memref.dealloc"(%103) : (memref<320xf32, 2 : i32>) -> ()
          "memref.dealloc"(%104) : (memref<320xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_11352"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_11352"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_11352"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg8: index, %arg9: index, %arg10: index, %arg11: index, %arg12: memref<5x2048xf32>, %arg13: memref<2048x11008xf32>, %arg14: memref<2048x11008xf32>, %arg15: memref<11008x2048xf32>, %arg16: memref<5x2048xf32>, %arg17: memref<5x11008xf32>, %arg18: memref<5x11008xf32>, %arg19: memref<5x11008xf32>):
      "air.segment"(%arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19) ({
      ^bb0(%arg20: memref<5x2048xf32>, %arg21: memref<2048x11008xf32>, %arg22: memref<2048x11008xf32>, %arg23: memref<11008x2048xf32>, %arg24: memref<5x2048xf32>, %arg25: memref<5x11008xf32>, %arg26: memref<5x11008xf32>, %arg27: memref<5x11008xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27) ({
        ^bb0(%arg28: index, %arg29: index, %arg30: index, %arg31: index, %arg32: memref<5x2048xf32>, %arg33: memref<2048x11008xf32>, %arg34: memref<2048x11008xf32>, %arg35: memref<11008x2048xf32>, %arg36: memref<5x2048xf32>, %arg37: memref<5x11008xf32>, %arg38: memref<5x11008xf32>, %arg39: memref<5x11008xf32>):
          %2 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %3 = "arith.constant"() <{value = 172 : index}> : () -> index
          %4 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %5 = "arith.constant"() <{value = 64 : index}> : () -> index
          %6 = "arith.constant"() <{value = 1 : index}> : () -> index
          %7 = "arith.constant"() <{value = 32 : index}> : () -> index
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.64.64.loops.5.64.64"} : () -> memref<4096xf32, 2 : i32>
          %10 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<320xf32, 2 : i32>
          %11 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data.input.5.64.loops.5.64.64"} : () -> memref<320xf32, 2 : i32>
          %12 = "air.wait_all"() : () -> !air.async.token
          %13 = "scf.for"(%8, %7, %6, %12) ({
          ^bb0(%arg40: index, %arg41: !air.async.token):
            %14 = "arith.muli"(%arg40, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.muli"(%arg40, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %16 = "arith.muli"(%arg40, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %17 = "memref.reinterpret_cast"(%10) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "down.initialize", orbit.phase = 11556 : i64, orbit.storage = "Y"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %18 = "arith.constant"() <{value = 0 : index}> : () -> index
            %19 = "arith.constant"() <{value = 5 : index}> : () -> index
            %20 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%18, %19, %20) ({
            ^bb0(%arg47: index):
              %76 = "arith.constant"() <{value = 0 : index}> : () -> index
              %77 = "arith.constant"() <{value = 64 : index}> : () -> index
              %78 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%76, %77, %78) ({
              ^bb0(%arg48: index):
                %79 = "arith.addi"(%arg48, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %80 = "arith.subi"(%79, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%4, %17, %arg47, %80) <{nontemporal = false}> : (f32, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %21 = "scf.for"(%8, %3, %6, %arg41) ({
            ^bb0(%arg42: index, %arg43: !air.async.token):
              %24 = "arith.muli"(%arg42, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "arith.muli"(%arg42, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "arith.muli"(%arg42, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %27 = "memref.reinterpret_cast"(%9) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11556 : i64, orbit.storage = "W_down"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %28 = "air.dma_memcpy_nd"(%arg43, %27, %arg35, %25, %15) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 11556 : i64, orbit.source_copies = array<i64: 11040>, orbit.storage = "W_down", orbit.target_copies = array<i64: 50944>, orbit.transfer = "host_to_l1", orbit.transfer_event = 34400 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<11008x2048xf32>, index, index) -> !air.async.token
              %29 = "memref.reinterpret_cast"(%11) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 5, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11556 : i64, orbit.storage = "H"} : (memref<320xf32, 2 : i32>) -> memref<5x64xf32, strided<[64, 1]>, 2 : i32>
              %30 = "air.dma_memcpy_nd"(%arg43, %29, %arg39, %26) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 11556 : i64, orbit.source_copies = array<i64: 50259>, orbit.storage = "H", orbit.target_copies = array<i64: 50945>, orbit.transfer = "host_to_l1", orbit.transfer_event = 34401 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
              "air.wait_all"(%28, %30) {orbit.computation_event = 34403 : i64, orbit.phase = 11556 : i64, orbit.phase_dependencies = array<i64: 11555>, orbit.read_copies = array<i64: 50944, 50946, 50945>, orbit.task = "down", orbit.write_copies = array<i64: 50947>} : (!air.async.token, !air.async.token) -> ()
              %31 = "arith.constant"() <{value = 0 : index}> : () -> index
              %32 = "arith.constant"() <{value = 5 : index}> : () -> index
              %33 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%31, %32, %33) ({
              ^bb0(%arg44: index):
                %35 = "arith.constant"() <{value = 0 : index}> : () -> index
                %36 = "arith.constant"() <{value = 64 : index}> : () -> index
                %37 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%35, %36, %37) ({
                ^bb0(%arg45: index):
                  %38 = "arith.addi"(%arg45, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %39 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %40 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %41 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%39, %40, %41) ({
                  ^bb0(%arg46: index):
                    %42 = "arith.addi"(%arg46, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %43 = "arith.subi"(%42, %26) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %44 = "memref.load"(%29, %arg44, %43) <{nontemporal = false}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %45 = "arith.subi"(%42, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %46 = "arith.subi"(%38, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %47 = "vector.transfer_read"(%27, %45, %46, %4) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %48 = "arith.subi"(%38, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %49 = "vector.transfer_read"(%17, %arg44, %48, %4) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %50 = "vector.extract"(%47) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %51 = "func.call"(%44, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %52 = "vector.insert"(%51, %2) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %53 = "vector.extract"(%47) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %54 = "func.call"(%44, %53) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %55 = "vector.insert"(%54, %52) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %56 = "vector.extract"(%47) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %57 = "func.call"(%44, %56) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %58 = "vector.insert"(%57, %55) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %59 = "vector.extract"(%47) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %60 = "func.call"(%44, %59) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %61 = "vector.insert"(%60, %58) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %62 = "vector.extract"(%47) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %63 = "func.call"(%44, %62) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %64 = "vector.insert"(%63, %61) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %65 = "vector.extract"(%47) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %66 = "func.call"(%44, %65) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %67 = "vector.insert"(%66, %64) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %68 = "vector.extract"(%47) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %69 = "func.call"(%44, %68) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %70 = "vector.insert"(%69, %67) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %71 = "vector.extract"(%47) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %72 = "func.call"(%44, %71) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %73 = "vector.insert"(%72, %70) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %74 = "arith.addf"(%49, %73) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %75 = "arith.subi"(%38, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%74, %17, %arg44, %75) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<5x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %34 = "air.wait_all"(%arg43) : (!air.async.token) -> !air.async.token
              "scf.yield"(%34) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %22 = "air.dma_memcpy_nd"(%21, %arg36, %16, %17) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11727 : i64, orbit.retained_begin = 11556 : i64, orbit.retained_end = 11728 : i64, orbit.source_copies = array<i64: 51460>, orbit.storage = "Y", orbit.target_copies = array<i64: 51461>, orbit.transfer = "l1_to_host", orbit.transfer_event = 34917 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 5, 64>, static_dst_strides = array<i64: 2048, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 5, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<5x2048xf32>, index, memref<5x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %23 = "air.wait_all"(%22) : (!air.async.token) -> !air.async.token
            "scf.yield"(%23) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%13) : (!air.async.token) -> ()
          "memref.dealloc"(%9) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%10) : (memref<320xf32, 2 : i32>) -> ()
          "memref.dealloc"(%11) : (memref<320xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_11556"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_11556"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_11556"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "0023fa0fc660e0d000f371d2b6eff9f3927f0b05e2bc74138127e7ae487d5ade", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "8c0c18e9f7ab0e83c0d958c735fe9d4b466e5b15e5cdf11aa852370d1e3f1414"} : () -> ()

