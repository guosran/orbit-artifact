module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "128b42b7546feae14889d2c6b5f4cbf0843173c5c25a01781d5ccd052fb5f1a7", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} {
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
  func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
  func.func @gemm_scale(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 1 : i32} {
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c2 = arith.constant 2 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_0[%c0, %c0] (%arg9[0, 0] [128, 16] [64, 1]) {id = 1 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = scf.for %arg13 = %c0 to %c2 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c64 : index
          %14 = air.channel.put async [%arg14]  @channel_1[%c0, %c0] (%arg8[%11, %13] [4, 64] [128, 1]) {id = 2 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = air.channel.get async [%arg12]  @channel_2[%c0, %c0] (%arg10[%11, 0] [4, 16] [64, 1]) {id = 3 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c64_2 = arith.constant 64 : index
          %c16 = arith.constant 16 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c4_3 = arith.constant 4 : index
          %c1_4 = arith.constant 1 : index
          %c8_5 = arith.constant 8 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_0[%arg11, %arg12] (%results[] [] []) {id = 4 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c8_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<64xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<64xf32, 2 : i32>
              air.execute_terminator %alloc : memref<64xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c0_6 to %c16 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %arg19] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c64_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_1[%arg11, %arg12] (%results_13[] [] []) {id = 5 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 3 : i64, orbit.phase = 32 : i64, orbit.phase_dependencies = array<i64: 31>, orbit.read_copies = array<i64: 24, 25, 27>, orbit.task = "gemm", orbit.write_copies = array<i64: 28>}
              %20 = scf.for %arg19 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c0_6 to %c16 step %c8_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %35 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %35 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg24] -> (vector<8xf32>) {
                      %35 = vector.transfer_read %reinterpret_cast[%23, %arg21], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %35 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (vector<8xf32>) {
                      %35 = vector.transfer_read %reinterpret_cast_10[%arg19, %arg21], %cst : memref<4x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %35 : vector<8xf32>
                    }
                    %24 = vector.extract %results_19[0] : f32 from vector<8xf32>
                    %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %24) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %25 = vector.extract %results_19[1] : f32 from vector<8xf32>
                    %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %25) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %26 = vector.extract %results_19[2] : f32 from vector<8xf32>
                    %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %26) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %27 = vector.extract %results_19[3] : f32 from vector<8xf32>
                    %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %27) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %28 = vector.extract %results_19[4] : f32 from vector<8xf32>
                    %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %28) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %29 = vector.extract %results_19[5] : f32 from vector<8xf32>
                    %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %30 = vector.extract %results_19[6] : f32 from vector<8xf32>
                    %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %31 = vector.extract %results_19[7] : f32 from vector<8xf32>
                    %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                      %35 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %35 : f32
                    }
                    %32 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                    %33 = arith.addf %results_21, %32 : vector<8xf32>
                    %async_token_38 = air.execute [%async_token_20] {
                      vector.transfer_write %33, %reinterpret_cast_10[%arg19, %arg21] : vector<8xf32>, memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %34 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %34 : !air.async.token
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
            %18 = air.channel.put async [%async_token_8, %17]  @channel_2[%arg11, %arg12] (%results_9[] [] []) {id = 6 : i32} : (memref<64xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<64xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 8 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_48 async [%0] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 4 : i32} {
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c2 = arith.constant 2 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_3[%c0, %c0] (%arg9[0, 16] [128, 16] [64, 1]) {id = 7 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = scf.for %arg13 = %c0 to %c2 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c64 : index
          %14 = air.channel.put async [%arg14]  @channel_4[%c0, %c0] (%arg8[%11, %13] [4, 64] [128, 1]) {id = 8 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = air.channel.get async [%arg12]  @channel_5[%c0, %c0] (%arg10[%11, 16] [4, 16] [64, 1]) {id = 9 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_48 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_48 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c64_2 = arith.constant 64 : index
          %c32 = arith.constant 32 : index
          %c16 = arith.constant 16 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c4_3 = arith.constant 4 : index
          %c1_4 = arith.constant 1 : index
          %c8_5 = arith.constant 8 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 48 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_3[%arg11, %arg12] (%results[] [] []) {id = 10 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c8_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<64xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<64xf32, 2 : i32>
              air.execute_terminator %alloc : memref<64xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 48 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c16 to %c32 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c16 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c64_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 48 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_4[%arg11, %arg12] (%results_13[] [] []) {id = 11 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 52 : i64, orbit.phase = 48 : i64, orbit.phase_dependencies = array<i64: 47>, orbit.read_copies = array<i64: 74, 75, 77>, orbit.task = "gemm", orbit.write_copies = array<i64: 78>}
              %20 = scf.for %arg19 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c16 to %c32 step %c8_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %36 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %36 : f32
                    }
                    %24 = arith.subi %arg21, %c16 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast[%23, %24], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast_10[%arg19, %24], %cst : memref<4x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
                      vector.transfer_write %34, %reinterpret_cast_10[%arg19, %24] : vector<8xf32>, memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %35 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %35 : !air.async.token
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
            %18 = air.channel.put async [%async_token_8, %17]  @channel_5[%arg11, %arg12] (%results_9[] [] []) {id = 12 : i32} : (memref<64xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<64xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 8 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %2 = air.launch @orbit_launch_64 async [%1] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 7 : i32} {
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c2 = arith.constant 2 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_6[%c0, %c0] (%arg9[0, 32] [128, 16] [64, 1]) {id = 13 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = scf.for %arg13 = %c0 to %c2 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c64 : index
          %14 = air.channel.put async [%arg14]  @channel_7[%c0, %c0] (%arg8[%11, %13] [4, 64] [128, 1]) {id = 14 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = air.channel.get async [%arg12]  @channel_8[%c0, %c0] (%arg10[%11, 32] [4, 16] [64, 1]) {id = 15 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_64 async  attributes {id = 8 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_64 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 9 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c64_2 = arith.constant 64 : index
          %c48 = arith.constant 48 : index
          %c32 = arith.constant 32 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c4_3 = arith.constant 4 : index
          %c1_4 = arith.constant 1 : index
          %c8_5 = arith.constant 8 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 64 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_6[%arg11, %arg12] (%results[] [] []) {id = 16 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c8_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<64xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<64xf32, 2 : i32>
              air.execute_terminator %alloc : memref<64xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 64 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c32 to %c48 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c32 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c64_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 64 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_7[%arg11, %arg12] (%results_13[] [] []) {id = 17 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 101 : i64, orbit.phase = 64 : i64, orbit.phase_dependencies = array<i64: 63>, orbit.read_copies = array<i64: 124, 125, 127>, orbit.task = "gemm", orbit.write_copies = array<i64: 128>}
              %20 = scf.for %arg19 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c32 to %c48 step %c8_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %36 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %36 : f32
                    }
                    %24 = arith.subi %arg21, %c32 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast[%23, %24], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast_10[%arg19, %24], %cst : memref<4x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
                      vector.transfer_write %34, %reinterpret_cast_10[%arg19, %24] : vector<8xf32>, memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %35 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %35 : !air.async.token
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
            %18 = air.channel.put async [%async_token_8, %17]  @channel_8[%arg11, %arg12] (%results_9[] [] []) {id = 18 : i32} : (memref<64xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<64xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 8 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %3 = air.launch @orbit_launch_80 async [%2] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 10 : i32} {
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c64 = arith.constant 64 : index
      %c2 = arith.constant 2 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.channel.put async  @channel_9[%c0, %c0] (%arg9[0, 48] [128, 16] [64, 1]) {id = 19 : i32} : (memref<128x64xf32>)
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = scf.for %arg13 = %c0 to %c2 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %13 = arith.muli %arg13, %c64 : index
          %14 = air.channel.put async [%arg14]  @channel_10[%c0, %c0] (%arg8[%11, %13] [4, 64] [128, 1]) {id = 20 : i32} : (memref<32x128xf32>)
          scf.yield %14 : !air.async.token
        }
        scf.yield %12 : !air.async.token
      }
      %8 = air.wait_all async 
      %9 = scf.for %arg11 = %c0 to %c8 step %c1_0 iter_args(%arg12 = %8) -> (!air.async.token) {
        %11 = arith.muli %arg11, %c4 : index
        %12 = air.channel.get async [%arg12]  @channel_11[%c0, %c0] (%arg10[%11, 48] [4, 16] [64, 1]) {id = 21 : i32} : (memref<32x64xf32>)
        scf.yield %12 : !air.async.token
      }
      %10 = air.segment @orbit_segment_80 async  attributes {id = 11 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %11 = air.herd @orbit_herd_80 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 12 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c128 = arith.constant 128 : index
          %c64_2 = arith.constant 64 : index
          %c48 = arith.constant 48 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c4_3 = arith.constant 4 : index
          %c1_4 = arith.constant 1 : index
          %c8_5 = arith.constant 8 : index
          %c0_6 = arith.constant 0 : index
          %async_token, %results = air.execute -> (memref<2048xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : memref<2048xf32, 2 : i32>
            air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %12 = air.channel.get async  @channel_9[%arg11, %arg12] (%results[] [] []) {id = 22 : i32} : (memref<2048xf32, 2 : i32>)
          air.wait_all [%12] 
          %13 = scf.for %arg15 = %c0_6 to %c8_5 step %c1_4 iter_args(%arg16 = %12) -> (!air.async.token) {
            %async_token_8, %results_9 = air.execute -> (memref<64xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<64xf32, 2 : i32>
              air.execute_terminator %alloc : memref<64xf32, 2 : i32>
            }
            %reinterpret_cast_10 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 80 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %14 = air.wait_all async 
            %15 = scf.for %arg17 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg18 = %14) -> (!air.async.token) {
              %19 = scf.for %arg19 = %c48 to %c64_2 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %20 = arith.subi %arg19, %c48 : index
                %async_token_12 = air.execute [%arg20] {
                  memref.store %cst, %reinterpret_cast_10[%arg17, %20] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                }
                scf.yield %async_token_12 : !air.async.token
              }
              scf.yield %19 : !air.async.token
            }
            %16 = air.wait_all async [%arg16, %15] 
            %17 = scf.for %arg17 = %c0_6 to %c128 step %c64_2 iter_args(%arg18 = %16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_14 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 80 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %19 = air.channel.get async [%async_token_12, %arg18]  @channel_10[%arg11, %arg12] (%results_13[] [] []) {id = 23 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%19]  {orbit.computation_event = 150 : i64, orbit.phase = 80 : i64, orbit.phase_dependencies = array<i64: 79>, orbit.read_copies = array<i64: 174, 175, 177>, orbit.task = "gemm", orbit.write_copies = array<i64: 178>}
              %20 = scf.for %arg19 = %c0_6 to %c4_3 step %c1_4 iter_args(%arg20 = %19) -> (!air.async.token) {
                %21 = scf.for %arg21 = %c48 to %c64_2 step %c8_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %22 = scf.for %arg23 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %23 = arith.addi %arg23, %arg17 : index
                    %async_token_16, %results_17 = air.execute [%arg24] -> (f32) {
                      %36 = memref.load %reinterpret_cast_14[%arg19, %arg23] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %36 : f32
                    }
                    %24 = arith.subi %arg21, %c48 : index
                    %async_token_18, %results_19 = air.execute [%arg24] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast[%23, %24], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %36 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg24] -> (vector<8xf32>) {
                      %36 = vector.transfer_read %reinterpret_cast_10[%arg19, %24], %cst : memref<4x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
                      vector.transfer_write %34, %reinterpret_cast_10[%arg19, %24] : vector<8xf32>, memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                    }
                    %35 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %35 : !air.async.token
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
            %18 = air.channel.put async [%async_token_8, %17]  @channel_11[%arg11, %arg12] (%results_9[] [] []) {id = 24 : i32} : (memref<64xf32, 2 : i32>)
            %async_token_11 = air.execute [%18] {
              memref.dealloc %results_9 : memref<64xf32, 2 : i32>
            }
            scf.yield %18 : !air.async.token
          } {orbit.compressed_phases = 8 : i64}
          air.wait_all [%13] 
          %async_token_7 = air.execute [%async_token] {
            memref.dealloc %results : memref<2048xf32, 2 : i32>
          }
        }
        air.wait_all [%11]  {air.segment_end}
      }
    }
    %4 = air.launch @orbit_launch_96 async [%3] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<32x64xf32>, memref<32x64xf32> attributes {id = 13 : i32} {
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %5 = air.wait_all async 
      %6 = scf.for %arg10 = %c0 to %c8 step %c1_0 iter_args(%arg11 = %5) -> (!air.async.token) {
        %10 = arith.muli %arg10, %c4 : index
        %11 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %12 = arith.muli %arg12, %c16 : index
          %13 = air.channel.put async [%arg13]  @channel_12[%c0, %c0] (%arg9[%10, %12] [4, 16] [64, 1]) {id = 25 : i32} : (memref<32x64xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %7 = air.wait_all async 
      %8 = scf.for %arg10 = %c0 to %c8 step %c1_0 iter_args(%arg11 = %7) -> (!air.async.token) {
        %10 = arith.muli %arg10, %c4 : index
        %11 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %12 = arith.muli %arg12, %c16 : index
          %13 = air.channel.get async [%arg13]  @channel_13[%c0, %c0] (%arg8[%10, %12] [4, 16] [64, 1]) {id = 26 : i32} : (memref<32x64xf32>)
          scf.yield %13 : !air.async.token
        }
        scf.yield %11 : !air.async.token
      }
      %9 = air.segment @orbit_segment_96 async  attributes {id = 14 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c8_1 = arith.constant 8 : index
        %c4_2 = arith.constant 4 : index
        %c1_3 = arith.constant 1 : index
        %c0_4 = arith.constant 0 : index
        %10 = air.wait_all async 
        %11 = scf.for %arg10 = %c0_4 to %c8_1 step %c1_3 iter_args(%arg11 = %10) -> (!air.async.token) {
          %15 = scf.for %arg12 = %c0_4 to %c4_2 step %c1_3 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %16 = air.wait_all async 
            scf.yield %16 : !air.async.token
          }
          scf.yield %15 : !air.async.token
        }
        %12 = air.wait_all async 
        %13 = scf.for %arg10 = %c0_4 to %c8_1 step %c1_3 iter_args(%arg11 = %12) -> (!air.async.token) {
          %15 = scf.for %arg12 = %c0_4 to %c4_2 step %c1_3 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %16 = air.wait_all async 
            scf.yield %16 : !air.async.token
          }
          scf.yield %15 : !air.async.token
        }
        %14 = air.herd @orbit_herd_96 async  tile (%arg10, %arg11) in (%arg12=%c1_3, %arg13=%c1_3) attributes {id = 15 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 5.000000e-01 : f32
          %cst_5 = arith.constant 0.000000e+00 : f32
          %c16_6 = arith.constant 16 : index
          %c4_7 = arith.constant 4 : index
          %c1_8 = arith.constant 1 : index
          %c8_9 = arith.constant 8 : index
          %c0_10 = arith.constant 0 : index
          %15 = air.wait_all async 
          %16 = scf.for %arg14 = %c0_10 to %c8_9 step %c1_8 iter_args(%arg15 = %15) -> (!air.async.token) {
            %17 = scf.for %arg16 = %c0_10 to %c4_7 step %c1_8 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.4.16.loops.4.16"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %async_token_11, %results_12 = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results_12 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.phase = 96 : i64, orbit.storage = "Y"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
              %reinterpret_cast_13 = memref.reinterpret_cast %results to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.phase = 96 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
              %18 = air.channel.get async [%async_token, %arg17]  @channel_12[%arg10, %arg11] (%results[] [] []) {id = 27 : i32} : (memref<64xf32, 2 : i32>)
              air.wait_all [%18]  {orbit.computation_event = 197 : i64, orbit.phase = 96 : i64, orbit.phase_dependencies = array<i64: 95>, orbit.read_copies = array<i64: 224>, orbit.task = "scale", orbit.write_copies = array<i64: 225>}
              %19 = scf.for %arg18 = %c0_10 to %c4_7 step %c1_8 iter_args(%arg19 = %18) -> (!air.async.token) {
                %21 = scf.for %arg20 = %c0_10 to %c16_6 step %c8_9 iter_args(%arg21 = %arg19) -> (!air.async.token) {
                  %async_token_16, %results_17 = air.execute [%arg21] -> (vector<8xf32>) {
                    %32 = vector.transfer_read %reinterpret_cast_13[%arg18, %arg20], %cst_5 : memref<4x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %32 : vector<8xf32>
                  }
                  %22 = vector.extract %results_17[0] : f32 from vector<8xf32>
                  %async_token_18, %results_19 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%22, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %23 = vector.extract %results_17[1] : f32 from vector<8xf32>
                  %async_token_20, %results_21 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%23, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %24 = vector.extract %results_17[2] : f32 from vector<8xf32>
                  %async_token_22, %results_23 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%24, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %25 = vector.extract %results_17[3] : f32 from vector<8xf32>
                  %async_token_24, %results_25 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%25, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %26 = vector.extract %results_17[4] : f32 from vector<8xf32>
                  %async_token_26, %results_27 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%26, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %27 = vector.extract %results_17[5] : f32 from vector<8xf32>
                  %async_token_28, %results_29 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%27, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %28 = vector.extract %results_17[6] : f32 from vector<8xf32>
                  %async_token_30, %results_31 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%28, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %29 = vector.extract %results_17[7] : f32 from vector<8xf32>
                  %async_token_32, %results_33 = air.execute [%arg21] -> (f32) {
                    %32 = func.call @__mulsf3(%29, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %32 : f32
                  }
                  %30 = vector.from_elements %results_19, %results_21, %results_23, %results_25, %results_27, %results_29, %results_31, %results_33 : vector<8xf32>
                  %async_token_34 = air.execute [%arg21] {
                    vector.transfer_write %30, %reinterpret_cast[%arg18, %arg20] : vector<8xf32>, memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  %31 = air.wait_all async [%async_token_16, %async_token_18, %async_token_20, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34] 
                  scf.yield %31 : !air.async.token
                }
                scf.yield %21 : !air.async.token
              }
              %20 = air.channel.put async [%async_token_11, %19]  @channel_13[%arg10, %arg11] (%results_12[] [] []) {id = 28 : i32} : (memref<64xf32, 2 : i32>)
              %async_token_14 = air.execute [%20] {
                memref.dealloc %results_12 : memref<64xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%18] {
                memref.dealloc %results : memref<64xf32, 2 : i32>
              }
              scf.yield %20 : !air.async.token
            } {orbit.compressed_phases = 4 : i64}
            scf.yield %17 : !air.async.token
          } {orbit.compressed_phases = 8 : i64}
          air.wait_all [%16] 
        }
        air.wait_all [%11, %13, %14]  {air.segment_end}
      }
    }
    return
  }
}
