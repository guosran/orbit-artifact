#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.program_graph = "e87bc2e1c7e5eb3225a2a79218f3bba31afbfc91c116b0237ce686cb2b937e74"} {
  aie.device(npu2) @orbit_public_graph_configuration {
    %shim_noc_tile_1_0 = aie.tile(1, 0)
    %tile_1_5 = aie.tile(1, 5)
    %lock_1_5 = aie.lock(%tile_1_5, 3) {init = 1 : i32}
    %lock_1_5_0 = aie.lock(%tile_1_5, 2) {init = 0 : i32}
    %lock_1_5_1 = aie.lock(%tile_1_5, 1) {init = 1 : i32}
    %lock_1_5_2 = aie.lock(%tile_1_5, 0) {init = 0 : i32}
    %buf1 = aie.buffer(%tile_1_5) {sym_name = "buf1"} : memref<640xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_1_5) {sym_name = "buf0"} : memref<640xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<64x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<64x64xf32>
    %mem_1_5 = aie.mem(%tile_1_5) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_1_5_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<640xf32, 2 : i32> offset = 0 len = 640) {task_id = 0 : i32}
      aie.use_lock(%lock_1_5_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_1_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<640xf32, 2 : i32> offset = 0 len = 640) {task_id = 0 : i32}
      aie.use_lock(%lock_1_5_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_1_5 = aie.core(%tile_1_5) {
      %c1_i32 = arith.constant 1 : i32
      %c64 = arith.constant 64 : index
      %c54 = arith.constant 54 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_1_5_1, AcquireGreaterEqual, %c1_i32)
      aie.use_lock(%lock_1_5_0, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf1 to offset: [0], sizes: [10, 64], strides: [64, 1] {orbit.allocation = 15 : i64, orbit.logical_offsets = array<i64: 54, 0>, orbit.logical_sizes = array<i64: 10, 64>, orbit.storage_index = 0 : i64} : memref<640xf32, 2 : i32> to memref<10x64xf32, strided<[64, 1]>, 2 : i32>
      %reinterpret_cast_3 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [10, 64], strides: [64, 1] {orbit.allocation = 16 : i64, orbit.logical_offsets = array<i64: 54, 0>, orbit.logical_sizes = array<i64: 10, 64>, orbit.storage_index = 1 : i64} : memref<640xf32, 2 : i32> to memref<10x64xf32, strided<[64, 1]>, 2 : i32>
      scf.for %arg0 = %c54 to %c64 step %c1 {
        scf.for %arg1 = %c0 to %c64 step %c1 {
          %0 = arith.subi %arg0, %c54 : index
          %1 = memref.load %reinterpret_cast[%0, %arg1] : memref<10x64xf32, strided<[64, 1]>, 2 : i32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %reinterpret_cast_3[%0, %arg1] : memref<10x64xf32, strided<[64, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_1_5, Release, %c1_i32)
      aie.use_lock(%lock_1_5_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_1_5", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_1_0, DMA : 0, %tile_1_5, DMA : 0) 
    aie.flow(%tile_1_5, DMA : 0, %shim_noc_tile_1_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_1_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_1_0, MM2S, 0)
    aie.runtime_sequence @orbit_public_graph_configuration_sequence(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<11x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<64x64xf32> offset = 3456 len = 640 sizes = [10, 64] strides = [64, 1])
        aie.end
      } {air.preserve_shim_dma_order, issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<64x64xf32> offset = 3456 len = 640 sizes = [10, 64] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @pointwise(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<11x64xf32>) {
      aiex.configure @orbit_public_graph_configuration {
        aiex.run @orbit_public_graph_configuration_sequence(%arg0, %arg1, %arg2) : (memref<64x64xf32>, memref<64x64xf32>, memref<11x64xf32>)
      }
    }
  }
}
