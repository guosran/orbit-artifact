#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.program_graph = "56d85de044f0ae81ae42c9813028e4ae309654ba2a7c6529aea060f57c2e1c89"} {
  aie.device(npu2) @orbit_public_graph_configuration {
    %shim_noc_tile_1_0 = aie.tile(1, 0)
    %tile_1_3 = aie.tile(1, 3)
    %lock_1_3 = aie.lock(%tile_1_3, 3) {init = 1 : i32}
    %lock_1_3_0 = aie.lock(%tile_1_3, 2) {init = 0 : i32}
    %lock_1_3_1 = aie.lock(%tile_1_3, 1) {init = 1 : i32}
    %lock_1_3_2 = aie.lock(%tile_1_3, 0) {init = 0 : i32}
    %buf1 = aie.buffer(%tile_1_3) {sym_name = "buf1"} : memref<1024xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_1_3) {sym_name = "buf0"} : memref<1024xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<32x32xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x32xf32>
    %mem_1_3 = aie.mem(%tile_1_3) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_1_3_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {task_id = 0 : i32}
      aie.use_lock(%lock_1_3_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_1_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {task_id = 0 : i32}
      aie.use_lock(%lock_1_3_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_1_3 = aie.core(%tile_1_3) {
      %c1_i32 = arith.constant 1 : i32
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_1_3_1, AcquireGreaterEqual, %c1_i32)
      aie.use_lock(%lock_1_3_0, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf1 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 32, 32>, orbit.storage_index = 1 : i64} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
      %reinterpret_cast_3 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 32, 32>, orbit.storage_index = 2 : i64} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
      scf.for %arg0 = %c0 to %c32 step %c1 {
        scf.for %arg1 = %c0 to %c32 step %c1 {
          %0 = memref.load %reinterpret_cast_3[%arg0, %arg1] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
          memref.store %0, %reinterpret_cast[%arg0, %arg1] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_1_3, Release, %c1_i32)
      aie.use_lock(%lock_1_3_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_1_3", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_1_0, DMA : 0, %tile_1_3, DMA : 0) 
    aie.flow(%tile_1_3, DMA : 0, %shim_noc_tile_1_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_1_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_1_0, MM2S, 0)
    aie.runtime_sequence @orbit_public_graph_configuration_sequence(%arg0: memref<32x32xf32>, %arg1: memref<32x32xf32>, %arg2: memref<32x32xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<32x32xf32> offset = 0 len = 1024 sizes = [1024] strides = [1])
        aie.end
      } {air.preserve_shim_dma_order, issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg2 : memref<32x32xf32> offset = 0 len = 1024 sizes = [1024] strides = [1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @pointwise(%arg0: memref<32x32xf32>, %arg1: memref<32x32xf32>, %arg2: memref<32x32xf32>) {
      aiex.configure @orbit_public_graph_configuration {
        aiex.run @orbit_public_graph_configuration_sequence(%arg0, %arg1, %arg2) : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>)
      }
    }
  }
}
