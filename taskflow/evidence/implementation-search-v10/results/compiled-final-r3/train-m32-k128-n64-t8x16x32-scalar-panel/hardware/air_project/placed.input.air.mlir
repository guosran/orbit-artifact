module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.mapping_plan = "28f6187c7639f2aaf609e26ed279c42b2592cecb0f2bb2952e5cdcd420ab1424", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  air.channel @channel_2 [1, 1]
  air.channel @channel_3 [1, 1]
  air.channel @channel_4 [1, 1]
  air.channel @channel_5 [1, 1]
  air.channel @channel_6 [1, 1]
  air.channel @channel_7 [1, 1]
  air.channel @channel_8 [1, 1]
  air.channel @channel_9 [1, 1]
  air.channel @channel_10 [1, 1]
  air.channel @channel_11 [1, 1]
  air.channel @channel_12 [1, 1]
  air.channel @channel_13 [1, 1]
  func.func @gemm_scale(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 1 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_0[%c0, %c0] (%arg9[0, 0] [128, 16] [64, 1]) {id = 1 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_1[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 2 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_2[%c0, %c0] (%arg10[%11, 0] [8, 16] [64, 1]) {id = 3 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c32_2 = arith.constant 32 : index
          %c16 = arith.constant 16 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c4_5 = arith.constant 4 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 16 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_0[%arg11, %arg12] (%results[] [] []) {id = 4 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c4_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c0_6 to %c16 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %arg19] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 16 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_1[%arg11, %arg12] (%results_13[] [] []) {id = 5 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 3 : i64, orbit.phase = 16 : i64, orbit.phase_dependencies = array<i64: 15>, orbit.read_copies = array<i64: 32, 33, 37>, orbit.task = "gemm", orbit.write_copies = array<i64: 38>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c0_6 to %c16 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %27 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %27 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %27 = memref.load %reinterpret_cast[%23, %arg21] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %27 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %27 = memref.load %reinterpret_cast_10[%arg19, %arg21] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %27 : f32
                    }
                    %24 = arith.mulf %results_17, %results_19 : f32
                    %25 = arith.addf %results_21, %24 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %25, %reinterpret_cast_10[%arg19, %arg21] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %26 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %26 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_2[%arg11, %arg12] (%results_9[] [] []) {id = 6 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_32 async [%0] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 4 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_3[%c0, %c0] (%arg9[0, 16] [128, 16] [64, 1]) {id = 7 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_4[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 8 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_5[%c0, %c0] (%arg10[%11, 16] [8, 16] [64, 1]) {id = 9 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_32 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_32 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c32_2 = arith.constant 32 : index
          %c16 = arith.constant 16 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c4_5 = arith.constant 4 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_3[%arg11, %arg12] (%results[] [] []) {id = 10 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c4_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c16 to %c32_2 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c16 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_4[%arg11, %arg12] (%results_13[] [] []) {id = 11 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 44 : i64, orbit.phase = 32 : i64, orbit.phase_dependencies = array<i64: 31>, orbit.read_copies = array<i64: 76, 77, 81>, orbit.task = "gemm", orbit.write_copies = array<i64: 82>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c16 to %c32_2 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %24 = arith.subi %arg21, %c16 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast[%23, %24] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %25 = arith.mulf %results_17, %results_19 : f32
                    %26 = arith.addf %results_21, %25 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %26, %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %27 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_5[%arg11, %arg12] (%results_9[] [] []) {id = 12 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %2 = air.launch @orbit_launch_48 async [%1] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 7 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_6[%c0, %c0] (%arg9[0, 32] [128, 16] [64, 1]) {id = 13 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_7[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 14 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_8[%c0, %c0] (%arg10[%11, 32] [8, 16] [64, 1]) {id = 15 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_48 async  attributes {id = 8 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_48 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 9 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c48 = arith.constant 48 : index
          %c32_2 = arith.constant 32 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c4_5 = arith.constant 4 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 48 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_6[%arg11, %arg12] (%results[] [] []) {id = 16 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c4_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 48 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c32_2 to %c48 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c32_2 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 48 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_7[%arg11, %arg12] (%results_13[] [] []) {id = 17 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 85 : i64, orbit.phase = 48 : i64, orbit.phase_dependencies = array<i64: 47>, orbit.read_copies = array<i64: 120, 121, 125>, orbit.task = "gemm", orbit.write_copies = array<i64: 126>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c32_2 to %c48 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %24 = arith.subi %arg21, %c32_2 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast[%23, %24] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %25 = arith.mulf %results_17, %results_19 : f32
                    %26 = arith.addf %results_21, %25 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %26, %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %27 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_8[%arg11, %arg12] (%results_9[] [] []) {id = 18 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %3 = air.launch @orbit_launch_64 async [%2] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 10 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_9[%c0, %c0] (%arg9[0, 48] [128, 16] [64, 1]) {id = 19 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c32 : index
          %14 = air.channel.put async [%arg14]  @channel_10[%c0, %c0] (%arg8[%11, %13] [8, 32] [128, 1]) {id = 20 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c8 : index
        %12 = air.channel.get async [%arg12]  @channel_11[%c0, %c0] (%arg10[%11, 48] [8, 16] [64, 1]) {id = 21 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_64 async  attributes {id = 11 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_64 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 12 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c32_2 = arith.constant 32 : index
          %c64 = arith.constant 64 : index
          %c48 = arith.constant 48 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c8_3 = arith.constant 8 : index
          %c1_4 = arith.constant 1 : index
          %c4_5 = arith.constant 4 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 64 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_9[%arg11, %arg12] (%results[] [] []) {id = 22 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c4_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 64 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c48 to %c64 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c48 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c32_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 64 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_10[%arg11, %arg12] (%results_13[] [] []) {id = 23 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 126 : i64, orbit.phase = 64 : i64, orbit.phase_dependencies = array<i64: 63>, orbit.read_copies = array<i64: 164, 165, 169>, orbit.task = "gemm", orbit.write_copies = array<i64: 170>}
              %20 = scf.for %arg19 = %c0_6 to %c8_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c48 to %c64 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %24 = arith.subi %arg21, %c48 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast[%23, %24] : memref<128x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (f32) {
                      %28 = memref.load %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      air.execute_terminator %28 : f32
                    }
                    %25 = arith.mulf %results_17, %results_19 : f32
                    %26 = arith.addf %results_21, %25 : f32
                    %async_token_22 = air.execute [%async_token_20] {
                      memref.store %26, %reinterpret_cast_10[%arg19, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %27 = air.wait_all async [%async_token_16, %async_token_18, %async_token_22] 
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %async_token_15 = air.execute [%19] {
                memref.dealloc %results_13 : memref<256xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            }
            %18 = air.channel.put async [%async_token_8, %17]  @channel_11[%arg11, %arg12] (%results_9[] [] []) {id = 24 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<128xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %4 = air.launch @orbit_launch_80 async [%3] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<32x64xf32>, memref<32x64xf32> attributes {id = 13 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.wait_all async 
      %6 = scf.for %arg10 = %c0 to %c4 step %c1_0 iter_args(%arg11 = %5) -> (!air.async.token) {
        %10 = arith.muli %arg10, %c8 : index
        %11 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %12 = arith.muli %arg12, %c16 : index
          %13 = air.channel.put async [%arg13]  @channel_12[%c0, %c0] (%arg9[%10, %12] [8, 16] [64, 1]) {id = 25 : i32} : (memref<32x64xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %7 = air.wait_all async 
      %8 = scf.for %arg10 = %c0 to %c4 step %c1_0 iter_args(%arg11 = %7) -> (!air.async.token) {
        %10 = arith.muli %arg10, %c8 : index
        %11 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %12 = arith.muli %arg12, %c16 : index
          %13 = air.channel.get async [%arg13]  @channel_13[%c0, %c0] (%arg8[%10, %12] [8, 16] [64, 1]) {id = 26 : i32} : (memref<32x64xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %9 = air.segment @orbit_segment_80 async  attributes {id = 14 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c4_1 = arith.constant 4 : index
        %c1_2 = arith.constant 1 : index
        %c0_3 = arith.constant 0 : index
        %10 = air.wait_all async 
        %11 = scf.for %arg10 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg11 = %10) -> (!air.async.token) {
          %15 = scf.for %arg12 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %16 = air.wait_all async 
            scf.yield %16 : !air.async.token
          }
          scf.yield %15 : !air.async.token
        }
        %12 = air.wait_all async 
        %13 = scf.for %arg10 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg11 = %12) -> (!air.async.token) {
          %15 = scf.for %arg12 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %16 = air.wait_all async 
            scf.yield %16 : !air.async.token
          }
          scf.yield %15 : !air.async.token
        }
        %14 = air.herd @orbit_herd_80 async  tile (%arg10, %arg11) in (%arg12=%c1_2, %arg13=%c1_2) attributes {id = 15 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 5.000000e-01 : f32
          %c16_4 = arith.constant 16 : index
          %c8_5 = arith.constant 8 : index
          %c1_6 = arith.constant 1 : index
          %c4_7 = arith.constant 4 : index
          %c0_8 = arith.constant 0 : index
          %15 = air.wait_all async 
          %16 = scf.for %arg14 = %c0_8 to %c4_7 step %c1_6 iter_args(%arg15 = %15) -> (!air.async.token) {
            %17 = scf.for %arg16 = %c0_8 to %c4_7 step %c1_6 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : memref<128xf32, 2 : i32>
                air.execute_terminator %alloc : memref<128xf32, 2 : i32>
              }
              %async_token_9, %results_10 = air.execute -> (memref<128xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<128xf32, 2 : i32>
                air.execute_terminator %alloc : memref<128xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results_10 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %reinterpret_cast_11 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %18 = air.channel.get async [%async_token, %arg17]  @channel_12[%arg10, %arg11] (%results[] [] []) {id = 27 : i32} : (memref<128xf32, 2 : i32>)
              air.wait_all [%18]  {orbit.computation_event = 165 : i64, orbit.phase = 80 : i64, orbit.phase_dependencies = array<i64: 79>, orbit.read_copies = array<i64: 208>, orbit.task = "scale", orbit.write_copies = array<i64: 209>}
              %19 = scf.for %arg18 = %c0_8 to %c8_5 step %c1_6 iter_args(%arg19 = %18) -> (!air.async.token) {
                %21 = scf.for %arg20 = %c0_8 to %c16_4 step %c1_6 iter_args(%arg21 = %arg19) -> (!air.async.token) {
                  %async_token_14, %results_15 = air.execute [%arg21] -> (f32) {
                    %24 = memref.load %reinterpret_cast_11[%arg18, %arg20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    air.execute_terminator %24 : f32
                  }
                  %22 = arith.mulf %results_15, %cst : f32
                  %async_token_16 = air.execute [%arg21] {
                    memref.store %22, %reinterpret_cast[%arg18, %arg20] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  %23 = air.wait_all async [%async_token_14, %async_token_16] 
                  scf.yield %23 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %20 = air.channel.put async [%async_token_9, %19]  @channel_13[%arg10, %arg11] (%results_10[] [] []) {id = 28 : i32} : (memref<128xf32, 2 : i32>)
              %async_token_12 = air.execute [%20] {
                memref.dealloc %results_10 : memref<128xf32, 2 : i32>
              }
              %async_token_13 = air.execute [%18] {
                memref.dealloc %results : memref<128xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            } {orbit.compressed_phases = 4 : i64}
            scf.yield %17 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%16] 
        }
        air.wait_all [%11, %13, %14]  {air.segment_end}
      }
    }
    return
  }
}
