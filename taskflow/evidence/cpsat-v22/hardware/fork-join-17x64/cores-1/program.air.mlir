"builtin.module"() ({
  "func.func"() <{function_type = (memref<17x64xf32>, memref<17x64xf32>) -> (), sym_name = "fork_join_17x64"}> ({
  ^bb0(%arg0: memref<17x64xf32>, %arg1: memref<17x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<17x64xf32>, %arg7: memref<17x64xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<17x64xf32>, %arg9: memref<17x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<17x64xf32>, %arg15: memref<17x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.17.64.loops.17.64"} : () -> memref<1088xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1088xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1088xf32, 2 : i32>
          %5 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<1088xf32, 2 : i32>
          %6 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 6 : i64, orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<1088xf32, 2 : i32>
          %7 = "air.wait_all"() : () -> !air.async.token
          %8 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %9 = "air.dma_memcpy_nd"(%7, %8, %arg14) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "I", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 17, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 17, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, memref<17x64xf32>) -> !air.async.token
          %10 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%7, %9) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_X", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %11 = "arith.constant"() <{value = 0 : index}> : () -> index
          %12 = "arith.constant"() <{value = 17 : index}> : () -> index
          %13 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%11, %12, %13) ({
          ^bb0(%arg22: index):
            %52 = "arith.constant"() <{value = 0 : index}> : () -> index
            %53 = "arith.constant"() <{value = 64 : index}> : () -> index
            %54 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%52, %53, %54) ({
            ^bb0(%arg23: index):
              %55 = "memref.load"(%8, %arg22, %arg23) <{nontemporal = false}> : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %56 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %57 = "arith.addf"(%55, %56) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%57, %10, %arg22, %arg23) <{nontemporal = false}> : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %14 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "X"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %15 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "Y"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%7) {orbit.computation_event = 2 : i64, orbit.phase = 1 : i64, orbit.phase_dependencies = array<i64: 0>, orbit.public_dependencies = array<i64: 1>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 1 : i64, orbit.task = "write_Y", orbit.write_copies = array<i64: 3>} : (!air.async.token) -> ()
          %16 = "arith.constant"() <{value = 0 : index}> : () -> index
          %17 = "arith.constant"() <{value = 17 : index}> : () -> index
          %18 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%16, %17, %18) ({
          ^bb0(%arg20: index):
            %46 = "arith.constant"() <{value = 0 : index}> : () -> index
            %47 = "arith.constant"() <{value = 64 : index}> : () -> index
            %48 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%46, %47, %48) ({
            ^bb0(%arg21: index):
              %49 = "memref.load"(%14, %arg20, %arg21) <{nontemporal = false}> : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %50 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %51 = "arith.mulf"(%49, %50) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%51, %15, %arg20, %arg21) <{nontemporal = false}> : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %19 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "X"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %20 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "Z"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%7) {orbit.computation_event = 3 : i64, orbit.phase = 2 : i64, orbit.phase_dependencies = array<i64: 1>, orbit.public_dependencies = array<i64: 1, 2>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 2 : i64, orbit.task = "write_Z", orbit.write_copies = array<i64: 4>} : (!air.async.token) -> ()
          %21 = "arith.constant"() <{value = 0 : index}> : () -> index
          %22 = "arith.constant"() <{value = 17 : index}> : () -> index
          %23 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%21, %22, %23) ({
          ^bb0(%arg18: index):
            %40 = "arith.constant"() <{value = 0 : index}> : () -> index
            %41 = "arith.constant"() <{value = 64 : index}> : () -> index
            %42 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%40, %41, %42) ({
            ^bb0(%arg19: index):
              %43 = "memref.load"(%19, %arg18, %arg19) <{nontemporal = false}> : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %44 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %45 = "arith.subf"(%43, %44) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%45, %20, %arg18, %arg19) <{nontemporal = false}> : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %24 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %25 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Y"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %26 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Z"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%7) {orbit.computation_event = 4 : i64, orbit.phase = 3 : i64, orbit.phase_dependencies = array<i64: 2>, orbit.public_dependencies = array<i64: 2, 3>, orbit.read_copies = array<i64: 3, 4>, orbit.source_instance = 3 : i64, orbit.task = "write_R", orbit.write_copies = array<i64: 5>} : (!air.async.token) -> ()
          %27 = "arith.constant"() <{value = 0 : index}> : () -> index
          %28 = "arith.constant"() <{value = 17 : index}> : () -> index
          %29 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%27, %28, %29) ({
          ^bb0(%arg16: index):
            %34 = "arith.constant"() <{value = 0 : index}> : () -> index
            %35 = "arith.constant"() <{value = 64 : index}> : () -> index
            %36 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%34, %35, %36) ({
            ^bb0(%arg17: index):
              %37 = "memref.load"(%25, %arg16, %arg17) <{nontemporal = false}> : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %38 = "memref.load"(%26, %arg16, %arg17) <{nontemporal = false}> : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %39 = "arith.addf"(%37, %38) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%39, %24, %arg16, %arg17) <{nontemporal = false}> : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %30 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
          %31 = "air.dma_memcpy_nd"(%7, %arg15, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 3 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "R", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 5 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 17, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 17, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32>, memref<17x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          %32 = "air.wait_all"(%31) : (!air.async.token) -> !air.async.token
          %33 = "air.wait_all"(%7, %7, %7, %32) : (!air.async.token, !air.async.token, !air.async.token, !air.async.token) -> !air.async.token
          "air.wait_all"(%33) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%5) : (memref<1088xf32, 2 : i32>) -> ()
          "memref.dealloc"(%6) : (memref<1088xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3, 4, 5>, orbit.mapping_strategy = "serial-tiled", orbit.row_count = 17 : i64, orbit.row_offset = 0 : i64, orbit.shard = 0 : i64, orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_shard_0", x_loc = 0 : i32, y_loc = 2 : i32} : (index, index, memref<17x64xf32>, memref<17x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_segment"} : (memref<17x64xf32>, memref<17x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch"} : (index, index, memref<17x64xf32>, memref<17x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_realization = "tiled-phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "independent physical shards; per-shard normalized graph and concrete placement in manifest", orbit.multicore_realization = "independent row shards, one segment, disjoint static local pools", orbit.source_fingerprint = "fe49f7fffb21a469683af2bf55f1e4dbee7a15a4b25a95dc73c267a0b2efec74"} : () -> ()

