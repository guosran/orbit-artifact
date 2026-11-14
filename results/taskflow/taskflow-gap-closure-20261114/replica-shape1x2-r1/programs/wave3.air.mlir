"builtin.module"() ({
  "func.func"() <{arg_attrs = [{orbit.name = "arg0", orbit.role = "input"}, {orbit.name = "arg1", orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<64x64xf32>, %arg7: memref<64x64xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<64x64xf32>, %arg9: memref<64x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<64x64xf32>, %arg15: memref<64x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 8 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 8>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : () -> memref<1024xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 9 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 9>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : () -> memref<1024xf32, 2 : i32>
          "air.wait_all"() {orbit.public_event = 9 : i64, orbit.read_copies = array<i64: 3>, orbit.write_copies = array<i64: 13>} : () -> ()
          %4 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 8 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<1024xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %5 = "air.dma_memcpy_nd"(%4, %arg14) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 9 : i64, orbit.storage = "arg0", orbit.transfer = "host_to_l1", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 16, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 48, 0>, static_src_sizes = array<i64: 16, 64>, static_src_strides = array<i64: 64, 1>} : (memref<16x64xf32, strided<[64, 1]>, 2 : i32>, memref<64x64xf32>) -> !air.async.token
          "air.wait_all"(%5) : (!air.async.token) -> ()
          "air.wait_all"() {orbit.public_event = 10 : i64, orbit.read_copies = array<i64: 13>, orbit.write_copies = array<i64: 14>} : () -> ()
          %6 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 8 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<1024xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 9 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 1 : i64} : (memref<1024xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "arith.constant"() <{value = 1 : index}> : () -> index
          %10 = "arith.constant"() <{value = 64 : index}> : () -> index
          %11 = "arith.constant"() <{value = 64 : index}> : () -> index
          %12 = "arith.constant"() <{value = 32 : index}> : () -> index
          %13 = "arith.constant"() <{value = 64 : index}> : () -> index
          %14 = "arith.constant"() <{value = 48 : index}> : () -> index
          %15 = "arith.constant"() <{value = 64 : index}> : () -> index
          %16 = "arith.constant"() <{value = 48 : index}> : () -> index
          %17 = "arith.constant"() <{value = 64 : index}> : () -> index
          %18 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%16, %17, %18) ({
          ^bb0(%arg16: index):
            %21 = "arith.constant"() <{value = 0 : index}> : () -> index
            %22 = "arith.constant"() <{value = 64 : index}> : () -> index
            %23 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%21, %22, %23) ({
            ^bb0(%arg17: index):
              %24 = "arith.constant"() <{value = 48 : index}> : () -> index
              %25 = "arith.subi"(%arg16, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "memref.load"(%6, %25, %arg17) <{nontemporal = false}> : (memref<16x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %27 = "arith.addf"(%26, %26) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %28 = "arith.constant"() <{value = 48 : index}> : () -> index
              %29 = "arith.subi"(%arg16, %28) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%27, %7, %29, %arg17) <{nontemporal = false}> : (f32, memref<16x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "air.wait_all"() {orbit.public_event = 11 : i64, orbit.read_copies = array<i64: 14>, orbit.write_copies = array<i64: 15>} : () -> ()
          %19 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 9 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 1 : i64} : (memref<1024xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %20 = "air.dma_memcpy_nd"(%5, %arg15, %19) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 11 : i64, orbit.storage = "arg1", orbit.transfer = "l1_to_host", static_dst_offsets = array<i64: 48, 0>, static_dst_sizes = array<i64: 16, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 16, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<64x64xf32>, memref<16x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          "air.wait_all"(%20) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.spatial_owner = "npu.tile.3.3", sym_name = "orbit_public_core_3_3", x_loc = 3 : i32, y_loc = 3 : i32} : (index, index, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_public_graph_configuration"} : (memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {air.preserve_shim_dma_order, operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_public_graph"} : (index, index, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.program_graph = "d4e21a0b48d50a35153b2ee05d53d0f6a890844678ab2c063f783aba40a4a4ea"} : () -> ()

