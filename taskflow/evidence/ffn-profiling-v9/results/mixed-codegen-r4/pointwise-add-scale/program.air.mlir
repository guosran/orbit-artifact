#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>) -> (), sym_name = "add_scale"}> ({
  ^bb0(%arg0: memref<4x16xf32>, %arg1: memref<4x16xf32>, %arg2: memref<4x16xf32>, %arg3: memref<4x16xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg30: index, %arg31: index, %arg32: index, %arg33: index, %arg34: memref<4x16xf32>, %arg35: memref<4x16xf32>, %arg36: memref<4x16xf32>, %arg37: memref<4x16xf32>):
      "air.segment"(%arg34, %arg35, %arg36, %arg37) ({
      ^bb0(%arg38: memref<4x16xf32>, %arg39: memref<4x16xf32>, %arg40: memref<4x16xf32>, %arg41: memref<4x16xf32>):
        %89 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%89, %89, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<4x16xf32>, %arg47: memref<4x16xf32>, %arg48: memref<4x16xf32>, %arg49: memref<4x16xf32>):
          %90 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.2.8.loops.2.8"} : () -> memref<16xf32, 2 : i32>
          %91 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.2.8.loops.2.8"} : () -> memref<16xf32, 2 : i32>
          %92 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<16xf32, 2 : i32>
          %93 = "air.wait_all"() : () -> !air.async.token
          %94 = "arith.constant"() <{value = 0 : index}> : () -> index
          %95 = "arith.constant"() <{value = 2 : index}> : () -> index
          %96 = "arith.constant"() <{value = 1 : index}> : () -> index
          %97 = "scf.for"(%94, %95, %96, %93) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %98 = "arith.constant"() <{value = 2 : index}> : () -> index
            %99 = "arith.muli"(%arg50, %98) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %100 = "arith.constant"() <{value = 2 : index}> : () -> index
            %101 = "arith.muli"(%arg50, %100) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %102 = "arith.constant"() <{value = 2 : index}> : () -> index
            %103 = "arith.muli"(%arg50, %102) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %104 = "arith.constant"() <{value = 2 : index}> : () -> index
            %105 = "arith.muli"(%arg50, %104) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %106 = "arith.constant"() <{value = 0 : index}> : () -> index
            %107 = "arith.constant"() <{value = 2 : index}> : () -> index
            %108 = "arith.constant"() <{value = 1 : index}> : () -> index
            %109 = "scf.for"(%106, %107, %108, %arg51) ({
            ^bb0(%arg52: index, %arg53: !air.async.token):
              %110 = "arith.constant"() <{value = 8 : index}> : () -> index
              %111 = "arith.muli"(%arg52, %110) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %112 = "arith.constant"() <{value = 8 : index}> : () -> index
              %113 = "arith.muli"(%arg52, %112) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %114 = "arith.constant"() <{value = 8 : index}> : () -> index
              %115 = "arith.muli"(%arg52, %114) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %116 = "arith.constant"() <{value = 8 : index}> : () -> index
              %117 = "arith.muli"(%arg52, %116) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %118 = "memref.reinterpret_cast"(%90) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2, 8>, static_strides = array<i64: 8, 1>}> {orbit.phase = 0 : i64, orbit.storage = "A"} : (memref<16xf32, 2 : i32>) -> memref<2x8xf32, strided<[8, 1]>, 2 : i32>
              %119 = "arith.constant"() <{value = 0 : index}> : () -> index
              %120 = "arith.addi"(%119, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %121 = "arith.constant"() <{value = 0 : index}> : () -> index
              %122 = "arith.addi"(%121, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %123 = "air.dma_memcpy_nd"(%arg53, %118, %arg46, %120, %122) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 8>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 2, 8>, static_dst_strides = array<i64: 8, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 2, 8>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<2x8xf32, strided<[8, 1]>, 2 : i32>, memref<4x16xf32>, index, index) -> !air.async.token
              %124 = "memref.reinterpret_cast"(%91) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2, 8>, static_strides = array<i64: 8, 1>}> {orbit.phase = 0 : i64, orbit.storage = "B"} : (memref<16xf32, 2 : i32>) -> memref<2x8xf32, strided<[8, 1]>, 2 : i32>
              %125 = "arith.constant"() <{value = 0 : index}> : () -> index
              %126 = "arith.addi"(%125, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %127 = "arith.constant"() <{value = 0 : index}> : () -> index
              %128 = "arith.addi"(%127, %115) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %129 = "air.dma_memcpy_nd"(%arg53, %124, %arg47, %126, %128) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "B", orbit.target_copies = array<i64: 9>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 2, 8>, static_dst_strides = array<i64: 8, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 2, 8>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<2x8xf32, strided<[8, 1]>, 2 : i32>, memref<4x16xf32>, index, index) -> !air.async.token
              %130 = "memref.reinterpret_cast"(%92) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2, 8>, static_strides = array<i64: 8, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<16xf32, 2 : i32>) -> memref<2x8xf32, strided<[8, 1]>, 2 : i32>
              "air.wait_all"(%123, %129) {orbit.computation_event = 2 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.read_copies = array<i64: 8, 9>, orbit.task = "add", orbit.write_copies = array<i64: 10>} : (!air.async.token, !air.async.token) -> ()
              %131 = "memref.cast"(%118) : (memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> memref<2x8xf32, 2 : i32>
              %132 = "memref.cast"(%124) : (memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> memref<2x8xf32, 2 : i32>
              %133 = "memref.cast"(%130) : (memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> memref<2x8xf32, 2 : i32>
              %134 = "arith.constant"() <{value = 0 : index}> : () -> index
              %135 = "arith.constant"() <{value = 2 : index}> : () -> index
              %136 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%134, %135, %136) ({
              ^bb0(%arg54: index):
                %143 = "arith.addi"(%arg54, %99) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %144 = "arith.constant"() <{value = 0 : index}> : () -> index
                %145 = "arith.constant"() <{value = 8 : index}> : () -> index
                %146 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%144, %145, %146) ({
                ^bb0(%arg55: index):
                  %147 = "arith.addi"(%arg55, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %148 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                  %149 = "arith.subi"(%143, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %150 = "arith.subi"(%147, %113) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %151 = "vector.transfer_read"(%131, %149, %150, %148) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<2x8xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %152 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                  %153 = "arith.subi"(%143, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %154 = "arith.subi"(%147, %115) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %155 = "vector.transfer_read"(%132, %153, %154, %152) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<2x8xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %156 = "arith.addf"(%151, %155) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                  %157 = "arith.subi"(%143, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %158 = "arith.subi"(%147, %117) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%156, %133, %157, %158) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<2x8xf32, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %137 = "arith.constant"() <{value = 0 : index}> : () -> index
              %138 = "arith.addi"(%137, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %139 = "arith.constant"() <{value = 0 : index}> : () -> index
              %140 = "arith.addi"(%139, %117) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %141 = "air.dma_memcpy_nd"(%arg53, %arg49, %138, %140, %130) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 10>, orbit.storage = "T", orbit.target_copies = array<i64: 11>, orbit.transfer = "l1_to_host", orbit.transfer_event = 3 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 2, 8>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 2, 8>, static_src_strides = array<i64: 8, 1>} : (!air.async.token, memref<4x16xf32>, index, index, memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> !air.async.token
              %142 = "air.wait_all"(%141) : (!air.async.token) -> !air.async.token
              "scf.yield"(%142) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%109) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%97) : (!air.async.token) -> ()
          "memref.dealloc"(%90) : (memref<16xf32, 2 : i32>) -> ()
          "memref.dealloc"(%91) : (memref<16xf32, 2 : i32>) -> ()
          "memref.dealloc"(%92) : (memref<16xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<4x16xf32>, %arg9: memref<4x16xf32>, %arg10: memref<4x16xf32>, %arg11: memref<4x16xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<4x16xf32>, %arg13: memref<4x16xf32>, %arg14: memref<4x16xf32>, %arg15: memref<4x16xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<4x16xf32>, %arg21: memref<4x16xf32>, %arg22: memref<4x16xf32>, %arg23: memref<4x16xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<16xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.2.8.loops.2.8"} : () -> memref<16xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 2 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "scf.for"(%5, %6, %7, %4) ({
          ^bb0(%arg24: index, %arg25: !air.async.token):
            %9 = "arith.constant"() <{value = 2 : index}> : () -> index
            %10 = "arith.muli"(%arg24, %9) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %11 = "arith.constant"() <{value = 2 : index}> : () -> index
            %12 = "arith.muli"(%arg24, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 2 : index}> : () -> index
            %14 = "arith.muli"(%arg24, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 0 : index}> : () -> index
            %16 = "arith.constant"() <{value = 2 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg25) ({
            ^bb0(%arg26: index, %arg27: !air.async.token):
              %19 = "arith.constant"() <{value = 8 : index}> : () -> index
              %20 = "arith.muli"(%arg26, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 8 : index}> : () -> index
              %22 = "arith.muli"(%arg26, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 8 : index}> : () -> index
              %24 = "arith.muli"(%arg26, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2, 8>, static_strides = array<i64: 8, 1>}> {orbit.phase = 4 : i64, orbit.storage = "C"} : (memref<16xf32, 2 : i32>) -> memref<2x8xf32, strided<[8, 1]>, 2 : i32>
              %26 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 2, 8>, static_strides = array<i64: 8, 1>}> {orbit.phase = 4 : i64, orbit.storage = "T"} : (memref<16xf32, 2 : i32>) -> memref<2x8xf32, strided<[8, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0 : index}> : () -> index
              %28 = "arith.addi"(%27, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %29 = "arith.constant"() <{value = 0 : index}> : () -> index
              %30 = "arith.addi"(%29, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "air.dma_memcpy_nd"(%arg27, %26, %arg23, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 11>, orbit.storage = "T", orbit.target_copies = array<i64: 24>, orbit.transfer = "host_to_l1", orbit.transfer_event = 16 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 2, 8>, static_dst_strides = array<i64: 8, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 2, 8>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<2x8xf32, strided<[8, 1]>, 2 : i32>, memref<4x16xf32>, index, index) -> !air.async.token
              "air.wait_all"(%31) {orbit.computation_event = 17 : i64, orbit.phase = 4 : i64, orbit.phase_dependencies = array<i64: 3>, orbit.read_copies = array<i64: 24>, orbit.task = "scale", orbit.write_copies = array<i64: 25>} : (!air.async.token) -> ()
              %32 = "memref.cast"(%25) : (memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> memref<2x8xf32, 2 : i32>
              %33 = "memref.cast"(%26) : (memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> memref<2x8xf32, 2 : i32>
              %34 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.constant"() <{value = 2 : index}> : () -> index
              %37 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%35, %36, %37) ({
              ^bb0(%arg28: index):
                %44 = "arith.addi"(%arg28, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %45 = "arith.constant"() <{value = 0 : index}> : () -> index
                %46 = "arith.constant"() <{value = 8 : index}> : () -> index
                %47 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%45, %46, %47) ({
                ^bb0(%arg29: index):
                  %48 = "arith.addi"(%arg29, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %49 = "arith.constant"() <{value = dense<2.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                  %50 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                  %51 = "arith.subi"(%44, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "arith.subi"(%48, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %53 = "vector.transfer_read"(%33, %51, %52, %50) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<2x8xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %54 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                  %55 = "vector.extract"(%53) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %56 = "vector.extract"(%49) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %57 = "func.call"(%55, %56) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %58 = "vector.insert"(%57, %54) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %59 = "vector.extract"(%53) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %60 = "vector.extract"(%49) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %61 = "func.call"(%59, %60) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %62 = "vector.insert"(%61, %58) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %63 = "vector.extract"(%53) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %64 = "vector.extract"(%49) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %65 = "func.call"(%63, %64) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %66 = "vector.insert"(%65, %62) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %67 = "vector.extract"(%53) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %68 = "vector.extract"(%49) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %69 = "func.call"(%67, %68) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %70 = "vector.insert"(%69, %66) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %71 = "vector.extract"(%53) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %72 = "vector.extract"(%49) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %73 = "func.call"(%71, %72) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %74 = "vector.insert"(%73, %70) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %75 = "vector.extract"(%53) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %76 = "vector.extract"(%49) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %77 = "func.call"(%75, %76) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %78 = "vector.insert"(%77, %74) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %79 = "vector.extract"(%53) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %80 = "vector.extract"(%49) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %81 = "func.call"(%79, %80) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %82 = "vector.insert"(%81, %78) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %83 = "vector.extract"(%53) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %84 = "vector.extract"(%49) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %85 = "func.call"(%83, %84) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %86 = "vector.insert"(%85, %82) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %87 = "arith.subi"(%44, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %88 = "arith.subi"(%48, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%86, %32, %87, %88) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<2x8xf32, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %38 = "arith.constant"() <{value = 0 : index}> : () -> index
              %39 = "arith.addi"(%38, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %40 = "arith.constant"() <{value = 0 : index}> : () -> index
              %41 = "arith.addi"(%40, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %42 = "air.dma_memcpy_nd"(%arg27, %arg22, %39, %41, %25) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 25>, orbit.storage = "C", orbit.target_copies = array<i64: 26>, orbit.transfer = "l1_to_host", orbit.transfer_event = 18 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 2, 8>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 2, 8>, static_src_strides = array<i64: 8, 1>} : (!air.async.token, memref<4x16xf32>, index, index, memref<2x8xf32, strided<[8, 1]>, 2 : i32>) -> !air.async.token
              %43 = "air.wait_all"(%42) : (!air.async.token) -> !air.async.token
              "scf.yield"(%43) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<16xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<16xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_4"} : (index, index, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_4"} : (memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_4"} : (index, index, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>, memref<4x16xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "a26ee2db34d5a354456b4a4966795248a0c1d2d9f9daaf77a43fbe936b05be78", orbit.source_fingerprint = "db22dcae144be55b6589d1046909dcedc776cbf19c251e09a31a169a923cbb53"} : () -> ()

