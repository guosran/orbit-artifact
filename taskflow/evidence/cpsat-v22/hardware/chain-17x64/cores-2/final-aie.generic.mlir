#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"builtin.module"() ({
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_segment"}> ({
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 1 : i32, row = 0 : i32}> : () -> index
    %2 = "aie.tile"() <{col = 1 : i32, row = 2 : i32}> : () -> index
    %3 = "aie.tile"() <{col = 0 : i32, row = 2 : i32}> : () -> index
    %4 = "aie.lock"(%2) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %5 = "aie.lock"(%2) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %6 = "aie.lock"(%2) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %7 = "aie.lock"(%2) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %8 = "aie.lock"(%3) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %9 = "aie.lock"(%3) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %10 = "aie.lock"(%3) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %11 = "aie.lock"(%3) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %12 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf5"}> : (index) -> memref<512xf32, 2 : i32>
    %13 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf4"}> : (index) -> memref<512xf32, 2 : i32>
    %14 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf3"}> : (index) -> memref<512xf32, 2 : i32>
    %15 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf2"}> : (index) -> memref<576xf32, 2 : i32>
    %16 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf1"}> : (index) -> memref<576xf32, 2 : i32>
    %17 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf0"}> : (index) -> memref<576xf32, 2 : i32>
    %18 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<17x64xf32>
    %19 = "aie.external_buffer"() <{sym_name = "__air_external_buffer_1"}> : () -> memref<17x64xf32>
    %20 = "aie.mem"(%3) ({
      %61 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %62 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%11, %61) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%13) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<512xf32, 2 : i32>) -> ()
      "aie.use_lock"(%10, %61) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %63 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%8, %61) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%12) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<512xf32, 2 : i32>) -> ()
      "aie.use_lock"(%9, %61) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %21 = "aie.core"(%3) <{stack_size = 8192 : i32}> ({
      %46 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %47 = "arith.constant"() <{value = 8 : index}> : () -> index
      %48 = "arith.constant"() <{value = 64 : index}> : () -> index
      %49 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
      %50 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
      %51 = "arith.constant"() <{value = 1 : index}> : () -> index
      %52 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%10, %46) <{action = 2 : i32}> : (index, i32) -> ()
      %53 = "memref.reinterpret_cast"(%12) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "aie.use_lock"(%9, %46) <{action = 2 : i32}> : (index, i32) -> ()
      %54 = "memref.reinterpret_cast"(%14) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%52, %47, %51) ({
      ^bb0(%arg10: index):
        "scf.for"(%52, %48, %51) ({
        ^bb0(%arg11: index):
          %59 = "memref.load"(%53, %arg10, %arg11) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %60 = "arith.addf"(%59, %49) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%60, %54, %arg10, %arg11) : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %55 = "memref.reinterpret_cast"(%13) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      %56 = "memref.reinterpret_cast"(%14) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "T"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%52, %47, %51) ({
      ^bb0(%arg8: index):
        "scf.for"(%52, %48, %51) ({
        ^bb0(%arg9: index):
          %57 = "memref.load"(%56, %arg8, %arg9) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %58 = "arith.mulf"(%57, %50) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%58, %55, %arg8, %arg9) : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%8, %46) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%11, %46) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_shard_1", air.herd_size = array<i64: 1, 1>} : (index) -> index
    %22 = "aie.mem"(%2) ({
      %43 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %44 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%7, %43) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%16) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<576xf32, 2 : i32>) -> ()
      "aie.use_lock"(%6, %43) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %45 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%4, %43) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%15) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<576xf32, 2 : i32>) -> ()
      "aie.use_lock"(%5, %43) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %23 = "aie.core"(%2) <{stack_size = 8192 : i32}> ({
      %28 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %29 = "arith.constant"() <{value = 9 : index}> : () -> index
      %30 = "arith.constant"() <{value = 64 : index}> : () -> index
      %31 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
      %32 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
      %33 = "arith.constant"() <{value = 1 : index}> : () -> index
      %34 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%6, %28) <{action = 2 : i32}> : (index, i32) -> ()
      %35 = "memref.reinterpret_cast"(%15) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "aie.use_lock"(%5, %28) <{action = 2 : i32}> : (index, i32) -> ()
      %36 = "memref.reinterpret_cast"(%17) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%34, %29, %33) ({
      ^bb0(%arg6: index):
        "scf.for"(%34, %30, %33) ({
        ^bb0(%arg7: index):
          %41 = "memref.load"(%35, %arg6, %arg7) : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %42 = "arith.addf"(%41, %31) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%42, %36, %arg6, %arg7) : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %37 = "memref.reinterpret_cast"(%16) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "R"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      %38 = "memref.reinterpret_cast"(%17) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "T"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%34, %29, %33) ({
      ^bb0(%arg4: index):
        "scf.for"(%34, %30, %33) ({
        ^bb0(%arg5: index):
          %39 = "memref.load"(%38, %arg4, %arg5) : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %40 = "arith.mulf"(%39, %32) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%40, %37, %arg4, %arg5) : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%4, %28) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%7, %28) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_shard_0", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%1, %2) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%2, %1) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%0, %3) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%3, %0) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%1) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_1"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_3"}> : (index) -> ()
    "aie.shim_dma_allocation"(%1) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_0"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_2"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_segment_sequence"}> ({
    ^bb0(%arg2: memref<17x64xf32>, %arg3: memref<17x64xf32>):
      %24 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_1, issue_token = true}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32, static_sizes = array<i64: 576>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%24) : (index) -> ()
      %25 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_3, issue_token = true}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 576 : i32, static_sizes = array<i64: 512>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%25) : (index) -> ()
      %26 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_0}> ({
        "aie.dma_bd"(%arg2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32, static_sizes = array<i64: 576>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%26) : (index) -> ()
      %27 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_2}> ({
        "aie.dma_bd"(%arg2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 576 : i32, static_sizes = array<i64: 512>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%27) : (index) -> ()
      "aiex.dma_await_task"(%24) : (index) -> ()
      "aiex.dma_await_task"(%25) : (index) -> ()
      "aiex.dma_free_task"(%26) : (index) -> ()
      "aiex.dma_free_task"(%27) : (index) -> ()
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

