"builtin.module"() ({
  "func.func"() <{function_type = (memref<31x64xf32>, memref<31x64xf32>) -> (), sym_name = "chain_31x64"}> ({
  ^bb0(%arg0: memref<31x64xf32>, %arg1: memref<31x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<31x64xf32>, %arg7: memref<31x64xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<31x64xf32>, %arg9: memref<31x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<31x64xf32>, %arg15: memref<31x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.31.64.loops.31.64"} : () -> memref<1984xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1984xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1984xf32, 2 : i32>
          %5 = "air.wait_all"() : () -> !air.async.token
          %6 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 31, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<1984xf32, 2 : i32>) -> memref<31x64xf32, strided<[64, 1]>, 2 : i32>
          %7 = "air.dma_memcpy_nd"(%5, %6, %arg14) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "I", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 31, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 31, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<31x64xf32, strided<[64, 1]>, 2 : i32>, memref<31x64xf32>) -> !air.async.token
          %8 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 31, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1984xf32, 2 : i32>) -> memref<31x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%5, %7) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_T", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %9 = "arith.constant"() <{value = 0 : index}> : () -> index
          %10 = "arith.constant"() <{value = 31 : index}> : () -> index
          %11 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%9, %10, %11) ({
          ^bb0(%arg18: index):
            %27 = "arith.constant"() <{value = 0 : index}> : () -> index
            %28 = "arith.constant"() <{value = 64 : index}> : () -> index
            %29 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%27, %28, %29) ({
            ^bb0(%arg19: index):
              %30 = "memref.load"(%6, %arg18, %arg19) <{nontemporal = false}> : (memref<31x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %31 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %32 = "arith.addf"(%30, %31) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%32, %8, %arg18, %arg19) <{nontemporal = false}> : (f32, memref<31x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %12 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 31, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<1984xf32, 2 : i32>) -> memref<31x64xf32, strided<[64, 1]>, 2 : i32>
          %13 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 31, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "T"} : (memref<1984xf32, 2 : i32>) -> memref<31x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%5) {orbit.computation_event = 2 : i64, orbit.phase = 1 : i64, orbit.phase_dependencies = array<i64: 0>, orbit.public_dependencies = array<i64: 1>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 1 : i64, orbit.task = "write_R", orbit.write_copies = array<i64: 3>} : (!air.async.token) -> ()
          %14 = "arith.constant"() <{value = 0 : index}> : () -> index
          %15 = "arith.constant"() <{value = 31 : index}> : () -> index
          %16 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%14, %15, %16) ({
          ^bb0(%arg16: index):
            %21 = "arith.constant"() <{value = 0 : index}> : () -> index
            %22 = "arith.constant"() <{value = 64 : index}> : () -> index
            %23 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%21, %22, %23) ({
            ^bb0(%arg17: index):
              %24 = "memref.load"(%13, %arg16, %arg17) <{nontemporal = false}> : (memref<31x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %25 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %26 = "arith.mulf"(%24, %25) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%26, %12, %arg16, %arg17) <{nontemporal = false}> : (f32, memref<31x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %17 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 31, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<1984xf32, 2 : i32>) -> memref<31x64xf32, strided<[64, 1]>, 2 : i32>
          %18 = "air.dma_memcpy_nd"(%5, %arg15, %17) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 1 : i64, orbit.source_copies = array<i64: 3>, orbit.storage = "R", orbit.target_copies = array<i64: 4>, orbit.transfer = "l1_to_host", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 31, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 31, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<31x64xf32>, memref<31x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          %19 = "air.wait_all"(%18) : (!air.async.token) -> !air.async.token
          %20 = "air.wait_all"(%5, %19) : (!air.async.token, !air.async.token) -> !air.async.token
          "air.wait_all"(%20) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1984xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1984xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<1984xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3>, orbit.mapping_strategy = "serial-tiled", orbit.row_count = 31 : i64, orbit.row_offset = 0 : i64, orbit.shard = 0 : i64, orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_shard_0", x_loc = 0 : i32, y_loc = 2 : i32} : (index, index, memref<31x64xf32>, memref<31x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_segment"} : (memref<31x64xf32>, memref<31x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch"} : (index, index, memref<31x64xf32>, memref<31x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_realization = "tiled-phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "independent physical shards; per-shard normalized graph and concrete placement in manifest", orbit.multicore_realization = "independent row shards, one segment, disjoint static local pools", orbit.source_fingerprint = "922a15fc1035fce1b042c538ff6f972fc75cf1aaafda03c47d30521bc1feee82"} : () -> ()

