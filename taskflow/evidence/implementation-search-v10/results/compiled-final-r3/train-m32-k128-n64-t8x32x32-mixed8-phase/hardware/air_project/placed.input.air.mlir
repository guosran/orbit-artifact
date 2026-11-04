module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "dab223a536202a74a37a96551946a9f7ce3edf526cade1f7379aa68f94b81e55", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} {
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  air.channel @channel_2 [1, 1]
  air.channel @channel_3 [1, 1]
  air.channel @channel_4 [1, 1]
  func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
  func.func @gemm_scale(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 1 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %2 = air.wait_all async 
      %3 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %2) -> (!air.async.token) {
        %9 = arith.muli %arg11, %c8 : index
        %10 = scf.for %arg13 = %c0 to %c2 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %11 = scf.for %arg15 = %c0 to %c4 step %c1_0 iter_args(%arg16 = %arg14) -> (!air.async.token) {
            %12 = arith.muli %arg15, %c32 : index
            %13 = air.channel.put async [%arg16]  @channel_0[%c0, %c0] (%arg8[%9, %12] [8, 32] [128, 1]) {id = 1 : i32} : (memref<32x128xf32>)
            scf.yield %13 : !air.async.token
          }
          scf.yield %11 : !air.async.token
        }
        scf.yield %10 : !air.async.token
      }
      %4 = air.wait_all async 
      %5 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %4) -> (!air.async.token) {
        %9 = scf.for %arg13 = %c0 to %c2 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %10 = arith.muli %arg13, %c32 : index
          %11 = scf.for %arg15 = %c0 to %c4 step %c1_0 iter_args(%arg16 = %arg14) -> (!air.async.token) {
            %12 = arith.muli %arg15, %c32 : index
            %13 = air.channel.put async [%arg16]  @channel_1[%c0, %c0] (%arg9[%12, %10] [32, 32] [64, 1]) {id = 2 : i32} : (memref<128x64xf32>)
            scf.yield %13 : !air.async.token
          }
          scf.yield %11 : !air.async.token
        }
        scf.yield %9 : !air.async.token
      }
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %9 = arith.muli %arg11, %c8 : index
        %10 = scf.for %arg13 = %c0 to %c2 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %11 = arith.muli %arg13, %c32 : index
          %12 = air.channel.get async [%arg14]  @channel_2[%c0, %c0] (%arg10[%9, %11] [8, 32] [64, 1]) {id = 3 : i32} : (memref<32x64xf32>)
          scf.yield %12 : !air.async.token
        }
        scf.yield %10 : !air.async.token
      }
      %8 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %9 = air.herd @orbit_herd async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 0.000000e+00 : f32
          %c32_2 = arith.constant 32 : index
          %c2_3 = arith.constant 2 : index
          %c8_4 = arith.constant 8 : index
          %c1_5 = arith.constant 1 : index
          %c4_6 = arith.constant 4 : index
          %c0_7 = arith.constant 0 : index
          %10 = air.wait_all async 
          %11 = scf.for %arg15 = %c0_7 to %c4_6 step %c1_5 iter_args(%arg16 = %10) -> (!air.async.token) {
            %12 = scf.for %arg17 = %c0_7 to %c2_3 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %13 = air.wait_all async 
              %14 = scf.for %arg19 = %c0_7 to %c8_4 step %c1_5 iter_args(%arg20 = %13) -> (!air.async.token) {
                %18 = scf.for %arg21 = %c0_7 to %c32_2 step %c1_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %async_token_9 = air.execute [%arg22] {
                    memref.store %cst, %reinterpret_cast[%arg19, %arg21] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  scf.yield %async_token_9 : !air.async.token
                }
                scf.yield %18 : !air.async.token
              }
              %15 = air.wait_all async [%arg18, %14] 
              %16 = scf.for %arg19 = %c0_7 to %c4_6 step %c1_5 iter_args(%arg20 = %15) -> (!air.async.token) {
                %async_token_9, %results_10 = air.execute -> (memref<1024xf32, 2 : i32>) {
                  %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : memref<1024xf32, 2 : i32>
                  air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
                }
                %async_token_11, %results_12 = air.execute -> (memref<256xf32, 2 : i32>) {
                  %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : memref<256xf32, 2 : i32>
                  air.execute_terminator %alloc : memref<256xf32, 2 : i32>
                }
                %reinterpret_cast_13 = memref.reinterpret_cast %results_12 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 8 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %18 = air.channel.get async [%async_token_11, %arg20]  @channel_0[%arg11, %arg12] (%results_12[] [] []) {id = 4 : i32} : (memref<256xf32, 2 : i32>)
                %reinterpret_cast_14 = memref.reinterpret_cast %results_10 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 8 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                %19 = air.channel.get async [%async_token_9, %arg20]  @channel_1[%arg11, %arg12] (%results_10[] [] []) {id = 5 : i32} : (memref<1024xf32, 2 : i32>)
                air.wait_all [%18, %19]  {orbit.computation_event = 3 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.read_copies = array<i64: 24, 25, 26>, orbit.task = "gemm", orbit.write_copies = array<i64: 27>}
                %20 = air.wait_all async [%18, %19] 
                %21 = scf.for %arg21 = %c0_7 to %c8_4 step %c1_5 iter_args(%arg22 = %20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_7 to %c32_2 step %c8_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = scf.for %arg25 = %c0_7 to %c32_2 step %c1_5 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                      %async_token_17, %results_18 = air.execute [%arg26] -> (f32) {
                        %35 = memref.load %reinterpret_cast_13[%arg21, %arg25] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                        air.execute_terminator %35 : f32
                      }
                      %async_token_19, %results_20 = air.execute [%arg26] -> (vector<8xf32>) {
                        %35 = vector.transfer_read %reinterpret_cast_14[%arg25, %arg23], %cst : memref<32x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                        air.execute_terminator %35 : vector<8xf32>
                      }
                      %async_token_21, %results_22 = air.execute [%arg26] -> (vector<8xf32>) {
                        %35 = vector.transfer_read %reinterpret_cast[%arg21, %arg23], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                        air.execute_terminator %35 : vector<8xf32>
                      }
                      %24 = vector.extract %results_20[0] : f32 from vector<8xf32>
                      %async_token_23, %results_24 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %24) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %25 = vector.extract %results_20[1] : f32 from vector<8xf32>
                      %async_token_25, %results_26 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %25) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %26 = vector.extract %results_20[2] : f32 from vector<8xf32>
                      %async_token_27, %results_28 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %26) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %27 = vector.extract %results_20[3] : f32 from vector<8xf32>
                      %async_token_29, %results_30 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %27) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %28 = vector.extract %results_20[4] : f32 from vector<8xf32>
                      %async_token_31, %results_32 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %28) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %29 = vector.extract %results_20[5] : f32 from vector<8xf32>
                      %async_token_33, %results_34 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %29) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %30 = vector.extract %results_20[6] : f32 from vector<8xf32>
                      %async_token_35, %results_36 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %30) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %31 = vector.extract %results_20[7] : f32 from vector<8xf32>
                      %async_token_37, %results_38 = air.execute [%async_token_17] -> (f32) {
                        %35 = func.call @__mulsf3(%results_18, %31) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %35 : f32
                      }
                      %32 = vector.from_elements %results_24, %results_26, %results_28, %results_30, %results_32, %results_34, %results_36, %results_38 : vector<8xf32>
                      %33 = arith.addf %results_22, %32 : vector<8xf32>
                      %async_token_39 = air.execute [%async_token_21] {
                        vector.transfer_write %33, %reinterpret_cast[%arg21, %arg23] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                      }
                      %34 = air.wait_all async [%async_token_19, %async_token_23, %async_token_25, %async_token_27, %async_token_29, %async_token_31, %async_token_33, %async_token_35, %async_token_37, %async_token_39] 
                      scf.yield %34 : !air.async.token
                    }
                    scf.yield %23 : !air.async.token
                  }
                  scf.yield %22 : !air.async.token
                }
                %async_token_15 = air.execute [%18] {
                  memref.dealloc %results_12 : memref<256xf32, 2 : i32>
                }
                %async_token_16 = air.execute [%19] {
                  memref.dealloc %results_10 : memref<1024xf32, 2 : i32>
                }
                scf.yield %21 : !air.async.token
              }
              %17 = air.channel.put async [%async_token, %16]  @channel_2[%arg11, %arg12] (%results[] [] []) {id = 6 : i32} : (memref<256xf32, 2 : i32>)
              %async_token_8 = air.execute [%17] {
                memref.dealloc %results : memref<256xf32, 2 : i32>
              }
              scf.yield %17 : !air.async.token
            } {orbit.compressed_phases = 2 : i64}
            scf.yield %12 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%11] 
        }
        air.wait_all [%9]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_40 async [%0] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<32x64xf32>, memref<32x64xf32> attributes {id = 4 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %2 = air.wait_all async 
      %3 = scf.for %arg10 = %c0 to %c4 step %c1_0 iter_args(%arg11 = %2) -> (!air.async.token) {
        %7 = arith.muli %arg10, %c8 : index
        %8 = scf.for %arg12 = %c0 to %c2 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %9 = arith.muli %arg12, %c32 : index
          %10 = air.channel.put async [%arg13]  @channel_3[%c0, %c0] (%arg9[%7, %9] [8, 32] [64, 1]) {id = 7 : i32} : (memref<32x64xf32>)
          scf.yield %10 : !air.async.token
        }
        scf.yield %8 : !air.async.token
      }
      %4 = air.wait_all async 
      %5 = scf.for %arg10 = %c0 to %c4 step %c1_0 iter_args(%arg11 = %4) -> (!air.async.token) {
        %7 = arith.muli %arg10, %c8 : index
        %8 = scf.for %arg12 = %c0 to %c2 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %9 = arith.muli %arg12, %c32 : index
          %10 = air.channel.get async [%arg13]  @channel_4[%c0, %c0] (%arg8[%7, %9] [8, 32] [64, 1]) {id = 8 : i32} : (memref<32x64xf32>)
          scf.yield %10 : !air.async.token
        }
        scf.yield %8 : !air.async.token
      }
      %6 = air.segment @orbit_segment_40 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %7 = air.herd @orbit_herd_40 async  tile (%arg10, %arg11) in (%arg12=%c1_1, %arg13=%c1_1) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 5.000000e-01 : f32
          %cst_2 = arith.constant 0.000000e+00 : f32
          %c32_3 = arith.constant 32 : index
          %c2_4 = arith.constant 2 : index
          %c8_5 = arith.constant 8 : index
          %c1_6 = arith.constant 1 : index
          %c4_7 = arith.constant 4 : index
          %c0_8 = arith.constant 0 : index
          %8 = air.wait_all async 
          %9 = scf.for %arg14 = %c0_8 to %c4_7 step %c1_6 iter_args(%arg15 = %8) -> (!air.async.token) {
            %10 = scf.for %arg16 = %c0_8 to %c2_4 step %c1_6 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %async_token_9, %results_10 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results_10 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 40 : i64, orbit.storage = "Y"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %reinterpret_cast_11 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 40 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %11 = air.channel.get async [%async_token, %arg17]  @channel_3[%arg10, %arg11] (%results[] [] []) {id = 9 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%11]  {orbit.computation_event = 113 : i64, orbit.phase = 40 : i64, orbit.phase_dependencies = array<i64: 39>, orbit.read_copies = array<i64: 136>, orbit.task = "scale", orbit.write_copies = array<i64: 137>}
              %12 = scf.for %arg18 = %c0_8 to %c8_5 step %c1_6 iter_args(%arg19 = %11) -> (!air.async.token) {
                %14 = scf.for %arg20 = %c0_8 to %c32_3 step %c8_5 iter_args(%arg21 = %arg19) -> (!air.async.token) {
                  %async_token_14, %results_15 = air.execute [%arg21] -> (vector<8xf32>) {
                    %25 = vector.transfer_read %reinterpret_cast_11[%arg18, %arg20], %cst_2 : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %25 : vector<8xf32>
                  }
                  %15 = vector.extract %results_15[0] : f32 from vector<8xf32>
                  %async_token_16, %results_17 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%15, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %16 = vector.extract %results_15[1] : f32 from vector<8xf32>
                  %async_token_18, %results_19 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%16, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %17 = vector.extract %results_15[2] : f32 from vector<8xf32>
                  %async_token_20, %results_21 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%17, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %18 = vector.extract %results_15[3] : f32 from vector<8xf32>
                  %async_token_22, %results_23 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%18, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %19 = vector.extract %results_15[4] : f32 from vector<8xf32>
                  %async_token_24, %results_25 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%19, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %20 = vector.extract %results_15[5] : f32 from vector<8xf32>
                  %async_token_26, %results_27 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%20, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %21 = vector.extract %results_15[6] : f32 from vector<8xf32>
                  %async_token_28, %results_29 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%21, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %22 = vector.extract %results_15[7] : f32 from vector<8xf32>
                  %async_token_30, %results_31 = air.execute [%arg21] -> (f32) {
                    %25 = func.call @__mulsf3(%22, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %25 : f32
                  }
                  %23 = vector.from_elements %results_17, %results_19, %results_21, %results_23, %results_25, %results_27, %results_29, %results_31 : vector<8xf32>
                  %async_token_32 = air.execute [%arg21] {
                    vector.transfer_write %23, %reinterpret_cast[%arg18, %arg20] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %24 = air.wait_all async [%async_token_14, %async_token_16, %async_token_18, %async_token_20, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32] 
                  scf.yield %24 : !air.async.token
                }
                scf.yield %14 : !air.async.token
              }
              %13 = air.channel.put async [%async_token_9, %12]  @channel_4[%arg10, %arg11] (%results_10[] [] []) {id = 10 : i32} : (memref<256xf32, 2 : i32>)
              %async_token_12 = air.execute [%13] {
                memref.dealloc %results_10 : memref<256xf32, 2 : i32>
              }
              %async_token_13 = air.execute [%11] {
                memref.dealloc %results : memref<256xf32, 2 : i32>
              }
              scf.yield %13 : !air.async.token
            } {orbit.compressed_phases = 2 : i64}
            scf.yield %10 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%9] 
        }
        air.wait_all [%7]  {air.segment_end}
      }
    }
    return
  }
}
