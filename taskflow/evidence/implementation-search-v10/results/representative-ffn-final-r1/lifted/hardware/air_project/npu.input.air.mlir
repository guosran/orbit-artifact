#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "b17368bc3d1715cf23dbe0d39fee112916672cb9f5730905ae10a62506be8cc4", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "8c0c18e9f7ab0e83c0d958c735fe9d4b466e5b15e5cdf11aa852370d1e3f1414"} {
  aie.device(npu2) @orbit_segment_57232 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf23 = aie.buffer(%tile_0_2) {sym_name = "buf23"} : memref<32xf32, 2 : i32> 
    %buf22 = aie.buffer(%tile_0_2) {sym_name = "buf22"} : memref<64xf32, 2 : i32> 
    %buf21 = aie.buffer(%tile_0_2) {sym_name = "buf21"} : memref<2048xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<11008x2048xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<5x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x2048xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf23 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf21 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf22 : memref<64xf32, 2 : i32> offset = 0 len = 64) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c172 = arith.constant 172 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c64 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf23 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "down.initialize", orbit.phase = 57232 : i64, orbit.storage = "Y"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c32 step %c1 {
          memref.store %cst, %reinterpret_cast[%c0, %arg1] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c172 step %c1 {
          %reinterpret_cast_5 = memref.reinterpret_cast %buf21 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 57232 : i64, orbit.storage = "W_down"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast_6 = memref.reinterpret_cast %buf22 to offset: [0], sizes: [1, 64], strides: [64, 1] {orbit.phase = 57232 : i64, orbit.storage = "H"} : memref<64xf32, 2 : i32> to memref<1x64xf32, strided<[64, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c32 step %c8 {
            scf.for %arg3 = %c0 to %c64 step %c1 {
              %0 = memref.load %reinterpret_cast_6[%c0, %arg3] : memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %1 = vector.transfer_read %reinterpret_cast_5[%arg3, %arg2], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %2 = vector.transfer_read %reinterpret_cast[%c0, %arg2], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %20, %reinterpret_cast[%c0, %arg2] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_1, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_57232", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_23(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_21(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_22(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_57232_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_23 {
        aie.dma_bd(%arg4 : memref<5x2048xf32> offset = 8192 len = 2048 sizes = [2048] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_21 {
        aie.dma_bd(%arg3 : memref<11008x2048xf32> offset = 0 len = 352256 sizes = [32, 43, 256, 32] strides = [32, 524288, 2048, 1])
        aie.end
      } {repeat_count = 31 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_21 {
        aie.dma_bd(%arg3 : memref<11008x2048xf32> offset = 1024 len = 352256 sizes = [32, 43, 256, 32] strides = [32, 524288, 2048, 1])
        aie.end
      } {repeat_count = 31 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_22 {
        aie.dma_bd(%arg7 : memref<5x11008xf32> offset = 44032 len = 11008 sizes = [16, 688] strides = [688, 1])
        aie.end
      } {repeat_count = 63 : i32}
      aiex.dma_start_task(%3)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_46224 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf20 = aie.buffer(%tile_0_2) {sym_name = "buf20"} : memref<128xf32, 2 : i32> 
    %buf19 = aie.buffer(%tile_0_2) {sym_name = "buf19"} : memref<256xf32, 2 : i32> 
    %buf18 = aie.buffer(%tile_0_2) {sym_name = "buf18"} : memref<2048xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<11008x2048xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<5x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x2048xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf20 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf18 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf19 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c172 = arith.constant 172 : index
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c64 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf20 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.initializer_task = "down.initialize", orbit.phase = 46224 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c4 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c1 {
            memref.store %cst, %reinterpret_cast[%arg1, %arg2] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c172 step %c1 {
          %reinterpret_cast_5 = memref.reinterpret_cast %buf18 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 46224 : i64, orbit.storage = "W_down"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast_6 = memref.reinterpret_cast %buf19 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 46224 : i64, orbit.storage = "H"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c4 step %c1 {
            scf.for %arg3 = %c0 to %c32 step %c8 {
              scf.for %arg4 = %c0 to %c64 step %c1 {
                %0 = memref.load %reinterpret_cast_6[%arg2, %arg4] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                %1 = vector.transfer_read %reinterpret_cast_5[%arg4, %arg3], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                %2 = vector.transfer_read %reinterpret_cast[%arg2, %arg3], %cst : memref<4x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
                vector.transfer_write %20, %reinterpret_cast[%arg2, %arg3] : vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_1, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_46224", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_20(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_18(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_19(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_46224_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_20 {
        aie.dma_bd(%arg4 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [64, 4, 32] strides = [32, 2048, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_18 {
        aie.dma_bd(%arg3 : memref<11008x2048xf32> offset = 0 len = 352256 sizes = [32, 43, 256, 32] strides = [32, 524288, 2048, 1])
        aie.end
      } {repeat_count = 31 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_18 {
        aie.dma_bd(%arg3 : memref<11008x2048xf32> offset = 1024 len = 352256 sizes = [32, 43, 256, 32] strides = [32, 524288, 2048, 1])
        aie.end
      } {repeat_count = 31 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_19 {
        aie.dma_bd(%arg7 : memref<5x11008xf32> offset = 0 len = 44032 sizes = [172, 4, 64] strides = [64, 11008, 1])
        aie.end
      } {repeat_count = 31 : i32}
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air_channel_19 {
        aie.dma_bd(%arg7 : memref<5x11008xf32> offset = 0 len = 44032 sizes = [172, 4, 64] strides = [64, 11008, 1])
        aie.end
      } {repeat_count = 31 : i32}
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_45752 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf17 = aie.buffer(%tile_0_2) {sym_name = "buf17"} : memref<32xf32, 2 : i32> 
    %buf16 = aie.buffer(%tile_0_2) {sym_name = "buf16"} : memref<32xf32, 2 : i32> 
    %buf15 = aie.buffer(%tile_0_2) {sym_name = "buf15"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<5x11008xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<5x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x11008xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf17 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf15 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf16 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 1.000000e+00 : f32
      %cst_5 = arith.constant 5.000000e-01 : f32
      %cst_6 = arith.constant 1.44269502 : f32
      %cst_7 = arith.constant -0.693359375 : f32
      %cst_8 = arith.constant 2.12194442E-4 : f32
      %cst_9 = arith.constant 1.98756912E-4 : f32
      %cst_10 = arith.constant 0.00139819994 : f32
      %cst_11 = arith.constant 0.00833345205 : f32
      %cst_12 = arith.constant 0.0416657962 : f32
      %cst_13 = arith.constant 0.166666657 : f32
      %cst_14 = arith.constant -8.780000e+01 : f32
      %cst_15 = arith.constant 8.880000e+01 : f32
      %cst_16 = arith.constant -1.270000e+02 : f32
      %cst_17 = arith.constant 1.270000e+02 : f32
      %c23_i32 = arith.constant 23 : i32
      %c127_i32 = arith.constant 127 : i32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c344 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf15 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 45752 : i64, orbit.storage = "G"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_18 = memref.reinterpret_cast %buf16 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 45752 : i64, orbit.storage = "U"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_19 = memref.reinterpret_cast %buf17 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 45752 : i64, orbit.storage = "H"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c32 step %c1 {
          %0 = memref.load %reinterpret_cast[%c0, %arg1] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %1 = memref.load %reinterpret_cast_18[%c0, %arg1] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          %2 = arith.negf %0 : f32
          %3 = arith.cmpf uge, %2, %cst_14 : f32
          %4 = arith.select %3, %2, %cst_14 : f32
          %5 = arith.cmpf ule, %4, %cst_15 : f32
          %6 = arith.select %5, %4, %cst_15 : f32
          %7 = arith.mulf %6, %cst_6 : f32
          %8 = arith.addf %7, %cst_5 : f32
          %9 = arith.fptosi %8 : f32 to i32
          %10 = arith.sitofp %9 : i32 to f32
          %11 = arith.cmpf olt, %8, %10 : f32
          %12 = arith.subf %10, %cst : f32
          %13 = arith.select %11, %12, %10 : f32
          %14 = arith.cmpf uge, %13, %cst_16 : f32
          %15 = arith.select %14, %13, %cst_16 : f32
          %16 = arith.cmpf ule, %15, %cst_17 : f32
          %17 = arith.select %16, %15, %cst_17 : f32
          %18 = arith.mulf %17, %cst_7 : f32
          %19 = arith.addf %18, %6 : f32
          %20 = arith.mulf %17, %cst_8 : f32
          %21 = arith.addf %20, %19 : f32
          %22 = arith.mulf %21, %cst_9 : f32
          %23 = arith.addf %22, %cst_10 : f32
          %24 = arith.mulf %23, %21 : f32
          %25 = arith.addf %24, %cst_11 : f32
          %26 = arith.mulf %25, %21 : f32
          %27 = arith.addf %26, %cst_12 : f32
          %28 = arith.mulf %27, %21 : f32
          %29 = arith.addf %28, %cst_13 : f32
          %30 = arith.mulf %29, %21 : f32
          %31 = arith.addf %30, %cst_5 : f32
          %32 = arith.mulf %21, %21 : f32
          %33 = arith.mulf %31, %32 : f32
          %34 = arith.addf %33, %21 : f32
          %35 = arith.addf %34, %cst : f32
          %36 = arith.fptosi %17 : f32 to i32
          %37 = arith.addi %36, %c127_i32 : i32
          %38 = arith.shli %37, %c23_i32 : i32
          %39 = arith.bitcast %38 : i32 to f32
          %40 = arith.mulf %35, %39 : f32
          %41 = arith.addf %40, %cst : f32
          %42 = arith.divf %0, %41 : f32
          %43 = arith.mulf %42, %1 : f32
          memref.store %43, %reinterpret_cast_19[%c0, %arg1] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
        aie.use_lock(%lock_0_2, Release, %c1_i32)
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_45752", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_17(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_15(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_16(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_45752_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_17 {
        aie.dma_bd(%arg7 : memref<5x11008xf32> offset = 44032 len = 11008 sizes = [11008] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_15 {
        aie.dma_bd(%arg5 : memref<5x11008xf32> offset = 44032 len = 11008 sizes = [11008] strides = [1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_16 {
        aie.dma_bd(%arg6 : memref<5x11008xf32> offset = 44032 len = 11008 sizes = [11008] strides = [1])
        aie.end
      }
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_45408 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf14 = aie.buffer(%tile_0_2) {sym_name = "buf14"} : memref<128xf32, 2 : i32> 
    %buf13 = aie.buffer(%tile_0_2) {sym_name = "buf13"} : memref<128xf32, 2 : i32> 
    %buf12 = aie.buffer(%tile_0_2) {sym_name = "buf12"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<5x11008xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<5x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x11008xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf14 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf12 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf13 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 1.000000e+00 : f32
      %cst_5 = arith.constant 5.000000e-01 : f32
      %cst_6 = arith.constant 1.44269502 : f32
      %cst_7 = arith.constant -0.693359375 : f32
      %cst_8 = arith.constant 2.12194442E-4 : f32
      %cst_9 = arith.constant 1.98756912E-4 : f32
      %cst_10 = arith.constant 0.00139819994 : f32
      %cst_11 = arith.constant 0.00833345205 : f32
      %cst_12 = arith.constant 0.0416657962 : f32
      %cst_13 = arith.constant 0.166666657 : f32
      %cst_14 = arith.constant -8.780000e+01 : f32
      %cst_15 = arith.constant 8.880000e+01 : f32
      %cst_16 = arith.constant -1.270000e+02 : f32
      %cst_17 = arith.constant 1.270000e+02 : f32
      %c23_i32 = arith.constant 23 : i32
      %c127_i32 = arith.constant 127 : i32
      %c4 = arith.constant 4 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c344 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf12 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.phase = 45408 : i64, orbit.storage = "G"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_18 = memref.reinterpret_cast %buf13 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.phase = 45408 : i64, orbit.storage = "U"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_19 = memref.reinterpret_cast %buf14 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.phase = 45408 : i64, orbit.storage = "H"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c4 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c1 {
            %0 = memref.load %reinterpret_cast[%arg1, %arg2] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %1 = memref.load %reinterpret_cast_18[%arg1, %arg2] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %2 = arith.negf %0 : f32
            %3 = arith.cmpf uge, %2, %cst_14 : f32
            %4 = arith.select %3, %2, %cst_14 : f32
            %5 = arith.cmpf ule, %4, %cst_15 : f32
            %6 = arith.select %5, %4, %cst_15 : f32
            %7 = arith.mulf %6, %cst_6 : f32
            %8 = arith.addf %7, %cst_5 : f32
            %9 = arith.fptosi %8 : f32 to i32
            %10 = arith.sitofp %9 : i32 to f32
            %11 = arith.cmpf olt, %8, %10 : f32
            %12 = arith.subf %10, %cst : f32
            %13 = arith.select %11, %12, %10 : f32
            %14 = arith.cmpf uge, %13, %cst_16 : f32
            %15 = arith.select %14, %13, %cst_16 : f32
            %16 = arith.cmpf ule, %15, %cst_17 : f32
            %17 = arith.select %16, %15, %cst_17 : f32
            %18 = arith.mulf %17, %cst_7 : f32
            %19 = arith.addf %18, %6 : f32
            %20 = arith.mulf %17, %cst_8 : f32
            %21 = arith.addf %20, %19 : f32
            %22 = arith.mulf %21, %cst_9 : f32
            %23 = arith.addf %22, %cst_10 : f32
            %24 = arith.mulf %23, %21 : f32
            %25 = arith.addf %24, %cst_11 : f32
            %26 = arith.mulf %25, %21 : f32
            %27 = arith.addf %26, %cst_12 : f32
            %28 = arith.mulf %27, %21 : f32
            %29 = arith.addf %28, %cst_13 : f32
            %30 = arith.mulf %29, %21 : f32
            %31 = arith.addf %30, %cst_5 : f32
            %32 = arith.mulf %21, %21 : f32
            %33 = arith.mulf %31, %32 : f32
            %34 = arith.addf %33, %21 : f32
            %35 = arith.addf %34, %cst : f32
            %36 = arith.fptosi %17 : f32 to i32
            %37 = arith.addi %36, %c127_i32 : i32
            %38 = arith.shli %37, %c23_i32 : i32
            %39 = arith.bitcast %38 : i32 to f32
            %40 = arith.mulf %35, %39 : f32
            %41 = arith.addf %40, %cst : f32
            %42 = arith.divf %0, %41 : f32
            %43 = arith.mulf %42, %1 : f32
            memref.store %43, %reinterpret_cast_19[%arg1, %arg2] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
        aie.use_lock(%lock_0_2, Release, %c1_i32)
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_45408", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_14(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_12(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_13(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_45408_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_14 {
        aie.dma_bd(%arg7 : memref<5x11008xf32> offset = 0 len = 44032 sizes = [344, 4, 32] strides = [32, 11008, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_12 {
        aie.dma_bd(%arg5 : memref<5x11008xf32> offset = 0 len = 44032 sizes = [344, 4, 32] strides = [32, 11008, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_13 {
        aie.dma_bd(%arg6 : memref<5x11008xf32> offset = 0 len = 44032 sizes = [344, 4, 32] strides = [32, 11008, 1])
        aie.end
      }
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_34400 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf11 = aie.buffer(%tile_0_2) {sym_name = "buf11"} : memref<32xf32, 2 : i32> 
    %buf10 = aie.buffer(%tile_0_2) {sym_name = "buf10"} : memref<2048xf32, 2 : i32> 
    %buf9 = aie.buffer(%tile_0_2) {sym_name = "buf9"} : memref<64xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<5x2048xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<2048x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x11008xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf11 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf9 : memref<64xf32, 2 : i32> offset = 0 len = 64) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf10 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c64 = arith.constant 64 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c344 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf11 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "up.initialize", orbit.phase = 34400 : i64, orbit.storage = "U"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c32 step %c1 {
          memref.store %cst, %reinterpret_cast[%c0, %arg1] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c32 step %c1 {
          %reinterpret_cast_5 = memref.reinterpret_cast %buf9 to offset: [0], sizes: [1, 64], strides: [64, 1] {orbit.phase = 34400 : i64, orbit.storage = "X"} : memref<64xf32, 2 : i32> to memref<1x64xf32, strided<[64, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast_6 = memref.reinterpret_cast %buf10 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 34400 : i64, orbit.storage = "W_up"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c32 step %c8 {
            scf.for %arg3 = %c0 to %c64 step %c1 {
              %0 = memref.load %reinterpret_cast_5[%c0, %arg3] : memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %1 = vector.transfer_read %reinterpret_cast_6[%arg3, %arg2], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %2 = vector.transfer_read %reinterpret_cast[%c0, %arg2], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %20, %reinterpret_cast[%c0, %arg2] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_1, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_34400", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_11(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_9(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_10(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_34400_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_11 {
        aie.dma_bd(%arg6 : memref<5x11008xf32> offset = 44032 len = 11008 sizes = [11008] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_9 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 8192 len = 2048 sizes = [4, 512] strides = [512, 1])
        aie.end
      } {repeat_count = 343 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 0 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 1376 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 2752 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%4)
      %5 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 4128 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%5)
      %6 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 5504 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%2)
      aiex.dma_start_task(%6)
      %7 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 6880 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%3)
      aiex.dma_start_task(%7)
      %8 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 8256 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%4)
      aiex.dma_start_task(%8)
      %9 = aiex.dma_configure_task_for @air_channel_10 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 9632 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%5)
      aiex.dma_start_task(%9)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%6)
      aiex.dma_free_task(%7)
      aiex.dma_free_task(%8)
      aiex.dma_free_task(%9)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_23392 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf8 = aie.buffer(%tile_0_2) {sym_name = "buf8"} : memref<128xf32, 2 : i32> 
    %buf7 = aie.buffer(%tile_0_2) {sym_name = "buf7"} : memref<2048xf32, 2 : i32> 
    %buf6 = aie.buffer(%tile_0_2) {sym_name = "buf6"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<5x2048xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<2048x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x11008xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf8 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf6 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf7 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c64 = arith.constant 64 : index
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c344 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf8 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.initializer_task = "up.initialize", orbit.phase = 23392 : i64, orbit.storage = "U"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c4 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c1 {
            memref.store %cst, %reinterpret_cast[%arg1, %arg2] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c32 step %c1 {
          %reinterpret_cast_5 = memref.reinterpret_cast %buf6 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 23392 : i64, orbit.storage = "X"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast_6 = memref.reinterpret_cast %buf7 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 23392 : i64, orbit.storage = "W_up"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c4 step %c1 {
            scf.for %arg3 = %c0 to %c32 step %c8 {
              scf.for %arg4 = %c0 to %c64 step %c1 {
                %0 = memref.load %reinterpret_cast_5[%arg2, %arg4] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                %1 = vector.transfer_read %reinterpret_cast_6[%arg4, %arg3], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                %2 = vector.transfer_read %reinterpret_cast[%arg2, %arg3], %cst : memref<4x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
                vector.transfer_write %20, %reinterpret_cast[%arg2, %arg3] : vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_1, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_23392", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_8(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_6(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_7(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_23392_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_8 {
        aie.dma_bd(%arg6 : memref<5x11008xf32> offset = 0 len = 44032 sizes = [344, 4, 32] strides = [32, 11008, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 0 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 1376 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%4)
      %5 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%5)
      %6 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 2752 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%6)
      %7 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%7)
      %8 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 4128 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%8)
      %9 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%1)
      aiex.dma_start_task(%9)
      %10 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 5504 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%2)
      aiex.dma_start_task(%10)
      %11 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%3)
      aiex.dma_start_task(%11)
      %12 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 6880 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%4)
      aiex.dma_start_task(%12)
      %13 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%5)
      aiex.dma_start_task(%13)
      %14 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 8256 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%6)
      aiex.dma_start_task(%14)
      %15 = aiex.dma_configure_task_for @air_channel_6 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%7)
      aiex.dma_start_task(%15)
      %16 = aiex.dma_configure_task_for @air_channel_7 {
        aie.dma_bd(%arg2 : memref<2048x11008xf32> offset = 9632 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%8)
      aiex.dma_start_task(%16)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%9)
      aiex.dma_free_task(%11)
      aiex.dma_free_task(%13)
      aiex.dma_free_task(%15)
      aiex.dma_free_task(%10)
      aiex.dma_free_task(%12)
      aiex.dma_free_task(%14)
      aiex.dma_free_task(%16)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_11696 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf5 = aie.buffer(%tile_0_2) {sym_name = "buf5"} : memref<32xf32, 2 : i32> 
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<2048xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<64xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<5x2048xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<2048x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x11008xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf5 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<64xf32, 2 : i32> offset = 0 len = 64) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c64 = arith.constant 64 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c344 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf5 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "gate.initialize", orbit.phase = 11696 : i64, orbit.storage = "G"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c32 step %c1 {
          memref.store %cst, %reinterpret_cast[%c0, %arg1] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c32 step %c1 {
          %reinterpret_cast_5 = memref.reinterpret_cast %buf3 to offset: [0], sizes: [1, 64], strides: [64, 1] {orbit.phase = 11696 : i64, orbit.storage = "X"} : memref<64xf32, 2 : i32> to memref<1x64xf32, strided<[64, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast_6 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 11696 : i64, orbit.storage = "W_gate"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c32 step %c8 {
            scf.for %arg3 = %c0 to %c64 step %c1 {
              %0 = memref.load %reinterpret_cast_5[%c0, %arg3] : memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %1 = vector.transfer_read %reinterpret_cast_6[%arg3, %arg2], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %2 = vector.transfer_read %reinterpret_cast[%c0, %arg2], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %20, %reinterpret_cast[%c0, %arg2] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_1, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_11696", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_5(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_11696_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_5 {
        aie.dma_bd(%arg5 : memref<5x11008xf32> offset = 44032 len = 11008 sizes = [11008] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_3 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 8192 len = 2048 sizes = [4, 512] strides = [512, 1])
        aie.end
      } {repeat_count = 343 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 0 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 1376 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 2752 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%4)
      %5 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 4128 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%5)
      %6 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 5504 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%2)
      aiex.dma_start_task(%6)
      %7 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 6880 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%3)
      aiex.dma_start_task(%7)
      %8 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 8256 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%4)
      aiex.dma_start_task(%8)
      %9 = aiex.dma_configure_task_for @air_channel_4 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 9632 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%5)
      aiex.dma_start_task(%9)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%6)
      aiex.dma_free_task(%7)
      aiex.dma_free_task(%8)
      aiex.dma_free_task(%9)
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
    %buf2 = aie.buffer(%tile_0_2) {sym_name = "buf2"} : memref<128xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<2048xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<5x2048xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<2048x11008xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<5x11008xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
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
      aie.dma_bd(%buf1 : memref<2048xf32, 2 : i32> offset = 0 len = 2048) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c64 = arith.constant 64 : index
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c344 step %c1 {
        aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.initializer_task = "gate.initialize", orbit.phase = 688 : i64, orbit.storage = "G"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
        scf.for %arg1 = %c0 to %c4 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c1 {
            memref.store %cst, %reinterpret_cast[%arg1, %arg2] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        scf.for %arg1 = %c0 to %c32 step %c1 {
          %reinterpret_cast_5 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 688 : i64, orbit.storage = "X"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast_6 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 688 : i64, orbit.storage = "W_gate"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
          aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
          scf.for %arg2 = %c0 to %c4 step %c1 {
            scf.for %arg3 = %c0 to %c32 step %c8 {
              scf.for %arg4 = %c0 to %c64 step %c1 {
                %0 = memref.load %reinterpret_cast_5[%arg2, %arg4] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                %1 = vector.transfer_read %reinterpret_cast_6[%arg4, %arg3], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                %2 = vector.transfer_read %reinterpret_cast[%arg2, %arg3], %cst : memref<4x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
                vector.transfer_write %20, %reinterpret_cast[%arg2, %arg3] : vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>
              } {loop_annotation = #loop_annotation}
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          aie.use_lock(%lock_0_2_1, Release, %c1_i32)
          aie.use_lock(%lock_0_2, Release, %c1_i32)
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_4, Release, %c1_i32)
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
    aie.runtime_sequence @orbit_segment_sequence(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_2 {
        aie.dma_bd(%arg5 : memref<5x11008xf32> offset = 0 len = 44032 sizes = [344, 4, 32] strides = [32, 11008, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 0 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 1376 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%4)
      %5 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%5)
      %6 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 2752 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%6)
      %7 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%7)
      %8 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 4128 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {issue_token = true, repeat_count = 42 : i32}
      aiex.dma_start_task(%8)
      %9 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%1)
      aiex.dma_start_task(%9)
      %10 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 5504 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%2)
      aiex.dma_start_task(%10)
      %11 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%3)
      aiex.dma_start_task(%11)
      %12 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 6880 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%4)
      aiex.dma_start_task(%12)
      %13 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%5)
      aiex.dma_start_task(%13)
      %14 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 8256 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%6)
      aiex.dma_start_task(%14)
      %15 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<5x2048xf32> offset = 0 len = 8192 sizes = [32, 4, 64] strides = [64, 2048, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%7)
      aiex.dma_start_task(%15)
      %16 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<2048x11008xf32> offset = 9632 len = 65536 sizes = [43, 32, 64, 32] strides = [32, 704512, 11008, 1])
        aie.end
      } {repeat_count = 42 : i32}
      aiex.dma_await_task(%8)
      aiex.dma_start_task(%16)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%9)
      aiex.dma_free_task(%11)
      aiex.dma_free_task(%13)
      aiex.dma_free_task(%15)
      aiex.dma_free_task(%10)
      aiex.dma_free_task(%12)
      aiex.dma_free_task(%14)
      aiex.dma_free_task(%16)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @ffn(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
      aiex.configure @orbit_segment {
        aiex.run @orbit_segment_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
      aiex.configure @orbit_segment_11696 {
        aiex.run @orbit_segment_11696_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
      aiex.configure @orbit_segment_23392 {
        aiex.run @orbit_segment_23392_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
      aiex.configure @orbit_segment_34400 {
        aiex.run @orbit_segment_34400_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
      aiex.configure @orbit_segment_45408 {
        aiex.run @orbit_segment_45408_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
      aiex.configure @orbit_segment_45752 {
        aiex.run @orbit_segment_45752_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
      aiex.configure @orbit_segment_46224 {
        aiex.run @orbit_segment_46224_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
      aiex.configure @orbit_segment_57232 {
        aiex.run @orbit_segment_57232_sequence(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>)
      }
    }
  }
}
