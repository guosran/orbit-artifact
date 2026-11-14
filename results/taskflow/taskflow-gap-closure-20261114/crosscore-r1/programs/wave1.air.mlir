"builtin.module"() ({
  "func.func"() <{arg_attrs = [{orbit.name = "arg0", orbit.role = "input"}, {orbit.name = "arg1", orbit.role = "output"}, {orbit.name = "alloc2", orbit.role = "temporary"}], function_type = (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<32x32xf32>, %arg1: memref<32x32xf32>, %arg2: memref<32x32xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2) ({
    ^bb0(%arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: memref<32x32xf32>, %arg8: memref<32x32xf32>, %arg9: memref<32x32xf32>):
      "air.segment"(%arg7, %arg8, %arg9) ({
      ^bb0(%arg10: memref<32x32xf32>, %arg11: memref<32x32xf32>, %arg12: memref<32x32xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg10, %arg11, %arg12) ({
        ^bb0(%arg13: index, %arg14: index, %arg15: index, %arg16: index, %arg17: memref<32x32xf32>, %arg18: memref<32x32xf32>, %arg19: memref<32x32xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 5>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : () -> memref<1024xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 4>, orbit.storage_index = 2 : i64, orbit.tile_pool = "public-storage-2"} : () -> memref<1024xf32, 2 : i32>
          "air.wait_all"() {orbit.public_event = 3 : i64, orbit.read_copies = array<i64: 3>, orbit.write_copies = array<i64: 4>} : () -> ()
          %4 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 32, 32>, orbit.storage_index = 2 : i64} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          %5 = "air.dma_memcpy_nd"(%4, %arg19) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 3 : i64, orbit.storage = "alloc2", orbit.transfer = "host_to_l1", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<32x32xf32>) -> !air.async.token
          "air.wait_all"(%5) : (!air.async.token) -> ()
          "air.wait_all"() {orbit.public_event = 4 : i64, orbit.read_copies = array<i64: 4>, orbit.write_copies = array<i64: 5>} : () -> ()
          %6 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 32, 32>, orbit.storage_index = 1 : i64} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          %7 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 32, 32>, orbit.storage_index = 2 : i64} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          %8 = "arith.constant"() <{value = 0 : index}> : () -> index
          %9 = "arith.constant"() <{value = 1 : index}> : () -> index
          %10 = "arith.constant"() <{value = 32 : index}> : () -> index
          %11 = "arith.constant"() <{value = 32 : index}> : () -> index
          %12 = "arith.constant"() <{value = 0 : index}> : () -> index
          %13 = "arith.constant"() <{value = 32 : index}> : () -> index
          %14 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%12, %13, %14) ({
          ^bb0(%arg20: index):
            %17 = "arith.constant"() <{value = 0 : index}> : () -> index
            %18 = "arith.constant"() <{value = 32 : index}> : () -> index
            %19 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%17, %18, %19) ({
            ^bb0(%arg21: index):
              %20 = "memref.load"(%7, %arg20, %arg21) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
              "memref.store"(%20, %6, %arg20, %arg21) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "air.wait_all"() {orbit.public_event = 5 : i64, orbit.read_copies = array<i64: 5>, orbit.write_copies = array<i64: 6>} : () -> ()
          %15 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 32, 32>, orbit.storage_index = 1 : i64} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          %16 = "air.dma_memcpy_nd"(%5, %arg18, %15) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.public_event = 5 : i64, orbit.storage = "arg1", orbit.transfer = "l1_to_host", static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<32x32xf32>, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
          "air.wait_all"(%16) : (!air.async.token) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%2) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 3>, orbit.spatial_owner = "npu.tile.1.3", sym_name = "orbit_public_core_1_3", x_loc = 1 : i32, y_loc = 3 : i32} : (index, index, memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 3>, sym_name = "orbit_public_graph_configuration"} : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {air.preserve_shim_dma_order, operandSegmentSizes = array<i32: 0, 2, 3>, sym_name = "orbit_public_graph"} : (index, index, memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> ()
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.program_graph = "56d85de044f0ae81ae42c9813028e4ae309654ba2a7c6529aea060f57c2e1c89"} : () -> ()

