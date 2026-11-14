module attributes {orbit.program_graph = "0c949f6a8f8fb604f1763fd00dc7c3fc7533c049cea93f90e62adb6c1b53f303"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  func.func @pointwise(%arg0: memref<64x64xf32> {orbit.name = "arg0", orbit.role = "input"}, %arg1: memref<64x64xf32> {orbit.name = "arg1", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_public_graph async (%arg2, %arg3) in (%arg4=%c1, %arg5=%c1) args(%arg6=%arg0, %arg7=%arg1) : memref<64x64xf32>, memref<64x64xf32> attributes {air.preserve_shim_dma_order, id = 1 : i32} {
      %c0 = arith.constant 0 : index
      %1 = air.channel.put async  @channel_0[%c0, %c0] (%arg6[24, 0] [8, 64] [64, 1]) {id = 1 : i32} : (memref<64x64xf32>)
      %2 = air.channel.get async  @channel_1[%c0, %c0] (%arg7[24, 0] [8, 64] [64, 1]) {id = 2 : i32} : (memref<64x64xf32>)
      %3 = air.segment @orbit_public_graph_configuration async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %4 = air.herd @orbit_public_core_1_3 async  tile (%arg8, %arg9) in (%arg10=%c1_0, %arg11=%c1_0) attributes {id = 3 : i32, orbit.spatial_owner = "npu.tile.1.3", x_loc = 1 : i64, y_loc = 3 : i64} {
          %c24 = arith.constant 24 : index
          %c32 = arith.constant 32 : index
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c0_2 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<512xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 4 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 4>, orbit.storage_index = 0 : i64, orbit.tile_pool = "public-storage-0"} : memref<512xf32, 2 : i32>
            air.execute_terminator %alloc : memref<512xf32, 2 : i32>
          }
          %async_token_3, %results_4 = air.execute -> (memref<512xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.allocation = 5 : i64, orbit.allocation_offsets_elements = array<i64: 0>, orbit.allocations = array<i64: 5>, orbit.storage_index = 1 : i64, orbit.tile_pool = "public-storage-1"} : memref<512xf32, 2 : i32>
            air.execute_terminator %alloc : memref<512xf32, 2 : i32>
          }
          %5 = air.channel.get async  @channel_0[%arg8, %arg9] (%results[] [] []) {id = 3 : i32} : (memref<512xf32, 2 : i32>)
          air.wait_all [%5] 
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [8, 64], strides: [64, 1] {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 24, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 0 : i64} : memref<512xf32, 2 : i32> to memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %reinterpret_cast_5 = memref.reinterpret_cast %results_4 to offset: [0], sizes: [8, 64], strides: [64, 1] {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 24, 0>, orbit.logical_sizes = array<i64: 8, 64>, orbit.storage_index = 1 : i64} : memref<512xf32, 2 : i32> to memref<8x64xf32, strided<[64, 1]>, 2 : i32>
          %6 = air.wait_all async 
          %7 = scf.for %arg12 = %c24 to %c32 step %c1_1 iter_args(%arg13 = %6) -> (!air.async.token) {
            %9 = scf.for %arg14 = %c0_2 to %c64 step %c1_1 iter_args(%arg15 = %arg13) -> (!air.async.token) {
              %10 = arith.subi %arg12, %c24 : index
              %async_token_8, %results_9 = air.execute [%arg15] -> (f32) {
                %13 = memref.load %reinterpret_cast[%10, %arg14] : memref<8x64xf32, strided<[64, 1]>, 2 : i32>
                air.execute_terminator %13 : f32
              }
              %11 = arith.addf %results_9, %results_9 : f32
              %async_token_10 = air.execute [%arg15] {
                memref.store %11, %reinterpret_cast_5[%10, %arg14] : memref<8x64xf32, strided<[64, 1]>, 2 : i32>
              }
              %12 = air.wait_all async [%async_token_8, %async_token_10] 
              scf.yield %12 : !air.async.token
            }
            scf.yield %9 : !air.async.token
          }
          %8 = air.channel.put async  @channel_1[%arg8, %arg9] (%results_4[] [] []) {id = 4 : i32} : (memref<512xf32, 2 : i32>)
          air.wait_all [%8] 
          %async_token_6 = air.execute [%async_token] {
            memref.dealloc %results : memref<512xf32, 2 : i32>
          }
          %async_token_7 = air.execute [%async_token_3] {
            memref.dealloc %results_4 : memref<512xf32, 2 : i32>
          }
        }
        air.wait_all [%4]  {air.segment_end}
      }
    }
    return
  }
}
