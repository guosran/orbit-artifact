module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "0023fa0fc660e0d000f371d2b6eff9f3927f0b05e2bc74138127e7ae487d5ade", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "8c0c18e9f7ab0e83c0d958c735fe9d4b466e5b15e5cdf11aa852370d1e3f1414"} {
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
  func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
  func.func @ffn(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg0, %arg13=%arg1, %arg14=%arg5) : memref<5x2048xf32>, memref<2048x11008xf32>, memref<5x11008xf32> attributes {id = 1 : i32} {
      %c172 = arith.constant 172 : index
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %4 = air.wait_all async 
      %5 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %4) -> (!air.async.token) {
        %11 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %12 = arith.muli %arg17, %c64 : index
          %13 = air.channel.put async [%arg18]  @channel_0[%c0, %c0] (%arg12[0, %12] [5, 64] [2048, 1]) {id = 1 : i32} : (memref<5x2048xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %6 = air.wait_all async 
      %7 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %13 = arith.muli %arg17, %c64 : index
          %14 = air.channel.put async [%arg18]  @channel_1[%c0, %c0] (%arg13[%13, %11] [64, 64] [11008, 1]) {id = 2 : i32} : (memref<2048x11008xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = air.channel.get async [%arg16]  @channel_2[%c0, %c0] (%arg14[0, %11] [5, 64] [11008, 1]) {id = 3 : i32} : (memref<5x11008xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c5 = arith.constant 5 : index
          %c32_2 = arith.constant 32 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c64_3 = arith.constant 64 : index
          %c1_4 = arith.constant 1 : index
          %c172_5 = arith.constant 172 : index
          %c0_6 = arith.constant 0 : index
          %12 = air.wait_all async 
          %13 = scf.for %arg19 = %c0_6 to %c172_5 step %c1_4 iter_args(%arg20 = %12) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<320xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : memref<320xf32, 2 : i32>
              air.execute_terminator %alloc : memref<320xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.initializer_task = "gate.initialize", orbit.phase = 172 : i64, orbit.storage = "G"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg21 = %c0_6 to %c5 step %c1_4 iter_args(%arg22 = %14) -> (!air.async.token) {
              %19 = scf.for %arg23 = %c0_6 to %c64_3 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_8 = air.execute [%arg24] {
                  memref.store %cst, %reinterpret_cast[%arg21, %arg23] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                }
                scf.yield %async_token_8 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg20, %15] 
            %17 = scf.for %arg21 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg22 = %16) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<4096xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.64.loops.5.64.64"} : memref<4096xf32, 2 : i32>
                air.execute_terminator %alloc : memref<4096xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<320xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.5.64.loops.5.64.64"} : memref<320xf32, 2 : i32>
                air.execute_terminator %alloc : memref<320xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.phase = 172 : i64, orbit.storage = "X"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_10, %arg22]  @channel_0[%arg15, %arg16] (%results_11[] [] []) {id = 4 : i32} : (memref<320xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [64, 64], strides: [64, 1] {orbit.phase = 172 : i64, orbit.storage = "W_gate"} : memref<4096xf32, 2 : i32> to memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %20 = air.channel.get async [%async_token_8, %arg22]  @channel_1[%arg15, %arg16] (%results_9[] [] []) {id = 5 : i32} : (memref<4096xf32, 2 : i32>)
              air.wait_all [%19, %20]  {orbit.computation_event = 3 : i64, orbit.phase = 172 : i64, orbit.phase_dependencies = array<i64: 171>, orbit.read_copies = array<i64: 16544, 16545, 16546>, orbit.task = "gate", orbit.write_copies = array<i64: 16547>}
              %21 = air.wait_all async [%19, %20] 
              %22 = scf.for %arg23 = %c0_6 to %c5 step %c1_4 iter_args(%arg24 = %21) -> (!air.async.token) {
                %23 = scf.for %arg25 = %c0_6 to %c64_3 step %c8 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %24 = scf.for %arg27 = %c0_6 to %c64_3 step %c1_4 iter_args(%arg28 = %arg26) -> (!air.async.token) {
                    %async_token_16, %results_17 = air.execute [%arg28] -> (f32) {
                      %36 = memref.load %reinterpret_cast_12[%arg23, %arg27] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %36 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg28] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast_13[%arg27, %arg25], %cst : memref<64x64xf32, strided<[64, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg28] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast[%arg23, %arg25], %cst : memref<5x64xf32, strided<[64, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %25 = vector.extract %results_19[0] : f32 from vector<8xf32>
                    %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %25) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %26 = vector.extract %results_19[1] : f32 from vector<8xf32>
                    %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %26) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %27 = vector.extract %results_19[2] : f32 from vector<8xf32>
                    %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %27) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %28 = vector.extract %results_19[3] : f32 from vector<8xf32>
                    %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %28) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %29 = vector.extract %results_19[4] : f32 from vector<8xf32>
                    %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %30 = vector.extract %results_19[5] : f32 from vector<8xf32>
                    %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %31 = vector.extract %results_19[6] : f32 from vector<8xf32>
                    %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %32 = vector.extract %results_19[7] : f32 from vector<8xf32>
                    %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %33 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                    %34 = arith.addf %results_21, %33 : vector<8xf32>
                    %async_token_38 = air.execute [%async_token_20] {
                      vector.transfer_write %34, %reinterpret_cast[%arg23, %arg25] : vector<8xf32>, memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                    }
                    %35 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %35 : !air.async.token
                  }
                  scf.yield %24 : !air.async.token
                }
                scf.yield %23 : !air.async.token
              }
              %async_token_14 = air.execute [%19] {
                memref.dealloc %results_11 : memref<320xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%20] {
                memref.dealloc %results_9 : memref<4096xf32, 2 : i32>
              }
              scf.yield %22 : !air.async.token
            }
            %18 = air.channel.put async [%async_token, %17]  @channel_2[%arg15, %arg16] (%results[] [] []) {id = 6 : i32} : (memref<320xf32, 2 : i32>)
            %async_token_7 = air.execute [%18] {
              memref.dealloc %results : memref<320xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 172 : i64}
          air.wait_all [%13] 
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_5848 async [%0] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg0, %arg13=%arg2, %arg14=%arg6) : memref<5x2048xf32>, memref<2048x11008xf32>, memref<5x11008xf32> attributes {id = 4 : i32} {
      %c172 = arith.constant 172 : index
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %4 = air.wait_all async 
      %5 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %4) -> (!air.async.token) {
        %11 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %12 = arith.muli %arg17, %c64 : index
          %13 = air.channel.put async [%arg18]  @channel_3[%c0, %c0] (%arg12[0, %12] [5, 64] [2048, 1]) {id = 7 : i32} : (memref<5x2048xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %6 = air.wait_all async 
      %7 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %13 = arith.muli %arg17, %c64 : index
          %14 = air.channel.put async [%arg18]  @channel_4[%c0, %c0] (%arg13[%13, %11] [64, 64] [11008, 1]) {id = 8 : i32} : (memref<2048x11008xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = air.channel.get async [%arg16]  @channel_5[%c0, %c0] (%arg14[0, %11] [5, 64] [11008, 1]) {id = 9 : i32} : (memref<5x11008xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_5848 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_5848 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c5 = arith.constant 5 : index
          %c32_2 = arith.constant 32 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c64_3 = arith.constant 64 : index
          %c1_4 = arith.constant 1 : index
          %c172_5 = arith.constant 172 : index
          %c0_6 = arith.constant 0 : index
          %12 = air.wait_all async 
          %13 = scf.for %arg19 = %c0_6 to %c172_5 step %c1_4 iter_args(%arg20 = %12) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<320xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data"} : memref<320xf32, 2 : i32>
              air.execute_terminator %alloc : memref<320xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.initializer_task = "up.initialize", orbit.phase = 5848 : i64, orbit.storage = "U"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg21 = %c0_6 to %c5 step %c1_4 iter_args(%arg22 = %14) -> (!air.async.token) {
              %19 = scf.for %arg23 = %c0_6 to %c64_3 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_8 = air.execute [%arg24] {
                  memref.store %cst, %reinterpret_cast[%arg21, %arg23] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                }
                scf.yield %async_token_8 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg20, %15] 
            %17 = scf.for %arg21 = %c0_6 to %c32_2 step %c1_4 iter_args(%arg22 = %16) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<4096xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.64.64.loops.5.64.64"} : memref<4096xf32, 2 : i32>
                air.execute_terminator %alloc : memref<4096xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<320xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.5.64.loops.5.64.64"} : memref<320xf32, 2 : i32>
                air.execute_terminator %alloc : memref<320xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.phase = 5848 : i64, orbit.storage = "X"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_10, %arg22]  @channel_3[%arg15, %arg16] (%results_11[] [] []) {id = 10 : i32} : (memref<320xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [64, 64], strides: [64, 1] {orbit.phase = 5848 : i64, orbit.storage = "W_up"} : memref<4096xf32, 2 : i32> to memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %20 = air.channel.get async [%async_token_8, %arg22]  @channel_4[%arg15, %arg16] (%results_9[] [] []) {id = 11 : i32} : (memref<4096xf32, 2 : i32>)
              air.wait_all [%19, %20]  {orbit.computation_event = 16859 : i64, orbit.phase = 5848 : i64, orbit.phase_dependencies = array<i64: 5847>, orbit.read_copies = array<i64: 33400, 33401, 33402>, orbit.task = "up", orbit.write_copies = array<i64: 33403>}
              %21 = air.wait_all async [%19, %20] 
              %22 = scf.for %arg23 = %c0_6 to %c5 step %c1_4 iter_args(%arg24 = %21) -> (!air.async.token) {
                %23 = scf.for %arg25 = %c0_6 to %c64_3 step %c8 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %24 = scf.for %arg27 = %c0_6 to %c64_3 step %c1_4 iter_args(%arg28 = %arg26) -> (!air.async.token) {
                    %async_token_16, %results_17 = air.execute [%arg28] -> (f32) {
                      %36 = memref.load %reinterpret_cast_12[%arg23, %arg27] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %36 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg28] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast_13[%arg27, %arg25], %cst : memref<64x64xf32, strided<[64, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg28] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast[%arg23, %arg25], %cst : memref<5x64xf32, strided<[64, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %25 = vector.extract %results_19[0] : f32 from vector<8xf32>
                    %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %25) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %26 = vector.extract %results_19[1] : f32 from vector<8xf32>
                    %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %26) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %27 = vector.extract %results_19[2] : f32 from vector<8xf32>
                    %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %27) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %28 = vector.extract %results_19[3] : f32 from vector<8xf32>
                    %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %28) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %29 = vector.extract %results_19[4] : f32 from vector<8xf32>
                    %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %30 = vector.extract %results_19[5] : f32 from vector<8xf32>
                    %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %31 = vector.extract %results_19[6] : f32 from vector<8xf32>
                    %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %32 = vector.extract %results_19[7] : f32 from vector<8xf32>
                    %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %33 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                    %34 = arith.addf %results_21, %33 : vector<8xf32>
                    %async_token_38 = air.execute [%async_token_20] {
                      vector.transfer_write %34, %reinterpret_cast[%arg23, %arg25] : vector<8xf32>, memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                    }
                    %35 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %35 : !air.async.token
                  }
                  scf.yield %24 : !air.async.token
                }
                scf.yield %23 : !air.async.token
              }
              %async_token_14 = air.execute [%19] {
                memref.dealloc %results_11 : memref<320xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%20] {
                memref.dealloc %results_9 : memref<4096xf32, 2 : i32>
              }
              scf.yield %22 : !air.async.token
            }
            %18 = air.channel.put async [%async_token, %17]  @channel_5[%arg15, %arg16] (%results[] [] []) {id = 12 : i32} : (memref<320xf32, 2 : i32>)
            %async_token_7 = air.execute [%18] {
              memref.dealloc %results : memref<320xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 172 : i64}
          air.wait_all [%13] 
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %2 = air.launch @orbit_launch_11352 async [%1] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg5, %arg13=%arg6, %arg14=%arg7) : memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32> attributes {id = 7 : i32} {
      %c172 = arith.constant 172 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %4 = air.wait_all async 
      %5 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %4) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = air.channel.put async [%arg16]  @channel_6[%c0, %c0] (%arg12[0, %11] [5, 64] [11008, 1]) {id = 13 : i32} : (memref<5x11008xf32>)
        scf.yield %12 : !air.async.token
      }
      %6 = air.wait_all async 
      %7 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = air.channel.put async [%arg16]  @channel_7[%c0, %c0] (%arg13[0, %11] [5, 64] [11008, 1]) {id = 14 : i32} : (memref<5x11008xf32>)
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c172 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = air.channel.get async [%arg16]  @channel_8[%c0, %c0] (%arg14[0, %11] [5, 64] [11008, 1]) {id = 15 : i32} : (memref<5x11008xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_11352 async  attributes {id = 8 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_11352 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 9 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c5 = arith.constant 5 : index
          %c127_i32 = arith.constant 127 : i32
          %c23_i32 = arith.constant 23 : i32
          %cst = arith.constant 1.270000e+02 : f32
          %cst_2 = arith.constant -1.270000e+02 : f32
          %cst_3 = arith.constant 8.880000e+01 : f32
          %cst_4 = arith.constant -8.780000e+01 : f32
          %cst_5 = arith.constant 0.166666657 : f32
          %cst_6 = arith.constant 0.0416657962 : f32
          %cst_7 = arith.constant 0.00833345205 : f32
          %cst_8 = arith.constant 0.00139819994 : f32
          %cst_9 = arith.constant 1.98756912E-4 : f32
          %cst_10 = arith.constant 2.12194442E-4 : f32
          %cst_11 = arith.constant -0.693359375 : f32
          %cst_12 = arith.constant 1.44269502 : f32
          %cst_13 = arith.constant 5.000000e-01 : f32
          %cst_14 = arith.constant 1.000000e+00 : f32
          %c64_15 = arith.constant 64 : index
          %c1_16 = arith.constant 1 : index
          %c172_17 = arith.constant 172 : index
          %c0_18 = arith.constant 0 : index
          %12 = air.wait_all async 
          %13 = scf.for %arg19 = %c0_18 to %c172_17 step %c1_16 iter_args(%arg20 = %12) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<320xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data"} : memref<320xf32, 2 : i32>
              air.execute_terminator %alloc : memref<320xf32, 2 : i32>
            }
            %async_token_19, %results_20 = air.execute -> (memref<320xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data.input.5.64.loops.5.64"} : memref<320xf32, 2 : i32>
              air.execute_terminator %alloc : memref<320xf32, 2 : i32>
            }
            %async_token_21, %results_22 = air.execute -> (memref<320xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data.input.5.64.loops.5.64"} : memref<320xf32, 2 : i32>
              air.execute_terminator %alloc : memref<320xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results_22 to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.phase = 11352 : i64, orbit.storage = "G"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %14 = air.channel.get async [%async_token_21, %arg20]  @channel_6[%arg15, %arg16] (%results_22[] [] []) {id = 16 : i32} : (memref<320xf32, 2 : i32>)
            %reinterpret_cast_23 = memref.reinterpret_cast %results_20 to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.phase = 11352 : i64, orbit.storage = "U"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %15 = air.channel.get async [%async_token_19, %arg20]  @channel_7[%arg15, %arg16] (%results_20[] [] []) {id = 17 : i32} : (memref<320xf32, 2 : i32>)
            %reinterpret_cast_24 = memref.reinterpret_cast %results to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.phase = 11352 : i64, orbit.storage = "H"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            air.wait_all [%14, %15]  {orbit.computation_event = 33714 : i64, orbit.phase = 11352 : i64, orbit.phase_dependencies = array<i64: 11351>, orbit.read_copies = array<i64: 50256, 50257>, orbit.task = "swiglu", orbit.write_copies = array<i64: 50258>}
            %16 = air.wait_all async [%14, %15] 
            %17 = scf.for %arg21 = %c0_18 to %c5 step %c1_16 iter_args(%arg22 = %16) -> (!air.async.token) {
              %19 = scf.for %arg23 = %c0_18 to %c64_15 step %c1_16 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_28, %results_29 = air.execute [%arg24] -> (f32) {
                  %63 = memref.load %reinterpret_cast[%arg21, %arg23] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                  air.execute_terminator %63 : f32
                }
                %async_token_30, %results_31 = air.execute [%arg24] -> (f32) {
                  %63 = memref.load %reinterpret_cast_23[%arg21, %arg23] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                  air.execute_terminator %63 : f32
                }
                %20 = arith.negf %results_29 : f32
                %21 = arith.cmpf uge, %20, %cst_4 : f32
                %22 = arith.select %21, %20, %cst_4 : f32
                %23 = arith.cmpf ule, %22, %cst_3 : f32
                %24 = arith.select %23, %22, %cst_3 : f32
                %25 = arith.mulf %24, %cst_12 : f32
                %26 = arith.addf %25, %cst_13 : f32
                %27 = arith.fptosi %26 : f32 to i32
                %28 = arith.sitofp %27 : i32 to f32
                %29 = arith.cmpf olt, %26, %28 : f32
                %30 = arith.subf %28, %cst_14 : f32
                %31 = arith.select %29, %30, %28 : f32
                %32 = arith.cmpf uge, %31, %cst_2 : f32
                %33 = arith.select %32, %31, %cst_2 : f32
                %34 = arith.cmpf ule, %33, %cst : f32
                %35 = arith.select %34, %33, %cst : f32
                %36 = arith.mulf %35, %cst_11 : f32
                %37 = arith.addf %36, %24 : f32
                %38 = arith.mulf %35, %cst_10 : f32
                %39 = arith.addf %38, %37 : f32
                %40 = arith.mulf %39, %cst_9 : f32
                %41 = arith.addf %40, %cst_8 : f32
                %42 = arith.mulf %41, %39 : f32
                %43 = arith.addf %42, %cst_7 : f32
                %44 = arith.mulf %43, %39 : f32
                %45 = arith.addf %44, %cst_6 : f32
                %46 = arith.mulf %45, %39 : f32
                %47 = arith.addf %46, %cst_5 : f32
                %48 = arith.mulf %47, %39 : f32
                %49 = arith.addf %48, %cst_13 : f32
                %50 = arith.mulf %39, %39 : f32
                %51 = arith.mulf %49, %50 : f32
                %52 = arith.addf %51, %39 : f32
                %53 = arith.addf %52, %cst_14 : f32
                %54 = arith.fptosi %35 : f32 to i32
                %55 = arith.addi %54, %c127_i32 : i32
                %56 = arith.shli %55, %c23_i32 : i32
                %57 = arith.bitcast %56 : i32 to f32
                %58 = arith.mulf %53, %57 : f32
                %59 = arith.addf %58, %cst_14 : f32
                %60 = arith.divf %results_29, %59 : f32
                %61 = arith.mulf %60, %results_31 : f32
                %async_token_32 = air.execute [%arg24] {
                  memref.store %61, %reinterpret_cast_24[%arg21, %arg23] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                }
                %62 = air.wait_all async [%async_token_28, %async_token_30, %async_token_32] 
                scf.yield %62 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %18 = air.channel.put async [%async_token, %17]  @channel_8[%arg15, %arg16] (%results[] [] []) {id = 18 : i32} : (memref<320xf32, 2 : i32>)
            %async_token_25 = air.execute [%14] {
              memref.dealloc %results_22 : memref<320xf32, 2 : i32>
            }
            %async_token_26 = air.execute [%15] {
              memref.dealloc %results_20 : memref<320xf32, 2 : i32>
            }
            %async_token_27 = air.execute [%18] {
              memref.dealloc %results : memref<320xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 172 : i64}
          air.wait_all [%13] 
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %3 = air.launch @orbit_launch_11556 async [%2] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg3, %arg13=%arg4, %arg14=%arg7) : memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32> attributes {id = 10 : i32} {
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c172 = arith.constant 172 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %4 = air.wait_all async 
      %5 = scf.for %arg15 = %c0 to %c32 step %c1_0 iter_args(%arg16 = %4) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = scf.for %arg17 = %c0 to %c172 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %13 = arith.muli %arg17, %c64 : index
          %14 = air.channel.put async [%arg18]  @channel_9[%c0, %c0] (%arg12[%13, %11] [64, 64] [2048, 1]) {id = 19 : i32} : (memref<11008x2048xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %6 = air.wait_all async 
      %7 = scf.for %arg15 = %c0 to %c32 step %c1_0 iter_args(%arg16 = %6) -> (!air.async.token) {
        %11 = scf.for %arg17 = %c0 to %c172 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %12 = arith.muli %arg17, %c64 : index
          %13 = air.channel.put async [%arg18]  @channel_10[%c0, %c0] (%arg14[0, %12] [5, 64] [11008, 1]) {id = 20 : i32} : (memref<5x11008xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c32 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg15, %c64 : index
        %12 = air.channel.get async [%arg16]  @channel_11[%c0, %c0] (%arg13[0, %11] [5, 64] [2048, 1]) {id = 21 : i32} : (memref<5x2048xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_11556 async  attributes {id = 11 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_11556 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 12 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c5 = arith.constant 5 : index
          %c172_2 = arith.constant 172 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c64_3 = arith.constant 64 : index
          %c1_4 = arith.constant 1 : index
          %c32_5 = arith.constant 32 : index
          %c0_6 = arith.constant 0 : index
          %12 = air.wait_all async 
          %13 = scf.for %arg19 = %c0_6 to %c32_5 step %c1_4 iter_args(%arg20 = %12) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<320xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : memref<320xf32, 2 : i32>
              air.execute_terminator %alloc : memref<320xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.initializer_task = "down.initialize", orbit.phase = 11556 : i64, orbit.storage = "Y"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg21 = %c0_6 to %c5 step %c1_4 iter_args(%arg22 = %14) -> (!air.async.token) {
              %19 = scf.for %arg23 = %c0_6 to %c64_3 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_8 = air.execute [%arg24] {
                  memref.store %cst, %reinterpret_cast[%arg21, %arg23] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                }
                scf.yield %async_token_8 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg20, %15] 
            %17 = scf.for %arg21 = %c0_6 to %c172_2 step %c1_4 iter_args(%arg22 = %16) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<320xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data.input.5.64.loops.5.64.64"} : memref<320xf32, 2 : i32>
                air.execute_terminator %alloc : memref<320xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<4096xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.64.64.loops.5.64.64"} : memref<4096xf32, 2 : i32>
                air.execute_terminator %alloc : memref<4096xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [64, 64], strides: [64, 1] {orbit.phase = 11556 : i64, orbit.storage = "W_down"} : memref<4096xf32, 2 : i32> to memref<64x64xf32, strided<[64, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_10, %arg22]  @channel_9[%arg15, %arg16] (%results_11[] [] []) {id = 22 : i32} : (memref<4096xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [5, 64], strides: [64, 1] {orbit.phase = 11556 : i64, orbit.storage = "H"} : memref<320xf32, 2 : i32> to memref<5x64xf32, strided<[64, 1]>, 2 : i32>
              %20 = air.channel.get async [%async_token_8, %arg22]  @channel_10[%arg15, %arg16] (%results_9[] [] []) {id = 23 : i32} : (memref<320xf32, 2 : i32>)
              air.wait_all [%19, %20]  {orbit.computation_event = 34403 : i64, orbit.phase = 11556 : i64, orbit.phase_dependencies = array<i64: 11555>, orbit.read_copies = array<i64: 50944, 50946, 50945>, orbit.task = "down", orbit.write_copies = array<i64: 50947>}
              %21 = air.wait_all async [%19, %20] 
              %22 = scf.for %arg23 = %c0_6 to %c5 step %c1_4 iter_args(%arg24 = %21) -> (!air.async.token) {
                %23 = scf.for %arg25 = %c0_6 to %c64_3 step %c8 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %24 = scf.for %arg27 = %c0_6 to %c64_3 step %c1_4 iter_args(%arg28 = %arg26) -> (!air.async.token) {
                    %async_token_16, %results_17 = air.execute [%arg28] -> (f32) {
                      %36 = memref.load %reinterpret_cast_13[%arg23, %arg27] : memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %36 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg28] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast_12[%arg27, %arg25], %cst : memref<64x64xf32, strided<[64, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg28] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast[%arg23, %arg25], %cst : memref<5x64xf32, strided<[64, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %25 = vector.extract %results_19[0] : f32 from vector<8xf32>
                    %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %25) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %26 = vector.extract %results_19[1] : f32 from vector<8xf32>
                    %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %26) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %27 = vector.extract %results_19[2] : f32 from vector<8xf32>
                    %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %27) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %28 = vector.extract %results_19[3] : f32 from vector<8xf32>
                    %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %28) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %29 = vector.extract %results_19[4] : f32 from vector<8xf32>
                    %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %30 = vector.extract %results_19[5] : f32 from vector<8xf32>
                    %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %31 = vector.extract %results_19[6] : f32 from vector<8xf32>
                    %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %32 = vector.extract %results_19[7] : f32 from vector<8xf32>
                    %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                      %36 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %36 : f32
                    }
                    %33 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                    %34 = arith.addf %results_21, %33 : vector<8xf32>
                    %async_token_38 = air.execute [%async_token_20] {
                      vector.transfer_write %34, %reinterpret_cast[%arg23, %arg25] : vector<8xf32>, memref<5x64xf32, strided<[64, 1]>, 2 : i32>
                    }
                    %35 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %35 : !air.async.token
                  }
                  scf.yield %24 : !air.async.token
                }
                scf.yield %23 : !air.async.token
              }
              %async_token_14 = air.execute [%19] {
                memref.dealloc %results_11 : memref<4096xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%20] {
                memref.dealloc %results_9 : memref<320xf32, 2 : i32>
              }
              scf.yield %22 : !air.async.token
            }
            %18 = air.channel.put async [%async_token, %17]  @channel_11[%arg15, %arg16] (%results[] [] []) {id = 24 : i32} : (memref<320xf32, 2 : i32>)
            %async_token_7 = air.execute [%18] {
              memref.dealloc %results : memref<320xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 32 : i64}
          air.wait_all [%13] 
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    return
  }
}
