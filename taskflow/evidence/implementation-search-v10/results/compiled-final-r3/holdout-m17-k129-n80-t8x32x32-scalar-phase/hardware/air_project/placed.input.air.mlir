module attributes {orbit.async_herd_scope = "module", orbit.channel_conversion_scope = "module", orbit.channel_input_fingerprint = "382113b46b9487b86c800bb9d45145178a5e0a78e451d072e113c61addf0275f", orbit.channel_legalization = "checked-storage-compute-dma-ports-v1", orbit.channel_pre_merge_fingerprint = "ddaaa51bc4f6ae13a662cc821a6e48238824866ca513656604a1a9722eaa7f32", orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.local_release_scope = "static-hardware-stage", orbit.mapping_plan = "dfb3ebbb5c80c5573c131f3302249e22b92738016036ab97bf175299203d50d7", orbit.source_fingerprint = "912511a293a64cce8e0d6c281bea7fa9b2ada1f653348173aee833f4c600a053"} {
  air.channel @__orbit_fifo_stage0_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage0_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage0_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage1_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage1_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage1_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage2_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage2_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage2_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage3_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage3_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage3_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage4_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage4_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage4_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage5_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage5_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage5_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage6_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage6_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage6_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage7_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage7_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage7_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @__orbit_fifo_stage8_storage0_in [1, 1] {air.tile_dma_channel = 0 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage8_storage1_in [1, 1] {air.tile_dma_channel = 1 : i32, channel_type = "npu_dma_packet"}
  air.channel @__orbit_fifo_stage8_storage3_out [1, 1] {air.tile_dma_channel = 0 : i32}
  air.channel @channel_45 [1, 1]
  air.channel @channel_46 [1, 1]
  air.channel @channel_47 [1, 1]
  air.channel @channel_48 [1, 1]
  air.channel @channel_49 [1, 1]
  air.channel @channel_50 [1, 1]
  air.channel @channel_51 [1, 1]
  air.channel @channel_52 [1, 1]
  air.channel @channel_53 [1, 1]
  air.channel @channel_54 [1, 1]
  air.channel @channel_55 [1, 1]
  air.channel @channel_56 [1, 1]
  func.func @gemm_scale(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 1 : i32} {
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage0_storage0_in[%c0, %c0] (%arg8[0, %23] [8, 32] [129, 1]) {id = 1 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage0_storage1_in[%c0, %c0] (%arg9[%23, 0] [32, 32] [80, 1]) {id = 2 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage0_storage0_in[%c0, %c0] (%arg8[0, 128] [8, 1] [129, 1]) {id = 3 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage0_storage1_in[%c0, %c0] (%arg9[128, 0] [1, 32] [80, 1]) {id = 4 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage0_storage3_out[%c0, %c0] (%arg10[0, 0] [8, 32] [80, 1]) {id = 5 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c4_2 = arith.constant 4 : index
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c8 = arith.constant 8 : index
          %c0_5 = arith.constant 0 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<8xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : memref<8xf32, 2 : i32>
            air.execute_terminator %alloc : memref<8xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<256xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<256xf32, 2 : i32>
            air.execute_terminator %alloc : memref<256xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 9 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c0_5 to %c8 step %c1_4 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c0_5 to %c32_3 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %async_token_12 = air.execute [%arg18] {
                memref.store %cst, %reinterpret_cast[%arg15, %arg17] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              scf.yield %async_token_12 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_5 to %c4_2 step %c1_4 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<1024xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : memref<1024xf32, 2 : i32>
              air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 9 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage0_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 6 : i32} : (memref<256xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 9 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage0_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 7 : i32} : (memref<1024xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 3 : i64, orbit.phase = 9 : i64, orbit.phase_dependencies = array<i64: 8>, orbit.read_copies = array<i64: 30, 31, 32>, orbit.task = "gemm", orbit.write_copies = array<i64: 33>}
            %33 = scf.for %arg17 = %c0_5 to %c8 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c0_5 to %c32_3 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %35 = scf.for %arg21 = %c0_5 to %c32_3 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %async_token_18, %results_19 = air.execute [%arg22] -> (f32) {
                    %39 = memref.load %reinterpret_cast_16[%arg17, %arg21] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %39 : f32
                  }
                  %async_token_20, %results_21 = air.execute [%arg22] -> (f32) {
                    %39 = memref.load %reinterpret_cast_17[%arg21, %arg19] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %39 : f32
                  }
                  %async_token_22, %results_23 = air.execute [%arg22] -> (f32) {
                    %39 = memref.load %reinterpret_cast[%arg17, %arg19] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %39 : f32
                  }
                  %36 = arith.mulf %results_19, %results_21 : f32
                  %37 = arith.addf %results_23, %36 : f32
                  %async_token_24 = air.execute [%async_token_22] {
                    memref.store %37, %reinterpret_cast[%arg17, %arg19] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %38 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                  scf.yield %38 : !air.async.token
                }
                scf.yield %35 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 13 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage0_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 8 : i32} : (memref<8xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 13 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage0_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 9 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 15 : i64, orbit.phase = 13 : i64, orbit.phase_dependencies = array<i64: 12>, orbit.read_copies = array<i64: 43, 44, 42>, orbit.task = "gemm", orbit.write_copies = array<i64: 45>}
          %29 = scf.for %arg15 = %c0_5 to %c8 step %c1_4 iter_args(%arg16 = %26) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c0_5 to %c32_3 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute [%arg18] -> (f32) {
                %35 = memref.load %reinterpret_cast_10[%arg15, %c0_5] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
                air.execute_terminator %35 : f32
              }
              %async_token_14, %results_15 = air.execute [%arg18] -> (f32) {
                %35 = memref.load %reinterpret_cast_11[%c0_5, %arg17] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %35 : f32
              }
              %async_token_16, %results_17 = air.execute [%arg18] -> (f32) {
                %35 = memref.load %reinterpret_cast[%arg15, %arg17] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %35 : f32
              }
              %32 = arith.mulf %results_13, %results_15 : f32
              %33 = arith.addf %results_17, %32 : f32
              %async_token_18 = air.execute [%async_token_16] {
                memref.store %33, %reinterpret_cast[%arg15, %arg17] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              %34 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
              scf.yield %34 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage0_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 10 : i32} : (memref<256xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %1 = air.launch @orbit_launch_14 async [%0] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 4 : i32} {
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage1_storage0_in[%c0, %c0] (%arg8[0, %23] [8, 32] [129, 1]) {id = 11 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage1_storage1_in[%c0, %c0] (%arg9[%23, 32] [32, 32] [80, 1]) {id = 12 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage1_storage0_in[%c0, %c0] (%arg8[0, 128] [8, 1] [129, 1]) {id = 13 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage1_storage1_in[%c0, %c0] (%arg9[128, 32] [1, 32] [80, 1]) {id = 14 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage1_storage3_out[%c0, %c0] (%arg10[0, 32] [8, 32] [80, 1]) {id = 15 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_14 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_14 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c4_2 = arith.constant 4 : index
          %c64 = arith.constant 64 : index
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c8 = arith.constant 8 : index
          %c0_5 = arith.constant 0 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<8xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : memref<8xf32, 2 : i32>
            air.execute_terminator %alloc : memref<8xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<256xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<256xf32, 2 : i32>
            air.execute_terminator %alloc : memref<256xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 14 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c0_5 to %c8 step %c1_4 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c32_3 to %c64 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg17, %c32_3 : index
              %async_token_12 = air.execute [%arg18] {
                memref.store %cst, %reinterpret_cast[%arg15, %32] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              scf.yield %async_token_12 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_5 to %c4_2 step %c1_4 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<1024xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : memref<1024xf32, 2 : i32>
              air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 14 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage1_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 16 : i32} : (memref<256xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 14 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage1_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 17 : i32} : (memref<1024xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 20 : i64, orbit.phase = 14 : i64, orbit.phase_dependencies = array<i64: 13>, orbit.read_copies = array<i64: 47, 48, 49>, orbit.task = "gemm", orbit.write_copies = array<i64: 50>}
            %33 = scf.for %arg17 = %c0_5 to %c8 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c32_3 to %c64 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %35 = scf.for %arg21 = %c0_5 to %c32_3 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %async_token_18, %results_19 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast_16[%arg17, %arg21] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %36 = arith.subi %arg19, %c32_3 : index
                  %async_token_20, %results_21 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast_17[%arg21, %36] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %async_token_22, %results_23 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast[%arg17, %36] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %37 = arith.mulf %results_19, %results_21 : f32
                  %38 = arith.addf %results_23, %37 : f32
                  %async_token_24 = air.execute [%async_token_22] {
                    memref.store %38, %reinterpret_cast[%arg17, %36] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %39 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                  scf.yield %39 : !air.async.token
                }
                scf.yield %35 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 18 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage1_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 18 : i32} : (memref<8xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 18 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage1_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 19 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 32 : i64, orbit.phase = 18 : i64, orbit.phase_dependencies = array<i64: 17>, orbit.read_copies = array<i64: 60, 61, 59>, orbit.task = "gemm", orbit.write_copies = array<i64: 62>}
          %29 = scf.for %arg15 = %c0_5 to %c8 step %c1_4 iter_args(%arg16 = %26) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c32_3 to %c64 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast_10[%arg15, %c0_5] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %32 = arith.subi %arg17, %c32_3 : index
              %async_token_14, %results_15 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast_11[%c0_5, %32] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %async_token_16, %results_17 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast[%arg15, %32] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %33 = arith.mulf %results_13, %results_15 : f32
              %34 = arith.addf %results_17, %33 : f32
              %async_token_18 = air.execute [%async_token_16] {
                memref.store %34, %reinterpret_cast[%arg15, %32] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              %35 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
              scf.yield %35 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage1_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 20 : i32} : (memref<256xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %2 = air.launch @orbit_launch_19 async [%1] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 7 : i32} {
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage2_storage0_in[%c0, %c0] (%arg8[0, %23] [8, 32] [129, 1]) {id = 21 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage2_storage1_in[%c0, %c0] (%arg9[%23, 64] [32, 16] [80, 1]) {id = 22 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage2_storage0_in[%c0, %c0] (%arg8[0, 128] [8, 1] [129, 1]) {id = 23 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage2_storage1_in[%c0, %c0] (%arg9[128, 64] [1, 16] [80, 1]) {id = 24 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage2_storage3_out[%c0, %c0] (%arg10[0, 64] [8, 16] [80, 1]) {id = 25 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_19 async  attributes {id = 8 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_19 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 9 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c32_2 = arith.constant 32 : index
          %c4_3 = arith.constant 4 : index
          %c80 = arith.constant 80 : index
          %c64 = arith.constant 64 : index
          %c1_4 = arith.constant 1 : index
          %c8 = arith.constant 8 : index
          %c0_5 = arith.constant 0 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<8xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : memref<8xf32, 2 : i32>
            air.execute_terminator %alloc : memref<8xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<16xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : memref<16xf32, 2 : i32>
            air.execute_terminator %alloc : memref<16xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
            air.execute_terminator %alloc : memref<128xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 19 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c0_5 to %c8 step %c1_4 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c64 to %c80 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg17, %c64 : index
              %async_token_12 = air.execute [%arg18] {
                memref.store %cst, %reinterpret_cast[%arg15, %32] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              }
              scf.yield %async_token_12 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_5 to %c4_3 step %c1_4 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<512xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : memref<512xf32, 2 : i32>
              air.execute_terminator %alloc : memref<512xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 19 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage2_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 26 : i32} : (memref<256xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 19 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage2_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 27 : i32} : (memref<512xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 37 : i64, orbit.phase = 19 : i64, orbit.phase_dependencies = array<i64: 18>, orbit.read_copies = array<i64: 64, 65, 66>, orbit.task = "gemm", orbit.write_copies = array<i64: 67>}
            %33 = scf.for %arg17 = %c0_5 to %c8 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c64 to %c80 step %c1_4 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %35 = scf.for %arg21 = %c0_5 to %c32_2 step %c1_4 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %async_token_18, %results_19 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast_16[%arg17, %arg21] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %36 = arith.subi %arg19, %c64 : index
                  %async_token_20, %results_21 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast_17[%arg21, %36] : memref<32x16xf32, strided<[16, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %async_token_22, %results_23 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast[%arg17, %36] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %37 = arith.mulf %results_19, %results_21 : f32
                  %38 = arith.addf %results_23, %37 : f32
                  %async_token_24 = air.execute [%async_token_22] {
                    memref.store %38, %reinterpret_cast[%arg17, %36] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  %39 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                  scf.yield %39 : !air.async.token
                }
                scf.yield %35 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 23 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage2_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 28 : i32} : (memref<8xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 23 : i64, orbit.storage = "B"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage2_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 29 : i32} : (memref<16xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 49 : i64, orbit.phase = 23 : i64, orbit.phase_dependencies = array<i64: 22>, orbit.read_copies = array<i64: 77, 78, 76>, orbit.task = "gemm", orbit.write_copies = array<i64: 79>}
          %29 = scf.for %arg15 = %c0_5 to %c8 step %c1_4 iter_args(%arg16 = %26) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c64 to %c80 step %c1_4 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %async_token_12, %results_13 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast_10[%arg15, %c0_5] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %32 = arith.subi %arg17, %c64 : index
              %async_token_14, %results_15 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast_11[%c0_5, %32] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %async_token_16, %results_17 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast[%arg15, %32] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %33 = arith.mulf %results_13, %results_15 : f32
              %34 = arith.addf %results_17, %33 : f32
              %async_token_18 = air.execute [%async_token_16] {
                memref.store %34, %reinterpret_cast[%arg15, %32] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              }
              %35 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
              scf.yield %35 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage2_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 30 : i32} : (memref<128xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %3 = air.launch @orbit_launch_24 async [%2] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 10 : i32} {
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage3_storage0_in[%c0, %c0] (%arg8[8, %23] [8, 32] [129, 1]) {id = 31 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage3_storage1_in[%c0, %c0] (%arg9[%23, 0] [32, 32] [80, 1]) {id = 32 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage3_storage0_in[%c0, %c0] (%arg8[8, 128] [8, 1] [129, 1]) {id = 33 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage3_storage1_in[%c0, %c0] (%arg9[128, 0] [1, 32] [80, 1]) {id = 34 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage3_storage3_out[%c0, %c0] (%arg10[8, 0] [8, 32] [80, 1]) {id = 35 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_24 async  attributes {id = 11 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_24 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 12 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c4_2 = arith.constant 4 : index
          %c32_3 = arith.constant 32 : index
          %c0_4 = arith.constant 0 : index
          %c1_5 = arith.constant 1 : index
          %c16 = arith.constant 16 : index
          %c8 = arith.constant 8 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<8xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : memref<8xf32, 2 : i32>
            air.execute_terminator %alloc : memref<8xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<256xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<256xf32, 2 : i32>
            air.execute_terminator %alloc : memref<256xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c8 to %c16 step %c1_5 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg15, %c8 : index
              %async_token_12 = air.execute [%arg18] {
                memref.store %cst, %reinterpret_cast[%32, %arg17] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              scf.yield %async_token_12 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_4 to %c4_2 step %c1_5 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<1024xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : memref<1024xf32, 2 : i32>
              air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 24 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage3_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 36 : i32} : (memref<256xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 24 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage3_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 37 : i32} : (memref<1024xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 54 : i64, orbit.phase = 24 : i64, orbit.phase_dependencies = array<i64: 23>, orbit.read_copies = array<i64: 81, 82, 83>, orbit.task = "gemm", orbit.write_copies = array<i64: 84>}
            %33 = scf.for %arg17 = %c8 to %c16 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %35 = scf.for %arg21 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %36 = arith.subi %arg17, %c8 : index
                  %async_token_18, %results_19 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast_16[%36, %arg21] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %async_token_20, %results_21 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast_17[%arg21, %arg19] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %async_token_22, %results_23 = air.execute [%arg22] -> (f32) {
                    %40 = memref.load %reinterpret_cast[%36, %arg19] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %40 : f32
                  }
                  %37 = arith.mulf %results_19, %results_21 : f32
                  %38 = arith.addf %results_23, %37 : f32
                  %async_token_24 = air.execute [%async_token_22] {
                    memref.store %38, %reinterpret_cast[%36, %arg19] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %39 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                  scf.yield %39 : !air.async.token
                }
                scf.yield %35 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 28 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage3_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 38 : i32} : (memref<8xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 28 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage3_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 39 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 66 : i64, orbit.phase = 28 : i64, orbit.phase_dependencies = array<i64: 27>, orbit.read_copies = array<i64: 94, 95, 93>, orbit.task = "gemm", orbit.write_copies = array<i64: 96>}
          %29 = scf.for %arg15 = %c8 to %c16 step %c1_5 iter_args(%arg16 = %26) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg15, %c8 : index
              %async_token_12, %results_13 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast_10[%32, %c0_4] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %async_token_14, %results_15 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast_11[%c0_4, %arg17] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %async_token_16, %results_17 = air.execute [%arg18] -> (f32) {
                %36 = memref.load %reinterpret_cast[%32, %arg17] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %36 : f32
              }
              %33 = arith.mulf %results_13, %results_15 : f32
              %34 = arith.addf %results_17, %33 : f32
              %async_token_18 = air.execute [%async_token_16] {
                memref.store %34, %reinterpret_cast[%32, %arg17] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              %35 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
              scf.yield %35 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage3_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 40 : i32} : (memref<256xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %4 = air.launch @orbit_launch_29 async [%3] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 13 : i32} {
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage4_storage0_in[%c0, %c0] (%arg8[8, %23] [8, 32] [129, 1]) {id = 41 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage4_storage1_in[%c0, %c0] (%arg9[%23, 32] [32, 32] [80, 1]) {id = 42 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage4_storage0_in[%c0, %c0] (%arg8[8, 128] [8, 1] [129, 1]) {id = 43 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage4_storage1_in[%c0, %c0] (%arg9[128, 32] [1, 32] [80, 1]) {id = 44 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage4_storage3_out[%c0, %c0] (%arg10[8, 32] [8, 32] [80, 1]) {id = 45 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_29 async  attributes {id = 14 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_29 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 15 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c4_2 = arith.constant 4 : index
          %c0_3 = arith.constant 0 : index
          %c64 = arith.constant 64 : index
          %c32_4 = arith.constant 32 : index
          %c1_5 = arith.constant 1 : index
          %c16 = arith.constant 16 : index
          %c8 = arith.constant 8 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<8xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.32.1"} : memref<8xf32, 2 : i32>
            air.execute_terminator %alloc : memref<8xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.8.32.1"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<256xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<256xf32, 2 : i32>
            air.execute_terminator %alloc : memref<256xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 29 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c8 to %c16 step %c1_5 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c32_4 to %c64 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg15, %c8 : index
              %33 = arith.subi %arg17, %c32_4 : index
              %async_token_12 = air.execute [%arg18] {
                memref.store %cst, %reinterpret_cast[%32, %33] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              scf.yield %async_token_12 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_3 to %c4_2 step %c1_5 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<1024xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.8.32.32"} : memref<1024xf32, 2 : i32>
              air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.32.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 29 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage4_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 46 : i32} : (memref<256xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 29 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage4_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 47 : i32} : (memref<1024xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 71 : i64, orbit.phase = 29 : i64, orbit.phase_dependencies = array<i64: 28>, orbit.read_copies = array<i64: 98, 99, 100>, orbit.task = "gemm", orbit.write_copies = array<i64: 101>}
            %33 = scf.for %arg17 = %c8 to %c16 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c32_4 to %c64 step %c1_5 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %35 = scf.for %arg21 = %c0_3 to %c32_4 step %c1_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %36 = arith.subi %arg17, %c8 : index
                  %async_token_18, %results_19 = air.execute [%arg22] -> (f32) {
                    %41 = memref.load %reinterpret_cast_16[%36, %arg21] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %41 : f32
                  }
                  %37 = arith.subi %arg19, %c32_4 : index
                  %async_token_20, %results_21 = air.execute [%arg22] -> (f32) {
                    %41 = memref.load %reinterpret_cast_17[%arg21, %37] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %41 : f32
                  }
                  %async_token_22, %results_23 = air.execute [%arg22] -> (f32) {
                    %41 = memref.load %reinterpret_cast[%36, %37] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %41 : f32
                  }
                  %38 = arith.mulf %results_19, %results_21 : f32
                  %39 = arith.addf %results_23, %38 : f32
                  %async_token_24 = air.execute [%async_token_22] {
                    memref.store %39, %reinterpret_cast[%36, %37] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %40 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                  scf.yield %40 : !air.async.token
                }
                scf.yield %35 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 33 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage4_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 48 : i32} : (memref<8xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 33 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage4_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 49 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 83 : i64, orbit.phase = 33 : i64, orbit.phase_dependencies = array<i64: 32>, orbit.read_copies = array<i64: 111, 112, 110>, orbit.task = "gemm", orbit.write_copies = array<i64: 113>}
          %29 = scf.for %arg15 = %c8 to %c16 step %c1_5 iter_args(%arg16 = %26) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c32_4 to %c64 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg15, %c8 : index
              %async_token_12, %results_13 = air.execute [%arg18] -> (f32) {
                %37 = memref.load %reinterpret_cast_10[%32, %c0_3] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
                air.execute_terminator %37 : f32
              }
              %33 = arith.subi %arg17, %c32_4 : index
              %async_token_14, %results_15 = air.execute [%arg18] -> (f32) {
                %37 = memref.load %reinterpret_cast_11[%c0_3, %33] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %37 : f32
              }
              %async_token_16, %results_17 = air.execute [%arg18] -> (f32) {
                %37 = memref.load %reinterpret_cast[%32, %33] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %37 : f32
              }
              %34 = arith.mulf %results_13, %results_15 : f32
              %35 = arith.addf %results_17, %34 : f32
              %async_token_18 = air.execute [%async_token_16] {
                memref.store %35, %reinterpret_cast[%32, %33] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              }
              %36 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
              scf.yield %36 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage4_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 50 : i32} : (memref<256xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %5 = air.launch @orbit_launch_34 async [%4] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 16 : i32} {
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage5_storage0_in[%c0, %c0] (%arg8[8, %23] [8, 32] [129, 1]) {id = 51 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage5_storage1_in[%c0, %c0] (%arg9[%23, 64] [32, 16] [80, 1]) {id = 52 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage5_storage0_in[%c0, %c0] (%arg8[8, 128] [8, 1] [129, 1]) {id = 53 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage5_storage1_in[%c0, %c0] (%arg9[128, 64] [1, 16] [80, 1]) {id = 54 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage5_storage3_out[%c0, %c0] (%arg10[8, 64] [8, 16] [80, 1]) {id = 55 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_34 async  attributes {id = 17 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_34 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 18 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c32_2 = arith.constant 32 : index
          %c4_3 = arith.constant 4 : index
          %c0_4 = arith.constant 0 : index
          %c80 = arith.constant 80 : index
          %c64 = arith.constant 64 : index
          %c1_5 = arith.constant 1 : index
          %c16 = arith.constant 16 : index
          %c8 = arith.constant 8 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<8xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.1.loops.8.16.1"} : memref<8xf32, 2 : i32>
            air.execute_terminator %alloc : memref<8xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<16xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.8.16.1"} : memref<16xf32, 2 : i32>
            air.execute_terminator %alloc : memref<16xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<128xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
            air.execute_terminator %alloc : memref<128xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 34 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c8 to %c16 step %c1_5 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c64 to %c80 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg15, %c8 : index
              %33 = arith.subi %arg17, %c64 : index
              %async_token_12 = air.execute [%arg18] {
                memref.store %cst, %reinterpret_cast[%32, %33] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              }
              scf.yield %async_token_12 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_4 to %c4_3 step %c1_5 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<512xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : memref<512xf32, 2 : i32>
              air.execute_terminator %alloc : memref<512xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 34 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage5_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 56 : i32} : (memref<256xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 34 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage5_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 57 : i32} : (memref<512xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 88 : i64, orbit.phase = 34 : i64, orbit.phase_dependencies = array<i64: 33>, orbit.read_copies = array<i64: 115, 116, 117>, orbit.task = "gemm", orbit.write_copies = array<i64: 118>}
            %33 = scf.for %arg17 = %c8 to %c16 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c64 to %c80 step %c1_5 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %35 = scf.for %arg21 = %c0_4 to %c32_2 step %c1_5 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %36 = arith.subi %arg17, %c8 : index
                  %async_token_18, %results_19 = air.execute [%arg22] -> (f32) {
                    %41 = memref.load %reinterpret_cast_16[%36, %arg21] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                    air.execute_terminator %41 : f32
                  }
                  %37 = arith.subi %arg19, %c64 : index
                  %async_token_20, %results_21 = air.execute [%arg22] -> (f32) {
                    %41 = memref.load %reinterpret_cast_17[%arg21, %37] : memref<32x16xf32, strided<[16, 1]>, 2 : i32>
                    air.execute_terminator %41 : f32
                  }
                  %async_token_22, %results_23 = air.execute [%arg22] -> (f32) {
                    %41 = memref.load %reinterpret_cast[%36, %37] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                    air.execute_terminator %41 : f32
                  }
                  %38 = arith.mulf %results_19, %results_21 : f32
                  %39 = arith.addf %results_23, %38 : f32
                  %async_token_24 = air.execute [%async_token_22] {
                    memref.store %39, %reinterpret_cast[%36, %37] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  %40 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                  scf.yield %40 : !air.async.token
                }
                scf.yield %35 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 38 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage5_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 58 : i32} : (memref<8xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 38 : i64, orbit.storage = "B"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage5_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 59 : i32} : (memref<16xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 100 : i64, orbit.phase = 38 : i64, orbit.phase_dependencies = array<i64: 37>, orbit.read_copies = array<i64: 128, 129, 127>, orbit.task = "gemm", orbit.write_copies = array<i64: 130>}
          %29 = scf.for %arg15 = %c8 to %c16 step %c1_5 iter_args(%arg16 = %26) -> (!air.async.token) {
            %31 = scf.for %arg17 = %c64 to %c80 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %32 = arith.subi %arg15, %c8 : index
              %async_token_12, %results_13 = air.execute [%arg18] -> (f32) {
                %37 = memref.load %reinterpret_cast_10[%32, %c0_4] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
                air.execute_terminator %37 : f32
              }
              %33 = arith.subi %arg17, %c64 : index
              %async_token_14, %results_15 = air.execute [%arg18] -> (f32) {
                %37 = memref.load %reinterpret_cast_11[%c0_4, %33] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
                air.execute_terminator %37 : f32
              }
              %async_token_16, %results_17 = air.execute [%arg18] -> (f32) {
                %37 = memref.load %reinterpret_cast[%32, %33] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                air.execute_terminator %37 : f32
              }
              %34 = arith.mulf %results_13, %results_15 : f32
              %35 = arith.addf %results_17, %34 : f32
              %async_token_18 = air.execute [%async_token_16] {
                memref.store %35, %reinterpret_cast[%32, %33] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              }
              %36 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
              scf.yield %36 : !air.async.token
            }
            scf.yield %31 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage5_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 60 : i32} : (memref<128xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %6 = air.launch @orbit_launch_39 async [%5] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 19 : i32} {
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage6_storage0_in[%c0, %c0] (%arg8[16, %23] [1, 32] [129, 1]) {id = 61 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage6_storage1_in[%c0, %c0] (%arg9[%23, 0] [32, 32] [80, 1]) {id = 62 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage6_storage0_in[%c0, %c0] (%arg8[16, 128] [1, 1] [129, 1]) {id = 63 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage6_storage1_in[%c0, %c0] (%arg9[128, 0] [1, 32] [80, 1]) {id = 64 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage6_storage3_out[%c0, %c0] (%arg10[16, 0] [1, 32] [80, 1]) {id = 65 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_39 async  attributes {id = 20 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_39 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 21 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c4_2 = arith.constant 4 : index
          %c32_3 = arith.constant 32 : index
          %c0_4 = arith.constant 0 : index
          %c1_5 = arith.constant 1 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<1xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : memref<1xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 39 : i64, orbit.storage = "intermediate"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg16 = %24) -> (!air.async.token) {
            %async_token_12 = air.execute [%arg16] {
              memref.store %cst, %reinterpret_cast[%c0_4, %arg15] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            }
            scf.yield %async_token_12 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_4 to %c4_2 step %c1_5 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<1024xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : memref<1024xf32, 2 : i32>
              air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 39 : i64, orbit.storage = "A"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage6_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 66 : i32} : (memref<32xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 39 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage6_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 67 : i32} : (memref<1024xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 105 : i64, orbit.phase = 39 : i64, orbit.phase_dependencies = array<i64: 38>, orbit.read_copies = array<i64: 132, 133, 134>, orbit.task = "gemm", orbit.write_copies = array<i64: 135>}
            %33 = scf.for %arg17 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %async_token_18, %results_19 = air.execute [%arg20] -> (f32) {
                  %38 = memref.load %reinterpret_cast_16[%c0_4, %arg19] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %38 : f32
                }
                %async_token_20, %results_21 = air.execute [%arg20] -> (f32) {
                  %38 = memref.load %reinterpret_cast_17[%arg19, %arg17] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %38 : f32
                }
                %async_token_22, %results_23 = air.execute [%arg20] -> (f32) {
                  %38 = memref.load %reinterpret_cast[%c0_4, %arg17] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %38 : f32
                }
                %35 = arith.mulf %results_19, %results_21 : f32
                %36 = arith.addf %results_23, %35 : f32
                %async_token_24 = air.execute [%async_token_22] {
                  memref.store %36, %reinterpret_cast[%c0_4, %arg17] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                }
                %37 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                scf.yield %37 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [1, 1], strides: [1, 1] {orbit.phase = 43 : i64, orbit.storage = "A"} : memref<1xf32, 2 : i32> to memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage6_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 68 : i32} : (memref<1xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 43 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage6_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 69 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 117 : i64, orbit.phase = 43 : i64, orbit.phase_dependencies = array<i64: 42>, orbit.read_copies = array<i64: 145, 146, 144>, orbit.task = "gemm", orbit.write_copies = array<i64: 147>}
          %29 = scf.for %arg15 = %c0_4 to %c32_3 step %c1_5 iter_args(%arg16 = %26) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute [%arg16] -> (f32) {
              %34 = memref.load %reinterpret_cast_10[%c0_4, %c0_4] : memref<1x1xf32, strided<[1, 1]>, 2 : i32>
              air.execute_terminator %34 : f32
            }
            %async_token_14, %results_15 = air.execute [%arg16] -> (f32) {
              %34 = memref.load %reinterpret_cast_11[%c0_4, %arg15] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              air.execute_terminator %34 : f32
            }
            %async_token_16, %results_17 = air.execute [%arg16] -> (f32) {
              %34 = memref.load %reinterpret_cast[%c0_4, %arg15] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              air.execute_terminator %34 : f32
            }
            %31 = arith.mulf %results_13, %results_15 : f32
            %32 = arith.addf %results_17, %31 : f32
            %async_token_18 = air.execute [%async_token_16] {
              memref.store %32, %reinterpret_cast[%c0_4, %arg15] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            }
            %33 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
            scf.yield %33 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage6_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 70 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %7 = air.launch @orbit_launch_44 async [%6] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 22 : i32} {
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage7_storage0_in[%c0, %c0] (%arg8[16, %23] [1, 32] [129, 1]) {id = 71 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage7_storage1_in[%c0, %c0] (%arg9[%23, 32] [32, 32] [80, 1]) {id = 72 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage7_storage0_in[%c0, %c0] (%arg8[16, 128] [1, 1] [129, 1]) {id = 73 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage7_storage1_in[%c0, %c0] (%arg9[128, 32] [1, 32] [80, 1]) {id = 74 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage7_storage3_out[%c0, %c0] (%arg10[16, 32] [1, 32] [80, 1]) {id = 75 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_44 async  attributes {id = 23 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_44 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 24 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c4_2 = arith.constant 4 : index
          %c0_3 = arith.constant 0 : index
          %c64 = arith.constant 64 : index
          %c32_4 = arith.constant 32 : index
          %c1_5 = arith.constant 1 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<1xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.32.1"} : memref<1xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.32.loops.1.32.1"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 44 : i64, orbit.storage = "intermediate"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c32_4 to %c64 step %c1_5 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = arith.subi %arg15, %c32_4 : index
            %async_token_12 = air.execute [%arg16] {
              memref.store %cst, %reinterpret_cast[%c0_3, %31] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            }
            scf.yield %async_token_12 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_3 to %c4_2 step %c1_5 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<1024xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.32.loops.1.32.32"} : memref<1024xf32, 2 : i32>
              air.execute_terminator %alloc : memref<1024xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.32.32"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 44 : i64, orbit.storage = "A"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage7_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 76 : i32} : (memref<32xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 44 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage7_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 77 : i32} : (memref<1024xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 122 : i64, orbit.phase = 44 : i64, orbit.phase_dependencies = array<i64: 43>, orbit.read_copies = array<i64: 149, 150, 151>, orbit.task = "gemm", orbit.write_copies = array<i64: 152>}
            %33 = scf.for %arg17 = %c32_4 to %c64 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c0_3 to %c32_4 step %c1_5 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %async_token_18, %results_19 = air.execute [%arg20] -> (f32) {
                  %39 = memref.load %reinterpret_cast_16[%c0_3, %arg19] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %39 : f32
                }
                %35 = arith.subi %arg17, %c32_4 : index
                %async_token_20, %results_21 = air.execute [%arg20] -> (f32) {
                  %39 = memref.load %reinterpret_cast_17[%arg19, %35] : memref<32x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %39 : f32
                }
                %async_token_22, %results_23 = air.execute [%arg20] -> (f32) {
                  %39 = memref.load %reinterpret_cast[%c0_3, %35] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %39 : f32
                }
                %36 = arith.mulf %results_19, %results_21 : f32
                %37 = arith.addf %results_23, %36 : f32
                %async_token_24 = air.execute [%async_token_22] {
                  memref.store %37, %reinterpret_cast[%c0_3, %35] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                }
                %38 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                scf.yield %38 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [1, 1], strides: [1, 1] {orbit.phase = 48 : i64, orbit.storage = "A"} : memref<1xf32, 2 : i32> to memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage7_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 78 : i32} : (memref<1xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 48 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage7_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 79 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 134 : i64, orbit.phase = 48 : i64, orbit.phase_dependencies = array<i64: 47>, orbit.read_copies = array<i64: 162, 163, 161>, orbit.task = "gemm", orbit.write_copies = array<i64: 164>}
          %29 = scf.for %arg15 = %c32_4 to %c64 step %c1_5 iter_args(%arg16 = %26) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute [%arg16] -> (f32) {
              %35 = memref.load %reinterpret_cast_10[%c0_3, %c0_3] : memref<1x1xf32, strided<[1, 1]>, 2 : i32>
              air.execute_terminator %35 : f32
            }
            %31 = arith.subi %arg15, %c32_4 : index
            %async_token_14, %results_15 = air.execute [%arg16] -> (f32) {
              %35 = memref.load %reinterpret_cast_11[%c0_3, %31] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              air.execute_terminator %35 : f32
            }
            %async_token_16, %results_17 = air.execute [%arg16] -> (f32) {
              %35 = memref.load %reinterpret_cast[%c0_3, %31] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              air.execute_terminator %35 : f32
            }
            %32 = arith.mulf %results_13, %results_15 : f32
            %33 = arith.addf %results_17, %32 : f32
            %async_token_18 = air.execute [%async_token_16] {
              memref.store %33, %reinterpret_cast[%c0_3, %31] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            }
            %34 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
            scf.yield %34 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage7_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 80 : i32} : (memref<32xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %8 = air.launch @orbit_launch_49 async [%7] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32> attributes {id = 25 : i32} {
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %15) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage8_storage0_in[%c0, %c0] (%arg8[16, %23] [1, 32] [129, 1]) {id = 81 : i32} : (memref<17x129xf32>)
        scf.yield %24 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %17) -> (!air.async.token) {
        %23 = arith.muli %arg11, %c32 : index
        %24 = air.channel.put async [%arg12]  @__orbit_fifo_stage8_storage1_in[%c0, %c0] (%arg9[%23, 64] [32, 16] [80, 1]) {id = 82 : i32} : (memref<129x80xf32>)
        scf.yield %24 : !air.async.token
      }
      %19 = air.channel.put async  @__orbit_fifo_stage8_storage0_in[%c0, %c0] (%arg8[16, 128] [1, 1] [129, 1]) {id = 83 : i32} : (memref<17x129xf32>)
      %20 = air.channel.put async  @__orbit_fifo_stage8_storage1_in[%c0, %c0] (%arg9[128, 64] [1, 16] [80, 1]) {id = 84 : i32} : (memref<129x80xf32>)
      %21 = air.channel.get async  @__orbit_fifo_stage8_storage3_out[%c0, %c0] (%arg10[16, 64] [1, 16] [80, 1]) {id = 85 : i32} : (memref<17x80xf32>)
      %22 = air.segment @orbit_segment_49 async  attributes {id = 26 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %23 = air.herd @orbit_herd_49 async  tile (%arg11, %arg12) in (%arg13=%c1_1, %arg14=%c1_1) attributes {id = 27 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c32_2 = arith.constant 32 : index
          %c4_3 = arith.constant 4 : index
          %c0_4 = arith.constant 0 : index
          %c80 = arith.constant 80 : index
          %c64 = arith.constant 64 : index
          %c1_5 = arith.constant 1 : index
          %cst = arith.constant 0.000000e+00 : f32
          %async_token, %results = air.execute -> (memref<1xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.1.loops.1.16.1"} : memref<1xf32, 2 : i32>
            air.execute_terminator %alloc : memref<1xf32, 2 : i32>
          }
          %async_token_6, %results_7 = air.execute -> (memref<16xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.1.16.loops.1.16.1"} : memref<16xf32, 2 : i32>
            air.execute_terminator %alloc : memref<16xf32, 2 : i32>
          }
          %async_token_8, %results_9 = air.execute -> (memref<16xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<16xf32, 2 : i32>
            air.execute_terminator %alloc : memref<16xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results_9 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 49 : i64, orbit.storage = "intermediate"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %24 = air.wait_all async 
          %25 = scf.for %arg15 = %c64 to %c80 step %c1_5 iter_args(%arg16 = %24) -> (!air.async.token) {
            %31 = arith.subi %arg15, %c64 : index
            %async_token_12 = air.execute [%arg16] {
              memref.store %cst, %reinterpret_cast[%c0_4, %31] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
            }
            scf.yield %async_token_12 : !air.async.token
          }
          %26 = scf.for %arg15 = %c0_4 to %c4_3 step %c1_5 iter_args(%arg16 = %25) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute -> (memref<512xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.1.16.32"} : memref<512xf32, 2 : i32>
              air.execute_terminator %alloc : memref<512xf32, 2 : i32>
            }
            %async_token_14, %results_15 = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.32.loops.1.16.32"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast_16 = memref.reinterpret_cast %results_15 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 49 : i64, orbit.storage = "A"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %31 = air.channel.get async [%async_token_14, %arg16]  @__orbit_fifo_stage8_storage0_in[%arg11, %arg12] (%results_15[] [] []) {id = 86 : i32} : (memref<32xf32, 2 : i32>)
            %reinterpret_cast_17 = memref.reinterpret_cast %results_13 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 49 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            %32 = air.channel.get async [%async_token_12, %arg16]  @__orbit_fifo_stage8_storage1_in[%arg11, %arg12] (%results_13[] [] []) {id = 87 : i32} : (memref<512xf32, 2 : i32>)
            air.wait_all [%31, %32]  {orbit.computation_event = 139 : i64, orbit.phase = 49 : i64, orbit.phase_dependencies = array<i64: 48>, orbit.read_copies = array<i64: 166, 167, 168>, orbit.task = "gemm", orbit.write_copies = array<i64: 169>}
            %33 = scf.for %arg17 = %c64 to %c80 step %c1_5 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %34 = scf.for %arg19 = %c0_4 to %c32_2 step %c1_5 iter_args(%arg20 = %arg18) -> (!air.async.token) {
                %async_token_18, %results_19 = air.execute [%arg20] -> (f32) {
                  %39 = memref.load %reinterpret_cast_16[%c0_4, %arg19] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %39 : f32
                }
                %35 = arith.subi %arg17, %c64 : index
                %async_token_20, %results_21 = air.execute [%arg20] -> (f32) {
                  %39 = memref.load %reinterpret_cast_17[%arg19, %35] : memref<32x16xf32, strided<[16, 1]>, 2 : i32>
                  air.execute_terminator %39 : f32
                }
                %async_token_22, %results_23 = air.execute [%arg20] -> (f32) {
                  %39 = memref.load %reinterpret_cast[%c0_4, %35] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
                  air.execute_terminator %39 : f32
                }
                %36 = arith.mulf %results_19, %results_21 : f32
                %37 = arith.addf %results_23, %36 : f32
                %async_token_24 = air.execute [%async_token_22] {
                  memref.store %37, %reinterpret_cast[%c0_4, %35] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
                }
                %38 = air.wait_all async [%async_token_18, %async_token_20, %async_token_24] 
                scf.yield %38 : !air.async.token
              }
              scf.yield %34 : !air.async.token
            }
            scf.yield %33 : !air.async.token
          }
          %reinterpret_cast_10 = memref.reinterpret_cast %results to offset: [0], sizes: [1, 1], strides: [1, 1] {orbit.phase = 53 : i64, orbit.storage = "A"} : memref<1xf32, 2 : i32> to memref<1x1xf32, strided<[1, 1]>, 2 : i32>
          %27 = air.channel.get async [%async_token]  @__orbit_fifo_stage8_storage0_in[%arg11, %arg12] (%results[] [] []) {id = 88 : i32} : (memref<1xf32, 2 : i32>)
          %reinterpret_cast_11 = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 53 : i64, orbit.storage = "B"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %28 = air.channel.get async [%async_token_6]  @__orbit_fifo_stage8_storage1_in[%arg11, %arg12] (%results_7[] [] []) {id = 89 : i32} : (memref<16xf32, 2 : i32>)
          air.wait_all [%27, %28]  {orbit.computation_event = 151 : i64, orbit.phase = 53 : i64, orbit.phase_dependencies = array<i64: 52>, orbit.read_copies = array<i64: 179, 180, 178>, orbit.task = "gemm", orbit.write_copies = array<i64: 181>}
          %29 = scf.for %arg15 = %c64 to %c80 step %c1_5 iter_args(%arg16 = %26) -> (!air.async.token) {
            %async_token_12, %results_13 = air.execute [%arg16] -> (f32) {
              %35 = memref.load %reinterpret_cast_10[%c0_4, %c0_4] : memref<1x1xf32, strided<[1, 1]>, 2 : i32>
              air.execute_terminator %35 : f32
            }
            %31 = arith.subi %arg15, %c64 : index
            %async_token_14, %results_15 = air.execute [%arg16] -> (f32) {
              %35 = memref.load %reinterpret_cast_11[%c0_4, %31] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
              air.execute_terminator %35 : f32
            }
            %async_token_16, %results_17 = air.execute [%arg16] -> (f32) {
              %35 = memref.load %reinterpret_cast[%c0_4, %31] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
              air.execute_terminator %35 : f32
            }
            %32 = arith.mulf %results_13, %results_15 : f32
            %33 = arith.addf %results_17, %32 : f32
            %async_token_18 = air.execute [%async_token_16] {
              memref.store %33, %reinterpret_cast[%c0_4, %31] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
            }
            %34 = air.wait_all async [%async_token_12, %async_token_14, %async_token_18] 
            scf.yield %34 : !air.async.token
          }
          %30 = air.channel.put async [%async_token_8]  @__orbit_fifo_stage8_storage3_out[%arg11, %arg12] (%results_9[] [] []) {id = 90 : i32} : (memref<16xf32, 2 : i32>)
          air.wait_all [%30] 
        }
        air.wait_all [%23] 
      }
    }
    %9 = air.launch @orbit_launch_54 async [%8] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<17x80xf32>, memref<17x80xf32> attributes {id = 28 : i32} {
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %15) -> (!air.async.token) {
        %20 = arith.muli %arg10, %c32 : index
        %21 = air.channel.put async [%arg11]  @channel_45[%c0, %c0] (%arg9[0, %20] [8, 32] [80, 1]) {id = 91 : i32} : (memref<17x80xf32>)
        scf.yield %21 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %17) -> (!air.async.token) {
        %20 = arith.muli %arg10, %c32 : index
        %21 = air.channel.get async [%arg11]  @channel_46[%c0, %c0] (%arg8[0, %20] [8, 32] [80, 1]) {id = 92 : i32} : (memref<17x80xf32>)
        scf.yield %21 : !air.async.token
      }
      %19 = air.segment @orbit_segment_54 async  attributes {id = 29 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %20 = air.herd @orbit_herd_54 async  tile (%arg10, %arg11) in (%arg12=%c1_1, %arg13=%c1_1) attributes {id = 30 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %cst = arith.constant 5.000000e-01 : f32
          %c32_2 = arith.constant 32 : index
          %c1_3 = arith.constant 1 : index
          %c2_4 = arith.constant 2 : index
          %c0_5 = arith.constant 0 : index
          %21 = air.wait_all async 
          %22 = scf.for %arg14 = %c0_5 to %c2_4 step %c1_3 iter_args(%arg15 = %21) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %async_token_6, %results_7 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results_7 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 54 : i64, orbit.storage = "Y"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %reinterpret_cast_8 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 54 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %23 = air.channel.get async [%async_token, %arg15]  @channel_45[%arg10, %arg11] (%results[] [] []) {id = 93 : i32} : (memref<256xf32, 2 : i32>)
            air.wait_all [%23]  {orbit.computation_event = 154 : i64, orbit.phase = 54 : i64, orbit.phase_dependencies = array<i64: 53>, orbit.read_copies = array<i64: 183>, orbit.task = "scale", orbit.write_copies = array<i64: 184>}
            %24 = scf.for %arg16 = %c0_5 to %c8 step %c1_3 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %26 = scf.for %arg18 = %c0_5 to %c32_2 step %c1_3 iter_args(%arg19 = %arg17) -> (!air.async.token) {
                %async_token_9, %results_10 = air.execute [%arg19] -> (f32) {
                  %29 = memref.load %reinterpret_cast_8[%arg16, %arg18] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %29 : f32
                }
                %27 = arith.mulf %results_10, %cst : f32
                %async_token_11 = air.execute [%arg19] {
                  memref.store %27, %reinterpret_cast[%arg16, %arg18] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                }
                %28 = air.wait_all async [%async_token_9, %async_token_11] 
                scf.yield %28 : !air.async.token
              }
              scf.yield %26 : !air.async.token
            }
            %25 = air.channel.put async [%async_token_6, %arg15]  @channel_46[%arg10, %arg11] (%results_7[] [] []) {id = 94 : i32} : (memref<256xf32, 2 : i32>)
            scf.yield %25 : !air.async.token
          }
          air.wait_all [%22] 
        }
        air.wait_all [%20] 
      }
    }
    %10 = air.launch @orbit_launch_56 async [%9] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<17x80xf32>, memref<17x80xf32> attributes {id = 31 : i32} {
      %c0 = arith.constant 0 : index
      %15 = air.channel.put async  @channel_47[%c0, %c0] (%arg9[0, 64] [8, 16] [80, 1]) {id = 95 : i32} : (memref<17x80xf32>)
      %16 = air.channel.get async  @channel_48[%c0, %c0] (%arg8[0, 64] [8, 16] [80, 1]) {id = 96 : i32} : (memref<17x80xf32>)
      %17 = air.segment @orbit_segment_56 async  attributes {id = 32 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %18 = air.herd @orbit_herd_56 async  tile (%arg10, %arg11) in (%arg12=%c1_0, %arg13=%c1_0) attributes {id = 33 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c80 = arith.constant 80 : index
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c8 = arith.constant 8 : index
          %c0_2 = arith.constant 0 : index
          %cst = arith.constant 5.000000e-01 : f32
          %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<128xf32, 2 : i32>
            air.execute_terminator %alloc : memref<128xf32, 2 : i32>
          }
          %async_token_3, %results_4 = air.execute -> (memref<128xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : memref<128xf32, 2 : i32>
            air.execute_terminator %alloc : memref<128xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 56 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_5 = memref.reinterpret_cast %results_4 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 56 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %19 = air.channel.get async [%async_token_3]  @channel_47[%arg10, %arg11] (%results_4[] [] []) {id = 97 : i32} : (memref<128xf32, 2 : i32>)
          air.wait_all [%19]  {orbit.computation_event = 160 : i64, orbit.phase = 56 : i64, orbit.phase_dependencies = array<i64: 55>, orbit.read_copies = array<i64: 189>, orbit.task = "scale", orbit.write_copies = array<i64: 190>}
          %20 = air.wait_all async 
          %21 = scf.for %arg14 = %c0_2 to %c8 step %c1_1 iter_args(%arg15 = %20) -> (!air.async.token) {
            %23 = scf.for %arg16 = %c64 to %c80 step %c1_1 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %24 = arith.subi %arg16, %c64 : index
              %async_token_6, %results_7 = air.execute [%arg17] -> (f32) {
                %27 = memref.load %reinterpret_cast_5[%arg14, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                air.execute_terminator %27 : f32
              }
              %25 = arith.mulf %results_7, %cst : f32
              %async_token_8 = air.execute [%arg17] {
                memref.store %25, %reinterpret_cast[%arg14, %24] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              }
              %26 = air.wait_all async [%async_token_6, %async_token_8] 
              scf.yield %26 : !air.async.token
            }
            scf.yield %23 : !air.async.token
          }
          %22 = air.channel.put async [%async_token]  @channel_48[%arg10, %arg11] (%results[] [] []) {id = 98 : i32} : (memref<128xf32, 2 : i32>)
          air.wait_all [%22] 
        }
        air.wait_all [%18] 
      }
    }
    %11 = air.launch @orbit_launch_57 async [%10] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<17x80xf32>, memref<17x80xf32> attributes {id = 34 : i32} {
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %15) -> (!air.async.token) {
        %20 = arith.muli %arg10, %c32 : index
        %21 = air.channel.put async [%arg11]  @channel_49[%c0, %c0] (%arg9[8, %20] [8, 32] [80, 1]) {id = 99 : i32} : (memref<17x80xf32>)
        scf.yield %21 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %17) -> (!air.async.token) {
        %20 = arith.muli %arg10, %c32 : index
        %21 = air.channel.get async [%arg11]  @channel_50[%c0, %c0] (%arg8[8, %20] [8, 32] [80, 1]) {id = 100 : i32} : (memref<17x80xf32>)
        scf.yield %21 : !air.async.token
      }
      %19 = air.segment @orbit_segment_57 async  attributes {id = 35 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %20 = air.herd @orbit_herd_57 async  tile (%arg10, %arg11) in (%arg12=%c1_1, %arg13=%c1_1) attributes {id = 36 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c16 = arith.constant 16 : index
          %c8 = arith.constant 8 : index
          %cst = arith.constant 5.000000e-01 : f32
          %c32_2 = arith.constant 32 : index
          %c1_3 = arith.constant 1 : index
          %c2_4 = arith.constant 2 : index
          %c0_5 = arith.constant 0 : index
          %21 = air.wait_all async 
          %22 = scf.for %arg14 = %c0_5 to %c2_4 step %c1_3 iter_args(%arg15 = %21) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.32.loops.8.32"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %async_token_6, %results_7 = air.execute -> (memref<256xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<256xf32, 2 : i32>
              air.execute_terminator %alloc : memref<256xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results_7 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 57 : i64, orbit.storage = "Y"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %reinterpret_cast_8 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 57 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            %23 = air.channel.get async [%async_token, %arg15]  @channel_49[%arg10, %arg11] (%results[] [] []) {id = 101 : i32} : (memref<256xf32, 2 : i32>)
            air.wait_all [%23]  {orbit.computation_event = 163 : i64, orbit.phase = 57 : i64, orbit.phase_dependencies = array<i64: 56>, orbit.read_copies = array<i64: 192>, orbit.task = "scale", orbit.write_copies = array<i64: 193>}
            %24 = scf.for %arg16 = %c8 to %c16 step %c1_3 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %26 = scf.for %arg18 = %c0_5 to %c32_2 step %c1_3 iter_args(%arg19 = %arg17) -> (!air.async.token) {
                %27 = arith.subi %arg16, %c8 : index
                %async_token_9, %results_10 = air.execute [%arg19] -> (f32) {
                  %30 = memref.load %reinterpret_cast_8[%27, %arg18] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %30 : f32
                }
                %28 = arith.mulf %results_10, %cst : f32
                %async_token_11 = air.execute [%arg19] {
                  memref.store %28, %reinterpret_cast[%27, %arg18] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                }
                %29 = air.wait_all async [%async_token_9, %async_token_11] 
                scf.yield %29 : !air.async.token
              }
              scf.yield %26 : !air.async.token
            }
            %25 = air.channel.put async [%async_token_6, %arg15]  @channel_50[%arg10, %arg11] (%results_7[] [] []) {id = 102 : i32} : (memref<256xf32, 2 : i32>)
            scf.yield %25 : !air.async.token
          }
          air.wait_all [%22] 
        }
        air.wait_all [%20] 
      }
    }
    %12 = air.launch @orbit_launch_59 async [%11] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<17x80xf32>, memref<17x80xf32> attributes {id = 37 : i32} {
      %c0 = arith.constant 0 : index
      %15 = air.channel.put async  @channel_51[%c0, %c0] (%arg9[8, 64] [8, 16] [80, 1]) {id = 103 : i32} : (memref<17x80xf32>)
      %16 = air.channel.get async  @channel_52[%c0, %c0] (%arg8[8, 64] [8, 16] [80, 1]) {id = 104 : i32} : (memref<17x80xf32>)
      %17 = air.segment @orbit_segment_59 async  attributes {id = 38 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %18 = air.herd @orbit_herd_59 async  tile (%arg10, %arg11) in (%arg12=%c1_0, %arg13=%c1_0) attributes {id = 39 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c80 = arith.constant 80 : index
          %c64 = arith.constant 64 : index
          %c1_1 = arith.constant 1 : index
          %c16 = arith.constant 16 : index
          %c8 = arith.constant 8 : index
          %cst = arith.constant 5.000000e-01 : f32
          %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<128xf32, 2 : i32>
            air.execute_terminator %alloc : memref<128xf32, 2 : i32>
          }
          %async_token_2, %results_3 = air.execute -> (memref<128xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : memref<128xf32, 2 : i32>
            air.execute_terminator %alloc : memref<128xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 59 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_4 = memref.reinterpret_cast %results_3 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 59 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %19 = air.channel.get async [%async_token_2]  @channel_51[%arg10, %arg11] (%results_3[] [] []) {id = 105 : i32} : (memref<128xf32, 2 : i32>)
          air.wait_all [%19]  {orbit.computation_event = 169 : i64, orbit.phase = 59 : i64, orbit.phase_dependencies = array<i64: 58>, orbit.read_copies = array<i64: 198>, orbit.task = "scale", orbit.write_copies = array<i64: 199>}
          %20 = air.wait_all async 
          %21 = scf.for %arg14 = %c8 to %c16 step %c1_1 iter_args(%arg15 = %20) -> (!air.async.token) {
            %23 = scf.for %arg16 = %c64 to %c80 step %c1_1 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %24 = arith.subi %arg14, %c8 : index
              %25 = arith.subi %arg16, %c64 : index
              %async_token_5, %results_6 = air.execute [%arg17] -> (f32) {
                %28 = memref.load %reinterpret_cast_4[%24, %25] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                air.execute_terminator %28 : f32
              }
              %26 = arith.mulf %results_6, %cst : f32
              %async_token_7 = air.execute [%arg17] {
                memref.store %26, %reinterpret_cast[%24, %25] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              }
              %27 = air.wait_all async [%async_token_5, %async_token_7] 
              scf.yield %27 : !air.async.token
            }
            scf.yield %23 : !air.async.token
          }
          %22 = air.channel.put async [%async_token]  @channel_52[%arg10, %arg11] (%results[] [] []) {id = 106 : i32} : (memref<128xf32, 2 : i32>)
          air.wait_all [%22] 
        }
        air.wait_all [%18] 
      }
    }
    %13 = air.launch @orbit_launch_60 async [%12] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<17x80xf32>, memref<17x80xf32> attributes {id = 40 : i32} {
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %15 = air.wait_all async 
      %16 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %15) -> (!air.async.token) {
        %20 = arith.muli %arg10, %c32 : index
        %21 = air.channel.put async [%arg11]  @channel_53[%c0, %c0] (%arg9[16, %20] [1, 32] [80, 1]) {id = 107 : i32} : (memref<17x80xf32>)
        scf.yield %21 : !air.async.token
      }
      %17 = air.wait_all async 
      %18 = scf.for %arg10 = %c0 to %c2 step %c1_0 iter_args(%arg11 = %17) -> (!air.async.token) {
        %20 = arith.muli %arg10, %c32 : index
        %21 = air.channel.get async [%arg11]  @channel_54[%c0, %c0] (%arg8[16, %20] [1, 32] [80, 1]) {id = 108 : i32} : (memref<17x80xf32>)
        scf.yield %21 : !air.async.token
      }
      %19 = air.segment @orbit_segment_60 async  attributes {id = 41 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %20 = air.herd @orbit_herd_60 async  tile (%arg10, %arg11) in (%arg12=%c1_1, %arg13=%c1_1) attributes {id = 42 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 5.000000e-01 : f32
          %c32_2 = arith.constant 32 : index
          %c1_3 = arith.constant 1 : index
          %c2_4 = arith.constant 2 : index
          %c0_5 = arith.constant 0 : index
          %21 = air.wait_all async 
          %22 = scf.for %arg14 = %c0_5 to %c2_4 step %c1_3 iter_args(%arg15 = %21) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.32.loops.1.32"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %async_token_6, %results_7 = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results_7 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 60 : i64, orbit.storage = "Y"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %reinterpret_cast_8 = memref.reinterpret_cast %results to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 60 : i64, orbit.storage = "intermediate"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %23 = air.channel.get async [%async_token, %arg15]  @channel_53[%arg10, %arg11] (%results[] [] []) {id = 109 : i32} : (memref<32xf32, 2 : i32>)
            air.wait_all [%23]  {orbit.computation_event = 172 : i64, orbit.phase = 60 : i64, orbit.phase_dependencies = array<i64: 59>, orbit.read_copies = array<i64: 201>, orbit.task = "scale", orbit.write_copies = array<i64: 202>}
            %24 = scf.for %arg16 = %c0_5 to %c32_2 step %c1_3 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %async_token_9, %results_10 = air.execute [%arg17] -> (f32) {
                %28 = memref.load %reinterpret_cast_8[%c0_5, %arg16] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %28 : f32
              }
              %26 = arith.mulf %results_10, %cst : f32
              %async_token_11 = air.execute [%arg17] {
                memref.store %26, %reinterpret_cast[%c0_5, %arg16] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              }
              %27 = air.wait_all async [%async_token_9, %async_token_11] 
              scf.yield %27 : !air.async.token
            }
            %25 = air.channel.put async [%async_token_6, %arg15]  @channel_54[%arg10, %arg11] (%results_7[] [] []) {id = 110 : i32} : (memref<32xf32, 2 : i32>)
            scf.yield %25 : !air.async.token
          }
          air.wait_all [%22] 
        }
        air.wait_all [%20] 
      }
    }
    %14 = air.launch @orbit_launch_62 async [%13] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<17x80xf32>, memref<17x80xf32> attributes {id = 43 : i32} {
      %c0 = arith.constant 0 : index
      %15 = air.channel.put async  @channel_55[%c0, %c0] (%arg9[16, 64] [1, 16] [80, 1]) {id = 111 : i32} : (memref<17x80xf32>)
      %16 = air.channel.get async  @channel_56[%c0, %c0] (%arg8[16, 64] [1, 16] [80, 1]) {id = 112 : i32} : (memref<17x80xf32>)
      %17 = air.segment @orbit_segment_62 async  attributes {id = 44 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_0 = arith.constant 1 : index
        %18 = air.herd @orbit_herd_62 async  tile (%arg10, %arg11) in (%arg12=%c1_0, %arg13=%c1_0) attributes {id = 45 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c0_1 = arith.constant 0 : index
          %c80 = arith.constant 80 : index
          %c64 = arith.constant 64 : index
          %c1_2 = arith.constant 1 : index
          %cst = arith.constant 5.000000e-01 : f32
          %async_token, %results = air.execute -> (memref<16xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<16xf32, 2 : i32>
            air.execute_terminator %alloc : memref<16xf32, 2 : i32>
          }
          %async_token_3, %results_4 = air.execute -> (memref<16xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.lifetime = "static-hardware-stage-region", orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.1.16.loops.1.16"} : memref<16xf32, 2 : i32>
            air.execute_terminator %alloc : memref<16xf32, 2 : i32>
          }
          %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 62 : i64, orbit.storage = "Y"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_5 = memref.reinterpret_cast %results_4 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 62 : i64, orbit.storage = "intermediate"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          %19 = air.channel.get async [%async_token_3]  @channel_55[%arg10, %arg11] (%results_4[] [] []) {id = 113 : i32} : (memref<16xf32, 2 : i32>)
          air.wait_all [%19]  {orbit.computation_event = 178 : i64, orbit.phase = 62 : i64, orbit.phase_dependencies = array<i64: 61>, orbit.read_copies = array<i64: 207>, orbit.task = "scale", orbit.write_copies = array<i64: 208>}
          %20 = air.wait_all async 
          %21 = scf.for %arg14 = %c64 to %c80 step %c1_2 iter_args(%arg15 = %20) -> (!air.async.token) {
            %23 = arith.subi %arg14, %c64 : index
            %async_token_6, %results_7 = air.execute [%arg15] -> (f32) {
              %26 = memref.load %reinterpret_cast_5[%c0_1, %23] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
              air.execute_terminator %26 : f32
            }
            %24 = arith.mulf %results_7, %cst : f32
            %async_token_8 = air.execute [%arg15] {
              memref.store %24, %reinterpret_cast[%c0_1, %23] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
            }
            %25 = air.wait_all async [%async_token_6, %async_token_8] 
            scf.yield %25 : !air.async.token
          }
          %22 = air.channel.put async [%async_token]  @channel_56[%arg10, %arg11] (%results[] [] []) {id = 114 : i32} : (memref<16xf32, 2 : i32>)
          air.wait_all [%22] 
        }
        air.wait_all [%18] 
      }
    }
    return
  }
}
