module attributes {orbit.program_graph = "3b62fd47edb2a6130afda526396e196deab0aa9ace201343f4aa7e2b987b74e0"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  func.func @pointwise(%arg0: memref<64x64xf32> {orbit.name = "arg0", orbit.role = "input"}, %arg1: memref<64x64xf32> {orbit.name = "arg1", orbit.role = "output"}, %arg2: memref<64x64xf32> {orbit.name = "alloc2", orbit.role = "temporary"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_public_graph async (%arg3, %arg4) in (%arg5=%c1, %arg6=%c1) args(%arg7=%arg1, %arg8=%arg2) : memref<64x64xf32>, memref<64x64xf32> attributes {air.preserve_shim_dma_order, id = 1 : i32} {
      %c0 = arith.constant 0 : index
      %1 = air.channel.put async  @channel_0[%c0, %c0] (%arg8[32, 0] [16, 64] [64, 1]) {id = 1 : i32} : (memref<64x64xf32>)
      %2 = air.channel.get async  @channel_1[%c0, %c0] (%arg7[32, 0] [16, 64] [64, 1]) {id = 2 : i32} : (memref<64x64xf32>)
      %3 = air.segment @orbit_public_graph_configuration async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %4 = air.herd @orbit_public_core_0_4 async  tile (%arg9, %arg10) in (%arg11=%c1_0, %arg12=%c1_0) attributes {id = 3 : i32, orbit.spatial_owner = "npu.tile.0.4", x_loc = 0 : i64, y_loc = 4 : i64} {
          %c48 = arith.constant 48 : index
          %c32 = arith.constant 32 : index
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c0_2 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<1024xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 6 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 6>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : memref<1024xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
          }
          %async_token_3, %results_4 = air.execute -> (memref<1024xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 16 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 16>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : memref<1024xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
          }
          %async_token_5, %results_6 = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation_offsets_elements = array<i64: 0, 1024>, orbit.allocations = array<i64: 7, 15>, orbit.storage_index = 2 : i64, orbit.tile_pool = "public-storage-2"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %5 = air.channel.get async  @channel_0[%arg9, %arg10] (%results_6[1024] [1024] [1]) {id = 3 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%5] 
          %reinterpret_cast = memref.reinterpret_cast %results_4 to offset: [0], sizes: [16, 64], strides: [64, 1] {orbit.allocation = 16 : i64, orbit.logical_offsets = array<i64: 32, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 1 : i64} : memref<1024xf32, 2 : i32> to memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %reinterpret_cast_7 = memref.reinterpret_cast %results_6 to offset: [1024], sizes: [16, 64], strides: [64, 1] {orbit.allocation = 15 : i64, orbit.logical_offsets = array<i64: 32, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 2 : i64} : memref<2048xf32, 2 : i32> to memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
          %6 = air.wait_all async 
          %7 = scf.for %arg13 = %c32 to %c48 step %c1_1 iter_args(%arg14 = %6) -> (!air.async.token) {
            %9 = scf.for %arg15 = %c0_2 to %c64 step %c1_1 iter_args(%arg16 = %arg14) -> (!air.async.token) {
              %10 = arith.subi %arg13, %c32 : index
              %async_token_11, %results_12 = air.execute [%arg16] -> (f32) {
                %11 = memref.load %reinterpret_cast_7[%10, %arg15] : memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
                air.execute_terminator %11 : f32
              }
              %async_token_13 = air.execute [%arg16] {
                memref.store %results_12, %reinterpret_cast[%10, %arg15] : memref<16x64xf32, strided<[64, 1]>, 2 : i32>
              }
              scf.yield %async_token_13 : !air.async.token
            }
            scf.yield %9 : !air.async.token
          }
          %8 = air.channel.put async  @channel_1[%arg9, %arg10] (%results_4[] [] []) {id = 4 : i32} : (memref<1024xf32, 2 : i32>)
          air.wait_all [%8] 
          %async_token_8 = air.execute [%async_token] {
            memref.dealloc %results : memref<1024xf32, 2 : i32>
          }
          %async_token_9 = air.execute [%async_token_5] {
            memref.dealloc %results_6 : memref<2048xf32, 2 : i32>
          }
          %async_token_10 = air.execute [%async_token_3] {
            memref.dealloc %results_4 : memref<1024xf32, 2 : i32>
          }
        }
        air.wait_all [%4]  {air.segment_end}
      }
    }
    return
  }
}
