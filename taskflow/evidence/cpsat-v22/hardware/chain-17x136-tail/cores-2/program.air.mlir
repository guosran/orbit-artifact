"builtin.module"() ({
  "func.func"() <{function_type = (memref<17x136xf32>, memref<17x136xf32>) -> (), sym_name = "chain_17x136_tail"}> ({
  ^bb0(%arg0: memref<17x136xf32>, %arg1: memref<17x136xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<17x136xf32>, %arg7: memref<17x136xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<17x136xf32>, %arg9: memref<17x136xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg20: index, %arg21: index, %arg22: index, %arg23: index, %arg24: memref<17x136xf32>, %arg25: memref<17x136xf32>):
          %34 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.9.136.loops.9.136"} : () -> memref<1224xf32, 2 : i32>
          %35 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1224xf32, 2 : i32>
          %36 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1224xf32, 2 : i32>
          %37 = "air.wait_all"() : () -> !air.async.token
          %38 = "memref.reinterpret_cast"(%34) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<1224xf32, 2 : i32>) -> memref<9x136xf32, strided<[136, 1]>, 2 : i32>
          %39 = "air.dma_memcpy_nd"(%37, %38, %arg24) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "I", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 9, 136>, static_dst_strides = array<i64: 136, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 9, 136>, static_src_strides = array<i64: 136, 1>} : (!air.async.token, memref<9x136xf32, strided<[136, 1]>, 2 : i32>, memref<17x136xf32>) -> !air.async.token
          %40 = "memref.reinterpret_cast"(%36) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1224xf32, 2 : i32>) -> memref<9x136xf32, strided<[136, 1]>, 2 : i32>
          "air.wait_all"(%37, %39) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_T", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %41 = "arith.constant"() <{value = 0 : index}> : () -> index
          %42 = "arith.constant"() <{value = 9 : index}> : () -> index
          %43 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%41, %42, %43) ({
          ^bb0(%arg28: index):
            %59 = "arith.constant"() <{value = 0 : index}> : () -> index
            %60 = "arith.constant"() <{value = 136 : index}> : () -> index
            %61 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%59, %60, %61) ({
            ^bb0(%arg29: index):
              %62 = "memref.load"(%38, %arg28, %arg29) <{nontemporal = false}> : (memref<9x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> f32
              %63 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %64 = "arith.addf"(%62, %63) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%64, %40, %arg28, %arg29) <{nontemporal = false}> : (f32, memref<9x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %44 = "memref.reinterpret_cast"(%35) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<1224xf32, 2 : i32>) -> memref<9x136xf32, strided<[136, 1]>, 2 : i32>
          %45 = "memref.reinterpret_cast"(%36) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 1 : i64, orbit.storage = "T"} : (memref<1224xf32, 2 : i32>) -> memref<9x136xf32, strided<[136, 1]>, 2 : i32>
          "air.wait_all"(%37) {orbit.computation_event = 2 : i64, orbit.phase = 1 : i64, orbit.phase_dependencies = array<i64: 0>, orbit.public_dependencies = array<i64: 1>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 1 : i64, orbit.task = "write_R", orbit.write_copies = array<i64: 3>} : (!air.async.token) -> ()
          %46 = "arith.constant"() <{value = 0 : index}> : () -> index
          %47 = "arith.constant"() <{value = 9 : index}> : () -> index
          %48 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%46, %47, %48) ({
          ^bb0(%arg26: index):
            %53 = "arith.constant"() <{value = 0 : index}> : () -> index
            %54 = "arith.constant"() <{value = 136 : index}> : () -> index
            %55 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%53, %54, %55) ({
            ^bb0(%arg27: index):
              %56 = "memref.load"(%45, %arg26, %arg27) <{nontemporal = false}> : (memref<9x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> f32
              %57 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %58 = "arith.mulf"(%56, %57) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%58, %44, %arg26, %arg27) <{nontemporal = false}> : (f32, memref<9x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %49 = "memref.reinterpret_cast"(%35) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<1224xf32, 2 : i32>) -> memref<9x136xf32, strided<[136, 1]>, 2 : i32>
          %50 = "air.dma_memcpy_nd"(%37, %arg25, %49) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 1 : i64, orbit.source_copies = array<i64: 3>, orbit.storage = "R", orbit.target_copies = array<i64: 4>, orbit.transfer = "l1_to_host", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 9, 136>, static_dst_strides = array<i64: 136, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 9, 136>, static_src_strides = array<i64: 136, 1>} : (!air.async.token, memref<17x136xf32>, memref<9x136xf32, strided<[136, 1]>, 2 : i32>) -> !air.async.token
          %51 = "air.wait_all"(%50) : (!air.async.token) -> !air.async.token
          %52 = "air.wait_all"(%37, %51) : (!air.async.token, !air.async.token) -> !air.async.token
          "air.wait_all"(%52) : (!air.async.token) -> ()
          "memref.dealloc"(%34) : (memref<1224xf32, 2 : i32>) -> ()
          "memref.dealloc"(%35) : (memref<1224xf32, 2 : i32>) -> ()
          "memref.dealloc"(%36) : (memref<1224xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3>, orbit.mapping_strategy = "serial-tiled", orbit.row_count = 9 : i64, orbit.row_offset = 0 : i64, orbit.shard = 0 : i64, orbit.spatial_owner = "npu.tile(1,2)", sym_name = "orbit_shard_0", x_loc = 1 : i32, y_loc = 2 : i32} : (index, index, memref<17x136xf32>, memref<17x136xf32>) -> ()
        %2 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%2, %2, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<17x136xf32>, %arg15: memref<17x136xf32>):
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.136.loops.8.136"} : () -> memref<1088xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1088xf32, 2 : i32>
          %5 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1088xf32, 2 : i32>
          %6 = "air.wait_all"() : () -> !air.async.token
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<1088xf32, 2 : i32>) -> memref<8x136xf32, strided<[136, 1]>, 2 : i32>
          %8 = "air.dma_memcpy_nd"(%6, %7, %arg14) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "I", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 136>, static_dst_strides = array<i64: 136, 1>, static_src_offsets = array<i64: 9, 0>, static_src_sizes = array<i64: 8, 136>, static_src_strides = array<i64: 136, 1>} : (!air.async.token, memref<8x136xf32, strided<[136, 1]>, 2 : i32>, memref<17x136xf32>) -> !air.async.token
          %9 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1088xf32, 2 : i32>) -> memref<8x136xf32, strided<[136, 1]>, 2 : i32>
          "air.wait_all"(%6, %8) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_T", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %10 = "arith.constant"() <{value = 0 : index}> : () -> index
          %11 = "arith.constant"() <{value = 8 : index}> : () -> index
          %12 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%10, %11, %12) ({
          ^bb0(%arg18: index):
            %28 = "arith.constant"() <{value = 0 : index}> : () -> index
            %29 = "arith.constant"() <{value = 136 : index}> : () -> index
            %30 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%28, %29, %30) ({
            ^bb0(%arg19: index):
              %31 = "memref.load"(%7, %arg18, %arg19) <{nontemporal = false}> : (memref<8x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> f32
              %32 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %33 = "arith.addf"(%31, %32) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%33, %9, %arg18, %arg19) <{nontemporal = false}> : (f32, memref<8x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %13 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<1088xf32, 2 : i32>) -> memref<8x136xf32, strided<[136, 1]>, 2 : i32>
          %14 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 1 : i64, orbit.storage = "T"} : (memref<1088xf32, 2 : i32>) -> memref<8x136xf32, strided<[136, 1]>, 2 : i32>
          "air.wait_all"(%6) {orbit.computation_event = 2 : i64, orbit.phase = 1 : i64, orbit.phase_dependencies = array<i64: 0>, orbit.public_dependencies = array<i64: 1>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 1 : i64, orbit.task = "write_R", orbit.write_copies = array<i64: 3>} : (!air.async.token) -> ()
          %15 = "arith.constant"() <{value = 0 : index}> : () -> index
          %16 = "arith.constant"() <{value = 8 : index}> : () -> index
          %17 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%15, %16, %17) ({
          ^bb0(%arg16: index):
            %22 = "arith.constant"() <{value = 0 : index}> : () -> index
            %23 = "arith.constant"() <{value = 136 : index}> : () -> index
            %24 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%22, %23, %24) ({
            ^bb0(%arg17: index):
              %25 = "memref.load"(%14, %arg16, %arg17) <{nontemporal = false}> : (memref<8x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> f32
              %26 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %27 = "arith.mulf"(%25, %26) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%27, %13, %arg16, %arg17) <{nontemporal = false}> : (f32, memref<8x136xf32, strided<[136, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %18 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 136>, static_strides = array<i64: 136, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<1088xf32, 2 : i32>) -> memref<8x136xf32, strided<[136, 1]>, 2 : i32>
          %19 = "air.dma_memcpy_nd"(%6, %arg15, %18) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 1 : i64, orbit.source_copies = array<i64: 3>, orbit.storage = "R", orbit.target_copies = array<i64: 4>, orbit.transfer = "l1_to_host", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: 9, 0>, static_dst_sizes = array<i64: 8, 136>, static_dst_strides = array<i64: 136, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 136>, static_src_strides = array<i64: 136, 1>} : (!air.async.token, memref<17x136xf32>, memref<8x136xf32, strided<[136, 1]>, 2 : i32>) -> !air.async.token
          %20 = "air.wait_all"(%19) : (!air.async.token) -> !air.async.token
          %21 = "air.wait_all"(%6, %20) : (!air.async.token, !air.async.token) -> !air.async.token
          "air.wait_all"(%21) : (!air.async.token) -> ()
          "memref.dealloc"(%3) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%5) : (memref<1088xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3>, orbit.mapping_strategy = "serial-tiled", orbit.row_count = 8 : i64, orbit.row_offset = 9 : i64, orbit.shard = 1 : i64, orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_shard_1", x_loc = 0 : i32, y_loc = 2 : i32} : (index, index, memref<17x136xf32>, memref<17x136xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_segment"} : (memref<17x136xf32>, memref<17x136xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch"} : (index, index, memref<17x136xf32>, memref<17x136xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_realization = "tiled-phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "independent physical shards; per-shard normalized graph and concrete placement in manifest", orbit.multicore_realization = "independent row shards, one segment, disjoint static local pools", orbit.source_fingerprint = "1cee13ac42f3d11cb9e190ea8dae5d45b894d40d532e200df4a26120a2dd8806"} : () -> ()

