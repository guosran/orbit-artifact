"builtin.module"() ({
  "func.func"() <{arg_attrs = [{orbit.name = "arg0", orbit.role = "input"}, {orbit.name = "arg1", orbit.role = "output"}, {orbit.name = "alloc2", orbit.role = "temporary"}], function_type = (memref<64x64xf32>, memref<64x64xf32>, memref<11x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<11x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<64x64xf32>, %arg8: memref<64x64xf32>, %arg9: memref<11x64xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>, %arg12: memref<11x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<64x64xf32>, %arg18: memref<64x64xf32>, %arg19: memref<11x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 1 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 1>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : () -> memref<704xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 5>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : () -> memref<704xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation_offsets_elements = array<i64: 0, 704>, orbit.allocations = array<i64: 2, 4>, orbit.storage_index = 2 : i64, orbit.tile_pool = "public-storage-2"} : () -> memref<1408xf32, 2 : i32>
          "air.wait_all"() {orbit.public_event = 3 : i64, orbit.read_copies = array<i64: 8>, orbit.write_copies = array<i64: 9>} : () -> ()
          %5 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 704>, static_sizes = array<i64: 11, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 2 : i64} : (memref<1408xf32, 2 : i32>) -> memref<11x64xf32, strided<[64, 1], offset: 704>, 2 : i32>
          %6 = "air.dma_memcpy_nd"(%5, %arg19) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 3 : i64, orbit.storage = "alloc2", orbit.transfer = "host_to_l1", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 11, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 11, 64>, static_src_strides = array<i64: 64, 1>} : (memref<11x64xf32, strided<[64, 1], offset: 704>, 2 : i32>, memref<11x64xf32>) -> !air.async.token
          "air.wait_all"(%6) : (!air.async.token) -> ()
          "air.wait_all"() {orbit.public_event = 4 : i64, orbit.read_copies = array<i64: 9>, orbit.write_copies = array<i64: 10>} : () -> ()
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 11, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 1 : i64} : (memref<704xf32, 2 : i32>) -> memref<11x64xf32, strided<[64, 1]>, 2 : i32>
          %8 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 704>, static_sizes = array<i64: 11, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 2 : i64} : (memref<1408xf32, 2 : i32>) -> memref<11x64xf32, strided<[64, 1], offset: 704>, 2 : i32>
          %9 = "arith.constant"() <{value = 0 : index}> : () -> index
          %10 = "arith.constant"() <{value = 1 : index}> : () -> index
          %11 = "arith.constant"() <{value = 64 : index}> : () -> index
          %12 = "arith.constant"() <{value = 64 : index}> : () -> index
          %13 = "arith.constant"() <{value = 0 : index}> : () -> index
          %14 = "arith.constant"() <{value = 11 : index}> : () -> index
          %15 = "arith.constant"() <{value = 0 : index}> : () -> index
          %16 = "arith.constant"() <{value = 11 : index}> : () -> index
          %17 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%15, %16, %17) ({
          ^bb0(%arg20: index):
            %20 = "arith.constant"() <{value = 0 : index}> : () -> index
            %21 = "arith.constant"() <{value = 64 : index}> : () -> index
            %22 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%20, %21, %22) ({
            ^bb0(%arg21: index):
              %23 = "memref.load"(%8, %arg20, %arg21) <{nontemporal = false}> : (memref<11x64xf32, strided<[64, 1], offset: 704>, 2 : i32>, index, index) -> f32
              "memref.store"(%23, %7, %arg20, %arg21) <{nontemporal = false}> : (f32, memref<11x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "air.wait_all"() {orbit.public_event = 5 : i64, orbit.read_copies = array<i64: 10>, orbit.write_copies = array<i64: 11>} : () -> ()
          %18 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 11, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 1 : i64} : (memref<704xf32, 2 : i32>) -> memref<11x64xf32, strided<[64, 1]>, 2 : i32>
          %19 = "air.dma_memcpy_nd"(%6, %arg18, %18) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 5 : i64, orbit.storage = "arg1", orbit.transfer = "l1_to_host", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 11, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 11, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<64x64xf32>, memref<11x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          "air.wait_all"(%19) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<704xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<1408xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<704xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.spatial_owner = "npu.tile.0.3", sym_name = "orbit_public_core_0_3", x_loc = 0 : i32, y_loc = 3 : i32} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<11x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_public_graph_configuration"} : (memref<64x64xf32>, memref<64x64xf32>, memref<11x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {air.preserve_shim_dma_order, operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_public_graph"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<11x64xf32>) -> ()
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.program_graph = "e87bc2e1c7e5eb3225a2a79218f3bba31afbfc91c116b0237ce686cb2b937e74"} : () -> ()

