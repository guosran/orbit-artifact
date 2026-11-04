"builtin.module"() ({
  "func.func"() <{function_type = (memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> (), sym_name = "activation"}> ({
  ^bb0(%arg0: memref<8x11008xf32>, %arg1: memref<8x11008xf32>, %arg2: memref<8x11008xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<8x11008xf32>, %arg8: memref<8x11008xf32>, %arg9: memref<8x11008xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<8x11008xf32>, %arg11: memref<8x11008xf32>, %arg12: memref<8x11008xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<8x11008xf32>, %arg18: memref<8x11008xf32>, %arg19: memref<8x11008xf32>):
          %2 = "arith.constant"() <{value = 127 : i32}> : () -> i32
          %3 = "arith.constant"() <{value = 23 : i32}> : () -> i32
          %4 = "arith.constant"() <{value = 1.270000e+02 : f32}> : () -> f32
          %5 = "arith.constant"() <{value = -1.270000e+02 : f32}> : () -> f32
          %6 = "arith.constant"() <{value = 8.880000e+01 : f32}> : () -> f32
          %7 = "arith.constant"() <{value = -8.780000e+01 : f32}> : () -> f32
          %8 = "arith.constant"() <{value = 0.166666657 : f32}> : () -> f32
          %9 = "arith.constant"() <{value = 0.0416657962 : f32}> : () -> f32
          %10 = "arith.constant"() <{value = 0.00833345205 : f32}> : () -> f32
          %11 = "arith.constant"() <{value = 0.00139819994 : f32}> : () -> f32
          %12 = "arith.constant"() <{value = 1.98756912E-4 : f32}> : () -> f32
          %13 = "arith.constant"() <{value = 2.12194442E-4 : f32}> : () -> f32
          %14 = "arith.constant"() <{value = -0.693359375 : f32}> : () -> f32
          %15 = "arith.constant"() <{value = 1.44269502 : f32}> : () -> f32
          %16 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %17 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
          %18 = "arith.constant"() <{value = 64 : index}> : () -> index
          %19 = "arith.constant"() <{value = 1 : index}> : () -> index
          %20 = "arith.constant"() <{value = 172 : index}> : () -> index
          %21 = "arith.constant"() <{value = 0 : index}> : () -> index
          %22 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.64.loops.8.64"} : () -> memref<512xf32, 2 : i32>
          %23 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.8.64.loops.8.64"} : () -> memref<512xf32, 2 : i32>
          %24 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<512xf32, 2 : i32>
          %25 = "air.wait_all"() : () -> !air.async.token
          %26 = "scf.for"(%21, %20, %19, %25) ({
          ^bb0(%arg20: index, %arg21: !air.async.token):
            %27 = "arith.muli"(%arg20, %18) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %28 = "arith.muli"(%arg20, %18) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %29 = "arith.muli"(%arg20, %18) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %30 = "arith.muli"(%arg20, %18) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %31 = "memref.reinterpret_cast"(%22) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "G"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %32 = "air.dma_memcpy_nd"(%arg21, %31, %arg17, %28) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "G", orbit.target_copies = array<i64: 344>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x11008xf32>, index) -> !air.async.token
            %33 = "memref.reinterpret_cast"(%23) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "U"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            %34 = "air.dma_memcpy_nd"(%arg21, %33, %arg18, %29) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 172>, orbit.storage = "U", orbit.target_copies = array<i64: 345>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<8x11008xf32>, index) -> !air.async.token
            %35 = "memref.reinterpret_cast"(%24) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "H"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
            "air.wait_all"(%32, %34) {orbit.computation_event = 2 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.read_copies = array<i64: 344, 345>, orbit.task = "swiglu", orbit.write_copies = array<i64: 346>} : (!air.async.token, !air.async.token) -> ()
            %36 = "arith.constant"() <{value = 0 : index}> : () -> index
            %37 = "arith.constant"() <{value = 8 : index}> : () -> index
            %38 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%36, %37, %38) ({
            ^bb0(%arg22: index):
              %41 = "arith.constant"() <{value = 0 : index}> : () -> index
              %42 = "arith.constant"() <{value = 64 : index}> : () -> index
              %43 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%41, %42, %43) ({
              ^bb0(%arg23: index):
                %44 = "arith.addi"(%arg23, %27) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %45 = "arith.subi"(%44, %28) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %46 = "memref.load"(%31, %arg22, %45) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                %47 = "arith.subi"(%44, %29) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %48 = "memref.load"(%33, %arg22, %47) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                %49 = "arith.negf"(%46) <{fastmath = #arith.fastmath<none>}> : (f32) -> f32
                %50 = "arith.cmpf"(%49, %7) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %51 = "arith.select"(%50, %49, %7) : (i1, f32, f32) -> f32
                %52 = "arith.cmpf"(%51, %6) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %53 = "arith.select"(%52, %51, %6) : (i1, f32, f32) -> f32
                %54 = "arith.mulf"(%53, %15) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %55 = "arith.addf"(%54, %16) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %56 = "arith.fptosi"(%55) : (f32) -> i32
                %57 = "arith.sitofp"(%56) : (i32) -> f32
                %58 = "arith.cmpf"(%55, %57) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f32, f32) -> i1
                %59 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
                %60 = "arith.subf"(%57, %59) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %61 = "arith.select"(%58, %60, %57) : (i1, f32, f32) -> f32
                %62 = "arith.cmpf"(%61, %5) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %63 = "arith.select"(%62, %61, %5) : (i1, f32, f32) -> f32
                %64 = "arith.cmpf"(%63, %4) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %65 = "arith.select"(%64, %63, %4) : (i1, f32, f32) -> f32
                %66 = "arith.mulf"(%65, %14) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %67 = "arith.addf"(%66, %53) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %68 = "arith.mulf"(%65, %13) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %69 = "arith.addf"(%68, %67) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %70 = "arith.mulf"(%69, %12) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %71 = "arith.addf"(%70, %11) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %72 = "arith.mulf"(%71, %69) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %73 = "arith.addf"(%72, %10) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %74 = "arith.mulf"(%73, %69) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %75 = "arith.addf"(%74, %9) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %76 = "arith.mulf"(%75, %69) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %77 = "arith.addf"(%76, %8) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %78 = "arith.mulf"(%77, %69) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %79 = "arith.addf"(%78, %16) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %80 = "arith.mulf"(%69, %69) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %81 = "arith.mulf"(%79, %80) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %82 = "arith.addf"(%81, %69) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %83 = "arith.addf"(%82, %17) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %84 = "arith.fptosi"(%65) : (f32) -> i32
                %85 = "arith.addi"(%84, %2) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %86 = "arith.shli"(%85, %3) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %87 = "arith.bitcast"(%86) : (i32) -> f32
                %88 = "arith.mulf"(%83, %87) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %89 = "arith.addf"(%88, %17) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %90 = "arith.divf"(%46, %89) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %91 = "arith.mulf"(%90, %48) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %92 = "arith.subi"(%44, %30) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%91, %35, %arg22, %92) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %39 = "air.dma_memcpy_nd"(%arg21, %arg19, %30, %35) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 346>, orbit.storage = "H", orbit.target_copies = array<i64: 347>, orbit.transfer = "l1_to_host", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x11008xf32>, index, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
            %40 = "air.wait_all"(%39) : (!air.async.token) -> !air.async.token
            "scf.yield"(%40) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%26) : (!air.async.token) -> ()
          "memref.dealloc"(%22) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%23) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%24) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "7b5b2efc3d34e961bbade3d44480589c6e24d6992b5e4d50738012eebc6c9b5a", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "5496f9ba1a8fe38eadebd16d72147359c4b0b92c4dc727e23658697b1b25bbb4"} : () -> ()

