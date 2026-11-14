module attributes {orbit.program_graph = "e87bc2e1c7e5eb3225a2a79218f3bba31afbfc91c116b0237ce686cb2b937e74"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  func.func @pointwise(%arg0: memref<64x64xf32> {orbit.name = "arg0", orbit.role = "input"}, %arg1: memref<64x64xf32> {orbit.name = "arg1", orbit.role = "output"}, %arg2: memref<11x64xf32> {orbit.name = "alloc2", orbit.role = "temporary"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_public_graph async (%arg3, %arg4) in (%arg5=%c1, %arg6=%c1) args(%arg7=%arg1, %arg8=%arg2) : memref<64x64xf32>, memref<11x64xf32> attributes {air.preserve_shim_dma_order, id = 1 : i32} {
      %c0 = arith.constant 0 : index
      %1 = air.channel.put async  @channel_0[%c0, %c0] (%arg8[] [] []) {id = 1 : i32} : (memref<11x64xf32>)
      %2 = air.channel.get async  @channel_1[%c0, %c0] (%arg7[0, 0] [11, 64] [64, 1]) {id = 2 : i32} : (memref<64x64xf32>)
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
          %5 = air.channel.get async  @channel_0[%arg9, %arg10] (%results_6[704] [704] [1]) {id = 3 : i32} : (memref<1408xf32, 2 : i32>)
          air.wait_all [%5] 
          %reinterpret_cast = memref.reinterpret_cast %results_4 to offset: [0], sizes: [11, 64], strides: [64, 1] {orbit.allocation = 5 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 1 : i64} : memref<704xf32, 2 : i32> to memref<11x64xf32, strided<[64, 1]>, 2 : i32>
          %reinterpret_cast_7 = memref.reinterpret_cast %results_6 to offset: [704], sizes: [11, 64], strides: [64, 1] {orbit.allocation = 4 : i64, orbit.logical_offsets = array<i64: 0, 0>, orbit.logical_sizes = array<i64: 11, 64>, orbit.storage_index = 2 : i64} : memref<1408xf32, 2 : i32> to memref<11x64xf32, strided<[64, 1], offset: 704>, 2 : i32>
          %6 = air.wait_all async 
          %7 = scf.for %arg13 = %c0_2 to %c11 step %c1_1 iter_args(%arg14 = %6) -> (!air.async.token) {
            %9 = scf.for %arg15 = %c0_2 to %c64 step %c1_1 iter_args(%arg16 = %arg14) -> (!air.async.token) {
              %async_token_11, %results_12 = air.execute [%arg16] -> (f32) {
                %10 = memref.load %reinterpret_cast_7[%arg13, %arg15] : memref<11x64xf32, strided<[64, 1], offset: 704>, 2 : i32>
                air.execute_terminator %10 : f32
              }
              %async_token_13 = air.execute [%arg16] {
                memref.store %results_12, %reinterpret_cast[%arg13, %arg15] : memref<11x64xf32, strided<[64, 1]>, 2 : i32>
              }
              scf.yield %async_token_13 : !air.async.token
            }
            scf.yield %9 : !air.async.token
          }
          %8 = air.channel.put async  @channel_1[%arg9, %arg10] (%results_4[] [] []) {id = 4 : i32} : (memref<704xf32, 2 : i32>)
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
