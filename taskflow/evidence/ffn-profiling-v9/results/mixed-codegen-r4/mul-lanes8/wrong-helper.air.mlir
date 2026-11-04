#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__divsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<4x8xf32>, memref<8x16xf32>, memref<4x16xf32>) -> (), sym_name = "gemm"}> ({
  ^bb0(%arg0: memref<4x8xf32>, %arg1: memref<8x16xf32>, %arg2: memref<4x16xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<4x8xf32>, %arg8: memref<8x16xf32>, %arg9: memref<4x16xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<4x8xf32>, %arg11: memref<8x16xf32>, %arg12: memref<4x16xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<4x8xf32>, %arg18: memref<8x16xf32>, %arg19: memref<4x16xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.2.4.loops.2.8.4"} : () -> memref<8xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.4.8.loops.2.8.4"} : () -> memref<32xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<16xf32, 2 : i32>
          %5 = "air.wait_all"() : () -> !air.async.token
          %6 = "arith.constant"() <{value = 0 : index}> : () -> index
          %7 = "arith.constant"() <{value = 2 : index}> : () -> index
          %8 = "arith.constant"() <{value = 1 : index}> : () -> index
          %9 = "scf.for"(%6, %7, %8, %5) ({
          ^bb0(%arg20: index, %arg21: !air.async.token):
            %10 = "arith.constant"() <{value = 2 : index}> : () -> index
            %11 = "arith.muli"(%arg20, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %12 = "arith.constant"() <{value = 2 : index}> : () -> index
            %13 = "arith.muli"(%arg20, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %14 = "arith.constant"() <{value = 2 : index}> : () -> index
            %15 = "arith.muli"(%arg20, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %16 = "arith.constant"() <{value = 0 : index}> : () -> index
            %17 = "arith.constant"() <{value = 2 : index}> : () -> index
            %18 = "arith.constant"() <{value = 1 : index}> : () -> index
            %19 = "scf.for"(%16, %17, %18, %arg21) ({
            ^bb0(%arg22: index, %arg23: !air.async.token):
              %20 = "arith.constant"() <{value = 8 : index}> : () -> index
              %21 = "arith.muli"(%arg22, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %22 = "arith.constant"() <{value = 8 : index}> : () -> index
              %23 = "arith.muli"(%arg22, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %24 = "arith.constant"() <{value = 8 : index}> : () -> index
              %25 = "arith.muli"(%arg22, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2, 8>, static_strides = array<i64: 8, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 4 : i64, orbit.storage = "C"} : (memref<16xf32, 2 : i32>) -> memref<2x8xf32, strided<[8, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %28 = "arith.constant"() <{value = 0 : index}> : () -> index
              %29 = "arith.constant"() <{value = 2 : index}> : () -> index
              %30 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%28, %29, %30) ({
              ^bb0(%arg29: index):
                %117 = "arith.addi"(%arg29, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %118 = "arith.constant"() <{value = 0 : index}> : () -> index
                %119 = "arith.constant"() <{value = 8 : index}> : () -> index
                %120 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%118, %119, %120) ({
                ^bb0(%arg30: index):
                  %121 = "arith.addi"(%arg30, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %122 = "arith.subi"(%117, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %123 = "arith.subi"(%121, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%27, %26, %122, %123) <{nontemporal = false}> : (f32, memref<2x8xf32, strided<[8, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %31 = "arith.constant"() <{value = 0 : index}> : () -> index
              %32 = "arith.constant"() <{value = 2 : index}> : () -> index
              %33 = "arith.constant"() <{value = 1 : index}> : () -> index
              %34 = "scf.for"(%31, %32, %33, %arg23) ({
              ^bb0(%arg24: index, %arg25: !air.async.token):
                %41 = "arith.constant"() <{value = 4 : index}> : () -> index
                %42 = "arith.muli"(%arg24, %41) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %43 = "arith.constant"() <{value = 4 : index}> : () -> index
                %44 = "arith.muli"(%arg24, %43) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %45 = "arith.constant"() <{value = 4 : index}> : () -> index
                %46 = "arith.muli"(%arg24, %45) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %47 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2, 4>, static_strides = array<i64: 4, 1>}> {orbit.phase = 4 : i64, orbit.storage = "A"} : (memref<8xf32, 2 : i32>) -> memref<2x4xf32, strided<[4, 1]>, 2 : i32>
                %48 = "arith.constant"() <{value = 0 : index}> : () -> index
                %49 = "arith.addi"(%48, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %50 = "arith.constant"() <{value = 0 : index}> : () -> index
                %51 = "arith.addi"(%50, %44) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %52 = "air.dma_memcpy_nd"(%arg25, %47, %arg17, %49, %51) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 8>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 2, 4>, static_dst_strides = array<i64: 4, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 2, 4>, static_src_strides = array<i64: 8, 1>} : (!air.async.token, memref<2x4xf32, strided<[4, 1]>, 2 : i32>, memref<4x8xf32>, index, index) -> !air.async.token
                %53 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 8>, static_strides = array<i64: 8, 1>}> {orbit.phase = 4 : i64, orbit.storage = "B"} : (memref<32xf32, 2 : i32>) -> memref<4x8xf32, strided<[8, 1]>, 2 : i32>
                %54 = "arith.constant"() <{value = 0 : index}> : () -> index
                %55 = "arith.addi"(%54, %46) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %56 = "arith.constant"() <{value = 0 : index}> : () -> index
                %57 = "arith.addi"(%56, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %58 = "air.dma_memcpy_nd"(%arg25, %53, %arg18, %55, %57) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "B", orbit.target_copies = array<i64: 9>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 8>, static_dst_strides = array<i64: 8, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 4, 8>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<4x8xf32, strided<[8, 1]>, 2 : i32>, memref<8x16xf32>, index, index) -> !air.async.token
                "air.wait_all"(%52, %58) {orbit.computation_event = 3 : i64, orbit.phase = 4 : i64, orbit.phase_dependencies = array<i64: 3>, orbit.read_copies = array<i64: 8, 9, 10>, orbit.task = "gemm", orbit.write_copies = array<i64: 11>} : (!air.async.token, !air.async.token) -> ()
                %59 = "memref.cast"(%47) : (memref<2x4xf32, strided<[4, 1]>, 2 : i32>) -> memref<2x4xf32, 2 : i32>
                %60 = "memref.cast"(%53) : (memref<4x8xf32, strided<[8, 1]>, 2 : i32>) -> memref<4x8xf32, 2 : i32>
                %61 = "memref.cast"(%26) : (memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> memref<2x8xf32, 2 : i32>
                %62 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                %63 = "arith.constant"() <{value = 0 : index}> : () -> index
                %64 = "arith.constant"() <{value = 2 : index}> : () -> index
                %65 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%63, %64, %65) ({
                ^bb0(%arg26: index):
                  %67 = "arith.addi"(%arg26, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %68 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %69 = "arith.constant"() <{value = 8 : index}> : () -> index
                  %70 = "arith.constant"() <{value = 8 : index}> : () -> index
                  "scf.for"(%68, %69, %70) ({
                  ^bb0(%arg27: index):
                    %71 = "arith.addi"(%arg27, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %72 = "arith.constant"() <{value = 0 : index}> : () -> index
                    %73 = "arith.constant"() <{value = 4 : index}> : () -> index
                    %74 = "arith.constant"() <{value = 1 : index}> : () -> index
                    "scf.for"(%72, %73, %74) ({
                    ^bb0(%arg28: index):
                      %75 = "arith.addi"(%arg28, %42) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %76 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                      %77 = "arith.subi"(%67, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %78 = "arith.subi"(%75, %44) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %79 = "memref.load"(%59, %77, %78) <{nontemporal = false}> : (memref<2x4xf32, 2 : i32>, index, index) -> f32
                      %80 = "vector.broadcast"(%79) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                      %81 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                      %82 = "arith.subi"(%75, %46) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %83 = "arith.subi"(%71, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %84 = "vector.transfer_read"(%60, %82, %83, %81) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x8xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                      %85 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                      %86 = "arith.subi"(%67, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %87 = "arith.subi"(%71, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %88 = "vector.transfer_read"(%61, %86, %87, %85) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<2x8xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                      %89 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                      %90 = "vector.extract"(%84) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                      %91 = "func.call"(%79, %90) <{callee = @__divsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %92 = "vector.insert"(%91, %89) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %93 = "vector.extract"(%84) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                      %94 = "func.call"(%79, %93) <{callee = @__divsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %95 = "vector.insert"(%94, %92) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %96 = "vector.extract"(%84) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                      %97 = "func.call"(%79, %96) <{callee = @__divsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %98 = "vector.insert"(%97, %95) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %99 = "vector.extract"(%84) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                      %100 = "func.call"(%79, %99) <{callee = @__divsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %101 = "vector.insert"(%100, %98) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %102 = "vector.extract"(%84) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                      %103 = "func.call"(%79, %102) <{callee = @__divsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %104 = "vector.insert"(%103, %101) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %105 = "vector.extract"(%84) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                      %106 = "func.call"(%79, %105) <{callee = @__divsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %107 = "vector.insert"(%106, %104) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %108 = "vector.extract"(%84) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                      %109 = "func.call"(%79, %108) <{callee = @__divsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %110 = "vector.insert"(%109, %107) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %111 = "vector.extract"(%84) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                      %112 = "func.call"(%79, %111) <{callee = @__divsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      %113 = "vector.insert"(%112, %110) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                      %114 = "arith.addf"(%88, %113) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                      %115 = "arith.subi"(%67, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      %116 = "arith.subi"(%71, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                      "vector.transfer_write"(%114, %61, %115, %116) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<2x8xf32, 2 : i32>, index, index) -> ()
                      "scf.yield"() : () -> ()
                    }) : (index, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                %66 = "air.wait_all"(%arg25) : (!air.async.token) -> !air.async.token
                "scf.yield"(%66) : (!air.async.token) -> ()
              }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.addi"(%35, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %37 = "arith.constant"() <{value = 0 : index}> : () -> index
              %38 = "arith.addi"(%37, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %39 = "air.dma_memcpy_nd"(%34, %arg19, %36, %38, %26) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 5 : i64, orbit.retained_begin = 4 : i64, orbit.retained_end = 6 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "C", orbit.target_copies = array<i64: 15>, orbit.transfer = "l1_to_host", orbit.transfer_event = 7 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 2, 8>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 2, 8>, static_src_strides = array<i64: 8, 1>} : (!air.async.token, memref<4x16xf32>, index, index, memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> !air.async.token
              %40 = "air.wait_all"(%39) : (!air.async.token) -> !air.async.token
              "scf.yield"(%40) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%19) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%9) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<8xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<32xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<16xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<4x8xf32>, memref<8x16xf32>, memref<4x16xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<4x8xf32>, memref<8x16xf32>, memref<4x16xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<4x8xf32>, memref<8x16xf32>, memref<4x16xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "e8357bb95e79e677d6f4cada13f068cc62b01287821cb2135977c6962193de03", orbit.source_fingerprint = "d7e61ee155d2499dd3f48faeec8e03662e2fbfa736ac774de4028bd533ecfe27"} : () -> ()

