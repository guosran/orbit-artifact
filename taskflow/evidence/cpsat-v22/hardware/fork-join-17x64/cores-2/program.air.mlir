"builtin.module"() ({
  "func.func"() <{function_type = (memref<17x64xf32>, memref<17x64xf32>) -> (), sym_name = "fork_join_17x64"}> ({
  ^bb0(%arg0: memref<17x64xf32>, %arg1: memref<17x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<17x64xf32>, %arg7: memref<17x64xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<17x64xf32>, %arg9: memref<17x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg24: index, %arg25: index, %arg26: index, %arg27: index, %arg28: memref<17x64xf32>, %arg29: memref<17x64xf32>):
          %59 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.9.64.loops.9.64"} : () -> memref<576xf32, 2 : i32>
          %60 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<576xf32, 2 : i32>
          %61 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<576xf32, 2 : i32>
          %62 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<576xf32, 2 : i32>
          %63 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 6 : i64, orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<576xf32, 2 : i32>
          %64 = "air.wait_all"() : () -> !air.async.token
          %65 = "memref.reinterpret_cast"(%59) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          %66 = "air.dma_memcpy_nd"(%64, %65, %arg28) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "I", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 9, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 9, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, memref<17x64xf32>) -> !air.async.token
          %67 = "memref.reinterpret_cast"(%61) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%64, %66) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_X", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %68 = "arith.constant"() <{value = 0 : index}> : () -> index
          %69 = "arith.constant"() <{value = 9 : index}> : () -> index
          %70 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%68, %69, %70) ({
          ^bb0(%arg36: index):
            %109 = "arith.constant"() <{value = 0 : index}> : () -> index
            %110 = "arith.constant"() <{value = 64 : index}> : () -> index
            %111 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%109, %110, %111) ({
            ^bb0(%arg37: index):
              %112 = "memref.load"(%65, %arg36, %arg37) <{nontemporal = false}> : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %113 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %114 = "arith.addf"(%112, %113) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%114, %67, %arg36, %arg37) <{nontemporal = false}> : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %71 = "memref.reinterpret_cast"(%61) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "X"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          %72 = "memref.reinterpret_cast"(%62) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "Y"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%64) {orbit.computation_event = 2 : i64, orbit.phase = 1 : i64, orbit.phase_dependencies = array<i64: 0>, orbit.public_dependencies = array<i64: 1>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 1 : i64, orbit.task = "write_Y", orbit.write_copies = array<i64: 3>} : (!air.async.token) -> ()
          %73 = "arith.constant"() <{value = 0 : index}> : () -> index
          %74 = "arith.constant"() <{value = 9 : index}> : () -> index
          %75 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%73, %74, %75) ({
          ^bb0(%arg34: index):
            %103 = "arith.constant"() <{value = 0 : index}> : () -> index
            %104 = "arith.constant"() <{value = 64 : index}> : () -> index
            %105 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%103, %104, %105) ({
            ^bb0(%arg35: index):
              %106 = "memref.load"(%71, %arg34, %arg35) <{nontemporal = false}> : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %107 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %108 = "arith.mulf"(%106, %107) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%108, %72, %arg34, %arg35) <{nontemporal = false}> : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %76 = "memref.reinterpret_cast"(%61) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "X"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          %77 = "memref.reinterpret_cast"(%63) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "Z"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%64) {orbit.computation_event = 3 : i64, orbit.phase = 2 : i64, orbit.phase_dependencies = array<i64: 1>, orbit.public_dependencies = array<i64: 1, 2>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 2 : i64, orbit.task = "write_Z", orbit.write_copies = array<i64: 4>} : (!air.async.token) -> ()
          %78 = "arith.constant"() <{value = 0 : index}> : () -> index
          %79 = "arith.constant"() <{value = 9 : index}> : () -> index
          %80 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%78, %79, %80) ({
          ^bb0(%arg32: index):
            %97 = "arith.constant"() <{value = 0 : index}> : () -> index
            %98 = "arith.constant"() <{value = 64 : index}> : () -> index
            %99 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%97, %98, %99) ({
            ^bb0(%arg33: index):
              %100 = "memref.load"(%76, %arg32, %arg33) <{nontemporal = false}> : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %101 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %102 = "arith.subf"(%100, %101) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%102, %77, %arg32, %arg33) <{nontemporal = false}> : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %81 = "memref.reinterpret_cast"(%60) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          %82 = "memref.reinterpret_cast"(%62) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Y"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          %83 = "memref.reinterpret_cast"(%63) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Z"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%64) {orbit.computation_event = 4 : i64, orbit.phase = 3 : i64, orbit.phase_dependencies = array<i64: 2>, orbit.public_dependencies = array<i64: 2, 3>, orbit.read_copies = array<i64: 3, 4>, orbit.source_instance = 3 : i64, orbit.task = "write_R", orbit.write_copies = array<i64: 5>} : (!air.async.token) -> ()
          %84 = "arith.constant"() <{value = 0 : index}> : () -> index
          %85 = "arith.constant"() <{value = 9 : index}> : () -> index
          %86 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%84, %85, %86) ({
          ^bb0(%arg30: index):
            %91 = "arith.constant"() <{value = 0 : index}> : () -> index
            %92 = "arith.constant"() <{value = 64 : index}> : () -> index
            %93 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%91, %92, %93) ({
            ^bb0(%arg31: index):
              %94 = "memref.load"(%82, %arg30, %arg31) <{nontemporal = false}> : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %95 = "memref.load"(%83, %arg30, %arg31) <{nontemporal = false}> : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %96 = "arith.addf"(%94, %95) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%96, %81, %arg30, %arg31) <{nontemporal = false}> : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %87 = "memref.reinterpret_cast"(%60) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
          %88 = "air.dma_memcpy_nd"(%64, %arg29, %87) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 3 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "R", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 5 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 9, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 9, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32>, memref<9x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          %89 = "air.wait_all"(%88) : (!air.async.token) -> !air.async.token
          %90 = "air.wait_all"(%64, %64, %64, %89) : (!air.async.token, !air.async.token, !air.async.token, !air.async.token) -> !air.async.token
          "air.wait_all"(%90) : (!air.async.token) -> ()
          "memref.dealloc"(%59) : (memref<576xf32, 2 : i32>) -> ()
          "memref.dealloc"(%60) : (memref<576xf32, 2 : i32>) -> ()
          "memref.dealloc"(%61) : (memref<576xf32, 2 : i32>) -> ()
          "memref.dealloc"(%62) : (memref<576xf32, 2 : i32>) -> ()
          "memref.dealloc"(%63) : (memref<576xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3, 4, 5>, orbit.mapping_strategy = "serial-tiled", orbit.row_count = 9 : i64, orbit.row_offset = 0 : i64, orbit.shard = 0 : i64, orbit.spatial_owner = "npu.tile(1,2)", sym_name = "orbit_shard_0", x_loc = 1 : i32, y_loc = 2 : i32} : (index, index, memref<17x64xf32>, memref<17x64xf32>) -> ()
        %2 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%2, %2, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<17x64xf32>, %arg15: memref<17x64xf32>):
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 2 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.64.loops.8.64"} : () -> memref<512xf32, 2 : i32>
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<512xf32, 2 : i32>
          %5 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<512xf32, 2 : i32>
          %6 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<512xf32, 2 : i32>
          %7 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 6 : i64, orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<512xf32, 2 : i32>
          %8 = "air.wait_all"() : () -> !air.async.token
          %9 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %10 = "air.dma_memcpy_nd"(%8, %9, %arg14) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "I", orbit.target_copies = array<i64: 1>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 9, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, memref<17x64xf32>) -> !air.async.token
          %11 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%8, %10) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 1>, orbit.source_instance = 0 : i64, orbit.task = "write_X", orbit.write_copies = array<i64: 2>} : (!air.async.token, !air.async.token) -> ()
          %12 = "arith.constant"() <{value = 0 : index}> : () -> index
          %13 = "arith.constant"() <{value = 8 : index}> : () -> index
          %14 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%12, %13, %14) ({
          ^bb0(%arg22: index):
            %53 = "arith.constant"() <{value = 0 : index}> : () -> index
            %54 = "arith.constant"() <{value = 64 : index}> : () -> index
            %55 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%53, %54, %55) ({
            ^bb0(%arg23: index):
              %56 = "memref.load"(%9, %arg22, %arg23) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %57 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %58 = "arith.addf"(%56, %57) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%58, %11, %arg22, %arg23) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %15 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %16 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "Y"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%8) {orbit.computation_event = 2 : i64, orbit.phase = 1 : i64, orbit.phase_dependencies = array<i64: 0>, orbit.public_dependencies = array<i64: 1>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 1 : i64, orbit.task = "write_Y", orbit.write_copies = array<i64: 3>} : (!air.async.token) -> ()
          %17 = "arith.constant"() <{value = 0 : index}> : () -> index
          %18 = "arith.constant"() <{value = 8 : index}> : () -> index
          %19 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%17, %18, %19) ({
          ^bb0(%arg20: index):
            %47 = "arith.constant"() <{value = 0 : index}> : () -> index
            %48 = "arith.constant"() <{value = 64 : index}> : () -> index
            %49 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%47, %48, %49) ({
            ^bb0(%arg21: index):
              %50 = "memref.load"(%15, %arg20, %arg21) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %51 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
              %52 = "arith.mulf"(%50, %51) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%52, %16, %arg20, %arg21) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %20 = "memref.reinterpret_cast"(%5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %21 = "memref.reinterpret_cast"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "Z"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%8) {orbit.computation_event = 3 : i64, orbit.phase = 2 : i64, orbit.phase_dependencies = array<i64: 1>, orbit.public_dependencies = array<i64: 1, 2>, orbit.read_copies = array<i64: 2>, orbit.source_instance = 2 : i64, orbit.task = "write_Z", orbit.write_copies = array<i64: 4>} : (!air.async.token) -> ()
          %22 = "arith.constant"() <{value = 0 : index}> : () -> index
          %23 = "arith.constant"() <{value = 8 : index}> : () -> index
          %24 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%22, %23, %24) ({
          ^bb0(%arg18: index):
            %41 = "arith.constant"() <{value = 0 : index}> : () -> index
            %42 = "arith.constant"() <{value = 64 : index}> : () -> index
            %43 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%41, %42, %43) ({
            ^bb0(%arg19: index):
              %44 = "memref.load"(%20, %arg18, %arg19) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %45 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
              %46 = "arith.subf"(%44, %45) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%46, %21, %arg18, %arg19) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %25 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %26 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Y"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %27 = "memref.reinterpret_cast"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Z"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          "air.wait_all"(%8) {orbit.computation_event = 4 : i64, orbit.phase = 3 : i64, orbit.phase_dependencies = array<i64: 2>, orbit.public_dependencies = array<i64: 2, 3>, orbit.read_copies = array<i64: 3, 4>, orbit.source_instance = 3 : i64, orbit.task = "write_R", orbit.write_copies = array<i64: 5>} : (!air.async.token) -> ()
          %28 = "arith.constant"() <{value = 0 : index}> : () -> index
          %29 = "arith.constant"() <{value = 8 : index}> : () -> index
          %30 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%28, %29, %30) ({
          ^bb0(%arg16: index):
            %35 = "arith.constant"() <{value = 0 : index}> : () -> index
            %36 = "arith.constant"() <{value = 64 : index}> : () -> index
            %37 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%35, %36, %37) ({
            ^bb0(%arg17: index):
              %38 = "memref.load"(%26, %arg16, %arg17) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %39 = "memref.load"(%27, %arg16, %arg17) <{nontemporal = false}> : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
              %40 = "arith.addf"(%38, %39) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%40, %25, %arg16, %arg17) <{nontemporal = false}> : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %31 = "memref.reinterpret_cast"(%4) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %32 = "air.dma_memcpy_nd"(%8, %arg15, %31) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 3 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "R", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 5 : i64, static_dst_offsets = array<i64: 9, 0>, static_dst_sizes = array<i64: 8, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 8, 64>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<17x64xf32>, memref<8x64xf32, strided<[64, 1]>, 2 : i32>) -> !air.async.token
          %33 = "air.wait_all"(%32) : (!air.async.token) -> !air.async.token
          %34 = "air.wait_all"(%8, %8, %8, %33) : (!air.async.token, !air.async.token, !air.async.token, !air.async.token) -> !air.async.token
          "air.wait_all"(%34) : (!air.async.token) -> ()
          "memref.dealloc"(%3) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%5) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%6) : (memref<512xf32, 2 : i32>) -> ()
          "memref.dealloc"(%7) : (memref<512xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3, 4, 5>, orbit.mapping_strategy = "serial-tiled", orbit.row_count = 8 : i64, orbit.row_offset = 9 : i64, orbit.shard = 1 : i64, orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_shard_1", x_loc = 0 : i32, y_loc = 2 : i32} : (index, index, memref<17x64xf32>, memref<17x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_segment"} : (memref<17x64xf32>, memref<17x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch"} : (index, index, memref<17x64xf32>, memref<17x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_realization = "tiled-phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "independent physical shards; per-shard normalized graph and concrete placement in manifest", orbit.multicore_realization = "independent row shards, one segment, disjoint static local pools", orbit.source_fingerprint = "fe49f7fffb21a469683af2bf55f1e4dbee7a15a4b25a95dc73c267a0b2efec74"} : () -> ()

