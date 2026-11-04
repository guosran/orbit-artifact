"builtin.module"() ({
  "func.func"() <{function_type = (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg382: index, %arg383: index, %arg384: index, %arg385: index, %arg386: memref<17x129xf32>, %arg387: memref<129x80xf32>, %arg388: memref<17x80xf32>, %arg389: memref<17x80xf32>):
      "air.segment"(%arg386, %arg387, %arg388, %arg389) ({
      ^bb0(%arg390: memref<17x129xf32>, %arg391: memref<129x80xf32>, %arg392: memref<17x80xf32>, %arg393: memref<17x80xf32>):
        %988 = "arith.constant"() <{value = 1 : index}> : () -> index
        %989 = "air.herd"(%988, %988, %arg390, %arg391, %arg392, %arg393) ({
        ^bb0(%arg394: index, %arg395: index, %arg396: index, %arg397: index, %arg398: memref<17x129xf32>, %arg399: memref<129x80xf32>, %arg400: memref<17x80xf32>, %arg401: memref<17x80xf32>):
          %990 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %991 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %992 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %993 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %994 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %995 = "air.wait_all"() : () -> !air.async.token
          %996 = "memref.reinterpret_cast"(%994) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 9 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %997 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %998 = "arith.constant"() <{value = 0 : index}> : () -> index
          %999 = "arith.constant"() <{value = 8 : index}> : () -> index
          %1000 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%998, %999, %1000) ({
          ^bb0(%arg410: index):
            %1064 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1065 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1066 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%1064, %1065, %1066) ({
            ^bb0(%arg411: index):
              "memref.store"(%997, %996, %arg410, %arg411) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %1001 = "arith.constant"() <{value = 0 : index}> : () -> index
          %1002 = "arith.constant"() <{value = 4 : index}> : () -> index
          %1003 = "arith.constant"() <{value = 1 : index}> : () -> index
          %1004 = "scf.for"(%1001, %1002, %1003, %995) ({
          ^bb0(%arg405: index, %arg406: !air.async.token):
            %1031 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1032 = "arith.muli"(%arg405, %1031) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1033 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1034 = "arith.muli"(%arg405, %1033) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1035 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1036 = "arith.muli"(%arg405, %1035) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1037 = "memref.reinterpret_cast"(%991) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 9 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %1038 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1039 = "arith.addi"(%1038, %1034) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1040 = "air.dma_memcpy_nd"(%arg406, %1037, %arg398, %1039) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 9 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 30>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %1041 = "memref.reinterpret_cast"(%993) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 9 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %1042 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1043 = "arith.addi"(%1042, %1036) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1044 = "air.dma_memcpy_nd"(%arg406, %1041, %arg399, %1043) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 9 : i64, orbit.source_copies = array<i64: 15>, orbit.storage = "B", orbit.target_copies = array<i64: 31>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%1040, %1044) {orbit.computation_event = 3 : i64, orbit.phase = 9 : i64, orbit.phase_dependencies = array<i64: 8>, orbit.read_copies = array<i64: 30, 31, 32>, orbit.task = "gemm", orbit.write_copies = array<i64: 33>} : (!air.async.token, !air.async.token) -> ()
            %1045 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %1046 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1047 = "arith.constant"() <{value = 8 : index}> : () -> index
            %1048 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%1046, %1047, %1048) ({
            ^bb0(%arg407: index):
              %1050 = "arith.constant"() <{value = 0 : index}> : () -> index
              %1051 = "arith.constant"() <{value = 32 : index}> : () -> index
              %1052 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%1050, %1051, %1052) ({
              ^bb0(%arg408: index):
                %1053 = "arith.constant"() <{value = 0 : index}> : () -> index
                %1054 = "arith.constant"() <{value = 32 : index}> : () -> index
                %1055 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%1053, %1054, %1055) ({
                ^bb0(%arg409: index):
                  %1056 = "arith.addi"(%arg409, %1032) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1057 = "arith.subi"(%1056, %1034) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1058 = "memref.load"(%1037, %arg407, %1057) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1059 = "arith.subi"(%1056, %1036) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1060 = "memref.load"(%1041, %1059, %arg408) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1061 = "memref.load"(%996, %arg407, %arg408) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1062 = "arith.mulf"(%1058, %1060) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %1063 = "arith.addf"(%1061, %1062) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  "memref.store"(%1063, %996, %arg407, %arg408) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %1049 = "air.wait_all"(%arg406) : (!air.async.token) -> !air.async.token
            "scf.yield"(%1049) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %1005 = "memref.reinterpret_cast"(%990) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 13 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %1006 = "air.dma_memcpy_nd"(%1004, %1005, %arg398) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 13 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "A", orbit.target_copies = array<i64: 43>, orbit.transfer = "host_to_l1", orbit.transfer_event = 13 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %1007 = "memref.reinterpret_cast"(%992) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 13 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %1008 = "air.dma_memcpy_nd"(%1004, %1007, %arg399) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 13 : i64, orbit.source_copies = array<i64: 27>, orbit.storage = "B", orbit.target_copies = array<i64: 44>, orbit.transfer = "host_to_l1", orbit.transfer_event = 14 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%1006, %1008) {orbit.computation_event = 15 : i64, orbit.phase = 13 : i64, orbit.phase_dependencies = array<i64: 12>, orbit.read_copies = array<i64: 43, 44, 42>, orbit.task = "gemm", orbit.write_copies = array<i64: 45>} : (!air.async.token, !air.async.token) -> ()
          %1009 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %1010 = "arith.constant"() <{value = 0 : index}> : () -> index
          %1011 = "arith.constant"() <{value = 8 : index}> : () -> index
          %1012 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%1010, %1011, %1012) ({
          ^bb0(%arg402: index):
            %1016 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1017 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1018 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%1016, %1017, %1018) ({
            ^bb0(%arg403: index):
              %1019 = "arith.constant"() <{value = 128 : index}> : () -> index
              %1020 = "arith.constant"() <{value = 129 : index}> : () -> index
              %1021 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%1019, %1020, %1021) ({
              ^bb0(%arg404: index):
                %1022 = "arith.constant"() <{value = 128 : index}> : () -> index
                %1023 = "arith.subi"(%arg404, %1022) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %1024 = "memref.load"(%1005, %arg402, %1023) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %1025 = "arith.constant"() <{value = 128 : index}> : () -> index
                %1026 = "arith.subi"(%arg404, %1025) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %1027 = "memref.load"(%1007, %1026, %arg403) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %1028 = "memref.load"(%996, %arg402, %arg403) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %1029 = "arith.mulf"(%1024, %1027) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %1030 = "arith.addf"(%1028, %1029) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                "memref.store"(%1030, %996, %arg402, %arg403) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %1013 = "air.wait_all"(%1004) : (!air.async.token) -> !air.async.token
          %1014 = "air.dma_memcpy_nd"(%1013, %arg401, %996) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 13 : i64, orbit.retained_begin = 9 : i64, orbit.retained_end = 14 : i64, orbit.source_copies = array<i64: 45>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 46>, orbit.transfer = "l1_to_host", orbit.transfer_event = 16 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %1015 = "air.wait_all"(%1014) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%1015) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%989) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg352: index, %arg353: index, %arg354: index, %arg355: index, %arg356: memref<17x129xf32>, %arg357: memref<129x80xf32>, %arg358: memref<17x80xf32>, %arg359: memref<17x80xf32>):
      "air.segment"(%arg356, %arg357, %arg358, %arg359) ({
      ^bb0(%arg360: memref<17x129xf32>, %arg361: memref<129x80xf32>, %arg362: memref<17x80xf32>, %arg363: memref<17x80xf32>):
        %895 = "arith.constant"() <{value = 1 : index}> : () -> index
        %896 = "air.herd"(%895, %895, %arg360, %arg361, %arg362, %arg363) ({
        ^bb0(%arg364: index, %arg365: index, %arg366: index, %arg367: index, %arg368: memref<17x129xf32>, %arg369: memref<129x80xf32>, %arg370: memref<17x80xf32>, %arg371: memref<17x80xf32>):
          %897 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %898 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %899 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %900 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %901 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %902 = "air.wait_all"() : () -> !air.async.token
          %903 = "memref.reinterpret_cast"(%901) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 14 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %904 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %905 = "arith.constant"() <{value = 0 : index}> : () -> index
          %906 = "arith.constant"() <{value = 8 : index}> : () -> index
          %907 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%905, %906, %907) ({
          ^bb0(%arg380: index):
            %983 = "arith.constant"() <{value = 32 : index}> : () -> index
            %984 = "arith.constant"() <{value = 64 : index}> : () -> index
            %985 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%983, %984, %985) ({
            ^bb0(%arg381: index):
              %986 = "arith.constant"() <{value = 32 : index}> : () -> index
              %987 = "arith.subi"(%arg381, %986) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%904, %903, %arg380, %987) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %908 = "arith.constant"() <{value = 0 : index}> : () -> index
          %909 = "arith.constant"() <{value = 4 : index}> : () -> index
          %910 = "arith.constant"() <{value = 1 : index}> : () -> index
          %911 = "scf.for"(%908, %909, %910, %902) ({
          ^bb0(%arg375: index, %arg376: !air.async.token):
            %944 = "arith.constant"() <{value = 32 : index}> : () -> index
            %945 = "arith.muli"(%arg375, %944) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %946 = "arith.constant"() <{value = 32 : index}> : () -> index
            %947 = "arith.muli"(%arg375, %946) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %948 = "arith.constant"() <{value = 32 : index}> : () -> index
            %949 = "arith.muli"(%arg375, %948) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %950 = "memref.reinterpret_cast"(%898) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 14 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %951 = "arith.constant"() <{value = 0 : index}> : () -> index
            %952 = "arith.addi"(%951, %947) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %953 = "air.dma_memcpy_nd"(%arg376, %950, %arg368, %952) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 14 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 47>, orbit.transfer = "host_to_l1", orbit.transfer_event = 17 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %954 = "memref.reinterpret_cast"(%900) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 14 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %955 = "arith.constant"() <{value = 0 : index}> : () -> index
            %956 = "arith.addi"(%955, %949) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %957 = "air.dma_memcpy_nd"(%arg376, %954, %arg369, %956) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 14 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 48>, orbit.transfer = "host_to_l1", orbit.transfer_event = 18 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%953, %957) {orbit.computation_event = 20 : i64, orbit.phase = 14 : i64, orbit.phase_dependencies = array<i64: 13>, orbit.read_copies = array<i64: 47, 48, 49>, orbit.task = "gemm", orbit.write_copies = array<i64: 50>} : (!air.async.token, !air.async.token) -> ()
            %958 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %959 = "arith.constant"() <{value = 0 : index}> : () -> index
            %960 = "arith.constant"() <{value = 8 : index}> : () -> index
            %961 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%959, %960, %961) ({
            ^bb0(%arg377: index):
              %963 = "arith.constant"() <{value = 32 : index}> : () -> index
              %964 = "arith.constant"() <{value = 64 : index}> : () -> index
              %965 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%963, %964, %965) ({
              ^bb0(%arg378: index):
                %966 = "arith.constant"() <{value = 0 : index}> : () -> index
                %967 = "arith.constant"() <{value = 32 : index}> : () -> index
                %968 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%966, %967, %968) ({
                ^bb0(%arg379: index):
                  %969 = "arith.addi"(%arg379, %945) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %970 = "arith.subi"(%969, %947) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %971 = "memref.load"(%950, %arg377, %970) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %972 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %973 = "arith.subi"(%arg378, %972) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %974 = "arith.subi"(%969, %949) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %975 = "memref.load"(%954, %974, %973) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %976 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %977 = "arith.subi"(%arg378, %976) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %978 = "memref.load"(%903, %arg377, %977) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %979 = "arith.mulf"(%971, %975) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %980 = "arith.addf"(%978, %979) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %981 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %982 = "arith.subi"(%arg378, %981) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%980, %903, %arg377, %982) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %962 = "air.wait_all"(%arg376) : (!air.async.token) -> !air.async.token
            "scf.yield"(%962) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %912 = "memref.reinterpret_cast"(%897) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 18 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %913 = "air.dma_memcpy_nd"(%911, %912, %arg368) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 18 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "A", orbit.target_copies = array<i64: 60>, orbit.transfer = "host_to_l1", orbit.transfer_event = 30 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %914 = "memref.reinterpret_cast"(%899) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 18 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %915 = "air.dma_memcpy_nd"(%911, %914, %arg369) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 18 : i64, orbit.source_copies = array<i64: 28>, orbit.storage = "B", orbit.target_copies = array<i64: 61>, orbit.transfer = "host_to_l1", orbit.transfer_event = 31 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%913, %915) {orbit.computation_event = 32 : i64, orbit.phase = 18 : i64, orbit.phase_dependencies = array<i64: 17>, orbit.read_copies = array<i64: 60, 61, 59>, orbit.task = "gemm", orbit.write_copies = array<i64: 62>} : (!air.async.token, !air.async.token) -> ()
          %916 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %917 = "arith.constant"() <{value = 0 : index}> : () -> index
          %918 = "arith.constant"() <{value = 8 : index}> : () -> index
          %919 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%917, %918, %919) ({
          ^bb0(%arg372: index):
            %923 = "arith.constant"() <{value = 32 : index}> : () -> index
            %924 = "arith.constant"() <{value = 64 : index}> : () -> index
            %925 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%923, %924, %925) ({
            ^bb0(%arg373: index):
              %926 = "arith.constant"() <{value = 128 : index}> : () -> index
              %927 = "arith.constant"() <{value = 129 : index}> : () -> index
              %928 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%926, %927, %928) ({
              ^bb0(%arg374: index):
                %929 = "arith.constant"() <{value = 128 : index}> : () -> index
                %930 = "arith.subi"(%arg374, %929) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %931 = "memref.load"(%912, %arg372, %930) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %932 = "arith.constant"() <{value = 128 : index}> : () -> index
                %933 = "arith.subi"(%arg374, %932) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %934 = "arith.constant"() <{value = 32 : index}> : () -> index
                %935 = "arith.subi"(%arg373, %934) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %936 = "memref.load"(%914, %933, %935) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %937 = "arith.constant"() <{value = 32 : index}> : () -> index
                %938 = "arith.subi"(%arg373, %937) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %939 = "memref.load"(%903, %arg372, %938) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %940 = "arith.mulf"(%931, %936) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %941 = "arith.addf"(%939, %940) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %942 = "arith.constant"() <{value = 32 : index}> : () -> index
                %943 = "arith.subi"(%arg373, %942) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%941, %903, %arg372, %943) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %920 = "air.wait_all"(%911) : (!air.async.token) -> !air.async.token
          %921 = "air.dma_memcpy_nd"(%920, %arg371, %903) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 18 : i64, orbit.retained_begin = 14 : i64, orbit.retained_end = 19 : i64, orbit.source_copies = array<i64: 62>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 63>, orbit.transfer = "l1_to_host", orbit.transfer_event = 33 : i64, static_dst_offsets = array<i64: 0, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %922 = "air.wait_all"(%921) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%922) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_14"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%896) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_14"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_14"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg322: index, %arg323: index, %arg324: index, %arg325: index, %arg326: memref<17x129xf32>, %arg327: memref<129x80xf32>, %arg328: memref<17x80xf32>, %arg329: memref<17x80xf32>):
      "air.segment"(%arg326, %arg327, %arg328, %arg329) ({
      ^bb0(%arg330: memref<17x129xf32>, %arg331: memref<129x80xf32>, %arg332: memref<17x80xf32>, %arg333: memref<17x80xf32>):
        %802 = "arith.constant"() <{value = 1 : index}> : () -> index
        %803 = "air.herd"(%802, %802, %arg330, %arg331, %arg332, %arg333) ({
        ^bb0(%arg334: index, %arg335: index, %arg336: index, %arg337: index, %arg338: memref<17x129xf32>, %arg339: memref<129x80xf32>, %arg340: memref<17x80xf32>, %arg341: memref<17x80xf32>):
          %804 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : () -> memref<8xf32, 2 : i32>
          %805 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %806 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : () -> memref<16xf32, 2 : i32>
          %807 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : () -> memref<512xf32, 2 : i32>
          %808 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %809 = "air.wait_all"() : () -> !air.async.token
          %810 = "memref.reinterpret_cast"(%808) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 19 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %811 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %812 = "arith.constant"() <{value = 0 : index}> : () -> index
          %813 = "arith.constant"() <{value = 8 : index}> : () -> index
          %814 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%812, %813, %814) ({
          ^bb0(%arg350: index):
            %890 = "arith.constant"() <{value = 64 : index}> : () -> index
            %891 = "arith.constant"() <{value = 80 : index}> : () -> index
            %892 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%890, %891, %892) ({
            ^bb0(%arg351: index):
              %893 = "arith.constant"() <{value = 64 : index}> : () -> index
              %894 = "arith.subi"(%arg351, %893) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%811, %810, %arg350, %894) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %815 = "arith.constant"() <{value = 0 : index}> : () -> index
          %816 = "arith.constant"() <{value = 4 : index}> : () -> index
          %817 = "arith.constant"() <{value = 1 : index}> : () -> index
          %818 = "scf.for"(%815, %816, %817, %809) ({
          ^bb0(%arg345: index, %arg346: !air.async.token):
            %851 = "arith.constant"() <{value = 32 : index}> : () -> index
            %852 = "arith.muli"(%arg345, %851) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %853 = "arith.constant"() <{value = 32 : index}> : () -> index
            %854 = "arith.muli"(%arg345, %853) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %855 = "arith.constant"() <{value = 32 : index}> : () -> index
            %856 = "arith.muli"(%arg345, %855) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %857 = "memref.reinterpret_cast"(%805) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 19 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %858 = "arith.constant"() <{value = 0 : index}> : () -> index
            %859 = "arith.addi"(%858, %854) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %860 = "air.dma_memcpy_nd"(%arg346, %857, %arg338, %859) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 19 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 64>, orbit.transfer = "host_to_l1", orbit.transfer_event = 34 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %861 = "memref.reinterpret_cast"(%807) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 19 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %862 = "arith.constant"() <{value = 0 : index}> : () -> index
            %863 = "arith.addi"(%862, %856) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %864 = "air.dma_memcpy_nd"(%arg346, %861, %arg339, %863) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 19 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "B", orbit.target_copies = array<i64: 65>, orbit.transfer = "host_to_l1", orbit.transfer_event = 35 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%860, %864) {orbit.computation_event = 37 : i64, orbit.phase = 19 : i64, orbit.phase_dependencies = array<i64: 18>, orbit.read_copies = array<i64: 64, 65, 66>, orbit.task = "gemm", orbit.write_copies = array<i64: 67>} : (!air.async.token, !air.async.token) -> ()
            %865 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %866 = "arith.constant"() <{value = 0 : index}> : () -> index
            %867 = "arith.constant"() <{value = 8 : index}> : () -> index
            %868 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%866, %867, %868) ({
            ^bb0(%arg347: index):
              %870 = "arith.constant"() <{value = 64 : index}> : () -> index
              %871 = "arith.constant"() <{value = 80 : index}> : () -> index
              %872 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%870, %871, %872) ({
              ^bb0(%arg348: index):
                %873 = "arith.constant"() <{value = 0 : index}> : () -> index
                %874 = "arith.constant"() <{value = 32 : index}> : () -> index
                %875 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%873, %874, %875) ({
                ^bb0(%arg349: index):
                  %876 = "arith.addi"(%arg349, %852) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %877 = "arith.subi"(%876, %854) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %878 = "memref.load"(%857, %arg347, %877) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %879 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %880 = "arith.subi"(%arg348, %879) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %881 = "arith.subi"(%876, %856) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %882 = "memref.load"(%861, %881, %880) <{nontemporal = false}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %883 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %884 = "arith.subi"(%arg348, %883) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %885 = "memref.load"(%810, %arg347, %884) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %886 = "arith.mulf"(%878, %882) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %887 = "arith.addf"(%885, %886) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %888 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %889 = "arith.subi"(%arg348, %888) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%887, %810, %arg347, %889) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %869 = "air.wait_all"(%arg346) : (!air.async.token) -> !air.async.token
            "scf.yield"(%869) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %819 = "memref.reinterpret_cast"(%804) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 23 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %820 = "air.dma_memcpy_nd"(%818, %819, %arg338) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 23 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "A", orbit.target_copies = array<i64: 77>, orbit.transfer = "host_to_l1", orbit.transfer_event = 47 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %821 = "memref.reinterpret_cast"(%806) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 23 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %822 = "air.dma_memcpy_nd"(%818, %821, %arg339) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 23 : i64, orbit.source_copies = array<i64: 29>, orbit.storage = "B", orbit.target_copies = array<i64: 78>, orbit.transfer = "host_to_l1", orbit.transfer_event = 48 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%820, %822) {orbit.computation_event = 49 : i64, orbit.phase = 23 : i64, orbit.phase_dependencies = array<i64: 22>, orbit.read_copies = array<i64: 77, 78, 76>, orbit.task = "gemm", orbit.write_copies = array<i64: 79>} : (!air.async.token, !air.async.token) -> ()
          %823 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %824 = "arith.constant"() <{value = 0 : index}> : () -> index
          %825 = "arith.constant"() <{value = 8 : index}> : () -> index
          %826 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%824, %825, %826) ({
          ^bb0(%arg342: index):
            %830 = "arith.constant"() <{value = 64 : index}> : () -> index
            %831 = "arith.constant"() <{value = 80 : index}> : () -> index
            %832 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%830, %831, %832) ({
            ^bb0(%arg343: index):
              %833 = "arith.constant"() <{value = 128 : index}> : () -> index
              %834 = "arith.constant"() <{value = 129 : index}> : () -> index
              %835 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%833, %834, %835) ({
              ^bb0(%arg344: index):
                %836 = "arith.constant"() <{value = 128 : index}> : () -> index
                %837 = "arith.subi"(%arg344, %836) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %838 = "memref.load"(%819, %arg342, %837) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %839 = "arith.constant"() <{value = 128 : index}> : () -> index
                %840 = "arith.subi"(%arg344, %839) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %841 = "arith.constant"() <{value = 64 : index}> : () -> index
                %842 = "arith.subi"(%arg343, %841) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %843 = "memref.load"(%821, %840, %842) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %844 = "arith.constant"() <{value = 64 : index}> : () -> index
                %845 = "arith.subi"(%arg343, %844) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %846 = "memref.load"(%810, %arg342, %845) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %847 = "arith.mulf"(%838, %843) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %848 = "arith.addf"(%846, %847) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %849 = "arith.constant"() <{value = 64 : index}> : () -> index
                %850 = "arith.subi"(%arg343, %849) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%848, %810, %arg342, %850) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %827 = "air.wait_all"(%818) : (!air.async.token) -> !air.async.token
          %828 = "air.dma_memcpy_nd"(%827, %arg341, %810) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 23 : i64, orbit.retained_begin = 19 : i64, orbit.retained_end = 24 : i64, orbit.source_copies = array<i64: 79>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 80>, orbit.transfer = "l1_to_host", orbit.transfer_event = 50 : i64, static_dst_offsets = array<i64: 0, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %829 = "air.wait_all"(%828) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%829) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_19"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%803) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_19"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_19"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg292: index, %arg293: index, %arg294: index, %arg295: index, %arg296: memref<17x129xf32>, %arg297: memref<129x80xf32>, %arg298: memref<17x80xf32>, %arg299: memref<17x80xf32>):
      "air.segment"(%arg296, %arg297, %arg298, %arg299) ({
      ^bb0(%arg300: memref<17x129xf32>, %arg301: memref<129x80xf32>, %arg302: memref<17x80xf32>, %arg303: memref<17x80xf32>):
        %709 = "arith.constant"() <{value = 1 : index}> : () -> index
        %710 = "air.herd"(%709, %709, %arg300, %arg301, %arg302, %arg303) ({
        ^bb0(%arg304: index, %arg305: index, %arg306: index, %arg307: index, %arg308: memref<17x129xf32>, %arg309: memref<129x80xf32>, %arg310: memref<17x80xf32>, %arg311: memref<17x80xf32>):
          %711 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %712 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %713 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %714 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %715 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %716 = "air.wait_all"() : () -> !air.async.token
          %717 = "memref.reinterpret_cast"(%715) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %718 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %719 = "arith.constant"() <{value = 8 : index}> : () -> index
          %720 = "arith.constant"() <{value = 16 : index}> : () -> index
          %721 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%719, %720, %721) ({
          ^bb0(%arg320: index):
            %797 = "arith.constant"() <{value = 0 : index}> : () -> index
            %798 = "arith.constant"() <{value = 32 : index}> : () -> index
            %799 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%797, %798, %799) ({
            ^bb0(%arg321: index):
              %800 = "arith.constant"() <{value = 8 : index}> : () -> index
              %801 = "arith.subi"(%arg320, %800) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%718, %717, %801, %arg321) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %722 = "arith.constant"() <{value = 0 : index}> : () -> index
          %723 = "arith.constant"() <{value = 4 : index}> : () -> index
          %724 = "arith.constant"() <{value = 1 : index}> : () -> index
          %725 = "scf.for"(%722, %723, %724, %716) ({
          ^bb0(%arg315: index, %arg316: !air.async.token):
            %758 = "arith.constant"() <{value = 32 : index}> : () -> index
            %759 = "arith.muli"(%arg315, %758) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %760 = "arith.constant"() <{value = 32 : index}> : () -> index
            %761 = "arith.muli"(%arg315, %760) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %762 = "arith.constant"() <{value = 32 : index}> : () -> index
            %763 = "arith.muli"(%arg315, %762) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %764 = "memref.reinterpret_cast"(%712) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %765 = "arith.constant"() <{value = 0 : index}> : () -> index
            %766 = "arith.addi"(%765, %761) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %767 = "air.dma_memcpy_nd"(%arg316, %764, %arg308, %766) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 24 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "A", orbit.target_copies = array<i64: 81>, orbit.transfer = "host_to_l1", orbit.transfer_event = 51 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %768 = "memref.reinterpret_cast"(%714) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %769 = "arith.constant"() <{value = 0 : index}> : () -> index
            %770 = "arith.addi"(%769, %763) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %771 = "air.dma_memcpy_nd"(%arg316, %768, %arg309, %770) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 24 : i64, orbit.source_copies = array<i64: 15>, orbit.storage = "B", orbit.target_copies = array<i64: 82>, orbit.transfer = "host_to_l1", orbit.transfer_event = 52 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%767, %771) {orbit.computation_event = 54 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 81, 82, 83>, orbit.task = "gemm", orbit.write_copies = array<i64: 84>} : (!air.async.token, !air.async.token) -> ()
            %772 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %773 = "arith.constant"() <{value = 8 : index}> : () -> index
            %774 = "arith.constant"() <{value = 16 : index}> : () -> index
            %775 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%773, %774, %775) ({
            ^bb0(%arg317: index):
              %777 = "arith.constant"() <{value = 0 : index}> : () -> index
              %778 = "arith.constant"() <{value = 32 : index}> : () -> index
              %779 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%777, %778, %779) ({
              ^bb0(%arg318: index):
                %780 = "arith.constant"() <{value = 0 : index}> : () -> index
                %781 = "arith.constant"() <{value = 32 : index}> : () -> index
                %782 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%780, %781, %782) ({
                ^bb0(%arg319: index):
                  %783 = "arith.addi"(%arg319, %759) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %784 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %785 = "arith.subi"(%arg317, %784) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %786 = "arith.subi"(%783, %761) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %787 = "memref.load"(%764, %785, %786) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %788 = "arith.subi"(%783, %763) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %789 = "memref.load"(%768, %788, %arg318) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %790 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %791 = "arith.subi"(%arg317, %790) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %792 = "memref.load"(%717, %791, %arg318) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %793 = "arith.mulf"(%787, %789) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %794 = "arith.addf"(%792, %793) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %795 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %796 = "arith.subi"(%arg317, %795) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%794, %717, %796, %arg318) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %776 = "air.wait_all"(%arg316) : (!air.async.token) -> !air.async.token
            "scf.yield"(%776) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %726 = "memref.reinterpret_cast"(%711) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 28 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %727 = "air.dma_memcpy_nd"(%725, %726, %arg308) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 28 : i64, orbit.source_copies = array<i64: 9>, orbit.storage = "A", orbit.target_copies = array<i64: 94>, orbit.transfer = "host_to_l1", orbit.transfer_event = 64 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %728 = "memref.reinterpret_cast"(%713) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 28 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %729 = "air.dma_memcpy_nd"(%725, %728, %arg309) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 28 : i64, orbit.source_copies = array<i64: 27>, orbit.storage = "B", orbit.target_copies = array<i64: 95>, orbit.transfer = "host_to_l1", orbit.transfer_event = 65 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%727, %729) {orbit.computation_event = 66 : i64, orbit.phase = 28 : i64, orbit.phase_dependencies = array<i64: 27>, orbit.read_copies = array<i64: 94, 95, 93>, orbit.task = "gemm", orbit.write_copies = array<i64: 96>} : (!air.async.token, !air.async.token) -> ()
          %730 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %731 = "arith.constant"() <{value = 8 : index}> : () -> index
          %732 = "arith.constant"() <{value = 16 : index}> : () -> index
          %733 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%731, %732, %733) ({
          ^bb0(%arg312: index):
            %737 = "arith.constant"() <{value = 0 : index}> : () -> index
            %738 = "arith.constant"() <{value = 32 : index}> : () -> index
            %739 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%737, %738, %739) ({
            ^bb0(%arg313: index):
              %740 = "arith.constant"() <{value = 128 : index}> : () -> index
              %741 = "arith.constant"() <{value = 129 : index}> : () -> index
              %742 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%740, %741, %742) ({
              ^bb0(%arg314: index):
                %743 = "arith.constant"() <{value = 8 : index}> : () -> index
                %744 = "arith.subi"(%arg312, %743) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %745 = "arith.constant"() <{value = 128 : index}> : () -> index
                %746 = "arith.subi"(%arg314, %745) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %747 = "memref.load"(%726, %744, %746) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %748 = "arith.constant"() <{value = 128 : index}> : () -> index
                %749 = "arith.subi"(%arg314, %748) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %750 = "memref.load"(%728, %749, %arg313) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %751 = "arith.constant"() <{value = 8 : index}> : () -> index
                %752 = "arith.subi"(%arg312, %751) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %753 = "memref.load"(%717, %752, %arg313) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %754 = "arith.mulf"(%747, %750) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %755 = "arith.addf"(%753, %754) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %756 = "arith.constant"() <{value = 8 : index}> : () -> index
                %757 = "arith.subi"(%arg312, %756) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%755, %717, %757, %arg313) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %734 = "air.wait_all"(%725) : (!air.async.token) -> !air.async.token
          %735 = "air.dma_memcpy_nd"(%734, %arg311, %717) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 28 : i64, orbit.retained_begin = 24 : i64, orbit.retained_end = 29 : i64, orbit.source_copies = array<i64: 96>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 97>, orbit.transfer = "l1_to_host", orbit.transfer_event = 67 : i64, static_dst_offsets = array<i64: 8, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %736 = "air.wait_all"(%735) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%736) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_24"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%710) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_24"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_24"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg262: index, %arg263: index, %arg264: index, %arg265: index, %arg266: memref<17x129xf32>, %arg267: memref<129x80xf32>, %arg268: memref<17x80xf32>, %arg269: memref<17x80xf32>):
      "air.segment"(%arg266, %arg267, %arg268, %arg269) ({
      ^bb0(%arg270: memref<17x129xf32>, %arg271: memref<129x80xf32>, %arg272: memref<17x80xf32>, %arg273: memref<17x80xf32>):
        %602 = "arith.constant"() <{value = 1 : index}> : () -> index
        %603 = "air.herd"(%602, %602, %arg270, %arg271, %arg272, %arg273) ({
        ^bb0(%arg274: index, %arg275: index, %arg276: index, %arg277: index, %arg278: memref<17x129xf32>, %arg279: memref<129x80xf32>, %arg280: memref<17x80xf32>, %arg281: memref<17x80xf32>):
          %604 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %605 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %606 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %607 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %608 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %609 = "air.wait_all"() : () -> !air.async.token
          %610 = "memref.reinterpret_cast"(%608) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 29 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %611 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %612 = "arith.constant"() <{value = 8 : index}> : () -> index
          %613 = "arith.constant"() <{value = 16 : index}> : () -> index
          %614 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%612, %613, %614) ({
          ^bb0(%arg290: index):
            %702 = "arith.constant"() <{value = 32 : index}> : () -> index
            %703 = "arith.constant"() <{value = 64 : index}> : () -> index
            %704 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%702, %703, %704) ({
            ^bb0(%arg291: index):
              %705 = "arith.constant"() <{value = 8 : index}> : () -> index
              %706 = "arith.subi"(%arg290, %705) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %707 = "arith.constant"() <{value = 32 : index}> : () -> index
              %708 = "arith.subi"(%arg291, %707) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%611, %610, %706, %708) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %615 = "arith.constant"() <{value = 0 : index}> : () -> index
          %616 = "arith.constant"() <{value = 4 : index}> : () -> index
          %617 = "arith.constant"() <{value = 1 : index}> : () -> index
          %618 = "scf.for"(%615, %616, %617, %609) ({
          ^bb0(%arg285: index, %arg286: !air.async.token):
            %657 = "arith.constant"() <{value = 32 : index}> : () -> index
            %658 = "arith.muli"(%arg285, %657) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %659 = "arith.constant"() <{value = 32 : index}> : () -> index
            %660 = "arith.muli"(%arg285, %659) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %661 = "arith.constant"() <{value = 32 : index}> : () -> index
            %662 = "arith.muli"(%arg285, %661) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %663 = "memref.reinterpret_cast"(%605) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 29 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %664 = "arith.constant"() <{value = 0 : index}> : () -> index
            %665 = "arith.addi"(%664, %660) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %666 = "air.dma_memcpy_nd"(%arg286, %663, %arg278, %665) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 29 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "A", orbit.target_copies = array<i64: 98>, orbit.transfer = "host_to_l1", orbit.transfer_event = 68 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %667 = "memref.reinterpret_cast"(%607) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 29 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %668 = "arith.constant"() <{value = 0 : index}> : () -> index
            %669 = "arith.addi"(%668, %662) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %670 = "air.dma_memcpy_nd"(%arg286, %667, %arg279, %669) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 29 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 99>, orbit.transfer = "host_to_l1", orbit.transfer_event = 69 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%666, %670) {orbit.computation_event = 71 : i64, orbit.phase = 29 : i64, orbit.phase_dependencies = array<i64: 28>, orbit.read_copies = array<i64: 98, 99, 100>, orbit.task = "gemm", orbit.write_copies = array<i64: 101>} : (!air.async.token, !air.async.token) -> ()
            %671 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %672 = "arith.constant"() <{value = 8 : index}> : () -> index
            %673 = "arith.constant"() <{value = 16 : index}> : () -> index
            %674 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%672, %673, %674) ({
            ^bb0(%arg287: index):
              %676 = "arith.constant"() <{value = 32 : index}> : () -> index
              %677 = "arith.constant"() <{value = 64 : index}> : () -> index
              %678 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%676, %677, %678) ({
              ^bb0(%arg288: index):
                %679 = "arith.constant"() <{value = 0 : index}> : () -> index
                %680 = "arith.constant"() <{value = 32 : index}> : () -> index
                %681 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%679, %680, %681) ({
                ^bb0(%arg289: index):
                  %682 = "arith.addi"(%arg289, %658) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %683 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %684 = "arith.subi"(%arg287, %683) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %685 = "arith.subi"(%682, %660) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %686 = "memref.load"(%663, %684, %685) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %687 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %688 = "arith.subi"(%arg288, %687) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %689 = "arith.subi"(%682, %662) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %690 = "memref.load"(%667, %689, %688) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %691 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %692 = "arith.subi"(%arg287, %691) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %693 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %694 = "arith.subi"(%arg288, %693) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %695 = "memref.load"(%610, %692, %694) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %696 = "arith.mulf"(%686, %690) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %697 = "arith.addf"(%695, %696) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %698 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %699 = "arith.subi"(%arg287, %698) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %700 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %701 = "arith.subi"(%arg288, %700) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%697, %610, %699, %701) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %675 = "air.wait_all"(%arg286) : (!air.async.token) -> !air.async.token
            "scf.yield"(%675) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %619 = "memref.reinterpret_cast"(%604) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 33 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %620 = "air.dma_memcpy_nd"(%618, %619, %arg278) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 33 : i64, orbit.source_copies = array<i64: 9>, orbit.storage = "A", orbit.target_copies = array<i64: 111>, orbit.transfer = "host_to_l1", orbit.transfer_event = 81 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %621 = "memref.reinterpret_cast"(%606) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 33 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %622 = "air.dma_memcpy_nd"(%618, %621, %arg279) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 33 : i64, orbit.source_copies = array<i64: 28>, orbit.storage = "B", orbit.target_copies = array<i64: 112>, orbit.transfer = "host_to_l1", orbit.transfer_event = 82 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%620, %622) {orbit.computation_event = 83 : i64, orbit.phase = 33 : i64, orbit.phase_dependencies = array<i64: 32>, orbit.read_copies = array<i64: 111, 112, 110>, orbit.task = "gemm", orbit.write_copies = array<i64: 113>} : (!air.async.token, !air.async.token) -> ()
          %623 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %624 = "arith.constant"() <{value = 8 : index}> : () -> index
          %625 = "arith.constant"() <{value = 16 : index}> : () -> index
          %626 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%624, %625, %626) ({
          ^bb0(%arg282: index):
            %630 = "arith.constant"() <{value = 32 : index}> : () -> index
            %631 = "arith.constant"() <{value = 64 : index}> : () -> index
            %632 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%630, %631, %632) ({
            ^bb0(%arg283: index):
              %633 = "arith.constant"() <{value = 128 : index}> : () -> index
              %634 = "arith.constant"() <{value = 129 : index}> : () -> index
              %635 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%633, %634, %635) ({
              ^bb0(%arg284: index):
                %636 = "arith.constant"() <{value = 8 : index}> : () -> index
                %637 = "arith.subi"(%arg282, %636) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %638 = "arith.constant"() <{value = 128 : index}> : () -> index
                %639 = "arith.subi"(%arg284, %638) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %640 = "memref.load"(%619, %637, %639) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %641 = "arith.constant"() <{value = 128 : index}> : () -> index
                %642 = "arith.subi"(%arg284, %641) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %643 = "arith.constant"() <{value = 32 : index}> : () -> index
                %644 = "arith.subi"(%arg283, %643) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %645 = "memref.load"(%621, %642, %644) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %646 = "arith.constant"() <{value = 8 : index}> : () -> index
                %647 = "arith.subi"(%arg282, %646) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %648 = "arith.constant"() <{value = 32 : index}> : () -> index
                %649 = "arith.subi"(%arg283, %648) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %650 = "memref.load"(%610, %647, %649) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %651 = "arith.mulf"(%640, %645) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %652 = "arith.addf"(%650, %651) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %653 = "arith.constant"() <{value = 8 : index}> : () -> index
                %654 = "arith.subi"(%arg282, %653) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %655 = "arith.constant"() <{value = 32 : index}> : () -> index
                %656 = "arith.subi"(%arg283, %655) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%652, %610, %654, %656) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %627 = "air.wait_all"(%618) : (!air.async.token) -> !air.async.token
          %628 = "air.dma_memcpy_nd"(%627, %arg281, %610) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 33 : i64, orbit.retained_begin = 29 : i64, orbit.retained_end = 34 : i64, orbit.source_copies = array<i64: 113>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 114>, orbit.transfer = "l1_to_host", orbit.transfer_event = 84 : i64, static_dst_offsets = array<i64: 8, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %629 = "air.wait_all"(%628) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%629) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_29"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%603) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_29"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_29"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg232: index, %arg233: index, %arg234: index, %arg235: index, %arg236: memref<17x129xf32>, %arg237: memref<129x80xf32>, %arg238: memref<17x80xf32>, %arg239: memref<17x80xf32>):
      "air.segment"(%arg236, %arg237, %arg238, %arg239) ({
      ^bb0(%arg240: memref<17x129xf32>, %arg241: memref<129x80xf32>, %arg242: memref<17x80xf32>, %arg243: memref<17x80xf32>):
        %495 = "arith.constant"() <{value = 1 : index}> : () -> index
        %496 = "air.herd"(%495, %495, %arg240, %arg241, %arg242, %arg243) ({
        ^bb0(%arg244: index, %arg245: index, %arg246: index, %arg247: index, %arg248: memref<17x129xf32>, %arg249: memref<129x80xf32>, %arg250: memref<17x80xf32>, %arg251: memref<17x80xf32>):
          %497 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : () -> memref<8xf32, 2 : i32>
          %498 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %499 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : () -> memref<16xf32, 2 : i32>
          %500 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : () -> memref<512xf32, 2 : i32>
          %501 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %502 = "air.wait_all"() : () -> !air.async.token
          %503 = "memref.reinterpret_cast"(%501) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 34 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %504 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %505 = "arith.constant"() <{value = 8 : index}> : () -> index
          %506 = "arith.constant"() <{value = 16 : index}> : () -> index
          %507 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%505, %506, %507) ({
          ^bb0(%arg260: index):
            %595 = "arith.constant"() <{value = 64 : index}> : () -> index
            %596 = "arith.constant"() <{value = 80 : index}> : () -> index
            %597 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%595, %596, %597) ({
            ^bb0(%arg261: index):
              %598 = "arith.constant"() <{value = 8 : index}> : () -> index
              %599 = "arith.subi"(%arg260, %598) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %600 = "arith.constant"() <{value = 64 : index}> : () -> index
              %601 = "arith.subi"(%arg261, %600) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%504, %503, %599, %601) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %508 = "arith.constant"() <{value = 0 : index}> : () -> index
          %509 = "arith.constant"() <{value = 4 : index}> : () -> index
          %510 = "arith.constant"() <{value = 1 : index}> : () -> index
          %511 = "scf.for"(%508, %509, %510, %502) ({
          ^bb0(%arg255: index, %arg256: !air.async.token):
            %550 = "arith.constant"() <{value = 32 : index}> : () -> index
            %551 = "arith.muli"(%arg255, %550) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %552 = "arith.constant"() <{value = 32 : index}> : () -> index
            %553 = "arith.muli"(%arg255, %552) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %554 = "arith.constant"() <{value = 32 : index}> : () -> index
            %555 = "arith.muli"(%arg255, %554) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %556 = "memref.reinterpret_cast"(%498) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 34 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %557 = "arith.constant"() <{value = 0 : index}> : () -> index
            %558 = "arith.addi"(%557, %553) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %559 = "air.dma_memcpy_nd"(%arg256, %556, %arg248, %558) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 34 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "A", orbit.target_copies = array<i64: 115>, orbit.transfer = "host_to_l1", orbit.transfer_event = 85 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %560 = "memref.reinterpret_cast"(%500) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 34 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %561 = "arith.constant"() <{value = 0 : index}> : () -> index
            %562 = "arith.addi"(%561, %555) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %563 = "air.dma_memcpy_nd"(%arg256, %560, %arg249, %562) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 34 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "B", orbit.target_copies = array<i64: 116>, orbit.transfer = "host_to_l1", orbit.transfer_event = 86 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%559, %563) {orbit.computation_event = 88 : i64, orbit.phase = 34 : i64, orbit.phase_dependencies = array<i64: 33>, orbit.read_copies = array<i64: 115, 116, 117>, orbit.task = "gemm", orbit.write_copies = array<i64: 118>} : (!air.async.token, !air.async.token) -> ()
            %564 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %565 = "arith.constant"() <{value = 8 : index}> : () -> index
            %566 = "arith.constant"() <{value = 16 : index}> : () -> index
            %567 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%565, %566, %567) ({
            ^bb0(%arg257: index):
              %569 = "arith.constant"() <{value = 64 : index}> : () -> index
              %570 = "arith.constant"() <{value = 80 : index}> : () -> index
              %571 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%569, %570, %571) ({
              ^bb0(%arg258: index):
                %572 = "arith.constant"() <{value = 0 : index}> : () -> index
                %573 = "arith.constant"() <{value = 32 : index}> : () -> index
                %574 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%572, %573, %574) ({
                ^bb0(%arg259: index):
                  %575 = "arith.addi"(%arg259, %551) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %576 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %577 = "arith.subi"(%arg257, %576) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %578 = "arith.subi"(%575, %553) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %579 = "memref.load"(%556, %577, %578) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %580 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %581 = "arith.subi"(%arg258, %580) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %582 = "arith.subi"(%575, %555) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %583 = "memref.load"(%560, %582, %581) <{nontemporal = false}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %584 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %585 = "arith.subi"(%arg257, %584) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %586 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %587 = "arith.subi"(%arg258, %586) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %588 = "memref.load"(%503, %585, %587) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %589 = "arith.mulf"(%579, %583) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %590 = "arith.addf"(%588, %589) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %591 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %592 = "arith.subi"(%arg257, %591) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %593 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %594 = "arith.subi"(%arg258, %593) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%590, %503, %592, %594) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %568 = "air.wait_all"(%arg256) : (!air.async.token) -> !air.async.token
            "scf.yield"(%568) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %512 = "memref.reinterpret_cast"(%497) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 38 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %513 = "air.dma_memcpy_nd"(%511, %512, %arg248) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 38 : i64, orbit.source_copies = array<i64: 9>, orbit.storage = "A", orbit.target_copies = array<i64: 128>, orbit.transfer = "host_to_l1", orbit.transfer_event = 98 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %514 = "memref.reinterpret_cast"(%499) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 38 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %515 = "air.dma_memcpy_nd"(%511, %514, %arg249) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 38 : i64, orbit.source_copies = array<i64: 29>, orbit.storage = "B", orbit.target_copies = array<i64: 129>, orbit.transfer = "host_to_l1", orbit.transfer_event = 99 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%513, %515) {orbit.computation_event = 100 : i64, orbit.phase = 38 : i64, orbit.phase_dependencies = array<i64: 37>, orbit.read_copies = array<i64: 128, 129, 127>, orbit.task = "gemm", orbit.write_copies = array<i64: 130>} : (!air.async.token, !air.async.token) -> ()
          %516 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %517 = "arith.constant"() <{value = 8 : index}> : () -> index
          %518 = "arith.constant"() <{value = 16 : index}> : () -> index
          %519 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%517, %518, %519) ({
          ^bb0(%arg252: index):
            %523 = "arith.constant"() <{value = 64 : index}> : () -> index
            %524 = "arith.constant"() <{value = 80 : index}> : () -> index
            %525 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%523, %524, %525) ({
            ^bb0(%arg253: index):
              %526 = "arith.constant"() <{value = 128 : index}> : () -> index
              %527 = "arith.constant"() <{value = 129 : index}> : () -> index
              %528 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%526, %527, %528) ({
              ^bb0(%arg254: index):
                %529 = "arith.constant"() <{value = 8 : index}> : () -> index
                %530 = "arith.subi"(%arg252, %529) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %531 = "arith.constant"() <{value = 128 : index}> : () -> index
                %532 = "arith.subi"(%arg254, %531) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %533 = "memref.load"(%512, %530, %532) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %534 = "arith.constant"() <{value = 128 : index}> : () -> index
                %535 = "arith.subi"(%arg254, %534) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %536 = "arith.constant"() <{value = 64 : index}> : () -> index
                %537 = "arith.subi"(%arg253, %536) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %538 = "memref.load"(%514, %535, %537) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %539 = "arith.constant"() <{value = 8 : index}> : () -> index
                %540 = "arith.subi"(%arg252, %539) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %541 = "arith.constant"() <{value = 64 : index}> : () -> index
                %542 = "arith.subi"(%arg253, %541) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %543 = "memref.load"(%503, %540, %542) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %544 = "arith.mulf"(%533, %538) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %545 = "arith.addf"(%543, %544) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %546 = "arith.constant"() <{value = 8 : index}> : () -> index
                %547 = "arith.subi"(%arg252, %546) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %548 = "arith.constant"() <{value = 64 : index}> : () -> index
                %549 = "arith.subi"(%arg253, %548) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%545, %503, %547, %549) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %520 = "air.wait_all"(%511) : (!air.async.token) -> !air.async.token
          %521 = "air.dma_memcpy_nd"(%520, %arg251, %503) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 38 : i64, orbit.retained_begin = 34 : i64, orbit.retained_end = 39 : i64, orbit.source_copies = array<i64: 130>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 131>, orbit.transfer = "l1_to_host", orbit.transfer_event = 101 : i64, static_dst_offsets = array<i64: 8, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %522 = "air.wait_all"(%521) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%522) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_34"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%496) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_34"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_34"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg202: index, %arg203: index, %arg204: index, %arg205: index, %arg206: memref<17x129xf32>, %arg207: memref<129x80xf32>, %arg208: memref<17x80xf32>, %arg209: memref<17x80xf32>):
      "air.segment"(%arg206, %arg207, %arg208, %arg209) ({
      ^bb0(%arg210: memref<17x129xf32>, %arg211: memref<129x80xf32>, %arg212: memref<17x80xf32>, %arg213: memref<17x80xf32>):
        %402 = "arith.constant"() <{value = 1 : index}> : () -> index
        %403 = "air.herd"(%402, %402, %arg210, %arg211, %arg212, %arg213) ({
        ^bb0(%arg214: index, %arg215: index, %arg216: index, %arg217: index, %arg218: memref<17x129xf32>, %arg219: memref<129x80xf32>, %arg220: memref<17x80xf32>, %arg221: memref<17x80xf32>):
          %404 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : () -> memref<1xf32, 2 : i32>
          %405 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : () -> memref<32xf32, 2 : i32>
          %406 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : () -> memref<32xf32, 2 : i32>
          %407 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : () -> memref<1024xf32, 2 : i32>
          %408 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<32xf32, 2 : i32>
          %409 = "air.wait_all"() : () -> !air.async.token
          %410 = "memref.reinterpret_cast"(%408) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 39 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %411 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %412 = "arith.constant"() <{value = 16 : index}> : () -> index
          %413 = "arith.constant"() <{value = 17 : index}> : () -> index
          %414 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%412, %413, %414) ({
          ^bb0(%arg230: index):
            %490 = "arith.constant"() <{value = 0 : index}> : () -> index
            %491 = "arith.constant"() <{value = 32 : index}> : () -> index
            %492 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%490, %491, %492) ({
            ^bb0(%arg231: index):
              %493 = "arith.constant"() <{value = 16 : index}> : () -> index
              %494 = "arith.subi"(%arg230, %493) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%411, %410, %494, %arg231) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %415 = "arith.constant"() <{value = 0 : index}> : () -> index
          %416 = "arith.constant"() <{value = 4 : index}> : () -> index
          %417 = "arith.constant"() <{value = 1 : index}> : () -> index
          %418 = "scf.for"(%415, %416, %417, %409) ({
          ^bb0(%arg225: index, %arg226: !air.async.token):
            %451 = "arith.constant"() <{value = 32 : index}> : () -> index
            %452 = "arith.muli"(%arg225, %451) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %453 = "arith.constant"() <{value = 32 : index}> : () -> index
            %454 = "arith.muli"(%arg225, %453) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %455 = "arith.constant"() <{value = 32 : index}> : () -> index
            %456 = "arith.muli"(%arg225, %455) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %457 = "memref.reinterpret_cast"(%405) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 39 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %458 = "arith.constant"() <{value = 0 : index}> : () -> index
            %459 = "arith.addi"(%458, %454) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %460 = "air.dma_memcpy_nd"(%arg226, %457, %arg218, %459) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 39 : i64, orbit.source_copies = array<i64: 10>, orbit.storage = "A", orbit.target_copies = array<i64: 132>, orbit.transfer = "host_to_l1", orbit.transfer_event = 102 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %461 = "memref.reinterpret_cast"(%407) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 39 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %462 = "arith.constant"() <{value = 0 : index}> : () -> index
            %463 = "arith.addi"(%462, %456) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %464 = "air.dma_memcpy_nd"(%arg226, %461, %arg219, %463) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 39 : i64, orbit.source_copies = array<i64: 15>, orbit.storage = "B", orbit.target_copies = array<i64: 133>, orbit.transfer = "host_to_l1", orbit.transfer_event = 103 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%460, %464) {orbit.computation_event = 105 : i64, orbit.phase = 39 : i64, orbit.phase_dependencies = array<i64: 38>, orbit.read_copies = array<i64: 132, 133, 134>, orbit.task = "gemm", orbit.write_copies = array<i64: 135>} : (!air.async.token, !air.async.token) -> ()
            %465 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %466 = "arith.constant"() <{value = 16 : index}> : () -> index
            %467 = "arith.constant"() <{value = 17 : index}> : () -> index
            %468 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%466, %467, %468) ({
            ^bb0(%arg227: index):
              %470 = "arith.constant"() <{value = 0 : index}> : () -> index
              %471 = "arith.constant"() <{value = 32 : index}> : () -> index
              %472 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%470, %471, %472) ({
              ^bb0(%arg228: index):
                %473 = "arith.constant"() <{value = 0 : index}> : () -> index
                %474 = "arith.constant"() <{value = 32 : index}> : () -> index
                %475 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%473, %474, %475) ({
                ^bb0(%arg229: index):
                  %476 = "arith.addi"(%arg229, %452) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %477 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %478 = "arith.subi"(%arg227, %477) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %479 = "arith.subi"(%476, %454) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %480 = "memref.load"(%457, %478, %479) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %481 = "arith.subi"(%476, %456) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %482 = "memref.load"(%461, %481, %arg228) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %483 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %484 = "arith.subi"(%arg227, %483) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %485 = "memref.load"(%410, %484, %arg228) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %486 = "arith.mulf"(%480, %482) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %487 = "arith.addf"(%485, %486) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %488 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %489 = "arith.subi"(%arg227, %488) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%487, %410, %489, %arg228) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %469 = "air.wait_all"(%arg226) : (!air.async.token) -> !air.async.token
            "scf.yield"(%469) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %419 = "memref.reinterpret_cast"(%404) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 43 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %420 = "air.dma_memcpy_nd"(%418, %419, %arg218) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 43 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "A", orbit.target_copies = array<i64: 145>, orbit.transfer = "host_to_l1", orbit.transfer_event = 115 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %421 = "memref.reinterpret_cast"(%406) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 43 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %422 = "air.dma_memcpy_nd"(%418, %421, %arg219) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 43 : i64, orbit.source_copies = array<i64: 27>, orbit.storage = "B", orbit.target_copies = array<i64: 146>, orbit.transfer = "host_to_l1", orbit.transfer_event = 116 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%420, %422) {orbit.computation_event = 117 : i64, orbit.phase = 43 : i64, orbit.phase_dependencies = array<i64: 42>, orbit.read_copies = array<i64: 145, 146, 144>, orbit.task = "gemm", orbit.write_copies = array<i64: 147>} : (!air.async.token, !air.async.token) -> ()
          %423 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %424 = "arith.constant"() <{value = 16 : index}> : () -> index
          %425 = "arith.constant"() <{value = 17 : index}> : () -> index
          %426 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%424, %425, %426) ({
          ^bb0(%arg222: index):
            %430 = "arith.constant"() <{value = 0 : index}> : () -> index
            %431 = "arith.constant"() <{value = 32 : index}> : () -> index
            %432 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%430, %431, %432) ({
            ^bb0(%arg223: index):
              %433 = "arith.constant"() <{value = 128 : index}> : () -> index
              %434 = "arith.constant"() <{value = 129 : index}> : () -> index
              %435 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%433, %434, %435) ({
              ^bb0(%arg224: index):
                %436 = "arith.constant"() <{value = 16 : index}> : () -> index
                %437 = "arith.subi"(%arg222, %436) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %438 = "arith.constant"() <{value = 128 : index}> : () -> index
                %439 = "arith.subi"(%arg224, %438) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %440 = "memref.load"(%419, %437, %439) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %441 = "arith.constant"() <{value = 128 : index}> : () -> index
                %442 = "arith.subi"(%arg224, %441) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %443 = "memref.load"(%421, %442, %arg223) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %444 = "arith.constant"() <{value = 16 : index}> : () -> index
                %445 = "arith.subi"(%arg222, %444) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %446 = "memref.load"(%410, %445, %arg223) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %447 = "arith.mulf"(%440, %443) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %448 = "arith.addf"(%446, %447) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %449 = "arith.constant"() <{value = 16 : index}> : () -> index
                %450 = "arith.subi"(%arg222, %449) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%448, %410, %450, %arg223) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %427 = "air.wait_all"(%418) : (!air.async.token) -> !air.async.token
          %428 = "air.dma_memcpy_nd"(%427, %arg221, %410) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 43 : i64, orbit.retained_begin = 39 : i64, orbit.retained_end = 44 : i64, orbit.source_copies = array<i64: 147>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 148>, orbit.transfer = "l1_to_host", orbit.transfer_event = 118 : i64, static_dst_offsets = array<i64: 16, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %429 = "air.wait_all"(%428) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%429) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_39"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%403) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_39"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_39"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg172: index, %arg173: index, %arg174: index, %arg175: index, %arg176: memref<17x129xf32>, %arg177: memref<129x80xf32>, %arg178: memref<17x80xf32>, %arg179: memref<17x80xf32>):
      "air.segment"(%arg176, %arg177, %arg178, %arg179) ({
      ^bb0(%arg180: memref<17x129xf32>, %arg181: memref<129x80xf32>, %arg182: memref<17x80xf32>, %arg183: memref<17x80xf32>):
        %295 = "arith.constant"() <{value = 1 : index}> : () -> index
        %296 = "air.herd"(%295, %295, %arg180, %arg181, %arg182, %arg183) ({
        ^bb0(%arg184: index, %arg185: index, %arg186: index, %arg187: index, %arg188: memref<17x129xf32>, %arg189: memref<129x80xf32>, %arg190: memref<17x80xf32>, %arg191: memref<17x80xf32>):
          %297 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : () -> memref<1xf32, 2 : i32>
          %298 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : () -> memref<32xf32, 2 : i32>
          %299 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : () -> memref<32xf32, 2 : i32>
          %300 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : () -> memref<1024xf32, 2 : i32>
          %301 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<32xf32, 2 : i32>
          %302 = "air.wait_all"() : () -> !air.async.token
          %303 = "memref.reinterpret_cast"(%301) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 44 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %304 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %305 = "arith.constant"() <{value = 16 : index}> : () -> index
          %306 = "arith.constant"() <{value = 17 : index}> : () -> index
          %307 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%305, %306, %307) ({
          ^bb0(%arg200: index):
            %395 = "arith.constant"() <{value = 32 : index}> : () -> index
            %396 = "arith.constant"() <{value = 64 : index}> : () -> index
            %397 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%395, %396, %397) ({
            ^bb0(%arg201: index):
              %398 = "arith.constant"() <{value = 16 : index}> : () -> index
              %399 = "arith.subi"(%arg200, %398) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %400 = "arith.constant"() <{value = 32 : index}> : () -> index
              %401 = "arith.subi"(%arg201, %400) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%304, %303, %399, %401) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %308 = "arith.constant"() <{value = 0 : index}> : () -> index
          %309 = "arith.constant"() <{value = 4 : index}> : () -> index
          %310 = "arith.constant"() <{value = 1 : index}> : () -> index
          %311 = "scf.for"(%308, %309, %310, %302) ({
          ^bb0(%arg195: index, %arg196: !air.async.token):
            %350 = "arith.constant"() <{value = 32 : index}> : () -> index
            %351 = "arith.muli"(%arg195, %350) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %352 = "arith.constant"() <{value = 32 : index}> : () -> index
            %353 = "arith.muli"(%arg195, %352) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %354 = "arith.constant"() <{value = 32 : index}> : () -> index
            %355 = "arith.muli"(%arg195, %354) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %356 = "memref.reinterpret_cast"(%298) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 44 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %357 = "arith.constant"() <{value = 0 : index}> : () -> index
            %358 = "arith.addi"(%357, %353) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %359 = "air.dma_memcpy_nd"(%arg196, %356, %arg188, %358) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 44 : i64, orbit.source_copies = array<i64: 10>, orbit.storage = "A", orbit.target_copies = array<i64: 149>, orbit.transfer = "host_to_l1", orbit.transfer_event = 119 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %360 = "memref.reinterpret_cast"(%300) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 44 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %361 = "arith.constant"() <{value = 0 : index}> : () -> index
            %362 = "arith.addi"(%361, %355) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %363 = "air.dma_memcpy_nd"(%arg196, %360, %arg189, %362) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 44 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 150>, orbit.transfer = "host_to_l1", orbit.transfer_event = 120 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%359, %363) {orbit.computation_event = 122 : i64, orbit.phase = 44 : i64, orbit.phase_dependencies = array<i64: 43>, orbit.read_copies = array<i64: 149, 150, 151>, orbit.task = "gemm", orbit.write_copies = array<i64: 152>} : (!air.async.token, !air.async.token) -> ()
            %364 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %365 = "arith.constant"() <{value = 16 : index}> : () -> index
            %366 = "arith.constant"() <{value = 17 : index}> : () -> index
            %367 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%365, %366, %367) ({
            ^bb0(%arg197: index):
              %369 = "arith.constant"() <{value = 32 : index}> : () -> index
              %370 = "arith.constant"() <{value = 64 : index}> : () -> index
              %371 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%369, %370, %371) ({
              ^bb0(%arg198: index):
                %372 = "arith.constant"() <{value = 0 : index}> : () -> index
                %373 = "arith.constant"() <{value = 32 : index}> : () -> index
                %374 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%372, %373, %374) ({
                ^bb0(%arg199: index):
                  %375 = "arith.addi"(%arg199, %351) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %376 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %377 = "arith.subi"(%arg197, %376) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %378 = "arith.subi"(%375, %353) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %379 = "memref.load"(%356, %377, %378) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %380 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %381 = "arith.subi"(%arg198, %380) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %382 = "arith.subi"(%375, %355) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %383 = "memref.load"(%360, %382, %381) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %384 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %385 = "arith.subi"(%arg197, %384) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %386 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %387 = "arith.subi"(%arg198, %386) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %388 = "memref.load"(%303, %385, %387) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %389 = "arith.mulf"(%379, %383) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %390 = "arith.addf"(%388, %389) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %391 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %392 = "arith.subi"(%arg197, %391) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %393 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %394 = "arith.subi"(%arg198, %393) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%390, %303, %392, %394) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %368 = "air.wait_all"(%arg196) : (!air.async.token) -> !air.async.token
            "scf.yield"(%368) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %312 = "memref.reinterpret_cast"(%297) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 48 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %313 = "air.dma_memcpy_nd"(%311, %312, %arg188) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 48 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "A", orbit.target_copies = array<i64: 162>, orbit.transfer = "host_to_l1", orbit.transfer_event = 132 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %314 = "memref.reinterpret_cast"(%299) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 48 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %315 = "air.dma_memcpy_nd"(%311, %314, %arg189) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 48 : i64, orbit.source_copies = array<i64: 28>, orbit.storage = "B", orbit.target_copies = array<i64: 163>, orbit.transfer = "host_to_l1", orbit.transfer_event = 133 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%313, %315) {orbit.computation_event = 134 : i64, orbit.phase = 48 : i64, orbit.phase_dependencies = array<i64: 47>, orbit.read_copies = array<i64: 162, 163, 161>, orbit.task = "gemm", orbit.write_copies = array<i64: 164>} : (!air.async.token, !air.async.token) -> ()
          %316 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %317 = "arith.constant"() <{value = 16 : index}> : () -> index
          %318 = "arith.constant"() <{value = 17 : index}> : () -> index
          %319 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%317, %318, %319) ({
          ^bb0(%arg192: index):
            %323 = "arith.constant"() <{value = 32 : index}> : () -> index
            %324 = "arith.constant"() <{value = 64 : index}> : () -> index
            %325 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%323, %324, %325) ({
            ^bb0(%arg193: index):
              %326 = "arith.constant"() <{value = 128 : index}> : () -> index
              %327 = "arith.constant"() <{value = 129 : index}> : () -> index
              %328 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%326, %327, %328) ({
              ^bb0(%arg194: index):
                %329 = "arith.constant"() <{value = 16 : index}> : () -> index
                %330 = "arith.subi"(%arg192, %329) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %331 = "arith.constant"() <{value = 128 : index}> : () -> index
                %332 = "arith.subi"(%arg194, %331) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %333 = "memref.load"(%312, %330, %332) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %334 = "arith.constant"() <{value = 128 : index}> : () -> index
                %335 = "arith.subi"(%arg194, %334) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %336 = "arith.constant"() <{value = 32 : index}> : () -> index
                %337 = "arith.subi"(%arg193, %336) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %338 = "memref.load"(%314, %335, %337) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %339 = "arith.constant"() <{value = 16 : index}> : () -> index
                %340 = "arith.subi"(%arg192, %339) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %341 = "arith.constant"() <{value = 32 : index}> : () -> index
                %342 = "arith.subi"(%arg193, %341) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %343 = "memref.load"(%303, %340, %342) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %344 = "arith.mulf"(%333, %338) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %345 = "arith.addf"(%343, %344) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %346 = "arith.constant"() <{value = 16 : index}> : () -> index
                %347 = "arith.subi"(%arg192, %346) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %348 = "arith.constant"() <{value = 32 : index}> : () -> index
                %349 = "arith.subi"(%arg193, %348) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%345, %303, %347, %349) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %320 = "air.wait_all"(%311) : (!air.async.token) -> !air.async.token
          %321 = "air.dma_memcpy_nd"(%320, %arg191, %303) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 48 : i64, orbit.retained_begin = 44 : i64, orbit.retained_end = 49 : i64, orbit.source_copies = array<i64: 164>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 165>, orbit.transfer = "l1_to_host", orbit.transfer_event = 135 : i64, static_dst_offsets = array<i64: 16, 32>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %322 = "air.wait_all"(%321) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%322) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_44"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%296) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_44"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_44"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg142: index, %arg143: index, %arg144: index, %arg145: index, %arg146: memref<17x129xf32>, %arg147: memref<129x80xf32>, %arg148: memref<17x80xf32>, %arg149: memref<17x80xf32>):
      "air.segment"(%arg146, %arg147, %arg148, %arg149) ({
      ^bb0(%arg150: memref<17x129xf32>, %arg151: memref<129x80xf32>, %arg152: memref<17x80xf32>, %arg153: memref<17x80xf32>):
        %188 = "arith.constant"() <{value = 1 : index}> : () -> index
        %189 = "air.herd"(%188, %188, %arg150, %arg151, %arg152, %arg153) ({
        ^bb0(%arg154: index, %arg155: index, %arg156: index, %arg157: index, %arg158: memref<17x129xf32>, %arg159: memref<129x80xf32>, %arg160: memref<17x80xf32>, %arg161: memref<17x80xf32>):
          %190 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.16.1"} : () -> memref<1xf32, 2 : i32>
          %191 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.16.32"} : () -> memref<32xf32, 2 : i32>
          %192 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.1.16.1"} : () -> memref<16xf32, 2 : i32>
          %193 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.1.16.32"} : () -> memref<512xf32, 2 : i32>
          %194 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<16xf32, 2 : i32>
          %195 = "air.wait_all"() : () -> !air.async.token
          %196 = "memref.reinterpret_cast"(%194) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 49 : i64, orbit.storage = "intermediate"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %197 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %198 = "arith.constant"() <{value = 16 : index}> : () -> index
          %199 = "arith.constant"() <{value = 17 : index}> : () -> index
          %200 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%198, %199, %200) ({
          ^bb0(%arg170: index):
            %288 = "arith.constant"() <{value = 64 : index}> : () -> index
            %289 = "arith.constant"() <{value = 80 : index}> : () -> index
            %290 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%288, %289, %290) ({
            ^bb0(%arg171: index):
              %291 = "arith.constant"() <{value = 16 : index}> : () -> index
              %292 = "arith.subi"(%arg170, %291) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %293 = "arith.constant"() <{value = 64 : index}> : () -> index
              %294 = "arith.subi"(%arg171, %293) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%197, %196, %292, %294) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %201 = "arith.constant"() <{value = 0 : index}> : () -> index
          %202 = "arith.constant"() <{value = 4 : index}> : () -> index
          %203 = "arith.constant"() <{value = 1 : index}> : () -> index
          %204 = "scf.for"(%201, %202, %203, %195) ({
          ^bb0(%arg165: index, %arg166: !air.async.token):
            %243 = "arith.constant"() <{value = 32 : index}> : () -> index
            %244 = "arith.muli"(%arg165, %243) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %245 = "arith.constant"() <{value = 32 : index}> : () -> index
            %246 = "arith.muli"(%arg165, %245) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %247 = "arith.constant"() <{value = 32 : index}> : () -> index
            %248 = "arith.muli"(%arg165, %247) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %249 = "memref.reinterpret_cast"(%191) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 49 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %250 = "arith.constant"() <{value = 0 : index}> : () -> index
            %251 = "arith.addi"(%250, %246) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %252 = "air.dma_memcpy_nd"(%arg166, %249, %arg158, %251) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 49 : i64, orbit.source_copies = array<i64: 10>, orbit.storage = "A", orbit.target_copies = array<i64: 166>, orbit.transfer = "host_to_l1", orbit.transfer_event = 136 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %253 = "memref.reinterpret_cast"(%193) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 49 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %254 = "arith.constant"() <{value = 0 : index}> : () -> index
            %255 = "arith.addi"(%254, %248) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %256 = "air.dma_memcpy_nd"(%arg166, %253, %arg159, %255) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 49 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "B", orbit.target_copies = array<i64: 167>, orbit.transfer = "host_to_l1", orbit.transfer_event = 137 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%252, %256) {orbit.computation_event = 139 : i64, orbit.phase = 49 : i64, orbit.phase_dependencies = array<i64: 48>, orbit.read_copies = array<i64: 166, 167, 168>, orbit.task = "gemm", orbit.write_copies = array<i64: 169>} : (!air.async.token, !air.async.token) -> ()
            %257 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %258 = "arith.constant"() <{value = 16 : index}> : () -> index
            %259 = "arith.constant"() <{value = 17 : index}> : () -> index
            %260 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%258, %259, %260) ({
            ^bb0(%arg167: index):
              %262 = "arith.constant"() <{value = 64 : index}> : () -> index
              %263 = "arith.constant"() <{value = 80 : index}> : () -> index
              %264 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%262, %263, %264) ({
              ^bb0(%arg168: index):
                %265 = "arith.constant"() <{value = 0 : index}> : () -> index
                %266 = "arith.constant"() <{value = 32 : index}> : () -> index
                %267 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%265, %266, %267) ({
                ^bb0(%arg169: index):
                  %268 = "arith.addi"(%arg169, %244) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %269 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %270 = "arith.subi"(%arg167, %269) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %271 = "arith.subi"(%268, %246) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %272 = "memref.load"(%249, %270, %271) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %273 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %274 = "arith.subi"(%arg168, %273) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %275 = "arith.subi"(%268, %248) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %276 = "memref.load"(%253, %275, %274) <{nontemporal = false}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %277 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %278 = "arith.subi"(%arg167, %277) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %279 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %280 = "arith.subi"(%arg168, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %281 = "memref.load"(%196, %278, %280) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %282 = "arith.mulf"(%272, %276) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %283 = "arith.addf"(%281, %282) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %284 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %285 = "arith.subi"(%arg167, %284) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %286 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %287 = "arith.subi"(%arg168, %286) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%283, %196, %285, %287) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %261 = "air.wait_all"(%arg166) : (!air.async.token) -> !air.async.token
            "scf.yield"(%261) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %205 = "memref.reinterpret_cast"(%190) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 53 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %206 = "air.dma_memcpy_nd"(%204, %205, %arg158) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 53 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "A", orbit.target_copies = array<i64: 179>, orbit.transfer = "host_to_l1", orbit.transfer_event = 149 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %207 = "memref.reinterpret_cast"(%192) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 53 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %208 = "air.dma_memcpy_nd"(%204, %207, %arg159) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 53 : i64, orbit.source_copies = array<i64: 29>, orbit.storage = "B", orbit.target_copies = array<i64: 180>, orbit.transfer = "host_to_l1", orbit.transfer_event = 150 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%206, %208) {orbit.computation_event = 151 : i64, orbit.phase = 53 : i64, orbit.phase_dependencies = array<i64: 52>, orbit.read_copies = array<i64: 179, 180, 178>, orbit.task = "gemm", orbit.write_copies = array<i64: 181>} : (!air.async.token, !air.async.token) -> ()
          %209 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %210 = "arith.constant"() <{value = 16 : index}> : () -> index
          %211 = "arith.constant"() <{value = 17 : index}> : () -> index
          %212 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%210, %211, %212) ({
          ^bb0(%arg162: index):
            %216 = "arith.constant"() <{value = 64 : index}> : () -> index
            %217 = "arith.constant"() <{value = 80 : index}> : () -> index
            %218 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%216, %217, %218) ({
            ^bb0(%arg163: index):
              %219 = "arith.constant"() <{value = 128 : index}> : () -> index
              %220 = "arith.constant"() <{value = 129 : index}> : () -> index
              %221 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%219, %220, %221) ({
              ^bb0(%arg164: index):
                %222 = "arith.constant"() <{value = 16 : index}> : () -> index
                %223 = "arith.subi"(%arg162, %222) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %224 = "arith.constant"() <{value = 128 : index}> : () -> index
                %225 = "arith.subi"(%arg164, %224) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %226 = "memref.load"(%205, %223, %225) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %227 = "arith.constant"() <{value = 128 : index}> : () -> index
                %228 = "arith.subi"(%arg164, %227) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %229 = "arith.constant"() <{value = 64 : index}> : () -> index
                %230 = "arith.subi"(%arg163, %229) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %231 = "memref.load"(%207, %228, %230) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %232 = "arith.constant"() <{value = 16 : index}> : () -> index
                %233 = "arith.subi"(%arg162, %232) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %234 = "arith.constant"() <{value = 64 : index}> : () -> index
                %235 = "arith.subi"(%arg163, %234) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %236 = "memref.load"(%196, %233, %235) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %237 = "arith.mulf"(%226, %231) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %238 = "arith.addf"(%236, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %239 = "arith.constant"() <{value = 16 : index}> : () -> index
                %240 = "arith.subi"(%arg162, %239) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %241 = "arith.constant"() <{value = 64 : index}> : () -> index
                %242 = "arith.subi"(%arg163, %241) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%238, %196, %240, %242) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %213 = "air.wait_all"(%204) : (!air.async.token) -> !air.async.token
          %214 = "air.dma_memcpy_nd"(%213, %arg161, %196) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 53 : i64, orbit.retained_begin = 49 : i64, orbit.retained_end = 54 : i64, orbit.source_copies = array<i64: 181>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 182>, orbit.transfer = "l1_to_host", orbit.transfer_event = 152 : i64, static_dst_offsets = array<i64: 16, 64>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %215 = "air.wait_all"(%214) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%215) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_49"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%189) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_49"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_49"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg118: index, %arg119: index, %arg120: index, %arg121: index, %arg122: memref<17x129xf32>, %arg123: memref<129x80xf32>, %arg124: memref<17x80xf32>, %arg125: memref<17x80xf32>):
      "air.segment"(%arg122, %arg123, %arg124, %arg125) ({
      ^bb0(%arg126: memref<17x129xf32>, %arg127: memref<129x80xf32>, %arg128: memref<17x80xf32>, %arg129: memref<17x80xf32>):
        %153 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%153, %153, %arg126, %arg127, %arg128, %arg129) ({
        ^bb0(%arg130: index, %arg131: index, %arg132: index, %arg133: index, %arg134: memref<17x129xf32>, %arg135: memref<129x80xf32>, %arg136: memref<17x80xf32>, %arg137: memref<17x80xf32>):
          %154 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<256xf32, 2 : i32>
          %155 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : () -> memref<256xf32, 2 : i32>
          %156 = "air.wait_all"() : () -> !air.async.token
          %157 = "arith.constant"() <{value = 0 : index}> : () -> index
          %158 = "arith.constant"() <{value = 2 : index}> : () -> index
          %159 = "arith.constant"() <{value = 1 : index}> : () -> index
          %160 = "scf.for"(%157, %158, %159, %156) ({
          ^bb0(%arg138: index, %arg139: !air.async.token):
            %161 = "arith.constant"() <{value = 32 : index}> : () -> index
            %162 = "arith.muli"(%arg138, %161) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %163 = "arith.constant"() <{value = 32 : index}> : () -> index
            %164 = "arith.muli"(%arg138, %163) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %165 = "arith.constant"() <{value = 32 : index}> : () -> index
            %166 = "arith.muli"(%arg138, %165) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %167 = "memref.reinterpret_cast"(%154) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 54 : i64, orbit.storage = "Y"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %168 = "memref.reinterpret_cast"(%155) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 54 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %169 = "arith.constant"() <{value = 0 : index}> : () -> index
            %170 = "arith.addi"(%169, %166) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %171 = "air.dma_memcpy_nd"(%arg139, %168, %arg137, %170) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 54 : i64, orbit.source_copies = array<i64: 46>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 183>, orbit.transfer = "host_to_l1", orbit.transfer_event = 153 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x80xf32>, index) -> !air.async.token
            "air.wait_all"(%171) {orbit.computation_event = 154 : i64, orbit.phase = 54 : i64, orbit.phase_dependencies = array<i64: 53>, orbit.read_copies = array<i64: 183>, orbit.task = "scale", orbit.write_copies = array<i64: 184>} : (!air.async.token) -> ()
            %172 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
            %173 = "arith.constant"() <{value = 0 : index}> : () -> index
            %174 = "arith.constant"() <{value = 8 : index}> : () -> index
            %175 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%173, %174, %175) ({
            ^bb0(%arg140: index):
              %180 = "arith.constant"() <{value = 0 : index}> : () -> index
              %181 = "arith.constant"() <{value = 32 : index}> : () -> index
              %182 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%180, %181, %182) ({
              ^bb0(%arg141: index):
                %183 = "arith.addi"(%arg141, %162) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %184 = "arith.subi"(%183, %166) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %185 = "memref.load"(%168, %arg140, %184) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %186 = "arith.mulf"(%185, %172) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %187 = "arith.subi"(%183, %164) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%186, %167, %arg140, %187) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %176 = "arith.constant"() <{value = 0 : index}> : () -> index
            %177 = "arith.addi"(%176, %164) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %178 = "air.dma_memcpy_nd"(%arg139, %arg136, %177, %167) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 54 : i64, orbit.source_copies = array<i64: 184>, orbit.storage = "Y", orbit.target_copies = array<i64: 185>, orbit.transfer = "l1_to_host", orbit.transfer_event = 155 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %179 = "air.wait_all"(%178) : (!air.async.token) -> !air.async.token
            "scf.yield"(%179) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%160) : (!air.async.token) -> ()
          "memref.dealloc"(%154) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%155) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_54"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_54"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_54"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg96: index, %arg97: index, %arg98: index, %arg99: index, %arg100: memref<17x129xf32>, %arg101: memref<129x80xf32>, %arg102: memref<17x80xf32>, %arg103: memref<17x80xf32>):
      "air.segment"(%arg100, %arg101, %arg102, %arg103) ({
      ^bb0(%arg104: memref<17x129xf32>, %arg105: memref<129x80xf32>, %arg106: memref<17x80xf32>, %arg107: memref<17x80xf32>):
        %131 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%131, %131, %arg104, %arg105, %arg106, %arg107) ({
        ^bb0(%arg108: index, %arg109: index, %arg110: index, %arg111: index, %arg112: memref<17x129xf32>, %arg113: memref<129x80xf32>, %arg114: memref<17x80xf32>, %arg115: memref<17x80xf32>):
          %132 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<128xf32, 2 : i32>
          %133 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : () -> memref<128xf32, 2 : i32>
          %134 = "air.wait_all"() : () -> !air.async.token
          %135 = "memref.reinterpret_cast"(%132) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 56 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %136 = "memref.reinterpret_cast"(%133) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 56 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %137 = "air.dma_memcpy_nd"(%134, %136, %arg115) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 56 : i64, orbit.source_copies = array<i64: 80>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 189>, orbit.transfer = "host_to_l1", orbit.transfer_event = 159 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 64>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, memref<17x80xf32>) -> !air.async.token
          "air.wait_all"(%137) {orbit.computation_event = 160 : i64, orbit.phase = 56 : i64, orbit.phase_dependencies = array<i64: 55>, orbit.read_copies = array<i64: 189>, orbit.task = "scale", orbit.write_copies = array<i64: 190>} : (!air.async.token) -> ()
          %138 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %139 = "arith.constant"() <{value = 0 : index}> : () -> index
          %140 = "arith.constant"() <{value = 8 : index}> : () -> index
          %141 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%139, %140, %141) ({
          ^bb0(%arg116: index):
            %144 = "arith.constant"() <{value = 64 : index}> : () -> index
            %145 = "arith.constant"() <{value = 80 : index}> : () -> index
            %146 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%144, %145, %146) ({
            ^bb0(%arg117: index):
              %147 = "arith.constant"() <{value = 64 : index}> : () -> index
              %148 = "arith.subi"(%arg117, %147) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %149 = "memref.load"(%136, %arg116, %148) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
              %150 = "arith.mulf"(%149, %138) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %151 = "arith.constant"() <{value = 64 : index}> : () -> index
              %152 = "arith.subi"(%arg117, %151) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%150, %135, %arg116, %152) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %142 = "air.dma_memcpy_nd"(%134, %arg114, %135) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 56 : i64, orbit.source_copies = array<i64: 190>, orbit.storage = "Y", orbit.target_copies = array<i64: 191>, orbit.transfer = "l1_to_host", orbit.transfer_event = 161 : i64, static_dst_offsets = array<i64: 0, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %143 = "air.wait_all"(%142) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%143) : (!air.async.token) -> ()
          "memref.dealloc"(%132) : (memref<128xf32, 2 : i32>) -> ()
          "memref.dealloc"(%133) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_56"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_56"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_56"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg72: index, %arg73: index, %arg74: index, %arg75: index, %arg76: memref<17x129xf32>, %arg77: memref<129x80xf32>, %arg78: memref<17x80xf32>, %arg79: memref<17x80xf32>):
      "air.segment"(%arg76, %arg77, %arg78, %arg79) ({
      ^bb0(%arg80: memref<17x129xf32>, %arg81: memref<129x80xf32>, %arg82: memref<17x80xf32>, %arg83: memref<17x80xf32>):
        %92 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%92, %92, %arg80, %arg81, %arg82, %arg83) ({
        ^bb0(%arg84: index, %arg85: index, %arg86: index, %arg87: index, %arg88: memref<17x129xf32>, %arg89: memref<129x80xf32>, %arg90: memref<17x80xf32>, %arg91: memref<17x80xf32>):
          %93 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<256xf32, 2 : i32>
          %94 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : () -> memref<256xf32, 2 : i32>
          %95 = "air.wait_all"() : () -> !air.async.token
          %96 = "arith.constant"() <{value = 0 : index}> : () -> index
          %97 = "arith.constant"() <{value = 2 : index}> : () -> index
          %98 = "arith.constant"() <{value = 1 : index}> : () -> index
          %99 = "scf.for"(%96, %97, %98, %95) ({
          ^bb0(%arg92: index, %arg93: !air.async.token):
            %100 = "arith.constant"() <{value = 32 : index}> : () -> index
            %101 = "arith.muli"(%arg92, %100) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %102 = "arith.constant"() <{value = 32 : index}> : () -> index
            %103 = "arith.muli"(%arg92, %102) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %104 = "arith.constant"() <{value = 32 : index}> : () -> index
            %105 = "arith.muli"(%arg92, %104) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %106 = "memref.reinterpret_cast"(%93) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 57 : i64, orbit.storage = "Y"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %107 = "memref.reinterpret_cast"(%94) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 57 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %108 = "arith.constant"() <{value = 0 : index}> : () -> index
            %109 = "arith.addi"(%108, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %110 = "air.dma_memcpy_nd"(%arg93, %107, %arg91, %109) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 57 : i64, orbit.source_copies = array<i64: 97>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 192>, orbit.transfer = "host_to_l1", orbit.transfer_event = 162 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x80xf32>, index) -> !air.async.token
            "air.wait_all"(%110) {orbit.computation_event = 163 : i64, orbit.phase = 57 : i64, orbit.phase_dependencies = array<i64: 56>, orbit.read_copies = array<i64: 192>, orbit.task = "scale", orbit.write_copies = array<i64: 193>} : (!air.async.token) -> ()
            %111 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
            %112 = "arith.constant"() <{value = 8 : index}> : () -> index
            %113 = "arith.constant"() <{value = 16 : index}> : () -> index
            %114 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%112, %113, %114) ({
            ^bb0(%arg94: index):
              %119 = "arith.constant"() <{value = 0 : index}> : () -> index
              %120 = "arith.constant"() <{value = 32 : index}> : () -> index
              %121 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%119, %120, %121) ({
              ^bb0(%arg95: index):
                %122 = "arith.addi"(%arg95, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %123 = "arith.constant"() <{value = 8 : index}> : () -> index
                %124 = "arith.subi"(%arg94, %123) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %125 = "arith.subi"(%122, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %126 = "memref.load"(%107, %124, %125) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %127 = "arith.mulf"(%126, %111) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %128 = "arith.constant"() <{value = 8 : index}> : () -> index
                %129 = "arith.subi"(%arg94, %128) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %130 = "arith.subi"(%122, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%127, %106, %129, %130) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %115 = "arith.constant"() <{value = 0 : index}> : () -> index
            %116 = "arith.addi"(%115, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %117 = "air.dma_memcpy_nd"(%arg93, %arg90, %116, %106) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 57 : i64, orbit.source_copies = array<i64: 193>, orbit.storage = "Y", orbit.target_copies = array<i64: 194>, orbit.transfer = "l1_to_host", orbit.transfer_event = 164 : i64, static_dst_offsets = array<i64: 8, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %118 = "air.wait_all"(%117) : (!air.async.token) -> !air.async.token
            "scf.yield"(%118) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%99) : (!air.async.token) -> ()
          "memref.dealloc"(%93) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%94) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_57"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_57"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_57"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg50: index, %arg51: index, %arg52: index, %arg53: index, %arg54: memref<17x129xf32>, %arg55: memref<129x80xf32>, %arg56: memref<17x80xf32>, %arg57: memref<17x80xf32>):
      "air.segment"(%arg54, %arg55, %arg56, %arg57) ({
      ^bb0(%arg58: memref<17x129xf32>, %arg59: memref<129x80xf32>, %arg60: memref<17x80xf32>, %arg61: memref<17x80xf32>):
        %66 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%66, %66, %arg58, %arg59, %arg60, %arg61) ({
        ^bb0(%arg62: index, %arg63: index, %arg64: index, %arg65: index, %arg66: memref<17x129xf32>, %arg67: memref<129x80xf32>, %arg68: memref<17x80xf32>, %arg69: memref<17x80xf32>):
          %67 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<128xf32, 2 : i32>
          %68 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : () -> memref<128xf32, 2 : i32>
          %69 = "air.wait_all"() : () -> !air.async.token
          %70 = "memref.reinterpret_cast"(%67) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 59 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %71 = "memref.reinterpret_cast"(%68) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 59 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %72 = "air.dma_memcpy_nd"(%69, %71, %arg69) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 59 : i64, orbit.source_copies = array<i64: 131>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 198>, orbit.transfer = "host_to_l1", orbit.transfer_event = 168 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 8, 64>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, memref<17x80xf32>) -> !air.async.token
          "air.wait_all"(%72) {orbit.computation_event = 169 : i64, orbit.phase = 59 : i64, orbit.phase_dependencies = array<i64: 58>, orbit.read_copies = array<i64: 198>, orbit.task = "scale", orbit.write_copies = array<i64: 199>} : (!air.async.token) -> ()
          %73 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %74 = "arith.constant"() <{value = 8 : index}> : () -> index
          %75 = "arith.constant"() <{value = 16 : index}> : () -> index
          %76 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%74, %75, %76) ({
          ^bb0(%arg70: index):
            %79 = "arith.constant"() <{value = 64 : index}> : () -> index
            %80 = "arith.constant"() <{value = 80 : index}> : () -> index
            %81 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%79, %80, %81) ({
            ^bb0(%arg71: index):
              %82 = "arith.constant"() <{value = 8 : index}> : () -> index
              %83 = "arith.subi"(%arg70, %82) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %84 = "arith.constant"() <{value = 64 : index}> : () -> index
              %85 = "arith.subi"(%arg71, %84) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %86 = "memref.load"(%71, %83, %85) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
              %87 = "arith.mulf"(%86, %73) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %88 = "arith.constant"() <{value = 8 : index}> : () -> index
              %89 = "arith.subi"(%arg70, %88) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %90 = "arith.constant"() <{value = 64 : index}> : () -> index
              %91 = "arith.subi"(%arg71, %90) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%87, %70, %89, %91) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %77 = "air.dma_memcpy_nd"(%69, %arg68, %70) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 59 : i64, orbit.source_copies = array<i64: 199>, orbit.storage = "Y", orbit.target_copies = array<i64: 200>, orbit.transfer = "l1_to_host", orbit.transfer_event = 170 : i64, static_dst_offsets = array<i64: 8, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %78 = "air.wait_all"(%77) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%78) : (!air.async.token) -> ()
          "memref.dealloc"(%67) : (memref<128xf32, 2 : i32>) -> ()
          "memref.dealloc"(%68) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_59"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_59"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_59"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg26: index, %arg27: index, %arg28: index, %arg29: index, %arg30: memref<17x129xf32>, %arg31: memref<129x80xf32>, %arg32: memref<17x80xf32>, %arg33: memref<17x80xf32>):
      "air.segment"(%arg30, %arg31, %arg32, %arg33) ({
      ^bb0(%arg34: memref<17x129xf32>, %arg35: memref<129x80xf32>, %arg36: memref<17x80xf32>, %arg37: memref<17x80xf32>):
        %27 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%27, %27, %arg34, %arg35, %arg36, %arg37) ({
        ^bb0(%arg38: index, %arg39: index, %arg40: index, %arg41: index, %arg42: memref<17x129xf32>, %arg43: memref<129x80xf32>, %arg44: memref<17x80xf32>, %arg45: memref<17x80xf32>):
          %28 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<32xf32, 2 : i32>
          %29 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.32.loops.1.32"} : () -> memref<32xf32, 2 : i32>
          %30 = "air.wait_all"() : () -> !air.async.token
          %31 = "arith.constant"() <{value = 0 : index}> : () -> index
          %32 = "arith.constant"() <{value = 2 : index}> : () -> index
          %33 = "arith.constant"() <{value = 1 : index}> : () -> index
          %34 = "scf.for"(%31, %32, %33, %30) ({
          ^bb0(%arg46: index, %arg47: !air.async.token):
            %35 = "arith.constant"() <{value = 32 : index}> : () -> index
            %36 = "arith.muli"(%arg46, %35) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %37 = "arith.constant"() <{value = 32 : index}> : () -> index
            %38 = "arith.muli"(%arg46, %37) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %39 = "arith.constant"() <{value = 32 : index}> : () -> index
            %40 = "arith.muli"(%arg46, %39) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %41 = "memref.reinterpret_cast"(%28) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 60 : i64, orbit.storage = "Y"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %42 = "memref.reinterpret_cast"(%29) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 60 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %43 = "arith.constant"() <{value = 0 : index}> : () -> index
            %44 = "arith.addi"(%43, %40) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %45 = "air.dma_memcpy_nd"(%arg47, %42, %arg45, %44) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 60 : i64, orbit.source_copies = array<i64: 148>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 201>, orbit.transfer = "host_to_l1", orbit.transfer_event = 171 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x80xf32>, index) -> !air.async.token
            "air.wait_all"(%45) {orbit.computation_event = 172 : i64, orbit.phase = 60 : i64, orbit.phase_dependencies = array<i64: 59>, orbit.read_copies = array<i64: 201>, orbit.task = "scale", orbit.write_copies = array<i64: 202>} : (!air.async.token) -> ()
            %46 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
            %47 = "arith.constant"() <{value = 16 : index}> : () -> index
            %48 = "arith.constant"() <{value = 17 : index}> : () -> index
            %49 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%47, %48, %49) ({
            ^bb0(%arg48: index):
              %54 = "arith.constant"() <{value = 0 : index}> : () -> index
              %55 = "arith.constant"() <{value = 32 : index}> : () -> index
              %56 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%54, %55, %56) ({
              ^bb0(%arg49: index):
                %57 = "arith.addi"(%arg49, %36) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %58 = "arith.constant"() <{value = 16 : index}> : () -> index
                %59 = "arith.subi"(%arg48, %58) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %60 = "arith.subi"(%57, %40) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %61 = "memref.load"(%42, %59, %60) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %62 = "arith.mulf"(%61, %46) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %63 = "arith.constant"() <{value = 16 : index}> : () -> index
                %64 = "arith.subi"(%arg48, %63) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %65 = "arith.subi"(%57, %38) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%62, %41, %64, %65) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %50 = "arith.constant"() <{value = 0 : index}> : () -> index
            %51 = "arith.addi"(%50, %38) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %52 = "air.dma_memcpy_nd"(%arg47, %arg44, %51, %41) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 60 : i64, orbit.source_copies = array<i64: 202>, orbit.storage = "Y", orbit.target_copies = array<i64: 203>, orbit.transfer = "l1_to_host", orbit.transfer_event = 173 : i64, static_dst_offsets = array<i64: 16, -9223372036854775808>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, index, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %53 = "air.wait_all"(%52) : (!air.async.token) -> !air.async.token
            "scf.yield"(%53) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%34) : (!air.async.token) -> ()
          "memref.dealloc"(%28) : (memref<32xf32, 2 : i32>) -> ()
          "memref.dealloc"(%29) : (memref<32xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_60"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_60"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_60"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<17x129xf32>, %arg9: memref<129x80xf32>, %arg10: memref<17x80xf32>, %arg11: memref<17x80xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<17x129xf32>, %arg13: memref<129x80xf32>, %arg14: memref<17x80xf32>, %arg15: memref<17x80xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<17x129xf32>, %arg21: memref<129x80xf32>, %arg22: memref<17x80xf32>, %arg23: memref<17x80xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<16xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.16.loops.1.16"} : () -> memref<16xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 62 : i64, orbit.storage = "Y"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %6 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 62 : i64, orbit.storage = "intermediate"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %7 = "air.dma_memcpy_nd"(%4, %6, %arg23) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 62 : i64, orbit.source_copies = array<i64: 182>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 207>, orbit.transfer = "host_to_l1", orbit.transfer_event = 177 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 16, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<17x80xf32>) -> !air.async.token
          "air.wait_all"(%7) {orbit.computation_event = 178 : i64, orbit.phase = 62 : i64, orbit.phase_dependencies = array<i64: 61>, orbit.read_copies = array<i64: 207>, orbit.task = "scale", orbit.write_copies = array<i64: 208>} : (!air.async.token) -> ()
          %8 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %9 = "arith.constant"() <{value = 16 : index}> : () -> index
          %10 = "arith.constant"() <{value = 17 : index}> : () -> index
          %11 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%9, %10, %11) ({
          ^bb0(%arg24: index):
            %14 = "arith.constant"() <{value = 64 : index}> : () -> index
            %15 = "arith.constant"() <{value = 80 : index}> : () -> index
            %16 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%14, %15, %16) ({
            ^bb0(%arg25: index):
              %17 = "arith.constant"() <{value = 16 : index}> : () -> index
              %18 = "arith.subi"(%arg24, %17) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %19 = "arith.constant"() <{value = 64 : index}> : () -> index
              %20 = "arith.subi"(%arg25, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "memref.load"(%6, %18, %20) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
              %22 = "arith.mulf"(%21, %8) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %23 = "arith.constant"() <{value = 16 : index}> : () -> index
              %24 = "arith.subi"(%arg24, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "arith.constant"() <{value = 64 : index}> : () -> index
              %26 = "arith.subi"(%arg25, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%22, %5, %24, %26) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %12 = "air.dma_memcpy_nd"(%4, %arg22, %5) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 62 : i64, orbit.source_copies = array<i64: 208>, orbit.storage = "Y", orbit.target_copies = array<i64: 209>, orbit.transfer = "l1_to_host", orbit.transfer_event = 179 : i64, static_dst_offsets = array<i64: 16, 64>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %13 = "air.wait_all"(%12) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%13) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<16xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<16xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_62"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_62"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_62"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "e0059a41318a23ea40da0ac9af630ebf06c5110df619651816143dda90e3bc46", orbit.source_fingerprint = "912511a293a64cce8e0d6c281bea7fa9b2ada1f653348173aee833f4c600a053"} : () -> ()

