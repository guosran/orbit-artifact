#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> (), sym_name = "up"}> ({
  ^bb0(%arg0: memref<8x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<8x11008xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<8x2048xf32>, %arg8: memref<2048x11008xf32>, %arg9: memref<8x11008xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<8x2048xf32>, %arg11: memref<2048x11008xf32>, %arg12: memref<8x11008xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<8x2048xf32>, %arg18: memref<2048x11008xf32>, %arg19: memref<8x11008xf32>):
          %2 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %3 = "arith.constant"() <{value = 32 : index}> : () -> index
          %4 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %5 = "arith.constant"() <{value = 64 : index}> : () -> index
          %6 = "arith.constant"() <{value = 1 : index}> : () -> index
          %7 = "arith.constant"() <{value = 172 : index}> : () -> index
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.64.loops.8.64.64"} : () -> memref<512xf32, 2 : i32>
          %10 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.64.loops.8.64.64"} : () -> memref<4096xf32, 2 : i32>
          %11 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<512xf32, 2 : i32>
          %12 = "air.wait_all"() : () -> !air.async.token
          %13 = "scf.for"(%8, %7, %6, %12) ({
          ^bb0(%arg20: index, %arg21: !air.async.token):
            %14 = "arith.muli"(%arg20, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.muli"(%arg20, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %16 = "arith.muli"(%arg20, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %17 = "memref.reinterpret_cast"(%11) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "up.initialize", orbit.phase = 172 : i64, orbit.storage = "U"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %18 = "arith.constant"() <{value = 0 : index}> : () -> index
            %19 = "arith.constant"() <{value = 8 : index}> : () -> index
            %20 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%18, %19, %20) ({
            ^bb0(%arg27: index):
              %76 = "arith.constant"() <{value = 0 : index}> : () -> index
              %77 = "arith.constant"() <{value = 64 : index}> : () -> index
              %78 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%76, %77, %78) ({
              ^bb0(%arg28: index):
                %79 = "arith.addi"(%arg28, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %80 = "arith.subi"(%79, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%4, %17, %arg27, %80) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %21 = "scf.for"(%8, %3, %6, %arg21) ({
            ^bb0(%arg22: index, %arg23: !air.async.token):
              %24 = "arith.muli"(%arg22, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "arith.muli"(%arg22, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "arith.muli"(%arg22, %5) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %27 = "memref.reinterpret_cast"(%9) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
              %28 = "air.dma_memcpy_nd"(%arg23, %27, %arg17, %25) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 5536>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x2048xf32>, index) -> !air.async.token
              %29 = "memref.reinterpret_cast"(%10) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "W_up"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %30 = "air.dma_memcpy_nd"(%arg23, %29, %arg18, %26, %15) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 32>, orbit.storage = "W_up", orbit.target_copies = array<i64: 5537>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%28, %30) {orbit.computation_event = 3 : i64, orbit.phase = 172 : i64, orbit.phase_dependencies = array<i64: 171>, orbit.read_copies = array<i64: 5536, 5537, 5538>, orbit.task = "up", orbit.write_copies = array<i64: 5539>} : (!air.async.token, !air.async.token) -> ()
              %31 = "arith.constant"() <{value = 0 : index}> : () -> index
              %32 = "arith.constant"() <{value = 8 : index}> : () -> index
              %33 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%31, %32, %33) ({
              ^bb0(%arg24: index):
                %35 = "arith.constant"() <{value = 0 : index}> : () -> index
                %36 = "arith.constant"() <{value = 64 : index}> : () -> index
                %37 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%35, %36, %37) ({
                ^bb0(%arg25: index):
                  %38 = "arith.addi"(%arg25, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %39 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %40 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %41 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%39, %40, %41) ({
                  ^bb0(%arg26: index):
                    %42 = "arith.addi"(%arg26, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %43 = "arith.subi"(%42, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %44 = "memref.load"(%27, %arg24, %43) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %45 = "arith.subi"(%42, %26) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %46 = "arith.subi"(%38, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %47 = "vector.transfer_read"(%29, %45, %46, %4) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %48 = "arith.subi"(%38, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %49 = "vector.transfer_read"(%17, %arg24, %48, %4) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %50 = "vector.extract"(%47) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %51 = "func.call"(%44, %50) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %52 = "vector.insert"(%51, %2) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %53 = "vector.extract"(%47) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %54 = "func.call"(%44, %53) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %55 = "vector.insert"(%54, %52) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %56 = "vector.extract"(%47) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %57 = "func.call"(%44, %56) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %58 = "vector.insert"(%57, %55) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %59 = "vector.extract"(%47) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %60 = "func.call"(%44, %59) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %61 = "vector.insert"(%60, %58) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %62 = "vector.extract"(%47) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %63 = "func.call"(%44, %62) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %64 = "vector.insert"(%63, %61) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %65 = "vector.extract"(%47) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %66 = "func.call"(%44, %65) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %67 = "vector.insert"(%66, %64) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %68 = "vector.extract"(%47) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %69 = "func.call"(%44, %68) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %70 = "vector.insert"(%69, %67) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %71 = "vector.extract"(%47) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %72 = "func.call"(%44, %71) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %73 = "vector.insert"(%72, %70) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %74 = "arith.addf"(%49, %73) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %75 = "arith.subi"(%38, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%74, %17, %arg24, %75) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %34 = "air.wait_all"(%arg23) : (!air.async.token) -> !air.async.token
              "scf.yield"(%34) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %22 = "air.dma_memcpy_nd"(%21, %arg19, %16, %17) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 203 : i64, orbit.retained_begin = 172 : i64, orbit.retained_end = 204 : i64, orbit.source_copies = array<i64: 5632>, orbit.storage = "U", orbit.target_copies = array<i64: 5633>, orbit.transfer = "l1_to_host", orbit.transfer_event = 97 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x11008xf32>, index, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %23 = "air.wait_all"(%22) : (!air.async.token) -> !air.async.token
            "scf.yield"(%23) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%13) : (!air.async.token) -> ()
          "memref.dealloc"(%9) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%10) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%11) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "ef2a9d0c97accff0e334366a4fe1391f44079be79c85d027b6d09a1dcbe0a86f", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "82fc0c4784eb588cc9bf162167c69fc99f53bb8dced80a4c309a3d8307eb78e1"} : () -> ()

