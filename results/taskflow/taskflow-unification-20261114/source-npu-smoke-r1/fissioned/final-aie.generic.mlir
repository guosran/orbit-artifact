#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"builtin.module"() ({
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_segment_4"}> ({
    %26 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %27 = "aie.tile"() <{col = 0 : i32, row = 2 : i32}> : () -> index
    %28 = "aie.lock"(%27) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %29 = "aie.lock"(%27) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %30 = "aie.lock"(%27) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %31 = "aie.lock"(%27) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %32 = "aie.buffer"(%27) <{aligned = true, sym_name = "buf3"}> : (index) -> memref<1024xf32, 2 : i32>
    %33 = "aie.buffer"(%27) <{aligned = true, sym_name = "buf2"}> : (index) -> memref<1024xf32, 2 : i32>
    %34 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<64x64xf32>
    %35 = "aie.external_buffer"() <{sym_name = "__air_external_buffer_1"}> : () -> memref<64x64xf32>
    %36 = "aie.mem"(%27) ({
      %49 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %50 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%31, %49) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%33) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<1024xf32, 2 : i32>) -> ()
      "aie.use_lock"(%30, %49) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %51 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%28, %49) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%32) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<1024xf32, 2 : i32>) -> ()
      "aie.use_lock"(%29, %49) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %37 = "aie.core"(%27) <{stack_size = 4096 : i32}> ({
      %40 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %41 = "arith.constant"() <{value = 2 : index}> : () -> index
      %42 = "arith.constant"() <{value = 32 : index}> : () -> index
      %43 = "arith.constant"() <{value = 1 : index}> : () -> index
      %44 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "scf.for"(%44, %41, %43) ({
      ^bb0(%arg13: index):
        "scf.for"(%44, %41, %43) ({
        ^bb0(%arg14: index):
          "aie.use_lock"(%30, %40) <{action = 2 : i32}> : (index, i32) -> ()
          %45 = "memref.reinterpret_cast"(%33) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          %46 = "memref.reinterpret_cast"(%32) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          "aie.use_lock"(%29, %40) <{action = 2 : i32}> : (index, i32) -> ()
          "scf.for"(%44, %42, %43) ({
          ^bb0(%arg15: index):
            "scf.for"(%44, %42, %43) ({
            ^bb0(%arg16: index):
              %47 = "memref.load"(%46, %arg15, %arg16) : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
              %48 = "arith.mulf"(%47, %47) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%48, %45, %arg15, %arg16) : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
          "aie.use_lock"(%31, %40) <{action = 1 : i32}> : (index, i32) -> ()
          "aie.use_lock"(%28, %40) <{action = 1 : i32}> : (index, i32) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_4", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%26, %27) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%27, %26) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%26) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_3"}> : (index) -> ()
    "aie.shim_dma_allocation"(%26) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_2"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_segment_4_sequence"}> ({
    ^bb0(%arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>, %arg12: memref<64x64xf32>):
      %38 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_3, issue_token = true, repeat_count = 1 : i32}> ({
        "aie.dma_bd"(%arg11) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 2048 : i32, static_offset = 0 : i32, static_sizes = array<i64: 2, 2, 32, 32>, static_strides = array<i64: 2048, 32, 64, 1>}> : (memref<64x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%38) : (index) -> ()
      %39 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_2, repeat_count = 1 : i32}> ({
        "aie.dma_bd"(%arg12) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 2048 : i32, static_offset = 0 : i32, static_sizes = array<i64: 2, 2, 32, 32>, static_strides = array<i64: 2048, 32, 64, 1>}> : (memref<64x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%39) : (index) -> ()
      "aiex.dma_await_task"(%38) : (index) -> ()
      "aiex.dma_free_task"(%39) : (index) -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>} : () -> ()
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_segment"}> ({
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 0 : i32, row = 2 : i32}> : () -> index
    %2 = "aie.lock"(%1) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %3 = "aie.lock"(%1) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %4 = "aie.lock"(%1) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %5 = "aie.lock"(%1) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %6 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf1"}> : (index) -> memref<1024xf32, 2 : i32>
    %7 = "aie.buffer"(%1) <{aligned = true, sym_name = "buf0"}> : (index) -> memref<1024xf32, 2 : i32>
    %8 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<64x64xf32>
    %9 = "aie.external_buffer"() <{sym_name = "__air_external_buffer_1"}> : () -> memref<64x64xf32>
    %10 = "aie.mem"(%1) ({
      %23 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %24 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%5, %23) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<1024xf32, 2 : i32>) -> ()
      "aie.use_lock"(%4, %23) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %25 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%2, %23) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 1024 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<1024xf32, 2 : i32>) -> ()
      "aie.use_lock"(%3, %23) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %11 = "aie.core"(%1) <{stack_size = 4096 : i32}> ({
      %14 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %15 = "arith.constant"() <{value = 2 : index}> : () -> index
      %16 = "arith.constant"() <{value = 32 : index}> : () -> index
      %17 = "arith.constant"() <{value = 1 : index}> : () -> index
      %18 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "scf.for"(%18, %15, %17) ({
      ^bb0(%arg6: index):
        "scf.for"(%18, %15, %17) ({
        ^bb0(%arg7: index):
          "aie.use_lock"(%4, %14) <{action = 2 : i32}> : (index, i32) -> ()
          %19 = "memref.reinterpret_cast"(%7) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          "aie.use_lock"(%3, %14) <{action = 2 : i32}> : (index, i32) -> ()
          %20 = "memref.reinterpret_cast"(%6) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          "scf.for"(%18, %16, %17) ({
          ^bb0(%arg8: index):
            "scf.for"(%18, %16, %17) ({
            ^bb0(%arg9: index):
              %21 = "memref.load"(%19, %arg8, %arg9) : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
              %22 = "arith.addf"(%21, %21) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%22, %20, %arg8, %arg9) : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
          "aie.use_lock"(%2, %14) <{action = 1 : i32}> : (index, i32) -> ()
          "aie.use_lock"(%5, %14) <{action = 1 : i32}> : (index, i32) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%0, %1) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%1, %0) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_1"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_0"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_segment_sequence"}> ({
    ^bb0(%arg3: memref<64x64xf32>, %arg4: memref<64x64xf32>, %arg5: memref<64x64xf32>):
      %12 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_1, issue_token = true, repeat_count = 1 : i32}> ({
        "aie.dma_bd"(%arg5) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 2048 : i32, static_offset = 0 : i32, static_sizes = array<i64: 2, 2, 32, 32>, static_strides = array<i64: 2048, 32, 64, 1>}> : (memref<64x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%12) : (index) -> ()
      %13 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_0, repeat_count = 1 : i32}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 2048 : i32, static_offset = 0 : i32, static_sizes = array<i64: 2, 2, 32, 32>, static_strides = array<i64: 2048, 32, 64, 1>}> : (memref<64x64xf32>) -> ()
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
    ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<64x64xf32>):
      "aiex.configure"() <{symbol = @orbit_segment}> ({
        "aiex.run"(%arg0, %arg1, %arg2) <{runtime_sequence_symbol = @orbit_segment_sequence}> : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      }) : () -> ()
      "aiex.configure"() <{symbol = @orbit_segment_4}> ({
        "aiex.run"(%arg0, %arg1, %arg2) <{runtime_sequence_symbol = @orbit_segment_4_sequence}> : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      }) : () -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_realization = "phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "common execution groups and explicit copy/release dependencies; source compute order preserved; conservative timing reservations are separate from runtime arbitration", orbit.mapping_plan = "3d731ad0bb0d3ad5a9392457830e8a5d5485f557af8736f2de009796061e662a", orbit.program_graph = "ef44aa1fef4d1c7718eb161e01d89712f3ff4d87d888ab695f7c7bee7630a90f", orbit.source_fingerprint = "b17fa0f5820838d945936434006e3510f45f6ba93db49555d72b54e7a4e752a0"} : () -> ()

