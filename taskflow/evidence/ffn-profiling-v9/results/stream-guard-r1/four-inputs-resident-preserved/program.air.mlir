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
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage = "A"} : () -> memref<4xf32, 2 : i32>
          %3 = "air.dma_memcpy_nd"(%2, %arg26) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 4>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (memref<4xf32, 2 : i32>, memref<4xf32>) -> !air.async.token
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage = "B"} : () -> memref<4xf32, 2 : i32>
          %5 = "air.dma_memcpy_nd"(%4, %arg27) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.source_copies = array<i64: 1>, orbit.storage = "B", orbit.target_copies = array<i64: 5>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (memref<4xf32, 2 : i32>, memref<4xf32>) -> !air.async.token
          %6 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage = "D"} : () -> memref<4xf32, 2 : i32>
          %7 = "air.dma_memcpy_nd"(%6, %arg28) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.source_copies = array<i64: 2>, orbit.storage = "D", orbit.target_copies = array<i64: 6>, orbit.transfer = "host_to_l1", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (memref<4xf32, 2 : i32>, memref<4xf32>) -> !air.async.token
          %8 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage = "E"} : () -> memref<4xf32, 2 : i32>
          %9 = "air.dma_memcpy_nd"(%8, %arg29) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.source_copies = array<i64: 3>, orbit.storage = "E", orbit.target_copies = array<i64: 7>, orbit.transfer = "host_to_l1", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (memref<4xf32, 2 : i32>, memref<4xf32>) -> !air.async.token
          %10 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage = "Y"} : () -> memref<4xf32, 2 : i32>
          %11 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage = "Z"} : () -> memref<4xf32, 2 : i32>
          "air.wait_all"(%3, %5, %7, %9) {orbit.source_dependencies = array<i64>, orbit.task = "grouped"} : (!air.async.token, !air.async.token, !air.async.token, !air.async.token) -> ()
          %12 = "arith.constant"() <{value = 0 : index}> : () -> index
          %13 = "arith.constant"() <{value = 4 : index}> : () -> index
          %14 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%12, %13, %14) ({
          ^bb0(%arg32: index):
            %18 = "memref.load"(%2, %arg32) <{nontemporal = false}> : (memref<4xf32, 2 : i32>, index) -> f32
            %19 = "memref.load"(%4, %arg32) <{nontemporal = false}> : (memref<4xf32, 2 : i32>, index) -> f32
            %20 = "arith.addf"(%18, %19) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
            "memref.store"(%20, %10, %arg32) <{nontemporal = false}> : (f32, memref<4xf32, 2 : i32>, index) -> ()
            %21 = "memref.load"(%6, %arg32) <{nontemporal = false}> : (memref<4xf32, 2 : i32>, index) -> f32
            %22 = "memref.load"(%8, %arg32) <{nontemporal = false}> : (memref<4xf32, 2 : i32>, index) -> f32
            %23 = "arith.mulf"(%21, %22) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
            "memref.store"(%23, %11, %arg32) <{nontemporal = false}> : (f32, memref<4xf32, 2 : i32>, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %15 = "air.wait_all"() {orbit.task_completion = "grouped"} : () -> !air.async.token
          %16 = "air.dma_memcpy_nd"(%15, %arg30, %10) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.source_copies = array<i64: 8>, orbit.storage = "Y", orbit.target_copies = array<i64: 10>, orbit.transfer = "l1_to_host", orbit.transfer_event = 5 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32>, memref<4xf32, 2 : i32>) -> !air.async.token
          %17 = "air.dma_memcpy_nd"(%15, %arg31, %11) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.source_copies = array<i64: 9>, orbit.storage = "Z", orbit.target_copies = array<i64: 11>, orbit.transfer = "l1_to_host", orbit.transfer_event = 6 : i64, static_dst_offsets = array<i64: 0>, static_dst_sizes = array<i64: 4>, static_dst_strides = array<i64: 1>, static_src_offsets = array<i64: 0>, static_src_sizes = array<i64: 4>, static_src_strides = array<i64: 1>} : (!air.async.token, memref<4xf32>, memref<4xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%16, %17) : (!air.async.token, !air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%6) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%8) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%10) : (memref<4xf32, 2 : i32>) -> ()
          "memref.dealloc"(%11) : (memref<4xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 6>, orbit.mapping_strategy = "single-herd-resident", sym_name = "orbit_herd"} : (index, index, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 6>, sym_name = "orbit_segment"} : (memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 6>, sym_name = "orbit_launch"} : (index, index, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "c97478d62536f5b05847b17d38ef5c603b52e15343a4281dc511a4dd28b68e4a", orbit.source_fingerprint = "4afafa4e53ef58663291b60bd724d183c198d8eae78338bb969c6c445b8acef9"} : () -> ()

