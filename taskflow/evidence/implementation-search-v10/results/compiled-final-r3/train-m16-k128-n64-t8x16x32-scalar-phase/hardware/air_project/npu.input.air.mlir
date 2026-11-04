#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "607567cc304a77cdbff8ee2f6363e0c00ffccef001486af862b0bb3de42bb369", orbit.source_fingerprint = "60fbbfc305db9d3a0222fda474d495f9bcd30577ace8a68d554bcd4f73a110a9"} {
  aie.device(npu2) @orbit_segment_40 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<128xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<16x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 5.000000e-01 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c2 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf3 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_3 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
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
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_40", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_40_sequence(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg2 : memref<16x64xf32> offset = 0 len = 512 sizes = [2, 4, 8, 16] strides = [512, 16, 64, 1])
        aie.end
      } {issue_token = true, repeat_count = 1 : i32}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_3 {
        aie.dma_bd(%arg3 : memref<16x64xf32> offset = 0 len = 512 sizes = [2, 4, 8, 16] strides = [512, 16, 64, 1])
        aie.end
      } {repeat_count = 1 : i32}
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
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
    %buf2 = aie.buffer(%tile_0_2) {sym_name = "buf2"} : memref<128xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<512xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<16x128xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<128x64xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<512xf32, 2 : i32> offset = 0 len = 512) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c2 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c1 {
              memref.store %cst, %reinterpret_cast[%arg2, %arg3] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          scf.for %arg2 = %c0 to %c4 step %c1 {
            %reinterpret_cast_5 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 8 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
            %reinterpret_cast_6 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 8 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
            scf.for %arg3 = %c0 to %c8 step %c1 {
              scf.for %arg4 = %c0 to %c16 step %c1 {
                scf.for %arg5 = %c0 to %c32 step %c1 {
                  %0 = memref.load %reinterpret_cast_5[%arg3, %arg5] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  %1 = memref.load %reinterpret_cast_6[%arg5, %arg4] : memref<32x16xf32, strided<[16, 1]>, 2 : i32>
                  %2 = memref.load %reinterpret_cast[%arg3, %arg4] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                  %3 = arith.mulf %0, %1 : f32
                  %4 = arith.addf %2, %3 : f32
                  memref.store %4, %reinterpret_cast[%arg3, %arg4] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                } {loop_annotation = #loop_annotation}
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
            aie.use_lock(%lock_0_2_1, Release, %c1_i32)
            aie.use_lock(%lock_0_2, Release, %c1_i32)
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_4, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_2(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_sequence(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_2 {
        aie.dma_bd(%arg3 : memref<16x64xf32> offset = 0 len = 512 sizes = [2, 4, 8, 16] strides = [512, 16, 64, 1])
        aie.end
      } {issue_token = true, repeat_count = 1 : i32}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<16x128xf32> offset = 0 len = 1024 sizes = [4, 8, 32] strides = [32, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<16x128xf32> offset = 1024 len = 1024 sizes = [4, 8, 32] strides = [32, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 0 len = 8192 sizes = [4, 128, 16] strides = [16, 64, 1])
        aie.end
      } {repeat_count = 1 : i32}
      aiex.dma_start_task(%3)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @gemm_scale(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      aiex.configure @orbit_segment {
        aiex.run @orbit_segment_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>)
      }
      aiex.configure @orbit_segment_40 {
        aiex.run @orbit_segment_40_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>)
      }
    }
  }
}
