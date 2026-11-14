"builtin.module"() ({
  "func.func"() <{arg_attrs = [{orbit.name = "arg0", orbit.role = "state"}], function_type = (memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0) ({
    ^bb0(%arg1: index, %arg2: index, %arg3: index, %arg4: index, %arg5: memref<64x64xf32>):
      "air.segment"(%arg5) ({
      ^bb0(%arg6: memref<64x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg6) ({
        ^bb0(%arg7: index, %arg8: index, %arg9: index, %arg10: index, %arg11: memref<64x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation_offsets_elements = array<i64: 0, 1024>, orbit.allocations = array<i64: 1, 2>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : () -> memref<2048xf32, 2 : i32>
          "air.wait_all"() {orbit.public_event = 0 : i64, orbit.read_copies = array<i64: 0>, orbit.write_copies = array<i64: 4>} : () -> ()
          %3 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 1 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %4 = "air.dma_memcpy_nd"(%3, %arg11) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 0 : i64, orbit.storage = "arg0", orbit.transfer = "host_to_l1", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 16, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 16, 64>, static_src_strides = array<i64: 64, 1>} : (memref<16x64xf32, strided<[64, 1]>, 2 : i32>, memref<64x64xf32>) -> !air.async.token
          "air.wait_all"(%4) : (!air.async.token) -> ()
          "air.wait_all"() {orbit.public_event = 1 : i64, orbit.read_copies = array<i64: 4>, orbit.write_copies = array<i64: 5>} : () -> ()
          %5 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 1024>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 2 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
          %6 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 1 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %7 = "arith.constant"() <{value = 0 : index}> : () -> index
          %8 = "arith.constant"() <{value = 16 : index}> : () -> index
          %9 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%7, %8, %9) ({
          ^bb0(%arg14: index):
            %26 = "arith.constant"() <{value = 0 : index}> : () -> index
            %27 = "arith.constant"() <{value = 64 : index}> : () -> index
            %28 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%26, %27, %28) ({
            ^bb0(%arg15: index):
              %29 = "memref.load"(%6, %arg14, %arg15) <{nontemporal = false}> : (memref<16x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              "memref.store"(%29, %5, %arg14, %arg15) <{nontemporal = false}> : (f32, memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) {orbit.local_version_staging = 1 : i64} : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {orbit.local_version_staging = 1 : i64} : (index, index, index) -> ()
          %10 = "arith.constant"() <{value = 0 : index}> : () -> index
          %11 = "arith.constant"() <{value = 1 : index}> : () -> index
          %12 = "arith.constant"() <{value = 64 : index}> : () -> index
          %13 = "arith.constant"() <{value = 64 : index}> : () -> index
          %14 = "arith.constant"() <{value = 0 : index}> : () -> index
          %15 = "arith.constant"() <{value = 16 : index}> : () -> index
          %16 = "arith.constant"() <{value = 0 : index}> : () -> index
          %17 = "arith.constant"() <{value = 16 : index}> : () -> index
          %18 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%16, %17, %18) ({
          ^bb0(%arg12: index):
            %21 = "arith.constant"() <{value = 0 : index}> : () -> index
            %22 = "arith.constant"() <{value = 64 : index}> : () -> index
            %23 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%21, %22, %23) ({
            ^bb0(%arg13: index):
              %24 = "memref.load"(%5, %arg12, %arg13) <{nontemporal = false}> : (memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, index, index) -> f32
              %25 = "arith.addf"(%24, %24) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%25, %5, %arg12, %arg13) <{nontemporal = false}> : (f32, memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "air.wait_all"() {orbit.public_event = 2 : i64, orbit.read_copies = array<i64: 5>, orbit.write_copies = array<i64: 12>} : () -> ()
          %19 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 1024>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 2 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
          %20 = "air.dma_memcpy_nd"(%4, %arg11, %19) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 2 : i64, orbit.storage = "arg0", orbit.transfer = "l1_to_host", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 16, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 16, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<64x64xf32>, memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>) -> !air.async.token
          "air.wait_all"(%20) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<2048xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 1>, orbit.spatial_owner = "npu.tile.0.3", sym_name = "orbit_public_core_0_3", x_loc = 0 : i32, y_loc = 3 : i32} : (index, index, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 1>, sym_name = "orbit_public_graph_configuration"} : (memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {air.preserve_shim_dma_order, operandSegmentSizes = array<i32: 0, 2, 1>, sym_name = "orbit_public_graph"} : (index, index, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.program_graph = "9624db75476676b8912a474fde3f821bb03ebd74ad85621d079e3aad1510c3b5"} : () -> ()

