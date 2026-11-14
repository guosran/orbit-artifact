#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"builtin.module"() ({
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_public_graph_configuration"}> ({
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 0 : i32, row = 4 : i32}> : () -> index
    %2 = "aie.lock"(%1) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %3 = "aie.lock"(%1) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %4 = "aie.lock"(%1) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %5 = "aie.lock"(%1) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %6 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf1"}> : (index) -> memref<256xf32, 2 : i32>
    %7 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf0"}> : (index) -> memref<256xf32, 2 : i32>
    %8 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<32x32xf32>
    %9 = "aie.external_buffer"() <{sym_name = "__air_external_buffer_1"}> : () -> memref<32x32xf32>
    %10 = "aie.mem"(%1) ({
      %24 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %25 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%5, %24) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 256 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<256xf32, 2 : i32>) -> ()
      "aie.use_lock"(%4, %24) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %26 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%2, %24) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 256 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<256xf32, 2 : i32>) -> ()
      "aie.use_lock"(%3, %24) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %11 = "aie.core"(%1) <{stack_size = 4096 : i32}> ({
      %14 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %15 = "arith.constant"() <{value = 32 : index}> : () -> index
      %16 = "arith.constant"() <{value = 16 : index}> : () -> index
      %17 = "arith.constant"() <{value = 1 : index}> : () -> index
      %18 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%4, %14) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%3, %14) <{action = 2 : i32}> : (index, i32) -> ()
      %19 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 16, 1>}> {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 0, 16>, orbit.logical_sizes = array<i64: 16, 16>, orbit.storage_index = 0 : i64} : (memref<256xf32, 2 : i32>) -> memref<16x16xf32, strided<[16, 1]>, 2 : i32>
      %20 = "memref.reinterpret_cast"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 16, 1>}> {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 0, 16>, orbit.logical_sizes = array<i64: 16, 16>, orbit.storage_index = 1 : i64} : (memref<256xf32, 2 : i32>) -> memref<16x16xf32, strided<[16, 1]>, 2 : i32>
      "scf.for"(%18, %16, %17) ({
      ^bb0(%arg4: index):
        "scf.for"(%16, %15, %17) ({
        ^bb0(%arg5: index):
          %21 = "arith.subi"(%arg5, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
          %22 = "memref.load"(%19, %arg4, %21) : (memref<16x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> f32
          %23 = "arith.addf"(%22, %22) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%23, %20, %arg4, %21) : (f32, memref<16x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%2, %14) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%5, %14) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_0_4", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%0, %1) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%1, %0) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_1"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_0"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_public_graph_configuration_sequence"}> ({
    ^bb0(%arg2: memref<32x32xf32>, %arg3: memref<32x32xf32>):
      %12 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_1, issue_token = true}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 256 : i32, static_offset = 16 : i32, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 32, 1>}> : (memref<32x32xf32>) -> ()
        "aie.end"() : () -> ()
      }) {air.preserve_shim_dma_order} : () -> index
      "aiex.dma_start_task"(%12) : (index) -> ()
      %13 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_0}> ({
        "aie.dma_bd"(%arg2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 256 : i32, static_offset = 16 : i32, static_sizes = array<i64: 16, 16>, static_strides = array<i64: 32, 1>}> : (memref<32x32xf32>) -> ()
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
    ^bb0(%arg0: memref<32x32xf32>, %arg1: memref<32x32xf32>):
      "aiex.configure"() <{symbol = @orbit_public_graph_configuration}> ({
        "aiex.run"(%arg0, %arg1) <{runtime_sequence_symbol = @orbit_public_graph_configuration_sequence}> : (memref<32x32xf32>, memref<32x32xf32>) -> ()
      }) : () -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) : () -> ()
}) {orbit.program_graph = "4abfbd354a6b2c9b333c577af6d08508a5e0d009df0ecbbedcab3cbdfac88280"} : () -> ()

