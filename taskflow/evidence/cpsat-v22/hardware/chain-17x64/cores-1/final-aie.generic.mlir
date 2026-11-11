#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"builtin.module"() ({
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_segment"}> ({
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 0 : i32, row = 2 : i32}> : () -> index
    %2 = "aie.lock"(%1) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %3 = "aie.lock"(%1) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %4 = "aie.lock"(%1) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %5 = "aie.lock"(%1) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %6 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf2"}> : (index) -> memref<1088xf32, 2 : i32>
    %7 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf1"}> : (index) -> memref<1088xf32, 2 : i32>
    %8 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf0"}> : (index) -> memref<1088xf32, 2 : i32>
    %9 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<17x64xf32>
    %10 = "aie.external_buffer"() <{sym_name = "__air_external_buffer_1"}> : () -> memref<17x64xf32>
    %11 = "aie.mem"(%1) ({
      %30 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %31 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%5, %30) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1088 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<1088xf32, 2 : i32>) -> ()
      "aie.use_lock"(%4, %30) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %32 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%2, %30) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1088 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<1088xf32, 2 : i32>) -> ()
      "aie.use_lock"(%3, %30) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %12 = "aie.core"(%1) <{stack_size = 8192 : i32}> ({
      %15 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %16 = "arith.constant"() <{value = 17 : index}> : () -> index
      %17 = "arith.constant"() <{value = 64 : index}> : () -> index
      %18 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
      %19 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
      %20 = "arith.constant"() <{value = 1 : index}> : () -> index
      %21 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%4, %15) <{action = 2 : i32}> : (index, i32) -> ()
      %22 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
      "aie.use_lock"(%3, %15) <{action = 2 : i32}> : (index, i32) -> ()
      %23 = "memref.reinterpret_cast"(%8) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%21, %16, %20) ({
      ^bb0(%arg6: index):
        "scf.for"(%21, %17, %20) ({
        ^bb0(%arg7: index):
          %28 = "memref.load"(%22, %arg6, %arg7) : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %29 = "arith.addf"(%28, %18) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%29, %23, %arg6, %arg7) : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %24 = "memref.reinterpret_cast"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
      %25 = "memref.reinterpret_cast"(%8) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 17, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "T"} : (memref<1088xf32, 2 : i32>) -> memref<17x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%21, %16, %20) ({
      ^bb0(%arg4: index):
        "scf.for"(%21, %17, %20) ({
        ^bb0(%arg5: index):
          %26 = "memref.load"(%25, %arg4, %arg5) : (memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %27 = "arith.mulf"(%26, %19) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%27, %24, %arg4, %arg5) : (f32, memref<17x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%2, %15) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%5, %15) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_shard_0", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%0, %1) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%1, %0) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_1"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_0"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_segment_sequence"}> ({
    ^bb0(%arg2: memref<17x64xf32>, %arg3: memref<17x64xf32>):
      %13 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_1, issue_token = true}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1088 : i32, static_offset = 0 : i32, static_sizes = array<i64: 1088>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%13) : (index) -> ()
      %14 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_0}> ({
        "aie.dma_bd"(%arg2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1088 : i32, static_offset = 0 : i32, static_sizes = array<i64: 1088>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%14) : (index) -> ()
      "aiex.dma_await_task"(%13) : (index) -> ()
      "aiex.dma_free_task"(%14) : (index) -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>} : () -> ()
  "aie.device"() <{device = 8 : i32, sym_name = "main"}> ({
    "aie.runtime_sequence"() <{sym_name = "chain_17x64"}> ({
    ^bb0(%arg0: memref<17x64xf32>, %arg1: memref<17x64xf32>):
      "aiex.configure"() <{symbol = @orbit_segment}> ({
        "aiex.run"(%arg0, %arg1) <{runtime_sequence_symbol = @orbit_segment_sequence}> : (memref<17x64xf32>, memref<17x64xf32>) -> ()
      }) : () -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_realization = "tiled-phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "independent physical shards; per-shard normalized graph and concrete placement in manifest", orbit.multicore_realization = "independent row shards, one segment, disjoint static local pools", orbit.source_fingerprint = "69331a8bbb4c915649c5ac3ce9e4d2552bf9dd2561690f0d377528be38853259"} : () -> ()

