#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"builtin.module"() ({
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_public_graph_configuration"}> ({
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 0 : i32, row = 3 : i32}> : () -> index
    %2 = "aie.lock"(%1) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %3 = "aie.lock"(%1) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %4 = "aie.lock"(%1) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %5 = "aie.lock"(%1) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %6 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf1"}> : (index) -> memref<512xf32, 2 : i32>
    %7 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf0"}> : (index) -> memref<512xf32, 2 : i32>
    %8 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<64x64xf32>
    %9 = "aie.external_buffer"() <{sym_name = "__air_external_buffer_1"}> : () -> memref<64x64xf32>
    %10 = "aie.mem"(%1) ({
      %25 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %26 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%5, %25) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<512xf32, 2 : i32>) -> ()
      "aie.use_lock"(%4, %25) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %27 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%2, %25) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<512xf32, 2 : i32>) -> ()
      "aie.use_lock"(%3, %25) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %11 = "aie.core"(%1) <{stack_size = 4096 : i32}> ({
      %14 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %15 = "arith.constant"() <{value = 64 : index}> : () -> index
      %16 = "arith.constant"() <{value = 16 : index}> : () -> index
      %17 = "arith.constant"() <{value = 8 : index}> : () -> index
      %18 = "arith.constant"() <{value = 1 : index}> : () -> index
      %19 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%4, %14) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%3, %14) <{action = 2 : i32}> : (index, i32) -> ()
      %20 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 1 : i64, orbit.logical_offsets = array<i64: 8, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 0 : i64} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      %21 = "memref.reinterpret_cast"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.allocation = 2 : i64, orbit.logical_offsets = array<i64: 8, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 1 : i64} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%17, %16, %18) ({
      ^bb0(%arg4: index):
        "scf.for"(%19, %15, %18) ({
        ^bb0(%arg5: index):
          %22 = "arith.subi"(%arg4, %17) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          %23 = "memref.load"(%20, %22, %arg5) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %24 = "arith.addf"(%23, %23) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%24, %21, %22, %arg5) : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%2, %14) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%5, %14) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_0_3", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%0, %1) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%1, %0) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_1"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_0"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_public_graph_configuration_sequence"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %12 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_1, issue_token = true}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 512 : i32, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> : (memref<64x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) {air.preserve_shim_dma_order} : () -> index
      "aiex.dma_start_task"(%12) : (index) -> ()
      %13 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_0}> ({
        "aie.dma_bd"(%arg2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 512 : i32, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> : (memref<64x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%13) : (index) -> ()
      "aiex.dma_await_task"(%12) : (index) -> ()
      "aiex.dma_free_task"(%13) : (index) -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>} : () -> ()
  "aie.device"() <{device = 8 : i32, sym_name = "main"}> ({
    "aie.runtime_sequence"() <{sym_name = "pointwise"}> ({
    ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
      "aiex.configure"() <{symbol = @orbit_public_graph_configuration}> ({
        "aiex.run"(%arg0, %arg1) <{runtime_sequence_symbol = @orbit_public_graph_configuration_sequence}> : (memref<64x64xf32>, memref<64x64xf32>) -> ()
      }) : () -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) : () -> ()
}) {orbit.program_graph = "0c949f6a8f8fb604f1763fd00dc7c3fc7533c049cea93f90e62adb6c1b53f303"} : () -> ()

