module attributes {orbit.program_graph = "9624db75476676b8912a474fde3f821bb03ebd74ad85621d079e3aad1510c3b5"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  func.func @pointwise(%arg0: memref<64x64xf32> {orbit.name = "arg0", orbit.role = "state"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_public_graph async (%arg1, %arg2) in (%arg3=%c1, %arg4=%c1) args(%arg5=%arg0) : memref<64x64xf32> attributes {air.preserve_shim_dma_order, id = 1 : i32} {
      %c0 = arith.constant 0 : index
      %1 = air.channel.put async  @channel_0[%c0, %c0] (%arg5[0, 0] [16, 64] [64, 1]) {id = 1 : i32} : (memref<64x64xf32>)
      %2 = air.channel.get async  @channel_1[%c0, %c0] (%arg5[0, 0] [16, 64] [64, 1]) {id = 2 : i32} : (memref<64x64xf32>)
      %3 = air.segment @orbit_public_graph_configuration async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %4 = air.herd @orbit_public_core_0_3 async  tile (%arg6, %arg7) in (%arg8=%c1_0, %arg9=%c1_0) attributes {id = 3 : i32, orbit.spatial_owner = "npu.tile.0.3", x_loc = 0 : i64, y_loc = 3 : i64} {
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c16 = arith.constant 16 : index
          %c0_2 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation_offsets_elements = array<i64: 0, 1024>, orbit.allocations = array<i64: 1, 2>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %5 = air.channel.get async  @channel_0[%arg6, %arg7] (%results[0] [1024] [1]) {id = 3 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%5] 
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [1024], sizes: [16, 64], strides: [64, 1] {orbit.allocation = 2 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : memref<2048xf32, 2 : i32> to memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
          %reinterpret_cast_3 = memref.reinterpret_cast %results to offset: [0], sizes: [16, 64], strides: [64, 1] {orbit.allocation = 1 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 16, 64>, orbit.storage_index = 0 : i64} : memref<2048xf32, 2 : i32> to memref<16x64xf32, strided<[64, 1]>, 2 : i32>
          %6 = air.wait_all async 
          %7 = scf.for %arg10 = %c0_2 to %c16 step %c1_1 iter_args(%arg11 = %6) -> (!air.async.token) {
            %10 = scf.for %arg12 = %c0_2 to %c64 step %c1_1 iter_args(%arg13 = %arg11) -> (!air.async.token) {
              %async_token_5, %results_6 = air.execute [%arg13] -> (f32) {
                %11 = memref.load %reinterpret_cast_3[%arg10, %arg12] : memref<16x64xf32, strided<[64, 1]>, 2 : i32>
                air.execute_terminator %11 : f32
              }
              %async_token_7 = air.execute [%async_token_5] {
                memref.store %results_6, %reinterpret_cast[%arg10, %arg12] : memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
              }
              scf.yield %async_token_7 : !air.async.token
            }
            scf.yield %10 : !air.async.token
          }
          %8 = scf.for %arg10 = %c0_2 to %c16 step %c1_1 iter_args(%arg11 = %7) -> (!air.async.token) {
            %10 = scf.for %arg12 = %c0_2 to %c64 step %c1_1 iter_args(%arg13 = %arg11) -> (!air.async.token) {
              %async_token_5, %results_6 = air.execute [%arg13] -> (f32) {
                %12 = memref.load %reinterpret_cast[%arg10, %arg12] : memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
                air.execute_terminator %12 : f32
              }
              %11 = arith.addf %results_6, %results_6 : f32
              %async_token_7 = air.execute [%async_token_5] {
                memref.store %11, %reinterpret_cast[%arg10, %arg12] : memref<16x64xf32, strided<[64, 1], offset: 1024>, 2 : i32>
              }
              scf.yield %async_token_7 : !air.async.token
            }
            scf.yield %10 : !air.async.token
          }
          %9 = air.channel.put async [%5]  @channel_1[%arg6, %arg7] (%results[1024] [1024] [1]) {id = 4 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%9] 
          %async_token_4 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%4]  {air.segment_end}
      }
    }
    return
  }
}
