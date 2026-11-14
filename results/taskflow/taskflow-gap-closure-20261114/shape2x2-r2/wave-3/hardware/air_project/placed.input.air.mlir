module attributes {orbit.program_graph = "b6dfd4b6d43fe82ec3556dd85005bdc3318e1862cbf587b87ea4639ceb24eb8c"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  func.func @pointwise(%arg0: memref<64x64xf32> {orbit.name = "arg0", orbit.role = "input"}, %arg1: memref<64x64xf32> {orbit.name = "arg1", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_public_graph async (%arg2, %arg3) in (%arg4=%c1, %arg5=%c1) args(%arg6=%arg0, %arg7=%arg1) : memref<64x64xf32>, memref<64x64xf32> attributes {air.preserve_shim_dma_order, id = 1 : i32} {
      %c0 = arith.constant 0 : index
      %1 = air.channel.put async  @channel_0[%c0, %c0] (%arg6[48, 0] [16, 64] [64, 1]) {id = 1 : i32} : (memref<64x64xf32>)
      %2 = air.channel.get async  @channel_1[%c0, %c0] (%arg7[48, 0] [16, 64] [64, 1]) {id = 2 : i32} : (memref<64x64xf32>)
      %3 = air.segment @orbit_public_graph_configuration async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %4 = air.herd @orbit_public_core_1_4 async  tile (%arg8, %arg9) in (%arg10=%c1_0, %arg11=%c1_0) attributes {id = 3 : i32, orbit.spatial_owner = "npu.tile.1.4", x_loc = 1 : i64, y_loc = 4 : i64} {
          %c48 = arith.constant 48 : index
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c0_2 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<1024xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 8 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 8>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : memref<1024xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
          }
          %async_token_3, %results_4 = air.execute -> (memref<1024xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 9 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 9>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : memref<1024xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
          }
          %5 = air.channel.get async  @channel_0[%arg8, %arg9] (%results[] [] []) {id = 3 : i32} : (memref<1024xf32, 2 : i32>)
          air.wait_all [%5] 
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [16, 64], strides: [64, 1] {orbit.allocation = 8 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : memref<1024xf32, 2 : i32> to memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %reinterpret_cast_5 = memref.reinterpret_cast %results_4 to offset: [0], sizes: [16, 64], strides: [64, 1] {orbit.allocation = 9 : i64, orbit.logical_offsets = array<i64: 48, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 1 : i64} : memref<1024xf32, 2 : i32> to memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %6 = air.wait_all async 
          %7 = scf.for %arg12 = %c48 to %c64 step %c1_1 iter_args(%arg13 = %6) -> (!air.async.token) {
            %9 = scf.for %arg14 = %c0_2 to %c64 step %c1_1 iter_args(%arg15 = %arg13) -> (!air.async.token) {
              %10 = arith.subi %arg12, %c48 : index
              %async_token_8, %results_9 = air.execute [%arg15] -> (f32) {
                %13 = memref.load %reinterpret_cast[%10, %arg14] : memref<16x64xf32, strided<[64, 1]>, 2 : i32>
                air.execute_terminator %13 : f32
              }
              %11 = arith.addf %results_9, %results_9 : f32
              %async_token_10 = air.execute [%arg15] {
                memref.store %11, %reinterpret_cast_5[%10, %arg14] : memref<16x64xf32, strided<[64, 1]>, 2 : i32>
              }
              %12 = air.wait_all async [%async_token_8, %async_token_10] 
              scf.yield %12 : !air.async.token
            }
            scf.yield %9 : !air.async.token
          }
          %8 = air.channel.put async  @channel_1[%arg8, %arg9] (%results_4[] [] []) {id = 4 : i32} : (memref<1024xf32, 2 : i32>)
          air.wait_all [%8] 
          %async_token_6 = air.execute [%async_token] {
            memref.dealloc %results : memref<1024xf32, 2 : i32>
          }
          %async_token_7 = air.execute [%async_token_3] {
            memref.dealloc %results_4 : memref<1024xf32, 2 : i32>
          }
        }
        air.wait_all [%4]  {air.segment_end}
      }
    }
    return
  }
}
