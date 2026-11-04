"builtin.module"() ({
  "func.func"() <{function_type = (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg59: index, %arg60: index, %arg61: index, %arg62: index, %arg63: memref<32x128xf32>, %arg64: memref<128x64xf32>, %arg65: memref<32x64xf32>, %arg66: memref<32x64xf32>):
      "air.segment"(%arg63, %arg64, %arg65, %arg66) ({
      ^bb0(%arg67: memref<32x128xf32>, %arg68: memref<128x64xf32>, %arg69: memref<32x64xf32>, %arg70: memref<32x64xf32>):
        %130 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%130, %130, %arg67, %arg68, %arg69, %arg70) ({
        ^bb0(%arg71: index, %arg72: index, %arg73: index, %arg74: index, %arg75: memref<32x128xf32>, %arg76: memref<128x64xf32>, %arg77: memref<32x64xf32>, %arg78: memref<32x64xf32>):
          %131 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %132 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<4096xf32, 2 : i32>
          %133 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %134 = "air.wait_all"() : () -> !air.async.token
          %135 = "memref.reinterpret_cast"(%132) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "B"} : (memref<4096xf32, 2 : i32>) -> memref<128x32xf32, strided<[32, 1]>, 2 : i32>
          %136 = "air.dma_memcpy_nd"(%134, %135, %arg76) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 8 : i64, orbit.readonly_retained_begin = 8 : i64, orbit.readonly_retained_end = 24 : i64, orbit.source_copies = array<i64: 16, 18, 20, 22>, orbit.storage = "B", orbit.target_copies = array<i64: 25, 26, 27, 28>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 128, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x32xf32, strided<[32, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%136) : (!air.async.token) -> ()
          %137 = "arith.constant"() <{value = 0 : index}> : () -> index
          %138 = "arith.constant"() <{value = 4 : index}> : () -> index
          %139 = "arith.constant"() <{value = 1 : index}> : () -> index
          %140 = "scf.for"(%137, %138, %139, %136) ({
          ^bb0(%arg79: index, %arg80: !air.async.token):
            %141 = "arith.constant"() <{value = 8 : index}> : () -> index
            %142 = "arith.muli"(%arg79, %141) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %143 = "arith.constant"() <{value = 8 : index}> : () -> index
            %144 = "arith.muli"(%arg79, %143) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %145 = "arith.constant"() <{value = 8 : index}> : () -> index
            %146 = "arith.muli"(%arg79, %145) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %147 = "memref.reinterpret_cast"(%133) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %148 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %149 = "arith.constant"() <{value = 0 : index}> : () -> index
            %150 = "arith.constant"() <{value = 8 : index}> : () -> index
            %151 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%149, %150, %151) ({
            ^bb0(%arg86: index):
              %194 = "arith.addi"(%arg86, %142) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %195 = "arith.constant"() <{value = 0 : index}> : () -> index
              %196 = "arith.constant"() <{value = 32 : index}> : () -> index
              %197 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%195, %196, %197) ({
              ^bb0(%arg87: index):
                %198 = "arith.subi"(%194, %146) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%148, %147, %198, %arg87) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
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
              %166 = "memref.reinterpret_cast"(%131) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %167 = "arith.constant"() <{value = 0 : index}> : () -> index
              %168 = "arith.addi"(%167, %144) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %169 = "arith.constant"() <{value = 0 : index}> : () -> index
              %170 = "arith.addi"(%169, %163) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %171 = "air.dma_memcpy_nd"(%arg82, %166, %arg75, %168, %170) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 24>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%171) {orbit.computation_event = 3 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.read_copies = array<i64: 24, 25, 29>, orbit.task = "gemm", orbit.write_copies = array<i64: 30>} : (!air.async.token) -> ()
              %172 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %173 = "arith.constant"() <{value = 0 : index}> : () -> index
              %174 = "arith.constant"() <{value = 8 : index}> : () -> index
              %175 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%173, %174, %175) ({
              ^bb0(%arg83: index):
                %177 = "arith.addi"(%arg83, %142) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %178 = "arith.constant"() <{value = 0 : index}> : () -> index
                %179 = "arith.constant"() <{value = 32 : index}> : () -> index
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
                    %188 = "memref.load"(%135, %184, %arg84) <{nontemporal = false}> : (memref<128x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %189 = "arith.subi"(%177, %146) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %190 = "memref.load"(%147, %189, %arg84) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %191 = "arith.mulf"(%187, %188) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %192 = "arith.addf"(%190, %191) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %193 = "arith.subi"(%177, %146) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%192, %147, %193, %arg84) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
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
            %158 = "air.dma_memcpy_nd"(%155, %arg78, %157, %147) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11 : i64, orbit.retained_begin = 8 : i64, orbit.retained_end = 12 : i64, orbit.source_copies = array<i64: 36>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 37>, orbit.transfer = "l1_to_host", orbit.transfer_event = 10 : i64, static_dst_offsets = array<i64: -9223372036854775808, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %159 = "air.wait_all"(%158) : (!air.async.token) -> !air.async.token
            "scf.yield"(%159) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%140) : (!air.async.token) -> ()
          "memref.dealloc"(%131) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%132) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%133) : (memref<256xf32, 2 : i32>) -> ()
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
        %53 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%53, %53, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<32x128xf32>, %arg47: memref<128x64xf32>, %arg48: memref<32x64xf32>, %arg49: memref<32x64xf32>):
          %54 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %55 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<4096xf32, 2 : i32>
          %56 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %57 = "air.wait_all"() : () -> !air.async.token
          %58 = "memref.reinterpret_cast"(%55) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "B"} : (memref<4096xf32, 2 : i32>) -> memref<128x32xf32, strided<[32, 1]>, 2 : i32>
          %59 = "air.dma_memcpy_nd"(%57, %58, %arg47) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 24 : i64, orbit.readonly_retained_begin = 24 : i64, orbit.readonly_retained_end = 40 : i64, orbit.source_copies = array<i64: 17, 19, 21, 23>, orbit.storage = "B", orbit.target_copies = array<i64: 69, 70, 71, 72>, orbit.transfer = "host_to_l1", orbit.transfer_event = 42 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, 32>, static_src_sizes = array<i64: 128, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x32xf32, strided<[32, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%59) : (!air.async.token) -> ()
          %60 = "arith.constant"() <{value = 0 : index}> : () -> index
          %61 = "arith.constant"() <{value = 4 : index}> : () -> index
          %62 = "arith.constant"() <{value = 1 : index}> : () -> index
          %63 = "scf.for"(%60, %61, %62, %59) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %64 = "arith.constant"() <{value = 8 : index}> : () -> index
            %65 = "arith.muli"(%arg50, %64) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %66 = "arith.constant"() <{value = 8 : index}> : () -> index
            %67 = "arith.muli"(%arg50, %66) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %68 = "arith.constant"() <{value = 8 : index}> : () -> index
            %69 = "arith.muli"(%arg50, %68) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %70 = "memref.reinterpret_cast"(%56) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %71 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %72 = "arith.constant"() <{value = 0 : index}> : () -> index
            %73 = "arith.constant"() <{value = 8 : index}> : () -> index
            %74 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%72, %73, %74) ({
            ^bb0(%arg57: index):
              %123 = "arith.addi"(%arg57, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %124 = "arith.constant"() <{value = 32 : index}> : () -> index
              %125 = "arith.constant"() <{value = 64 : index}> : () -> index
              %126 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%124, %125, %126) ({
              ^bb0(%arg58: index):
                %127 = "arith.constant"() <{value = 32 : index}> : () -> index
                %128 = "arith.subi"(%arg58, %127) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %129 = "arith.subi"(%123, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%71, %70, %129, %128) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
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
              %89 = "memref.reinterpret_cast"(%54) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %90 = "arith.constant"() <{value = 0 : index}> : () -> index
              %91 = "arith.addi"(%90, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %92 = "arith.constant"() <{value = 0 : index}> : () -> index
              %93 = "arith.addi"(%92, %86) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %94 = "air.dma_memcpy_nd"(%arg53, %89, %arg46, %91, %93) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 24 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 68>, orbit.transfer = "host_to_l1", orbit.transfer_event = 41 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%94) {orbit.computation_event = 44 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 68, 69, 73>, orbit.task = "gemm", orbit.write_copies = array<i64: 74>} : (!air.async.token) -> ()
              %95 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %96 = "arith.constant"() <{value = 0 : index}> : () -> index
              %97 = "arith.constant"() <{value = 8 : index}> : () -> index
              %98 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%96, %97, %98) ({
              ^bb0(%arg54: index):
                %100 = "arith.addi"(%arg54, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %101 = "arith.constant"() <{value = 32 : index}> : () -> index
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
                    %111 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %112 = "arith.subi"(%arg55, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %113 = "memref.load"(%58, %107, %112) <{nontemporal = false}> : (memref<128x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %114 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %115 = "arith.subi"(%arg55, %114) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %116 = "arith.subi"(%100, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %117 = "memref.load"(%70, %116, %115) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                    %118 = "arith.mulf"(%110, %113) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %119 = "arith.addf"(%117, %118) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                    %120 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %121 = "arith.subi"(%arg55, %120) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %122 = "arith.subi"(%100, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "memref.store"(%119, %70, %122, %121) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
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
            %81 = "air.dma_memcpy_nd"(%78, %arg49, %80, %70) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 27 : i64, orbit.retained_begin = 24 : i64, orbit.retained_end = 28 : i64, orbit.source_copies = array<i64: 80>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 81>, orbit.transfer = "l1_to_host", orbit.transfer_event = 51 : i64, static_dst_offsets = array<i64: -9223372036854775808, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %82 = "air.wait_all"(%81) : (!air.async.token) -> !air.async.token
            "scf.yield"(%82) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%63) : (!air.async.token) -> ()
          "memref.dealloc"(%54) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%55) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%56) : (memref<256xf32, 2 : i32>) -> ()
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
              %32 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
              %33 = "arith.constant"() <{value = 0 : index}> : () -> index
              %34 = "arith.constant"() <{value = 8 : index}> : () -> index
              %35 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%33, %34, %35) ({
              ^bb0(%arg28: index):
                %42 = "arith.addi"(%arg28, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %43 = "arith.constant"() <{value = 0 : index}> : () -> index
                %44 = "arith.constant"() <{value = 32 : index}> : () -> index
                %45 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%43, %44, %45) ({
                ^bb0(%arg29: index):
                  %46 = "arith.addi"(%arg29, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %47 = "arith.subi"(%42, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %48 = "arith.subi"(%46, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %49 = "memref.load"(%26, %47, %48) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %50 = "arith.mulf"(%49, %32) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %51 = "arith.subi"(%42, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "arith.subi"(%46, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%50, %25, %51, %52) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %36 = "arith.constant"() <{value = 0 : index}> : () -> index
              %37 = "arith.addi"(%36, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %38 = "arith.constant"() <{value = 0 : index}> : () -> index
              %39 = "arith.addi"(%38, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %40 = "air.dma_memcpy_nd"(%arg27, %arg22, %37, %39, %25) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 113>, orbit.storage = "Y", orbit.target_copies = array<i64: 114>, orbit.transfer = "l1_to_host", orbit.transfer_event = 84 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %41 = "air.wait_all"(%40) : (!air.async.token) -> !air.async.token
              "scf.yield"(%41) : (!air.async.token) -> ()
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
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.mapping_plan = "3b1cf004711945828aa888ad64af3481de4797b1774274afd4152e6fef6d28ac", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} : () -> ()

