"builtin.module"() ({
  "func.func"() <{function_type = (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg30: index, %arg31: index, %arg32: index, %arg33: index, %arg34: memref<32x128xf32>, %arg35: memref<128x64xf32>, %arg36: memref<32x64xf32>, %arg37: memref<32x64xf32>):
      "air.segment"(%arg34, %arg35, %arg36, %arg37) ({
      ^bb0(%arg38: memref<32x128xf32>, %arg39: memref<128x64xf32>, %arg40: memref<32x64xf32>, %arg41: memref<32x64xf32>):
        %53 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%53, %53, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<32x128xf32>, %arg47: memref<128x64xf32>, %arg48: memref<32x64xf32>, %arg49: memref<32x64xf32>):
          %54 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %55 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %56 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %57 = "air.wait_all"() : () -> !air.async.token
          %58 = "arith.constant"() <{value = 0 : index}> : () -> index
          %59 = "arith.constant"() <{value = 4 : index}> : () -> index
          %60 = "arith.constant"() <{value = 1 : index}> : () -> index
          %61 = "scf.for"(%58, %59, %60, %57) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %62 = "arith.constant"() <{value = 8 : index}> : () -> index
            %63 = "arith.muli"(%arg50, %62) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %64 = "arith.constant"() <{value = 8 : index}> : () -> index
            %65 = "arith.muli"(%arg50, %64) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %66 = "arith.constant"() <{value = 8 : index}> : () -> index
            %67 = "arith.muli"(%arg50, %66) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %68 = "arith.constant"() <{value = 0 : index}> : () -> index
            %69 = "arith.constant"() <{value = 2 : index}> : () -> index
            %70 = "arith.constant"() <{value = 1 : index}> : () -> index
            %71 = "scf.for"(%68, %69, %70, %arg51) ({
            ^bb0(%arg52: index, %arg53: !air.async.token):
              %72 = "arith.constant"() <{value = 32 : index}> : () -> index
              %73 = "arith.muli"(%arg52, %72) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %74 = "arith.constant"() <{value = 32 : index}> : () -> index
              %75 = "arith.muli"(%arg52, %74) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %76 = "arith.constant"() <{value = 32 : index}> : () -> index
              %77 = "arith.muli"(%arg52, %76) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %78 = "memref.reinterpret_cast"(%56) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %79 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %80 = "arith.constant"() <{value = 0 : index}> : () -> index
              %81 = "arith.constant"() <{value = 8 : index}> : () -> index
              %82 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%80, %81, %82) ({
              ^bb0(%arg59: index):
                %138 = "arith.addi"(%arg59, %63) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %139 = "arith.constant"() <{value = 0 : index}> : () -> index
                %140 = "arith.constant"() <{value = 32 : index}> : () -> index
                %141 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%139, %140, %141) ({
                ^bb0(%arg60: index):
                  %142 = "arith.addi"(%arg60, %73) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %143 = "arith.subi"(%138, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %144 = "arith.subi"(%142, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%79, %78, %143, %144) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %83 = "arith.constant"() <{value = 0 : index}> : () -> index
              %84 = "arith.constant"() <{value = 4 : index}> : () -> index
              %85 = "arith.constant"() <{value = 1 : index}> : () -> index
              %86 = "scf.for"(%83, %84, %85, %arg53) ({
              ^bb0(%arg54: index, %arg55: !air.async.token):
                %93 = "arith.constant"() <{value = 32 : index}> : () -> index
                %94 = "arith.muli"(%arg54, %93) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %95 = "arith.constant"() <{value = 32 : index}> : () -> index
                %96 = "arith.muli"(%arg54, %95) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %97 = "arith.constant"() <{value = 32 : index}> : () -> index
                %98 = "arith.muli"(%arg54, %97) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %99 = "memref.reinterpret_cast"(%54) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %100 = "arith.constant"() <{value = 0 : index}> : () -> index
                %101 = "arith.addi"(%100, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %102 = "arith.constant"() <{value = 0 : index}> : () -> index
                %103 = "arith.addi"(%102, %96) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %104 = "air.dma_memcpy_nd"(%arg55, %99, %arg46, %101, %103) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 24>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
                %105 = "memref.reinterpret_cast"(%55) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                %106 = "arith.constant"() <{value = 0 : index}> : () -> index
                %107 = "arith.addi"(%106, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %108 = "arith.constant"() <{value = 0 : index}> : () -> index
                %109 = "arith.addi"(%108, %75) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %110 = "air.dma_memcpy_nd"(%arg55, %105, %arg47, %107, %109) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 25>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<128x64xf32>, index, index) -> !air.async.token
                "air.wait_all"(%104, %110) {orbit.computation_event = 3 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.read_copies = array<i64: 24, 25, 26>, orbit.task = "gemm", orbit.write_copies = array<i64: 27>} : (!air.async.token, !air.async.token) -> ()
                %111 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                %112 = "arith.constant"() <{value = 0 : index}> : () -> index
                %113 = "arith.constant"() <{value = 8 : index}> : () -> index
                %114 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%112, %113, %114) ({
                ^bb0(%arg56: index):
                  %116 = "arith.addi"(%arg56, %63) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %117 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %118 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %119 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%117, %118, %119) ({
                  ^bb0(%arg57: index):
                    %120 = "arith.addi"(%arg57, %73) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %121 = "arith.constant"() <{value = 0 : index}> : () -> index
                    %122 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %123 = "arith.constant"() <{value = 1 : index}> : () -> index
                    "scf.for"(%121, %122, %123) ({
                    ^bb0(%arg58: index):
                      %124 = "arith.addi"(%arg58, %94) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %125 = "arith.subi"(%116, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %126 = "arith.subi"(%124, %96) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %127 = "memref.load"(%99, %125, %126) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                      %128 = "arith.subi"(%124, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %129 = "arith.subi"(%120, %75) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %130 = "memref.load"(%105, %128, %129) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                      %131 = "arith.subi"(%116, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %132 = "arith.subi"(%120, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %133 = "memref.load"(%78, %131, %132) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                      %134 = "arith.mulf"(%127, %130) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                      %135 = "arith.addf"(%133, %134) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                      %136 = "arith.subi"(%116, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %137 = "arith.subi"(%120, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      "memref.store"(%135, %78, %136, %137) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                      "scf.yield"() : () -> ()
                    }) : (index, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                %115 = "air.wait_all"(%arg55) : (!air.async.token) -> !air.async.token
                "scf.yield"(%115) : (!air.async.token) -> ()
              }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
              %87 = "arith.constant"() <{value = 0 : index}> : () -> index
              %88 = "arith.addi"(%87, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %89 = "arith.constant"() <{value = 0 : index}> : () -> index
              %90 = "arith.addi"(%89, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %91 = "air.dma_memcpy_nd"(%86, %arg49, %88, %90, %78) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 11 : i64, orbit.retained_begin = 8 : i64, orbit.retained_end = 12 : i64, orbit.source_copies = array<i64: 36>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 37>, orbit.transfer = "l1_to_host", orbit.transfer_event = 13 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %92 = "air.wait_all"(%91) : (!air.async.token) -> !air.async.token
              "scf.yield"(%92) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%71) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%61) : (!air.async.token) -> ()
          "memref.dealloc"(%54) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%55) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%56) : (memref<256xf32, 2 : i32>) -> ()
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
              %40 = "air.dma_memcpy_nd"(%arg27, %arg22, %37, %39, %25) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 40 : i64, orbit.source_copies = array<i64: 137>, orbit.storage = "Y", orbit.target_copies = array<i64: 138>, orbit.transfer = "l1_to_host", orbit.transfer_event = 114 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x64xf32>, index, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
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
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "8af5e73bb04b8ab7b5a37d9d78738b4f672ac746cc9a392011bc360e715c88ac", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} : () -> ()

