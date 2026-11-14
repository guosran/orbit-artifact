"builtin.module"() ({
  "func.func"() <{function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<64x64xf32>, %arg7: memref<64x64xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<64x64xf32>, %arg9: memref<64x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<64x64xf32>, %arg15: memref<64x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1024xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 2 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "scf.for"(%5, %6, %7, %4) ({
          ^bb0(%arg16: index, %arg17: !air.async.token):
            %9 = "arith.constant"() <{value = 32 : index}> : () -> index
            %10 = "arith.muli"(%arg16, %9) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %11 = "arith.constant"() <{value = 32 : index}> : () -> index
            %12 = "arith.muli"(%arg16, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 32 : index}> : () -> index
            %14 = "arith.muli"(%arg16, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 0 : index}> : () -> index
            %16 = "arith.constant"() <{value = 2 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg17) ({
            ^bb0(%arg18: index, %arg19: !air.async.token):
              %19 = "arith.constant"() <{value = 32 : index}> : () -> index
              %20 = "arith.muli"(%arg18, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 32 : index}> : () -> index
              %22 = "arith.muli"(%arg18, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 32 : index}> : () -> index
              %24 = "arith.muli"(%arg18, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %26 = "arith.constant"() <{value = 0 : index}> : () -> index
              %27 = "arith.addi"(%26, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %28 = "arith.constant"() <{value = 0 : index}> : () -> index
              %29 = "arith.addi"(%28, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %30 = "air.dma_memcpy_nd"(%arg19, %25, %arg14, %27, %29) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 4>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index, index) -> !air.async.token
              %31 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              "air.wait_all"(%arg19, %30) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 4>, orbit.source_instance = 0 : i64, orbit.task = "double.fuse.square", orbit.write_copies = array<i64: 5>} : (!air.async.token, !air.async.token) -> ()
              %32 = "arith.constant"() <{value = 0 : index}> : () -> index
              %33 = "arith.constant"() <{value = 1 : index}> : () -> index
              %34 = "arith.constant"() <{value = 64 : index}> : () -> index
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.constant"() <{value = 1 : index}> : () -> index
              %37 = "arith.constant"() <{value = 64 : index}> : () -> index
              %38 = "arith.constant"() <{value = 0 : index}> : () -> index
              %39 = "arith.constant"() <{value = 32 : index}> : () -> index
              %40 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%38, %39, %40) ({
              ^bb0(%arg20: index):
                %48 = "arith.addi"(%arg20, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %49 = "arith.constant"() <{value = 0 : index}> : () -> index
                %50 = "arith.constant"() <{value = 32 : index}> : () -> index
                %51 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%49, %50, %51) ({
                ^bb0(%arg21: index):
                  %52 = "arith.addi"(%arg21, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %53 = "arith.subi"(%48, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %54 = "arith.subi"(%52, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %55 = "memref.load"(%25, %53, %54) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %56 = "arith.addf"(%55, %55) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %57 = "arith.mulf"(%56, %56) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %58 = "arith.subi"(%48, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %59 = "arith.subi"(%52, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%57, %31, %58, %59) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %41 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %42 = "arith.constant"() <{value = 0 : index}> : () -> index
              %43 = "arith.addi"(%42, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %44 = "arith.constant"() <{value = 0 : index}> : () -> index
              %45 = "arith.addi"(%44, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %46 = "air.dma_memcpy_nd"(%arg19, %arg15, %43, %45, %41) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "Y", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %47 = "air.wait_all"(%46) : (!air.async.token) -> !air.async.token
              "scf.yield"(%47) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd"} : (index, index, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_segment"} : (memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch"} : (index, index, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_realization = "phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "common execution groups and explicit copy/release dependencies; source compute order preserved; conservative timing reservations are separate from runtime arbitration", orbit.mapping_plan = "54c6f1dd701cb7c07d2f8a9b74a375daa7b921eb733ca6d19c10c23354716ab5", orbit.program_graph = "4cd90be228d46a1ee9442d96f5c823bbfafdef8d8c8dbaec49fcac54271ccf66", orbit.source_fingerprint = "f6d1cf9b0233ccdfe6fb80f91c8bc94f21b78e0828c979c88e96c1dd84bdea66"} : () -> ()

