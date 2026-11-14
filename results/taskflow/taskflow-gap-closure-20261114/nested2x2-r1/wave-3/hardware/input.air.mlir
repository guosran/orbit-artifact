"builtin.module"() ({
  "func.func"() <{arg_attrs = [{orbit.name = "arg0", orbit.role = "input"}, {orbit.name = "arg1", orbit.role = "output"}], function_type = (memref<32x32xf32>, memref<32x32xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<32x32xf32>, %arg1: memref<32x32xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<32x32xf32>, %arg7: memref<32x32xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<32x32xf32>, %arg9: memref<32x32xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<32x32xf32>, %arg15: memref<32x32xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 7 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 7>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : () -> memref<256xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 8 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 8>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : () -> memref<256xf32, 2 : i32>
          "air.wait_all"() {orbit.public_event = 9 : i64, orbit.read_copies = array<i64: 3>, orbit.write_copies = array<i64: 10>} : () -> ()
          %4 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 16, 1>}> {orbit.allocation = 7 : i64, orbit.logical_offsets = array<i64: 16, 16>, orbit.logical_sizes = array<i64: 16, 16>, orbit.storage_index = 0 : i64} : (memref<256xf32, 2 : i32>) -> memref<16x16xf32, strided<[16, 1]>, 2 : i32>
          %5 = "air.dma_memcpy_nd"(%4, %arg14) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 9 : i64, orbit.storage = "arg0", orbit.transfer = "host_to_l1", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 16, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 16, 16>, static_src_sizes = array<i64: 16, 16>, static_src_strides = array<i64: 32, 1>} : (memref<16x16xf32, strided<[16, 1]>, 2 : i32>, memref<32x32xf32>) -> !air.async.token
          "air.wait_all"(%5) : (!air.async.token) -> ()
          "air.wait_all"() {orbit.public_event = 10 : i64, orbit.read_copies = array<i64: 10>, orbit.write_copies = array<i64: 11>} : () -> ()
          %6 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 16, 1>}> {orbit.allocation = 7 : i64, orbit.logical_offsets = array<i64: 16, 16>, orbit.logical_sizes = array<i64: 16, 16>, orbit.storage_index = 0 : i64} : (memref<256xf32, 2 : i32>) -> memref<16x16xf32, strided<[16, 1]>, 2 : i32>
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 16, 1>}> {orbit.allocation = 8 : i64, orbit.logical_offsets = array<i64: 16, 16>, orbit.logical_sizes = array<i64: 16, 16>, orbit.storage_index = 1 : i64} : (memref<256xf32, 2 : i32>) -> memref<16x16xf32, strided<[16, 1]>, 2 : i32>
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "arith.constant"() <{value = 1 : index}> : () -> index
          %10 = "arith.constant"() <{value = 32 : index}> : () -> index
          %11 = "arith.constant"() <{value = 32 : index}> : () -> index
          %12 = "arith.constant"() <{value = 16 : index}> : () -> index
          %13 = "arith.constant"() <{value = 32 : index}> : () -> index
          %14 = "arith.constant"() <{value = 16 : index}> : () -> index
          %15 = "arith.constant"() <{value = 32 : index}> : () -> index
          %16 = "arith.constant"() <{value = 16 : index}> : () -> index
          %17 = "arith.constant"() <{value = 32 : index}> : () -> index
          %18 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%16, %17, %18) ({
          ^bb0(%arg16: index):
            %21 = "arith.constant"() <{value = 16 : index}> : () -> index
            %22 = "arith.constant"() <{value = 32 : index}> : () -> index
            %23 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%21, %22, %23) ({
            ^bb0(%arg17: index):
              %24 = "arith.constant"() <{value = 16 : index}> : () -> index
              %25 = "arith.subi"(%arg16, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "arith.constant"() <{value = 16 : index}> : () -> index
              %27 = "arith.subi"(%arg17, %26) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %28 = "memref.load"(%6, %25, %27) <{nontemporal = false}> : (memref<16x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
              %29 = "arith.addf"(%28, %28) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              %30 = "arith.constant"() <{value = 16 : index}> : () -> index
              %31 = "arith.subi"(%arg16, %30) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %32 = "arith.constant"() <{value = 16 : index}> : () -> index
              %33 = "arith.subi"(%arg17, %32) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              "memref.store"(%29, %7, %31, %33) <{nontemporal = false}> : (f32, memref<16x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "air.wait_all"() {orbit.public_event = 11 : i64, orbit.read_copies = array<i64: 11>, orbit.write_copies = array<i64: 15>} : () -> ()
          %19 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 16, 1>}> {orbit.allocation = 8 : i64, orbit.logical_offsets = array<i64: 16, 16>, orbit.logical_sizes = array<i64: 16, 16>, orbit.storage_index = 1 : i64} : (memref<256xf32, 2 : i32>) -> memref<16x16xf32, strided<[16, 1]>, 2 : i32>
          %20 = "air.dma_memcpy_nd"(%5, %arg15, %19) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 11 : i64, orbit.storage = "arg1", orbit.transfer = "l1_to_host", static_dst_offsets = array<i64: 16, 16>, static_dst_sizes = array<i64: 16, 16>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 16, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<32x32xf32>, memref<16x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
          "air.wait_all"(%20) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.spatial_owner = "npu.tile.1.4", sym_name = "orbit_public_core_1_4", x_loc = 1 : i32, y_loc = 4 : i32} : (index, index, memref<32x32xf32>, memref<32x32xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_public_graph_configuration"} : (memref<32x32xf32>, memref<32x32xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {air.preserve_shim_dma_order, operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_public_graph"} : (index, index, memref<32x32xf32>, memref<32x32xf32>) -> ()
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.program_graph = "1ea0e131e5bec4de5ea1c7c47fa218c8fafd5502bab24ee1e486caf44639bafa"} : () -> ()

