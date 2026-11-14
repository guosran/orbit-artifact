#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.program_graph = "e87bc2e1c7e5eb3225a2a79218f3bba31afbfc91c116b0237ce686cb2b937e74"} {
  aie.device(npu2) @orbit_public_graph_configuration {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_3 = aie.tile(0, 3)
    %lock_0_3 = aie.lock(%tile_0_3, 3) {init = 1 : i32}
    %lock_0_3_0 = aie.lock(%tile_0_3, 2) {init = 0 : i32}
    %lock_0_3_1 = aie.lock(%tile_0_3, 1) {init = 1 : i32}
    %lock_0_3_2 = aie.lock(%tile_0_3, 0) {init = 0 : i32}
    %buf2 = aie.buffer(%tile_0_3) {sym_name = "buf2"} : memref<704xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_3) {sym_name = "buf1"} : memref<704xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_3) {sym_name = "buf0"} : memref<1408xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<64x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<11x64xf32>
    %mem_0_3 = aie.mem(%tile_0_3) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_3_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<1408xf32, 2 : i32> offset = 0 len = 704) {task_id = 0 : i32}
      aie.use_lock(%lock_0_3_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<704xf32, 2 : i32> offset = 0 len = 704) {task_id = 0 : i32}
      aie.use_lock(%lock_0_3_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_3 = aie.core(%tile_0_3) {
      %c1_i32 = arith.constant 1 : i32
      %c64 = arith.constant 64 : index
      %c11 = arith.constant 11 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%lock_0_3_1, AcquireGreaterEqual, %c1_i32)
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%lock_0_3_0, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [11, 64], strides: [64, 1] {orbit.allocation = 1 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 0 : i64} : memref<704xf32, 2 : i32> to memref<11x64xf32, strided<[64, 1]>, 2 : i32>
      %reinterpret_cast_3 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [11, 64], strides: [64, 1] {orbit.allocation = 2 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 2 : i64} : memref<1408xf32, 2 : i32> to memref<11x64xf32, strided<[64, 1]>, 2 : i32>
      scf.for %arg0 = %c0 to %c11 step %c1 {
        scf.for %arg1 = %c0 to %c64 step %c1 {
          %0 = memref.load %reinterpret_cast[%arg0, %arg1] : memref<11x64xf32, strided<[64, 1]>, 2 : i32>
          %1 = arith.addf %0, %0 : f32
          memref.store %1, %reinterpret_cast_3[%arg0, %arg1] : memref<11x64xf32, strided<[64, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_3, Release, %c1_i32)
      aie.use_lock(%lock_0_3_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_0_3", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    air.channel @channel_0 [1, 1]
    air.channel @channel_1 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_3, DMA : 0) 
    aie.flow(%tile_0_3, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  airrt.module_metadata{
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_public_graph_configuration"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 4 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 3 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 3 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_public_core_0_3"}
    }
  }
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  func.func @pointwise(%arg0: memref<64x64xf32> {orbit.name = "arg0", orbit.role = "input"}, %arg1: memref<64x64xf32> {orbit.name = "arg1", orbit.role = "output"}, %arg2: memref<11x64xf32> {orbit.name = "alloc2", orbit.role = "temporary"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_public_graph async (%arg3, %arg4) in (%arg5=%c1, %arg6=%c1) args(%arg7=%arg0, %arg8=%arg2) : memref<64x64xf32>, memref<11x64xf32> attributes {air.preserve_shim_dma_order, id = 1 : i32} {
      %c0 = arith.constant 0 : index
      %1 = air.channel.put async  @channel_0[%c0, %c0] (%arg7[0, 0] [11, 64] [64, 1]) {id = 1 : i32, metadataArray = [{base = "air_channel_0", index = 0 : i32}]} : (memref<64x64xf32>)
      %2 = air.channel.get async  @channel_1[%c0, %c0] (%arg8[] [] []) {id = 2 : i32, metadataArray = [{base = "air_channel_1", index = 0 : i32}]} : (memref<11x64xf32>)
      %3 = air.segment @orbit_public_graph_configuration async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %4 = air.herd @orbit_public_core_0_3 async  tile (%arg9, %arg10) in (%arg11=%c1_0, %arg12=%c1_0) attributes {id = 3 : i32, orbit.spatial_owner = "npu.tile.0.3", x_loc = 0 : i64, y_loc = 3 : i64} {
          %c11 = arith.constant 11 : index
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c0_2 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<704xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 1 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 1>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : memref<704xf32, 2 : i32>
            air.execute_terminator %alloc : memref<704xf32, 2 : i32>
          }
          %async_token_3, %results_4 = air.execute -> (memref<704xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 5 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 5>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : memref<704xf32, 2 : i32>
            air.execute_terminator %alloc : memref<704xf32, 2 : i32>
          }
          %async_token_5, %results_6 = air.execute -> (memref<1408xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation_offsets_elements = array<i64: 0, 704>, orbit.allocations = array<i64: 2, 4>, orbit.storage_index = 2 : i64, orbit.tile_pool = "public-storage-2"} : memref<1408xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1408xf32, 2 : i32>
          }
          %5 = air.channel.get async  @channel_0[%arg9, %arg10] (%results[] [] []) {id = 3 : i32} : (memref<704xf32, 2 : i32>)
          air.wait_all [%5] 
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [11, 64], strides: [64, 1] {orbit.allocation = 1 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 0 : i64} : memref<704xf32, 2 : i32> to memref<11x64xf32, strided<[64, 1]>, 2 : i32>
          %reinterpret_cast_7 = memref.reinterpret_cast %results_6 to offset: [0], sizes: [11, 64], strides: [64, 1] {orbit.allocation = 2 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 2 : i64} : memref<1408xf32, 2 : i32> to memref<11x64xf32, strided<[64, 1]>, 2 : i32>
          %6 = air.wait_all async 
          %7 = scf.for %arg13 = %c0_2 to %c11 step %c1_1 iter_args(%arg14 = %6) -> (!air.async.token) {
            %9 = scf.for %arg15 = %c0_2 to %c64 step %c1_1 iter_args(%arg16 = %arg14) -> (!air.async.token) {
              %async_token_11, %results_12 = air.execute [%arg16] -> (f32) {
                %12 = memref.load %reinterpret_cast[%arg13, %arg15] : memref<11x64xf32, strided<[64, 1]>, 2 : i32>
                air.execute_terminator %12 : f32
              }
              %10 = arith.addf %results_12, %results_12 : f32
              %async_token_13 = air.execute [%arg16] {
                memref.store %10, %reinterpret_cast_7[%arg13, %arg15] : memref<11x64xf32, strided<[64, 1]>, 2 : i32>
              }
              %11 = air.wait_all async [%async_token_11, %async_token_13] 
              scf.yield %11 : !air.async.token
            }
            scf.yield %9 : !air.async.token
          }
          %8 = air.channel.put async  @channel_1[%arg9, %arg10] (%results_6[0] [704] [1]) {id = 4 : i32} : (memref<1408xf32, 2 : i32>)
          air.wait_all [%8] 
          %async_token_8 = air.execute [%async_token] {
            memref.dealloc %results : memref<704xf32, 2 : i32>
          }
          %async_token_9 = air.execute [%async_token_5] {
            memref.dealloc %results_6 : memref<1408xf32, 2 : i32>
          }
          %async_token_10 = air.execute [%async_token_3] {
            memref.dealloc %results_4 : memref<704xf32, 2 : i32>
          }
        }
        air.wait_all [%4]  {air.segment_end}
      }
    }
    return
  }
}
