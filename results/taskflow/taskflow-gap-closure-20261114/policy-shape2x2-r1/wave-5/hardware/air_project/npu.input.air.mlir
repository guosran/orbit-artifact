#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.program_graph = "0c949f6a8f8fb604f1763fd00dc7c3fc7533c049cea93f90e62adb6c1b53f303"} {
  aie.device(npu2) @orbit_public_graph_configuration {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_4 = aie.tile(0, 4)
    %lock_0_4 = aie.lock(%tile_0_4, 3) {init = 1 : i32}
    %lock_0_4_0 = aie.lock(%tile_0_4, 2) {init = 0 : i32}
    %lock_0_4_1 = aie.lock(%tile_0_4, 1) {init = 1 : i32}
    %lock_0_4_2 = aie.lock(%tile_0_4, 0) {init = 0 : i32}
    %buf1 = aie.buffer(%tile_0_4) {sym_name = "buf1"} : memref<512xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_4) {sym_name = "buf0"} : memref<512xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<64x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<64x64xf32>
    %mem_0_4 = aie.mem(%tile_0_4) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_4_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<512xf32, 2 : i32> offset = 0 len = 512) {task_id = 0 : i32}
      aie.use_lock(%lock_0_4_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<512xf32, 2 : i32> offset = 0 len = 512) {task_id = 0 : i32}
      aie.use_lock(%lock_0_4_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_4 = aie.core(%tile_0_4) {
      %c1_i32 = arith.constant 1 : i32
      %c64 = arith.constant 64 : index
      %c48 = arith.constant 48 : index
      %c40 = arith.constant 40 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_4_1, AcquireGreaterEqual, %c1_i32)
      aie.use_lock(%lock_0_4_0, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf1 to offset: [0], sizes: [8, 64], strides: [64, 1] {orbit.allocation = 6 : i64, orbit.logical_offsets = array<i64: 40, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 0 : i64} : memref<512xf32, 2 : i32> to memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      %reinterpret_cast_3 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [8, 64], strides: [64, 1] {orbit.allocation = 7 : i64, orbit.logical_offsets = array<i64: 40, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 1 : i64} : memref<512xf32, 2 : i32> to memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      scf.for %arg0 = %c40 to %c48 step %c1 {
        scf.for %arg1 = %c0 to %c64 step %c1 {
          %0 = arith.subi %arg0, %c40 : index
          %1 = memref.load %reinterpret_cast[%0, %arg1] : memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %reinterpret_cast_3[%0, %arg1] : memref<8x64xf32, strided<[64, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_4, Release, %c1_i32)
      aie.use_lock(%lock_0_4_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_0_4", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_4, DMA : 0) 
    aie.flow(%tile_0_4, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_public_graph_configuration_sequence(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<64x64xf32> offset = 2560 len = 512 sizes = [8, 64] strides = [64, 1])
        aie.end
      } {air.preserve_shim_dma_order, issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<64x64xf32> offset = 2560 len = 512 sizes = [8, 64] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @pointwise(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>) {
      aiex.configure @orbit_public_graph_configuration {
        aiex.run @orbit_public_graph_configuration_sequence(%arg0, %arg1) : (memref<64x64xf32>, memref<64x64xf32>)
      }
    }
  }
}
