"builtin.module"() ({
  "func.func"() <{function_type = (memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> (), sym_name = "streams"}> ({
  ^bb0(%arg0: memref<4xf32>, %arg1: memref<4xf32>, %arg2: memref<4xf32>, %arg3: memref<4xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<4xf32>, %arg9: memref<4xf32>, %arg10: memref<4xf32>, %arg11: memref<4xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<4xf32>, %arg13: memref<4xf32>, %arg14: memref<4xf32>, %arg15: memref<4xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<4xf32>, %arg21: memref<4xf32>, %arg22: memref<4xf32>, %arg23: memref<4xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.2.loops.2"} : () -> memref<2xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.2.loops.2"} : () -> memref<2xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<2xf32, 2 : i32>
          %5 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<2xf32, 2 : i32>
          %6 = "air.wait_all"() : () -> !air.async.token
          %7 = "arith.constant"() <{value = 0 : index}> : () -> index
          %8 = "arith.constant"() <{value = 2 : index}> : () -> index
          %9 = "arith.constant"() <{value = 1 : index}> : () -> index
          %10 = "scf.for"(%7, %8, %9, %6) ({
          ^bb0(%arg24: index, %arg25: !air.async.token):
            %11 = "arith.constant"() <{value = 2 : index}> : () -> index
            %12 = "arith.muli"(%arg24, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 2 : index}> : () -> index
            %14 = "arith.muli"(%arg24, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 2 : index}> : () -> index
            %16 = "arith.muli"(%arg24, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %17 = "arith.constant"() <{value = 2 : index}> : () -> index
            %18 = "arith.muli"(%arg24, %17) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %19 = "arith.constant"() <{value = 2 : index}> : () -> index
            %20 = "arith.muli"(%arg24, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %21 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "A"} : (memref<2xf32, 2 : i32>) -> memref<2xf32, strided<[1]>, 2 : i32>
            %22 = "arith.constant"() <{value = 0 : index}> : () -> index
            %23 = "arith.addi"(%22, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %24 = "air.dma_memcpy_nd"(%arg25, %21, %arg20, %23) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 4>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 2>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: -9223372036854775808>, static_src_sizes = array<i64: 2>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<2xf32, strided<[1]>, 2 : i32>, memref<4xf32>, index) -> !air.async.token
            %25 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "B"} : (memref<2xf32, 2 : i32>) -> memref<2xf32, strided<[1]>, 2 : i32>
            %26 = "arith.constant"() <{value = 0 : index}> : () -> index
            %27 = "arith.addi"(%26, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %28 = "air.dma_memcpy_nd"(%arg25, %25, %arg21, %27) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 2>, orbit.storage = "B", orbit.target_copies = array<i64: 5>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 2>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: -9223372036854775808>, static_src_sizes = array<i64: 2>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<2xf32, strided<[1]>, 2 : i32>, memref<4xf32>, index) -> !air.async.token
            %29 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "Y"} : (memref<2xf32, 2 : i32>) -> memref<2xf32, strided<[1]>, 2 : i32>
            %30 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "Z"} : (memref<2xf32, 2 : i32>) -> memref<2xf32, strided<[1]>, 2 : i32>
            "air.wait_all"(%24, %28) {orbit.computation_event = 2 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.read_copies = array<i64: 4, 5>, orbit.task = "grouped", orbit.write_copies = array<i64: 6, 7>} : (!air.async.token, !air.async.token) -> ()
            %31 = "arith.constant"() <{value = 0 : index}> : () -> index
            %32 = "arith.constant"() <{value = 2 : index}> : () -> index
            %33 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%31, %32, %33) ({
            ^bb0(%arg26: index):
              %41 = "arith.addi"(%arg26, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %42 = "arith.subi"(%41, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %43 = "memref.load"(%21, %42) <{nontemporal = false}> : (memref<2xf32, strided<[1]>, 2 : i32>, index) -> f32
              %44 = "arith.subi"(%41, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %45 = "memref.load"(%25, %44) <{nontemporal = false}> : (memref<2xf32, strided<[1]>, 2 : i32>, index) -> f32
              %46 = "arith.addf"(%43, %45) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %47 = "arith.subi"(%41, %18) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%46, %29, %47) <{nontemporal = false}> : (f32, memref<2xf32, strided<[1]>, 2 : i32>, index) -> ()
              %48 = "arith.subi"(%41, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %49 = "memref.load"(%21, %48) <{nontemporal = false}> : (memref<2xf32, strided<[1]>, 2 : i32>, index) -> f32
              %50 = "arith.subi"(%41, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %51 = "memref.load"(%25, %50) <{nontemporal = false}> : (memref<2xf32, strided<[1]>, 2 : i32>, index) -> f32
              %52 = "arith.mulf"(%49, %51) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %53 = "arith.subi"(%41, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%52, %30, %53) <{nontemporal = false}> : (f32, memref<2xf32, strided<[1]>, 2 : i32>, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %34 = "arith.constant"() <{value = 0 : index}> : () -> index
            %35 = "arith.addi"(%34, %18) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %36 = "air.dma_memcpy_nd"(%arg25, %arg22, %35, %29) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 6>, orbit.storage = "Y", orbit.target_copies = array<i64: 8>, orbit.transfer = "l1_to_host", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: -9223372036854775808>, static_dst_sizes = array<i64: 2>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 2>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32>, index, memref<2xf32, strided<[1]>, 2 : i32>) -> !air.async.token
            %37 = "arith.constant"() <{value = 0 : index}> : () -> index
            %38 = "arith.addi"(%37, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %39 = "air.dma_memcpy_nd"(%arg25, %arg23, %38, %30) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 7>, orbit.storage = "Z", orbit.target_copies = array<i64: 9>, orbit.transfer = "l1_to_host", orbit.transfer_event = 4 : i64, static_dst_offsets = array<i64: -9223372036854775808>, static_dst_sizes = array<i64: 2>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 2>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32>, index, memref<2xf32, strided<[1]>, 2 : i32>) -> !air.async.token
            %40 = "air.wait_all"(%36, %39) : (!air.async.token, !air.async.token) -> !air.async.token
            "scf.yield"(%40) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%10) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<2xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<2xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<2xf32, 2 : i32>) -> ()
          "memref.dealloc"(%5) : (memref<2xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "a7188c05c7d484b5b19dc50aa0c2353b556d5ba10c8b726b881d948c217351c8", orbit.source_fingerprint = "d0876973dffbf1f23db2ddaacb8c3f70133193743462ce16b79aa5dfdd2550d0"} : () -> ()

