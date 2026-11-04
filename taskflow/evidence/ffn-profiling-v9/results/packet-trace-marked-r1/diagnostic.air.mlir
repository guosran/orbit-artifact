"builtin.module"() ({
  "func.func"() <{function_type = (memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>) -> (), sym_name = "gemm"}> ({
  ^bb0(%arg0: memref<1x64xf32>, %arg1: memref<64x16xf32>, %arg2: memref<1x16xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<1x64xf32>, %arg8: memref<64x16xf32>, %arg9: memref<1x16xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<1x64xf32>, %arg11: memref<64x16xf32>, %arg12: memref<1x16xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<1x64xf32>, %arg18: memref<64x16xf32>, %arg19: memref<1x16xf32>):
          aie.event(0)
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.64.loops.1.16.64"} : () -> memref<64xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.16.loops.1.16.64"} : () -> memref<1024xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<16xf32, 2 : i32>
          %5 = "air.wait_all"() : () -> !air.async.token
          %6 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 1 : i64, orbit.storage = "C"} : (memref<16xf32, 2 : i32>) -> memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %7 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "arith.constant"() <{value = 1 : index}> : () -> index
          %10 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%8, %9, %10) ({
          ^bb0(%arg23: index):
            %33 = "arith.constant"() <{value = 0 : index}> : () -> index
            %34 = "arith.constant"() <{value = 16 : index}> : () -> index
            %35 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%33, %34, %35) ({
            ^bb0(%arg24: index):
              "memref.store"(%7, %6, %arg23, %arg24) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %11 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "A"} : (memref<64xf32, 2 : i32>) -> memref<1x64xf32, strided<[64, 1]>, 2 : i32>
          %12 = "air.dma_memcpy_nd"(%5, %11, %arg17) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 1 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 2>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<1x64xf32, strided<[64, 1]>, 2 : i32>, memref<1x64xf32>) -> !air.async.token
          %13 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 1 : i64, orbit.storage = "B"} : (memref<1024xf32, 2 : i32>) -> memref<64x16xf32, strided<[16, 1]>, 2 : i32>
          %14 = "air.dma_memcpy_nd"(%5, %13, %arg18) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 1 : i64, orbit.source_copies = array<i64: 1>, orbit.storage = "B", orbit.target_copies = array<i64: 3>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 64, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<64x16xf32, strided<[16, 1]>, 2 : i32>, memref<64x16xf32>) -> !air.async.token
          "air.wait_all"(%12, %14) {orbit.computation_event = 3 : i64, orbit.phase = 1 : i64, orbit.phase_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 2, 3, 4>, orbit.task = "gemm", orbit.write_copies = array<i64: 5>} : (!air.async.token, !air.async.token) -> ()
          %15 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %16 = "arith.constant"() <{value = 0 : index}> : () -> index
          %17 = "arith.constant"() <{value = 1 : index}> : () -> index
          %18 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%16, %17, %18) ({
          ^bb0(%arg20: index):
            %22 = "arith.constant"() <{value = 0 : index}> : () -> index
            %23 = "arith.constant"() <{value = 16 : index}> : () -> index
            %24 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%22, %23, %24) ({
            ^bb0(%arg21: index):
              %25 = "arith.constant"() <{value = 0 : index}> : () -> index
              %26 = "arith.constant"() <{value = 64 : index}> : () -> index
              %27 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%25, %26, %27) ({
              ^bb0(%arg22: index):
                %28 = "memref.load"(%11, %arg20, %arg22) <{nontemporal = false}> : (memref<1x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                %29 = "memref.load"(%13, %arg22, %arg21) <{nontemporal = false}> : (memref<64x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %30 = "memref.load"(%6, %arg20, %arg21) <{nontemporal = false}> : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
                %31 = "arith.mulf"(%28, %29) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %32 = "arith.addf"(%30, %31) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                "memref.store"(%32, %6, %arg20, %arg21) <{nontemporal = false}> : (f32, memref<1x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %19 = "air.wait_all"(%5) : (!air.async.token) -> !air.async.token
          %20 = "air.dma_memcpy_nd"(%19, %arg19, %6) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 1 : i64, orbit.retained_begin = 1 : i64, orbit.retained_end = 2 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "C", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 4 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<1x16xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %21 = "air.wait_all"(%20) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%21) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<64xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<16xf32, 2 : i32>) -> ()
          aie.event(1)
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "0da5d040dd8c46ad5b4ce2a351adf9f21f5612d09dc1e88ff591f982ad0a271f", orbit.source_fingerprint = "9795912d6d8439a7371a6f129a804117d1940ad841ed58f7ca9fe6c0b5b98e32"} : () -> ()

