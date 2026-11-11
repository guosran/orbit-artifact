"builtin.module"() ({
  "func.func"() <{function_type = (memref<17x64xf32>, memref<17x64xf32>, memref<17x64xf32>) -> (), sym_name = "chain_17x64"}> ({
  ^bb0(%arg0: memref<17x64xf32>, %arg1: memref<17x64xf32>, %arg2: memref<17x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<17x64xf32>, %arg8: memref<17x64xf32>, %arg9: memref<17x64xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg21: memref<17x64xf32>, %arg22: memref<17x64xf32>, %arg23: memref<17x64xf32>):
        %20 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%20, %20, %arg21, %arg23) ({
        ^bb0(%arg24: index, %arg25: index, %arg26: index, %arg27: index, %arg28: memref<17x64xf32>, %arg29: memref<17x64xf32>):
          %21 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.17.64.loops.17.64"} : () -> memref<1088xf32, 2 : i32>
          %22 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1088xf32, 2 : i32>
          %23 = "air.wait_all"() : () -> !air.async.token
          %24 = "memref.reinterpret_cast"(%21) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %25 = "air.dma_memcpy_nd"(%23, %24, %arg28) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "I", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 17, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 17, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, memref<17x64xf32>) -> !air.async.token
          %26 = "memref.reinterpret_cast"(%22) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%23, %25) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_T", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %27 = "arith.constant"() <{value = 0 : index}> : () -> index
          %28 = "arith.constant"() <{value = 17 : index}> : () -> index
          %29 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%27, %28, %29) ({
          ^bb0(%arg30: index):
            %33 = "arith.constant"() <{value = 0 : index}> : () -> index
            %34 = "arith.constant"() <{value = 64 : index}> : () -> index
            %35 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%33, %34, %35) ({
            ^bb0(%arg31: index):
              %36 = "memref.load"(%24, %arg30, %arg31) <{nontemporal = false}> : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %37 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %38 = "arith.addf"(%36, %37) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%38, %26, %arg30, %arg31) <{nontemporal = false}> : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %30 = "memref.reinterpret_cast"(%22) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %31 = "air.dma_memcpy_nd"(%23, %arg29, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 2>, orbit.storage = "T", orbit.target_copies = array<i64: 3>, orbit.transfer = "l1_to_host", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 17, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 17, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32>, memref<17x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          %32 = "air.wait_all"(%31) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%32) : (!air.async.token) -> ()
          "memref.dealloc"(%21) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%22) : (memref<1088xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_joint_group_0", x_loc = 0 : i32, y_loc = 2 : i32} : (index, index, memref<17x64xf32>, memref<17x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_joint_configuration_0"} : (memref<17x64xf32>, memref<17x64xf32>, memref<17x64xf32>) -> ()
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<17x64xf32>, %arg11: memref<17x64xf32>, %arg12: memref<17x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg11) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<17x64xf32>, %arg18: memref<17x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.17.64.loops.17.64"} : () -> memref<1088xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1088xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %6 = "air.dma_memcpy_nd"(%4, %5, %arg17) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "T", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 17, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 17, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, memref<17x64xf32>) -> !air.async.token
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "R"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%4, %6) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_R", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "arith.constant"() <{value = 17 : index}> : () -> index
          %10 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%8, %9, %10) ({
          ^bb0(%arg19: index):
            %14 = "arith.constant"() <{value = 0 : index}> : () -> index
            %15 = "arith.constant"() <{value = 64 : index}> : () -> index
            %16 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%14, %15, %16) ({
            ^bb0(%arg20: index):
              %17 = "memref.load"(%5, %arg19, %arg20) <{nontemporal = false}> : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %18 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %19 = "arith.mulf"(%17, %18) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%19, %7, %arg19, %arg20) <{nontemporal = false}> : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %11 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "R"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %12 = "air.dma_memcpy_nd"(%4, %arg18, %11) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 2>, orbit.storage = "R", orbit.target_copies = array<i64: 3>, orbit.transfer = "l1_to_host", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 17, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 17, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32>, memref<17x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          %13 = "air.wait_all"(%12) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%13) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1088xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_joint_group_1", x_loc = 0 : i32, y_loc = 2 : i32} : (index, index, memref<17x64xf32>, memref<17x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_joint_configuration_1"} : (memref<17x64xf32>, memref<17x64xf32>, memref<17x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_joint"} : (index, index, memref<17x64xf32>, memref<17x64xf32>, memref<17x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.graph_schedule_realization = "selected static groups and coordinates; synchronous configuration barriers; DMA readiness, no timed dispatch guarantee", orbit.program_graph = "7b2a1e30d879964f33252649fa157d898eba78e352f0f662e42236e1e865843a", orbit.source_fingerprint = "69331a8bbb4c915649c5ac3ce9e4d2552bf9dd2561690f0d377528be38853259"} : () -> ()

