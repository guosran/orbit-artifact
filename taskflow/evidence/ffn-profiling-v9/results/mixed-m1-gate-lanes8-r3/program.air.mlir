#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<1x2048xf32>, memref<2048x11008xf32>, memref<1x11008xf32>) -> (), sym_name = "gate"}> ({
  ^bb0(%arg0: memref<1x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<1x11008xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<1x2048xf32>, %arg8: memref<2048x11008xf32>, %arg9: memref<1x11008xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<1x2048xf32>, %arg11: memref<2048x11008xf32>, %arg12: memref<1x11008xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<1x2048xf32>, %arg18: memref<2048x11008xf32>, %arg19: memref<1x11008xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.64.loops.1.64.64"} : () -> memref<64xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.64.loops.1.64.64"} : () -> memref<4096xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<64xf32, 2 : i32>
          %5 = "air.wait_all"() : () -> !air.async.token
          %6 = "arith.constant"() <{value = 0 : index}> : () -> index
          %7 = "arith.constant"() <{value = 172 : index}> : () -> index
          %8 = "arith.constant"() <{value = 1 : index}> : () -> index
          %9 = "scf.for"(%6, %7, %8, %5) ({
          ^bb0(%arg20: index, %arg21: !air.async.token):
            %10 = "arith.constant"() <{value = 64 : index}> : () -> index
            %11 = "arith.muli"(%arg20, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %12 = "arith.constant"() <{value = 64 : index}> : () -> index
            %13 = "arith.muli"(%arg20, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %14 = "arith.constant"() <{value = 64 : index}> : () -> index
            %15 = "arith.muli"(%arg20, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %16 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 64>, static_strides = array<i64: 64, 1>}> {orbit.initializer_task = "gate.initialize", orbit.phase = 172 : i64, orbit.storage = "G"} : (memref<64xf32, 2 : i32>) -> memref<1x64xf32, strided<[64, 1]>, 2 : i32>
            %17 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %18 = "arith.constant"() <{value = 0 : index}> : () -> index
            %19 = "arith.constant"() <{value = 1 : index}> : () -> index
            %20 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%18, %19, %20) ({
            ^bb0(%arg27: index):
              %99 = "arith.constant"() <{value = 0 : index}> : () -> index
              %100 = "arith.constant"() <{value = 64 : index}> : () -> index
              %101 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%99, %100, %101) ({
              ^bb0(%arg28: index):
                %102 = "arith.addi"(%arg28, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %103 = "arith.subi"(%102, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%17, %16, %arg27, %103) <{nontemporal = false}> : (f32, memref<1x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %21 = "arith.constant"() <{value = 0 : index}> : () -> index
            %22 = "arith.constant"() <{value = 32 : index}> : () -> index
            %23 = "arith.constant"() <{value = 1 : index}> : () -> index
            %24 = "scf.for"(%21, %22, %23, %arg21) ({
            ^bb0(%arg22: index, %arg23: !air.async.token):
              %29 = "arith.constant"() <{value = 64 : index}> : () -> index
              %30 = "arith.muli"(%arg22, %29) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "arith.constant"() <{value = 64 : index}> : () -> index
              %32 = "arith.muli"(%arg22, %31) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %33 = "arith.constant"() <{value = 64 : index}> : () -> index
              %34 = "arith.muli"(%arg22, %33) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %35 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "X"} : (memref<64xf32, 2 : i32>) -> memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %36 = "arith.constant"() <{value = 0 : index}> : () -> index
              %37 = "arith.addi"(%36, %32) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %38 = "air.dma_memcpy_nd"(%arg23, %35, %arg17, %37) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 5536>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 1, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<1x64xf32, strided<[64, 1]>, 2 : i32>, memref<1x2048xf32>, index) -> !air.async.token
              %39 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 172 : i64, orbit.storage = "W_gate"} : (memref<4096xf32, 2 : i32>) -> memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %40 = "arith.constant"() <{value = 0 : index}> : () -> index
              %41 = "arith.addi"(%40, %34) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %42 = "arith.constant"() <{value = 0 : index}> : () -> index
              %43 = "arith.addi"(%42, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %44 = "air.dma_memcpy_nd"(%arg23, %39, %arg18, %41, %43) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 172 : i64, orbit.source_copies = array<i64: 32>, orbit.storage = "W_gate", orbit.target_copies = array<i64: 5537>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x64xf32, strided<[64, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%38, %44) {orbit.computation_event = 3 : i64, orbit.phase = 172 : i64, orbit.phase_dependencies = array<i64: 171>, orbit.read_copies = array<i64: 5536, 5537, 5538>, orbit.task = "gate", orbit.write_copies = array<i64: 5539>} : (!air.async.token, !air.async.token) -> ()
              %45 = "memref.cast"(%35) : (memref<1x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<1x64xf32, 2 : i32>
              %46 = "memref.cast"(%39) : (memref<64x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<64x64xf32, 2 : i32>
              %47 = "memref.cast"(%16) : (memref<1x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<1x64xf32, 2 : i32>
              %48 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %49 = "arith.constant"() <{value = 0 : index}> : () -> index
              %50 = "arith.constant"() <{value = 1 : index}> : () -> index
              %51 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%49, %50, %51) ({
              ^bb0(%arg24: index):
                %53 = "arith.constant"() <{value = 0 : index}> : () -> index
                %54 = "arith.constant"() <{value = 64 : index}> : () -> index
                %55 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%53, %54, %55) ({
                ^bb0(%arg25: index):
                  %56 = "arith.addi"(%arg25, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %57 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %58 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %59 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%57, %58, %59) ({
                  ^bb0(%arg26: index):
                    %60 = "arith.addi"(%arg26, %30) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %61 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %62 = "arith.subi"(%60, %32) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %63 = "memref.load"(%45, %arg24, %62) <{nontemporal = false}> : (memref<1x64xf32, 2 : i32>, index, index) -> f32
                    %64 = "vector.broadcast"(%63) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                    %65 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %66 = "arith.subi"(%60, %34) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %67 = "arith.subi"(%56, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %68 = "vector.transfer_read"(%46, %66, %67, %65) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x64xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %69 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %70 = "arith.subi"(%56, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %71 = "vector.transfer_read"(%47, %arg24, %70, %69) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x64xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %72 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                    %73 = "vector.extract"(%68) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %74 = "func.call"(%63, %73) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %75 = "vector.insert"(%74, %72) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %76 = "vector.extract"(%68) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %77 = "func.call"(%63, %76) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %78 = "vector.insert"(%77, %75) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %79 = "vector.extract"(%68) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %80 = "func.call"(%63, %79) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %81 = "vector.insert"(%80, %78) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %82 = "vector.extract"(%68) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %83 = "func.call"(%63, %82) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %84 = "vector.insert"(%83, %81) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %85 = "vector.extract"(%68) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %86 = "func.call"(%63, %85) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %87 = "vector.insert"(%86, %84) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %88 = "vector.extract"(%68) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %89 = "func.call"(%63, %88) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %90 = "vector.insert"(%89, %87) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %91 = "vector.extract"(%68) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %92 = "func.call"(%63, %91) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %93 = "vector.insert"(%92, %90) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %94 = "vector.extract"(%68) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %95 = "func.call"(%63, %94) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %96 = "vector.insert"(%95, %93) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %97 = "arith.addf"(%71, %96) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %98 = "arith.subi"(%56, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%97, %47, %arg24, %98) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x64xf32, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %52 = "air.wait_all"(%arg23) : (!air.async.token) -> !air.async.token
              "scf.yield"(%52) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %25 = "arith.constant"() <{value = 0 : index}> : () -> index
            %26 = "arith.addi"(%25, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %27 = "air.dma_memcpy_nd"(%24, %arg19, %26, %16) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 203 : i64, orbit.retained_begin = 172 : i64, orbit.retained_end = 204 : i64, orbit.source_copies = array<i64: 5632>, orbit.storage = "G", orbit.target_copies = array<i64: 5633>, orbit.transfer = "l1_to_host", orbit.transfer_event = 97 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 1, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<1x11008xf32>, index, memref<1x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %28 = "air.wait_all"(%27) : (!air.async.token) -> !air.async.token
            "scf.yield"(%28) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%9) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<64xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<4096xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<64xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<1x2048xf32>, memref<2048x11008xf32>, memref<1x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<1x2048xf32>, memref<2048x11008xf32>, memref<1x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<1x2048xf32>, memref<2048x11008xf32>, memref<1x11008xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "c727744072857e83ba6bf5ab302b1b6e21f9215a0f782b389b7ecdd5fb43c811", orbit.source_fingerprint = "8d92f38303672940f6c28ff38f9cad627974f80605d49ac3bfff4f52d1b8e565"} : () -> ()

