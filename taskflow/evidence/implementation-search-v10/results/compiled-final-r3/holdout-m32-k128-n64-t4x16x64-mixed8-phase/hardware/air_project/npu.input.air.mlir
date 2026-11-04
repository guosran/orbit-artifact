#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "ef4dd4b1cca00f96976ce9a2dad7250904a22ba4e57c75c42db1ff57129893db", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} {
  aie.device(npu2) @orbit_segment_96 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<64xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<64xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<32x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<64xf32, 2 : i32> offset = 0 len = 64) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<64xf32, 2 : i32> offset = 0 len = 64) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 0.000000e+00 : f32
      %cst_3 = arith.constant 5.000000e-01 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf3 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.phase = 96 : i64, orbit.storage = "Y"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_4 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.phase = 96 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c4 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c8 {
              %0 = vector.transfer_read %reinterpret_cast_4[%arg2, %arg3], %cst : memref<4x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %17, %reinterpret_cast[%arg2, %arg3] : vector<8xf32>, memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_2, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_96", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_96_sequence(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg2 : memref<32x64xf32> offset = 0 len = 256 sizes = [8, 4, 4, 16] strides = [256, 16, 64, 1])
        aie.end
      } {issue_token = true, repeat_count = 7 : i32}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_3 {
        aie.dma_bd(%arg3 : memref<32x64xf32> offset = 0 len = 256 sizes = [8, 4, 4, 16] strides = [256, 16, 64, 1])
        aie.end
      } {repeat_count = 7 : i32}
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
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
    %buf2 = aie.buffer(%tile_0_2) {sym_name = "buf2"} : memref<64xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<1024xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<32x128xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<128x64xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<64xf32, 2 : i32> offset = 0 len = 64) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c8 = arith.constant 8 : index
      %c4 = arith.constant 4 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c2 = arith.constant 2 : index
      %c64 = arith.constant 64 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [4, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : memref<64xf32, 2 : i32> to memref<4x16xf32, strided<[16, 1]>, 2 : i32>
          scf.for %arg2 = %c0 to %c4 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c1 {
              memref.store %cst, %reinterpret_cast[%arg2, %arg3] : memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          scf.for %arg2 = %c0 to %c2 step %c1 {
            %reinterpret_cast_5 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 32 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
            aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
            %reinterpret_cast_6 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [64, 16], strides: [16, 1] {orbit.phase = 32 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<64x16xf32, strided<[16, 1]>, 2 : i32>
            aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
            scf.for %arg3 = %c0 to %c4 step %c1 {
              scf.for %arg4 = %c0 to %c16 step %c8 {
                scf.for %arg5 = %c0 to %c64 step %c1 {
                  %0 = memref.load %reinterpret_cast_5[%arg3, %arg5] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                  %1 = vector.transfer_read %reinterpret_cast_6[%arg5, %arg4], %cst : memref<64x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                  %2 = vector.transfer_read %reinterpret_cast[%arg3, %arg4], %cst : memref<4x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                  %3 = vector.extract %1[0] : f32 from vector<8xf32>
                  %4 = func.call @__mulsf3(%0, %3) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %5 = vector.extract %1[1] : f32 from vector<8xf32>
                  %6 = func.call @__mulsf3(%0, %5) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %7 = vector.extract %1[2] : f32 from vector<8xf32>
                  %8 = func.call @__mulsf3(%0, %7) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %9 = vector.extract %1[3] : f32 from vector<8xf32>
                  %10 = func.call @__mulsf3(%0, %9) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %11 = vector.extract %1[4] : f32 from vector<8xf32>
                  %12 = func.call @__mulsf3(%0, %11) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %13 = vector.extract %1[5] : f32 from vector<8xf32>
                  %14 = func.call @__mulsf3(%0, %13) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %15 = vector.extract %1[6] : f32 from vector<8xf32>
                  %16 = func.call @__mulsf3(%0, %15) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %17 = vector.extract %1[7] : f32 from vector<8xf32>
                  %18 = func.call @__mulsf3(%0, %17) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %19 = vector.from_elements %4, %6, %8, %10, %12, %14, %16, %18 : vector<8xf32>
                  %20 = arith.addf %2, %19 : vector<8xf32>
                  vector.transfer_write %20, %reinterpret_cast[%arg3, %arg4] : vector<8xf32>, memref<4x16xf32, strided<[16, 1]>, 2 : i32>
                } {loop_annotation = #loop_annotation}
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
            aie.use_lock(%lock_0_2_1, Release, %c1_i32)
            aie.use_lock(%lock_0_2, Release, %c1_i32)
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_4, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_2(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_sequence(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_2 {
        aie.dma_bd(%arg3 : memref<32x64xf32> offset = 0 len = 256 sizes = [8, 4, 4, 16] strides = [256, 16, 64, 1])
        aie.end
      } {issue_token = true, repeat_count = 7 : i32}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 0 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {issue_token = true, repeat_count = 3 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<128x64xf32> offset = 0 len = 8192 sizes = [4, 128, 16] strides = [16, 64, 1])
        aie.end
      } {repeat_count = 7 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 512 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {issue_token = true, repeat_count = 3 : i32}
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 1024 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {issue_token = true, repeat_count = 3 : i32}
      aiex.dma_start_task(%4)
      %5 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 1536 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {issue_token = true, repeat_count = 3 : i32}
      aiex.dma_start_task(%5)
      %6 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 2048 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_await_task(%1)
      aiex.dma_start_task(%6)
      %7 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 2560 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_await_task(%3)
      aiex.dma_start_task(%7)
      %8 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 3072 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_await_task(%4)
      aiex.dma_start_task(%8)
      %9 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<32x128xf32> offset = 3584 len = 512 sizes = [2, 4, 64] strides = [64, 128, 1])
        aie.end
      } {repeat_count = 3 : i32}
      aiex.dma_await_task(%5)
      aiex.dma_start_task(%9)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%6)
      aiex.dma_free_task(%7)
      aiex.dma_free_task(%8)
      aiex.dma_free_task(%9)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @gemm_scale(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
      aiex.configure @orbit_segment {
        aiex.run @orbit_segment_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>)
      }
      aiex.configure @orbit_segment_96 {
        aiex.run @orbit_segment_96_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>)
      }
    }
  }
}
