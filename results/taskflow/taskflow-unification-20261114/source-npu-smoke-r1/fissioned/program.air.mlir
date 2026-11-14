"builtin.module"() ({
  "func.func"() <{function_type = (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<64x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg26: index, %arg27: index, %arg28: index, %arg29: index, %arg30: memref<64x64xf32>, %arg31: memref<64x64xf32>, %arg32: memref<64x64xf32>):
      "air.segment"(%arg30, %arg31, %arg32) ({
      ^bb0(%arg33: memref<64x64xf32>, %arg34: memref<64x64xf32>, %arg35: memref<64x64xf32>):
        %56 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%56, %56, %arg33, %arg34, %arg35) ({
        ^bb0(%arg36: index, %arg37: index, %arg38: index, %arg39: index, %arg40: memref<64x64xf32>, %arg41: memref<64x64xf32>, %arg42: memref<64x64xf32>):
          %57 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %58 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1024xf32, 2 : i32>
          %59 = "air.wait_all"() : () -> !air.async.token
          %60 = "arith.constant"() <{value = 0 : index}> : () -> index
          %61 = "arith.constant"() <{value = 2 : index}> : () -> index
          %62 = "arith.constant"() <{value = 1 : index}> : () -> index
          %63 = "scf.for"(%60, %61, %62, %59) ({
          ^bb0(%arg43: index, %arg44: !air.async.token):
            %64 = "arith.constant"() <{value = 32 : index}> : () -> index
            %65 = "arith.muli"(%arg43, %64) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %66 = "arith.constant"() <{value = 32 : index}> : () -> index
            %67 = "arith.muli"(%arg43, %66) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %68 = "arith.constant"() <{value = 32 : index}> : () -> index
            %69 = "arith.muli"(%arg43, %68) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %70 = "arith.constant"() <{value = 0 : index}> : () -> index
            %71 = "arith.constant"() <{value = 2 : index}> : () -> index
            %72 = "arith.constant"() <{value = 1 : index}> : () -> index
            %73 = "scf.for"(%70, %71, %72, %arg44) ({
            ^bb0(%arg45: index, %arg46: !air.async.token):
              %74 = "arith.constant"() <{value = 32 : index}> : () -> index
              %75 = "arith.muli"(%arg45, %74) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %76 = "arith.constant"() <{value = 32 : index}> : () -> index
              %77 = "arith.muli"(%arg45, %76) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %78 = "arith.constant"() <{value = 32 : index}> : () -> index
              %79 = "arith.muli"(%arg45, %78) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %80 = "memref.reinterpret_cast"(%57) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %81 = "arith.constant"() <{value = 0 : index}> : () -> index
              %82 = "arith.addi"(%81, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %83 = "arith.constant"() <{value = 0 : index}> : () -> index
              %84 = "arith.addi"(%83, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %85 = "air.dma_memcpy_nd"(%arg46, %80, %arg40, %82, %84) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 4>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index, index) -> !air.async.token
              %86 = "memref.reinterpret_cast"(%58) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              "air.wait_all"(%arg46, %85) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 4>, orbit.source_instance = 0 : i64, orbit.task = "double.split.0.fuse.double.split.1", orbit.write_copies = array<i64: 5>} : (!air.async.token, !air.async.token) -> ()
              %87 = "arith.constant"() <{value = 0 : index}> : () -> index
              %88 = "arith.constant"() <{value = 1 : index}> : () -> index
              %89 = "arith.constant"() <{value = 64 : index}> : () -> index
              %90 = "arith.constant"() <{value = 0 : index}> : () -> index
              %91 = "arith.constant"() <{value = 1 : index}> : () -> index
              %92 = "arith.constant"() <{value = 64 : index}> : () -> index
              %93 = "arith.constant"() <{value = 0 : index}> : () -> index
              %94 = "arith.constant"() <{value = 32 : index}> : () -> index
              %95 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%93, %94, %95) ({
              ^bb0(%arg47: index):
                %103 = "arith.addi"(%arg47, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %104 = "arith.constant"() <{value = 0 : index}> : () -> index
                %105 = "arith.constant"() <{value = 32 : index}> : () -> index
                %106 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%104, %105, %106) ({
                ^bb0(%arg48: index):
                  %107 = "arith.addi"(%arg48, %75) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %108 = "arith.subi"(%103, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %109 = "arith.subi"(%107, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %110 = "memref.load"(%80, %108, %109) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %111 = "arith.addf"(%110, %110) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %112 = "arith.subi"(%103, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %113 = "arith.subi"(%107, %79) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%111, %86, %112, %113) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %96 = "memref.reinterpret_cast"(%58) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %97 = "arith.constant"() <{value = 0 : index}> : () -> index
              %98 = "arith.addi"(%97, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %99 = "arith.constant"() <{value = 0 : index}> : () -> index
              %100 = "arith.addi"(%99, %79) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %101 = "air.dma_memcpy_nd"(%arg46, %arg42, %98, %100, %96) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "T", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %102 = "air.wait_all"(%101) : (!air.async.token) -> !air.async.token
              "scf.yield"(%102) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%73) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%63) : (!air.async.token) -> ()
          "memref.dealloc"(%57) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%58) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<64x64xf32>, %arg8: memref<64x64xf32>, %arg9: memref<64x64xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>, %arg12: memref<64x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<64x64xf32>, %arg18: memref<64x64xf32>, %arg19: memref<64x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 6 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1024xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 2 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "scf.for"(%5, %6, %7, %4) ({
          ^bb0(%arg20: index, %arg21: !air.async.token):
            %9 = "arith.constant"() <{value = 32 : index}> : () -> index
            %10 = "arith.muli"(%arg20, %9) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %11 = "arith.constant"() <{value = 32 : index}> : () -> index
            %12 = "arith.muli"(%arg20, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 32 : index}> : () -> index
            %14 = "arith.muli"(%arg20, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 0 : index}> : () -> index
            %16 = "arith.constant"() <{value = 2 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg21) ({
            ^bb0(%arg22: index, %arg23: !air.async.token):
              %19 = "arith.constant"() <{value = 32 : index}> : () -> index
              %20 = "arith.muli"(%arg22, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 32 : index}> : () -> index
              %22 = "arith.muli"(%arg22, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 32 : index}> : () -> index
              %24 = "arith.muli"(%arg22, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %26 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0 : index}> : () -> index
              %28 = "arith.addi"(%27, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %29 = "arith.constant"() <{value = 0 : index}> : () -> index
              %30 = "arith.addi"(%29, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "air.dma_memcpy_nd"(%arg23, %26, %arg19, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 6>, orbit.storage = "T", orbit.target_copies = array<i64: 16>, orbit.transfer = "host_to_l1", orbit.transfer_event = 12 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%arg23, %31) {orbit.computation_event = 13 : i64, orbit.phase = 4 : i64, orbit.phase_dependencies = array<i64: 3>, orbit.public_dependencies = array<i64: 11, 12>, orbit.read_copies = array<i64: 16>, orbit.source_instance = 4 : i64, orbit.task = "square", orbit.write_copies = array<i64: 17>} : (!air.async.token, !air.async.token) -> ()
              %32 = "arith.constant"() <{value = 0 : index}> : () -> index
              %33 = "arith.constant"() <{value = 1 : index}> : () -> index
              %34 = "arith.constant"() <{value = 64 : index}> : () -> index
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.constant"() <{value = 32 : index}> : () -> index
              %37 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%35, %36, %37) ({
              ^bb0(%arg24: index):
                %45 = "arith.addi"(%arg24, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %46 = "arith.constant"() <{value = 0 : index}> : () -> index
                %47 = "arith.constant"() <{value = 32 : index}> : () -> index
                %48 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%46, %47, %48) ({
                ^bb0(%arg25: index):
                  %49 = "arith.addi"(%arg25, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %50 = "arith.subi"(%45, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %51 = "arith.subi"(%49, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "memref.load"(%26, %50, %51) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %53 = "arith.mulf"(%52, %52) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %54 = "arith.subi"(%45, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %55 = "arith.subi"(%49, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%53, %25, %54, %55) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %38 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %39 = "arith.constant"() <{value = 0 : index}> : () -> index
              %40 = "arith.addi"(%39, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %41 = "arith.constant"() <{value = 0 : index}> : () -> index
              %42 = "arith.addi"(%41, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %43 = "air.dma_memcpy_nd"(%arg23, %arg18, %40, %42, %38) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "Y", orbit.target_copies = array<i64: 18>, orbit.transfer = "l1_to_host", orbit.transfer_event = 14 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %44 = "air.wait_all"(%43) : (!air.async.token) -> !air.async.token
              "scf.yield"(%44) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.execution_group = 1 : i64, orbit.group_members = array<i64: 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd_4"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_segment_4"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_launch_4"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_realization = "phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "common execution groups and explicit copy/release dependencies; source compute order preserved; conservative timing reservations are separate from runtime arbitration", orbit.mapping_plan = "3d731ad0bb0d3ad5a9392457830e8a5d5485f557af8736f2de009796061e662a", orbit.program_graph = "ef44aa1fef4d1c7718eb161e01d89712f3ff4d87d888ab695f7c7bee7630a90f", orbit.source_fingerprint = "b17fa0f5820838d945936434006e3510f45f6ba93db49555d72b54e7a4e752a0"} : () -> ()

