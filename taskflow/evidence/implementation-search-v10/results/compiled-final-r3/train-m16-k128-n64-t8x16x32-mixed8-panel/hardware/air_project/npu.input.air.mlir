#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "99a211e4670ca5c27d71b2ec3dc65e6b941d0d8392ef26cea980219ad819c8fb", orbit.source_fingerprint = "60fbbfc305db9d3a0222fda474d495f9bcd30577ace8a68d554bcd4f73a110a9"} {
  aie.device(npu2) @orbit_segment_40 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf13 = aie.buffer(%tile_0_2) {sym_name = "buf13"} : memref<128xf32, 2 : i32> 
    %buf12 = aie.buffer(%tile_0_2) {sym_name = "buf12"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<16x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf12 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf13 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 0.000000e+00 : f32
      %cst_3 = arith.constant 5.000000e-01 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c2 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf12 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_4 = memref.reinterpret_cast %buf13 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 40 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c8 {
              %0 = vector.transfer_read %reinterpret_cast_4[%arg2, %arg3], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
              %1 = vector.extract %0[0] : f32 from vector<8xf32>
              %2 = func.call @__mulsf3(%1, %cst_3) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %3 = vector.extract %0[1] : f32 from vector<8xf32>
              %4 = func.call @__mulsf3(%3, %cst_3) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %5 = vector.extract %0[2] : f32 from vector<8xf32>
              %6 = func.call @__mulsf3(%5, %cst_3) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %7 = vector.extract %0[3] : f32 from vector<8xf32>
              %8 = func.call @__mulsf3(%7, %cst_3) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %9 = vector.extract %0[4] : f32 from vector<8xf32>
              %10 = func.call @__mulsf3(%9, %cst_3) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %11 = vector.extract %0[5] : f32 from vector<8xf32>
              %12 = func.call @__mulsf3(%11, %cst_3) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %13 = vector.extract %0[6] : f32 from vector<8xf32>
              %14 = func.call @__mulsf3(%13, %cst_3) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %15 = vector.extract %0[7] : f32 from vector<8xf32>
              %16 = func.call @__mulsf3(%15, %cst_3) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %17 = vector.from_elements %2, %4, %6, %8, %10, %12, %14, %16 : vector<8xf32>
              vector.transfer_write %17, %reinterpret_cast[%arg2, %arg3] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_2, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_40", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_13(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_12(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_40_sequence(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_13 {
        aie.dma_bd(%arg2 : memref<16x64xf32> offset = 0 len = 512 sizes = [2, 4, 8, 16] strides = [512, 16, 64, 1])
        aie.end
      } {issue_token = true, repeat_count = 1 : i32}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_12 {
        aie.dma_bd(%arg3 : memref<16x64xf32> offset = 0 len = 512 sizes = [2, 4, 8, 16] strides = [512, 16, 64, 1])
        aie.end
      } {repeat_count = 1 : i32}
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_32 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf11 = aie.buffer(%tile_0_2) {sym_name = "buf11"} : memref<2048xf32, 2 : i32> 
    %buf10 = aie.buffer(%tile_0_2) {sym_name = "buf10"} : memref<128xf32, 2 : i32> 
    %buf9 = aie.buffer(%tile_0_2) {sym_name = "buf9"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf10 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf11 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf9 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c48 = arith.constant 48 : index
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf11 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf10 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c48 to %c64 step %c1 {
            %0 = arith.subi %arg2, %c48 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf9 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c48 to %c64 step %c8 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = arith.subi %arg3, %c48 : index
                %3 = vector.transfer_read %reinterpret_cast[%0, %2], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %4 = vector.transfer_read %reinterpret_cast_5[%arg2, %2], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %5 = vector.extract %3[0] : f32 from vector<8xf32>
                %6 = func.call @__mulsf3(%1, %5) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %7 = vector.extract %3[1] : f32 from vector<8xf32>
                %8 = func.call @__mulsf3(%1, %7) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %9 = vector.extract %3[2] : f32 from vector<8xf32>
                %10 = func.call @__mulsf3(%1, %9) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %11 = vector.extract %3[3] : f32 from vector<8xf32>
                %12 = func.call @__mulsf3(%1, %11) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %13 = vector.extract %3[4] : f32 from vector<8xf32>
                %14 = func.call @__mulsf3(%1, %13) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %15 = vector.extract %3[5] : f32 from vector<8xf32>
                %16 = func.call @__mulsf3(%1, %15) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %17 = vector.extract %3[6] : f32 from vector<8xf32>
                %18 = func.call @__mulsf3(%1, %17) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %19 = vector.extract %3[7] : f32 from vector<8xf32>
                %20 = func.call @__mulsf3(%1, %19) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %21 = vector.from_elements %6, %8, %10, %12, %14, %16, %18, %20 : vector<8xf32>
                %22 = arith.addf %4, %21 : vector<8xf32>
                vector.transfer_write %22, %reinterpret_cast_5[%arg2, %2] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_32", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_11(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_9(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_10(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_32_sequence(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_11 {
        aie.dma_bd(%arg3 : memref<16x64xf32> offset = 48 len = 256 sizes = [16, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_9 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 48 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg0 : memref<16x128xf32> offset = 0 len = 1024 sizes = [2, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 1 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_24 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf8 = aie.buffer(%tile_0_2) {sym_name = "buf8"} : memref<2048xf32, 2 : i32> 
    %buf7 = aie.buffer(%tile_0_2) {sym_name = "buf7"} : memref<128xf32, 2 : i32> 
    %buf6 = aie.buffer(%tile_0_2) {sym_name = "buf6"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf7 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf8 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf6 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c32 = arith.constant 32 : index
      %c48 = arith.constant 48 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf8 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 24 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf7 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c32 to %c48 step %c1 {
            %0 = arith.subi %arg2, %c32 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf6 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 24 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c32 to %c48 step %c8 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = arith.subi %arg3, %c32 : index
                %3 = vector.transfer_read %reinterpret_cast[%0, %2], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %4 = vector.transfer_read %reinterpret_cast_5[%arg2, %2], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %5 = vector.extract %3[0] : f32 from vector<8xf32>
                %6 = func.call @__mulsf3(%1, %5) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %7 = vector.extract %3[1] : f32 from vector<8xf32>
                %8 = func.call @__mulsf3(%1, %7) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %9 = vector.extract %3[2] : f32 from vector<8xf32>
                %10 = func.call @__mulsf3(%1, %9) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %11 = vector.extract %3[3] : f32 from vector<8xf32>
                %12 = func.call @__mulsf3(%1, %11) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %13 = vector.extract %3[4] : f32 from vector<8xf32>
                %14 = func.call @__mulsf3(%1, %13) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %15 = vector.extract %3[5] : f32 from vector<8xf32>
                %16 = func.call @__mulsf3(%1, %15) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %17 = vector.extract %3[6] : f32 from vector<8xf32>
                %18 = func.call @__mulsf3(%1, %17) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %19 = vector.extract %3[7] : f32 from vector<8xf32>
                %20 = func.call @__mulsf3(%1, %19) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %21 = vector.from_elements %6, %8, %10, %12, %14, %16, %18, %20 : vector<8xf32>
                %22 = arith.addf %4, %21 : vector<8xf32>
                vector.transfer_write %22, %reinterpret_cast_5[%arg2, %2] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_24", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_8(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_6(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_7(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_24_sequence(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_8 {
        aie.dma_bd(%arg3 : memref<16x64xf32> offset = 32 len = 256 sizes = [16, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 32 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg0 : memref<16x128xf32> offset = 0 len = 1024 sizes = [2, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 1 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_16 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf5 = aie.buffer(%tile_0_2) {sym_name = "buf5"} : memref<2048xf32, 2 : i32> 
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<128xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf5 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf5 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 16 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c16 to %c32 step %c1 {
            %0 = arith.subi %arg2, %c16 : index
            memref.store %cst, %reinterpret_cast_5[%arg1, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf3 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 16 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c16 to %c32 step %c8 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = arith.subi %arg3, %c16 : index
                %3 = vector.transfer_read %reinterpret_cast[%0, %2], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %4 = vector.transfer_read %reinterpret_cast_5[%arg2, %2], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %5 = vector.extract %3[0] : f32 from vector<8xf32>
                %6 = func.call @__mulsf3(%1, %5) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %7 = vector.extract %3[1] : f32 from vector<8xf32>
                %8 = func.call @__mulsf3(%1, %7) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %9 = vector.extract %3[2] : f32 from vector<8xf32>
                %10 = func.call @__mulsf3(%1, %9) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %11 = vector.extract %3[3] : f32 from vector<8xf32>
                %12 = func.call @__mulsf3(%1, %11) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %13 = vector.extract %3[4] : f32 from vector<8xf32>
                %14 = func.call @__mulsf3(%1, %13) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %15 = vector.extract %3[5] : f32 from vector<8xf32>
                %16 = func.call @__mulsf3(%1, %15) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %17 = vector.extract %3[6] : f32 from vector<8xf32>
                %18 = func.call @__mulsf3(%1, %17) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %19 = vector.extract %3[7] : f32 from vector<8xf32>
                %20 = func.call @__mulsf3(%1, %19) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %21 = vector.from_elements %6, %8, %10, %12, %14, %16, %18, %20 : vector<8xf32>
                %22 = arith.addf %4, %21 : vector<8xf32>
                vector.transfer_write %22, %reinterpret_cast_5[%arg2, %2] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_16", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_5(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_16_sequence(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_5 {
        aie.dma_bd(%arg3 : memref<16x64xf32> offset = 16 len = 256 sizes = [16, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_3 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 16 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg0 : memref<16x128xf32> offset = 0 len = 1024 sizes = [2, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 1 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf2 = aie.buffer(%tile_0_2) {sym_name = "buf2"} : memref<2048xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<128xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<128x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<16x128xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<16x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c8 = arith.constant 8 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c128 = arith.constant 128 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [128, 16], strides: [16, 1] {orbit.phase = 8 : i64, orbit.storage = "B"} : memref<2048xf32, 2 : i32> to memref<128x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_5 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 8 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c0 to %c16 step %c1 {
            memref.store %cst, %reinterpret_cast_5[%arg1, %arg2] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c128 step %c32 {
          %reinterpret_cast_6 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 8 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c8 {
              scf.for %arg4 = %c0 to %c32 step %c1 {
                %0 = arith.addi %arg4, %arg1 : index
                %1 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %2 = vector.transfer_read %reinterpret_cast[%0, %arg3], %cst : memref<128x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %3 = vector.transfer_read %reinterpret_cast_5[%arg2, %arg3], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                %4 = vector.extract %2[0] : f32 from vector<8xf32>
                %5 = func.call @__mulsf3(%1, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %6 = vector.extract %2[1] : f32 from vector<8xf32>
                %7 = func.call @__mulsf3(%1, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %8 = vector.extract %2[2] : f32 from vector<8xf32>
                %9 = func.call @__mulsf3(%1, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %10 = vector.extract %2[3] : f32 from vector<8xf32>
                %11 = func.call @__mulsf3(%1, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %12 = vector.extract %2[4] : f32 from vector<8xf32>
                %13 = func.call @__mulsf3(%1, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %14 = vector.extract %2[5] : f32 from vector<8xf32>
                %15 = func.call @__mulsf3(%1, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %16 = vector.extract %2[6] : f32 from vector<8xf32>
                %17 = func.call @__mulsf3(%1, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %18 = vector.extract %2[7] : f32 from vector<8xf32>
                %19 = func.call @__mulsf3(%1, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
                %21 = arith.addf %3, %20 : vector<8xf32>
                vector.transfer_write %21, %reinterpret_cast_5[%arg2, %arg3] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_2(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_sequence(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_2 {
        aie.dma_bd(%arg3 : memref<16x64xf32> offset = 0 len = 256 sizes = [16, 16] strides = [64, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 0 len = 2048 sizes = [128, 16] strides = [64, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg0 : memref<16x128xf32> offset = 0 len = 1024 sizes = [2, 4, 8, 32] strides = [1024, 32, 128, 1])
        aie.end
      } {repeat_count = 1 : i32}
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @gemm_scale(%arg0: memref<16x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<16x64xf32>, %arg3: memref<16x64xf32>) {
      aiex.configure @orbit_segment {
        aiex.run @orbit_segment_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>)
      }
      aiex.configure @orbit_segment_16 {
        aiex.run @orbit_segment_16_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>)
      }
      aiex.configure @orbit_segment_24 {
        aiex.run @orbit_segment_24_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>)
      }
      aiex.configure @orbit_segment_32 {
        aiex.run @orbit_segment_32_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>)
      }
      aiex.configure @orbit_segment_40 {
        aiex.run @orbit_segment_40_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<16x128xf32>, memref<128x64xf32>, memref<16x64xf32>, memref<16x64xf32>)
      }
    }
  }
}
