"builtin.module"() ({
  "func.func"() <{arg_attrs = [{orbit.name = "arg0", orbit.role = "input"}, {orbit.name = "arg1", orbit.role = "output"}, {orbit.name = "alloc2", orbit.role = "temporary"}], function_type = (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<64x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<64x64xf32>, %arg8: memref<64x64xf32>, %arg9: memref<64x64xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>, %arg12: memref<64x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<64x64xf32>, %arg18: memref<64x64xf32>, %arg19: memref<64x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 8 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 8>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : () -> memref<1024xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 18 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 18>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : () -> memref<1024xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation_offsets_elements = array<i64: 0, 1024>, orbit.allocations = array<i64: 9, 17>, orbit.storage_index = 2 : i64, orbit.tile_pool = "public-storage-2"} : () -> memref<2048xf32, 2 : i32>
          "air.wait_all"() {orbit.public_event = 12 : i64, orbit.read_copies = array<i64: 15>, orbit.write_copies = array<i64: 25>} : () -> ()
          %5 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 1024>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 17 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 2 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
          %6 = "air.dma_memcpy_nd"(%5, %arg19) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 12 : i64, orbit.storage = "alloc2", orbit.transfer = "host_to_l1", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 16, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 48, 0>, static_src_sizes = array<i64: 16, 64>, static_src_strides = array<i64: 64, 1>} : (memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, memref<64x64xf32>) -> !air.async.token
          "air.wait_all"(%6) : (!air.async.token) -> ()
          "air.wait_all"() {orbit.public_event = 13 : i64, orbit.read_copies = array<i64: 25>, orbit.write_copies = array<i64: 26>} : () -> ()
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 18 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 1 : i64} : (memref<1024xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %8 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 1024>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 17 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 2 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
          %9 = "arith.constant"() <{value = 0 : index}> : () -> index
          %10 = "arith.constant"() <{value = 1 : index}> : () -> index
          %11 = "arith.constant"() <{value = 64 : index}> : () -> index
          %12 = "arith.constant"() <{value = 64 : index}> : () -> index
          %13 = "arith.constant"() <{value = 48 : index}> : () -> index
          %14 = "arith.constant"() <{value = 64 : index}> : () -> index
          %15 = "arith.constant"() <{value = 48 : index}> : () -> index
          %16 = "arith.constant"() <{value = 64 : index}> : () -> index
          %17 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%15, %16, %17) ({
          ^bb0(%arg20: index):
            %20 = "arith.constant"() <{value = 0 : index}> : () -> index
            %21 = "arith.constant"() <{value = 64 : index}> : () -> index
            %22 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%20, %21, %22) ({
            ^bb0(%arg21: index):
              %23 = "arith.constant"() <{value = 48 : index}> : () -> index
              %24 = "arith.subi"(%arg20, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.load"(%8, %24, %arg21) <{nontemporal = false}> : (memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, index, index) -> f32
              %26 = "arith.constant"() <{value = 48 : index}> : () -> index
              %27 = "arith.subi"(%arg20, %26) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%25, %7, %27, %arg21) <{nontemporal = false}> : (f32, memref<16x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "air.wait_all"() {orbit.public_event = 14 : i64, orbit.read_copies = array<i64: 26>, orbit.write_copies = array<i64: 27>} : () -> ()
          %18 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 18 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 1 : i64} : (memref<1024xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %19 = "air.dma_memcpy_nd"(%6, %arg18, %18) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 14 : i64, orbit.storage = "arg1", orbit.transfer = "l1_to_host", static_dst_offsets = array<i64: 48, 0>, static_dst_sizes = array<i64: 16, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 16, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<64x64xf32>, memref<16x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          "air.wait_all"(%19) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.spatial_owner = "npu.tile.1.4", sym_name = "orbit_public_core_1_4", x_loc = 1 : i32, y_loc = 4 : i32} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_public_graph_configuration"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {air.preserve_shim_dma_order, operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_public_graph"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.program_graph = "3b62fd47edb2a6130afda526396e196deab0aa9ace201343f4aa7e2b987b74e0"} : () -> ()

