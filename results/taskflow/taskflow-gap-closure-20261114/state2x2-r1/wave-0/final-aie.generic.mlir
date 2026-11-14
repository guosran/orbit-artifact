#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"builtin.module"() ({
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_public_graph_configuration"}> ({
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 0 : i32, row = 3 : i32}> : () -> index
    %2 = "aie.lock"(%1) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %3 = "aie.lock"(%1) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %4 = "aie.lock"(%1) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %5 = "aie.lock"(%1) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %6 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf0"}> : (index) -> memref<2048xf32, 2 : i32>
    %7 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<64x64xf32>
    %8 = "aie.mem"(%1) ({
      %22 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %23 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%5, %22) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 1024 : i32}> {task_id = 0 : i32} : (memref<2048xf32, 2 : i32>) -> ()
      "aie.use_lock"(%4, %22) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %24 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%2, %22) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<2048xf32, 2 : i32>) -> ()
      "aie.use_lock"(%3, %22) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %9 = "aie.core"(%1) <{stack_size = 4096 : i32}> ({
      %12 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %13 = "arith.constant"() <{value = 16 : index}> : () -> index
      %14 = "arith.constant"() <{value = 64 : index}> : () -> index
      %15 = "arith.constant"() <{value = 1 : index}> : () -> index
      %16 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%4, %12) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%3, %12) <{action = 2 : i32}> : (index, i32) -> ()
      %17 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 1024>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 2 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
      %18 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 1 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : (memref<2048xf32, 2 : i32>) -> memref<16x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%16, %13, %15) ({
      ^bb0(%arg4: index):
        "scf.for"(%16, %14, %15) ({
        ^bb0(%arg5: index):
          %21 = "memref.load"(%18, %arg4, %arg5) : (memref<16x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          "memref.store"(%21, %17, %arg4, %arg5) : (f32, memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "scf.for"(%16, %13, %15) ({
      ^bb0(%arg2: index):
        "scf.for"(%16, %14, %15) ({
        ^bb0(%arg3: index):
          %19 = "memref.load"(%17, %arg2, %arg3) : (memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, index, index) -> f32
          %20 = "arith.addf"(%19, %19) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%20, %17, %arg2, %arg3) : (f32, memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%2, %12) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%5, %12) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_0_3", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%0, %1) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%1, %0) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_1"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_0"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_public_graph_configuration_sequence"}> ({
    ^bb0(%arg1: memref<64x64xf32>):
      %10 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_1, issue_token = true}> ({
        "aie.dma_bd"(%arg1) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 0 : i32, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> : (memref<64x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) {air.preserve_shim_dma_order} : () -> index
      "aiex.dma_start_task"(%10) : (index) -> ()
      %11 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_0}> ({
        "aie.dma_bd"(%arg1) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 0 : i32, static_sizes = array<i64: 16, 64>, static_strides = array<i64: 64, 1>}> : (memref<64x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%11) : (index) -> ()
      "aiex.dma_await_task"(%10) : (index) -> ()
      "aiex.dma_free_task"(%11) : (index) -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>} : () -> ()
  "aie.device"() <{device = 8 : i32, sym_name = "main"}> ({
    "aie.runtime_sequence"() <{sym_name = "pointwise"}> ({
    ^bb0(%arg0: memref<64x64xf32>):
      "aiex.configure"() <{symbol = @orbit_public_graph_configuration}> ({
        "aiex.run"(%arg0) <{runtime_sequence_symbol = @orbit_public_graph_configuration_sequence}> : (memref<64x64xf32>) -> ()
      }) : () -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) : () -> ()
}) {orbit.program_graph = "9624db75476676b8912a474fde3f821bb03ebd74ad85621d079e3aad1510c3b5"} : () -> ()

