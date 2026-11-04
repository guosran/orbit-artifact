"builtin.module"() ({
  "func.func"() <{function_type = (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg382: index, %arg383: index, %arg384: index, %arg385: index, %arg386: memref<17x129xf32>, %arg387: memref<129x80xf32>, %arg388: memref<17x80xf32>, %arg389: memref<17x80xf32>):
      "air.segment"(%arg386, %arg387, %arg388, %arg389) ({
      ^bb0(%arg390: memref<17x129xf32>, %arg391: memref<129x80xf32>, %arg392: memref<17x80xf32>, %arg393: memref<17x80xf32>):
        %994 = "arith.constant"() <{value = 1 : index}> : () -> index
        %995 = "air.herd"(%994, %994, %arg390, %arg391, %arg392, %arg393) ({
        ^bb0(%arg394: index, %arg395: index, %arg396: index, %arg397: index, %arg398: memref<17x129xf32>, %arg399: memref<129x80xf32>, %arg400: memref<17x80xf32>, %arg401: memref<17x80xf32>):
          %996 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %997 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %998 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %999 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %1000 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %1001 = "air.wait_all"() : () -> !air.async.token
          %1002 = "memref.reinterpret_cast"(%1000) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 9 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %1003 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %1004 = "arith.constant"() <{value = 0 : index}> : () -> index
          %1005 = "arith.constant"() <{value = 8 : index}> : () -> index
          %1006 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%1004, %1005, %1006) ({
          ^bb0(%arg410: index):
            %1070 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1071 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1072 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%1070, %1071, %1072) ({
            ^bb0(%arg411: index):
              "memref.store"(%1003, %1002, %arg410, %arg411) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %1007 = "arith.constant"() <{value = 0 : index}> : () -> index
          %1008 = "arith.constant"() <{value = 4 : index}> : () -> index
          %1009 = "arith.constant"() <{value = 1 : index}> : () -> index
          %1010 = "scf.for"(%1007, %1008, %1009, %1001) ({
          ^bb0(%arg405: index, %arg406: !air.async.token):
            %1037 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1038 = "arith.muli"(%arg405, %1037) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1039 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1040 = "arith.muli"(%arg405, %1039) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1041 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1042 = "arith.muli"(%arg405, %1041) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1043 = "memref.reinterpret_cast"(%997) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 9 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %1044 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1045 = "arith.addi"(%1044, %1040) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1046 = "air.dma_memcpy_nd"(%arg406, %1043, %arg398, %1045) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 9 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 30>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %1047 = "memref.reinterpret_cast"(%999) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 9 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %1048 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1049 = "arith.addi"(%1048, %1042) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1050 = "air.dma_memcpy_nd"(%arg406, %1047, %arg399, %1049) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 9 : i64, orbit.source_copies = array<i64: 15>, orbit.storage = "B", orbit.target_copies = array<i64: 31>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%1046, %1050) {orbit.computation_event = 3 : i64, orbit.phase = 9 : i64, orbit.phase_dependencies = array<i64: 8>, orbit.read_copies = array<i64: 30, 31, 32>, orbit.task = "gemm", orbit.write_copies = array<i64: 33>} : (!air.async.token, !air.async.token) -> ()
            %1051 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %1052 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1053 = "arith.constant"() <{value = 8 : index}> : () -> index
            %1054 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%1052, %1053, %1054) ({
            ^bb0(%arg407: index):
              %1056 = "arith.constant"() <{value = 0 : index}> : () -> index
              %1057 = "arith.constant"() <{value = 32 : index}> : () -> index
              %1058 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%1056, %1057, %1058) ({
              ^bb0(%arg408: index):
                %1059 = "arith.constant"() <{value = 0 : index}> : () -> index
                %1060 = "arith.constant"() <{value = 32 : index}> : () -> index
                %1061 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%1059, %1060, %1061) ({
                ^bb0(%arg409: index):
                  %1062 = "arith.addi"(%arg409, %1038) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1063 = "arith.subi"(%1062, %1040) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1064 = "memref.load"(%1043, %arg407, %1063) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1065 = "arith.subi"(%1062, %1042) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1066 = "memref.load"(%1047, %1065, %arg408) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1067 = "memref.load"(%1002, %arg407, %arg408) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1068 = "arith.mulf"(%1064, %1066) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %1069 = "arith.addf"(%1067, %1068) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  "memref.store"(%1069, %1002, %arg407, %arg408) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %1055 = "air.wait_all"(%arg406) : (!air.async.token) -> !air.async.token
            "scf.yield"(%1055) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %1011 = "memref.reinterpret_cast"(%996) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 13 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %1012 = "air.dma_memcpy_nd"(%1010, %1011, %arg398) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 13 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "A", orbit.target_copies = array<i64: 43>, orbit.transfer = "host_to_l1", orbit.transfer_event = 13 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %1013 = "memref.reinterpret_cast"(%998) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 13 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %1014 = "air.dma_memcpy_nd"(%1010, %1013, %arg399) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 13 : i64, orbit.source_copies = array<i64: 27>, orbit.storage = "B", orbit.target_copies = array<i64: 44>, orbit.transfer = "host_to_l1", orbit.transfer_event = 14 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%1012, %1014) {orbit.computation_event = 15 : i64, orbit.phase = 13 : i64, orbit.phase_dependencies = array<i64: 12>, orbit.read_copies = array<i64: 43, 44, 42>, orbit.task = "gemm", orbit.write_copies = array<i64: 45>} : (!air.async.token, !air.async.token) -> ()
          %1015 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %1016 = "arith.constant"() <{value = 0 : index}> : () -> index
          %1017 = "arith.constant"() <{value = 8 : index}> : () -> index
          %1018 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%1016, %1017, %1018) ({
          ^bb0(%arg402: index):
            %1022 = "arith.constant"() <{value = 0 : index}> : () -> index
            %1023 = "arith.constant"() <{value = 32 : index}> : () -> index
            %1024 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%1022, %1023, %1024) ({
            ^bb0(%arg403: index):
              %1025 = "arith.constant"() <{value = 128 : index}> : () -> index
              %1026 = "arith.constant"() <{value = 129 : index}> : () -> index
              %1027 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%1025, %1026, %1027) ({
              ^bb0(%arg404: index):
                %1028 = "arith.constant"() <{value = 128 : index}> : () -> index
                %1029 = "arith.subi"(%arg404, %1028) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %1030 = "memref.load"(%1011, %arg402, %1029) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %1031 = "arith.constant"() <{value = 128 : index}> : () -> index
                %1032 = "arith.subi"(%arg404, %1031) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %1033 = "memref.load"(%1013, %1032, %arg403) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %1034 = "memref.load"(%1002, %arg402, %arg403) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %1035 = "arith.mulf"(%1030, %1033) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %1036 = "arith.addf"(%1034, %1035) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                "memref.store"(%1036, %1002, %arg402, %arg403) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %1019 = "air.wait_all"(%1010) : (!air.async.token) -> !air.async.token
          %1020 = "air.dma_memcpy_nd"(%1019, %arg401, %1002) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 13 : i64, orbit.retained_begin = 9 : i64, orbit.retained_end = 14 : i64, orbit.source_copies = array<i64: 45>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 46>, orbit.transfer = "l1_to_host", orbit.transfer_event = 16 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %1021 = "air.wait_all"(%1020) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%1021) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%995) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg352: index, %arg353: index, %arg354: index, %arg355: index, %arg356: memref<17x129xf32>, %arg357: memref<129x80xf32>, %arg358: memref<17x80xf32>, %arg359: memref<17x80xf32>):
      "air.segment"(%arg356, %arg357, %arg358, %arg359) ({
      ^bb0(%arg360: memref<17x129xf32>, %arg361: memref<129x80xf32>, %arg362: memref<17x80xf32>, %arg363: memref<17x80xf32>):
        %901 = "arith.constant"() <{value = 1 : index}> : () -> index
        %902 = "air.herd"(%901, %901, %arg360, %arg361, %arg362, %arg363) ({
        ^bb0(%arg364: index, %arg365: index, %arg366: index, %arg367: index, %arg368: memref<17x129xf32>, %arg369: memref<129x80xf32>, %arg370: memref<17x80xf32>, %arg371: memref<17x80xf32>):
          %903 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %904 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %905 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %906 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %907 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %908 = "air.wait_all"() : () -> !air.async.token
          %909 = "memref.reinterpret_cast"(%907) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 14 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %910 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %911 = "arith.constant"() <{value = 0 : index}> : () -> index
          %912 = "arith.constant"() <{value = 8 : index}> : () -> index
          %913 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%911, %912, %913) ({
          ^bb0(%arg380: index):
            %989 = "arith.constant"() <{value = 32 : index}> : () -> index
            %990 = "arith.constant"() <{value = 64 : index}> : () -> index
            %991 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%989, %990, %991) ({
            ^bb0(%arg381: index):
              %992 = "arith.constant"() <{value = 32 : index}> : () -> index
              %993 = "arith.subi"(%arg381, %992) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%910, %909, %arg380, %993) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %914 = "arith.constant"() <{value = 0 : index}> : () -> index
          %915 = "arith.constant"() <{value = 4 : index}> : () -> index
          %916 = "arith.constant"() <{value = 1 : index}> : () -> index
          %917 = "scf.for"(%914, %915, %916, %908) ({
          ^bb0(%arg375: index, %arg376: !air.async.token):
            %950 = "arith.constant"() <{value = 32 : index}> : () -> index
            %951 = "arith.muli"(%arg375, %950) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %952 = "arith.constant"() <{value = 32 : index}> : () -> index
            %953 = "arith.muli"(%arg375, %952) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %954 = "arith.constant"() <{value = 32 : index}> : () -> index
            %955 = "arith.muli"(%arg375, %954) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %956 = "memref.reinterpret_cast"(%904) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 14 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %957 = "arith.constant"() <{value = 0 : index}> : () -> index
            %958 = "arith.addi"(%957, %953) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %959 = "air.dma_memcpy_nd"(%arg376, %956, %arg368, %958) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 14 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 47>, orbit.transfer = "host_to_l1", orbit.transfer_event = 17 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %960 = "memref.reinterpret_cast"(%906) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 14 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %961 = "arith.constant"() <{value = 0 : index}> : () -> index
            %962 = "arith.addi"(%961, %955) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %963 = "air.dma_memcpy_nd"(%arg376, %960, %arg369, %962) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 14 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 48>, orbit.transfer = "host_to_l1", orbit.transfer_event = 18 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%959, %963) {orbit.computation_event = 20 : i64, orbit.phase = 14 : i64, orbit.phase_dependencies = array<i64: 13>, orbit.read_copies = array<i64: 47, 48, 49>, orbit.task = "gemm", orbit.write_copies = array<i64: 50>} : (!air.async.token, !air.async.token) -> ()
            %964 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %965 = "arith.constant"() <{value = 0 : index}> : () -> index
            %966 = "arith.constant"() <{value = 8 : index}> : () -> index
            %967 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%965, %966, %967) ({
            ^bb0(%arg377: index):
              %969 = "arith.constant"() <{value = 32 : index}> : () -> index
              %970 = "arith.constant"() <{value = 64 : index}> : () -> index
              %971 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%969, %970, %971) ({
              ^bb0(%arg378: index):
                %972 = "arith.constant"() <{value = 0 : index}> : () -> index
                %973 = "arith.constant"() <{value = 32 : index}> : () -> index
                %974 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%972, %973, %974) ({
                ^bb0(%arg379: index):
                  %975 = "arith.addi"(%arg379, %951) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %976 = "arith.subi"(%975, %953) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %977 = "memref.load"(%956, %arg377, %976) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %978 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %979 = "arith.subi"(%arg378, %978) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %980 = "arith.subi"(%975, %955) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %981 = "memref.load"(%960, %980, %979) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %982 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %983 = "arith.subi"(%arg378, %982) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %984 = "memref.load"(%909, %arg377, %983) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %985 = "arith.mulf"(%977, %981) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %986 = "arith.addf"(%984, %985) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %987 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %988 = "arith.subi"(%arg378, %987) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%986, %909, %arg377, %988) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %968 = "air.wait_all"(%arg376) : (!air.async.token) -> !air.async.token
            "scf.yield"(%968) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %918 = "memref.reinterpret_cast"(%903) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 18 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %919 = "air.dma_memcpy_nd"(%917, %918, %arg368) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 18 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "A", orbit.target_copies = array<i64: 60>, orbit.transfer = "host_to_l1", orbit.transfer_event = 30 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %920 = "memref.reinterpret_cast"(%905) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 18 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %921 = "air.dma_memcpy_nd"(%917, %920, %arg369) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 18 : i64, orbit.source_copies = array<i64: 28>, orbit.storage = "B", orbit.target_copies = array<i64: 61>, orbit.transfer = "host_to_l1", orbit.transfer_event = 31 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%919, %921) {orbit.computation_event = 32 : i64, orbit.phase = 18 : i64, orbit.phase_dependencies = array<i64: 17>, orbit.read_copies = array<i64: 60, 61, 59>, orbit.task = "gemm", orbit.write_copies = array<i64: 62>} : (!air.async.token, !air.async.token) -> ()
          %922 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %923 = "arith.constant"() <{value = 0 : index}> : () -> index
          %924 = "arith.constant"() <{value = 8 : index}> : () -> index
          %925 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%923, %924, %925) ({
          ^bb0(%arg372: index):
            %929 = "arith.constant"() <{value = 32 : index}> : () -> index
            %930 = "arith.constant"() <{value = 64 : index}> : () -> index
            %931 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%929, %930, %931) ({
            ^bb0(%arg373: index):
              %932 = "arith.constant"() <{value = 128 : index}> : () -> index
              %933 = "arith.constant"() <{value = 129 : index}> : () -> index
              %934 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%932, %933, %934) ({
              ^bb0(%arg374: index):
                %935 = "arith.constant"() <{value = 128 : index}> : () -> index
                %936 = "arith.subi"(%arg374, %935) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %937 = "memref.load"(%918, %arg372, %936) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %938 = "arith.constant"() <{value = 128 : index}> : () -> index
                %939 = "arith.subi"(%arg374, %938) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %940 = "arith.constant"() <{value = 32 : index}> : () -> index
                %941 = "arith.subi"(%arg373, %940) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %942 = "memref.load"(%920, %939, %941) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %943 = "arith.constant"() <{value = 32 : index}> : () -> index
                %944 = "arith.subi"(%arg373, %943) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %945 = "memref.load"(%909, %arg372, %944) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %946 = "arith.mulf"(%937, %942) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %947 = "arith.addf"(%945, %946) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %948 = "arith.constant"() <{value = 32 : index}> : () -> index
                %949 = "arith.subi"(%arg373, %948) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%947, %909, %arg372, %949) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %926 = "air.wait_all"(%917) : (!air.async.token) -> !air.async.token
          %927 = "air.dma_memcpy_nd"(%926, %arg371, %909) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 18 : i64, orbit.retained_begin = 14 : i64, orbit.retained_end = 19 : i64, orbit.source_copies = array<i64: 62>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 63>, orbit.transfer = "l1_to_host", orbit.transfer_event = 33 : i64, static_dst_offsets = array<i64: 0, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %928 = "air.wait_all"(%927) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%928) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_14"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%902) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_14"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_14"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg322: index, %arg323: index, %arg324: index, %arg325: index, %arg326: memref<17x129xf32>, %arg327: memref<129x80xf32>, %arg328: memref<17x80xf32>, %arg329: memref<17x80xf32>):
      "air.segment"(%arg326, %arg327, %arg328, %arg329) ({
      ^bb0(%arg330: memref<17x129xf32>, %arg331: memref<129x80xf32>, %arg332: memref<17x80xf32>, %arg333: memref<17x80xf32>):
        %808 = "arith.constant"() <{value = 1 : index}> : () -> index
        %809 = "air.herd"(%808, %808, %arg330, %arg331, %arg332, %arg333) ({
        ^bb0(%arg334: index, %arg335: index, %arg336: index, %arg337: index, %arg338: memref<17x129xf32>, %arg339: memref<129x80xf32>, %arg340: memref<17x80xf32>, %arg341: memref<17x80xf32>):
          %810 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : () -> memref<8xf32, 2 : i32>
          %811 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %812 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : () -> memref<16xf32, 2 : i32>
          %813 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : () -> memref<512xf32, 2 : i32>
          %814 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %815 = "air.wait_all"() : () -> !air.async.token
          %816 = "memref.reinterpret_cast"(%814) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 19 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %817 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %818 = "arith.constant"() <{value = 0 : index}> : () -> index
          %819 = "arith.constant"() <{value = 8 : index}> : () -> index
          %820 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%818, %819, %820) ({
          ^bb0(%arg350: index):
            %896 = "arith.constant"() <{value = 64 : index}> : () -> index
            %897 = "arith.constant"() <{value = 80 : index}> : () -> index
            %898 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%896, %897, %898) ({
            ^bb0(%arg351: index):
              %899 = "arith.constant"() <{value = 64 : index}> : () -> index
              %900 = "arith.subi"(%arg351, %899) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%817, %816, %arg350, %900) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %821 = "arith.constant"() <{value = 0 : index}> : () -> index
          %822 = "arith.constant"() <{value = 4 : index}> : () -> index
          %823 = "arith.constant"() <{value = 1 : index}> : () -> index
          %824 = "scf.for"(%821, %822, %823, %815) ({
          ^bb0(%arg345: index, %arg346: !air.async.token):
            %857 = "arith.constant"() <{value = 32 : index}> : () -> index
            %858 = "arith.muli"(%arg345, %857) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %859 = "arith.constant"() <{value = 32 : index}> : () -> index
            %860 = "arith.muli"(%arg345, %859) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %861 = "arith.constant"() <{value = 32 : index}> : () -> index
            %862 = "arith.muli"(%arg345, %861) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %863 = "memref.reinterpret_cast"(%811) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 19 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %864 = "arith.constant"() <{value = 0 : index}> : () -> index
            %865 = "arith.addi"(%864, %860) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %866 = "air.dma_memcpy_nd"(%arg346, %863, %arg338, %865) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 19 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 64>, orbit.transfer = "host_to_l1", orbit.transfer_event = 34 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %867 = "memref.reinterpret_cast"(%813) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 19 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %868 = "arith.constant"() <{value = 0 : index}> : () -> index
            %869 = "arith.addi"(%868, %862) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %870 = "air.dma_memcpy_nd"(%arg346, %867, %arg339, %869) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 19 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "B", orbit.target_copies = array<i64: 65>, orbit.transfer = "host_to_l1", orbit.transfer_event = 35 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%866, %870) {orbit.computation_event = 37 : i64, orbit.phase = 19 : i64, orbit.phase_dependencies = array<i64: 18>, orbit.read_copies = array<i64: 64, 65, 66>, orbit.task = "gemm", orbit.write_copies = array<i64: 67>} : (!air.async.token, !air.async.token) -> ()
            %871 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %872 = "arith.constant"() <{value = 0 : index}> : () -> index
            %873 = "arith.constant"() <{value = 8 : index}> : () -> index
            %874 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%872, %873, %874) ({
            ^bb0(%arg347: index):
              %876 = "arith.constant"() <{value = 64 : index}> : () -> index
              %877 = "arith.constant"() <{value = 80 : index}> : () -> index
              %878 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%876, %877, %878) ({
              ^bb0(%arg348: index):
                %879 = "arith.constant"() <{value = 0 : index}> : () -> index
                %880 = "arith.constant"() <{value = 32 : index}> : () -> index
                %881 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%879, %880, %881) ({
                ^bb0(%arg349: index):
                  %882 = "arith.addi"(%arg349, %858) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %883 = "arith.subi"(%882, %860) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %884 = "memref.load"(%863, %arg347, %883) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %885 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %886 = "arith.subi"(%arg348, %885) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %887 = "arith.subi"(%882, %862) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %888 = "memref.load"(%867, %887, %886) <{nontemporal = false}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %889 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %890 = "arith.subi"(%arg348, %889) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %891 = "memref.load"(%816, %arg347, %890) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %892 = "arith.mulf"(%884, %888) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %893 = "arith.addf"(%891, %892) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %894 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %895 = "arith.subi"(%arg348, %894) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%893, %816, %arg347, %895) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %875 = "air.wait_all"(%arg346) : (!air.async.token) -> !air.async.token
            "scf.yield"(%875) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %825 = "memref.reinterpret_cast"(%810) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 23 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %826 = "air.dma_memcpy_nd"(%824, %825, %arg338) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 23 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "A", orbit.target_copies = array<i64: 77>, orbit.transfer = "host_to_l1", orbit.transfer_event = 47 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %827 = "memref.reinterpret_cast"(%812) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 23 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %828 = "air.dma_memcpy_nd"(%824, %827, %arg339) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 23 : i64, orbit.source_copies = array<i64: 29>, orbit.storage = "B", orbit.target_copies = array<i64: 78>, orbit.transfer = "host_to_l1", orbit.transfer_event = 48 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%826, %828) {orbit.computation_event = 49 : i64, orbit.phase = 23 : i64, orbit.phase_dependencies = array<i64: 22>, orbit.read_copies = array<i64: 77, 78, 76>, orbit.task = "gemm", orbit.write_copies = array<i64: 79>} : (!air.async.token, !air.async.token) -> ()
          %829 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %830 = "arith.constant"() <{value = 0 : index}> : () -> index
          %831 = "arith.constant"() <{value = 8 : index}> : () -> index
          %832 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%830, %831, %832) ({
          ^bb0(%arg342: index):
            %836 = "arith.constant"() <{value = 64 : index}> : () -> index
            %837 = "arith.constant"() <{value = 80 : index}> : () -> index
            %838 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%836, %837, %838) ({
            ^bb0(%arg343: index):
              %839 = "arith.constant"() <{value = 128 : index}> : () -> index
              %840 = "arith.constant"() <{value = 129 : index}> : () -> index
              %841 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%839, %840, %841) ({
              ^bb0(%arg344: index):
                %842 = "arith.constant"() <{value = 128 : index}> : () -> index
                %843 = "arith.subi"(%arg344, %842) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %844 = "memref.load"(%825, %arg342, %843) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %845 = "arith.constant"() <{value = 128 : index}> : () -> index
                %846 = "arith.subi"(%arg344, %845) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %847 = "arith.constant"() <{value = 64 : index}> : () -> index
                %848 = "arith.subi"(%arg343, %847) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %849 = "memref.load"(%827, %846, %848) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %850 = "arith.constant"() <{value = 64 : index}> : () -> index
                %851 = "arith.subi"(%arg343, %850) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %852 = "memref.load"(%816, %arg342, %851) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %853 = "arith.mulf"(%844, %849) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %854 = "arith.addf"(%852, %853) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %855 = "arith.constant"() <{value = 64 : index}> : () -> index
                %856 = "arith.subi"(%arg343, %855) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%854, %816, %arg342, %856) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %833 = "air.wait_all"(%824) : (!air.async.token) -> !air.async.token
          %834 = "air.dma_memcpy_nd"(%833, %arg341, %816) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 23 : i64, orbit.retained_begin = 19 : i64, orbit.retained_end = 24 : i64, orbit.source_copies = array<i64: 79>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 80>, orbit.transfer = "l1_to_host", orbit.transfer_event = 50 : i64, static_dst_offsets = array<i64: 0, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %835 = "air.wait_all"(%834) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%835) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_19"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%809) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_19"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_19"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg292: index, %arg293: index, %arg294: index, %arg295: index, %arg296: memref<17x129xf32>, %arg297: memref<129x80xf32>, %arg298: memref<17x80xf32>, %arg299: memref<17x80xf32>):
      "air.segment"(%arg296, %arg297, %arg298, %arg299) ({
      ^bb0(%arg300: memref<17x129xf32>, %arg301: memref<129x80xf32>, %arg302: memref<17x80xf32>, %arg303: memref<17x80xf32>):
        %715 = "arith.constant"() <{value = 1 : index}> : () -> index
        %716 = "air.herd"(%715, %715, %arg300, %arg301, %arg302, %arg303) ({
        ^bb0(%arg304: index, %arg305: index, %arg306: index, %arg307: index, %arg308: memref<17x129xf32>, %arg309: memref<129x80xf32>, %arg310: memref<17x80xf32>, %arg311: memref<17x80xf32>):
          %717 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %718 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %719 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %720 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %721 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %722 = "air.wait_all"() : () -> !air.async.token
          %723 = "memref.reinterpret_cast"(%721) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %724 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %725 = "arith.constant"() <{value = 8 : index}> : () -> index
          %726 = "arith.constant"() <{value = 16 : index}> : () -> index
          %727 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%725, %726, %727) ({
          ^bb0(%arg320: index):
            %803 = "arith.constant"() <{value = 0 : index}> : () -> index
            %804 = "arith.constant"() <{value = 32 : index}> : () -> index
            %805 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%803, %804, %805) ({
            ^bb0(%arg321: index):
              %806 = "arith.constant"() <{value = 8 : index}> : () -> index
              %807 = "arith.subi"(%arg320, %806) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%724, %723, %807, %arg321) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %728 = "arith.constant"() <{value = 0 : index}> : () -> index
          %729 = "arith.constant"() <{value = 4 : index}> : () -> index
          %730 = "arith.constant"() <{value = 1 : index}> : () -> index
          %731 = "scf.for"(%728, %729, %730, %722) ({
          ^bb0(%arg315: index, %arg316: !air.async.token):
            %764 = "arith.constant"() <{value = 32 : index}> : () -> index
            %765 = "arith.muli"(%arg315, %764) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %766 = "arith.constant"() <{value = 32 : index}> : () -> index
            %767 = "arith.muli"(%arg315, %766) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %768 = "arith.constant"() <{value = 32 : index}> : () -> index
            %769 = "arith.muli"(%arg315, %768) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %770 = "memref.reinterpret_cast"(%718) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %771 = "arith.constant"() <{value = 0 : index}> : () -> index
            %772 = "arith.addi"(%771, %767) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %773 = "air.dma_memcpy_nd"(%arg316, %770, %arg308, %772) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 24 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "A", orbit.target_copies = array<i64: 81>, orbit.transfer = "host_to_l1", orbit.transfer_event = 51 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %774 = "memref.reinterpret_cast"(%720) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %775 = "arith.constant"() <{value = 0 : index}> : () -> index
            %776 = "arith.addi"(%775, %769) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %777 = "air.dma_memcpy_nd"(%arg316, %774, %arg309, %776) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 24 : i64, orbit.source_copies = array<i64: 15>, orbit.storage = "B", orbit.target_copies = array<i64: 82>, orbit.transfer = "host_to_l1", orbit.transfer_event = 52 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%773, %777) {orbit.computation_event = 54 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 81, 82, 83>, orbit.task = "gemm", orbit.write_copies = array<i64: 84>} : (!air.async.token, !air.async.token) -> ()
            %778 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %779 = "arith.constant"() <{value = 8 : index}> : () -> index
            %780 = "arith.constant"() <{value = 16 : index}> : () -> index
            %781 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%779, %780, %781) ({
            ^bb0(%arg317: index):
              %783 = "arith.constant"() <{value = 0 : index}> : () -> index
              %784 = "arith.constant"() <{value = 32 : index}> : () -> index
              %785 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%783, %784, %785) ({
              ^bb0(%arg318: index):
                %786 = "arith.constant"() <{value = 0 : index}> : () -> index
                %787 = "arith.constant"() <{value = 32 : index}> : () -> index
                %788 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%786, %787, %788) ({
                ^bb0(%arg319: index):
                  %789 = "arith.addi"(%arg319, %765) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %790 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %791 = "arith.subi"(%arg317, %790) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %792 = "arith.subi"(%789, %767) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %793 = "memref.load"(%770, %791, %792) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %794 = "arith.subi"(%789, %769) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %795 = "memref.load"(%774, %794, %arg318) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %796 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %797 = "arith.subi"(%arg317, %796) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %798 = "memref.load"(%723, %797, %arg318) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %799 = "arith.mulf"(%793, %795) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %800 = "arith.addf"(%798, %799) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %801 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %802 = "arith.subi"(%arg317, %801) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%800, %723, %802, %arg318) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %782 = "air.wait_all"(%arg316) : (!air.async.token) -> !air.async.token
            "scf.yield"(%782) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %732 = "memref.reinterpret_cast"(%717) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 28 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %733 = "air.dma_memcpy_nd"(%731, %732, %arg308) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 28 : i64, orbit.source_copies = array<i64: 9>, orbit.storage = "A", orbit.target_copies = array<i64: 94>, orbit.transfer = "host_to_l1", orbit.transfer_event = 64 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %734 = "memref.reinterpret_cast"(%719) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 28 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %735 = "air.dma_memcpy_nd"(%731, %734, %arg309) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 28 : i64, orbit.source_copies = array<i64: 27>, orbit.storage = "B", orbit.target_copies = array<i64: 95>, orbit.transfer = "host_to_l1", orbit.transfer_event = 65 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%733, %735) {orbit.computation_event = 66 : i64, orbit.phase = 28 : i64, orbit.phase_dependencies = array<i64: 27>, orbit.read_copies = array<i64: 94, 95, 93>, orbit.task = "gemm", orbit.write_copies = array<i64: 96>} : (!air.async.token, !air.async.token) -> ()
          %736 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %737 = "arith.constant"() <{value = 8 : index}> : () -> index
          %738 = "arith.constant"() <{value = 16 : index}> : () -> index
          %739 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%737, %738, %739) ({
          ^bb0(%arg312: index):
            %743 = "arith.constant"() <{value = 0 : index}> : () -> index
            %744 = "arith.constant"() <{value = 32 : index}> : () -> index
            %745 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%743, %744, %745) ({
            ^bb0(%arg313: index):
              %746 = "arith.constant"() <{value = 128 : index}> : () -> index
              %747 = "arith.constant"() <{value = 129 : index}> : () -> index
              %748 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%746, %747, %748) ({
              ^bb0(%arg314: index):
                %749 = "arith.constant"() <{value = 8 : index}> : () -> index
                %750 = "arith.subi"(%arg312, %749) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %751 = "arith.constant"() <{value = 128 : index}> : () -> index
                %752 = "arith.subi"(%arg314, %751) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %753 = "memref.load"(%732, %750, %752) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %754 = "arith.constant"() <{value = 128 : index}> : () -> index
                %755 = "arith.subi"(%arg314, %754) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %756 = "memref.load"(%734, %755, %arg313) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %757 = "arith.constant"() <{value = 8 : index}> : () -> index
                %758 = "arith.subi"(%arg312, %757) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %759 = "memref.load"(%723, %758, %arg313) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %760 = "arith.mulf"(%753, %756) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %761 = "arith.addf"(%759, %760) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %762 = "arith.constant"() <{value = 8 : index}> : () -> index
                %763 = "arith.subi"(%arg312, %762) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%761, %723, %763, %arg313) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %740 = "air.wait_all"(%731) : (!air.async.token) -> !air.async.token
          %741 = "air.dma_memcpy_nd"(%740, %arg311, %723) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 28 : i64, orbit.retained_begin = 24 : i64, orbit.retained_end = 29 : i64, orbit.source_copies = array<i64: 96>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 97>, orbit.transfer = "l1_to_host", orbit.transfer_event = 67 : i64, static_dst_offsets = array<i64: 8, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %742 = "air.wait_all"(%741) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%742) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_24"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%716) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_24"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_24"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg262: index, %arg263: index, %arg264: index, %arg265: index, %arg266: memref<17x129xf32>, %arg267: memref<129x80xf32>, %arg268: memref<17x80xf32>, %arg269: memref<17x80xf32>):
      "air.segment"(%arg266, %arg267, %arg268, %arg269) ({
      ^bb0(%arg270: memref<17x129xf32>, %arg271: memref<129x80xf32>, %arg272: memref<17x80xf32>, %arg273: memref<17x80xf32>):
        %608 = "arith.constant"() <{value = 1 : index}> : () -> index
        %609 = "air.herd"(%608, %608, %arg270, %arg271, %arg272, %arg273) ({
        ^bb0(%arg274: index, %arg275: index, %arg276: index, %arg277: index, %arg278: memref<17x129xf32>, %arg279: memref<129x80xf32>, %arg280: memref<17x80xf32>, %arg281: memref<17x80xf32>):
          %610 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %611 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %612 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %613 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %614 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %615 = "air.wait_all"() : () -> !air.async.token
          %616 = "memref.reinterpret_cast"(%614) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 29 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %617 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %618 = "arith.constant"() <{value = 8 : index}> : () -> index
          %619 = "arith.constant"() <{value = 16 : index}> : () -> index
          %620 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%618, %619, %620) ({
          ^bb0(%arg290: index):
            %708 = "arith.constant"() <{value = 32 : index}> : () -> index
            %709 = "arith.constant"() <{value = 64 : index}> : () -> index
            %710 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%708, %709, %710) ({
            ^bb0(%arg291: index):
              %711 = "arith.constant"() <{value = 8 : index}> : () -> index
              %712 = "arith.subi"(%arg290, %711) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %713 = "arith.constant"() <{value = 32 : index}> : () -> index
              %714 = "arith.subi"(%arg291, %713) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%617, %616, %712, %714) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %621 = "arith.constant"() <{value = 0 : index}> : () -> index
          %622 = "arith.constant"() <{value = 4 : index}> : () -> index
          %623 = "arith.constant"() <{value = 1 : index}> : () -> index
          %624 = "scf.for"(%621, %622, %623, %615) ({
          ^bb0(%arg285: index, %arg286: !air.async.token):
            %663 = "arith.constant"() <{value = 32 : index}> : () -> index
            %664 = "arith.muli"(%arg285, %663) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %665 = "arith.constant"() <{value = 32 : index}> : () -> index
            %666 = "arith.muli"(%arg285, %665) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %667 = "arith.constant"() <{value = 32 : index}> : () -> index
            %668 = "arith.muli"(%arg285, %667) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %669 = "memref.reinterpret_cast"(%611) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 29 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %670 = "arith.constant"() <{value = 0 : index}> : () -> index
            %671 = "arith.addi"(%670, %666) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %672 = "air.dma_memcpy_nd"(%arg286, %669, %arg278, %671) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 29 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "A", orbit.target_copies = array<i64: 98>, orbit.transfer = "host_to_l1", orbit.transfer_event = 68 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %673 = "memref.reinterpret_cast"(%613) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 29 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %674 = "arith.constant"() <{value = 0 : index}> : () -> index
            %675 = "arith.addi"(%674, %668) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %676 = "air.dma_memcpy_nd"(%arg286, %673, %arg279, %675) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 29 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 99>, orbit.transfer = "host_to_l1", orbit.transfer_event = 69 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%672, %676) {orbit.computation_event = 71 : i64, orbit.phase = 29 : i64, orbit.phase_dependencies = array<i64: 28>, orbit.read_copies = array<i64: 98, 99, 100>, orbit.task = "gemm", orbit.write_copies = array<i64: 101>} : (!air.async.token, !air.async.token) -> ()
            %677 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %678 = "arith.constant"() <{value = 8 : index}> : () -> index
            %679 = "arith.constant"() <{value = 16 : index}> : () -> index
            %680 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%678, %679, %680) ({
            ^bb0(%arg287: index):
              %682 = "arith.constant"() <{value = 32 : index}> : () -> index
              %683 = "arith.constant"() <{value = 64 : index}> : () -> index
              %684 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%682, %683, %684) ({
              ^bb0(%arg288: index):
                %685 = "arith.constant"() <{value = 0 : index}> : () -> index
                %686 = "arith.constant"() <{value = 32 : index}> : () -> index
                %687 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%685, %686, %687) ({
                ^bb0(%arg289: index):
                  %688 = "arith.addi"(%arg289, %664) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %689 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %690 = "arith.subi"(%arg287, %689) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %691 = "arith.subi"(%688, %666) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %692 = "memref.load"(%669, %690, %691) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %693 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %694 = "arith.subi"(%arg288, %693) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %695 = "arith.subi"(%688, %668) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %696 = "memref.load"(%673, %695, %694) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %697 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %698 = "arith.subi"(%arg287, %697) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %699 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %700 = "arith.subi"(%arg288, %699) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %701 = "memref.load"(%616, %698, %700) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %702 = "arith.mulf"(%692, %696) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %703 = "arith.addf"(%701, %702) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %704 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %705 = "arith.subi"(%arg287, %704) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %706 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %707 = "arith.subi"(%arg288, %706) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%703, %616, %705, %707) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %681 = "air.wait_all"(%arg286) : (!air.async.token) -> !air.async.token
            "scf.yield"(%681) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %625 = "memref.reinterpret_cast"(%610) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 33 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %626 = "air.dma_memcpy_nd"(%624, %625, %arg278) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 33 : i64, orbit.source_copies = array<i64: 9>, orbit.storage = "A", orbit.target_copies = array<i64: 111>, orbit.transfer = "host_to_l1", orbit.transfer_event = 81 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %627 = "memref.reinterpret_cast"(%612) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 33 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %628 = "air.dma_memcpy_nd"(%624, %627, %arg279) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 33 : i64, orbit.source_copies = array<i64: 28>, orbit.storage = "B", orbit.target_copies = array<i64: 112>, orbit.transfer = "host_to_l1", orbit.transfer_event = 82 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%626, %628) {orbit.computation_event = 83 : i64, orbit.phase = 33 : i64, orbit.phase_dependencies = array<i64: 32>, orbit.read_copies = array<i64: 111, 112, 110>, orbit.task = "gemm", orbit.write_copies = array<i64: 113>} : (!air.async.token, !air.async.token) -> ()
          %629 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %630 = "arith.constant"() <{value = 8 : index}> : () -> index
          %631 = "arith.constant"() <{value = 16 : index}> : () -> index
          %632 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%630, %631, %632) ({
          ^bb0(%arg282: index):
            %636 = "arith.constant"() <{value = 32 : index}> : () -> index
            %637 = "arith.constant"() <{value = 64 : index}> : () -> index
            %638 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%636, %637, %638) ({
            ^bb0(%arg283: index):
              %639 = "arith.constant"() <{value = 128 : index}> : () -> index
              %640 = "arith.constant"() <{value = 129 : index}> : () -> index
              %641 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%639, %640, %641) ({
              ^bb0(%arg284: index):
                %642 = "arith.constant"() <{value = 8 : index}> : () -> index
                %643 = "arith.subi"(%arg282, %642) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %644 = "arith.constant"() <{value = 128 : index}> : () -> index
                %645 = "arith.subi"(%arg284, %644) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %646 = "memref.load"(%625, %643, %645) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %647 = "arith.constant"() <{value = 128 : index}> : () -> index
                %648 = "arith.subi"(%arg284, %647) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %649 = "arith.constant"() <{value = 32 : index}> : () -> index
                %650 = "arith.subi"(%arg283, %649) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %651 = "memref.load"(%627, %648, %650) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %652 = "arith.constant"() <{value = 8 : index}> : () -> index
                %653 = "arith.subi"(%arg282, %652) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %654 = "arith.constant"() <{value = 32 : index}> : () -> index
                %655 = "arith.subi"(%arg283, %654) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %656 = "memref.load"(%616, %653, %655) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %657 = "arith.mulf"(%646, %651) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %658 = "arith.addf"(%656, %657) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %659 = "arith.constant"() <{value = 8 : index}> : () -> index
                %660 = "arith.subi"(%arg282, %659) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %661 = "arith.constant"() <{value = 32 : index}> : () -> index
                %662 = "arith.subi"(%arg283, %661) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%658, %616, %660, %662) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %633 = "air.wait_all"(%624) : (!air.async.token) -> !air.async.token
          %634 = "air.dma_memcpy_nd"(%633, %arg281, %616) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 33 : i64, orbit.retained_begin = 29 : i64, orbit.retained_end = 34 : i64, orbit.source_copies = array<i64: 113>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 114>, orbit.transfer = "l1_to_host", orbit.transfer_event = 84 : i64, static_dst_offsets = array<i64: 8, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %635 = "air.wait_all"(%634) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%635) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_29"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%609) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_29"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_29"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg232: index, %arg233: index, %arg234: index, %arg235: index, %arg236: memref<17x129xf32>, %arg237: memref<129x80xf32>, %arg238: memref<17x80xf32>, %arg239: memref<17x80xf32>):
      "air.segment"(%arg236, %arg237, %arg238, %arg239) ({
      ^bb0(%arg240: memref<17x129xf32>, %arg241: memref<129x80xf32>, %arg242: memref<17x80xf32>, %arg243: memref<17x80xf32>):
        %501 = "arith.constant"() <{value = 1 : index}> : () -> index
        %502 = "air.herd"(%501, %501, %arg240, %arg241, %arg242, %arg243) ({
        ^bb0(%arg244: index, %arg245: index, %arg246: index, %arg247: index, %arg248: memref<17x129xf32>, %arg249: memref<129x80xf32>, %arg250: memref<17x80xf32>, %arg251: memref<17x80xf32>):
          %503 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : () -> memref<8xf32, 2 : i32>
          %504 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %505 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : () -> memref<16xf32, 2 : i32>
          %506 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : () -> memref<512xf32, 2 : i32>
          %507 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %508 = "air.wait_all"() : () -> !air.async.token
          %509 = "memref.reinterpret_cast"(%507) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 34 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %510 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %511 = "arith.constant"() <{value = 8 : index}> : () -> index
          %512 = "arith.constant"() <{value = 16 : index}> : () -> index
          %513 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%511, %512, %513) ({
          ^bb0(%arg260: index):
            %601 = "arith.constant"() <{value = 64 : index}> : () -> index
            %602 = "arith.constant"() <{value = 80 : index}> : () -> index
            %603 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%601, %602, %603) ({
            ^bb0(%arg261: index):
              %604 = "arith.constant"() <{value = 8 : index}> : () -> index
              %605 = "arith.subi"(%arg260, %604) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %606 = "arith.constant"() <{value = 64 : index}> : () -> index
              %607 = "arith.subi"(%arg261, %606) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%510, %509, %605, %607) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %514 = "arith.constant"() <{value = 0 : index}> : () -> index
          %515 = "arith.constant"() <{value = 4 : index}> : () -> index
          %516 = "arith.constant"() <{value = 1 : index}> : () -> index
          %517 = "scf.for"(%514, %515, %516, %508) ({
          ^bb0(%arg255: index, %arg256: !air.async.token):
            %556 = "arith.constant"() <{value = 32 : index}> : () -> index
            %557 = "arith.muli"(%arg255, %556) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %558 = "arith.constant"() <{value = 32 : index}> : () -> index
            %559 = "arith.muli"(%arg255, %558) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %560 = "arith.constant"() <{value = 32 : index}> : () -> index
            %561 = "arith.muli"(%arg255, %560) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %562 = "memref.reinterpret_cast"(%504) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 34 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %563 = "arith.constant"() <{value = 0 : index}> : () -> index
            %564 = "arith.addi"(%563, %559) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %565 = "air.dma_memcpy_nd"(%arg256, %562, %arg248, %564) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 34 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "A", orbit.target_copies = array<i64: 115>, orbit.transfer = "host_to_l1", orbit.transfer_event = 85 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %566 = "memref.reinterpret_cast"(%506) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 34 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %567 = "arith.constant"() <{value = 0 : index}> : () -> index
            %568 = "arith.addi"(%567, %561) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %569 = "air.dma_memcpy_nd"(%arg256, %566, %arg249, %568) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 34 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "B", orbit.target_copies = array<i64: 116>, orbit.transfer = "host_to_l1", orbit.transfer_event = 86 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%565, %569) {orbit.computation_event = 88 : i64, orbit.phase = 34 : i64, orbit.phase_dependencies = array<i64: 33>, orbit.read_copies = array<i64: 115, 116, 117>, orbit.task = "gemm", orbit.write_copies = array<i64: 118>} : (!air.async.token, !air.async.token) -> ()
            %570 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %571 = "arith.constant"() <{value = 8 : index}> : () -> index
            %572 = "arith.constant"() <{value = 16 : index}> : () -> index
            %573 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%571, %572, %573) ({
            ^bb0(%arg257: index):
              %575 = "arith.constant"() <{value = 64 : index}> : () -> index
              %576 = "arith.constant"() <{value = 80 : index}> : () -> index
              %577 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%575, %576, %577) ({
              ^bb0(%arg258: index):
                %578 = "arith.constant"() <{value = 0 : index}> : () -> index
                %579 = "arith.constant"() <{value = 32 : index}> : () -> index
                %580 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%578, %579, %580) ({
                ^bb0(%arg259: index):
                  %581 = "arith.addi"(%arg259, %557) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %582 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %583 = "arith.subi"(%arg257, %582) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %584 = "arith.subi"(%581, %559) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %585 = "memref.load"(%562, %583, %584) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %586 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %587 = "arith.subi"(%arg258, %586) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %588 = "arith.subi"(%581, %561) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %589 = "memref.load"(%566, %588, %587) <{nontemporal = false}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %590 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %591 = "arith.subi"(%arg257, %590) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %592 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %593 = "arith.subi"(%arg258, %592) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %594 = "memref.load"(%509, %591, %593) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %595 = "arith.mulf"(%585, %589) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %596 = "arith.addf"(%594, %595) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %597 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %598 = "arith.subi"(%arg257, %597) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %599 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %600 = "arith.subi"(%arg258, %599) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%596, %509, %598, %600) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %574 = "air.wait_all"(%arg256) : (!air.async.token) -> !air.async.token
            "scf.yield"(%574) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %518 = "memref.reinterpret_cast"(%503) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 38 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %519 = "air.dma_memcpy_nd"(%517, %518, %arg248) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 38 : i64, orbit.source_copies = array<i64: 9>, orbit.storage = "A", orbit.target_copies = array<i64: 128>, orbit.transfer = "host_to_l1", orbit.transfer_event = 98 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<8x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %520 = "memref.reinterpret_cast"(%505) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 38 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %521 = "air.dma_memcpy_nd"(%517, %520, %arg249) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 38 : i64, orbit.source_copies = array<i64: 29>, orbit.storage = "B", orbit.target_copies = array<i64: 129>, orbit.transfer = "host_to_l1", orbit.transfer_event = 99 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%519, %521) {orbit.computation_event = 100 : i64, orbit.phase = 38 : i64, orbit.phase_dependencies = array<i64: 37>, orbit.read_copies = array<i64: 128, 129, 127>, orbit.task = "gemm", orbit.write_copies = array<i64: 130>} : (!air.async.token, !air.async.token) -> ()
          %522 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %523 = "arith.constant"() <{value = 8 : index}> : () -> index
          %524 = "arith.constant"() <{value = 16 : index}> : () -> index
          %525 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%523, %524, %525) ({
          ^bb0(%arg252: index):
            %529 = "arith.constant"() <{value = 64 : index}> : () -> index
            %530 = "arith.constant"() <{value = 80 : index}> : () -> index
            %531 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%529, %530, %531) ({
            ^bb0(%arg253: index):
              %532 = "arith.constant"() <{value = 128 : index}> : () -> index
              %533 = "arith.constant"() <{value = 129 : index}> : () -> index
              %534 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%532, %533, %534) ({
              ^bb0(%arg254: index):
                %535 = "arith.constant"() <{value = 8 : index}> : () -> index
                %536 = "arith.subi"(%arg252, %535) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %537 = "arith.constant"() <{value = 128 : index}> : () -> index
                %538 = "arith.subi"(%arg254, %537) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %539 = "memref.load"(%518, %536, %538) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %540 = "arith.constant"() <{value = 128 : index}> : () -> index
                %541 = "arith.subi"(%arg254, %540) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %542 = "arith.constant"() <{value = 64 : index}> : () -> index
                %543 = "arith.subi"(%arg253, %542) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %544 = "memref.load"(%520, %541, %543) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %545 = "arith.constant"() <{value = 8 : index}> : () -> index
                %546 = "arith.subi"(%arg252, %545) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %547 = "arith.constant"() <{value = 64 : index}> : () -> index
                %548 = "arith.subi"(%arg253, %547) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %549 = "memref.load"(%509, %546, %548) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %550 = "arith.mulf"(%539, %544) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %551 = "arith.addf"(%549, %550) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %552 = "arith.constant"() <{value = 8 : index}> : () -> index
                %553 = "arith.subi"(%arg252, %552) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %554 = "arith.constant"() <{value = 64 : index}> : () -> index
                %555 = "arith.subi"(%arg253, %554) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%551, %509, %553, %555) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %526 = "air.wait_all"(%517) : (!air.async.token) -> !air.async.token
          %527 = "air.dma_memcpy_nd"(%526, %arg251, %509) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 38 : i64, orbit.retained_begin = 34 : i64, orbit.retained_end = 39 : i64, orbit.source_copies = array<i64: 130>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 131>, orbit.transfer = "l1_to_host", orbit.transfer_event = 101 : i64, static_dst_offsets = array<i64: 8, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %528 = "air.wait_all"(%527) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%528) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_34"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%502) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_34"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_34"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg202: index, %arg203: index, %arg204: index, %arg205: index, %arg206: memref<17x129xf32>, %arg207: memref<129x80xf32>, %arg208: memref<17x80xf32>, %arg209: memref<17x80xf32>):
      "air.segment"(%arg206, %arg207, %arg208, %arg209) ({
      ^bb0(%arg210: memref<17x129xf32>, %arg211: memref<129x80xf32>, %arg212: memref<17x80xf32>, %arg213: memref<17x80xf32>):
        %408 = "arith.constant"() <{value = 1 : index}> : () -> index
        %409 = "air.herd"(%408, %408, %arg210, %arg211, %arg212, %arg213) ({
        ^bb0(%arg214: index, %arg215: index, %arg216: index, %arg217: index, %arg218: memref<17x129xf32>, %arg219: memref<129x80xf32>, %arg220: memref<17x80xf32>, %arg221: memref<17x80xf32>):
          %410 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : () -> memref<1xf32, 2 : i32>
          %411 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : () -> memref<32xf32, 2 : i32>
          %412 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : () -> memref<32xf32, 2 : i32>
          %413 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : () -> memref<1024xf32, 2 : i32>
          %414 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<32xf32, 2 : i32>
          %415 = "air.wait_all"() : () -> !air.async.token
          %416 = "memref.reinterpret_cast"(%414) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 39 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %417 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %418 = "arith.constant"() <{value = 16 : index}> : () -> index
          %419 = "arith.constant"() <{value = 17 : index}> : () -> index
          %420 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%418, %419, %420) ({
          ^bb0(%arg230: index):
            %496 = "arith.constant"() <{value = 0 : index}> : () -> index
            %497 = "arith.constant"() <{value = 32 : index}> : () -> index
            %498 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%496, %497, %498) ({
            ^bb0(%arg231: index):
              %499 = "arith.constant"() <{value = 16 : index}> : () -> index
              %500 = "arith.subi"(%arg230, %499) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%417, %416, %500, %arg231) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %421 = "arith.constant"() <{value = 0 : index}> : () -> index
          %422 = "arith.constant"() <{value = 4 : index}> : () -> index
          %423 = "arith.constant"() <{value = 1 : index}> : () -> index
          %424 = "scf.for"(%421, %422, %423, %415) ({
          ^bb0(%arg225: index, %arg226: !air.async.token):
            %457 = "arith.constant"() <{value = 32 : index}> : () -> index
            %458 = "arith.muli"(%arg225, %457) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %459 = "arith.constant"() <{value = 32 : index}> : () -> index
            %460 = "arith.muli"(%arg225, %459) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %461 = "arith.constant"() <{value = 32 : index}> : () -> index
            %462 = "arith.muli"(%arg225, %461) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %463 = "memref.reinterpret_cast"(%411) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 39 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %464 = "arith.constant"() <{value = 0 : index}> : () -> index
            %465 = "arith.addi"(%464, %460) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %466 = "air.dma_memcpy_nd"(%arg226, %463, %arg218, %465) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 39 : i64, orbit.source_copies = array<i64: 10>, orbit.storage = "A", orbit.target_copies = array<i64: 132>, orbit.transfer = "host_to_l1", orbit.transfer_event = 102 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %467 = "memref.reinterpret_cast"(%413) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 39 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %468 = "arith.constant"() <{value = 0 : index}> : () -> index
            %469 = "arith.addi"(%468, %462) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %470 = "air.dma_memcpy_nd"(%arg226, %467, %arg219, %469) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 39 : i64, orbit.source_copies = array<i64: 15>, orbit.storage = "B", orbit.target_copies = array<i64: 133>, orbit.transfer = "host_to_l1", orbit.transfer_event = 103 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%466, %470) {orbit.computation_event = 105 : i64, orbit.phase = 39 : i64, orbit.phase_dependencies = array<i64: 38>, orbit.read_copies = array<i64: 132, 133, 134>, orbit.task = "gemm", orbit.write_copies = array<i64: 135>} : (!air.async.token, !air.async.token) -> ()
            %471 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %472 = "arith.constant"() <{value = 16 : index}> : () -> index
            %473 = "arith.constant"() <{value = 17 : index}> : () -> index
            %474 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%472, %473, %474) ({
            ^bb0(%arg227: index):
              %476 = "arith.constant"() <{value = 0 : index}> : () -> index
              %477 = "arith.constant"() <{value = 32 : index}> : () -> index
              %478 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%476, %477, %478) ({
              ^bb0(%arg228: index):
                %479 = "arith.constant"() <{value = 0 : index}> : () -> index
                %480 = "arith.constant"() <{value = 32 : index}> : () -> index
                %481 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%479, %480, %481) ({
                ^bb0(%arg229: index):
                  %482 = "arith.addi"(%arg229, %458) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %483 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %484 = "arith.subi"(%arg227, %483) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %485 = "arith.subi"(%482, %460) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %486 = "memref.load"(%463, %484, %485) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %487 = "arith.subi"(%482, %462) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %488 = "memref.load"(%467, %487, %arg228) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %489 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %490 = "arith.subi"(%arg227, %489) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %491 = "memref.load"(%416, %490, %arg228) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %492 = "arith.mulf"(%486, %488) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %493 = "arith.addf"(%491, %492) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %494 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %495 = "arith.subi"(%arg227, %494) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%493, %416, %495, %arg228) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %475 = "air.wait_all"(%arg226) : (!air.async.token) -> !air.async.token
            "scf.yield"(%475) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %425 = "memref.reinterpret_cast"(%410) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 43 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %426 = "air.dma_memcpy_nd"(%424, %425, %arg218) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 43 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "A", orbit.target_copies = array<i64: 145>, orbit.transfer = "host_to_l1", orbit.transfer_event = 115 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %427 = "memref.reinterpret_cast"(%412) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 43 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %428 = "air.dma_memcpy_nd"(%424, %427, %arg219) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 43 : i64, orbit.source_copies = array<i64: 27>, orbit.storage = "B", orbit.target_copies = array<i64: 146>, orbit.transfer = "host_to_l1", orbit.transfer_event = 116 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%426, %428) {orbit.computation_event = 117 : i64, orbit.phase = 43 : i64, orbit.phase_dependencies = array<i64: 42>, orbit.read_copies = array<i64: 145, 146, 144>, orbit.task = "gemm", orbit.write_copies = array<i64: 147>} : (!air.async.token, !air.async.token) -> ()
          %429 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %430 = "arith.constant"() <{value = 16 : index}> : () -> index
          %431 = "arith.constant"() <{value = 17 : index}> : () -> index
          %432 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%430, %431, %432) ({
          ^bb0(%arg222: index):
            %436 = "arith.constant"() <{value = 0 : index}> : () -> index
            %437 = "arith.constant"() <{value = 32 : index}> : () -> index
            %438 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%436, %437, %438) ({
            ^bb0(%arg223: index):
              %439 = "arith.constant"() <{value = 128 : index}> : () -> index
              %440 = "arith.constant"() <{value = 129 : index}> : () -> index
              %441 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%439, %440, %441) ({
              ^bb0(%arg224: index):
                %442 = "arith.constant"() <{value = 16 : index}> : () -> index
                %443 = "arith.subi"(%arg222, %442) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %444 = "arith.constant"() <{value = 128 : index}> : () -> index
                %445 = "arith.subi"(%arg224, %444) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %446 = "memref.load"(%425, %443, %445) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %447 = "arith.constant"() <{value = 128 : index}> : () -> index
                %448 = "arith.subi"(%arg224, %447) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %449 = "memref.load"(%427, %448, %arg223) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %450 = "arith.constant"() <{value = 16 : index}> : () -> index
                %451 = "arith.subi"(%arg222, %450) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %452 = "memref.load"(%416, %451, %arg223) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %453 = "arith.mulf"(%446, %449) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %454 = "arith.addf"(%452, %453) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %455 = "arith.constant"() <{value = 16 : index}> : () -> index
                %456 = "arith.subi"(%arg222, %455) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%454, %416, %456, %arg223) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %433 = "air.wait_all"(%424) : (!air.async.token) -> !air.async.token
          %434 = "air.dma_memcpy_nd"(%433, %arg221, %416) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 43 : i64, orbit.retained_begin = 39 : i64, orbit.retained_end = 44 : i64, orbit.source_copies = array<i64: 147>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 148>, orbit.transfer = "l1_to_host", orbit.transfer_event = 118 : i64, static_dst_offsets = array<i64: 16, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %435 = "air.wait_all"(%434) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%435) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_39"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%409) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_39"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_39"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg172: index, %arg173: index, %arg174: index, %arg175: index, %arg176: memref<17x129xf32>, %arg177: memref<129x80xf32>, %arg178: memref<17x80xf32>, %arg179: memref<17x80xf32>):
      "air.segment"(%arg176, %arg177, %arg178, %arg179) ({
      ^bb0(%arg180: memref<17x129xf32>, %arg181: memref<129x80xf32>, %arg182: memref<17x80xf32>, %arg183: memref<17x80xf32>):
        %301 = "arith.constant"() <{value = 1 : index}> : () -> index
        %302 = "air.herd"(%301, %301, %arg180, %arg181, %arg182, %arg183) ({
        ^bb0(%arg184: index, %arg185: index, %arg186: index, %arg187: index, %arg188: memref<17x129xf32>, %arg189: memref<129x80xf32>, %arg190: memref<17x80xf32>, %arg191: memref<17x80xf32>):
          %303 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : () -> memref<1xf32, 2 : i32>
          %304 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : () -> memref<32xf32, 2 : i32>
          %305 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : () -> memref<32xf32, 2 : i32>
          %306 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : () -> memref<1024xf32, 2 : i32>
          %307 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<32xf32, 2 : i32>
          %308 = "air.wait_all"() : () -> !air.async.token
          %309 = "memref.reinterpret_cast"(%307) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 44 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %310 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %311 = "arith.constant"() <{value = 16 : index}> : () -> index
          %312 = "arith.constant"() <{value = 17 : index}> : () -> index
          %313 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%311, %312, %313) ({
          ^bb0(%arg200: index):
            %401 = "arith.constant"() <{value = 32 : index}> : () -> index
            %402 = "arith.constant"() <{value = 64 : index}> : () -> index
            %403 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%401, %402, %403) ({
            ^bb0(%arg201: index):
              %404 = "arith.constant"() <{value = 16 : index}> : () -> index
              %405 = "arith.subi"(%arg200, %404) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %406 = "arith.constant"() <{value = 32 : index}> : () -> index
              %407 = "arith.subi"(%arg201, %406) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%310, %309, %405, %407) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %314 = "arith.constant"() <{value = 0 : index}> : () -> index
          %315 = "arith.constant"() <{value = 4 : index}> : () -> index
          %316 = "arith.constant"() <{value = 1 : index}> : () -> index
          %317 = "scf.for"(%314, %315, %316, %308) ({
          ^bb0(%arg195: index, %arg196: !air.async.token):
            %356 = "arith.constant"() <{value = 32 : index}> : () -> index
            %357 = "arith.muli"(%arg195, %356) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %358 = "arith.constant"() <{value = 32 : index}> : () -> index
            %359 = "arith.muli"(%arg195, %358) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %360 = "arith.constant"() <{value = 32 : index}> : () -> index
            %361 = "arith.muli"(%arg195, %360) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %362 = "memref.reinterpret_cast"(%304) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 44 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %363 = "arith.constant"() <{value = 0 : index}> : () -> index
            %364 = "arith.addi"(%363, %359) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %365 = "air.dma_memcpy_nd"(%arg196, %362, %arg188, %364) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 44 : i64, orbit.source_copies = array<i64: 10>, orbit.storage = "A", orbit.target_copies = array<i64: 149>, orbit.transfer = "host_to_l1", orbit.transfer_event = 119 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %366 = "memref.reinterpret_cast"(%306) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 44 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %367 = "arith.constant"() <{value = 0 : index}> : () -> index
            %368 = "arith.addi"(%367, %361) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %369 = "air.dma_memcpy_nd"(%arg196, %366, %arg189, %368) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 44 : i64, orbit.source_copies = array<i64: 16>, orbit.storage = "B", orbit.target_copies = array<i64: 150>, orbit.transfer = "host_to_l1", orbit.transfer_event = 120 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%365, %369) {orbit.computation_event = 122 : i64, orbit.phase = 44 : i64, orbit.phase_dependencies = array<i64: 43>, orbit.read_copies = array<i64: 149, 150, 151>, orbit.task = "gemm", orbit.write_copies = array<i64: 152>} : (!air.async.token, !air.async.token) -> ()
            %370 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %371 = "arith.constant"() <{value = 16 : index}> : () -> index
            %372 = "arith.constant"() <{value = 17 : index}> : () -> index
            %373 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%371, %372, %373) ({
            ^bb0(%arg197: index):
              %375 = "arith.constant"() <{value = 32 : index}> : () -> index
              %376 = "arith.constant"() <{value = 64 : index}> : () -> index
              %377 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%375, %376, %377) ({
              ^bb0(%arg198: index):
                %378 = "arith.constant"() <{value = 0 : index}> : () -> index
                %379 = "arith.constant"() <{value = 32 : index}> : () -> index
                %380 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%378, %379, %380) ({
                ^bb0(%arg199: index):
                  %381 = "arith.addi"(%arg199, %357) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %382 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %383 = "arith.subi"(%arg197, %382) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %384 = "arith.subi"(%381, %359) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %385 = "memref.load"(%362, %383, %384) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %386 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %387 = "arith.subi"(%arg198, %386) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %388 = "arith.subi"(%381, %361) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %389 = "memref.load"(%366, %388, %387) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %390 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %391 = "arith.subi"(%arg197, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %392 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %393 = "arith.subi"(%arg198, %392) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %394 = "memref.load"(%309, %391, %393) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %395 = "arith.mulf"(%385, %389) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %396 = "arith.addf"(%394, %395) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %397 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %398 = "arith.subi"(%arg197, %397) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %399 = "arith.constant"() <{value = 32 : index}> : () -> index
                  %400 = "arith.subi"(%arg198, %399) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%396, %309, %398, %400) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %374 = "air.wait_all"(%arg196) : (!air.async.token) -> !air.async.token
            "scf.yield"(%374) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %318 = "memref.reinterpret_cast"(%303) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 48 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %319 = "air.dma_memcpy_nd"(%317, %318, %arg188) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 48 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "A", orbit.target_copies = array<i64: 162>, orbit.transfer = "host_to_l1", orbit.transfer_event = 132 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %320 = "memref.reinterpret_cast"(%305) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 48 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %321 = "air.dma_memcpy_nd"(%317, %320, %arg189) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 48 : i64, orbit.source_copies = array<i64: 28>, orbit.storage = "B", orbit.target_copies = array<i64: 163>, orbit.transfer = "host_to_l1", orbit.transfer_event = 133 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%319, %321) {orbit.computation_event = 134 : i64, orbit.phase = 48 : i64, orbit.phase_dependencies = array<i64: 47>, orbit.read_copies = array<i64: 162, 163, 161>, orbit.task = "gemm", orbit.write_copies = array<i64: 164>} : (!air.async.token, !air.async.token) -> ()
          %322 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %323 = "arith.constant"() <{value = 16 : index}> : () -> index
          %324 = "arith.constant"() <{value = 17 : index}> : () -> index
          %325 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%323, %324, %325) ({
          ^bb0(%arg192: index):
            %329 = "arith.constant"() <{value = 32 : index}> : () -> index
            %330 = "arith.constant"() <{value = 64 : index}> : () -> index
            %331 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%329, %330, %331) ({
            ^bb0(%arg193: index):
              %332 = "arith.constant"() <{value = 128 : index}> : () -> index
              %333 = "arith.constant"() <{value = 129 : index}> : () -> index
              %334 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%332, %333, %334) ({
              ^bb0(%arg194: index):
                %335 = "arith.constant"() <{value = 16 : index}> : () -> index
                %336 = "arith.subi"(%arg192, %335) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %337 = "arith.constant"() <{value = 128 : index}> : () -> index
                %338 = "arith.subi"(%arg194, %337) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %339 = "memref.load"(%318, %336, %338) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %340 = "arith.constant"() <{value = 128 : index}> : () -> index
                %341 = "arith.subi"(%arg194, %340) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %342 = "arith.constant"() <{value = 32 : index}> : () -> index
                %343 = "arith.subi"(%arg193, %342) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %344 = "memref.load"(%320, %341, %343) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %345 = "arith.constant"() <{value = 16 : index}> : () -> index
                %346 = "arith.subi"(%arg192, %345) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %347 = "arith.constant"() <{value = 32 : index}> : () -> index
                %348 = "arith.subi"(%arg193, %347) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %349 = "memref.load"(%309, %346, %348) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %350 = "arith.mulf"(%339, %344) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %351 = "arith.addf"(%349, %350) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %352 = "arith.constant"() <{value = 16 : index}> : () -> index
                %353 = "arith.subi"(%arg192, %352) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %354 = "arith.constant"() <{value = 32 : index}> : () -> index
                %355 = "arith.subi"(%arg193, %354) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%351, %309, %353, %355) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %326 = "air.wait_all"(%317) : (!air.async.token) -> !air.async.token
          %327 = "air.dma_memcpy_nd"(%326, %arg191, %309) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 48 : i64, orbit.retained_begin = 44 : i64, orbit.retained_end = 49 : i64, orbit.source_copies = array<i64: 164>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 165>, orbit.transfer = "l1_to_host", orbit.transfer_event = 135 : i64, static_dst_offsets = array<i64: 16, 32>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          %328 = "air.wait_all"(%327) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%328) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_44"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%302) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_44"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_44"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg142: index, %arg143: index, %arg144: index, %arg145: index, %arg146: memref<17x129xf32>, %arg147: memref<129x80xf32>, %arg148: memref<17x80xf32>, %arg149: memref<17x80xf32>):
      "air.segment"(%arg146, %arg147, %arg148, %arg149) ({
      ^bb0(%arg150: memref<17x129xf32>, %arg151: memref<129x80xf32>, %arg152: memref<17x80xf32>, %arg153: memref<17x80xf32>):
        %194 = "arith.constant"() <{value = 1 : index}> : () -> index
        %195 = "air.herd"(%194, %194, %arg150, %arg151, %arg152, %arg153) ({
        ^bb0(%arg154: index, %arg155: index, %arg156: index, %arg157: index, %arg158: memref<17x129xf32>, %arg159: memref<129x80xf32>, %arg160: memref<17x80xf32>, %arg161: memref<17x80xf32>):
          %196 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.16.1"} : () -> memref<1xf32, 2 : i32>
          %197 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.16.32"} : () -> memref<32xf32, 2 : i32>
          %198 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.1.16.1"} : () -> memref<16xf32, 2 : i32>
          %199 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.1.16.32"} : () -> memref<512xf32, 2 : i32>
          %200 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<16xf32, 2 : i32>
          %201 = "air.wait_all"() : () -> !air.async.token
          %202 = "memref.reinterpret_cast"(%200) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 49 : i64, orbit.storage = "intermediate"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %203 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %204 = "arith.constant"() <{value = 16 : index}> : () -> index
          %205 = "arith.constant"() <{value = 17 : index}> : () -> index
          %206 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%204, %205, %206) ({
          ^bb0(%arg170: index):
            %294 = "arith.constant"() <{value = 64 : index}> : () -> index
            %295 = "arith.constant"() <{value = 80 : index}> : () -> index
            %296 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%294, %295, %296) ({
            ^bb0(%arg171: index):
              %297 = "arith.constant"() <{value = 16 : index}> : () -> index
              %298 = "arith.subi"(%arg170, %297) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %299 = "arith.constant"() <{value = 64 : index}> : () -> index
              %300 = "arith.subi"(%arg171, %299) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%203, %202, %298, %300) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %207 = "arith.constant"() <{value = 0 : index}> : () -> index
          %208 = "arith.constant"() <{value = 4 : index}> : () -> index
          %209 = "arith.constant"() <{value = 1 : index}> : () -> index
          %210 = "scf.for"(%207, %208, %209, %201) ({
          ^bb0(%arg165: index, %arg166: !air.async.token):
            %249 = "arith.constant"() <{value = 32 : index}> : () -> index
            %250 = "arith.muli"(%arg165, %249) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %251 = "arith.constant"() <{value = 32 : index}> : () -> index
            %252 = "arith.muli"(%arg165, %251) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %253 = "arith.constant"() <{value = 32 : index}> : () -> index
            %254 = "arith.muli"(%arg165, %253) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %255 = "memref.reinterpret_cast"(%197) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 49 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %256 = "arith.constant"() <{value = 0 : index}> : () -> index
            %257 = "arith.addi"(%256, %252) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %258 = "air.dma_memcpy_nd"(%arg166, %255, %arg158, %257) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 49 : i64, orbit.source_copies = array<i64: 10>, orbit.storage = "A", orbit.target_copies = array<i64: 166>, orbit.transfer = "host_to_l1", orbit.transfer_event = 136 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x129xf32>, index) -> !air.async.token
            %259 = "memref.reinterpret_cast"(%199) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 49 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %260 = "arith.constant"() <{value = 0 : index}> : () -> index
            %261 = "arith.addi"(%260, %254) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %262 = "air.dma_memcpy_nd"(%arg166, %259, %arg159, %261) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 49 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "B", orbit.target_copies = array<i64: 167>, orbit.transfer = "host_to_l1", orbit.transfer_event = 137 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<32x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>, index) -> !air.async.token
            "air.wait_all"(%258, %262) {orbit.computation_event = 139 : i64, orbit.phase = 49 : i64, orbit.phase_dependencies = array<i64: 48>, orbit.read_copies = array<i64: 166, 167, 168>, orbit.task = "gemm", orbit.write_copies = array<i64: 169>} : (!air.async.token, !air.async.token) -> ()
            %263 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %264 = "arith.constant"() <{value = 16 : index}> : () -> index
            %265 = "arith.constant"() <{value = 17 : index}> : () -> index
            %266 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%264, %265, %266) ({
            ^bb0(%arg167: index):
              %268 = "arith.constant"() <{value = 64 : index}> : () -> index
              %269 = "arith.constant"() <{value = 80 : index}> : () -> index
              %270 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%268, %269, %270) ({
              ^bb0(%arg168: index):
                %271 = "arith.constant"() <{value = 0 : index}> : () -> index
                %272 = "arith.constant"() <{value = 32 : index}> : () -> index
                %273 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%271, %272, %273) ({
                ^bb0(%arg169: index):
                  %274 = "arith.addi"(%arg169, %250) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %275 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %276 = "arith.subi"(%arg167, %275) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %277 = "arith.subi"(%274, %252) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %278 = "memref.load"(%255, %276, %277) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %279 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %280 = "arith.subi"(%arg168, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %281 = "arith.subi"(%274, %254) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %282 = "memref.load"(%259, %281, %280) <{nontemporal = false}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %283 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %284 = "arith.subi"(%arg167, %283) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %285 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %286 = "arith.subi"(%arg168, %285) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %287 = "memref.load"(%202, %284, %286) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                  %288 = "arith.mulf"(%278, %282) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %289 = "arith.addf"(%287, %288) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %290 = "arith.constant"() <{value = 16 : index}> : () -> index
                  %291 = "arith.subi"(%arg167, %290) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %292 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %293 = "arith.subi"(%arg168, %292) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%289, %202, %291, %293) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %267 = "air.wait_all"(%arg166) : (!air.async.token) -> !air.async.token
            "scf.yield"(%267) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          %211 = "memref.reinterpret_cast"(%196) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 53 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %212 = "air.dma_memcpy_nd"(%210, %211, %arg158) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 53 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "A", orbit.target_copies = array<i64: 179>, orbit.transfer = "host_to_l1", orbit.transfer_event = 149 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 1>, static_dst_strides = array<i64: 1, 1>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>} : (!air.async.token, memref<1x1xf32, strided<[1, 1]>, 2 : i32>, memref<17x129xf32>) -> !air.async.token
          %213 = "memref.reinterpret_cast"(%198) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 53 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %214 = "air.dma_memcpy_nd"(%210, %213, %arg159) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 53 : i64, orbit.source_copies = array<i64: 29>, orbit.storage = "B", orbit.target_copies = array<i64: 180>, orbit.transfer = "host_to_l1", orbit.transfer_event = 150 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<129x80xf32>) -> !air.async.token
          "air.wait_all"(%212, %214) {orbit.computation_event = 151 : i64, orbit.phase = 53 : i64, orbit.phase_dependencies = array<i64: 52>, orbit.read_copies = array<i64: 179, 180, 178>, orbit.task = "gemm", orbit.write_copies = array<i64: 181>} : (!air.async.token, !air.async.token) -> ()
          %215 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %216 = "arith.constant"() <{value = 16 : index}> : () -> index
          %217 = "arith.constant"() <{value = 17 : index}> : () -> index
          %218 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%216, %217, %218) ({
          ^bb0(%arg162: index):
            %222 = "arith.constant"() <{value = 64 : index}> : () -> index
            %223 = "arith.constant"() <{value = 80 : index}> : () -> index
            %224 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%222, %223, %224) ({
            ^bb0(%arg163: index):
              %225 = "arith.constant"() <{value = 128 : index}> : () -> index
              %226 = "arith.constant"() <{value = 129 : index}> : () -> index
              %227 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%225, %226, %227) ({
              ^bb0(%arg164: index):
                %228 = "arith.constant"() <{value = 16 : index}> : () -> index
                %229 = "arith.subi"(%arg162, %228) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %230 = "arith.constant"() <{value = 128 : index}> : () -> index
                %231 = "arith.subi"(%arg164, %230) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %232 = "memref.load"(%211, %229, %231) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
                %233 = "arith.constant"() <{value = 128 : index}> : () -> index
                %234 = "arith.subi"(%arg164, %233) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %235 = "arith.constant"() <{value = 64 : index}> : () -> index
                %236 = "arith.subi"(%arg163, %235) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %237 = "memref.load"(%213, %234, %236) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %238 = "arith.constant"() <{value = 16 : index}> : () -> index
                %239 = "arith.subi"(%arg162, %238) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %240 = "arith.constant"() <{value = 64 : index}> : () -> index
                %241 = "arith.subi"(%arg163, %240) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %242 = "memref.load"(%202, %239, %241) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %243 = "arith.mulf"(%232, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %244 = "arith.addf"(%242, %243) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %245 = "arith.constant"() <{value = 16 : index}> : () -> index
                %246 = "arith.subi"(%arg162, %245) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %247 = "arith.constant"() <{value = 64 : index}> : () -> index
                %248 = "arith.subi"(%arg163, %247) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%244, %202, %246, %248) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %219 = "air.wait_all"(%210) : (!air.async.token) -> !air.async.token
          %220 = "air.dma_memcpy_nd"(%219, %arg161, %202) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 53 : i64, orbit.retained_begin = 49 : i64, orbit.retained_end = 54 : i64, orbit.source_copies = array<i64: 181>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 182>, orbit.transfer = "l1_to_host", orbit.transfer_event = 152 : i64, static_dst_offsets = array<i64: 16, 64>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %221 = "air.wait_all"(%220) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%221) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_49"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%195) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_49"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_49"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg118: index, %arg119: index, %arg120: index, %arg121: index, %arg122: memref<17x129xf32>, %arg123: memref<129x80xf32>, %arg124: memref<17x80xf32>, %arg125: memref<17x80xf32>):
      "air.segment"(%arg122, %arg123, %arg124, %arg125) ({
      ^bb0(%arg126: memref<17x129xf32>, %arg127: memref<129x80xf32>, %arg128: memref<17x80xf32>, %arg129: memref<17x80xf32>):
        %158 = "arith.constant"() <{value = 1 : index}> : () -> index
        %159 = "air.herd"(%158, %158, %arg126, %arg127, %arg128, %arg129) ({
        ^bb0(%arg130: index, %arg131: index, %arg132: index, %arg133: index, %arg134: memref<17x129xf32>, %arg135: memref<129x80xf32>, %arg136: memref<17x80xf32>, %arg137: memref<17x80xf32>):
          %160 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<256xf32, 2 : i32>
          %161 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : () -> memref<256xf32, 2 : i32>
          %162 = "air.wait_all"() : () -> !air.async.token
          %163 = "arith.constant"() <{value = 0 : index}> : () -> index
          %164 = "arith.constant"() <{value = 2 : index}> : () -> index
          %165 = "arith.constant"() <{value = 1 : index}> : () -> index
          %166 = "scf.for"(%163, %164, %165, %162) ({
          ^bb0(%arg138: index, %arg139: !air.async.token):
            %167 = "arith.constant"() <{value = 32 : index}> : () -> index
            %168 = "arith.muli"(%arg138, %167) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %169 = "arith.constant"() <{value = 32 : index}> : () -> index
            %170 = "arith.muli"(%arg138, %169) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %171 = "arith.constant"() <{value = 32 : index}> : () -> index
            %172 = "arith.muli"(%arg138, %171) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %173 = "memref.reinterpret_cast"(%160) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 54 : i64, orbit.storage = "Y"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %174 = "memref.reinterpret_cast"(%161) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 54 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %175 = "arith.constant"() <{value = 0 : index}> : () -> index
            %176 = "arith.addi"(%175, %172) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %177 = "air.dma_memcpy_nd"(%arg139, %174, %arg137, %176) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 54 : i64, orbit.source_copies = array<i64: 46>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 183>, orbit.transfer = "host_to_l1", orbit.transfer_event = 153 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x80xf32>, index) -> !air.async.token
            "air.wait_all"(%177) {orbit.computation_event = 154 : i64, orbit.phase = 54 : i64, orbit.phase_dependencies = array<i64: 53>, orbit.read_copies = array<i64: 183>, orbit.task = "scale", orbit.write_copies = array<i64: 184>} : (!air.async.token) -> ()
            %178 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
            %179 = "arith.constant"() <{value = 0 : index}> : () -> index
            %180 = "arith.constant"() <{value = 8 : index}> : () -> index
            %181 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%179, %180, %181) ({
            ^bb0(%arg140: index):
              %186 = "arith.constant"() <{value = 0 : index}> : () -> index
              %187 = "arith.constant"() <{value = 32 : index}> : () -> index
              %188 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%186, %187, %188) ({
              ^bb0(%arg141: index):
                %189 = "arith.addi"(%arg141, %168) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %190 = "arith.subi"(%189, %172) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %191 = "memref.load"(%174, %arg140, %190) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %192 = "arith.mulf"(%191, %178) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %193 = "arith.subi"(%189, %170) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%192, %173, %arg140, %193) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %182 = "arith.constant"() <{value = 0 : index}> : () -> index
            %183 = "arith.addi"(%182, %170) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %184 = "air.dma_memcpy_nd"(%arg139, %arg136, %183, %173) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 54 : i64, orbit.source_copies = array<i64: 184>, orbit.storage = "Y", orbit.target_copies = array<i64: 185>, orbit.transfer = "l1_to_host", orbit.transfer_event = 155 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %185 = "air.wait_all"(%184) : (!air.async.token) -> !air.async.token
            "scf.yield"(%185) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%166) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_54"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%159) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_54"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_54"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg96: index, %arg97: index, %arg98: index, %arg99: index, %arg100: memref<17x129xf32>, %arg101: memref<129x80xf32>, %arg102: memref<17x80xf32>, %arg103: memref<17x80xf32>):
      "air.segment"(%arg100, %arg101, %arg102, %arg103) ({
      ^bb0(%arg104: memref<17x129xf32>, %arg105: memref<129x80xf32>, %arg106: memref<17x80xf32>, %arg107: memref<17x80xf32>):
        %135 = "arith.constant"() <{value = 1 : index}> : () -> index
        %136 = "air.herd"(%135, %135, %arg104, %arg105, %arg106, %arg107) ({
        ^bb0(%arg108: index, %arg109: index, %arg110: index, %arg111: index, %arg112: memref<17x129xf32>, %arg113: memref<129x80xf32>, %arg114: memref<17x80xf32>, %arg115: memref<17x80xf32>):
          %137 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<128xf32, 2 : i32>
          %138 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : () -> memref<128xf32, 2 : i32>
          %139 = "air.wait_all"() : () -> !air.async.token
          %140 = "memref.reinterpret_cast"(%137) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 56 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %141 = "memref.reinterpret_cast"(%138) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 56 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %142 = "air.dma_memcpy_nd"(%139, %141, %arg115) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 56 : i64, orbit.source_copies = array<i64: 80>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 189>, orbit.transfer = "host_to_l1", orbit.transfer_event = 159 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 64>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, memref<17x80xf32>) -> !air.async.token
          "air.wait_all"(%142) {orbit.computation_event = 160 : i64, orbit.phase = 56 : i64, orbit.phase_dependencies = array<i64: 55>, orbit.read_copies = array<i64: 189>, orbit.task = "scale", orbit.write_copies = array<i64: 190>} : (!air.async.token) -> ()
          %143 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %144 = "arith.constant"() <{value = 0 : index}> : () -> index
          %145 = "arith.constant"() <{value = 8 : index}> : () -> index
          %146 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%144, %145, %146) ({
          ^bb0(%arg116: index):
            %149 = "arith.constant"() <{value = 64 : index}> : () -> index
            %150 = "arith.constant"() <{value = 80 : index}> : () -> index
            %151 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%149, %150, %151) ({
            ^bb0(%arg117: index):
              %152 = "arith.constant"() <{value = 64 : index}> : () -> index
              %153 = "arith.subi"(%arg117, %152) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %154 = "memref.load"(%141, %arg116, %153) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
              %155 = "arith.mulf"(%154, %143) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %156 = "arith.constant"() <{value = 64 : index}> : () -> index
              %157 = "arith.subi"(%arg117, %156) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%155, %140, %arg116, %157) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %147 = "air.dma_memcpy_nd"(%139, %arg114, %140) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 56 : i64, orbit.source_copies = array<i64: 190>, orbit.storage = "Y", orbit.target_copies = array<i64: 191>, orbit.transfer = "l1_to_host", orbit.transfer_event = 161 : i64, static_dst_offsets = array<i64: 0, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %148 = "air.wait_all"(%147) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%148) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_56"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%136) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_56"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_56"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg72: index, %arg73: index, %arg74: index, %arg75: index, %arg76: memref<17x129xf32>, %arg77: memref<129x80xf32>, %arg78: memref<17x80xf32>, %arg79: memref<17x80xf32>):
      "air.segment"(%arg76, %arg77, %arg78, %arg79) ({
      ^bb0(%arg80: memref<17x129xf32>, %arg81: memref<129x80xf32>, %arg82: memref<17x80xf32>, %arg83: memref<17x80xf32>):
        %95 = "arith.constant"() <{value = 1 : index}> : () -> index
        %96 = "air.herd"(%95, %95, %arg80, %arg81, %arg82, %arg83) ({
        ^bb0(%arg84: index, %arg85: index, %arg86: index, %arg87: index, %arg88: memref<17x129xf32>, %arg89: memref<129x80xf32>, %arg90: memref<17x80xf32>, %arg91: memref<17x80xf32>):
          %97 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<256xf32, 2 : i32>
          %98 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : () -> memref<256xf32, 2 : i32>
          %99 = "air.wait_all"() : () -> !air.async.token
          %100 = "arith.constant"() <{value = 0 : index}> : () -> index
          %101 = "arith.constant"() <{value = 2 : index}> : () -> index
          %102 = "arith.constant"() <{value = 1 : index}> : () -> index
          %103 = "scf.for"(%100, %101, %102, %99) ({
          ^bb0(%arg92: index, %arg93: !air.async.token):
            %104 = "arith.constant"() <{value = 32 : index}> : () -> index
            %105 = "arith.muli"(%arg92, %104) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %106 = "arith.constant"() <{value = 32 : index}> : () -> index
            %107 = "arith.muli"(%arg92, %106) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %108 = "arith.constant"() <{value = 32 : index}> : () -> index
            %109 = "arith.muli"(%arg92, %108) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %110 = "memref.reinterpret_cast"(%97) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 57 : i64, orbit.storage = "Y"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %111 = "memref.reinterpret_cast"(%98) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 57 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %112 = "arith.constant"() <{value = 0 : index}> : () -> index
            %113 = "arith.addi"(%112, %109) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %114 = "air.dma_memcpy_nd"(%arg93, %111, %arg91, %113) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 57 : i64, orbit.source_copies = array<i64: 97>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 192>, orbit.transfer = "host_to_l1", orbit.transfer_event = 162 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x80xf32>, index) -> !air.async.token
            "air.wait_all"(%114) {orbit.computation_event = 163 : i64, orbit.phase = 57 : i64, orbit.phase_dependencies = array<i64: 56>, orbit.read_copies = array<i64: 192>, orbit.task = "scale", orbit.write_copies = array<i64: 193>} : (!air.async.token) -> ()
            %115 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
            %116 = "arith.constant"() <{value = 8 : index}> : () -> index
            %117 = "arith.constant"() <{value = 16 : index}> : () -> index
            %118 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%116, %117, %118) ({
            ^bb0(%arg94: index):
              %123 = "arith.constant"() <{value = 0 : index}> : () -> index
              %124 = "arith.constant"() <{value = 32 : index}> : () -> index
              %125 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%123, %124, %125) ({
              ^bb0(%arg95: index):
                %126 = "arith.addi"(%arg95, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %127 = "arith.constant"() <{value = 8 : index}> : () -> index
                %128 = "arith.subi"(%arg94, %127) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %129 = "arith.subi"(%126, %109) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %130 = "memref.load"(%111, %128, %129) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %131 = "arith.mulf"(%130, %115) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %132 = "arith.constant"() <{value = 8 : index}> : () -> index
                %133 = "arith.subi"(%arg94, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %134 = "arith.subi"(%126, %107) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%131, %110, %133, %134) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %119 = "arith.constant"() <{value = 0 : index}> : () -> index
            %120 = "arith.addi"(%119, %107) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %121 = "air.dma_memcpy_nd"(%arg93, %arg90, %120, %110) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 57 : i64, orbit.source_copies = array<i64: 193>, orbit.storage = "Y", orbit.target_copies = array<i64: 194>, orbit.transfer = "l1_to_host", orbit.transfer_event = 164 : i64, static_dst_offsets = array<i64: 8, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, index, memref<8x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %122 = "air.wait_all"(%121) : (!air.async.token) -> !air.async.token
            "scf.yield"(%122) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%103) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_57"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%96) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_57"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_57"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg50: index, %arg51: index, %arg52: index, %arg53: index, %arg54: memref<17x129xf32>, %arg55: memref<129x80xf32>, %arg56: memref<17x80xf32>, %arg57: memref<17x80xf32>):
      "air.segment"(%arg54, %arg55, %arg56, %arg57) ({
      ^bb0(%arg58: memref<17x129xf32>, %arg59: memref<129x80xf32>, %arg60: memref<17x80xf32>, %arg61: memref<17x80xf32>):
        %68 = "arith.constant"() <{value = 1 : index}> : () -> index
        %69 = "air.herd"(%68, %68, %arg58, %arg59, %arg60, %arg61) ({
        ^bb0(%arg62: index, %arg63: index, %arg64: index, %arg65: index, %arg66: memref<17x129xf32>, %arg67: memref<129x80xf32>, %arg68: memref<17x80xf32>, %arg69: memref<17x80xf32>):
          %70 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<128xf32, 2 : i32>
          %71 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : () -> memref<128xf32, 2 : i32>
          %72 = "air.wait_all"() : () -> !air.async.token
          %73 = "memref.reinterpret_cast"(%70) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 59 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %74 = "memref.reinterpret_cast"(%71) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 59 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %75 = "air.dma_memcpy_nd"(%72, %74, %arg69) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 59 : i64, orbit.source_copies = array<i64: 131>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 198>, orbit.transfer = "host_to_l1", orbit.transfer_event = 168 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 8, 64>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, memref<17x80xf32>) -> !air.async.token
          "air.wait_all"(%75) {orbit.computation_event = 169 : i64, orbit.phase = 59 : i64, orbit.phase_dependencies = array<i64: 58>, orbit.read_copies = array<i64: 198>, orbit.task = "scale", orbit.write_copies = array<i64: 199>} : (!air.async.token) -> ()
          %76 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %77 = "arith.constant"() <{value = 8 : index}> : () -> index
          %78 = "arith.constant"() <{value = 16 : index}> : () -> index
          %79 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%77, %78, %79) ({
          ^bb0(%arg70: index):
            %82 = "arith.constant"() <{value = 64 : index}> : () -> index
            %83 = "arith.constant"() <{value = 80 : index}> : () -> index
            %84 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%82, %83, %84) ({
            ^bb0(%arg71: index):
              %85 = "arith.constant"() <{value = 8 : index}> : () -> index
              %86 = "arith.subi"(%arg70, %85) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %87 = "arith.constant"() <{value = 64 : index}> : () -> index
              %88 = "arith.subi"(%arg71, %87) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %89 = "memref.load"(%74, %86, %88) <{nontemporal = false}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
              %90 = "arith.mulf"(%89, %76) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %91 = "arith.constant"() <{value = 8 : index}> : () -> index
              %92 = "arith.subi"(%arg70, %91) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %93 = "arith.constant"() <{value = 64 : index}> : () -> index
              %94 = "arith.subi"(%arg71, %93) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%90, %73, %92, %94) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %80 = "air.dma_memcpy_nd"(%72, %arg68, %73) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 59 : i64, orbit.source_copies = array<i64: 199>, orbit.storage = "Y", orbit.target_copies = array<i64: 200>, orbit.transfer = "l1_to_host", orbit.transfer_event = 170 : i64, static_dst_offsets = array<i64: 8, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %81 = "air.wait_all"(%80) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%81) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_59"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%69) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_59"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_59"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg26: index, %arg27: index, %arg28: index, %arg29: index, %arg30: memref<17x129xf32>, %arg31: memref<129x80xf32>, %arg32: memref<17x80xf32>, %arg33: memref<17x80xf32>):
      "air.segment"(%arg30, %arg31, %arg32, %arg33) ({
      ^bb0(%arg34: memref<17x129xf32>, %arg35: memref<129x80xf32>, %arg36: memref<17x80xf32>, %arg37: memref<17x80xf32>):
        %28 = "arith.constant"() <{value = 1 : index}> : () -> index
        %29 = "air.herd"(%28, %28, %arg34, %arg35, %arg36, %arg37) ({
        ^bb0(%arg38: index, %arg39: index, %arg40: index, %arg41: index, %arg42: memref<17x129xf32>, %arg43: memref<129x80xf32>, %arg44: memref<17x80xf32>, %arg45: memref<17x80xf32>):
          %30 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<32xf32, 2 : i32>
          %31 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.32.loops.1.32"} : () -> memref<32xf32, 2 : i32>
          %32 = "air.wait_all"() : () -> !air.async.token
          %33 = "arith.constant"() <{value = 0 : index}> : () -> index
          %34 = "arith.constant"() <{value = 2 : index}> : () -> index
          %35 = "arith.constant"() <{value = 1 : index}> : () -> index
          %36 = "scf.for"(%33, %34, %35, %32) ({
          ^bb0(%arg46: index, %arg47: !air.async.token):
            %37 = "arith.constant"() <{value = 32 : index}> : () -> index
            %38 = "arith.muli"(%arg46, %37) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %39 = "arith.constant"() <{value = 32 : index}> : () -> index
            %40 = "arith.muli"(%arg46, %39) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %41 = "arith.constant"() <{value = 32 : index}> : () -> index
            %42 = "arith.muli"(%arg46, %41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %43 = "memref.reinterpret_cast"(%30) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 60 : i64, orbit.storage = "Y"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %44 = "memref.reinterpret_cast"(%31) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 60 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %45 = "arith.constant"() <{value = 0 : index}> : () -> index
            %46 = "arith.addi"(%45, %42) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %47 = "air.dma_memcpy_nd"(%arg47, %44, %arg45, %46) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 60 : i64, orbit.source_copies = array<i64: 148>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 201>, orbit.transfer = "host_to_l1", orbit.transfer_event = 171 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<17x80xf32>, index) -> !air.async.token
            "air.wait_all"(%47) {orbit.computation_event = 172 : i64, orbit.phase = 60 : i64, orbit.phase_dependencies = array<i64: 59>, orbit.read_copies = array<i64: 201>, orbit.task = "scale", orbit.write_copies = array<i64: 202>} : (!air.async.token) -> ()
            %48 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
            %49 = "arith.constant"() <{value = 16 : index}> : () -> index
            %50 = "arith.constant"() <{value = 17 : index}> : () -> index
            %51 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%49, %50, %51) ({
            ^bb0(%arg48: index):
              %56 = "arith.constant"() <{value = 0 : index}> : () -> index
              %57 = "arith.constant"() <{value = 32 : index}> : () -> index
              %58 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%56, %57, %58) ({
              ^bb0(%arg49: index):
                %59 = "arith.addi"(%arg49, %38) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %60 = "arith.constant"() <{value = 16 : index}> : () -> index
                %61 = "arith.subi"(%arg48, %60) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %62 = "arith.subi"(%59, %42) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %63 = "memref.load"(%44, %61, %62) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %64 = "arith.mulf"(%63, %48) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %65 = "arith.constant"() <{value = 16 : index}> : () -> index
                %66 = "arith.subi"(%arg48, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %67 = "arith.subi"(%59, %40) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%64, %43, %66, %67) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %52 = "arith.constant"() <{value = 0 : index}> : () -> index
            %53 = "arith.addi"(%52, %40) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %54 = "air.dma_memcpy_nd"(%arg47, %arg44, %53, %43) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 60 : i64, orbit.source_copies = array<i64: 202>, orbit.storage = "Y", orbit.target_copies = array<i64: 203>, orbit.transfer = "l1_to_host", orbit.transfer_event = 173 : i64, static_dst_offsets = array<i64: 16, -9223372036854775808>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<17x80xf32>, index, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %55 = "air.wait_all"(%54) : (!air.async.token) -> !air.async.token
            "scf.yield"(%55) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%36) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_60"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%29) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_60"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_60"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<17x129xf32>, %arg9: memref<129x80xf32>, %arg10: memref<17x80xf32>, %arg11: memref<17x80xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<17x129xf32>, %arg13: memref<129x80xf32>, %arg14: memref<17x80xf32>, %arg15: memref<17x80xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        %2 = "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<17x129xf32>, %arg21: memref<129x80xf32>, %arg22: memref<17x80xf32>, %arg23: memref<17x80xf32>):
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<16xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.16.loops.1.16"} : () -> memref<16xf32, 2 : i32>
          %5 = "air.wait_all"() : () -> !air.async.token
          %6 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 62 : i64, orbit.storage = "Y"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %7 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 62 : i64, orbit.storage = "intermediate"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %8 = "air.dma_memcpy_nd"(%5, %7, %arg23) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 62 : i64, orbit.source_copies = array<i64: 182>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 207>, orbit.transfer = "host_to_l1", orbit.transfer_event = 177 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 16, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>} : (!air.async.token, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, memref<17x80xf32>) -> !air.async.token
          "air.wait_all"(%8) {orbit.computation_event = 178 : i64, orbit.phase = 62 : i64, orbit.phase_dependencies = array<i64: 61>, orbit.read_copies = array<i64: 207>, orbit.task = "scale", orbit.write_copies = array<i64: 208>} : (!air.async.token) -> ()
          %9 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %10 = "arith.constant"() <{value = 16 : index}> : () -> index
          %11 = "arith.constant"() <{value = 17 : index}> : () -> index
          %12 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%10, %11, %12) ({
          ^bb0(%arg24: index):
            %15 = "arith.constant"() <{value = 64 : index}> : () -> index
            %16 = "arith.constant"() <{value = 80 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%15, %16, %17) ({
            ^bb0(%arg25: index):
              %18 = "arith.constant"() <{value = 16 : index}> : () -> index
              %19 = "arith.subi"(%arg24, %18) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %20 = "arith.constant"() <{value = 64 : index}> : () -> index
              %21 = "arith.subi"(%arg25, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %22 = "memref.load"(%7, %19, %21) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
              %23 = "arith.mulf"(%22, %9) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %24 = "arith.constant"() <{value = 16 : index}> : () -> index
              %25 = "arith.subi"(%arg24, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "arith.constant"() <{value = 64 : index}> : () -> index
              %27 = "arith.subi"(%arg25, %26) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%23, %6, %25, %27) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %13 = "air.dma_memcpy_nd"(%5, %arg22, %6) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 62 : i64, orbit.source_copies = array<i64: 208>, orbit.storage = "Y", orbit.target_copies = array<i64: 209>, orbit.transfer = "l1_to_host", orbit.transfer_event = 179 : i64, static_dst_offsets = array<i64: 16, 64>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 80, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<17x80xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %14 = "air.wait_all"(%13) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%14) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_62"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> !air.async.token
        "air.wait_all"(%2) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_62"} : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_62"} : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.async_herd_scope = "module", orbit.channel_conversion_scope = "module", orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.local_release_scope = "static-hardware-stage", orbit.mapping_plan = "dfb3ebbb5c80c5573c131f3302249e22b92738016036ab97bf175299203d50d7", orbit.source_fingerprint = "912511a293a64cce8e0d6c281bea7fa9b2ada1f653348173aee833f4c600a053"} : () -> ()

