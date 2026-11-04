#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.mapping_plan = "5c4478413012fb3cc41e079c227a93e1774c5756c5e5ee9dd5e8768e56bbd6c4", orbit.source_fingerprint = "60fbbfc305db9d3a0222fda474d495f9bcd30577ace8a68d554bcd4f73a110a9"} {
  aie.device(npu2) @orbit_segment_40 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf13 = aie.buffer(%tile_0_2) {sym_name = "buf13"} : memref<128xf32, 2 : i32> 
    %buf12 = aie.buffer(%tile_0_2) {sym_name = "buf12"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<16x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x64xf32>
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
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 5.000000e-01 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      scf.for %arg0 = %c0 to %c2 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf12 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_3 = memref.reinterpret_cast %buf13 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
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
    air.channel @channel_12 [1, 1]
    air.channel @channel_13 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_13(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_12(%shim_noc_tile_0_0, MM2S, 0)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_32 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
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
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c48 = arith.constant 48 : index
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf11 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf10 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c48 to %c64 step %c1 {
            %0 = arith.subi %arg2, %c48 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf9 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
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
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_32", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    air.channel @channel_9 [1, 1]
    air.channel @channel_10 [1, 1]
    air.channel @channel_11 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_11(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_9(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_10(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_24 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
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
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c32 = arith.constant 32 : index
      %c48 = arith.constant 48 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf8 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 24 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf7 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c32 to %c48 step %c1 {
            %0 = arith.subi %arg2, %c32 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf6 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 24 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
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
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_24", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    air.channel @channel_6 [1, 1]
    air.channel @channel_7 [1, 1]
    air.channel @channel_8 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_8(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_6(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_7(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_16 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
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
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf5 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 16 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c16 to %c32 step %c1 {
            %0 = arith.subi %arg2, %c16 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf3 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 16 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
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
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_16", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    air.channel @channel_3 [1, 1]
    air.channel @channel_4 [1, 1]
    air.channel @channel_5 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_5(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
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
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 8 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c0 to %c16 step %c1 {
            memref.store %cst, %reinterpret_cast_5[%arg1, %arg2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 8 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
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
    air.channel @channel_0 [1, 1]
    air.channel @channel_1 [1, 1]
    air.channel @channel_2 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_2(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  airrt.module_metadata{
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 6 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 4 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 5 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_16"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 12 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 10 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 11 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_16"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_24"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 18 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 16 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 17 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_24"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_32"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 24 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 22 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 23 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_32"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_40"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 28 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 27 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_40"}
    }
  }
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  air.channel @channel_2 [1, 1]
  air.channel @channel_3 [1, 1]
  air.channel @channel_4 [1, 1]
  air.channel @channel_5 [1, 1]
  air.channel @channel_6 [1, 1]
  air.channel @channel_7 [1, 1]
  air.channel @channel_8 [1, 1]
  air.channel @channel_9 [1, 1]
  air.channel @channel_10 [1, 1]
  air.channel @channel_11 [1, 1]
  air.channel @channel_12 [1, 1]
  air.channel @channel_13 [1, 1]
  func.func @gemm_scale(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32> attributes {id = 1 : i32} {
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_0[%c0, %c0] (%arg9[0, 0] [128, 16] [64, 1]) {id = 1 : i32, metadataArray = [{base = "air_channel_0", index = 0 : i32}]} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_1[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 2 : i32, metadataArray = [{base = "air_channel_1", index = 0 : i32}]} : (memref<16x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_2[%c0, %c0] (%arg10[%11, 0] [8, 16] [64, 1]) {id = 3 : i32, metadataArray = [{base = "air_channel_2", index = 0 : i32}]} : (memref<16x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c32_2 = arith.constant 32 : index
          %c16 = arith.constant 16 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c2_5 = arith.constant 2 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 8 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_0[%arg11, %arg12] (%results[] [] []) {id = 4 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c2_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c0_6 to %c16 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %arg19] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 8 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_1[%arg11, %arg12] (%results_13[] [] []) {id = 5 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 3 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.read_copies = array<i64: 24, 25, 29>, orbit.task = "gemm", orbit.write_copies = array<i64: 30>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c0_6 to %c16 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %27 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %27 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %27 = memref.load %reinterpret_cast[%23, %arg21] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %27 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %27 = memref.load %reinterpret_cast_10[%arg19, %arg21] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %27 : f32
                    }
                    %24 = arith.mulf %results_17, %results_19 : f32
                    %25 = arith.addf %results_21, %24 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %25, %reinterpret_cast_10[%arg19, %arg21] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %26 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %26 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_2[%arg11, %arg12] (%results_9[] [] []) {id = 6 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 2 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_16 async [%0] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32> attributes {id = 4 : i32} {
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_3[%c0, %c0] (%arg9[0, 16] [128, 16] [64, 1]) {id = 7 : i32, metadataArray = [{base = "air_channel_3", index = 0 : i32}]} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_4[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 8 : i32, metadataArray = [{base = "air_channel_4", index = 0 : i32}]} : (memref<16x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_5[%c0, %c0] (%arg10[%11, 16] [8, 16] [64, 1]) {id = 9 : i32, metadataArray = [{base = "air_channel_5", index = 0 : i32}]} : (memref<16x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_16 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_16 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c32_2 = arith.constant 32 : index
          %c16 = arith.constant 16 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c2_5 = arith.constant 2 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 16 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_3[%arg11, %arg12] (%results[] [] []) {id = 10 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c2_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c16 to %c32_2 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c16 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 16 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_4[%arg11, %arg12] (%results_13[] [] []) {id = 11 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 24 : i64, orbit.phase = 16 : i64, orbit.phase_dependencies = array<i64: 15>, orbit.read_copies = array<i64: 48, 49, 53>, orbit.task = "gemm", orbit.write_copies = array<i64: 54>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c16 to %c32_2 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %24 = arith.subi %arg21, %c16 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast[%23, %24] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %25 = arith.mulf %results_17, %results_19 : f32
                    %26 = arith.addf %results_21, %25 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %26, %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %27 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_5[%arg11, %arg12] (%results_9[] [] []) {id = 12 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 2 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %2 = air.launch @orbit_launch_24 async [%1] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32> attributes {id = 7 : i32} {
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_6[%c0, %c0] (%arg9[0, 32] [128, 16] [64, 1]) {id = 13 : i32, metadataArray = [{base = "air_channel_6", index = 0 : i32}]} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_7[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 14 : i32, metadataArray = [{base = "air_channel_7", index = 0 : i32}]} : (memref<16x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_8[%c0, %c0] (%arg10[%11, 32] [8, 16] [64, 1]) {id = 15 : i32, metadataArray = [{base = "air_channel_8", index = 0 : i32}]} : (memref<16x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_24 async  attributes {id = 8 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_24 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 9 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c48 = arith.constant 48 : index
          %c32_2 = arith.constant 32 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c2_5 = arith.constant 2 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 24 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_6[%arg11, %arg12] (%results[] [] []) {id = 16 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c2_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c32_2 to %c48 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c32_2 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 24 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_7[%arg11, %arg12] (%results_13[] [] []) {id = 17 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 45 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 72, 73, 77>, orbit.task = "gemm", orbit.write_copies = array<i64: 78>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c32_2 to %c48 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %24 = arith.subi %arg21, %c32_2 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast[%23, %24] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %25 = arith.mulf %results_17, %results_19 : f32
                    %26 = arith.addf %results_21, %25 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %26, %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %27 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_8[%arg11, %arg12] (%results_9[] [] []) {id = 18 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 2 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %3 = air.launch @orbit_launch_32 async [%2] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32> attributes {id = 10 : i32} {
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_9[%c0, %c0] (%arg9[0, 48] [128, 16] [64, 1]) {id = 19 : i32, metadataArray = [{base = "air_channel_9", index = 0 : i32}]} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_10[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 20 : i32, metadataArray = [{base = "air_channel_10", index = 0 : i32}]} : (memref<16x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c2 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_11[%c0, %c0] (%arg10[%11, 48] [8, 16] [64, 1]) {id = 21 : i32, metadataArray = [{base = "air_channel_11", index = 0 : i32}]} : (memref<16x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_32 async  attributes {id = 11 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_32 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 12 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c32_2 = arith.constant 32 : index
          %c64 = arith.constant 64 : index
          %c48 = arith.constant 48 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c2_5 = arith.constant 2 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_9[%arg11, %arg12] (%results[] [] []) {id = 22 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c2_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c48 to %c64 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c48 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_10[%arg11, %arg12] (%results_13[] [] []) {id = 23 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 66 : i64, orbit.phase = 32 : i64, orbit.phase_dependencies = array<i64: 31>, orbit.read_copies = array<i64: 96, 97, 101>, orbit.task = "gemm", orbit.write_copies = array<i64: 102>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c48 to %c64 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %24 = arith.subi %arg21, %c48 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast[%23, %24] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %25 = arith.mulf %results_17, %results_19 : f32
                    %26 = arith.addf %results_21, %25 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %26, %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %27 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_11[%arg11, %arg12] (%results_9[] [] []) {id = 24 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 2 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %4 = air.launch @orbit_launch_40 async [%3] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<16x64xf32>, memref<16x64xf32> attributes {id = 13 : i32} {
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.wait_all async 
      %6 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %5) -> (!air.async.token) {
        %10 = arith.muli %arg10, %c8 : index
        %11 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %12 = arith.muli %arg12, %c16 : index
          %13 = air.channel.put async [%arg13]  @channel_12[%c0, %c0] (%arg9[%10, %12] [8, 16] [64, 1]) {id = 25 : i32, metadataArray = [{base = "air_channel_12", index = 0 : i32}]} : (memref<16x64xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %7 = air.wait_all async 
      %8 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %7) -> (!air.async.token) {
        %10 = arith.muli %arg10, %c8 : index
        %11 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %12 = arith.muli %arg12, %c16 : index
          %13 = air.channel.get async [%arg13]  @channel_13[%c0, %c0] (%arg8[%10, %12] [8, 16] [64, 1]) {id = 26 : i32, metadataArray = [{base = "air_channel_13", index = 0 : i32}]} : (memref<16x64xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %9 = air.segment @orbit_segment_40 async  attributes {id = 14 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %10 = air.herd @orbit_herd_40 async  tile (%arg10, %arg11) in (%arg12=%c1_1, %arg13=%c1_1) attributes {id = 15 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 5.000000e-01 : f32
          %c16_2 = arith.constant 16 : index
          %c4_3 = arith.constant 4 : index
          %c8_4 = arith.constant 8 : index
          %c1_5 = arith.constant 1 : index
          %c2_6 = arith.constant 2 : index
          %c0_7 = arith.constant 0 : index
          %11 = air.wait_all async 
          %12 = scf.for %arg14 = %c0_7 to %c2_6 step %c1_5 iter_args(%arg15 = %11) -> (!air.async.token) {
            %13 = scf.for %arg16 = %c0_7 to %c4_3 step %c1_5 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : memref<128xf32, 2 : i32>
                air.execute_terminator %alloc : memref<128xf32, 2 : i32>
              }
              %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<128xf32, 2 : i32>
                air.execute_terminator %alloc : memref<128xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %14 = air.channel.get async [%async_token, %arg17]  @channel_12[%arg10, %arg11] (%results[] [] []) {id = 27 : i32} : (memref<128xf32, 2 : i32>)
              air.wait_all [%14]  {orbit.computation_event = 85 : i64, orbit.phase = 40 : i64, orbit.phase_dependencies = array<i64: 39>, orbit.read_copies = array<i64: 120>, orbit.task = "scale", orbit.write_copies = array<i64: 121>}
              %15 = scf.for %arg18 = %c0_7 to %c8_4 step %c1_5 iter_args(%arg19 = %14) -> (!air.async.token) {
                %17 = scf.for %arg20 = %c0_7 to %c16_2 step %c1_5 iter_args(%arg21 = %arg19) -> (!air.async.token) {
                  %async_token_13, %results_14 = air.execute [%arg21] -> (f32) {
                    %20 = memref.load %reinterpret_cast_10[%arg18, %arg20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    air.execute_terminator %20 : f32
                  }
                  %18 = arith.mulf %results_14, %cst : f32
                  %async_token_15 = air.execute [%arg21] {
                    memref.store %18, %reinterpret_cast[%arg18, %arg20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  %19 = air.wait_all async [%async_token_13, %async_token_15] 
                  scf.yield %19 : !air.async.token
                }
                scf.yield %17 : !air.async.token
              }
              %16 = air.channel.put async [%async_token_8, %15]  @channel_13[%arg10, %arg11] (%results_9[] [] []) {id = 28 : i32} : (memref<128xf32, 2 : i32>)
              %async_token_11 = air.execute [%16] {
                memref.dealloc %results_9 : memref<128xf32, 2 : i32>
              }
              %async_token_12 = air.execute [%14] {
                memref.dealloc %results : memref<128xf32, 2 : i32>
              }
              scf.yield %16 : !air.async.token
            } {orbit.compressed_phases = 4 : i64}
            scf.yield %13 : !air.async.token
          } {orbit.compressed_phases = 2 : i64}
          air.wait_all [%12] 
        }
        air.wait_all [%10]  {air.segment_end}
      }
    }
    return
  }
}
