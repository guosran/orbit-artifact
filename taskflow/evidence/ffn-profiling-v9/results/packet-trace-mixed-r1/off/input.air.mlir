#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
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
            %64 = "arith.constant"() <{value = 0 : index}> : () -> index
            %65 = "arith.constant"() <{value = 16 : index}> : () -> index
            %66 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%64, %65, %66) ({
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
          aie.event(0)
          %15 = "memref.cast"(%11) : (memref<1x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<1x64xf32, 2 : i32>
          %16 = "memref.cast"(%13) : (memref<64x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<64x16xf32, 2 : i32>
          %17 = "memref.cast"(%6) : (memref<1x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<1x16xf32, 2 : i32>
          %18 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %19 = "arith.constant"() <{value = 0 : index}> : () -> index
          %20 = "arith.constant"() <{value = 1 : index}> : () -> index
          %21 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%19, %20, %21) ({
          ^bb0(%arg20: index):
            %25 = "arith.constant"() <{value = 0 : index}> : () -> index
            %26 = "arith.constant"() <{value = 16 : index}> : () -> index
            %27 = "arith.constant"() <{value = 8 : index}> : () -> index
            "scf.for"(%25, %26, %27) ({
            ^bb0(%arg21: index):
              %28 = "arith.constant"() <{value = 0 : index}> : () -> index
              %29 = "arith.constant"() <{value = 64 : index}> : () -> index
              %30 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%28, %29, %30) ({
              ^bb0(%arg22: index):
                %31 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                %32 = "memref.load"(%15, %arg20, %arg22) <{nontemporal = false}> : (memref<1x64xf32, 2 : i32>, index, index) -> f32
                %33 = "vector.broadcast"(%32) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                %34 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                %35 = "vector.transfer_read"(%16, %arg22, %arg21, %34) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                %36 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                %37 = "vector.transfer_read"(%17, %arg20, %arg21, %36) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                %38 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                %39 = "vector.extract"(%35) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                %40 = "func.call"(%32, %39) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %41 = "vector.insert"(%40, %38) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %42 = "vector.extract"(%35) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                %43 = "func.call"(%32, %42) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %44 = "vector.insert"(%43, %41) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %45 = "vector.extract"(%35) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                %46 = "func.call"(%32, %45) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %47 = "vector.insert"(%46, %44) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %48 = "vector.extract"(%35) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                %49 = "func.call"(%32, %48) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %50 = "vector.insert"(%49, %47) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %51 = "vector.extract"(%35) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                %52 = "func.call"(%32, %51) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %53 = "vector.insert"(%52, %50) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %54 = "vector.extract"(%35) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                %55 = "func.call"(%32, %54) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %56 = "vector.insert"(%55, %53) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %57 = "vector.extract"(%35) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                %58 = "func.call"(%32, %57) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %59 = "vector.insert"(%58, %56) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %60 = "vector.extract"(%35) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                %61 = "func.call"(%32, %60) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %62 = "vector.insert"(%61, %59) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                %63 = "arith.addf"(%37, %62) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                "vector.transfer_write"(%63, %17, %arg20, %arg21) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x16xf32, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %22 = "air.wait_all"(%5) : (!air.async.token) -> !air.async.token
          aie.event(1)
          %23 = "air.dma_memcpy_nd"(%22, %arg19, %6) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 1 : i64, orbit.retained_begin = 1 : i64, orbit.retained_end = 2 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "C", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 4 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<1x16xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          %24 = "air.wait_all"(%23) : (!air.async.token) -> !air.async.token
          "air.wait_all"(%24) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<64xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<16xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "524e4c6a826d08d8438c0185cf530ef7f15488c22f4677e94f170cbaf7bd3f20", orbit.source_fingerprint = "9795912d6d8439a7371a6f129a804117d1940ad841ed58f7ca9fe6c0b5b98e32"} : () -> ()

