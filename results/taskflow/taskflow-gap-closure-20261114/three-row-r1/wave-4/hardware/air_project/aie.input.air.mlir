#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.program_graph = "cc11d5609d6c355258dcaaf3faef0ef9cbbde7108c96c04dbc4b113ca24d42f6"} {
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
    %tile_0_5 = aie.tile(0, 5)
    %lock_0_5 = aie.lock(%tile_0_5, 3) {init = 1 : i32}
    %lock_0_5_0 = aie.lock(%tile_0_5, 2) {init = 0 : i32}
    %lock_0_5_1 = aie.lock(%tile_0_5, 1) {init = 1 : i32}
    %lock_0_5_2 = aie.lock(%tile_0_5, 0) {init = 0 : i32}
    %buf1 = aie.buffer(%tile_0_5) {sym_name = "buf1"} : memref<640xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_5) {sym_name = "buf0"} : memref<640xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<64x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<64x64xf32>
    %mem_0_5 = aie.mem(%tile_0_5) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_5_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<640xf32, 2 : i32> offset = 0 len = 640) {task_id = 0 : i32}
      aie.use_lock(%lock_0_5_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<640xf32, 2 : i32> offset = 0 len = 640) {task_id = 0 : i32}
      aie.use_lock(%lock_0_5_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_5 = aie.core(%tile_0_5) {
      %c1_i32 = arith.constant 1 : i32
      %c64 = arith.constant 64 : index
      %c44 = arith.constant 44 : index
      %c54 = arith.constant 54 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%lock_0_5_1, AcquireGreaterEqual, %c1_i32)
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%lock_0_5_0, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf1 to offset: [0], sizes: [10, 64], strides: [64, 1] {orbit.allocation = 10 : i64, orbit.logical_offsets = array<i64: 44, 0>, orbit.logical_sizes = array<i64: 10, 64>, orbit.storage_index = 0 : i64} : memref<640xf32, 2 : i32> to memref<10x64xf32, strided<[64, 1]>, 2 : i32>
      %reinterpret_cast_3 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [10, 64], strides: [64, 1] {orbit.allocation = 11 : i64, orbit.logical_offsets = array<i64: 44, 0>, orbit.logical_sizes = array<i64: 10, 64>, orbit.storage_index = 1 : i64} : memref<640xf32, 2 : i32> to memref<10x64xf32, strided<[64, 1]>, 2 : i32>
      scf.for %arg0 = %c44 to %c54 step %c1 {
        scf.for %arg1 = %c0 to %c64 step %c1 {
          %0 = arith.subi %arg0, %c44 : index
          %1 = memref.load %reinterpret_cast[%0, %arg1] : memref<10x64xf32, strided<[64, 1]>, 2 : i32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %reinterpret_cast_3[%0, %arg1] : memref<10x64xf32, strided<[64, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_5, Release, %c1_i32)
      aie.use_lock(%lock_0_5_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_public_core_0_5", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    air.channel @channel_0 [1, 1]
    air.channel @channel_1 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_5, DMA : 0) 
    aie.flow(%tile_0_5, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  airrt.module_metadata{
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_public_graph_configuration"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 4 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 3 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 5 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_public_core_0_5"}
    }
  }
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  func.func @pointwise(%arg0: memref<64x64xf32> {orbit.name = "arg0", orbit.role = "input"}, %arg1: memref<64x64xf32> {orbit.name = "arg1", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_public_graph async (%arg2, %arg3) in (%arg4=%c1, %arg5=%c1) args(%arg6=%arg0, %arg7=%arg1) : memref<64x64xf32>, memref<64x64xf32> attributes {air.preserve_shim_dma_order, id = 1 : i32} {
      %c0 = arith.constant 0 : index
      %1 = air.channel.put async  @channel_0[%c0, %c0] (%arg6[44, 0] [10, 64] [64, 1]) {id = 1 : i32, metadataArray = [{base = "air_channel_0", index = 0 : i32}]} : (memref<64x64xf32>)
      %2 = air.channel.get async  @channel_1[%c0, %c0] (%arg7[44, 0] [10, 64] [64, 1]) {id = 2 : i32, metadataArray = [{base = "air_channel_1", index = 0 : i32}]} : (memref<64x64xf32>)
      %3 = air.segment @orbit_public_graph_configuration async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %4 = air.herd @orbit_public_core_0_5 async  tile (%arg8, %arg9) in (%arg10=%c1_0, %arg11=%c1_0) attributes {id = 3 : i32, orbit.spatial_owner = "npu.tile.0.5", x_loc = 0 : i64, y_loc = 5 : i64} {
          %c54 = arith.constant 54 : index
          %c44 = arith.constant 44 : index
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c0_2 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<640xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 10 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 10>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : memref<640xf32, 2 : i32>
            air.execute_terminator %alloc : memref<640xf32, 2 : i32>
          }
          %async_token_3, %results_4 = air.execute -> (memref<640xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 11 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 11>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : memref<640xf32, 2 : i32>
            air.execute_terminator %alloc : memref<640xf32, 2 : i32>
          }
          %5 = air.channel.get async  @channel_0[%arg8, %arg9] (%results[] [] []) {id = 3 : i32} : (memref<640xf32, 2 : i32>)
          air.wait_all [%5] 
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [10, 64], strides: [64, 1] {orbit.allocation = 10 : i64, orbit.logical_offsets = array<i64: 44, 0>, orbit.logical_sizes = array<i64: 10, 64>, orbit.storage_index = 0 : i64} : memref<640xf32, 2 : i32> to memref<10x64xf32, strided<[64, 1]>, 2 : i32>
          %reinterpret_cast_5 = memref.reinterpret_cast %results_4 to offset: [0], sizes: [10, 64], strides: [64, 1] {orbit.allocation = 11 : i64, orbit.logical_offsets = array<i64: 44, 0>, orbit.logical_sizes = array<i64: 10, 64>, orbit.storage_index = 1 : i64} : memref<640xf32, 2 : i32> to memref<10x64xf32, strided<[64, 1]>, 2 : i32>
          %6 = air.wait_all async 
          %7 = scf.for %arg12 = %c44 to %c54 step %c1_1 iter_args(%arg13 = %6) -> (!air.async.token) {
            %9 = scf.for %arg14 = %c0_2 to %c64 step %c1_1 iter_args(%arg15 = %arg13) -> (!air.async.token) {
              %10 = arith.subi %arg12, %c44 : index
              %async_token_8, %results_9 = air.execute [%arg15] -> (f32) {
                %13 = memref.load %reinterpret_cast[%10, %arg14] : memref<10x64xf32, strided<[64, 1]>, 2 : i32>
                air.execute_terminator %13 : f32
              }
              %11 = arith.addf %results_9, %results_9 : f32
              %async_token_10 = air.execute [%arg15] {
                memref.store %11, %reinterpret_cast_5[%10, %arg14] : memref<10x64xf32, strided<[64, 1]>, 2 : i32>
              }
              %12 = air.wait_all async [%async_token_8, %async_token_10] 
              scf.yield %12 : !air.async.token
            }
            scf.yield %9 : !air.async.token
          }
          %8 = air.channel.put async  @channel_1[%arg8, %arg9] (%results_4[] [] []) {id = 4 : i32} : (memref<640xf32, 2 : i32>)
          air.wait_all [%8] 
          %async_token_6 = air.execute [%async_token] {
            memref.dealloc %results : memref<640xf32, 2 : i32>
          }
          %async_token_7 = air.execute [%async_token_3] {
            memref.dealloc %results_4 : memref<640xf32, 2 : i32>
          }
        }
        air.wait_all [%4]  {air.segment_end}
      }
    }
    return
  }
}
