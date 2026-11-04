"builtin.module"() ({
  "func.func"() <{function_type = (memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> (), sym_name = "ffn"}> ({
  ^bb0(%arg0: memref<8x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<8x2048xf32>, %arg5: memref<8x11008xf32>, %arg6: memref<8x11008xf32>, %arg7: memref<8x11008xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg126: index, %arg127: index, %arg128: index, %arg129: index, %arg130: memref<8x2048xf32>, %arg131: memref<2048x11008xf32>, %arg132: memref<2048x11008xf32>, %arg133: memref<11008x2048xf32>, %arg134: memref<8x2048xf32>, %arg135: memref<8x11008xf32>, %arg136: memref<8x11008xf32>, %arg137: memref<8x11008xf32>):
      "air.segment"(%arg130, %arg131, %arg132, %arg133, %arg134, %arg135, %arg136, %arg137) ({
      ^bb0(%arg138: memref<8x2048xf32>, %arg139: memref<2048x11008xf32>, %arg140: memref<2048x11008xf32>, %arg141: memref<11008x2048xf32>, %arg142: memref<8x2048xf32>, %arg143: memref<8x11008xf32>, %arg144: memref<8x11008xf32>, %arg145: memref<8x11008xf32>):
        %205 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%205, %205, %arg138, %arg139, %arg140, %arg141, %arg142, %arg143, %arg144, %arg145) ({
        ^bb0(%arg146: index, %arg147: index, %arg148: index, %arg149: index, %arg150: memref<8x2048xf32>, %arg151: memref<2048x11008xf32>, %arg152: memref<2048x11008xf32>, %arg153: memref<11008x2048xf32>, %arg154: memref<8x2048xf32>, %arg155: memref<8x11008xf32>, %arg156: memref<8x11008xf32>, %arg157: memref<8x11008xf32>):
          %206 = "arith.constant"() <{value = 32 : index}> : () -> index
          %207 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %208 = "arith.constant"() <{value = 64 : index}> : () -> index
          %209 = "arith.constant"() <{value = 1 : index}> : () -> index
          %210 = "arith.constant"() <{value = 172 : index}> : () -> index
          %211 = "arith.constant"() <{value = 0 : index}> : () -> index
          %212 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.64.loops.8.64.64"} : () -> memref<512xf32, 2 : i32>
          %213 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.64.loops.8.64.64"} : () -> memref<4096xf32, 2 : i32>
          %214 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : () -> memref<512xf32, 2 : i32>
          %215 = "air.wait_all"() : () -> !air.async.token
          %216 = "scf.for"(%211, %210, %209, %215) ({
          ^bb0(%arg158: index, %arg159: !air.async.token):
            %217 = "arith.muli"(%arg158, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %218 = "arith.muli"(%arg158, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %219 = "arith.muli"(%arg158, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %220 = "memref.reinterpret_cast"(%214) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "gate.initialize", orbit.phase = 172 : i64, orbit.storage = "G"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %221 = "arith.constant"() <{value = 0 : index}> : () -> index
            %222 = "arith.constant"() <{value = 8 : index}> : () -> index
            %223 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%221, %222, %223) ({
            ^bb0(%arg165: index):
              %256 = "arith.constant"() <{value = 0 : index}> : () -> index
              %257 = "arith.constant"() <{value = 64 : index}> : () -> index
              %258 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%256, %257, %258) ({
              ^bb0(%arg166: index):
                %259 = "arith.addi"(%arg166, %217) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %260 = "arith.subi"(%259, %219) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%207, %220, %arg165, %260) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %224 = "scf.for"(%211, %206, %209, %arg159) ({
            ^bb0(%arg160: index, %arg161: !air.async.token):
              %227 = "arith.muli"(%arg160, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %228 = "arith.muli"(%arg160, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %229 = "arith.muli"(%arg160, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %230 = "memref.reinterpret_cast"(%212) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
              %231 = "air.dma_memcpy_nd"(%arg161, %230, %arg150, %228) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 16544>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x2048xf32>, index) -> !air.async.token
              %232 = "memref.reinterpret_cast"(%213) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "W_gate"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %233 = "air.dma_memcpy_nd"(%arg161, %232, %arg151, %229, %218) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 32>, orbit.storage = "W_gate", orbit.target_copies = array<i64: 16545>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%231, %233) {orbit.computation_event = 3 : i64, orbit.phase = 172 : i64, orbit.phase_dependencies = array<i64: 171>, orbit.read_copies = array<i64: 16544, 16545, 16546>, orbit.task = "gate", orbit.write_copies = array<i64: 16547>} : (!air.async.token, !air.async.token) -> ()
              %234 = "arith.constant"() <{value = 0 : index}> : () -> index
              %235 = "arith.constant"() <{value = 8 : index}> : () -> index
              %236 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%234, %235, %236) ({
              ^bb0(%arg162: index):
                %238 = "arith.constant"() <{value = 0 : index}> : () -> index
                %239 = "arith.constant"() <{value = 64 : index}> : () -> index
                %240 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%238, %239, %240) ({
                ^bb0(%arg163: index):
                  %241 = "arith.addi"(%arg163, %217) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %242 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %243 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %244 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%242, %243, %244) ({
                  ^bb0(%arg164: index):
                    %245 = "arith.addi"(%arg164, %227) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %246 = "arith.subi"(%245, %228) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %247 = "memref.load"(%230, %arg162, %246) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %248 = "arith.subi"(%245, %229) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %249 = "arith.subi"(%241, %218) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %250 = "memref.load"(%232, %248, %249) <{nontemporal = false}> : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %251 = "arith.subi"(%241, %219) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %252 = "memref.load"(%220, %arg162, %251) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %253 = "arith.mulf"(%247, %250) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %254 = "arith.addf"(%252, %253) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %255 = "arith.subi"(%241, %219) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%254, %220, %arg162, %255) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %237 = "air.wait_all"(%arg161) : (!air.async.token) -> !air.async.token
              "scf.yield"(%237) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %225 = "air.dma_memcpy_nd"(%224, %arg155, %219, %220) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 203 : i64, orbit.retained_begin = 172 : i64, orbit.retained_end = 204 : i64, orbit.source_copies = array<i64: 16640>, orbit.storage = "G", orbit.target_copies = array<i64: 16641>, orbit.transfer = "l1_to_host", orbit.transfer_event = 97 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x11008xf32>, index, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %226 = "air.wait_all"(%225) : (!air.async.token) -> !air.async.token
            "scf.yield"(%226) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%216) : (!air.async.token) -> ()
          "memref.dealloc"(%212) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%213) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%214) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment"} : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg85: index, %arg86: index, %arg87: index, %arg88: index, %arg89: memref<8x2048xf32>, %arg90: memref<2048x11008xf32>, %arg91: memref<2048x11008xf32>, %arg92: memref<11008x2048xf32>, %arg93: memref<8x2048xf32>, %arg94: memref<8x11008xf32>, %arg95: memref<8x11008xf32>, %arg96: memref<8x11008xf32>):
      "air.segment"(%arg89, %arg90, %arg91, %arg92, %arg93, %arg94, %arg95, %arg96) ({
      ^bb0(%arg97: memref<8x2048xf32>, %arg98: memref<2048x11008xf32>, %arg99: memref<2048x11008xf32>, %arg100: memref<11008x2048xf32>, %arg101: memref<8x2048xf32>, %arg102: memref<8x11008xf32>, %arg103: memref<8x11008xf32>, %arg104: memref<8x11008xf32>):
        %149 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%149, %149, %arg97, %arg98, %arg99, %arg100, %arg101, %arg102, %arg103, %arg104) ({
        ^bb0(%arg105: index, %arg106: index, %arg107: index, %arg108: index, %arg109: memref<8x2048xf32>, %arg110: memref<2048x11008xf32>, %arg111: memref<2048x11008xf32>, %arg112: memref<11008x2048xf32>, %arg113: memref<8x2048xf32>, %arg114: memref<8x11008xf32>, %arg115: memref<8x11008xf32>, %arg116: memref<8x11008xf32>):
          %150 = "arith.constant"() <{value = 32 : index}> : () -> index
          %151 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %152 = "arith.constant"() <{value = 64 : index}> : () -> index
          %153 = "arith.constant"() <{value = 1 : index}> : () -> index
          %154 = "arith.constant"() <{value = 172 : index}> : () -> index
          %155 = "arith.constant"() <{value = 0 : index}> : () -> index
          %156 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.64.loops.8.64.64"} : () -> memref<512xf32, 2 : i32>
          %157 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.64.64.loops.8.64.64"} : () -> memref<4096xf32, 2 : i32>
          %158 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data"} : () -> memref<512xf32, 2 : i32>
          %159 = "air.wait_all"() : () -> !air.async.token
          %160 = "scf.for"(%155, %154, %153, %159) ({
          ^bb0(%arg117: index, %arg118: !air.async.token):
            %161 = "arith.muli"(%arg117, %152) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %162 = "arith.muli"(%arg117, %152) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %163 = "arith.muli"(%arg117, %152) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %164 = "memref.reinterpret_cast"(%158) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "up.initialize", orbit.phase = 5848 : i64, orbit.storage = "U"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %165 = "arith.constant"() <{value = 0 : index}> : () -> index
            %166 = "arith.constant"() <{value = 8 : index}> : () -> index
            %167 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%165, %166, %167) ({
            ^bb0(%arg124: index):
              %200 = "arith.constant"() <{value = 0 : index}> : () -> index
              %201 = "arith.constant"() <{value = 64 : index}> : () -> index
              %202 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%200, %201, %202) ({
              ^bb0(%arg125: index):
                %203 = "arith.addi"(%arg125, %161) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %204 = "arith.subi"(%203, %163) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%151, %164, %arg124, %204) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %168 = "scf.for"(%155, %150, %153, %arg118) ({
            ^bb0(%arg119: index, %arg120: !air.async.token):
              %171 = "arith.muli"(%arg119, %152) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %172 = "arith.muli"(%arg119, %152) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %173 = "arith.muli"(%arg119, %152) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %174 = "memref.reinterpret_cast"(%156) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 5848 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
              %175 = "air.dma_memcpy_nd"(%arg120, %174, %arg109, %172) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 5848 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 33400>, orbit.transfer = "host_to_l1", orbit.transfer_event = 16856 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x2048xf32>, index) -> !air.async.token
              %176 = "memref.reinterpret_cast"(%157) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 5848 : i64, orbit.storage = "W_up"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %177 = "air.dma_memcpy_nd"(%arg120, %176, %arg111, %173, %162) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 5848 : i64, orbit.source_copies = array<i64: 5536>, orbit.storage = "W_up", orbit.target_copies = array<i64: 33401>, orbit.transfer = "host_to_l1", orbit.transfer_event = 16857 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%175, %177) {orbit.computation_event = 16859 : i64, orbit.phase = 5848 : i64, orbit.phase_dependencies = array<i64: 5847>, orbit.read_copies = array<i64: 33400, 33401, 33402>, orbit.task = "up", orbit.write_copies = array<i64: 33403>} : (!air.async.token, !air.async.token) -> ()
              %178 = "arith.constant"() <{value = 0 : index}> : () -> index
              %179 = "arith.constant"() <{value = 8 : index}> : () -> index
              %180 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%178, %179, %180) ({
              ^bb0(%arg121: index):
                %182 = "arith.constant"() <{value = 0 : index}> : () -> index
                %183 = "arith.constant"() <{value = 64 : index}> : () -> index
                %184 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%182, %183, %184) ({
                ^bb0(%arg122: index):
                  %185 = "arith.addi"(%arg122, %161) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %186 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %187 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %188 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%186, %187, %188) ({
                  ^bb0(%arg123: index):
                    %189 = "arith.addi"(%arg123, %171) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %190 = "arith.subi"(%189, %172) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %191 = "memref.load"(%174, %arg121, %190) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %192 = "arith.subi"(%189, %173) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %193 = "arith.subi"(%185, %162) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %194 = "memref.load"(%176, %192, %193) <{nontemporal = false}> : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %195 = "arith.subi"(%185, %163) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %196 = "memref.load"(%164, %arg121, %195) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %197 = "arith.mulf"(%191, %194) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %198 = "arith.addf"(%196, %197) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %199 = "arith.subi"(%185, %163) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%198, %164, %arg121, %199) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %181 = "air.wait_all"(%arg120) : (!air.async.token) -> !air.async.token
              "scf.yield"(%181) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %169 = "air.dma_memcpy_nd"(%168, %arg115, %163, %164) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 5879 : i64, orbit.retained_begin = 5848 : i64, orbit.retained_end = 5880 : i64, orbit.source_copies = array<i64: 33496>, orbit.storage = "U", orbit.target_copies = array<i64: 33497>, orbit.transfer = "l1_to_host", orbit.transfer_event = 16953 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x11008xf32>, index, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %170 = "air.wait_all"(%169) : (!air.async.token) -> !air.async.token
            "scf.yield"(%170) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%160) : (!air.async.token) -> ()
          "memref.dealloc"(%156) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%157) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%158) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_5848"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_5848"} : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_5848"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg49: index, %arg50: index, %arg51: index, %arg52: index, %arg53: memref<8x2048xf32>, %arg54: memref<2048x11008xf32>, %arg55: memref<2048x11008xf32>, %arg56: memref<11008x2048xf32>, %arg57: memref<8x2048xf32>, %arg58: memref<8x11008xf32>, %arg59: memref<8x11008xf32>, %arg60: memref<8x11008xf32>):
      "air.segment"(%arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60) ({
      ^bb0(%arg61: memref<8x2048xf32>, %arg62: memref<2048x11008xf32>, %arg63: memref<2048x11008xf32>, %arg64: memref<11008x2048xf32>, %arg65: memref<8x2048xf32>, %arg66: memref<8x11008xf32>, %arg67: memref<8x11008xf32>, %arg68: memref<8x11008xf32>):
        %57 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%57, %57, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68) ({
        ^bb0(%arg69: index, %arg70: index, %arg71: index, %arg72: index, %arg73: memref<8x2048xf32>, %arg74: memref<2048x11008xf32>, %arg75: memref<2048x11008xf32>, %arg76: memref<11008x2048xf32>, %arg77: memref<8x2048xf32>, %arg78: memref<8x11008xf32>, %arg79: memref<8x11008xf32>, %arg80: memref<8x11008xf32>):
          %58 = "arith.constant"() <{value = 127 : i32}> : () -> i32
          %59 = "arith.constant"() <{value = 23 : i32}> : () -> i32
          %60 = "arith.constant"() <{value = 1.270000e+02 : f32}> : () -> f32
          %61 = "arith.constant"() <{value = -1.270000e+02 : f32}> : () -> f32
          %62 = "arith.constant"() <{value = 8.880000e+01 : f32}> : () -> f32
          %63 = "arith.constant"() <{value = -8.780000e+01 : f32}> : () -> f32
          %64 = "arith.constant"() <{value = 0.166666657 : f32}> : () -> f32
          %65 = "arith.constant"() <{value = 0.0416657962 : f32}> : () -> f32
          %66 = "arith.constant"() <{value = 0.00833345205 : f32}> : () -> f32
          %67 = "arith.constant"() <{value = 0.00139819994 : f32}> : () -> f32
          %68 = "arith.constant"() <{value = 1.98756912E-4 : f32}> : () -> f32
          %69 = "arith.constant"() <{value = 2.12194442E-4 : f32}> : () -> f32
          %70 = "arith.constant"() <{value = -0.693359375 : f32}> : () -> f32
          %71 = "arith.constant"() <{value = 1.44269502 : f32}> : () -> f32
          %72 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %73 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
          %74 = "arith.constant"() <{value = 64 : index}> : () -> index
          %75 = "arith.constant"() <{value = 1 : index}> : () -> index
          %76 = "arith.constant"() <{value = 172 : index}> : () -> index
          %77 = "arith.constant"() <{value = 0 : index}> : () -> index
          %78 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data.input.8.64.loops.8.64"} : () -> memref<512xf32, 2 : i32>
          %79 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data.input.8.64.loops.8.64"} : () -> memref<512xf32, 2 : i32>
          %80 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data"} : () -> memref<512xf32, 2 : i32>
          %81 = "air.wait_all"() : () -> !air.async.token
          %82 = "scf.for"(%77, %76, %75, %81) ({
          ^bb0(%arg81: index, %arg82: !air.async.token):
            %83 = "arith.muli"(%arg81, %74) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %84 = "arith.muli"(%arg81, %74) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %85 = "arith.muli"(%arg81, %74) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %86 = "arith.muli"(%arg81, %74) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %87 = "memref.reinterpret_cast"(%78) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11352 : i64, orbit.storage = "G"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %88 = "air.dma_memcpy_nd"(%arg82, %87, %arg78, %84) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 11352 : i64, orbit.source_copies = array<i64: 16641>, orbit.storage = "G", orbit.target_copies = array<i64: 50256>, orbit.transfer = "host_to_l1", orbit.transfer_event = 33712 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x11008xf32>, index) -> !air.async.token
            %89 = "memref.reinterpret_cast"(%79) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11352 : i64, orbit.storage = "U"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %90 = "air.dma_memcpy_nd"(%arg82, %89, %arg79, %85) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 11352 : i64, orbit.source_copies = array<i64: 33497>, orbit.storage = "U", orbit.target_copies = array<i64: 50257>, orbit.transfer = "host_to_l1", orbit.transfer_event = 33713 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x11008xf32>, index) -> !air.async.token
            %91 = "memref.reinterpret_cast"(%80) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11352 : i64, orbit.storage = "H"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            "air.wait_all"(%88, %90) {orbit.computation_event = 33714 : i64, orbit.phase = 11352 : i64, orbit.phase_dependencies = array<i64: 11351>, orbit.read_copies = array<i64: 50256, 50257>, orbit.task = "swiglu", orbit.write_copies = array<i64: 50258>} : (!air.async.token, !air.async.token) -> ()
            %92 = "arith.constant"() <{value = 0 : index}> : () -> index
            %93 = "arith.constant"() <{value = 8 : index}> : () -> index
            %94 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%92, %93, %94) ({
            ^bb0(%arg83: index):
              %97 = "arith.constant"() <{value = 0 : index}> : () -> index
              %98 = "arith.constant"() <{value = 64 : index}> : () -> index
              %99 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%97, %98, %99) ({
              ^bb0(%arg84: index):
                %100 = "arith.addi"(%arg84, %83) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %101 = "arith.subi"(%100, %84) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %102 = "memref.load"(%87, %arg83, %101) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                %103 = "arith.subi"(%100, %85) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %104 = "memref.load"(%89, %arg83, %103) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                %105 = "arith.negf"(%102) <{fastmath = #arith.fastmath<none>}> : (f32) -> f32
                %106 = "arith.cmpf"(%105, %63) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %107 = "arith.select"(%106, %105, %63) : (i1, f32, f32) -> f32
                %108 = "arith.cmpf"(%107, %62) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %109 = "arith.select"(%108, %107, %62) : (i1, f32, f32) -> f32
                %110 = "arith.mulf"(%109, %71) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %111 = "arith.addf"(%110, %72) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %112 = "arith.fptosi"(%111) : (f32) -> i32
                %113 = "arith.sitofp"(%112) : (i32) -> f32
                %114 = "arith.cmpf"(%111, %113) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f32, f32) -> i1
                %115 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
                %116 = "arith.subf"(%113, %115) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %117 = "arith.select"(%114, %116, %113) : (i1, f32, f32) -> f32
                %118 = "arith.cmpf"(%117, %61) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %119 = "arith.select"(%118, %117, %61) : (i1, f32, f32) -> f32
                %120 = "arith.cmpf"(%119, %60) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %121 = "arith.select"(%120, %119, %60) : (i1, f32, f32) -> f32
                %122 = "arith.mulf"(%121, %70) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %123 = "arith.addf"(%122, %109) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %124 = "arith.mulf"(%121, %69) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %125 = "arith.addf"(%124, %123) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %126 = "arith.mulf"(%125, %68) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %127 = "arith.addf"(%126, %67) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %128 = "arith.mulf"(%127, %125) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %129 = "arith.addf"(%128, %66) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %130 = "arith.mulf"(%129, %125) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %131 = "arith.addf"(%130, %65) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %132 = "arith.mulf"(%131, %125) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %133 = "arith.addf"(%132, %64) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %134 = "arith.mulf"(%133, %125) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %135 = "arith.addf"(%134, %72) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %136 = "arith.mulf"(%125, %125) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %137 = "arith.mulf"(%135, %136) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %138 = "arith.addf"(%137, %125) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %139 = "arith.addf"(%138, %73) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %140 = "arith.fptosi"(%121) : (f32) -> i32
                %141 = "arith.addi"(%140, %58) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %142 = "arith.shli"(%141, %59) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %143 = "arith.bitcast"(%142) : (i32) -> f32
                %144 = "arith.mulf"(%139, %143) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %145 = "arith.addf"(%144, %73) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %146 = "arith.divf"(%102, %145) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %147 = "arith.mulf"(%146, %104) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %148 = "arith.subi"(%100, %86) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%147, %91, %arg83, %148) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %95 = "air.dma_memcpy_nd"(%arg82, %arg80, %86, %91) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11352 : i64, orbit.source_copies = array<i64: 50258>, orbit.storage = "H", orbit.target_copies = array<i64: 50259>, orbit.transfer = "l1_to_host", orbit.transfer_event = 33715 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x11008xf32>, index, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %96 = "air.wait_all"(%95) : (!air.async.token) -> !air.async.token
            "scf.yield"(%96) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%82) : (!air.async.token) -> ()
          "memref.dealloc"(%78) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%79) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%80) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_11352"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_11352"} : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_11352"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg8: index, %arg9: index, %arg10: index, %arg11: index, %arg12: memref<8x2048xf32>, %arg13: memref<2048x11008xf32>, %arg14: memref<2048x11008xf32>, %arg15: memref<11008x2048xf32>, %arg16: memref<8x2048xf32>, %arg17: memref<8x11008xf32>, %arg18: memref<8x11008xf32>, %arg19: memref<8x11008xf32>):
      "air.segment"(%arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19) ({
      ^bb0(%arg20: memref<8x2048xf32>, %arg21: memref<2048x11008xf32>, %arg22: memref<2048x11008xf32>, %arg23: memref<11008x2048xf32>, %arg24: memref<8x2048xf32>, %arg25: memref<8x11008xf32>, %arg26: memref<8x11008xf32>, %arg27: memref<8x11008xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27) ({
        ^bb0(%arg28: index, %arg29: index, %arg30: index, %arg31: index, %arg32: memref<8x2048xf32>, %arg33: memref<2048x11008xf32>, %arg34: memref<2048x11008xf32>, %arg35: memref<11008x2048xf32>, %arg36: memref<8x2048xf32>, %arg37: memref<8x11008xf32>, %arg38: memref<8x11008xf32>, %arg39: memref<8x11008xf32>):
          %2 = "arith.constant"() <{value = 172 : index}> : () -> index
          %3 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %4 = "arith.constant"() <{value = 64 : index}> : () -> index
          %5 = "arith.constant"() <{value = 1 : index}> : () -> index
          %6 = "arith.constant"() <{value = 32 : index}> : () -> index
          %7 = "arith.constant"() <{value = 0 : index}> : () -> index
          %8 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.64.64.loops.8.64.64"} : () -> memref<4096xf32, 2 : i32>
          %9 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<512xf32, 2 : i32>
          %10 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data.input.8.64.loops.8.64.64"} : () -> memref<512xf32, 2 : i32>
          %11 = "air.wait_all"() : () -> !air.async.token
          %12 = "scf.for"(%7, %6, %5, %11) ({
          ^bb0(%arg40: index, %arg41: !air.async.token):
            %13 = "arith.muli"(%arg40, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %14 = "arith.muli"(%arg40, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.muli"(%arg40, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %16 = "memref.reinterpret_cast"(%9) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "down.initialize", orbit.phase = 11556 : i64, orbit.storage = "Y"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %17 = "arith.constant"() <{value = 0 : index}> : () -> index
            %18 = "arith.constant"() <{value = 8 : index}> : () -> index
            %19 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%17, %18, %19) ({
            ^bb0(%arg47: index):
              %52 = "arith.constant"() <{value = 0 : index}> : () -> index
              %53 = "arith.constant"() <{value = 64 : index}> : () -> index
              %54 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%52, %53, %54) ({
              ^bb0(%arg48: index):
                %55 = "arith.addi"(%arg48, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %56 = "arith.subi"(%55, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%3, %16, %arg47, %56) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %20 = "scf.for"(%7, %2, %5, %arg41) ({
            ^bb0(%arg42: index, %arg43: !air.async.token):
              %23 = "arith.muli"(%arg42, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %24 = "arith.muli"(%arg42, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "arith.muli"(%arg42, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "memref.reinterpret_cast"(%8) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11556 : i64, orbit.storage = "W_down"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %27 = "air.dma_memcpy_nd"(%arg43, %26, %arg35, %24, %14) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 11556 : i64, orbit.source_copies = array<i64: 11040>, orbit.storage = "W_down", orbit.target_copies = array<i64: 50944>, orbit.transfer = "host_to_l1", orbit.transfer_event = 34400 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<11008x2048xf32>, index, index) -> !air.async.token
              %28 = "memref.reinterpret_cast"(%10) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11556 : i64, orbit.storage = "H"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
              %29 = "air.dma_memcpy_nd"(%arg43, %28, %arg39, %25) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 11556 : i64, orbit.source_copies = array<i64: 50259>, orbit.storage = "H", orbit.target_copies = array<i64: 50945>, orbit.transfer = "host_to_l1", orbit.transfer_event = 34401 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x11008xf32>, index) -> !air.async.token
              "air.wait_all"(%27, %29) {orbit.computation_event = 34403 : i64, orbit.phase = 11556 : i64, orbit.phase_dependencies = array<i64: 11555>, orbit.read_copies = array<i64: 50944, 50946, 50945>, orbit.task = "down", orbit.write_copies = array<i64: 50947>} : (!air.async.token, !air.async.token) -> ()
              %30 = "arith.constant"() <{value = 0 : index}> : () -> index
              %31 = "arith.constant"() <{value = 8 : index}> : () -> index
              %32 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%30, %31, %32) ({
              ^bb0(%arg44: index):
                %34 = "arith.constant"() <{value = 0 : index}> : () -> index
                %35 = "arith.constant"() <{value = 64 : index}> : () -> index
                %36 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%34, %35, %36) ({
                ^bb0(%arg45: index):
                  %37 = "arith.addi"(%arg45, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %38 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %39 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %40 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%38, %39, %40) ({
                  ^bb0(%arg46: index):
                    %41 = "arith.addi"(%arg46, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %42 = "arith.subi"(%41, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %43 = "memref.load"(%28, %arg44, %42) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %44 = "arith.subi"(%41, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %45 = "arith.subi"(%37, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %46 = "memref.load"(%26, %44, %45) <{nontemporal = false}> : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %47 = "arith.subi"(%37, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %48 = "memref.load"(%16, %arg44, %47) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %49 = "arith.mulf"(%43, %46) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %50 = "arith.addf"(%48, %49) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %51 = "arith.subi"(%37, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%50, %16, %arg44, %51) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %33 = "air.wait_all"(%arg43) : (!air.async.token) -> !air.async.token
              "scf.yield"(%33) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %21 = "air.dma_memcpy_nd"(%20, %arg36, %15, %16) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11727 : i64, orbit.retained_begin = 11556 : i64, orbit.retained_end = 11728 : i64, orbit.source_copies = array<i64: 51460>, orbit.storage = "Y", orbit.target_copies = array<i64: 51461>, orbit.transfer = "l1_to_host", orbit.transfer_event = 34917 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 2048, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x2048xf32>, index, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %22 = "air.wait_all"(%21) : (!air.async.token) -> !air.async.token
            "scf.yield"(%22) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%12) : (!air.async.token) -> ()
          "memref.dealloc"(%8) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%9) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%10) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_11556"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_11556"} : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_11556"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.mapping_plan = "4e6757e119571f039a52dc04d559e930e7b5fc3274767f1cfa624d88bb5f42f3", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "a54c082680b6b7f5605f978b00756bdab5fa6b377971877f544451638574c8f1"} : () -> ()

