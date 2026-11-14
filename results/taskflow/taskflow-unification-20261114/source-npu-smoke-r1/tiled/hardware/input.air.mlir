"builtin.module"() ({
  "func.func"() <{function_type = (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<64x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg47: index, %arg48: index, %arg49: index, %arg50: index, %arg51: memref<64x64xf32>, %arg52: memref<64x64xf32>, %arg53: memref<64x64xf32>):
      "air.segment"(%arg51, %arg52, %arg53) ({
      ^bb0(%arg54: memref<64x64xf32>, %arg55: memref<64x64xf32>, %arg56: memref<64x64xf32>):
        %100 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%100, %100, %arg54, %arg55, %arg56) ({
        ^bb0(%arg57: index, %arg58: index, %arg59: index, %arg60: index, %arg61: memref<64x64xf32>, %arg62: memref<64x64xf32>, %arg63: memref<64x64xf32>):
          %101 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %102 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1024xf32, 2 : i32>
          %103 = "air.wait_all"() : () -> !air.async.token
          %104 = "arith.constant"() <{value = 0 : index}> : () -> index
          %105 = "arith.constant"() <{value = 2 : index}> : () -> index
          %106 = "arith.constant"() <{value = 1 : index}> : () -> index
          %107 = "scf.for"(%104, %105, %106, %103) ({
          ^bb0(%arg64: index, %arg65: !air.async.token):
            %108 = "arith.constant"() <{value = 32 : index}> : () -> index
            %109 = "arith.muli"(%arg64, %108) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %110 = "arith.constant"() <{value = 32 : index}> : () -> index
            %111 = "arith.muli"(%arg64, %110) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %112 = "arith.constant"() <{value = 32 : index}> : () -> index
            %113 = "arith.muli"(%arg64, %112) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %114 = "memref.reinterpret_cast"(%101) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %115 = "arith.constant"() <{value = 0 : index}> : () -> index
            %116 = "arith.addi"(%115, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %117 = "air.dma_memcpy_nd"(%arg65, %114, %arg61, %116) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 4>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index) -> !air.async.token
            %118 = "memref.reinterpret_cast"(%102) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            "air.wait_all"(%arg65, %117) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 4>, orbit.source_instance = 0 : i64, orbit.task = "double.tile.0.0", orbit.write_copies = array<i64: 5>} : (!air.async.token, !air.async.token) -> ()
            %119 = "arith.constant"() <{value = 0 : index}> : () -> index
            %120 = "arith.constant"() <{value = 1 : index}> : () -> index
            %121 = "arith.constant"() <{value = 64 : index}> : () -> index
            %122 = "arith.constant"() <{value = 0 : index}> : () -> index
            %123 = "arith.constant"() <{value = 32 : index}> : () -> index
            %124 = "arith.constant"() <{value = 0 : index}> : () -> index
            %125 = "arith.constant"() <{value = 32 : index}> : () -> index
            %126 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%124, %125, %126) ({
            ^bb0(%arg66: index):
              %132 = "arith.constant"() <{value = 0 : index}> : () -> index
              %133 = "arith.constant"() <{value = 32 : index}> : () -> index
              %134 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%132, %133, %134) ({
              ^bb0(%arg67: index):
                %135 = "arith.addi"(%arg67, %109) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %136 = "arith.subi"(%135, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %137 = "memref.load"(%114, %arg66, %136) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %138 = "arith.addf"(%137, %137) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %139 = "arith.subi"(%135, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%138, %118, %arg66, %139) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %127 = "memref.reinterpret_cast"(%102) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %128 = "arith.constant"() <{value = 0 : index}> : () -> index
            %129 = "arith.addi"(%128, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %130 = "air.dma_memcpy_nd"(%arg65, %arg63, %129, %127) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "T", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %131 = "air.wait_all"(%130) : (!air.async.token) -> !air.async.token
            "scf.yield"(%131) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%107) : (!air.async.token) -> ()
          "memref.dealloc"(%101) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%102) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3, 4, 5>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg26: index, %arg27: index, %arg28: index, %arg29: index, %arg30: memref<64x64xf32>, %arg31: memref<64x64xf32>, %arg32: memref<64x64xf32>):
      "air.segment"(%arg30, %arg31, %arg32) ({
      ^bb0(%arg33: memref<64x64xf32>, %arg34: memref<64x64xf32>, %arg35: memref<64x64xf32>):
        %56 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%56, %56, %arg33, %arg34, %arg35) ({
        ^bb0(%arg36: index, %arg37: index, %arg38: index, %arg39: index, %arg40: memref<64x64xf32>, %arg41: memref<64x64xf32>, %arg42: memref<64x64xf32>):
          %57 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %58 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 6 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1024xf32, 2 : i32>
          %59 = "air.wait_all"() : () -> !air.async.token
          %60 = "arith.constant"() <{value = 0 : index}> : () -> index
          %61 = "arith.constant"() <{value = 2 : index}> : () -> index
          %62 = "arith.constant"() <{value = 1 : index}> : () -> index
          %63 = "scf.for"(%60, %61, %62, %59) ({
          ^bb0(%arg43: index, %arg44: !air.async.token):
            %64 = "arith.constant"() <{value = 32 : index}> : () -> index
            %65 = "arith.muli"(%arg43, %64) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %66 = "arith.constant"() <{value = 32 : index}> : () -> index
            %67 = "arith.muli"(%arg43, %66) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %68 = "arith.constant"() <{value = 32 : index}> : () -> index
            %69 = "arith.muli"(%arg43, %68) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %70 = "memref.reinterpret_cast"(%57) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 2 : i64, orbit.storage = "X"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %71 = "arith.constant"() <{value = 0 : index}> : () -> index
            %72 = "arith.addi"(%71, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %73 = "air.dma_memcpy_nd"(%arg44, %70, %arg40, %72) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 2 : i64, orbit.source_copies = array<i64: 2>, orbit.storage = "X", orbit.target_copies = array<i64: 10>, orbit.transfer = "host_to_l1", orbit.transfer_event = 6 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 32, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index) -> !air.async.token
            %74 = "memref.reinterpret_cast"(%58) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 2 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            "air.wait_all"(%arg44, %73) {orbit.computation_event = 7 : i64, orbit.phase = 2 : i64, orbit.phase_dependencies = array<i64: 1>, orbit.public_dependencies = array<i64: 5, 6>, orbit.read_copies = array<i64: 10>, orbit.source_instance = 2 : i64, orbit.task = "double.tile.0.1", orbit.write_copies = array<i64: 11>} : (!air.async.token, !air.async.token) -> ()
            %75 = "arith.constant"() <{value = 0 : index}> : () -> index
            %76 = "arith.constant"() <{value = 1 : index}> : () -> index
            %77 = "arith.constant"() <{value = 64 : index}> : () -> index
            %78 = "arith.constant"() <{value = 32 : index}> : () -> index
            %79 = "arith.constant"() <{value = 64 : index}> : () -> index
            %80 = "arith.constant"() <{value = 32 : index}> : () -> index
            %81 = "arith.constant"() <{value = 64 : index}> : () -> index
            %82 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%80, %81, %82) ({
            ^bb0(%arg45: index):
              %88 = "arith.constant"() <{value = 0 : index}> : () -> index
              %89 = "arith.constant"() <{value = 32 : index}> : () -> index
              %90 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%88, %89, %90) ({
              ^bb0(%arg46: index):
                %91 = "arith.addi"(%arg46, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %92 = "arith.constant"() <{value = 32 : index}> : () -> index
                %93 = "arith.subi"(%arg45, %92) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %94 = "arith.subi"(%91, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %95 = "memref.load"(%70, %93, %94) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %96 = "arith.addf"(%95, %95) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %97 = "arith.constant"() <{value = 32 : index}> : () -> index
                %98 = "arith.subi"(%arg45, %97) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %99 = "arith.subi"(%91, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%96, %74, %98, %99) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %83 = "memref.reinterpret_cast"(%58) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 2 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %84 = "arith.constant"() <{value = 0 : index}> : () -> index
            %85 = "arith.addi"(%84, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %86 = "air.dma_memcpy_nd"(%arg44, %arg42, %85, %83) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 2 : i64, orbit.source_copies = array<i64: 11>, orbit.storage = "T", orbit.target_copies = array<i64: 12>, orbit.transfer = "l1_to_host", orbit.transfer_event = 8 : i64, static_dst_offsets = array<i64: 32, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %87 = "air.wait_all"(%86) : (!air.async.token) -> !air.async.token
            "scf.yield"(%87) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%63) : (!air.async.token) -> ()
          "memref.dealloc"(%57) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%58) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.execution_group = 1 : i64, orbit.group_members = array<i64: 6, 7, 8, 9, 10, 11>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd_2"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment_2"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_2"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<64x64xf32>, %arg8: memref<64x64xf32>, %arg9: memref<64x64xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>, %arg12: memref<64x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<64x64xf32>, %arg18: memref<64x64xf32>, %arg19: memref<64x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 8 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1024xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 7 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 2 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "scf.for"(%5, %6, %7, %4) ({
          ^bb0(%arg20: index, %arg21: !air.async.token):
            %9 = "arith.constant"() <{value = 32 : index}> : () -> index
            %10 = "arith.muli"(%arg20, %9) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %11 = "arith.constant"() <{value = 32 : index}> : () -> index
            %12 = "arith.muli"(%arg20, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 32 : index}> : () -> index
            %14 = "arith.muli"(%arg20, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 0 : index}> : () -> index
            %16 = "arith.constant"() <{value = 2 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg21) ({
            ^bb0(%arg22: index, %arg23: !air.async.token):
              %19 = "arith.constant"() <{value = 32 : index}> : () -> index
              %20 = "arith.muli"(%arg22, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 32 : index}> : () -> index
              %22 = "arith.muli"(%arg22, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 32 : index}> : () -> index
              %24 = "arith.muli"(%arg22, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %26 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0 : index}> : () -> index
              %28 = "arith.addi"(%27, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %29 = "arith.constant"() <{value = 0 : index}> : () -> index
              %30 = "arith.addi"(%29, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "air.dma_memcpy_nd"(%arg23, %26, %arg19, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 6>, orbit.storage = "T", orbit.target_copies = array<i64: 16>, orbit.transfer = "host_to_l1", orbit.transfer_event = 12 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%arg23, %31) {orbit.computation_event = 13 : i64, orbit.phase = 4 : i64, orbit.phase_dependencies = array<i64: 3>, orbit.public_dependencies = array<i64: 5, 11, 12>, orbit.read_copies = array<i64: 16>, orbit.source_instance = 4 : i64, orbit.task = "square", orbit.write_copies = array<i64: 17>} : (!air.async.token, !air.async.token) -> ()
              %32 = "arith.constant"() <{value = 0 : index}> : () -> index
              %33 = "arith.constant"() <{value = 1 : index}> : () -> index
              %34 = "arith.constant"() <{value = 64 : index}> : () -> index
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.constant"() <{value = 32 : index}> : () -> index
              %37 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%35, %36, %37) ({
              ^bb0(%arg24: index):
                %45 = "arith.addi"(%arg24, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %46 = "arith.constant"() <{value = 0 : index}> : () -> index
                %47 = "arith.constant"() <{value = 32 : index}> : () -> index
                %48 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%46, %47, %48) ({
                ^bb0(%arg25: index):
                  %49 = "arith.addi"(%arg25, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %50 = "arith.subi"(%45, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %51 = "arith.subi"(%49, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "memref.load"(%26, %50, %51) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %53 = "arith.mulf"(%52, %52) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %54 = "arith.subi"(%45, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %55 = "arith.subi"(%49, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%53, %25, %54, %55) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %38 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %39 = "arith.constant"() <{value = 0 : index}> : () -> index
              %40 = "arith.addi"(%39, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %41 = "arith.constant"() <{value = 0 : index}> : () -> index
              %42 = "arith.addi"(%41, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %43 = "air.dma_memcpy_nd"(%arg23, %arg18, %40, %42, %38) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "Y", orbit.target_copies = array<i64: 18>, orbit.transfer = "l1_to_host", orbit.transfer_event = 14 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %44 = "air.wait_all"(%43) : (!air.async.token) -> !air.async.token
              "scf.yield"(%44) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.execution_group = 2 : i64, orbit.group_members = array<i64: 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd_4"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment_4"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_4"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_realization = "phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "common execution groups and explicit copy/release dependencies; source compute order preserved; conservative timing reservations are separate from runtime arbitration", orbit.mapping_plan = "eec47acc671078e24cc7f73060124fd64266a341cd4f5156e4bc434050ba7c96", orbit.program_graph = "2d898725bf1a373afe105cc85fddab1a3902420dae55882541fd2c1feeeb3634", orbit.source_fingerprint = "78eff522fe9f491f2ec0e002cebc37191c62e56b69d36ef2d0dec2d39d835c93"} : () -> ()

