"builtin.module"() ({
  "func.func"() <{function_type = (memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> (), sym_name = "streams"}> ({
  ^bb0(%arg0: memref<4xf32>, %arg1: memref<4xf32>, %arg2: memref<4xf32>, %arg3: memref<4xf32>, %arg4: memref<4xf32>, %arg5: memref<4xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5) ({
    ^bb0(%arg6: index, %arg7: index, %arg8: index, %arg9: index, %arg10: memref<4xf32>, %arg11: memref<4xf32>, %arg12: memref<4xf32>, %arg13: memref<4xf32>, %arg14: memref<4xf32>, %arg15: memref<4xf32>):
      "air.segment"(%arg10, %arg11, %arg12, %arg13, %arg14, %arg15) ({
      ^bb0(%arg16: memref<4xf32>, %arg17: memref<4xf32>, %arg18: memref<4xf32>, %arg19: memref<4xf32>, %arg20: memref<4xf32>, %arg21: memref<4xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21) ({
        ^bb0(%arg22: index, %arg23: index, %arg24: index, %arg25: index, %arg26: memref<4xf32>, %arg27: memref<4xf32>, %arg28: memref<4xf32>, %arg29: memref<4xf32>, %arg30: memref<4xf32>, %arg31: memref<4xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.loops.4"} : () -> memref<4xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.4.loops.4"} : () -> memref<4xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.4.loops.4"} : () -> memref<4xf32, 2 : i32>
          %5 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.4.loops.4"} : () -> memref<4xf32, 2 : i32>
          %6 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<4xf32, 2 : i32>
          %7 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : () -> memref<4xf32, 2 : i32>
          %8 = "air.wait_all"() : () -> !air.async.token
          %9 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "A"} : (memref<4xf32, 2 : i32>) -> memref<4xf32, strided<[1]>, 2 : i32>
          %10 = "air.dma_memcpy_nd"(%8, %9, %arg26) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 4>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32, strided<[1]>, 2 : i32>, memref<4xf32>) -> !air.async.token
          %11 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "B"} : (memref<4xf32, 2 : i32>) -> memref<4xf32, strided<[1]>, 2 : i32>
          %12 = "air.dma_memcpy_nd"(%8, %11, %arg27) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 1>, orbit.storage = "B", orbit.target_copies = array<i64: 5>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32, strided<[1]>, 2 : i32>, memref<4xf32>) -> !air.async.token
          %13 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "D"} : (memref<4xf32, 2 : i32>) -> memref<4xf32, strided<[1]>, 2 : i32>
          %14 = "air.dma_memcpy_nd"(%8, %13, %arg28) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 2>, orbit.storage = "D", orbit.target_copies = array<i64: 6>, orbit.transfer = "host_to_l1", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32, strided<[1]>, 2 : i32>, memref<4xf32>) -> !air.async.token
          %15 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "E"} : (memref<4xf32, 2 : i32>) -> memref<4xf32, strided<[1]>, 2 : i32>
          %16 = "air.dma_memcpy_nd"(%8, %15, %arg29) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 3>, orbit.storage = "E", orbit.target_copies = array<i64: 7>, orbit.transfer = "host_to_l1", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32, strided<[1]>, 2 : i32>, memref<4xf32>) -> !air.async.token
          %17 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "Y"} : (memref<4xf32, 2 : i32>) -> memref<4xf32, strided<[1]>, 2 : i32>
          %18 = "memref.reinterpret_cast"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4>, static_strides = array<i64: 1>}> {orbit.phase = 0 : i64, orbit.storage = "Z"} : (memref<4xf32, 2 : i32>) -> memref<4xf32, strided<[1]>, 2 : i32>
          "air.wait_all"(%10, %12, %14, %16) {orbit.computation_event = 4 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.read_copies = array<i64: 4, 5, 6, 7>, orbit.task = "grouped", orbit.write_copies = array<i64: 8, 9>} : (!air.async.token, !air.async.token, !air.async.token, !air.async.token) -> ()
          %19 = "arith.constant"() <{value = 0 : index}> : () -> index
          %20 = "arith.constant"() <{value = 4 : index}> : () -> index
          %21 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%19, %20, %21) ({
          ^bb0(%arg32: index):
            %25 = "memref.load"(%9, %arg32) <{nontemporal = false}> : (memref<4xf32, strided<[1]>, 2 : i32>, index) -> f32
            %26 = "memref.load"(%11, %arg32) <{nontemporal = false}> : (memref<4xf32, strided<[1]>, 2 : i32>, index) -> f32
            %27 = "arith.addf"(%25, %26) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
            "memref.store"(%27, %17, %arg32) <{nontemporal = false}> : (f32, memref<4xf32, strided<[1]>, 2 : i32>, index) -> ()
            %28 = "memref.load"(%13, %arg32) <{nontemporal = false}> : (memref<4xf32, strided<[1]>, 2 : i32>, index) -> f32
            %29 = "memref.load"(%15, %arg32) <{nontemporal = false}> : (memref<4xf32, strided<[1]>, 2 : i32>, index) -> f32
            %30 = "arith.mulf"(%28, %29) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
            "memref.store"(%30, %18, %arg32) <{nontemporal = false}> : (f32, memref<4xf32, strided<[1]>, 2 : i32>, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %22 = "air.dma_memcpy_nd"(%8, %arg30, %17) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 8>, orbit.storage = "Y", orbit.target_copies = array<i64: 10>, orbit.transfer = "l1_to_host", orbit.transfer_event = 5 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32>, memref<4xf32, strided<[1]>, 2 : i32>) -> !air.async.token
          %23 = "air.dma_memcpy_nd"(%8, %arg31, %18) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 9>, orbit.storage = "Z", orbit.target_copies = array<i64: 11>, orbit.transfer = "l1_to_host", orbit.transfer_event = 6 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32>, memref<4xf32, strided<[1]>, 2 : i32>) -> !air.async.token
          %24 = "air.wait_all"(%22, %23) : (!air.async.token, !air.async.token) -> !air.async.token
          "air.wait_all"(%24) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%5) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%6) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%7) : (memref<4xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 6>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 6>, sym_name = "orbit_segment"} : (memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 6>, sym_name = "orbit_launch"} : (index, index, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "04076151383417437b23a2a43e74b6b0358cdfed460f687a1c046bdc0f4a2aed", orbit.source_fingerprint = "4afafa4e53ef58663291b60bd724d183c198d8eae78338bb969c6c445b8acef9"} : () -> ()

