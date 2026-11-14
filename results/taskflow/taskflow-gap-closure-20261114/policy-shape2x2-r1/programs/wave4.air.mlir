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
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 6 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 6>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : () -> memref<512xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 7 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 7>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : () -> memref<512xf32, 2 : i32>
          "air.wait_all"() {orbit.public_event = 12 : i64, orbit.read_copies = array<i64: 4>, orbit.write_copies = array<i64: 20>} : () -> ()
          %4 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 6 : i64, orbit.logical_offsets = array<i64: 32, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 0 : i64} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %5 = "air.dma_memcpy_nd"(%4, %arg14) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 12 : i64, orbit.storage = "arg0", orbit.transfer = "host_to_l1", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 32, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<64x64xf32>) -> !air.async.token
          "air.wait_all"(%5) : (!air.async.token) -> ()
          "air.wait_all"() {orbit.public_event = 13 : i64, orbit.read_copies = array<i64: 20>, orbit.write_copies = array<i64: 21>} : () -> ()
          %6 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 6 : i64, orbit.logical_offsets = array<i64: 32, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 0 : i64} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 7 : i64, orbit.logical_offsets = array<i64: 32, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 1 : i64} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "arith.constant"() <{value = 1 : index}> : () -> index
          %10 = "arith.constant"() <{value = 64 : index}> : () -> index
          %11 = "arith.constant"() <{value = 64 : index}> : () -> index
          %12 = "arith.constant"() <{value = 32 : index}> : () -> index
          %13 = "arith.constant"() <{value = 48 : index}> : () -> index
          %14 = "arith.constant"() <{value = 32 : index}> : () -> index
          %15 = "arith.constant"() <{value = 40 : index}> : () -> index
          %16 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%14, %15, %16) ({
          ^bb0(%arg16: index):
            %19 = "arith.constant"() <{value = 0 : index}> : () -> index
            %20 = "arith.constant"() <{value = 64 : index}> : () -> index
            %21 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%19, %20, %21) ({
            ^bb0(%arg17: index):
              %22 = "arith.constant"() <{value = 32 : index}> : () -> index
              %23 = "arith.subi"(%arg16, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %24 = "memref.load"(%6, %23, %arg17) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %25 = "arith.addf"(%24, %24) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %26 = "arith.constant"() <{value = 32 : index}> : () -> index
              %27 = "arith.subi"(%arg16, %26) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%25, %7, %27, %arg17) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "air.wait_all"() {orbit.public_event = 14 : i64, orbit.read_copies = array<i64: 21>, orbit.write_copies = array<i64: 22>} : () -> ()
          %17 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 7 : i64, orbit.logical_offsets = array<i64: 32, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 1 : i64} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %18 = "air.dma_memcpy_nd"(%5, %arg15, %17) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 14 : i64, orbit.storage = "arg1", orbit.transfer = "l1_to_host", static_dst_offsets = array<i64: 32, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<64x64xf32>, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          "air.wait_all"(%18) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.spatial_owner = "npu.tile.0.4", sym_name = "orbit_public_core_0_4", x_loc = 0 : i32, y_loc = 4 : i32} : (index, index, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_public_graph_configuration"} : (memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {air.preserve_shim_dma_order, operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_public_graph"} : (index, index, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.program_graph = "0c949f6a8f8fb604f1763fd00dc7c3fc7533c049cea93f90e62adb6c1b53f303"} : () -> ()

