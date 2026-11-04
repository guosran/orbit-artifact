#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage0_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage0_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage0_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage1_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage1_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage1_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage2_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage2_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage2_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage3_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage3_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage3_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage4_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage4_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage4_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage5_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage5_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage5_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage6_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage6_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage6_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage7_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage7_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage7_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage8_storage0_in"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_packet", size = [1, 1], sym_name = "__orbit_fifo_stage8_storage1_in"}> {air.tile_dma_channel = 1 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "__orbit_fifo_stage8_storage3_out"}> {air.tile_dma_channel = 0 : i32} : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_45"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_46"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_47"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_48"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_49"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_50"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_51"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_52"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_53"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_54"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_55"}> : () -> ()
  "air.channel"() <{channel_type = "npu_dma_stream", size = [1, 1], sym_name = "channel_56"}> : () -> ()
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"}> ({
    ^bb0(%arg267: index, %arg268: index, %arg269: index, %arg270: index, %arg271: memref<17x129xf32>, %arg272: memref<129x80xf32>, %arg273: memref<17x80xf32>):
      %1041 = "arith.constant"() <{value = 32 : index}> : () -> index
      %1042 = "arith.constant"() <{value = 4 : index}> : () -> index
      %1043 = "arith.constant"() <{value = 1 : index}> : () -> index
      %1044 = "arith.constant"() <{value = 0 : index}> : () -> index
      %1045 = "air.wait_all"() : () -> !air.async.token
      %1046 = "scf.for"(%1044, %1042, %1043, %1045) ({
      ^bb0(%arg288: index, %arg289: !air.async.token):
        %1125 = "arith.muli"(%arg288, %1041) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %1126 = "air.channel.put"(%arg289, %1044, %1044, %arg271, %1125) <{chan_name = @__orbit_fifo_stage0_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%1126) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %1047 = "air.wait_all"() : () -> !air.async.token
      %1048 = "scf.for"(%1044, %1042, %1043, %1047) ({
      ^bb0(%arg286: index, %arg287: !air.async.token):
        %1123 = "arith.muli"(%arg286, %1041) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %1124 = "air.channel.put"(%arg287, %1044, %1044, %arg272, %1123) <{chan_name = @__orbit_fifo_stage0_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%1124) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %1049 = "air.channel.put"(%1044, %1044, %arg271) <{chan_name = @__orbit_fifo_stage0_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %1050 = "air.channel.put"(%1044, %1044, %arg272) <{chan_name = @__orbit_fifo_stage0_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %1051 = "air.channel.get"(%1044, %1044, %arg273) <{chan_name = @__orbit_fifo_stage0_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment"}> ({
        %1052 = "arith.constant"() <{value = 1 : index}> : () -> index
        %1053 = "air.herd"(%1052, %1052) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd"}> ({
        ^bb0(%arg274: index, %arg275: index, %arg276: index, %arg277: index):
          %1054 = "arith.constant"() <{value = 4 : index}> : () -> index
          %1055 = "arith.constant"() <{value = 32 : index}> : () -> index
          %1056 = "arith.constant"() <{value = 1 : index}> : () -> index
          %1057 = "arith.constant"() <{value = 8 : index}> : () -> index
          %1058 = "arith.constant"() <{value = 0 : index}> : () -> index
          %1059 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %1060 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %1061 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %1062 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %1063 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %1064 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %1065 = "memref.reinterpret_cast"(%1064) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 9 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          "scf.for"(%1058, %1057, %1056) ({
          ^bb0(%arg284: index):
            "scf.for"(%1058, %1055, %1056) ({
            ^bb0(%arg285: index):
              "memref.store"(%1059, %1065, %arg284, %arg285) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%1058, %1054, %1056) ({
          ^bb0(%arg280: index):
            %1092 = "arith.muli"(%arg280, %1055) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1093 = "arith.muli"(%arg280, %1055) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1094 = "arith.muli"(%arg280, %1055) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1095 = "memref.reinterpret_cast"(%1061) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 9 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %1096 = "air.channel.get"(%arg274, %arg275, %1061) <{chan_name = @__orbit_fifo_stage0_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            %1097 = "memref.reinterpret_cast"(%1063) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 9 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %1098 = "air.channel.get"(%arg274, %arg275, %1063) <{chan_name = @__orbit_fifo_stage0_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1024xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%1096, %1098) {orbit.computation_event = 3 : i64, orbit.phase = 9 : i64, orbit.phase_dependencies = array<i64: 8>, orbit.read_copies = array<i64: 30, 31, 32>, orbit.task = "gemm", orbit.write_copies = array<i64: 33>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%1058, %1057, %1056) ({
            ^bb0(%arg281: index):
              "scf.for"(%1058, %1055, %1057) ({
              ^bb0(%arg282: index):
                "scf.for"(%1058, %1055, %1056) ({
                ^bb0(%arg283: index):
                  %1099 = "arith.addi"(%arg283, %1092) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1100 = "arith.subi"(%1099, %1093) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1101 = "memref.load"(%1095, %arg281, %1100) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1102 = "arith.subi"(%1099, %1094) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1103 = "vector.transfer_read"(%1097, %1102, %arg282, %1059) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %1104 = "vector.transfer_read"(%1065, %arg281, %arg282, %1059) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %1105 = "vector.extract"(%1103) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %1106 = "func.call"(%1101, %1105) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1107 = "vector.extract"(%1103) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %1108 = "func.call"(%1101, %1107) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1109 = "vector.extract"(%1103) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %1110 = "func.call"(%1101, %1109) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1111 = "vector.extract"(%1103) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %1112 = "func.call"(%1101, %1111) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1113 = "vector.extract"(%1103) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %1114 = "func.call"(%1101, %1113) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1115 = "vector.extract"(%1103) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %1116 = "func.call"(%1101, %1115) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1117 = "vector.extract"(%1103) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %1118 = "func.call"(%1101, %1117) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1119 = "vector.extract"(%1103) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %1120 = "func.call"(%1101, %1119) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1121 = "vector.from_elements"(%1106, %1108, %1110, %1112, %1114, %1116, %1118, %1120) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                  %1122 = "arith.addf"(%1104, %1121) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                  "vector.transfer_write"(%1122, %1065, %arg281, %arg282) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %1066 = "memref.reinterpret_cast"(%1060) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 13 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %1067 = "air.channel.get"(%arg274, %arg275, %1060) <{chan_name = @__orbit_fifo_stage0_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<8xf32, 2 : i32>) -> !air.async.token
          %1068 = "memref.reinterpret_cast"(%1062) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 13 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %1069 = "air.channel.get"(%arg274, %arg275, %1062) <{chan_name = @__orbit_fifo_stage0_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%1067, %1069) {orbit.computation_event = 15 : i64, orbit.phase = 13 : i64, orbit.phase_dependencies = array<i64: 12>, orbit.read_copies = array<i64: 43, 44, 42>, orbit.task = "gemm", orbit.write_copies = array<i64: 45>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%1058, %1057, %1056) ({
          ^bb0(%arg278: index):
            "scf.for"(%1058, %1055, %1057) ({
            ^bb0(%arg279: index):
              %1071 = "memref.load"(%1066, %arg278, %1058) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
              %1072 = "vector.transfer_read"(%1068, %1058, %arg279, %1059) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %1073 = "vector.transfer_read"(%1065, %arg278, %arg279, %1059) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %1074 = "vector.extract"(%1072) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %1075 = "func.call"(%1071, %1074) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1076 = "vector.extract"(%1072) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %1077 = "func.call"(%1071, %1076) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1078 = "vector.extract"(%1072) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %1079 = "func.call"(%1071, %1078) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1080 = "vector.extract"(%1072) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %1081 = "func.call"(%1071, %1080) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1082 = "vector.extract"(%1072) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %1083 = "func.call"(%1071, %1082) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1084 = "vector.extract"(%1072) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %1085 = "func.call"(%1071, %1084) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1086 = "vector.extract"(%1072) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %1087 = "func.call"(%1071, %1086) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1088 = "vector.extract"(%1072) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %1089 = "func.call"(%1071, %1088) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %1090 = "vector.from_elements"(%1075, %1077, %1079, %1081, %1083, %1085, %1087, %1089) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %1091 = "arith.addf"(%1073, %1090) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
              "vector.transfer_write"(%1091, %1065, %arg278, %arg279) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %1070 = "air.channel.put"(%arg274, %arg275, %1064) <{chan_name = @__orbit_fifo_stage0_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%1070) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%1053) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_14"}> ({
    ^bb0(%arg244: index, %arg245: index, %arg246: index, %arg247: index, %arg248: memref<17x129xf32>, %arg249: memref<129x80xf32>, %arg250: memref<17x80xf32>):
      %947 = "arith.constant"() <{value = 32 : index}> : () -> index
      %948 = "arith.constant"() <{value = 4 : index}> : () -> index
      %949 = "arith.constant"() <{value = 1 : index}> : () -> index
      %950 = "arith.constant"() <{value = 0 : index}> : () -> index
      %951 = "air.wait_all"() : () -> !air.async.token
      %952 = "scf.for"(%950, %948, %949, %951) ({
      ^bb0(%arg265: index, %arg266: !air.async.token):
        %1039 = "arith.muli"(%arg265, %947) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %1040 = "air.channel.put"(%arg266, %950, %950, %arg248, %1039) <{chan_name = @__orbit_fifo_stage1_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%1040) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %953 = "air.wait_all"() : () -> !air.async.token
      %954 = "scf.for"(%950, %948, %949, %953) ({
      ^bb0(%arg263: index, %arg264: !air.async.token):
        %1037 = "arith.muli"(%arg263, %947) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %1038 = "air.channel.put"(%arg264, %950, %950, %arg249, %1037) <{chan_name = @__orbit_fifo_stage1_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%1038) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %955 = "air.channel.put"(%950, %950, %arg248) <{chan_name = @__orbit_fifo_stage1_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %956 = "air.channel.put"(%950, %950, %arg249) <{chan_name = @__orbit_fifo_stage1_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %957 = "air.channel.get"(%950, %950, %arg250) <{chan_name = @__orbit_fifo_stage1_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 0, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_14"}> ({
        %958 = "arith.constant"() <{value = 1 : index}> : () -> index
        %959 = "air.herd"(%958, %958) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_14"}> ({
        ^bb0(%arg251: index, %arg252: index, %arg253: index, %arg254: index):
          %960 = "arith.constant"() <{value = 4 : index}> : () -> index
          %961 = "arith.constant"() <{value = 64 : index}> : () -> index
          %962 = "arith.constant"() <{value = 32 : index}> : () -> index
          %963 = "arith.constant"() <{value = 1 : index}> : () -> index
          %964 = "arith.constant"() <{value = 8 : index}> : () -> index
          %965 = "arith.constant"() <{value = 0 : index}> : () -> index
          %966 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %967 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %968 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %969 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %970 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %971 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %972 = "memref.reinterpret_cast"(%971) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 14 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          "scf.for"(%965, %964, %963) ({
          ^bb0(%arg261: index):
            "scf.for"(%962, %961, %963) ({
            ^bb0(%arg262: index):
              %1036 = "arith.subi"(%arg262, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%966, %972, %arg261, %1036) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%965, %960, %963) ({
          ^bb0(%arg257: index):
            %1002 = "arith.muli"(%arg257, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1003 = "arith.muli"(%arg257, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1004 = "arith.muli"(%arg257, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %1005 = "memref.reinterpret_cast"(%968) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 14 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %1006 = "air.channel.get"(%arg251, %arg252, %968) <{chan_name = @__orbit_fifo_stage1_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            %1007 = "memref.reinterpret_cast"(%970) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 14 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %1008 = "air.channel.get"(%arg251, %arg252, %970) <{chan_name = @__orbit_fifo_stage1_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1024xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%1006, %1008) {orbit.computation_event = 20 : i64, orbit.phase = 14 : i64, orbit.phase_dependencies = array<i64: 13>, orbit.read_copies = array<i64: 47, 48, 49>, orbit.task = "gemm", orbit.write_copies = array<i64: 50>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%965, %964, %963) ({
            ^bb0(%arg258: index):
              "scf.for"(%962, %961, %964) ({
              ^bb0(%arg259: index):
                "scf.for"(%965, %962, %963) ({
                ^bb0(%arg260: index):
                  %1009 = "arith.addi"(%arg260, %1002) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1010 = "arith.subi"(%1009, %1003) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1011 = "memref.load"(%1005, %arg258, %1010) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %1012 = "arith.subi"(%1009, %1004) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1013 = "arith.subi"(%arg259, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1014 = "vector.transfer_read"(%1007, %1012, %1013, %966) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %1015 = "arith.subi"(%arg259, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %1016 = "vector.transfer_read"(%972, %arg258, %1015, %966) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %1017 = "vector.extract"(%1014) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %1018 = "func.call"(%1011, %1017) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1019 = "vector.extract"(%1014) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %1020 = "func.call"(%1011, %1019) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1021 = "vector.extract"(%1014) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %1022 = "func.call"(%1011, %1021) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1023 = "vector.extract"(%1014) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %1024 = "func.call"(%1011, %1023) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1025 = "vector.extract"(%1014) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %1026 = "func.call"(%1011, %1025) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1027 = "vector.extract"(%1014) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %1028 = "func.call"(%1011, %1027) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1029 = "vector.extract"(%1014) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %1030 = "func.call"(%1011, %1029) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1031 = "vector.extract"(%1014) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %1032 = "func.call"(%1011, %1031) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %1033 = "vector.from_elements"(%1018, %1020, %1022, %1024, %1026, %1028, %1030, %1032) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                  %1034 = "arith.addf"(%1016, %1033) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                  %1035 = "arith.subi"(%arg259, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%1034, %972, %arg258, %1035) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %973 = "memref.reinterpret_cast"(%967) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 18 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %974 = "air.channel.get"(%arg251, %arg252, %967) <{chan_name = @__orbit_fifo_stage1_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<8xf32, 2 : i32>) -> !air.async.token
          %975 = "memref.reinterpret_cast"(%969) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 18 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %976 = "air.channel.get"(%arg251, %arg252, %969) <{chan_name = @__orbit_fifo_stage1_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%974, %976) {orbit.computation_event = 32 : i64, orbit.phase = 18 : i64, orbit.phase_dependencies = array<i64: 17>, orbit.read_copies = array<i64: 60, 61, 59>, orbit.task = "gemm", orbit.write_copies = array<i64: 62>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%965, %964, %963) ({
          ^bb0(%arg255: index):
            "scf.for"(%962, %961, %964) ({
            ^bb0(%arg256: index):
              %978 = "memref.load"(%973, %arg255, %965) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
              %979 = "arith.subi"(%arg256, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %980 = "vector.transfer_read"(%975, %965, %979, %966) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %981 = "arith.subi"(%arg256, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %982 = "vector.transfer_read"(%972, %arg255, %981, %966) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %983 = "vector.extract"(%980) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %984 = "func.call"(%978, %983) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %985 = "vector.extract"(%980) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %986 = "func.call"(%978, %985) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %987 = "vector.extract"(%980) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %988 = "func.call"(%978, %987) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %989 = "vector.extract"(%980) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %990 = "func.call"(%978, %989) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %991 = "vector.extract"(%980) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %992 = "func.call"(%978, %991) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %993 = "vector.extract"(%980) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %994 = "func.call"(%978, %993) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %995 = "vector.extract"(%980) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %996 = "func.call"(%978, %995) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %997 = "vector.extract"(%980) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %998 = "func.call"(%978, %997) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %999 = "vector.from_elements"(%984, %986, %988, %990, %992, %994, %996, %998) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %1000 = "arith.addf"(%982, %999) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
              %1001 = "arith.subi"(%arg256, %962) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%1000, %972, %arg255, %1001) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %977 = "air.channel.put"(%arg251, %arg252, %971) <{chan_name = @__orbit_fifo_stage1_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%977) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%959) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_19"}> ({
    ^bb0(%arg221: index, %arg222: index, %arg223: index, %arg224: index, %arg225: memref<17x129xf32>, %arg226: memref<129x80xf32>, %arg227: memref<17x80xf32>):
      %852 = "arith.constant"() <{value = 4 : index}> : () -> index
      %853 = "arith.constant"() <{value = 32 : index}> : () -> index
      %854 = "arith.constant"() <{value = 1 : index}> : () -> index
      %855 = "arith.constant"() <{value = 0 : index}> : () -> index
      %856 = "air.wait_all"() : () -> !air.async.token
      %857 = "scf.for"(%855, %852, %854, %856) ({
      ^bb0(%arg242: index, %arg243: !air.async.token):
        %945 = "arith.muli"(%arg242, %853) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %946 = "air.channel.put"(%arg243, %855, %855, %arg225, %945) <{chan_name = @__orbit_fifo_stage2_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%946) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %858 = "air.wait_all"() : () -> !air.async.token
      %859 = "scf.for"(%855, %852, %854, %858) ({
      ^bb0(%arg240: index, %arg241: !air.async.token):
        %943 = "arith.muli"(%arg240, %853) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %944 = "air.channel.put"(%arg241, %855, %855, %arg226, %943) <{chan_name = @__orbit_fifo_stage2_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%944) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %860 = "air.channel.put"(%855, %855, %arg225) <{chan_name = @__orbit_fifo_stage2_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 0, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %861 = "air.channel.put"(%855, %855, %arg226) <{chan_name = @__orbit_fifo_stage2_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %862 = "air.channel.get"(%855, %855, %arg227) <{chan_name = @__orbit_fifo_stage2_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 0, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_19"}> ({
        %863 = "arith.constant"() <{value = 1 : index}> : () -> index
        %864 = "air.herd"(%863, %863) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_19"}> ({
        ^bb0(%arg228: index, %arg229: index, %arg230: index, %arg231: index):
          %865 = "arith.constant"() <{value = 32 : index}> : () -> index
          %866 = "arith.constant"() <{value = 4 : index}> : () -> index
          %867 = "arith.constant"() <{value = 80 : index}> : () -> index
          %868 = "arith.constant"() <{value = 64 : index}> : () -> index
          %869 = "arith.constant"() <{value = 1 : index}> : () -> index
          %870 = "arith.constant"() <{value = 8 : index}> : () -> index
          %871 = "arith.constant"() <{value = 0 : index}> : () -> index
          %872 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %873 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : () -> memref<8xf32, 2 : i32>
          %874 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %875 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : () -> memref<16xf32, 2 : i32>
          %876 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : () -> memref<512xf32, 2 : i32>
          %877 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %878 = "memref.reinterpret_cast"(%877) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 19 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          "scf.for"(%871, %870, %869) ({
          ^bb0(%arg238: index):
            "scf.for"(%868, %867, %869) ({
            ^bb0(%arg239: index):
              %942 = "arith.subi"(%arg239, %868) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%872, %878, %arg238, %942) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%871, %866, %869) ({
          ^bb0(%arg234: index):
            %908 = "arith.muli"(%arg234, %865) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %909 = "arith.muli"(%arg234, %865) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %910 = "arith.muli"(%arg234, %865) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %911 = "memref.reinterpret_cast"(%874) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 19 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %912 = "air.channel.get"(%arg228, %arg229, %874) <{chan_name = @__orbit_fifo_stage2_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            %913 = "memref.reinterpret_cast"(%876) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 19 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %914 = "air.channel.get"(%arg228, %arg229, %876) <{chan_name = @__orbit_fifo_stage2_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<512xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%912, %914) {orbit.computation_event = 37 : i64, orbit.phase = 19 : i64, orbit.phase_dependencies = array<i64: 18>, orbit.read_copies = array<i64: 64, 65, 66>, orbit.task = "gemm", orbit.write_copies = array<i64: 67>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%871, %870, %869) ({
            ^bb0(%arg235: index):
              "scf.for"(%868, %867, %870) ({
              ^bb0(%arg236: index):
                "scf.for"(%871, %865, %869) ({
                ^bb0(%arg237: index):
                  %915 = "arith.addi"(%arg237, %908) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %916 = "arith.subi"(%915, %909) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %917 = "memref.load"(%911, %arg235, %916) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %918 = "arith.subi"(%915, %910) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %919 = "arith.subi"(%arg236, %868) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %920 = "vector.transfer_read"(%913, %918, %919, %872) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %921 = "arith.subi"(%arg236, %868) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %922 = "vector.transfer_read"(%878, %arg235, %921, %872) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %923 = "vector.extract"(%920) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %924 = "func.call"(%917, %923) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %925 = "vector.extract"(%920) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %926 = "func.call"(%917, %925) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %927 = "vector.extract"(%920) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %928 = "func.call"(%917, %927) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %929 = "vector.extract"(%920) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %930 = "func.call"(%917, %929) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %931 = "vector.extract"(%920) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %932 = "func.call"(%917, %931) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %933 = "vector.extract"(%920) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %934 = "func.call"(%917, %933) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %935 = "vector.extract"(%920) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %936 = "func.call"(%917, %935) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %937 = "vector.extract"(%920) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %938 = "func.call"(%917, %937) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %939 = "vector.from_elements"(%924, %926, %928, %930, %932, %934, %936, %938) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                  %940 = "arith.addf"(%922, %939) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                  %941 = "arith.subi"(%arg236, %868) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%940, %878, %arg235, %941) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %879 = "memref.reinterpret_cast"(%873) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 23 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %880 = "air.channel.get"(%arg228, %arg229, %873) <{chan_name = @__orbit_fifo_stage2_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<8xf32, 2 : i32>) -> !air.async.token
          %881 = "memref.reinterpret_cast"(%875) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 23 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %882 = "air.channel.get"(%arg228, %arg229, %875) <{chan_name = @__orbit_fifo_stage2_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<16xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%880, %882) {orbit.computation_event = 49 : i64, orbit.phase = 23 : i64, orbit.phase_dependencies = array<i64: 22>, orbit.read_copies = array<i64: 77, 78, 76>, orbit.task = "gemm", orbit.write_copies = array<i64: 79>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%871, %870, %869) ({
          ^bb0(%arg232: index):
            "scf.for"(%868, %867, %870) ({
            ^bb0(%arg233: index):
              %884 = "memref.load"(%879, %arg232, %871) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
              %885 = "arith.subi"(%arg233, %868) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %886 = "vector.transfer_read"(%881, %871, %885, %872) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %887 = "arith.subi"(%arg233, %868) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %888 = "vector.transfer_read"(%878, %arg232, %887, %872) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %889 = "vector.extract"(%886) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %890 = "func.call"(%884, %889) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %891 = "vector.extract"(%886) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %892 = "func.call"(%884, %891) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %893 = "vector.extract"(%886) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %894 = "func.call"(%884, %893) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %895 = "vector.extract"(%886) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %896 = "func.call"(%884, %895) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %897 = "vector.extract"(%886) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %898 = "func.call"(%884, %897) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %899 = "vector.extract"(%886) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %900 = "func.call"(%884, %899) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %901 = "vector.extract"(%886) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %902 = "func.call"(%884, %901) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %903 = "vector.extract"(%886) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %904 = "func.call"(%884, %903) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %905 = "vector.from_elements"(%890, %892, %894, %896, %898, %900, %902, %904) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %906 = "arith.addf"(%888, %905) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
              %907 = "arith.subi"(%arg233, %868) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%906, %878, %arg232, %907) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %883 = "air.channel.put"(%arg228, %arg229, %877) <{chan_name = @__orbit_fifo_stage2_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<128xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%883) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%864) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_24"}> ({
    ^bb0(%arg198: index, %arg199: index, %arg200: index, %arg201: index, %arg202: memref<17x129xf32>, %arg203: memref<129x80xf32>, %arg204: memref<17x80xf32>):
      %758 = "arith.constant"() <{value = 32 : index}> : () -> index
      %759 = "arith.constant"() <{value = 4 : index}> : () -> index
      %760 = "arith.constant"() <{value = 1 : index}> : () -> index
      %761 = "arith.constant"() <{value = 0 : index}> : () -> index
      %762 = "air.wait_all"() : () -> !air.async.token
      %763 = "scf.for"(%761, %759, %760, %762) ({
      ^bb0(%arg219: index, %arg220: !air.async.token):
        %850 = "arith.muli"(%arg219, %758) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %851 = "air.channel.put"(%arg220, %761, %761, %arg202, %850) <{chan_name = @__orbit_fifo_stage3_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%851) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %764 = "air.wait_all"() : () -> !air.async.token
      %765 = "scf.for"(%761, %759, %760, %764) ({
      ^bb0(%arg217: index, %arg218: !air.async.token):
        %848 = "arith.muli"(%arg217, %758) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %849 = "air.channel.put"(%arg218, %761, %761, %arg203, %848) <{chan_name = @__orbit_fifo_stage3_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%849) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %766 = "air.channel.put"(%761, %761, %arg202) <{chan_name = @__orbit_fifo_stage3_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %767 = "air.channel.put"(%761, %761, %arg203) <{chan_name = @__orbit_fifo_stage3_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %768 = "air.channel.get"(%761, %761, %arg204) <{chan_name = @__orbit_fifo_stage3_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 8, 0>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_24"}> ({
        %769 = "arith.constant"() <{value = 1 : index}> : () -> index
        %770 = "air.herd"(%769, %769) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_24"}> ({
        ^bb0(%arg205: index, %arg206: index, %arg207: index, %arg208: index):
          %771 = "arith.constant"() <{value = 4 : index}> : () -> index
          %772 = "arith.constant"() <{value = 32 : index}> : () -> index
          %773 = "arith.constant"() <{value = 0 : index}> : () -> index
          %774 = "arith.constant"() <{value = 1 : index}> : () -> index
          %775 = "arith.constant"() <{value = 16 : index}> : () -> index
          %776 = "arith.constant"() <{value = 8 : index}> : () -> index
          %777 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %778 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %779 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %780 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %781 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %782 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %783 = "memref.reinterpret_cast"(%782) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          "scf.for"(%776, %775, %774) ({
          ^bb0(%arg215: index):
            "scf.for"(%773, %772, %774) ({
            ^bb0(%arg216: index):
              %847 = "arith.subi"(%arg215, %776) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%777, %783, %847, %arg216) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%773, %771, %774) ({
          ^bb0(%arg211: index):
            %813 = "arith.muli"(%arg211, %772) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %814 = "arith.muli"(%arg211, %772) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %815 = "arith.muli"(%arg211, %772) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %816 = "memref.reinterpret_cast"(%779) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %817 = "air.channel.get"(%arg205, %arg206, %779) <{chan_name = @__orbit_fifo_stage3_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            %818 = "memref.reinterpret_cast"(%781) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 24 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %819 = "air.channel.get"(%arg205, %arg206, %781) <{chan_name = @__orbit_fifo_stage3_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1024xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%817, %819) {orbit.computation_event = 54 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 81, 82, 83>, orbit.task = "gemm", orbit.write_copies = array<i64: 84>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%776, %775, %774) ({
            ^bb0(%arg212: index):
              "scf.for"(%773, %772, %776) ({
              ^bb0(%arg213: index):
                "scf.for"(%773, %772, %774) ({
                ^bb0(%arg214: index):
                  %820 = "arith.addi"(%arg214, %813) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %821 = "arith.subi"(%arg212, %776) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %822 = "arith.subi"(%820, %814) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %823 = "memref.load"(%816, %821, %822) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %824 = "arith.subi"(%820, %815) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %825 = "vector.transfer_read"(%818, %824, %arg213, %777) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %826 = "arith.subi"(%arg212, %776) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %827 = "vector.transfer_read"(%783, %826, %arg213, %777) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %828 = "vector.extract"(%825) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %829 = "func.call"(%823, %828) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %830 = "vector.extract"(%825) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %831 = "func.call"(%823, %830) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %832 = "vector.extract"(%825) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %833 = "func.call"(%823, %832) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %834 = "vector.extract"(%825) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %835 = "func.call"(%823, %834) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %836 = "vector.extract"(%825) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %837 = "func.call"(%823, %836) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %838 = "vector.extract"(%825) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %839 = "func.call"(%823, %838) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %840 = "vector.extract"(%825) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %841 = "func.call"(%823, %840) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %842 = "vector.extract"(%825) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %843 = "func.call"(%823, %842) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %844 = "vector.from_elements"(%829, %831, %833, %835, %837, %839, %841, %843) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                  %845 = "arith.addf"(%827, %844) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                  %846 = "arith.subi"(%arg212, %776) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%845, %783, %846, %arg213) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %784 = "memref.reinterpret_cast"(%778) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 28 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %785 = "air.channel.get"(%arg205, %arg206, %778) <{chan_name = @__orbit_fifo_stage3_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<8xf32, 2 : i32>) -> !air.async.token
          %786 = "memref.reinterpret_cast"(%780) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 28 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %787 = "air.channel.get"(%arg205, %arg206, %780) <{chan_name = @__orbit_fifo_stage3_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%785, %787) {orbit.computation_event = 66 : i64, orbit.phase = 28 : i64, orbit.phase_dependencies = array<i64: 27>, orbit.read_copies = array<i64: 94, 95, 93>, orbit.task = "gemm", orbit.write_copies = array<i64: 96>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%776, %775, %774) ({
          ^bb0(%arg209: index):
            "scf.for"(%773, %772, %776) ({
            ^bb0(%arg210: index):
              %789 = "arith.subi"(%arg209, %776) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %790 = "memref.load"(%784, %789, %773) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
              %791 = "vector.transfer_read"(%786, %773, %arg210, %777) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %792 = "arith.subi"(%arg209, %776) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %793 = "vector.transfer_read"(%783, %792, %arg210, %777) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %794 = "vector.extract"(%791) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %795 = "func.call"(%790, %794) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %796 = "vector.extract"(%791) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %797 = "func.call"(%790, %796) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %798 = "vector.extract"(%791) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %799 = "func.call"(%790, %798) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %800 = "vector.extract"(%791) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %801 = "func.call"(%790, %800) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %802 = "vector.extract"(%791) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %803 = "func.call"(%790, %802) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %804 = "vector.extract"(%791) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %805 = "func.call"(%790, %804) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %806 = "vector.extract"(%791) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %807 = "func.call"(%790, %806) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %808 = "vector.extract"(%791) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %809 = "func.call"(%790, %808) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %810 = "vector.from_elements"(%795, %797, %799, %801, %803, %805, %807, %809) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %811 = "arith.addf"(%793, %810) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
              %812 = "arith.subi"(%arg209, %776) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%811, %783, %812, %arg210) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %788 = "air.channel.put"(%arg205, %arg206, %782) <{chan_name = @__orbit_fifo_stage3_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%788) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%770) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_29"}> ({
    ^bb0(%arg175: index, %arg176: index, %arg177: index, %arg178: index, %arg179: memref<17x129xf32>, %arg180: memref<129x80xf32>, %arg181: memref<17x80xf32>):
      %656 = "arith.constant"() <{value = 32 : index}> : () -> index
      %657 = "arith.constant"() <{value = 4 : index}> : () -> index
      %658 = "arith.constant"() <{value = 1 : index}> : () -> index
      %659 = "arith.constant"() <{value = 0 : index}> : () -> index
      %660 = "air.wait_all"() : () -> !air.async.token
      %661 = "scf.for"(%659, %657, %658, %660) ({
      ^bb0(%arg196: index, %arg197: !air.async.token):
        %756 = "arith.muli"(%arg196, %656) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %757 = "air.channel.put"(%arg197, %659, %659, %arg179, %756) <{chan_name = @__orbit_fifo_stage4_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%757) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %662 = "air.wait_all"() : () -> !air.async.token
      %663 = "scf.for"(%659, %657, %658, %662) ({
      ^bb0(%arg194: index, %arg195: !air.async.token):
        %754 = "arith.muli"(%arg194, %656) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %755 = "air.channel.put"(%arg195, %659, %659, %arg180, %754) <{chan_name = @__orbit_fifo_stage4_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%755) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %664 = "air.channel.put"(%659, %659, %arg179) <{chan_name = @__orbit_fifo_stage4_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %665 = "air.channel.put"(%659, %659, %arg180) <{chan_name = @__orbit_fifo_stage4_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %666 = "air.channel.get"(%659, %659, %arg181) <{chan_name = @__orbit_fifo_stage4_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 8, 32>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_29"}> ({
        %667 = "arith.constant"() <{value = 1 : index}> : () -> index
        %668 = "air.herd"(%667, %667) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_29"}> ({
        ^bb0(%arg182: index, %arg183: index, %arg184: index, %arg185: index):
          %669 = "arith.constant"() <{value = 4 : index}> : () -> index
          %670 = "arith.constant"() <{value = 0 : index}> : () -> index
          %671 = "arith.constant"() <{value = 64 : index}> : () -> index
          %672 = "arith.constant"() <{value = 32 : index}> : () -> index
          %673 = "arith.constant"() <{value = 1 : index}> : () -> index
          %674 = "arith.constant"() <{value = 16 : index}> : () -> index
          %675 = "arith.constant"() <{value = 8 : index}> : () -> index
          %676 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %677 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : () -> memref<8xf32, 2 : i32>
          %678 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : () -> memref<256xf32, 2 : i32>
          %679 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : () -> memref<32xf32, 2 : i32>
          %680 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : () -> memref<1024xf32, 2 : i32>
          %681 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<256xf32, 2 : i32>
          %682 = "memref.reinterpret_cast"(%681) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 29 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          "scf.for"(%675, %674, %673) ({
          ^bb0(%arg192: index):
            "scf.for"(%672, %671, %673) ({
            ^bb0(%arg193: index):
              %752 = "arith.subi"(%arg192, %675) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %753 = "arith.subi"(%arg193, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%676, %682, %752, %753) <{nontemporal = false}> : (f32, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%670, %669, %673) ({
          ^bb0(%arg188: index):
            %715 = "arith.muli"(%arg188, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %716 = "arith.muli"(%arg188, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %717 = "arith.muli"(%arg188, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %718 = "memref.reinterpret_cast"(%678) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 29 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %719 = "air.channel.get"(%arg182, %arg183, %678) <{chan_name = @__orbit_fifo_stage4_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            %720 = "memref.reinterpret_cast"(%680) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 29 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %721 = "air.channel.get"(%arg182, %arg183, %680) <{chan_name = @__orbit_fifo_stage4_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1024xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%719, %721) {orbit.computation_event = 71 : i64, orbit.phase = 29 : i64, orbit.phase_dependencies = array<i64: 28>, orbit.read_copies = array<i64: 98, 99, 100>, orbit.task = "gemm", orbit.write_copies = array<i64: 101>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%675, %674, %673) ({
            ^bb0(%arg189: index):
              "scf.for"(%672, %671, %675) ({
              ^bb0(%arg190: index):
                "scf.for"(%670, %672, %673) ({
                ^bb0(%arg191: index):
                  %722 = "arith.addi"(%arg191, %715) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %723 = "arith.subi"(%arg189, %675) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %724 = "arith.subi"(%722, %716) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %725 = "memref.load"(%718, %723, %724) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %726 = "arith.subi"(%722, %717) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %727 = "arith.subi"(%arg190, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %728 = "vector.transfer_read"(%720, %726, %727, %676) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %729 = "arith.subi"(%arg189, %675) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %730 = "arith.subi"(%arg190, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %731 = "vector.transfer_read"(%682, %729, %730, %676) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %732 = "vector.extract"(%728) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %733 = "func.call"(%725, %732) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %734 = "vector.extract"(%728) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %735 = "func.call"(%725, %734) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %736 = "vector.extract"(%728) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %737 = "func.call"(%725, %736) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %738 = "vector.extract"(%728) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %739 = "func.call"(%725, %738) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %740 = "vector.extract"(%728) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %741 = "func.call"(%725, %740) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %742 = "vector.extract"(%728) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %743 = "func.call"(%725, %742) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %744 = "vector.extract"(%728) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %745 = "func.call"(%725, %744) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %746 = "vector.extract"(%728) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %747 = "func.call"(%725, %746) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %748 = "vector.from_elements"(%733, %735, %737, %739, %741, %743, %745, %747) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                  %749 = "arith.addf"(%731, %748) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                  %750 = "arith.subi"(%arg189, %675) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %751 = "arith.subi"(%arg190, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%749, %682, %750, %751) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %683 = "memref.reinterpret_cast"(%677) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 33 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %684 = "air.channel.get"(%arg182, %arg183, %677) <{chan_name = @__orbit_fifo_stage4_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<8xf32, 2 : i32>) -> !air.async.token
          %685 = "memref.reinterpret_cast"(%679) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 33 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %686 = "air.channel.get"(%arg182, %arg183, %679) <{chan_name = @__orbit_fifo_stage4_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%684, %686) {orbit.computation_event = 83 : i64, orbit.phase = 33 : i64, orbit.phase_dependencies = array<i64: 32>, orbit.read_copies = array<i64: 111, 112, 110>, orbit.task = "gemm", orbit.write_copies = array<i64: 113>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%675, %674, %673) ({
          ^bb0(%arg186: index):
            "scf.for"(%672, %671, %675) ({
            ^bb0(%arg187: index):
              %688 = "arith.subi"(%arg186, %675) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %689 = "memref.load"(%683, %688, %670) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
              %690 = "arith.subi"(%arg187, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %691 = "vector.transfer_read"(%685, %670, %690, %676) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %692 = "arith.subi"(%arg186, %675) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %693 = "arith.subi"(%arg187, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %694 = "vector.transfer_read"(%682, %692, %693, %676) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %695 = "vector.extract"(%691) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %696 = "func.call"(%689, %695) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %697 = "vector.extract"(%691) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %698 = "func.call"(%689, %697) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %699 = "vector.extract"(%691) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %700 = "func.call"(%689, %699) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %701 = "vector.extract"(%691) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %702 = "func.call"(%689, %701) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %703 = "vector.extract"(%691) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %704 = "func.call"(%689, %703) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %705 = "vector.extract"(%691) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %706 = "func.call"(%689, %705) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %707 = "vector.extract"(%691) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %708 = "func.call"(%689, %707) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %709 = "vector.extract"(%691) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %710 = "func.call"(%689, %709) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %711 = "vector.from_elements"(%696, %698, %700, %702, %704, %706, %708, %710) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %712 = "arith.addf"(%694, %711) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
              %713 = "arith.subi"(%arg186, %675) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %714 = "arith.subi"(%arg187, %672) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%712, %682, %713, %714) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %687 = "air.channel.put"(%arg182, %arg183, %681) <{chan_name = @__orbit_fifo_stage4_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%687) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%668) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_34"}> ({
    ^bb0(%arg152: index, %arg153: index, %arg154: index, %arg155: index, %arg156: memref<17x129xf32>, %arg157: memref<129x80xf32>, %arg158: memref<17x80xf32>):
      %553 = "arith.constant"() <{value = 4 : index}> : () -> index
      %554 = "arith.constant"() <{value = 32 : index}> : () -> index
      %555 = "arith.constant"() <{value = 1 : index}> : () -> index
      %556 = "arith.constant"() <{value = 0 : index}> : () -> index
      %557 = "air.wait_all"() : () -> !air.async.token
      %558 = "scf.for"(%556, %553, %555, %557) ({
      ^bb0(%arg173: index, %arg174: !air.async.token):
        %654 = "arith.muli"(%arg173, %554) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %655 = "air.channel.put"(%arg174, %556, %556, %arg156, %654) <{chan_name = @__orbit_fifo_stage5_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%655) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %559 = "air.wait_all"() : () -> !air.async.token
      %560 = "scf.for"(%556, %553, %555, %559) ({
      ^bb0(%arg171: index, %arg172: !air.async.token):
        %652 = "arith.muli"(%arg171, %554) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %653 = "air.channel.put"(%arg172, %556, %556, %arg157, %652) <{chan_name = @__orbit_fifo_stage5_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%653) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %561 = "air.channel.put"(%556, %556, %arg156) <{chan_name = @__orbit_fifo_stage5_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 8, 128>, static_src_sizes = array<i64: 8, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %562 = "air.channel.put"(%556, %556, %arg157) <{chan_name = @__orbit_fifo_stage5_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %563 = "air.channel.get"(%556, %556, %arg158) <{chan_name = @__orbit_fifo_stage5_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 8, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_34"}> ({
        %564 = "arith.constant"() <{value = 1 : index}> : () -> index
        %565 = "air.herd"(%564, %564) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_34"}> ({
        ^bb0(%arg159: index, %arg160: index, %arg161: index, %arg162: index):
          %566 = "arith.constant"() <{value = 32 : index}> : () -> index
          %567 = "arith.constant"() <{value = 4 : index}> : () -> index
          %568 = "arith.constant"() <{value = 0 : index}> : () -> index
          %569 = "arith.constant"() <{value = 80 : index}> : () -> index
          %570 = "arith.constant"() <{value = 64 : index}> : () -> index
          %571 = "arith.constant"() <{value = 1 : index}> : () -> index
          %572 = "arith.constant"() <{value = 16 : index}> : () -> index
          %573 = "arith.constant"() <{value = 8 : index}> : () -> index
          %574 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %575 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : () -> memref<8xf32, 2 : i32>
          %576 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : () -> memref<256xf32, 2 : i32>
          %577 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : () -> memref<16xf32, 2 : i32>
          %578 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : () -> memref<512xf32, 2 : i32>
          %579 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<128xf32, 2 : i32>
          %580 = "memref.reinterpret_cast"(%579) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 34 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          "scf.for"(%573, %572, %571) ({
          ^bb0(%arg169: index):
            "scf.for"(%570, %569, %571) ({
            ^bb0(%arg170: index):
              %650 = "arith.subi"(%arg169, %573) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %651 = "arith.subi"(%arg170, %570) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%574, %580, %650, %651) <{nontemporal = false}> : (f32, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%568, %567, %571) ({
          ^bb0(%arg165: index):
            %613 = "arith.muli"(%arg165, %566) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %614 = "arith.muli"(%arg165, %566) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %615 = "arith.muli"(%arg165, %566) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %616 = "memref.reinterpret_cast"(%576) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 34 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %617 = "air.channel.get"(%arg159, %arg160, %576) <{chan_name = @__orbit_fifo_stage5_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            %618 = "memref.reinterpret_cast"(%578) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 34 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %619 = "air.channel.get"(%arg159, %arg160, %578) <{chan_name = @__orbit_fifo_stage5_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<512xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%617, %619) {orbit.computation_event = 88 : i64, orbit.phase = 34 : i64, orbit.phase_dependencies = array<i64: 33>, orbit.read_copies = array<i64: 115, 116, 117>, orbit.task = "gemm", orbit.write_copies = array<i64: 118>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%573, %572, %571) ({
            ^bb0(%arg166: index):
              "scf.for"(%570, %569, %573) ({
              ^bb0(%arg167: index):
                "scf.for"(%568, %566, %571) ({
                ^bb0(%arg168: index):
                  %620 = "arith.addi"(%arg168, %613) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %621 = "arith.subi"(%arg166, %573) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %622 = "arith.subi"(%620, %614) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %623 = "memref.load"(%616, %621, %622) <{nontemporal = false}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %624 = "arith.subi"(%620, %615) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %625 = "arith.subi"(%arg167, %570) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %626 = "vector.transfer_read"(%618, %624, %625, %574) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %627 = "arith.subi"(%arg166, %573) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %628 = "arith.subi"(%arg167, %570) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %629 = "vector.transfer_read"(%580, %627, %628, %574) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %630 = "vector.extract"(%626) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %631 = "func.call"(%623, %630) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %632 = "vector.extract"(%626) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %633 = "func.call"(%623, %632) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %634 = "vector.extract"(%626) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %635 = "func.call"(%623, %634) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %636 = "vector.extract"(%626) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %637 = "func.call"(%623, %636) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %638 = "vector.extract"(%626) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %639 = "func.call"(%623, %638) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %640 = "vector.extract"(%626) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %641 = "func.call"(%623, %640) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %642 = "vector.extract"(%626) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %643 = "func.call"(%623, %642) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %644 = "vector.extract"(%626) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %645 = "func.call"(%623, %644) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %646 = "vector.from_elements"(%631, %633, %635, %637, %639, %641, %643, %645) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                  %647 = "arith.addf"(%629, %646) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                  %648 = "arith.subi"(%arg166, %573) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %649 = "arith.subi"(%arg167, %570) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%647, %580, %648, %649) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %581 = "memref.reinterpret_cast"(%575) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 38 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %582 = "air.channel.get"(%arg159, %arg160, %575) <{chan_name = @__orbit_fifo_stage5_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<8xf32, 2 : i32>) -> !air.async.token
          %583 = "memref.reinterpret_cast"(%577) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 38 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %584 = "air.channel.get"(%arg159, %arg160, %577) <{chan_name = @__orbit_fifo_stage5_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<16xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%582, %584) {orbit.computation_event = 100 : i64, orbit.phase = 38 : i64, orbit.phase_dependencies = array<i64: 37>, orbit.read_copies = array<i64: 128, 129, 127>, orbit.task = "gemm", orbit.write_copies = array<i64: 130>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%573, %572, %571) ({
          ^bb0(%arg163: index):
            "scf.for"(%570, %569, %573) ({
            ^bb0(%arg164: index):
              %586 = "arith.subi"(%arg163, %573) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %587 = "memref.load"(%581, %586, %568) <{nontemporal = false}> : (memref<8x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
              %588 = "arith.subi"(%arg164, %570) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %589 = "vector.transfer_read"(%583, %568, %588, %574) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %590 = "arith.subi"(%arg163, %573) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %591 = "arith.subi"(%arg164, %570) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %592 = "vector.transfer_read"(%580, %590, %591, %574) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %593 = "vector.extract"(%589) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %594 = "func.call"(%587, %593) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %595 = "vector.extract"(%589) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %596 = "func.call"(%587, %595) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %597 = "vector.extract"(%589) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %598 = "func.call"(%587, %597) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %599 = "vector.extract"(%589) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %600 = "func.call"(%587, %599) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %601 = "vector.extract"(%589) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %602 = "func.call"(%587, %601) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %603 = "vector.extract"(%589) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %604 = "func.call"(%587, %603) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %605 = "vector.extract"(%589) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %606 = "func.call"(%587, %605) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %607 = "vector.extract"(%589) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %608 = "func.call"(%587, %607) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %609 = "vector.from_elements"(%594, %596, %598, %600, %602, %604, %606, %608) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %610 = "arith.addf"(%592, %609) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
              %611 = "arith.subi"(%arg163, %573) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %612 = "arith.subi"(%arg164, %570) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%610, %580, %611, %612) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %585 = "air.channel.put"(%arg159, %arg160, %579) <{chan_name = @__orbit_fifo_stage5_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<128xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%585) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%565) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_39"}> ({
    ^bb0(%arg132: index, %arg133: index, %arg134: index, %arg135: index, %arg136: memref<17x129xf32>, %arg137: memref<129x80xf32>, %arg138: memref<17x80xf32>):
      %467 = "arith.constant"() <{value = 32 : index}> : () -> index
      %468 = "arith.constant"() <{value = 4 : index}> : () -> index
      %469 = "arith.constant"() <{value = 1 : index}> : () -> index
      %470 = "arith.constant"() <{value = 0 : index}> : () -> index
      %471 = "air.wait_all"() : () -> !air.async.token
      %472 = "scf.for"(%470, %468, %469, %471) ({
      ^bb0(%arg150: index, %arg151: !air.async.token):
        %551 = "arith.muli"(%arg150, %467) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %552 = "air.channel.put"(%arg151, %470, %470, %arg136, %551) <{chan_name = @__orbit_fifo_stage6_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%552) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %473 = "air.wait_all"() : () -> !air.async.token
      %474 = "scf.for"(%470, %468, %469, %473) ({
      ^bb0(%arg148: index, %arg149: !air.async.token):
        %549 = "arith.muli"(%arg148, %467) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %550 = "air.channel.put"(%arg149, %470, %470, %arg137, %549) <{chan_name = @__orbit_fifo_stage6_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%550) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %475 = "air.channel.put"(%470, %470, %arg136) <{chan_name = @__orbit_fifo_stage6_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %476 = "air.channel.put"(%470, %470, %arg137) <{chan_name = @__orbit_fifo_stage6_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %477 = "air.channel.get"(%470, %470, %arg138) <{chan_name = @__orbit_fifo_stage6_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 16, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_39"}> ({
        %478 = "arith.constant"() <{value = 1 : index}> : () -> index
        %479 = "air.herd"(%478, %478) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_39"}> ({
        ^bb0(%arg139: index, %arg140: index, %arg141: index, %arg142: index):
          %480 = "arith.constant"() <{value = 8 : index}> : () -> index
          %481 = "arith.constant"() <{value = 4 : index}> : () -> index
          %482 = "arith.constant"() <{value = 32 : index}> : () -> index
          %483 = "arith.constant"() <{value = 0 : index}> : () -> index
          %484 = "arith.constant"() <{value = 1 : index}> : () -> index
          %485 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %486 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : () -> memref<1xf32, 2 : i32>
          %487 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : () -> memref<32xf32, 2 : i32>
          %488 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : () -> memref<32xf32, 2 : i32>
          %489 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : () -> memref<1024xf32, 2 : i32>
          %490 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<32xf32, 2 : i32>
          %491 = "memref.reinterpret_cast"(%490) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 39 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          "scf.for"(%483, %482, %484) ({
          ^bb0(%arg147: index):
            "memref.store"(%485, %491, %483, %arg147) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%483, %481, %484) ({
          ^bb0(%arg144: index):
            %518 = "arith.muli"(%arg144, %482) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %519 = "arith.muli"(%arg144, %482) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %520 = "arith.muli"(%arg144, %482) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %521 = "memref.reinterpret_cast"(%487) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 39 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %522 = "air.channel.get"(%arg139, %arg140, %487) <{chan_name = @__orbit_fifo_stage6_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
            %523 = "memref.reinterpret_cast"(%489) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 39 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %524 = "air.channel.get"(%arg139, %arg140, %489) <{chan_name = @__orbit_fifo_stage6_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1024xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%522, %524) {orbit.computation_event = 105 : i64, orbit.phase = 39 : i64, orbit.phase_dependencies = array<i64: 38>, orbit.read_copies = array<i64: 132, 133, 134>, orbit.task = "gemm", orbit.write_copies = array<i64: 135>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%483, %482, %480) ({
            ^bb0(%arg145: index):
              "scf.for"(%483, %482, %484) ({
              ^bb0(%arg146: index):
                %525 = "arith.addi"(%arg146, %518) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %526 = "arith.subi"(%525, %519) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %527 = "memref.load"(%521, %483, %526) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %528 = "arith.subi"(%525, %520) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %529 = "vector.transfer_read"(%523, %528, %arg145, %485) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %530 = "vector.transfer_read"(%491, %483, %arg145, %485) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %531 = "vector.extract"(%529) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                %532 = "func.call"(%527, %531) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %533 = "vector.extract"(%529) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                %534 = "func.call"(%527, %533) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %535 = "vector.extract"(%529) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                %536 = "func.call"(%527, %535) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %537 = "vector.extract"(%529) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                %538 = "func.call"(%527, %537) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %539 = "vector.extract"(%529) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                %540 = "func.call"(%527, %539) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %541 = "vector.extract"(%529) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                %542 = "func.call"(%527, %541) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %543 = "vector.extract"(%529) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                %544 = "func.call"(%527, %543) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %545 = "vector.extract"(%529) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                %546 = "func.call"(%527, %545) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %547 = "vector.from_elements"(%532, %534, %536, %538, %540, %542, %544, %546) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                %548 = "arith.addf"(%530, %547) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                "vector.transfer_write"(%548, %491, %483, %arg145) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %492 = "memref.reinterpret_cast"(%486) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 43 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %493 = "air.channel.get"(%arg139, %arg140, %486) <{chan_name = @__orbit_fifo_stage6_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1xf32, 2 : i32>) -> !air.async.token
          %494 = "memref.reinterpret_cast"(%488) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 43 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %495 = "air.channel.get"(%arg139, %arg140, %488) <{chan_name = @__orbit_fifo_stage6_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%493, %495) {orbit.computation_event = 117 : i64, orbit.phase = 43 : i64, orbit.phase_dependencies = array<i64: 42>, orbit.read_copies = array<i64: 145, 146, 144>, orbit.task = "gemm", orbit.write_copies = array<i64: 147>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%483, %482, %480) ({
          ^bb0(%arg143: index):
            %497 = "memref.load"(%492, %483, %483) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
            %498 = "vector.transfer_read"(%494, %483, %arg143, %485) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
            %499 = "vector.transfer_read"(%491, %483, %arg143, %485) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
            %500 = "vector.extract"(%498) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
            %501 = "func.call"(%497, %500) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %502 = "vector.extract"(%498) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
            %503 = "func.call"(%497, %502) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %504 = "vector.extract"(%498) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
            %505 = "func.call"(%497, %504) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %506 = "vector.extract"(%498) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
            %507 = "func.call"(%497, %506) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %508 = "vector.extract"(%498) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
            %509 = "func.call"(%497, %508) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %510 = "vector.extract"(%498) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
            %511 = "func.call"(%497, %510) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %512 = "vector.extract"(%498) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
            %513 = "func.call"(%497, %512) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %514 = "vector.extract"(%498) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
            %515 = "func.call"(%497, %514) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %516 = "vector.from_elements"(%501, %503, %505, %507, %509, %511, %513, %515) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
            %517 = "arith.addf"(%499, %516) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
            "vector.transfer_write"(%517, %491, %483, %arg143) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %496 = "air.channel.put"(%arg139, %arg140, %490) <{chan_name = @__orbit_fifo_stage6_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%496) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%479) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_44"}> ({
    ^bb0(%arg112: index, %arg113: index, %arg114: index, %arg115: index, %arg116: memref<17x129xf32>, %arg117: memref<129x80xf32>, %arg118: memref<17x80xf32>):
      %373 = "arith.constant"() <{value = 32 : index}> : () -> index
      %374 = "arith.constant"() <{value = 4 : index}> : () -> index
      %375 = "arith.constant"() <{value = 1 : index}> : () -> index
      %376 = "arith.constant"() <{value = 0 : index}> : () -> index
      %377 = "air.wait_all"() : () -> !air.async.token
      %378 = "scf.for"(%376, %374, %375, %377) ({
      ^bb0(%arg130: index, %arg131: !air.async.token):
        %465 = "arith.muli"(%arg130, %373) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %466 = "air.channel.put"(%arg131, %376, %376, %arg116, %465) <{chan_name = @__orbit_fifo_stage7_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%466) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %379 = "air.wait_all"() : () -> !air.async.token
      %380 = "scf.for"(%376, %374, %375, %379) ({
      ^bb0(%arg128: index, %arg129: !air.async.token):
        %463 = "arith.muli"(%arg128, %373) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %464 = "air.channel.put"(%arg129, %376, %376, %arg117, %463) <{chan_name = @__orbit_fifo_stage7_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 32>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%464) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %381 = "air.channel.put"(%376, %376, %arg116) <{chan_name = @__orbit_fifo_stage7_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %382 = "air.channel.put"(%376, %376, %arg117) <{chan_name = @__orbit_fifo_stage7_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 32>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %383 = "air.channel.get"(%376, %376, %arg118) <{chan_name = @__orbit_fifo_stage7_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 16, 32>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_44"}> ({
        %384 = "arith.constant"() <{value = 1 : index}> : () -> index
        %385 = "air.herd"(%384, %384) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_44"}> ({
        ^bb0(%arg119: index, %arg120: index, %arg121: index, %arg122: index):
          %386 = "arith.constant"() <{value = 8 : index}> : () -> index
          %387 = "arith.constant"() <{value = 4 : index}> : () -> index
          %388 = "arith.constant"() <{value = 0 : index}> : () -> index
          %389 = "arith.constant"() <{value = 64 : index}> : () -> index
          %390 = "arith.constant"() <{value = 32 : index}> : () -> index
          %391 = "arith.constant"() <{value = 1 : index}> : () -> index
          %392 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %393 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : () -> memref<1xf32, 2 : i32>
          %394 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : () -> memref<32xf32, 2 : i32>
          %395 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : () -> memref<32xf32, 2 : i32>
          %396 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : () -> memref<1024xf32, 2 : i32>
          %397 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<32xf32, 2 : i32>
          %398 = "memref.reinterpret_cast"(%397) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 44 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          "scf.for"(%390, %389, %391) ({
          ^bb0(%arg127: index):
            %462 = "arith.subi"(%arg127, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            "memref.store"(%392, %398, %388, %462) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%388, %387, %391) ({
          ^bb0(%arg124: index):
            %428 = "arith.muli"(%arg124, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %429 = "arith.muli"(%arg124, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %430 = "arith.muli"(%arg124, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %431 = "memref.reinterpret_cast"(%394) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 44 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %432 = "air.channel.get"(%arg119, %arg120, %394) <{chan_name = @__orbit_fifo_stage7_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
            %433 = "memref.reinterpret_cast"(%396) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 44 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %434 = "air.channel.get"(%arg119, %arg120, %396) <{chan_name = @__orbit_fifo_stage7_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1024xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%432, %434) {orbit.computation_event = 122 : i64, orbit.phase = 44 : i64, orbit.phase_dependencies = array<i64: 43>, orbit.read_copies = array<i64: 149, 150, 151>, orbit.task = "gemm", orbit.write_copies = array<i64: 152>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%390, %389, %386) ({
            ^bb0(%arg125: index):
              "scf.for"(%388, %390, %391) ({
              ^bb0(%arg126: index):
                %435 = "arith.addi"(%arg126, %428) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %436 = "arith.subi"(%435, %429) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %437 = "memref.load"(%431, %388, %436) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %438 = "arith.subi"(%435, %430) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %439 = "arith.subi"(%arg125, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %440 = "vector.transfer_read"(%433, %438, %439, %392) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %441 = "arith.subi"(%arg125, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %442 = "vector.transfer_read"(%398, %388, %441, %392) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %443 = "vector.extract"(%440) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                %444 = "func.call"(%437, %443) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %445 = "vector.extract"(%440) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                %446 = "func.call"(%437, %445) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %447 = "vector.extract"(%440) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                %448 = "func.call"(%437, %447) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %449 = "vector.extract"(%440) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                %450 = "func.call"(%437, %449) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %451 = "vector.extract"(%440) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                %452 = "func.call"(%437, %451) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %453 = "vector.extract"(%440) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                %454 = "func.call"(%437, %453) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %455 = "vector.extract"(%440) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                %456 = "func.call"(%437, %455) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %457 = "vector.extract"(%440) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                %458 = "func.call"(%437, %457) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %459 = "vector.from_elements"(%444, %446, %448, %450, %452, %454, %456, %458) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                %460 = "arith.addf"(%442, %459) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                %461 = "arith.subi"(%arg125, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "vector.transfer_write"(%460, %398, %388, %461) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %399 = "memref.reinterpret_cast"(%393) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 48 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %400 = "air.channel.get"(%arg119, %arg120, %393) <{chan_name = @__orbit_fifo_stage7_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1xf32, 2 : i32>) -> !air.async.token
          %401 = "memref.reinterpret_cast"(%395) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 48 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %402 = "air.channel.get"(%arg119, %arg120, %395) <{chan_name = @__orbit_fifo_stage7_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%400, %402) {orbit.computation_event = 134 : i64, orbit.phase = 48 : i64, orbit.phase_dependencies = array<i64: 47>, orbit.read_copies = array<i64: 162, 163, 161>, orbit.task = "gemm", orbit.write_copies = array<i64: 164>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%390, %389, %386) ({
          ^bb0(%arg123: index):
            %404 = "memref.load"(%399, %388, %388) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
            %405 = "arith.subi"(%arg123, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %406 = "vector.transfer_read"(%401, %388, %405, %392) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
            %407 = "arith.subi"(%arg123, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %408 = "vector.transfer_read"(%398, %388, %407, %392) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
            %409 = "vector.extract"(%406) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
            %410 = "func.call"(%404, %409) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %411 = "vector.extract"(%406) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
            %412 = "func.call"(%404, %411) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %413 = "vector.extract"(%406) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
            %414 = "func.call"(%404, %413) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %415 = "vector.extract"(%406) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
            %416 = "func.call"(%404, %415) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %417 = "vector.extract"(%406) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
            %418 = "func.call"(%404, %417) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %419 = "vector.extract"(%406) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
            %420 = "func.call"(%404, %419) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %421 = "vector.extract"(%406) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
            %422 = "func.call"(%404, %421) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %423 = "vector.extract"(%406) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
            %424 = "func.call"(%404, %423) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %425 = "vector.from_elements"(%410, %412, %414, %416, %418, %420, %422, %424) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
            %426 = "arith.addf"(%408, %425) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
            %427 = "arith.subi"(%arg123, %390) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            "vector.transfer_write"(%426, %398, %388, %427) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %403 = "air.channel.put"(%arg119, %arg120, %397) <{chan_name = @__orbit_fifo_stage7_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%403) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%385) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_49"}> ({
    ^bb0(%arg92: index, %arg93: index, %arg94: index, %arg95: index, %arg96: memref<17x129xf32>, %arg97: memref<129x80xf32>, %arg98: memref<17x80xf32>):
      %278 = "arith.constant"() <{value = 4 : index}> : () -> index
      %279 = "arith.constant"() <{value = 32 : index}> : () -> index
      %280 = "arith.constant"() <{value = 1 : index}> : () -> index
      %281 = "arith.constant"() <{value = 0 : index}> : () -> index
      %282 = "air.wait_all"() : () -> !air.async.token
      %283 = "scf.for"(%281, %278, %280, %282) ({
      ^bb0(%arg110: index, %arg111: !air.async.token):
        %371 = "arith.muli"(%arg110, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %372 = "air.channel.put"(%arg111, %281, %281, %arg96, %371) <{chan_name = @__orbit_fifo_stage8_storage0_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 129, 1>}> : (!air.async.token, index, index, memref<17x129xf32>, index) -> !air.async.token
        "scf.yield"(%372) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %284 = "air.wait_all"() : () -> !air.async.token
      %285 = "scf.for"(%281, %278, %280, %284) ({
      ^bb0(%arg108: index, %arg109: !air.async.token):
        %369 = "arith.muli"(%arg108, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %370 = "air.channel.put"(%arg109, %281, %281, %arg97, %369) <{chan_name = @__orbit_fifo_stage8_storage1_in, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: -9223372036854775808, 64>, static_src_sizes = array<i64: 32, 16>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<129x80xf32>, index) -> !air.async.token
        "scf.yield"(%370) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %286 = "air.channel.put"(%281, %281, %arg96) <{chan_name = @__orbit_fifo_stage8_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 16, 128>, static_src_sizes = array<i64: 1, 1>, static_src_strides = array<i64: 129, 1>}> : (index, index, memref<17x129xf32>) -> !air.async.token
      %287 = "air.channel.put"(%281, %281, %arg97) <{chan_name = @__orbit_fifo_stage8_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 128, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<129x80xf32>) -> !air.async.token
      %288 = "air.channel.get"(%281, %281, %arg98) <{chan_name = @__orbit_fifo_stage8_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 16, 64>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_49"}> ({
        %289 = "arith.constant"() <{value = 1 : index}> : () -> index
        %290 = "air.herd"(%289, %289) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_49"}> ({
        ^bb0(%arg99: index, %arg100: index, %arg101: index, %arg102: index):
          %291 = "arith.constant"() <{value = 8 : index}> : () -> index
          %292 = "arith.constant"() <{value = 32 : index}> : () -> index
          %293 = "arith.constant"() <{value = 4 : index}> : () -> index
          %294 = "arith.constant"() <{value = 0 : index}> : () -> index
          %295 = "arith.constant"() <{value = 80 : index}> : () -> index
          %296 = "arith.constant"() <{value = 64 : index}> : () -> index
          %297 = "arith.constant"() <{value = 1 : index}> : () -> index
          %298 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %299 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.16.1"} : () -> memref<1xf32, 2 : i32>
          %300 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.16.32"} : () -> memref<32xf32, 2 : i32>
          %301 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.1.16.1"} : () -> memref<16xf32, 2 : i32>
          %302 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.1.16.32"} : () -> memref<512xf32, 2 : i32>
          %303 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<16xf32, 2 : i32>
          %304 = "memref.reinterpret_cast"(%303) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 49 : i64, orbit.storage = "intermediate"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          "scf.for"(%296, %295, %297) ({
          ^bb0(%arg107: index):
            %368 = "arith.subi"(%arg107, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            "memref.store"(%298, %304, %294, %368) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "scf.for"(%294, %293, %297) ({
          ^bb0(%arg104: index):
            %334 = "arith.muli"(%arg104, %292) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %335 = "arith.muli"(%arg104, %292) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %336 = "arith.muli"(%arg104, %292) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %337 = "memref.reinterpret_cast"(%300) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 49 : i64, orbit.storage = "A"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %338 = "air.channel.get"(%arg99, %arg100, %300) <{chan_name = @__orbit_fifo_stage8_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<32xf32, 2 : i32>) -> !air.async.token
            %339 = "memref.reinterpret_cast"(%302) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 49 : i64, orbit.storage = "B"} : (memref<512xf32, 2 : i32>) -> memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %340 = "air.channel.get"(%arg99, %arg100, %302) <{chan_name = @__orbit_fifo_stage8_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<512xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%338, %340) {orbit.computation_event = 139 : i64, orbit.phase = 49 : i64, orbit.phase_dependencies = array<i64: 48>, orbit.read_copies = array<i64: 166, 167, 168>, orbit.task = "gemm", orbit.write_copies = array<i64: 169>} : (!air.async.token, !air.async.token) -> ()
            "scf.for"(%296, %295, %291) ({
            ^bb0(%arg105: index):
              "scf.for"(%294, %292, %297) ({
              ^bb0(%arg106: index):
                %341 = "arith.addi"(%arg106, %334) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %342 = "arith.subi"(%341, %335) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %343 = "memref.load"(%337, %294, %342) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %344 = "arith.subi"(%341, %336) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %345 = "arith.subi"(%arg105, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %346 = "vector.transfer_read"(%339, %344, %345, %298) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<32x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %347 = "arith.subi"(%arg105, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %348 = "vector.transfer_read"(%304, %294, %347, %298) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %349 = "vector.extract"(%346) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                %350 = "func.call"(%343, %349) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %351 = "vector.extract"(%346) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                %352 = "func.call"(%343, %351) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %353 = "vector.extract"(%346) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                %354 = "func.call"(%343, %353) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %355 = "vector.extract"(%346) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                %356 = "func.call"(%343, %355) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %357 = "vector.extract"(%346) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                %358 = "func.call"(%343, %357) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %359 = "vector.extract"(%346) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                %360 = "func.call"(%343, %359) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %361 = "vector.extract"(%346) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                %362 = "func.call"(%343, %361) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %363 = "vector.extract"(%346) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                %364 = "func.call"(%343, %363) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %365 = "vector.from_elements"(%350, %352, %354, %356, %358, %360, %362, %364) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                %366 = "arith.addf"(%348, %365) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                %367 = "arith.subi"(%arg105, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "vector.transfer_write"(%366, %304, %294, %367) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.compressed_phases = 4 : i64} : (index, index, index) -> ()
          %305 = "memref.reinterpret_cast"(%299) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 1>, static_strides = array<i64: 1, 1>}> {orbit.phase = 53 : i64, orbit.storage = "A"} : (memref<1xf32, 2 : i32>) -> memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %306 = "air.channel.get"(%arg99, %arg100, %299) <{chan_name = @__orbit_fifo_stage8_storage0_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<1xf32, 2 : i32>) -> !air.async.token
          %307 = "memref.reinterpret_cast"(%301) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 53 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %308 = "air.channel.get"(%arg99, %arg100, %301) <{chan_name = @__orbit_fifo_stage8_storage1_in, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<16xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%306, %308) {orbit.computation_event = 151 : i64, orbit.phase = 53 : i64, orbit.phase_dependencies = array<i64: 52>, orbit.read_copies = array<i64: 179, 180, 178>, orbit.task = "gemm", orbit.write_copies = array<i64: 181>} : (!air.async.token, !air.async.token) -> ()
          "scf.for"(%296, %295, %291) ({
          ^bb0(%arg103: index):
            %310 = "memref.load"(%305, %294, %294) <{nontemporal = false}> : (memref<1x1xf32, strided<[1, 1]>, 2 : i32>, index, index) -> f32
            %311 = "arith.subi"(%arg103, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %312 = "vector.transfer_read"(%307, %294, %311, %298) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
            %313 = "arith.subi"(%arg103, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %314 = "vector.transfer_read"(%304, %294, %313, %298) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
            %315 = "vector.extract"(%312) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
            %316 = "func.call"(%310, %315) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %317 = "vector.extract"(%312) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
            %318 = "func.call"(%310, %317) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %319 = "vector.extract"(%312) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
            %320 = "func.call"(%310, %319) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %321 = "vector.extract"(%312) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
            %322 = "func.call"(%310, %321) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %323 = "vector.extract"(%312) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
            %324 = "func.call"(%310, %323) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %325 = "vector.extract"(%312) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
            %326 = "func.call"(%310, %325) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %327 = "vector.extract"(%312) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
            %328 = "func.call"(%310, %327) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %329 = "vector.extract"(%312) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
            %330 = "func.call"(%310, %329) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %331 = "vector.from_elements"(%316, %318, %320, %322, %324, %326, %328, %330) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
            %332 = "arith.addf"(%314, %331) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
            %333 = "arith.subi"(%arg103, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            "vector.transfer_write"(%332, %304, %294, %333) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %309 = "air.channel.put"(%arg99, %arg100, %303) <{chan_name = @__orbit_fifo_stage8_storage3_out, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<16xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%309) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%290) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg2, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch_54"}> ({
    ^bb0(%arg74: index, %arg75: index, %arg76: index, %arg77: index, %arg78: memref<17x80xf32>, %arg79: memref<17x80xf32>):
      %225 = "arith.constant"() <{value = 2 : index}> : () -> index
      %226 = "arith.constant"() <{value = 32 : index}> : () -> index
      %227 = "arith.constant"() <{value = 1 : index}> : () -> index
      %228 = "arith.constant"() <{value = 0 : index}> : () -> index
      %229 = "air.wait_all"() : () -> !air.async.token
      %230 = "scf.for"(%228, %225, %227, %229) ({
      ^bb0(%arg90: index, %arg91: !air.async.token):
        %276 = "arith.muli"(%arg90, %226) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %277 = "air.channel.put"(%arg91, %228, %228, %arg79, %276) <{chan_name = @channel_45, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<17x80xf32>, index) -> !air.async.token
        "scf.yield"(%277) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %231 = "air.wait_all"() : () -> !air.async.token
      %232 = "scf.for"(%228, %225, %227, %231) ({
      ^bb0(%arg88: index, %arg89: !air.async.token):
        %274 = "arith.muli"(%arg88, %226) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %275 = "air.channel.get"(%arg89, %228, %228, %arg78, %274) <{chan_name = @channel_46, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0>, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<17x80xf32>, index) -> !air.async.token
        "scf.yield"(%275) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_54"}> ({
        %233 = "arith.constant"() <{value = 1 : index}> : () -> index
        %234 = "air.herd"(%233, %233) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_54"}> ({
        ^bb0(%arg80: index, %arg81: index, %arg82: index, %arg83: index):
          %235 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %236 = "arith.constant"() <{value = 8 : index}> : () -> index
          %237 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %238 = "arith.constant"() <{value = 32 : index}> : () -> index
          %239 = "arith.constant"() <{value = 1 : index}> : () -> index
          %240 = "arith.constant"() <{value = 2 : index}> : () -> index
          %241 = "arith.constant"() <{value = 0 : index}> : () -> index
          %242 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<256xf32, 2 : i32>
          %243 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : () -> memref<256xf32, 2 : i32>
          %244 = "air.wait_all"() : () -> !air.async.token
          %245 = "scf.for"(%241, %240, %239, %244) ({
          ^bb0(%arg84: index, %arg85: !air.async.token):
            %246 = "arith.muli"(%arg84, %238) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %247 = "arith.muli"(%arg84, %238) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %248 = "arith.muli"(%arg84, %238) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %249 = "memref.reinterpret_cast"(%242) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 54 : i64, orbit.storage = "Y"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %250 = "memref.reinterpret_cast"(%243) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 54 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %251 = "air.channel.get"(%arg85, %arg80, %arg81, %243) <{chan_name = @channel_45, operandSegmentSizes = array<i32: 1, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (!air.async.token, index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%251) {orbit.computation_event = 154 : i64, orbit.phase = 54 : i64, orbit.phase_dependencies = array<i64: 53>, orbit.read_copies = array<i64: 183>, orbit.task = "scale", orbit.write_copies = array<i64: 184>} : (!air.async.token) -> ()
            "scf.for"(%241, %236, %239) ({
            ^bb0(%arg86: index):
              "scf.for"(%241, %238, %236) ({
              ^bb0(%arg87: index):
                %253 = "arith.addi"(%arg87, %246) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %254 = "arith.subi"(%253, %248) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %255 = "vector.transfer_read"(%250, %arg86, %254, %235) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %256 = "vector.extract"(%255) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                %257 = "func.call"(%256, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %258 = "vector.extract"(%255) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                %259 = "func.call"(%258, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %260 = "vector.extract"(%255) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                %261 = "func.call"(%260, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %262 = "vector.extract"(%255) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                %263 = "func.call"(%262, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %264 = "vector.extract"(%255) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                %265 = "func.call"(%264, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %266 = "vector.extract"(%255) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                %267 = "func.call"(%266, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %268 = "vector.extract"(%255) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                %269 = "func.call"(%268, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %270 = "vector.extract"(%255) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                %271 = "func.call"(%270, %237) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %272 = "vector.from_elements"(%257, %259, %261, %263, %265, %267, %269, %271) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                %273 = "arith.subi"(%253, %247) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "vector.transfer_write"(%272, %249, %arg86, %273) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %252 = "air.channel.put"(%arg85, %arg80, %arg81, %242) <{chan_name = @channel_46, operandSegmentSizes = array<i32: 1, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (!air.async.token, index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            "scf.yield"(%252) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%245) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%234) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg2, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch_56"}> ({
    ^bb0(%arg62: index, %arg63: index, %arg64: index, %arg65: index, %arg66: memref<17x80xf32>, %arg67: memref<17x80xf32>):
      %187 = "arith.constant"() <{value = 0 : index}> : () -> index
      %188 = "air.channel.put"(%187, %187, %arg67) <{chan_name = @channel_47, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 0, 64>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      %189 = "air.channel.get"(%187, %187, %arg66) <{chan_name = @channel_48, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 0, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_56"}> ({
        %190 = "arith.constant"() <{value = 1 : index}> : () -> index
        %191 = "air.herd"(%190, %190) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_56"}> ({
        ^bb0(%arg68: index, %arg69: index, %arg70: index, %arg71: index):
          %192 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %193 = "arith.constant"() <{value = 80 : index}> : () -> index
          %194 = "arith.constant"() <{value = 64 : index}> : () -> index
          %195 = "arith.constant"() <{value = 1 : index}> : () -> index
          %196 = "arith.constant"() <{value = 8 : index}> : () -> index
          %197 = "arith.constant"() <{value = 0 : index}> : () -> index
          %198 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %199 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<128xf32, 2 : i32>
          %200 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : () -> memref<128xf32, 2 : i32>
          %201 = "memref.reinterpret_cast"(%199) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 56 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %202 = "memref.reinterpret_cast"(%200) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 56 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %203 = "air.channel.get"(%arg68, %arg69, %200) <{chan_name = @channel_47, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<128xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%203) {orbit.computation_event = 160 : i64, orbit.phase = 56 : i64, orbit.phase_dependencies = array<i64: 55>, orbit.read_copies = array<i64: 189>, orbit.task = "scale", orbit.write_copies = array<i64: 190>} : (!air.async.token) -> ()
          "scf.for"(%197, %196, %195) ({
          ^bb0(%arg72: index):
            "scf.for"(%194, %193, %196) ({
            ^bb0(%arg73: index):
              %205 = "arith.subi"(%arg73, %194) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %206 = "vector.transfer_read"(%202, %arg72, %205, %192) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %207 = "vector.extract"(%206) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %208 = "func.call"(%207, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %209 = "vector.extract"(%206) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %210 = "func.call"(%209, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %211 = "vector.extract"(%206) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %212 = "func.call"(%211, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %213 = "vector.extract"(%206) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %214 = "func.call"(%213, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %215 = "vector.extract"(%206) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %216 = "func.call"(%215, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %217 = "vector.extract"(%206) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %218 = "func.call"(%217, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %219 = "vector.extract"(%206) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %220 = "func.call"(%219, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %221 = "vector.extract"(%206) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %222 = "func.call"(%221, %198) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %223 = "vector.from_elements"(%208, %210, %212, %214, %216, %218, %220, %222) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %224 = "arith.subi"(%arg73, %194) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%223, %201, %arg72, %224) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %204 = "air.channel.put"(%arg68, %arg69, %199) <{chan_name = @channel_48, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<128xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%204) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%191) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg2, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch_57"}> ({
    ^bb0(%arg44: index, %arg45: index, %arg46: index, %arg47: index, %arg48: memref<17x80xf32>, %arg49: memref<17x80xf32>):
      %131 = "arith.constant"() <{value = 2 : index}> : () -> index
      %132 = "arith.constant"() <{value = 32 : index}> : () -> index
      %133 = "arith.constant"() <{value = 1 : index}> : () -> index
      %134 = "arith.constant"() <{value = 0 : index}> : () -> index
      %135 = "air.wait_all"() : () -> !air.async.token
      %136 = "scf.for"(%134, %131, %133, %135) ({
      ^bb0(%arg60: index, %arg61: !air.async.token):
        %185 = "arith.muli"(%arg60, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %186 = "air.channel.put"(%arg61, %134, %134, %arg49, %185) <{chan_name = @channel_49, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 8, -9223372036854775808>, static_src_sizes = array<i64: 8, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<17x80xf32>, index) -> !air.async.token
        "scf.yield"(%186) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %137 = "air.wait_all"() : () -> !air.async.token
      %138 = "scf.for"(%134, %131, %133, %137) ({
      ^bb0(%arg58: index, %arg59: !air.async.token):
        %183 = "arith.muli"(%arg58, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %184 = "air.channel.get"(%arg59, %134, %134, %arg48, %183) <{chan_name = @channel_50, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0>, static_dst_offsets = array<i64: 8, -9223372036854775808>, static_dst_sizes = array<i64: 8, 32>, static_dst_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<17x80xf32>, index) -> !air.async.token
        "scf.yield"(%184) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_57"}> ({
        %139 = "arith.constant"() <{value = 1 : index}> : () -> index
        %140 = "air.herd"(%139, %139) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_57"}> ({
        ^bb0(%arg50: index, %arg51: index, %arg52: index, %arg53: index):
          %141 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %142 = "arith.constant"() <{value = 16 : index}> : () -> index
          %143 = "arith.constant"() <{value = 8 : index}> : () -> index
          %144 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %145 = "arith.constant"() <{value = 32 : index}> : () -> index
          %146 = "arith.constant"() <{value = 1 : index}> : () -> index
          %147 = "arith.constant"() <{value = 2 : index}> : () -> index
          %148 = "arith.constant"() <{value = 0 : index}> : () -> index
          %149 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<256xf32, 2 : i32>
          %150 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : () -> memref<256xf32, 2 : i32>
          %151 = "air.wait_all"() : () -> !air.async.token
          %152 = "scf.for"(%148, %147, %146, %151) ({
          ^bb0(%arg54: index, %arg55: !air.async.token):
            %153 = "arith.muli"(%arg54, %145) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %154 = "arith.muli"(%arg54, %145) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %155 = "arith.muli"(%arg54, %145) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %156 = "memref.reinterpret_cast"(%149) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 57 : i64, orbit.storage = "Y"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %157 = "memref.reinterpret_cast"(%150) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 57 : i64, orbit.storage = "intermediate"} : (memref<256xf32, 2 : i32>) -> memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %158 = "air.channel.get"(%arg55, %arg50, %arg51, %150) <{chan_name = @channel_49, operandSegmentSizes = array<i32: 1, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (!air.async.token, index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%158) {orbit.computation_event = 163 : i64, orbit.phase = 57 : i64, orbit.phase_dependencies = array<i64: 56>, orbit.read_copies = array<i64: 192>, orbit.task = "scale", orbit.write_copies = array<i64: 193>} : (!air.async.token) -> ()
            "scf.for"(%143, %142, %146) ({
            ^bb0(%arg56: index):
              "scf.for"(%148, %145, %143) ({
              ^bb0(%arg57: index):
                %160 = "arith.addi"(%arg57, %153) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %161 = "arith.subi"(%arg56, %143) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %162 = "arith.subi"(%160, %155) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %163 = "vector.transfer_read"(%157, %161, %162, %141) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                %164 = "vector.extract"(%163) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                %165 = "func.call"(%164, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %166 = "vector.extract"(%163) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                %167 = "func.call"(%166, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %168 = "vector.extract"(%163) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                %169 = "func.call"(%168, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %170 = "vector.extract"(%163) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                %171 = "func.call"(%170, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %172 = "vector.extract"(%163) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                %173 = "func.call"(%172, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %174 = "vector.extract"(%163) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                %175 = "func.call"(%174, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %176 = "vector.extract"(%163) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                %177 = "func.call"(%176, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %178 = "vector.extract"(%163) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                %179 = "func.call"(%178, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %180 = "vector.from_elements"(%165, %167, %169, %171, %173, %175, %177, %179) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
                %181 = "arith.subi"(%arg56, %143) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %182 = "arith.subi"(%160, %154) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "vector.transfer_write"(%180, %156, %181, %182) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %159 = "air.channel.put"(%arg55, %arg50, %arg51, %149) <{chan_name = @channel_50, operandSegmentSizes = array<i32: 1, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (!air.async.token, index, index, memref<256xf32, 2 : i32>) -> !air.async.token
            "scf.yield"(%159) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%152) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%140) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg2, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch_59"}> ({
    ^bb0(%arg32: index, %arg33: index, %arg34: index, %arg35: index, %arg36: memref<17x80xf32>, %arg37: memref<17x80xf32>):
      %91 = "arith.constant"() <{value = 0 : index}> : () -> index
      %92 = "air.channel.put"(%91, %91, %arg37) <{chan_name = @channel_51, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 8, 64>, static_src_sizes = array<i64: 8, 16>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      %93 = "air.channel.get"(%91, %91, %arg36) <{chan_name = @channel_52, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 8, 64>, static_dst_sizes = array<i64: 8, 16>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_59"}> ({
        %94 = "arith.constant"() <{value = 1 : index}> : () -> index
        %95 = "air.herd"(%94, %94) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_59"}> ({
        ^bb0(%arg38: index, %arg39: index, %arg40: index, %arg41: index):
          %96 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %97 = "arith.constant"() <{value = 80 : index}> : () -> index
          %98 = "arith.constant"() <{value = 64 : index}> : () -> index
          %99 = "arith.constant"() <{value = 1 : index}> : () -> index
          %100 = "arith.constant"() <{value = 16 : index}> : () -> index
          %101 = "arith.constant"() <{value = 8 : index}> : () -> index
          %102 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %103 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<128xf32, 2 : i32>
          %104 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : () -> memref<128xf32, 2 : i32>
          %105 = "memref.reinterpret_cast"(%103) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 59 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %106 = "memref.reinterpret_cast"(%104) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 59 : i64, orbit.storage = "intermediate"} : (memref<128xf32, 2 : i32>) -> memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %107 = "air.channel.get"(%arg38, %arg39, %104) <{chan_name = @channel_51, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<128xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%107) {orbit.computation_event = 169 : i64, orbit.phase = 59 : i64, orbit.phase_dependencies = array<i64: 58>, orbit.read_copies = array<i64: 198>, orbit.task = "scale", orbit.write_copies = array<i64: 199>} : (!air.async.token) -> ()
          "scf.for"(%101, %100, %99) ({
          ^bb0(%arg42: index):
            "scf.for"(%98, %97, %101) ({
            ^bb0(%arg43: index):
              %109 = "arith.subi"(%arg42, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %110 = "arith.subi"(%arg43, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %111 = "vector.transfer_read"(%106, %109, %110, %96) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %112 = "vector.extract"(%111) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %113 = "func.call"(%112, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %114 = "vector.extract"(%111) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %115 = "func.call"(%114, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %116 = "vector.extract"(%111) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %117 = "func.call"(%116, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %118 = "vector.extract"(%111) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %119 = "func.call"(%118, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %120 = "vector.extract"(%111) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %121 = "func.call"(%120, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %122 = "vector.extract"(%111) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %123 = "func.call"(%122, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %124 = "vector.extract"(%111) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %125 = "func.call"(%124, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %126 = "vector.extract"(%111) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %127 = "func.call"(%126, %102) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %128 = "vector.from_elements"(%113, %115, %117, %119, %121, %123, %125, %127) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %129 = "arith.subi"(%arg42, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %130 = "arith.subi"(%arg43, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%128, %105, %129, %130) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %108 = "air.channel.put"(%arg38, %arg39, %103) <{chan_name = @channel_52, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<128xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%108) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%95) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg2, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch_60"}> ({
    ^bb0(%arg15: index, %arg16: index, %arg17: index, %arg18: index, %arg19: memref<17x80xf32>, %arg20: memref<17x80xf32>):
      %38 = "arith.constant"() <{value = 2 : index}> : () -> index
      %39 = "arith.constant"() <{value = 32 : index}> : () -> index
      %40 = "arith.constant"() <{value = 1 : index}> : () -> index
      %41 = "arith.constant"() <{value = 0 : index}> : () -> index
      %42 = "air.wait_all"() : () -> !air.async.token
      %43 = "scf.for"(%41, %38, %40, %42) ({
      ^bb0(%arg30: index, %arg31: !air.async.token):
        %89 = "arith.muli"(%arg30, %39) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %90 = "air.channel.put"(%arg31, %41, %41, %arg20, %89) <{chan_name = @channel_53, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0, 0>, static_src_offsets = array<i64: 16, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<17x80xf32>, index) -> !air.async.token
        "scf.yield"(%90) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      %44 = "air.wait_all"() : () -> !air.async.token
      %45 = "scf.for"(%41, %38, %40, %44) ({
      ^bb0(%arg28: index, %arg29: !air.async.token):
        %87 = "arith.muli"(%arg28, %39) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
        %88 = "air.channel.get"(%arg29, %41, %41, %arg19, %87) <{chan_name = @channel_54, operandSegmentSizes = array<i32: 1, 2, 1, 1, 0, 0>, static_dst_offsets = array<i64: 16, -9223372036854775808>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 80, 1>}> : (!air.async.token, index, index, memref<17x80xf32>, index) -> !air.async.token
        "scf.yield"(%88) : (!air.async.token) -> ()
      }) : (index, index, index, !air.async.token) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_60"}> ({
        %46 = "arith.constant"() <{value = 1 : index}> : () -> index
        %47 = "air.herd"(%46, %46) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_60"}> ({
        ^bb0(%arg21: index, %arg22: index, %arg23: index, %arg24: index):
          %48 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %49 = "arith.constant"() <{value = 8 : index}> : () -> index
          %50 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %51 = "arith.constant"() <{value = 32 : index}> : () -> index
          %52 = "arith.constant"() <{value = 1 : index}> : () -> index
          %53 = "arith.constant"() <{value = 2 : index}> : () -> index
          %54 = "arith.constant"() <{value = 0 : index}> : () -> index
          %55 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<32xf32, 2 : i32>
          %56 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.32.loops.1.32"} : () -> memref<32xf32, 2 : i32>
          %57 = "air.wait_all"() : () -> !air.async.token
          %58 = "scf.for"(%54, %53, %52, %57) ({
          ^bb0(%arg25: index, %arg26: !air.async.token):
            %59 = "arith.muli"(%arg25, %51) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %60 = "arith.muli"(%arg25, %51) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %61 = "arith.muli"(%arg25, %51) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %62 = "memref.reinterpret_cast"(%55) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 60 : i64, orbit.storage = "Y"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %63 = "memref.reinterpret_cast"(%56) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 60 : i64, orbit.storage = "intermediate"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %64 = "air.channel.get"(%arg26, %arg21, %arg22, %56) <{chan_name = @channel_53, operandSegmentSizes = array<i32: 1, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (!air.async.token, index, index, memref<32xf32, 2 : i32>) -> !air.async.token
            "air.wait_all"(%64) {orbit.computation_event = 172 : i64, orbit.phase = 60 : i64, orbit.phase_dependencies = array<i64: 59>, orbit.read_copies = array<i64: 201>, orbit.task = "scale", orbit.write_copies = array<i64: 202>} : (!air.async.token) -> ()
            "scf.for"(%54, %51, %49) ({
            ^bb0(%arg27: index):
              %66 = "arith.addi"(%arg27, %59) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %67 = "arith.subi"(%66, %61) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %68 = "vector.transfer_read"(%63, %54, %67, %48) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
              %69 = "vector.extract"(%68) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
              %70 = "func.call"(%69, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %71 = "vector.extract"(%68) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
              %72 = "func.call"(%71, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %73 = "vector.extract"(%68) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
              %74 = "func.call"(%73, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %75 = "vector.extract"(%68) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
              %76 = "func.call"(%75, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %77 = "vector.extract"(%68) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
              %78 = "func.call"(%77, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %79 = "vector.extract"(%68) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
              %80 = "func.call"(%79, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %81 = "vector.extract"(%68) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
              %82 = "func.call"(%81, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %83 = "vector.extract"(%68) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
              %84 = "func.call"(%83, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %85 = "vector.from_elements"(%70, %72, %74, %76, %78, %80, %82, %84) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
              %86 = "arith.subi"(%66, %60) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "vector.transfer_write"(%85, %62, %54, %86) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %65 = "air.channel.put"(%arg26, %arg21, %arg22, %55) <{chan_name = @channel_54, operandSegmentSizes = array<i32: 1, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (!air.async.token, index, index, memref<32xf32, 2 : i32>) -> !air.async.token
            "scf.yield"(%65) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%58) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%47) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "air.launch"(%0, %0, %arg2, %arg3) <{operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch_62"}> ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<17x80xf32>, %arg9: memref<17x80xf32>):
      %1 = "arith.constant"() <{value = 0 : index}> : () -> index
      %2 = "air.channel.put"(%1, %1, %arg9) <{chan_name = @channel_55, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64: 16, 64>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      %3 = "air.channel.get"(%1, %1, %arg8) <{chan_name = @channel_56, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64: 16, 64>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 80, 1>}> : (index, index, memref<17x80xf32>) -> !air.async.token
      "air.segment"() <{operandSegmentSizes = array<i32: 0, 0, 0>, sym_name = "orbit_segment_62"}> ({
        %4 = "arith.constant"() <{value = 1 : index}> : () -> index
        %5 = "air.herd"(%4, %4) <{operandSegmentSizes = array<i32: 0, 2, 0>, sym_name = "orbit_herd_62"}> ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index):
          %6 = "arith.constant"() <{value = 0 : index}> : () -> index
          %7 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %8 = "arith.constant"() <{value = 8 : index}> : () -> index
          %9 = "arith.constant"() <{value = 80 : index}> : () -> index
          %10 = "arith.constant"() <{value = 64 : index}> : () -> index
          %11 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %12 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<16xf32, 2 : i32>
          %13 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.16.loops.1.16"} : () -> memref<16xf32, 2 : i32>
          %14 = "memref.reinterpret_cast"(%12) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 62 : i64, orbit.storage = "Y"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %15 = "memref.reinterpret_cast"(%13) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 62 : i64, orbit.storage = "intermediate"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %16 = "air.channel.get"(%arg10, %arg11, %13) <{chan_name = @channel_55, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0>, static_dst_offsets = array<i64>, static_dst_sizes = array<i64>, static_dst_strides = array<i64>}> : (index, index, memref<16xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%16) {orbit.computation_event = 178 : i64, orbit.phase = 62 : i64, orbit.phase_dependencies = array<i64: 61>, orbit.read_copies = array<i64: 207>, orbit.task = "scale", orbit.write_copies = array<i64: 208>} : (!air.async.token) -> ()
          "scf.for"(%10, %9, %8) ({
          ^bb0(%arg14: index):
            %18 = "arith.subi"(%arg14, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %19 = "vector.transfer_read"(%15, %6, %18, %7) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
            %20 = "vector.extract"(%19) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
            %21 = "func.call"(%20, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %22 = "vector.extract"(%19) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
            %23 = "func.call"(%22, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %24 = "vector.extract"(%19) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
            %25 = "func.call"(%24, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %26 = "vector.extract"(%19) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
            %27 = "func.call"(%26, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %28 = "vector.extract"(%19) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
            %29 = "func.call"(%28, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %30 = "vector.extract"(%19) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
            %31 = "func.call"(%30, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %32 = "vector.extract"(%19) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
            %33 = "func.call"(%32, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %34 = "vector.extract"(%19) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
            %35 = "func.call"(%34, %11) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %36 = "vector.from_elements"(%21, %23, %25, %27, %29, %31, %33, %35) : (f32, f32, f32, f32, f32, f32, f32, f32) -> vector<8xf32>
            %37 = "arith.subi"(%arg14, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            "vector.transfer_write"(%36, %14, %6, %37) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %17 = "air.channel.put"(%arg10, %arg11, %12) <{chan_name = @channel_56, operandSegmentSizes = array<i32: 0, 2, 1, 0, 0, 0, 0>, static_src_offsets = array<i64>, static_src_sizes = array<i64>, static_src_strides = array<i64>}> : (index, index, memref<16xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%17) : (!air.async.token) -> ()
          "air.herd_terminator"() : () -> ()
        }) {orbit.mapping_strategy = "serial-tiled"} : (index, index) -> !air.async.token
        "air.wait_all"(%5) : (!air.async.token) -> ()
        "air.segment_terminator"() : () -> ()
      }) : () -> ()
      "air.launch_terminator"() : () -> ()
    }) : (index, index, memref<17x80xf32>, memref<17x80xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.async_herd_scope = "module", orbit.channel_conversion_scope = "module", orbit.channel_input_fingerprint = "54d2201698282640109a4cb4fac0ef7938a04d26a2a793baeb8c6fe0dd2909ea", orbit.channel_legalization = "checked-storage-compute-dma-ports-v1", orbit.channel_pre_merge_fingerprint = "b6cb2b3234e90287bb5a97086f8a103758104c70ce47b2809476e64c4ad136e7", orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.local_release_scope = "static-hardware-stage", orbit.mapping_plan = "b2fac988bd30bacd29b0bb139ebc7aec8ffeda478b40e1fcb3637512c890e51d", orbit.source_fingerprint = "912511a293a64cce8e0d6c281bea7fa9b2ada1f653348173aee833f4c600a053"} : () -> ()

