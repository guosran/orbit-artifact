#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.mapping_plan = "28f6187c7639f2aaf609e26ed279c42b2592cecb0f2bb2952e5cdcd420ab1424", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} {
  aie.device(npu2) @orbit_segment_80 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf13 = aie.buffer(%tile_0_2) {sym_name = "buf13"} : memref<128xf32, 2 : i32> 
    %buf12 = aie.buffer(%tile_0_2) {sym_name = "buf12"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<32x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf12 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf13 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 5.000000e-01 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c4 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf12 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_3 = memref.reinterpret_cast %buf13 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c1 {
              %0 = memref.load %reinterpret_cast_3[%arg2, %arg3] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %1 = arith.mulf %0, %cst : f32
              memref.store %1, %reinterpret_cast[%arg2, %arg3] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_2, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_80", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_13(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_12(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_80_sequence(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_13 {
        aie.dma_bd(%arg2 : memref<32x64xf32> offset = 0 len = 512 sizes = [4, 4, 8, 16] strides = [512, 16, 64, 1])
        aie.end
      } {issue_token = true, repeat_count = 3 : i32}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_12 {
        aie.dma_bd(%arg3 : memref<32x64xf32> offset = 0 len = 512 sizes = [4, 4, 8, 16] strides = [512, 16, 64, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_64 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf11 = aie.buffer(%tile_0_2) {sym_name = "buf11"} : memref<2048xf32, 2 : i32> 
    %buf10 = aie.buffer(%tile_0_2) {sym_name = "buf10"} : memref<128xf32, 2 : i32> 
    %buf9 = aie.buffer(%tile_0_2) {sym_name = "buf9"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf10 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf11 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf9 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c48 = arith.constant 48 : index
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf11 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 64 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c4 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf10 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 64 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c48 to %c64 step %c1 {
            %0 = arith.subi %arg2, %c48 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf9 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 64 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c48 to %c64 step %c1 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = arith.subi %arg3, %c48 : index
                %3 = memref.load %reinterpret_cast[%0, %2] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                %4 = memref.load %reinterpret_cast_5[%arg2, %2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                %5 = arith.mulf %1, %3 : f32
                %6 = arith.addf %4, %5 : f32
                memref.store %6, %reinterpret_cast_5[%arg2, %2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_64", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_11(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_9(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_10(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_64_sequence(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_11 {
        aie.dma_bd(%arg3 : memref<32x64xf32> offset = 48 len = 512 sizes = [32, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_9 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 48 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 0 len = 1024 sizes = [4, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_48 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf8 = aie.buffer(%tile_0_2) {sym_name = "buf8"} : memref<2048xf32, 2 : i32> 
    %buf7 = aie.buffer(%tile_0_2) {sym_name = "buf7"} : memref<128xf32, 2 : i32> 
    %buf6 = aie.buffer(%tile_0_2) {sym_name = "buf6"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf7 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf8 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf6 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c32 = arith.constant 32 : index
      %c48 = arith.constant 48 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf8 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 48 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c4 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf7 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 48 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c32 to %c48 step %c1 {
            %0 = arith.subi %arg2, %c32 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf6 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 48 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c32 to %c48 step %c1 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = arith.subi %arg3, %c32 : index
                %3 = memref.load %reinterpret_cast[%0, %2] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                %4 = memref.load %reinterpret_cast_5[%arg2, %2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                %5 = arith.mulf %1, %3 : f32
                %6 = arith.addf %4, %5 : f32
                memref.store %6, %reinterpret_cast_5[%arg2, %2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_48", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_8(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_6(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_7(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_48_sequence(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_8 {
        aie.dma_bd(%arg3 : memref<32x64xf32> offset = 32 len = 512 sizes = [32, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 32 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 0 len = 1024 sizes = [4, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_32 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf5 = aie.buffer(%tile_0_2) {sym_name = "buf5"} : memref<2048xf32, 2 : i32> 
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<128xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf5 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf5 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c4 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c16 to %c32 step %c1 {
            %0 = arith.subi %arg2, %c16 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf3 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c16 to %c32 step %c1 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = arith.subi %arg3, %c16 : index
                %3 = memref.load %reinterpret_cast[%0, %2] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                %4 = memref.load %reinterpret_cast_5[%arg2, %2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                %5 = arith.mulf %1, %3 : f32
                %6 = arith.addf %4, %5 : f32
                memref.store %6, %reinterpret_cast_5[%arg2, %2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_32", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_5(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_32_sequence(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_5 {
        aie.dma_bd(%arg3 : memref<32x64xf32> offset = 16 len = 512 sizes = [32, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_3 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 16 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 0 len = 1024 sizes = [4, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf2 = aie.buffer(%tile_0_2) {sym_name = "buf2"} : memref<2048xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<128xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 16 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c4 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c0 to %c16 step %c1 {
            memref.store %cst, %reinterpret_cast_5[%arg1, %arg2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 16 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c1 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = memref.load %reinterpret_cast[%0, %arg3] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                %3 = memref.load %reinterpret_cast_5[%arg2, %arg3] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                %4 = arith.mulf %1, %2 : f32
                %5 = arith.addf %3, %4 : f32
                memref.store %5, %reinterpret_cast_5[%arg2, %arg3] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_2(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_sequence(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_2 {
        aie.dma_bd(%arg3 : memref<32x64xf32> offset = 0 len = 512 sizes = [32, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 0 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 0 len = 1024 sizes = [4, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @gemm_scale(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      aiex.configure @orbit_segment {
        aiex.run @orbit_segment_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>)
      }
      aiex.configure @orbit_segment_32 {
        aiex.run @orbit_segment_32_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>)
      }
      aiex.configure @orbit_segment_48 {
        aiex.run @orbit_segment_48_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>)
      }
      aiex.configure @orbit_segment_64 {
        aiex.run @orbit_segment_64_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>)
      }
      aiex.configure @orbit_segment_80 {
        aiex.run @orbit_segment_80_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>)
      }
    }
  }
}
