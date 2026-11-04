module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.mapping_plan = "d802c9f9e3a367ac86508863f9b476940a2738b6eea3bd9e293646b3519b283c", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  air.channel @channel_2 [1, 1]
  air.channel @channel_3 [1, 1]
  air.channel @channel_4 [1, 1]
  func.func @gemm_scale(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 1 : i32} {
      %c16 = arith.constant 16 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c2 = arith.constant 2 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %2 = air.wait_all async 
      %3 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %2) -> (!air.async.token) {
        %9 = arith.muli %arg11, %c4 : index
        %10 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %11 = scf.for %arg15 = %c0 to %c2 step %c1_0 iter_args(%arg16 = %arg14) -> (!air.async.token) {
            %12 = arith.muli %arg15, %c64 : index
            %13 = air.channel.put async [%arg16]  @channel_0[%c0, %c0] (%arg8[%9, %12] [4, 64] [128, 1]) {id = 1 : i32} : (memref<32x128xf32>)
            scf.yield %13 : !air.async.token
          }
          scf.yield %11 : !air.async.token
        }
        scf.yield %10 : !air.async.token
      }
      %4 = air.wait_all async 
      %5 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %4) -> (!air.async.token) {
        %9 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %10 = arith.muli %arg13, %c16 : index
          %11 = scf.for %arg15 = %c0 to %c2 step %c1_0 iter_args(%arg16 = %arg14) -> (!air.async.token) {
            %12 = arith.muli %arg15, %c64 : index
            %13 = air.channel.put async [%arg16]  @channel_1[%c0, %c0] (%arg9[%12, %10] [64, 16] [64, 1]) {id = 2 : i32} : (memref<128x64xf32>)
            scf.yield %13 : !air.async.token
          }
          scf.yield %11 : !air.async.token
        }
        scf.yield %9 : !air.async.token
      }
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %9 = arith.muli %arg11, %c4 : index
        %10 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %11 = arith.muli %arg13, %c16 : index
          %12 = air.channel.get async [%arg14]  @channel_2[%c0, %c0] (%arg10[%9, %11] [4, 16] [64, 1]) {id = 3 : i32} : (memref<32x64xf32>)
          scf.yield %12 : !air.async.token
        }
        scf.yield %10 : !air.async.token
      }
      %8 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c8_1 = arith.constant 8 : index
        %c4_2 = arith.constant 4 : index
        %c1_3 = arith.constant 1 : index
        %c0_4 = arith.constant 0 : index
        %9 = air.wait_all async 
        %10 = scf.for %arg11 = %c0_4 to %c8_1 step %c1_3 iter_args(%arg12 = %9) -> (!air.async.token) {
          %14 = scf.for %arg13 = %c0_4 to %c4_2 step %c1_3 iter_args(%arg14 = %arg12) -> (!air.async.token) {
            %15 = air.wait_all async 
            scf.yield %15 : !air.async.token
          }
          scf.yield %14 : !air.async.token
        }
        %11 = air.wait_all async 
        %12 = scf.for %arg11 = %c0_4 to %c8_1 step %c1_3 iter_args(%arg12 = %11) -> (!air.async.token) {
          %14 = scf.for %arg13 = %c0_4 to %c4_2 step %c1_3 iter_args(%arg14 = %arg12) -> (!air.async.token) {
            %15 = air.wait_all async 
            scf.yield %15 : !air.async.token
          }
          scf.yield %14 : !air.async.token
        }
        %13 = air.herd @orbit_herd async  tile (%arg11, %arg12) in (%arg13=%c1_3, %arg14=%c1_3) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c64_5 = arith.constant 64 : index
          %c2_6 = arith.constant 2 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c16_7 = arith.constant 16 : index
          %c4_8 = arith.constant 4 : index
          %c1_9 = arith.constant 1 : index
          %c8_10 = arith.constant 8 : index
          %c0_11 = arith.constant 0 : index
          %14 = air.wait_all async 
          %15 = scf.for %arg15 = %c0_11 to %c8_10 step %c1_9 iter_args(%arg16 = %14) -> (!air.async.token) {
            %16 = scf.for %arg17 = %c0_11 to %c4_8 step %c1_9 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
              %17 = air.wait_all async 
              %18 = scf.for %arg19 = %c0_11 to %c4_8 step %c1_9 iter_args(%arg20 = %17) -> (!air.async.token) {
                %22 = scf.for %arg21 = %c0_11 to %c16_7 step %c1_9 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %async_token_13 = air.execute [%arg22] {
                    memref.store %cst, %reinterpret_cast[%arg19, %arg21] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  scf.yield %async_token_13 : !air.async.token
                }
                scf.yield %22 : !air.async.token
              }
              %19 = air.wait_all async [%arg18, %18] 
              %20 = scf.for %arg19 = %c0_11 to %c2_6 step %c1_9 iter_args(%arg20 = %19) -> (!air.async.token) {
                %async_token_13, %results_14 = air.execute -> (memref<1024xf32, 2 : i32>) {
                  %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.16.loops.4.16.64"} : memref<1024xf32, 2 : i32>
                  air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
                }
                %async_token_15, %results_16 = air.execute -> (memref<256xf32, 2 : i32>) {
                  %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : memref<256xf32, 2 : i32>
                  air.execute_terminator %alloc : memref<256xf32, 2 : i32>
                }
                %reinterpret_cast_17 = memref.reinterpret_cast %results_16 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                %22 = air.channel.get async [%async_token_15, %arg20]  @channel_0[%arg11, %arg12] (%results_16[] [] []) {id = 4 : i32} : (memref<256xf32, 2 : i32>)
                %reinterpret_cast_18 = memref.reinterpret_cast %results_14 to offset: [0], sizes: [64, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<64x16xf32, strided<[16, 1]>, 2 : i32>
                %23 = air.channel.get async [%async_token_13, %arg20]  @channel_1[%arg11, %arg12] (%results_14[] [] []) {id = 5 : i32} : (memref<1024xf32, 2 : i32>)
                air.wait_all [%22, %23]  {orbit.computation_event = 3 : i64, orbit.phase = 32 : i64, orbit.phase_dependencies = array<i64: 31>, orbit.read_copies = array<i64: 24, 25, 26>, orbit.task = "gemm", orbit.write_copies = array<i64: 27>}
                %24 = air.wait_all async [%22, %23] 
                %25 = scf.for %arg21 = %c0_11 to %c4_8 step %c1_9 iter_args(%arg22 = %24) -> (!air.async.token) {
                  %26 = scf.for %arg23 = %c0_11 to %c16_7 step %c1_9 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %27 = scf.for %arg25 = %c0_11 to %c64_5 step %c1_9 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                      %async_token_21, %results_22 = air.execute [%arg26] -> (f32) {
                        %31 = memref.load %reinterpret_cast_17[%arg21, %arg25] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                        air.execute_terminator %31 : f32
                      }
                      %async_token_23, %results_24 = air.execute [%arg26] -> (f32) {
                        %31 = memref.load %reinterpret_cast_18[%arg25, %arg23] : memref<64x16xf32, strided<[16, 1]>, 2 : i32>
                        air.execute_terminator %31 : f32
                      }
                      %async_token_25, %results_26 = air.execute [%arg26] -> (f32) {
                        %31 = memref.load %reinterpret_cast[%arg21, %arg23] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                        air.execute_terminator %31 : f32
                      }
                      %28 = arith.mulf %results_22, %results_24 : f32
                      %29 = arith.addf %results_26, %28 : f32
                      %async_token_27 = air.execute [%async_token_25] {
                        memref.store %29, %reinterpret_cast[%arg21, %arg23] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                      }
                      %30 = air.wait_all async [%async_token_21, %async_token_23, %async_token_27] 
                      scf.yield %30 : !air.async.token
                    }
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %26 : !air.async.token
                }
                %async_token_19 = air.execute [%22] {
                  memref.dealloc %results_16 : memref<256xf32, 2 : i32>
                }
                %async_token_20 = air.execute [%23] {
                  memref.dealloc %results_14 : memref<1024xf32, 2 : i32>
                }
                scf.yield %25 : !air.async.token
              }
              %21 = air.channel.put async [%async_token, %20]  @channel_2[%arg11, %arg12] (%results[] [] []) {id = 6 : i32} : (memref<64xf32, 2 : i32>)
              %async_token_12 = air.execute [%21] {
                memref.dealloc %results : memref<64xf32, 2 : i32>
              }
              scf.yield %21 : !air.async.token
            } {orbit.compressed_phases = 4 : i64}
            scf.yield %16 : !air.async.token
          } {orbit.compressed_phases = 8 : i64}
          air.wait_all [%15] 
        }
        air.wait_all [%10, %12, %13]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_96 async [%0] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<32x64xf32>, memref<32x64xf32> attributes {id = 4 : i32} {
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %2 = air.wait_all async 
      %3 = scf.for %arg10 = %c0 to %c8 step %c1_0 iter_args(%arg11 = %2) -> (!air.async.token) {
        %7 = arith.muli %arg10, %c4 : index
        %8 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %9 = arith.muli %arg12, %c16 : index
          %10 = air.channel.put async [%arg13]  @channel_3[%c0, %c0] (%arg9[%7, %9] [4, 16] [64, 1]) {id = 7 : i32} : (memref<32x64xf32>)
          scf.yield %10 : !air.async.token
        }
        scf.yield %8 : !air.async.token
      }
      %4 = air.wait_all async 
      %5 = scf.for %arg10 = %c0 to %c8 step %c1_0 iter_args(%arg11 = %4) -> (!air.async.token) {
        %7 = arith.muli %arg10, %c4 : index
        %8 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %9 = arith.muli %arg12, %c16 : index
          %10 = air.channel.get async [%arg13]  @channel_4[%c0, %c0] (%arg8[%7, %9] [4, 16] [64, 1]) {id = 8 : i32} : (memref<32x64xf32>)
          scf.yield %10 : !air.async.token
        }
        scf.yield %8 : !air.async.token
      }
      %6 = air.segment @orbit_segment_96 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c8_1 = arith.constant 8 : index
        %c4_2 = arith.constant 4 : index
        %c1_3 = arith.constant 1 : index
        %c0_4 = arith.constant 0 : index
        %7 = air.wait_all async 
        %8 = scf.for %arg10 = %c0_4 to %c8_1 step %c1_3 iter_args(%arg11 = %7) -> (!air.async.token) {
          %12 = scf.for %arg12 = %c0_4 to %c4_2 step %c1_3 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %13 = air.wait_all async 
            scf.yield %13 : !air.async.token
          }
          scf.yield %12 : !air.async.token
        }
        %9 = air.wait_all async 
        %10 = scf.for %arg10 = %c0_4 to %c8_1 step %c1_3 iter_args(%arg11 = %9) -> (!air.async.token) {
          %12 = scf.for %arg12 = %c0_4 to %c4_2 step %c1_3 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %13 = air.wait_all async 
            scf.yield %13 : !air.async.token
          }
          scf.yield %12 : !air.async.token
        }
        %11 = air.herd @orbit_herd_96 async  tile (%arg10, %arg11) in (%arg12=%c1_3, %arg13=%c1_3) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 5.000000e-01 : f32
          %c16_5 = arith.constant 16 : index
          %c4_6 = arith.constant 4 : index
          %c1_7 = arith.constant 1 : index
          %c8_8 = arith.constant 8 : index
          %c0_9 = arith.constant 0 : index
          %12 = air.wait_all async 
          %13 = scf.for %arg14 = %c0_9 to %c8_8 step %c1_7 iter_args(%arg15 = %12) -> (!air.async.token) {
            %14 = scf.for %arg16 = %c0_9 to %c4_6 step %c1_7 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.4.16.loops.4.16"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results_11 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.phase = 96 : i64, orbit.storage = "Y"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
              %reinterpret_cast_12 = memref.reinterpret_cast %results to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.phase = 96 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
              %15 = air.channel.get async [%async_token, %arg17]  @channel_3[%arg10, %arg11] (%results[] [] []) {id = 9 : i32} : (memref<64xf32, 2 : i32>)
              air.wait_all [%15]  {orbit.computation_event = 257 : i64, orbit.phase = 96 : i64, orbit.phase_dependencies = array<i64: 95>, orbit.read_copies = array<i64: 280>, orbit.task = "scale", orbit.write_copies = array<i64: 281>}
              %16 = scf.for %arg18 = %c0_9 to %c4_6 step %c1_7 iter_args(%arg19 = %15) -> (!air.async.token) {
                %18 = scf.for %arg20 = %c0_9 to %c16_5 step %c1_7 iter_args(%arg21 = %arg19) -> (!air.async.token) {
                  %async_token_15, %results_16 = air.execute [%arg21] -> (f32) {
                    %21 = memref.load %reinterpret_cast_12[%arg18, %arg20] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                    air.execute_terminator %21 : f32
                  }
                  %19 = arith.mulf %results_16, %cst : f32
                  %async_token_17 = air.execute [%arg21] {
                    memref.store %19, %reinterpret_cast[%arg18, %arg20] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  %20 = air.wait_all async [%async_token_15, %async_token_17] 
                  scf.yield %20 : !air.async.token
                }
                scf.yield %18 : !air.async.token
              }
              %17 = air.channel.put async [%async_token_10, %16]  @channel_4[%arg10, %arg11] (%results_11[] [] []) {id = 10 : i32} : (memref<64xf32, 2 : i32>)
              %async_token_13 = air.execute [%17] {
                memref.dealloc %results_11 : memref<64xf32, 2 : i32>
              }
              %async_token_14 = air.execute [%15] {
                memref.dealloc %results : memref<64xf32, 2 : i32>
              }
              scf.yield %17 : !air.async.token
            } {orbit.compressed_phases = 4 : i64}
            scf.yield %14 : !air.async.token
          } {orbit.compressed_phases = 8 : i64}
          air.wait_all [%13] 
        }
        air.wait_all [%8, %10, %11]  {air.segment_end}
      }
    }
    return
  }
}
