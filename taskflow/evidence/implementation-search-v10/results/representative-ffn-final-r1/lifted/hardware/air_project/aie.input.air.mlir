#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "b17368bc3d1715cf23dbe0d39fee112916672cb9f5730905ae10a62506be8cc4", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "8c0c18e9f7ab0e83c0d958c735fe9d4b466e5b15e5cdf11aa852370d1e3f1414"} {
  aie.device(npu2) @orbit_segment_57232 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_21 [1, 1]
    air.channel @channel_22 [1, 1]
    air.channel @channel_23 [1, 1]
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_23(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_21(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_22(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_46224 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_18 [1, 1]
    air.channel @channel_19 [1, 1]
    air.channel @channel_20 [1, 1]
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_20(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_18(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_19(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_45752 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_15 [1, 1]
    air.channel @channel_16 [1, 1]
    air.channel @channel_17 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_17(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_15(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_16(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_45408 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_12 [1, 1]
    air.channel @channel_13 [1, 1]
    air.channel @channel_14 [1, 1]
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_14(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_12(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_13(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_34400 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_9 [1, 1]
    air.channel @channel_10 [1, 1]
    air.channel @channel_11 [1, 1]
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_11(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_9(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_10(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_23392 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_6 [1, 1]
    air.channel @channel_7 [1, 1]
    air.channel @channel_8 [1, 1]
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_8(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_6(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_7(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_11696 {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_3 [1, 1]
    air.channel @channel_4 [1, 1]
    air.channel @channel_5 [1, 1]
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_5(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment {
    %mem_tile_7_1 = aie.tile(7, 1)
    %mem_tile_6_1 = aie.tile(6, 1)
    %mem_tile_5_1 = aie.tile(5, 1)
    %mem_tile_4_1 = aie.tile(4, 1)
    %mem_tile_3_1 = aie.tile(3, 1)
    %mem_tile_2_1 = aie.tile(2, 1)
    %mem_tile_1_1 = aie.tile(1, 1)
    %mem_tile_0_1 = aie.tile(0, 1)
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
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
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
    air.channel @channel_0 [1, 1]
    air.channel @channel_1 [1, 1]
    air.channel @channel_2 [1, 1]
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%shim_noc_tile_0_0, DMA : 1, %tile_0_2, DMA : 1) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_2(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  airrt.module_metadata{
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 6 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 4 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 5 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_11696"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 12 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 10 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 11 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_11696"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_23392"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 18 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 16 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 17 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_23392"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_34400"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 24 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 22 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 23 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_34400"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_45408"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 30 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 28 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 29 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_45408"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_45752"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 36 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 34 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 35 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_45752"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_46224"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 42 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 40 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 41 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_46224"}
    }
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_57232"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 48 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 46 : i64, location = -1 : i64, row = 0 : i64}, {channel = 3 : i64, col = 0 : i64, id = 47 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_57232"}
    }
  }
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
  air.channel @channel_14 [1, 1]
  air.channel @channel_15 [1, 1]
  air.channel @channel_16 [1, 1]
  air.channel @channel_17 [1, 1]
  air.channel @channel_18 [1, 1]
  air.channel @channel_19 [1, 1]
  air.channel @channel_20 [1, 1]
  air.channel @channel_21 [1, 1]
  air.channel @channel_22 [1, 1]
  air.channel @channel_23 [1, 1]
  func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
  func.func @ffn(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg0, %arg13=%arg1, %arg14=%arg5) : memref<5x2048xf32>, memref<2048x11008xf32>, memref<5x11008xf32> attributes {id = 1 : i32} {
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %16 = arith.muli %arg17, %c64 : index
          %17 = air.channel.put async [%arg18]  @channel_0[%c0, %c0] (%arg12[0, %16] [4, 64] [2048, 1]) {id = 1 : i32, metadataArray = [{base = "air_channel_0", index = 0 : i32}]} : (memref<5x2048xf32>)
          scf.yield %17 : !air.async.token
        }
        scf.yield %15 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %17 = arith.muli %arg17, %c64 : index
          %18 = air.channel.put async [%arg18]  @channel_1[%c0, %c0] (%arg13[%17, %15] [64, 32] [11008, 1]) {id = 2 : i32, metadataArray = [{base = "air_channel_1", index = 0 : i32}]} : (memref<2048x11008xf32>)
          scf.yield %18 : !air.async.token
        }
        scf.yield %16 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_2[%c0, %c0] (%arg14[0, %15] [4, 32] [11008, 1]) {id = 3 : i32, metadataArray = [{base = "air_channel_2", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c4 = arith.constant 4 : index
          %c64_2 = arith.constant 64 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c344_5 = arith.constant 344 : index
          %c0_6 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_6 to %c344_5 step %c1_4 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.initializer_task = "gate.initialize", orbit.phase = 688 : i64, orbit.storage = "G"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.wait_all async 
            %19 = scf.for %arg21 = %c0_6 to %c4 step %c1_4 iter_args(%arg22 = %18) -> (!air.async.token) {
              %23 = scf.for %arg23 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_8 = air.execute [%arg24] {
                  memref.store %cst, %reinterpret_cast[%arg21, %arg23] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                }
                scf.yield %async_token_8 : !air.async.token
              }
              scf.yield %23 : !air.async.token
            }
            %20 = air.wait_all async [%arg20, %19] 
            %21 = scf.for %arg21 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg22 = %20) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<2048xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.32.loops.4.32.64"} : memref<2048xf32, 2 : i32>
                air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.32.64"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 688 : i64, orbit.storage = "X"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %23 = air.channel.get async [%async_token_10, %arg22]  @channel_0[%arg15, %arg16] (%results_11[] [] []) {id = 4 : i32} : (memref<256xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 688 : i64, orbit.storage = "W_gate"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %24 = air.channel.get async [%async_token_8, %arg22]  @channel_1[%arg15, %arg16] (%results_9[] [] []) {id = 5 : i32} : (memref<2048xf32, 2 : i32>)
              air.wait_all [%23, %24]  {orbit.computation_event = 3 : i64, orbit.phase = 688 : i64, orbit.phase_dependencies = array<i64: 687>, orbit.read_copies = array<i64: 33088, 33089, 33090>, orbit.task = "gate", orbit.write_copies = array<i64: 33091>}
              %25 = air.wait_all async [%23, %24] 
              %26 = scf.for %arg23 = %c0_6 to %c4 step %c1_4 iter_args(%arg24 = %25) -> (!air.async.token) {
                %27 = scf.for %arg25 = %c0_6 to %c32_3 step %c8 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %28 = scf.for %arg27 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg28 = %arg26) -> (!air.async.token) {
                    %async_token_16, %results_17 = air.execute [%arg28] -> (f32) {
                      %40 = memref.load %reinterpret_cast_12[%arg23, %arg27] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %40 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg28] -> (vector<8xf32>) {
                      %40 = vector.transfer_read %reinterpret_cast_13[%arg27, %arg25], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %40 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg28] -> (vector<8xf32>) {
                      %40 = vector.transfer_read %reinterpret_cast[%arg23, %arg25], %cst : memref<4x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %40 : vector<8xf32>
                    }
                    %29 = vector.extract %results_19[0] : f32 from vector<8xf32>
                    %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %30 = vector.extract %results_19[1] : f32 from vector<8xf32>
                    %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %31 = vector.extract %results_19[2] : f32 from vector<8xf32>
                    %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %32 = vector.extract %results_19[3] : f32 from vector<8xf32>
                    %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %33 = vector.extract %results_19[4] : f32 from vector<8xf32>
                    %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %33) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %34 = vector.extract %results_19[5] : f32 from vector<8xf32>
                    %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %34) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %35 = vector.extract %results_19[6] : f32 from vector<8xf32>
                    %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %35) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %36 = vector.extract %results_19[7] : f32 from vector<8xf32>
                    %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %36) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %37 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                    %38 = arith.addf %results_21, %37 : vector<8xf32>
                    %async_token_38 = air.execute [%async_token_20] {
                      vector.transfer_write %38, %reinterpret_cast[%arg23, %arg25] : vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                    }
                    %39 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %39 : !air.async.token
                  }
                  scf.yield %28 : !air.async.token
                }
                scf.yield %27 : !air.async.token
              }
              %async_token_14 = air.execute [%23] {
                memref.dealloc %results_11 : memref<256xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%24] {
                memref.dealloc %results_9 : memref<2048xf32, 2 : i32>
              }
              scf.yield %26 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_2[%arg15, %arg16] (%results[] [] []) {id = 6 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_7 = air.execute [%22] {
              memref.dealloc %results : memref<128xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 344 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_11696 async [%0] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg0, %arg13=%arg1, %arg14=%arg5) : memref<5x2048xf32>, memref<2048x11008xf32>, memref<5x11008xf32> attributes {id = 4 : i32} {
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %16 = arith.muli %arg17, %c64 : index
          %17 = air.channel.put async [%arg18]  @channel_3[%c0, %c0] (%arg12[4, %16] [1, 64] [2048, 1]) {id = 7 : i32, metadataArray = [{base = "air_channel_3", index = 0 : i32}]} : (memref<5x2048xf32>)
          scf.yield %17 : !air.async.token
        }
        scf.yield %15 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %17 = arith.muli %arg17, %c64 : index
          %18 = air.channel.put async [%arg18]  @channel_4[%c0, %c0] (%arg13[%17, %15] [64, 32] [11008, 1]) {id = 8 : i32, metadataArray = [{base = "air_channel_4", index = 0 : i32}]} : (memref<2048x11008xf32>)
          scf.yield %18 : !air.async.token
        }
        scf.yield %16 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_5[%c0, %c0] (%arg14[4, %15] [1, 32] [11008, 1]) {id = 9 : i32, metadataArray = [{base = "air_channel_5", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment_11696 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd_11696 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c64_2 = arith.constant 64 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c344_5 = arith.constant 344 : index
          %c0_6 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_6 to %c344_5 step %c1_4 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "gate.initialize", orbit.phase = 11696 : i64, orbit.storage = "G"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.wait_all async 
            %19 = scf.for %arg21 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg22 = %18) -> (!air.async.token) {
              %async_token_8 = air.execute [%arg22] {
                memref.store %cst, %reinterpret_cast[%c0_6, %arg21] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              }
              scf.yield %async_token_8 : !air.async.token
            }
            %20 = air.wait_all async [%arg20, %19] 
            %21 = scf.for %arg21 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg22 = %20) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<2048xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.32.loops.1.32.64"} : memref<2048xf32, 2 : i32>
                air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.64.loops.1.32.64"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [1, 64], strides: [64, 1] {orbit.phase = 11696 : i64, orbit.storage = "X"} : memref<64xf32, 2 : i32> to memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %23 = air.channel.get async [%async_token_10, %arg22]  @channel_3[%arg15, %arg16] (%results_11[] [] []) {id = 10 : i32} : (memref<64xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 11696 : i64, orbit.storage = "W_gate"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %24 = air.channel.get async [%async_token_8, %arg22]  @channel_4[%arg15, %arg16] (%results_9[] [] []) {id = 11 : i32} : (memref<2048xf32, 2 : i32>)
              air.wait_all [%23, %24]  {orbit.computation_event = 33715 : i64, orbit.phase = 11696 : i64, orbit.phase_dependencies = array<i64: 11695>, orbit.read_copies = array<i64: 66800, 66801, 66802>, orbit.task = "gate", orbit.write_copies = array<i64: 66803>}
              %25 = air.wait_all async [%23, %24] 
              %26 = scf.for %arg23 = %c0_6 to %c32_3 step %c8 iter_args(%arg24 = %25) -> (!air.async.token) {
                %27 = scf.for %arg25 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %async_token_16, %results_17 = air.execute [%arg26] -> (f32) {
                    %39 = memref.load %reinterpret_cast_12[%c0_6, %arg25] : memref<1x64xf32, strided<[64, 1]>, 2 : i32>
                    air.execute_terminator %39 : f32
                  }
                  %async_token_18, %results_19 = air.execute [%arg26] -> (vector<8xf32>) {
                    %39 = vector.transfer_read %reinterpret_cast_13[%arg25, %arg23], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %39 : vector<8xf32>
                  }
                  %async_token_20, %results_21 = air.execute [%arg26] -> (vector<8xf32>) {
                    %39 = vector.transfer_read %reinterpret_cast[%c0_6, %arg23], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %39 : vector<8xf32>
                  }
                  %28 = vector.extract %results_19[0] : f32 from vector<8xf32>
                  %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %28) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %29 = vector.extract %results_19[1] : f32 from vector<8xf32>
                  %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %30 = vector.extract %results_19[2] : f32 from vector<8xf32>
                  %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %31 = vector.extract %results_19[3] : f32 from vector<8xf32>
                  %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %32 = vector.extract %results_19[4] : f32 from vector<8xf32>
                  %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %33 = vector.extract %results_19[5] : f32 from vector<8xf32>
                  %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %33) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %34 = vector.extract %results_19[6] : f32 from vector<8xf32>
                  %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %34) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %35 = vector.extract %results_19[7] : f32 from vector<8xf32>
                  %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %35) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %36 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                  %37 = arith.addf %results_21, %36 : vector<8xf32>
                  %async_token_38 = air.execute [%async_token_20] {
                    vector.transfer_write %37, %reinterpret_cast[%c0_6, %arg23] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %38 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                  scf.yield %38 : !air.async.token
                }
                scf.yield %27 : !air.async.token
              }
              %async_token_14 = air.execute [%23] {
                memref.dealloc %results_11 : memref<64xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%24] {
                memref.dealloc %results_9 : memref<2048xf32, 2 : i32>
              }
              scf.yield %26 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_5[%arg15, %arg16] (%results[] [] []) {id = 12 : i32} : (memref<32xf32, 2 : i32>)
            %async_token_7 = air.execute [%22] {
              memref.dealloc %results : memref<32xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 344 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    %2 = air.launch @orbit_launch_23392 async [%1] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg0, %arg13=%arg2, %arg14=%arg6) : memref<5x2048xf32>, memref<2048x11008xf32>, memref<5x11008xf32> attributes {id = 7 : i32} {
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %16 = arith.muli %arg17, %c64 : index
          %17 = air.channel.put async [%arg18]  @channel_6[%c0, %c0] (%arg12[0, %16] [4, 64] [2048, 1]) {id = 13 : i32, metadataArray = [{base = "air_channel_6", index = 0 : i32}]} : (memref<5x2048xf32>)
          scf.yield %17 : !air.async.token
        }
        scf.yield %15 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %17 = arith.muli %arg17, %c64 : index
          %18 = air.channel.put async [%arg18]  @channel_7[%c0, %c0] (%arg13[%17, %15] [64, 32] [11008, 1]) {id = 14 : i32, metadataArray = [{base = "air_channel_7", index = 0 : i32}]} : (memref<2048x11008xf32>)
          scf.yield %18 : !air.async.token
        }
        scf.yield %16 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_8[%c0, %c0] (%arg14[0, %15] [4, 32] [11008, 1]) {id = 15 : i32, metadataArray = [{base = "air_channel_8", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment_23392 async  attributes {id = 8 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd_23392 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 9 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c4 = arith.constant 4 : index
          %c64_2 = arith.constant 64 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c344_5 = arith.constant 344 : index
          %c0_6 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_6 to %c344_5 step %c1_4 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.initializer_task = "up.initialize", orbit.phase = 23392 : i64, orbit.storage = "U"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.wait_all async 
            %19 = scf.for %arg21 = %c0_6 to %c4 step %c1_4 iter_args(%arg22 = %18) -> (!air.async.token) {
              %23 = scf.for %arg23 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_8 = air.execute [%arg24] {
                  memref.store %cst, %reinterpret_cast[%arg21, %arg23] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                }
                scf.yield %async_token_8 : !air.async.token
              }
              scf.yield %23 : !air.async.token
            }
            %20 = air.wait_all async [%arg20, %19] 
            %21 = scf.for %arg21 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg22 = %20) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<2048xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.64.32.loops.4.32.64"} : memref<2048xf32, 2 : i32>
                air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.32.64"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 23392 : i64, orbit.storage = "X"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %23 = air.channel.get async [%async_token_10, %arg22]  @channel_6[%arg15, %arg16] (%results_11[] [] []) {id = 16 : i32} : (memref<256xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 23392 : i64, orbit.storage = "W_up"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %24 = air.channel.get async [%async_token_8, %arg22]  @channel_7[%arg15, %arg16] (%results_9[] [] []) {id = 17 : i32} : (memref<2048xf32, 2 : i32>)
              air.wait_all [%23, %24]  {orbit.computation_event = 67427 : i64, orbit.phase = 23392 : i64, orbit.phase_dependencies = array<i64: 23391>, orbit.read_copies = array<i64: 100512, 100513, 100514>, orbit.task = "up", orbit.write_copies = array<i64: 100515>}
              %25 = air.wait_all async [%23, %24] 
              %26 = scf.for %arg23 = %c0_6 to %c4 step %c1_4 iter_args(%arg24 = %25) -> (!air.async.token) {
                %27 = scf.for %arg25 = %c0_6 to %c32_3 step %c8 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %28 = scf.for %arg27 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg28 = %arg26) -> (!air.async.token) {
                    %async_token_16, %results_17 = air.execute [%arg28] -> (f32) {
                      %40 = memref.load %reinterpret_cast_12[%arg23, %arg27] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %40 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg28] -> (vector<8xf32>) {
                      %40 = vector.transfer_read %reinterpret_cast_13[%arg27, %arg25], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %40 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg28] -> (vector<8xf32>) {
                      %40 = vector.transfer_read %reinterpret_cast[%arg23, %arg25], %cst : memref<4x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %40 : vector<8xf32>
                    }
                    %29 = vector.extract %results_19[0] : f32 from vector<8xf32>
                    %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %30 = vector.extract %results_19[1] : f32 from vector<8xf32>
                    %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %31 = vector.extract %results_19[2] : f32 from vector<8xf32>
                    %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %32 = vector.extract %results_19[3] : f32 from vector<8xf32>
                    %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %33 = vector.extract %results_19[4] : f32 from vector<8xf32>
                    %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %33) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %34 = vector.extract %results_19[5] : f32 from vector<8xf32>
                    %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %34) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %35 = vector.extract %results_19[6] : f32 from vector<8xf32>
                    %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %35) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %36 = vector.extract %results_19[7] : f32 from vector<8xf32>
                    %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %36) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %37 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                    %38 = arith.addf %results_21, %37 : vector<8xf32>
                    %async_token_38 = air.execute [%async_token_20] {
                      vector.transfer_write %38, %reinterpret_cast[%arg23, %arg25] : vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                    }
                    %39 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %39 : !air.async.token
                  }
                  scf.yield %28 : !air.async.token
                }
                scf.yield %27 : !air.async.token
              }
              %async_token_14 = air.execute [%23] {
                memref.dealloc %results_11 : memref<256xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%24] {
                memref.dealloc %results_9 : memref<2048xf32, 2 : i32>
              }
              scf.yield %26 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_8[%arg15, %arg16] (%results[] [] []) {id = 18 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_7 = air.execute [%22] {
              memref.dealloc %results : memref<128xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 344 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    %3 = air.launch @orbit_launch_34400 async [%2] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg0, %arg13=%arg2, %arg14=%arg6) : memref<5x2048xf32>, memref<2048x11008xf32>, memref<5x11008xf32> attributes {id = 10 : i32} {
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %16 = arith.muli %arg17, %c64 : index
          %17 = air.channel.put async [%arg18]  @channel_9[%c0, %c0] (%arg12[4, %16] [1, 64] [2048, 1]) {id = 19 : i32, metadataArray = [{base = "air_channel_9", index = 0 : i32}]} : (memref<5x2048xf32>)
          scf.yield %17 : !air.async.token
        }
        scf.yield %15 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = scf.for %arg17 = %c0 to %c32 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %17 = arith.muli %arg17, %c64 : index
          %18 = air.channel.put async [%arg18]  @channel_10[%c0, %c0] (%arg13[%17, %15] [64, 32] [11008, 1]) {id = 20 : i32, metadataArray = [{base = "air_channel_10", index = 0 : i32}]} : (memref<2048x11008xf32>)
          scf.yield %18 : !air.async.token
        }
        scf.yield %16 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_11[%c0, %c0] (%arg14[4, %15] [1, 32] [11008, 1]) {id = 21 : i32, metadataArray = [{base = "air_channel_11", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment_34400 async  attributes {id = 11 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd_34400 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 12 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c64_2 = arith.constant 64 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c344_5 = arith.constant 344 : index
          %c0_6 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_6 to %c344_5 step %c1_4 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "up.initialize", orbit.phase = 34400 : i64, orbit.storage = "U"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.wait_all async 
            %19 = scf.for %arg21 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg22 = %18) -> (!air.async.token) {
              %async_token_8 = air.execute [%arg22] {
                memref.store %cst, %reinterpret_cast[%c0_6, %arg21] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              }
              scf.yield %async_token_8 : !air.async.token
            }
            %20 = air.wait_all async [%arg20, %19] 
            %21 = scf.for %arg21 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg22 = %20) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<2048xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.64.32.loops.1.32.64"} : memref<2048xf32, 2 : i32>
                air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.64.loops.1.32.64"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [1, 64], strides: [64, 1] {orbit.phase = 34400 : i64, orbit.storage = "X"} : memref<64xf32, 2 : i32> to memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %23 = air.channel.get async [%async_token_10, %arg22]  @channel_9[%arg15, %arg16] (%results_11[] [] []) {id = 22 : i32} : (memref<64xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 34400 : i64, orbit.storage = "W_up"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %24 = air.channel.get async [%async_token_8, %arg22]  @channel_10[%arg15, %arg16] (%results_9[] [] []) {id = 23 : i32} : (memref<2048xf32, 2 : i32>)
              air.wait_all [%23, %24]  {orbit.computation_event = 101139 : i64, orbit.phase = 34400 : i64, orbit.phase_dependencies = array<i64: 34399>, orbit.read_copies = array<i64: 134224, 134225, 134226>, orbit.task = "up", orbit.write_copies = array<i64: 134227>}
              %25 = air.wait_all async [%23, %24] 
              %26 = scf.for %arg23 = %c0_6 to %c32_3 step %c8 iter_args(%arg24 = %25) -> (!air.async.token) {
                %27 = scf.for %arg25 = %c0_6 to %c64_2 step %c1_4 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %async_token_16, %results_17 = air.execute [%arg26] -> (f32) {
                    %39 = memref.load %reinterpret_cast_12[%c0_6, %arg25] : memref<1x64xf32, strided<[64, 1]>, 2 : i32>
                    air.execute_terminator %39 : f32
                  }
                  %async_token_18, %results_19 = air.execute [%arg26] -> (vector<8xf32>) {
                    %39 = vector.transfer_read %reinterpret_cast_13[%arg25, %arg23], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %39 : vector<8xf32>
                  }
                  %async_token_20, %results_21 = air.execute [%arg26] -> (vector<8xf32>) {
                    %39 = vector.transfer_read %reinterpret_cast[%c0_6, %arg23], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %39 : vector<8xf32>
                  }
                  %28 = vector.extract %results_19[0] : f32 from vector<8xf32>
                  %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %28) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %29 = vector.extract %results_19[1] : f32 from vector<8xf32>
                  %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %30 = vector.extract %results_19[2] : f32 from vector<8xf32>
                  %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %31 = vector.extract %results_19[3] : f32 from vector<8xf32>
                  %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %32 = vector.extract %results_19[4] : f32 from vector<8xf32>
                  %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %33 = vector.extract %results_19[5] : f32 from vector<8xf32>
                  %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %33) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %34 = vector.extract %results_19[6] : f32 from vector<8xf32>
                  %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %34) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %35 = vector.extract %results_19[7] : f32 from vector<8xf32>
                  %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %35) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %36 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                  %37 = arith.addf %results_21, %36 : vector<8xf32>
                  %async_token_38 = air.execute [%async_token_20] {
                    vector.transfer_write %37, %reinterpret_cast[%c0_6, %arg23] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %38 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                  scf.yield %38 : !air.async.token
                }
                scf.yield %27 : !air.async.token
              }
              %async_token_14 = air.execute [%23] {
                memref.dealloc %results_11 : memref<64xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%24] {
                memref.dealloc %results_9 : memref<2048xf32, 2 : i32>
              }
              scf.yield %26 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_11[%arg15, %arg16] (%results[] [] []) {id = 24 : i32} : (memref<32xf32, 2 : i32>)
            %async_token_7 = air.execute [%22] {
              memref.dealloc %results : memref<32xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 344 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    %4 = air.launch @orbit_launch_45408 async [%3] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg5, %arg13=%arg6, %arg14=%arg7) : memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32> attributes {id = 13 : i32} {
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.put async [%arg16]  @channel_12[%c0, %c0] (%arg12[0, %15] [4, 32] [11008, 1]) {id = 25 : i32, metadataArray = [{base = "air_channel_12", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.put async [%arg16]  @channel_13[%c0, %c0] (%arg13[0, %15] [4, 32] [11008, 1]) {id = 26 : i32, metadataArray = [{base = "air_channel_13", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_14[%c0, %c0] (%arg14[0, %15] [4, 32] [11008, 1]) {id = 27 : i32, metadataArray = [{base = "air_channel_14", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment_45408 async  attributes {id = 14 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd_45408 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 15 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c4 = arith.constant 4 : index
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
          %c32_15 = arith.constant 32 : index
          %c1_16 = arith.constant 1 : index
          %c344_17 = arith.constant 344 : index
          %c0_18 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_18 to %c344_17 step %c1_16 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %async_token_19, %results_20 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data.input.4.32.loops.4.32"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %async_token_21, %results_22 = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data.input.4.32.loops.4.32"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results_22 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.phase = 45408 : i64, orbit.storage = "G"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.channel.get async [%async_token_21, %arg20]  @channel_12[%arg15, %arg16] (%results_22[] [] []) {id = 28 : i32} : (memref<128xf32, 2 : i32>)
            %reinterpret_cast_23 = memref.reinterpret_cast %results_20 to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.phase = 45408 : i64, orbit.storage = "U"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %19 = air.channel.get async [%async_token_19, %arg20]  @channel_13[%arg15, %arg16] (%results_20[] [] []) {id = 29 : i32} : (memref<128xf32, 2 : i32>)
            %reinterpret_cast_24 = memref.reinterpret_cast %results to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.phase = 45408 : i64, orbit.storage = "H"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            air.wait_all [%18, %19]  {orbit.computation_event = 134850 : i64, orbit.phase = 45408 : i64, orbit.phase_dependencies = array<i64: 45407>, orbit.read_copies = array<i64: 167936, 167937>, orbit.task = "swiglu", orbit.write_copies = array<i64: 167938>}
            %20 = air.wait_all async [%18, %19] 
            %21 = scf.for %arg21 = %c0_18 to %c4 step %c1_16 iter_args(%arg22 = %20) -> (!air.async.token) {
              %23 = scf.for %arg23 = %c0_18 to %c32_15 step %c1_16 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_28, %results_29 = air.execute [%arg24] -> (f32) {
                  %67 = memref.load %reinterpret_cast[%arg21, %arg23] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %67 : f32
                }
                %async_token_30, %results_31 = air.execute [%arg24] -> (f32) {
                  %67 = memref.load %reinterpret_cast_23[%arg21, %arg23] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                  air.execute_terminator %67 : f32
                }
                %24 = arith.negf %results_29 : f32
                %25 = arith.cmpf uge, %24, %cst_4 : f32
                %26 = arith.select %25, %24, %cst_4 : f32
                %27 = arith.cmpf ule, %26, %cst_3 : f32
                %28 = arith.select %27, %26, %cst_3 : f32
                %29 = arith.mulf %28, %cst_12 : f32
                %30 = arith.addf %29, %cst_13 : f32
                %31 = arith.fptosi %30 : f32 to i32
                %32 = arith.sitofp %31 : i32 to f32
                %33 = arith.cmpf olt, %30, %32 : f32
                %34 = arith.subf %32, %cst_14 : f32
                %35 = arith.select %33, %34, %32 : f32
                %36 = arith.cmpf uge, %35, %cst_2 : f32
                %37 = arith.select %36, %35, %cst_2 : f32
                %38 = arith.cmpf ule, %37, %cst : f32
                %39 = arith.select %38, %37, %cst : f32
                %40 = arith.mulf %39, %cst_11 : f32
                %41 = arith.addf %40, %28 : f32
                %42 = arith.mulf %39, %cst_10 : f32
                %43 = arith.addf %42, %41 : f32
                %44 = arith.mulf %43, %cst_9 : f32
                %45 = arith.addf %44, %cst_8 : f32
                %46 = arith.mulf %45, %43 : f32
                %47 = arith.addf %46, %cst_7 : f32
                %48 = arith.mulf %47, %43 : f32
                %49 = arith.addf %48, %cst_6 : f32
                %50 = arith.mulf %49, %43 : f32
                %51 = arith.addf %50, %cst_5 : f32
                %52 = arith.mulf %51, %43 : f32
                %53 = arith.addf %52, %cst_13 : f32
                %54 = arith.mulf %43, %43 : f32
                %55 = arith.mulf %53, %54 : f32
                %56 = arith.addf %55, %43 : f32
                %57 = arith.addf %56, %cst_14 : f32
                %58 = arith.fptosi %39 : f32 to i32
                %59 = arith.addi %58, %c127_i32 : i32
                %60 = arith.shli %59, %c23_i32 : i32
                %61 = arith.bitcast %60 : i32 to f32
                %62 = arith.mulf %57, %61 : f32
                %63 = arith.addf %62, %cst_14 : f32
                %64 = arith.divf %results_29, %63 : f32
                %65 = arith.mulf %64, %results_31 : f32
                %async_token_32 = air.execute [%arg24] {
                  memref.store %65, %reinterpret_cast_24[%arg21, %arg23] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                }
                %66 = air.wait_all async [%async_token_28, %async_token_30, %async_token_32] 
                scf.yield %66 : !air.async.token
              }
              scf.yield %23 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_14[%arg15, %arg16] (%results[] [] []) {id = 30 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_25 = air.execute [%18] {
              memref.dealloc %results_22 : memref<128xf32, 2 : i32>
            }
            %async_token_26 = air.execute [%19] {
              memref.dealloc %results_20 : memref<128xf32, 2 : i32>
            }
            %async_token_27 = air.execute [%22] {
              memref.dealloc %results : memref<128xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 344 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    %5 = air.launch @orbit_launch_45752 async [%4] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg5, %arg13=%arg6, %arg14=%arg7) : memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32> attributes {id = 16 : i32} {
      %c344 = arith.constant 344 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.put async [%arg16]  @channel_15[%c0, %c0] (%arg12[4, %15] [1, 32] [11008, 1]) {id = 31 : i32, metadataArray = [{base = "air_channel_15", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.put async [%arg16]  @channel_16[%c0, %c0] (%arg13[4, %15] [1, 32] [11008, 1]) {id = 32 : i32, metadataArray = [{base = "air_channel_16", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c344 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_17[%c0, %c0] (%arg14[4, %15] [1, 32] [11008, 1]) {id = 33 : i32, metadataArray = [{base = "air_channel_17", index = 0 : i32}]} : (memref<5x11008xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment_45752 async  attributes {id = 17 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd_45752 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 18 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
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
          %c32_15 = arith.constant 32 : index
          %c1_16 = arith.constant 1 : index
          %c344_17 = arith.constant 344 : index
          %c0_18 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_18 to %c344_17 step %c1_16 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %async_token_19, %results_20 = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data.input.1.32.loops.1.32"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %async_token_21, %results_22 = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data.input.1.32.loops.1.32"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results_22 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 45752 : i64, orbit.storage = "G"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.channel.get async [%async_token_21, %arg20]  @channel_15[%arg15, %arg16] (%results_22[] [] []) {id = 34 : i32} : (memref<32xf32, 2 : i32>)
            %reinterpret_cast_23 = memref.reinterpret_cast %results_20 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 45752 : i64, orbit.storage = "U"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %19 = air.channel.get async [%async_token_19, %arg20]  @channel_16[%arg15, %arg16] (%results_20[] [] []) {id = 35 : i32} : (memref<32xf32, 2 : i32>)
            %reinterpret_cast_24 = memref.reinterpret_cast %results to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 45752 : i64, orbit.storage = "H"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            air.wait_all [%18, %19]  {orbit.computation_event = 136226 : i64, orbit.phase = 45752 : i64, orbit.phase_dependencies = array<i64: 45751>, orbit.read_copies = array<i64: 169312, 169313>, orbit.task = "swiglu", orbit.write_copies = array<i64: 169314>}
            %20 = air.wait_all async [%18, %19] 
            %21 = scf.for %arg21 = %c0_18 to %c32_15 step %c1_16 iter_args(%arg22 = %20) -> (!air.async.token) {
              %async_token_28, %results_29 = air.execute [%arg22] -> (f32) {
                %66 = memref.load %reinterpret_cast[%c0_18, %arg21] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %66 : f32
              }
              %async_token_30, %results_31 = air.execute [%arg22] -> (f32) {
                %66 = memref.load %reinterpret_cast_23[%c0_18, %arg21] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                air.execute_terminator %66 : f32
              }
              %23 = arith.negf %results_29 : f32
              %24 = arith.cmpf uge, %23, %cst_4 : f32
              %25 = arith.select %24, %23, %cst_4 : f32
              %26 = arith.cmpf ule, %25, %cst_3 : f32
              %27 = arith.select %26, %25, %cst_3 : f32
              %28 = arith.mulf %27, %cst_12 : f32
              %29 = arith.addf %28, %cst_13 : f32
              %30 = arith.fptosi %29 : f32 to i32
              %31 = arith.sitofp %30 : i32 to f32
              %32 = arith.cmpf olt, %29, %31 : f32
              %33 = arith.subf %31, %cst_14 : f32
              %34 = arith.select %32, %33, %31 : f32
              %35 = arith.cmpf uge, %34, %cst_2 : f32
              %36 = arith.select %35, %34, %cst_2 : f32
              %37 = arith.cmpf ule, %36, %cst : f32
              %38 = arith.select %37, %36, %cst : f32
              %39 = arith.mulf %38, %cst_11 : f32
              %40 = arith.addf %39, %27 : f32
              %41 = arith.mulf %38, %cst_10 : f32
              %42 = arith.addf %41, %40 : f32
              %43 = arith.mulf %42, %cst_9 : f32
              %44 = arith.addf %43, %cst_8 : f32
              %45 = arith.mulf %44, %42 : f32
              %46 = arith.addf %45, %cst_7 : f32
              %47 = arith.mulf %46, %42 : f32
              %48 = arith.addf %47, %cst_6 : f32
              %49 = arith.mulf %48, %42 : f32
              %50 = arith.addf %49, %cst_5 : f32
              %51 = arith.mulf %50, %42 : f32
              %52 = arith.addf %51, %cst_13 : f32
              %53 = arith.mulf %42, %42 : f32
              %54 = arith.mulf %52, %53 : f32
              %55 = arith.addf %54, %42 : f32
              %56 = arith.addf %55, %cst_14 : f32
              %57 = arith.fptosi %38 : f32 to i32
              %58 = arith.addi %57, %c127_i32 : i32
              %59 = arith.shli %58, %c23_i32 : i32
              %60 = arith.bitcast %59 : i32 to f32
              %61 = arith.mulf %56, %60 : f32
              %62 = arith.addf %61, %cst_14 : f32
              %63 = arith.divf %results_29, %62 : f32
              %64 = arith.mulf %63, %results_31 : f32
              %async_token_32 = air.execute [%arg22] {
                memref.store %64, %reinterpret_cast_24[%c0_18, %arg21] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              }
              %65 = air.wait_all async [%async_token_28, %async_token_30, %async_token_32] 
              scf.yield %65 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_17[%arg15, %arg16] (%results[] [] []) {id = 36 : i32} : (memref<32xf32, 2 : i32>)
            %async_token_25 = air.execute [%18] {
              memref.dealloc %results_22 : memref<32xf32, 2 : i32>
            }
            %async_token_26 = air.execute [%19] {
              memref.dealloc %results_20 : memref<32xf32, 2 : i32>
            }
            %async_token_27 = air.execute [%22] {
              memref.dealloc %results : memref<32xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 344 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    %6 = air.launch @orbit_launch_46224 async [%5] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg3, %arg13=%arg4, %arg14=%arg7) : memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32> attributes {id = 19 : i32} {
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c172 = arith.constant 172 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c64 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = scf.for %arg17 = %c0 to %c172 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %17 = arith.muli %arg17, %c64 : index
          %18 = air.channel.put async [%arg18]  @channel_18[%c0, %c0] (%arg12[%17, %15] [64, 32] [2048, 1]) {id = 37 : i32, metadataArray = [{base = "air_channel_18", index = 0 : i32}]} : (memref<11008x2048xf32>)
          scf.yield %18 : !air.async.token
        }
        scf.yield %16 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c64 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = scf.for %arg17 = %c0 to %c172 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %16 = arith.muli %arg17, %c64 : index
          %17 = air.channel.put async [%arg18]  @channel_19[%c0, %c0] (%arg14[0, %16] [4, 64] [11008, 1]) {id = 38 : i32, metadataArray = [{base = "air_channel_19", index = 0 : i32}]} : (memref<5x11008xf32>)
          scf.yield %17 : !air.async.token
        }
        scf.yield %15 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c64 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_20[%c0, %c0] (%arg13[0, %15] [4, 32] [2048, 1]) {id = 39 : i32, metadataArray = [{base = "air_channel_20", index = 0 : i32}]} : (memref<5x2048xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment_46224 async  attributes {id = 20 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd_46224 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 21 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c4 = arith.constant 4 : index
          %c172_2 = arith.constant 172 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c64_5 = arith.constant 64 : index
          %c0_6 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_6 to %c64_5 step %c1_4 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : memref<128xf32, 2 : i32>
              air.execute_terminator %alloc : memref<128xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [4, 32], strides: [32, 1] {orbit.initializer_task = "down.initialize", orbit.phase = 46224 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.wait_all async 
            %19 = scf.for %arg21 = %c0_6 to %c4 step %c1_4 iter_args(%arg22 = %18) -> (!air.async.token) {
              %23 = scf.for %arg23 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                %async_token_8 = air.execute [%arg24] {
                  memref.store %cst, %reinterpret_cast[%arg21, %arg23] : memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                }
                scf.yield %async_token_8 : !air.async.token
              }
              scf.yield %23 : !air.async.token
            }
            %20 = air.wait_all async [%arg20, %19] 
            %21 = scf.for %arg21 = %c0_6 to %c172_2 step %c1_4 iter_args(%arg22 = %20) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<256xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data.input.4.64.loops.4.32.64"} : memref<256xf32, 2 : i32>
                air.execute_terminator %alloc : memref<256xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<2048xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.64.32.loops.4.32.64"} : memref<2048xf32, 2 : i32>
                air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 46224 : i64, orbit.storage = "W_down"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %23 = air.channel.get async [%async_token_10, %arg22]  @channel_18[%arg15, %arg16] (%results_11[] [] []) {id = 40 : i32} : (memref<2048xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [4, 64], strides: [64, 1] {orbit.phase = 46224 : i64, orbit.storage = "H"} : memref<256xf32, 2 : i32> to memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %24 = air.channel.get async [%async_token_8, %arg22]  @channel_19[%arg15, %arg16] (%results_9[] [] []) {id = 41 : i32} : (memref<256xf32, 2 : i32>)
              air.wait_all [%23, %24]  {orbit.computation_event = 137603 : i64, orbit.phase = 46224 : i64, orbit.phase_dependencies = array<i64: 46223>, orbit.read_copies = array<i64: 170688, 170691, 170689, 170690>, orbit.task = "down", orbit.write_copies = array<i64: 170692>}
              %25 = air.wait_all async [%23, %24] 
              %26 = scf.for %arg23 = %c0_6 to %c4 step %c1_4 iter_args(%arg24 = %25) -> (!air.async.token) {
                %27 = scf.for %arg25 = %c0_6 to %c32_3 step %c8 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %28 = scf.for %arg27 = %c0_6 to %c64_5 step %c1_4 iter_args(%arg28 = %arg26) -> (!air.async.token) {
                    %async_token_16, %results_17 = air.execute [%arg28] -> (f32) {
                      %40 = memref.load %reinterpret_cast_13[%arg23, %arg27] : memref<4x64xf32, strided<[64, 1]>, 2 : i32>
                      air.execute_terminator %40 : f32
                    }
                    %async_token_18, %results_19 = air.execute [%arg28] -> (vector<8xf32>) {
                      %40 = vector.transfer_read %reinterpret_cast_12[%arg27, %arg25], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %40 : vector<8xf32>
                    }
                    %async_token_20, %results_21 = air.execute [%arg28] -> (vector<8xf32>) {
                      %40 = vector.transfer_read %reinterpret_cast[%arg23, %arg25], %cst : memref<4x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                      air.execute_terminator %40 : vector<8xf32>
                    }
                    %29 = vector.extract %results_19[0] : f32 from vector<8xf32>
                    %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %30 = vector.extract %results_19[1] : f32 from vector<8xf32>
                    %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %31 = vector.extract %results_19[2] : f32 from vector<8xf32>
                    %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %32 = vector.extract %results_19[3] : f32 from vector<8xf32>
                    %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %33 = vector.extract %results_19[4] : f32 from vector<8xf32>
                    %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %33) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %34 = vector.extract %results_19[5] : f32 from vector<8xf32>
                    %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %34) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %35 = vector.extract %results_19[6] : f32 from vector<8xf32>
                    %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %35) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %36 = vector.extract %results_19[7] : f32 from vector<8xf32>
                    %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                      %40 = func.call @__mulsf3(%results_17, %36) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                      air.execute_terminator %40 : f32
                    }
                    %37 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                    %38 = arith.addf %results_21, %37 : vector<8xf32>
                    %async_token_38 = air.execute [%async_token_20] {
                      vector.transfer_write %38, %reinterpret_cast[%arg23, %arg25] : vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>
                    }
                    %39 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                    scf.yield %39 : !air.async.token
                  }
                  scf.yield %28 : !air.async.token
                }
                scf.yield %27 : !air.async.token
              }
              %async_token_14 = air.execute [%23] {
                memref.dealloc %results_11 : memref<2048xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%24] {
                memref.dealloc %results_9 : memref<256xf32, 2 : i32>
              }
              scf.yield %26 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_20[%arg15, %arg16] (%results[] [] []) {id = 42 : i32} : (memref<128xf32, 2 : i32>)
            %async_token_7 = air.execute [%22] {
              memref.dealloc %results : memref<128xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 64 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    %7 = air.launch @orbit_launch_57232 async [%6] (%arg8, %arg9) in (%arg10=%c1, %arg11=%c1) args(%arg12=%arg3, %arg13=%arg4, %arg14=%arg7) : memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32> attributes {id = 22 : i32} {
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c172 = arith.constant 172 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %8 = air.wait_all async 
      %9 = scf.for %arg15 = %c0 to %c64 step %c1_0 iter_args(%arg16 = %8) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = scf.for %arg17 = %c0 to %c172 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %17 = arith.muli %arg17, %c64 : index
          %18 = air.channel.put async [%arg18]  @channel_21[%c0, %c0] (%arg12[%17, %15] [64, 32] [2048, 1]) {id = 43 : i32, metadataArray = [{base = "air_channel_21", index = 0 : i32}]} : (memref<11008x2048xf32>)
          scf.yield %18 : !air.async.token
        }
        scf.yield %16 : !air.async.token
      }
      %10 = air.wait_all async 
      %11 = scf.for %arg15 = %c0 to %c64 step %c1_0 iter_args(%arg16 = %10) -> (!air.async.token) {
        %15 = scf.for %arg17 = %c0 to %c172 step %c1_0 iter_args(%arg18 = %arg16) -> (!air.async.token) {
          %16 = arith.muli %arg17, %c64 : index
          %17 = air.channel.put async [%arg18]  @channel_22[%c0, %c0] (%arg14[4, %16] [1, 64] [11008, 1]) {id = 44 : i32, metadataArray = [{base = "air_channel_22", index = 0 : i32}]} : (memref<5x11008xf32>)
          scf.yield %17 : !air.async.token
        }
        scf.yield %15 : !air.async.token
      }
      %12 = air.wait_all async 
      %13 = scf.for %arg15 = %c0 to %c64 step %c1_0 iter_args(%arg16 = %12) -> (!air.async.token) {
        %15 = arith.muli %arg15, %c32 : index
        %16 = air.channel.get async [%arg16]  @channel_23[%c0, %c0] (%arg13[4, %15] [1, 32] [2048, 1]) {id = 45 : i32, metadataArray = [{base = "air_channel_23", index = 0 : i32}]} : (memref<5x2048xf32>)
        scf.yield %16 : !air.async.token
      }
      %14 = air.segment @orbit_segment_57232 async  attributes {id = 23 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c1_1 = arith.constant 1 : index
        %15 = air.herd @orbit_herd_57232 async  tile (%arg15, %arg16) in (%arg17=%c1_1, %arg18=%c1_1) attributes {id = 24 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c8 = arith.constant 8 : index
          %c172_2 = arith.constant 172 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c32_3 = arith.constant 32 : index
          %c1_4 = arith.constant 1 : index
          %c64_5 = arith.constant 64 : index
          %c0_6 = arith.constant 0 : index
          %16 = air.wait_all async 
          %17 = scf.for %arg19 = %c0_6 to %c64_5 step %c1_4 iter_args(%arg20 = %16) -> (!air.async.token) {
            %async_token, %results = air.execute -> (memref<32xf32, 2 : i32>) {
              %alloc = memref.alloc() {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : memref<32xf32, 2 : i32>
              air.execute_terminator %alloc : memref<32xf32, 2 : i32>
            }
            %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "down.initialize", orbit.phase = 57232 : i64, orbit.storage = "Y"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %18 = air.wait_all async 
            %19 = scf.for %arg21 = %c0_6 to %c32_3 step %c1_4 iter_args(%arg22 = %18) -> (!air.async.token) {
              %async_token_8 = air.execute [%arg22] {
                memref.store %cst, %reinterpret_cast[%c0_6, %arg21] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
              }
              scf.yield %async_token_8 : !air.async.token
            }
            %20 = air.wait_all async [%arg20, %19] 
            %21 = scf.for %arg21 = %c0_6 to %c172_2 step %c1_4 iter_args(%arg22 = %20) -> (!air.async.token) {
              %async_token_8, %results_9 = air.execute -> (memref<64xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data.input.1.64.loops.1.32.64"} : memref<64xf32, 2 : i32>
                air.execute_terminator %alloc : memref<64xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<2048xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.64.32.loops.1.32.64"} : memref<2048xf32, 2 : i32>
                air.execute_terminator %alloc : memref<2048xf32, 2 : i32>
              }
              %reinterpret_cast_12 = memref.reinterpret_cast %results_11 to offset: [0], sizes: [64, 32], strides: [32, 1] {orbit.phase = 57232 : i64, orbit.storage = "W_down"} : memref<2048xf32, 2 : i32> to memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %23 = air.channel.get async [%async_token_10, %arg22]  @channel_21[%arg15, %arg16] (%results_11[] [] []) {id = 46 : i32} : (memref<2048xf32, 2 : i32>)
              %reinterpret_cast_13 = memref.reinterpret_cast %results_9 to offset: [0], sizes: [1, 64], strides: [64, 1] {orbit.phase = 57232 : i64, orbit.storage = "H"} : memref<64xf32, 2 : i32> to memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %24 = air.channel.get async [%async_token_8, %arg22]  @channel_22[%arg15, %arg16] (%results_9[] [] []) {id = 47 : i32} : (memref<64xf32, 2 : i32>)
              air.wait_all [%23, %24]  {orbit.computation_event = 170755 : i64, orbit.phase = 57232 : i64, orbit.phase_dependencies = array<i64: 57231>, orbit.read_copies = array<i64: 214848, 214851, 214849, 214850>, orbit.task = "down", orbit.write_copies = array<i64: 214852>}
              %25 = air.wait_all async [%23, %24] 
              %26 = scf.for %arg23 = %c0_6 to %c32_3 step %c8 iter_args(%arg24 = %25) -> (!air.async.token) {
                %27 = scf.for %arg25 = %c0_6 to %c64_5 step %c1_4 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                  %async_token_16, %results_17 = air.execute [%arg26] -> (f32) {
                    %39 = memref.load %reinterpret_cast_13[%c0_6, %arg25] : memref<1x64xf32, strided<[64, 1]>, 2 : i32>
                    air.execute_terminator %39 : f32
                  }
                  %async_token_18, %results_19 = air.execute [%arg26] -> (vector<8xf32>) {
                    %39 = vector.transfer_read %reinterpret_cast_12[%arg25, %arg23], %cst : memref<64x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %39 : vector<8xf32>
                  }
                  %async_token_20, %results_21 = air.execute [%arg26] -> (vector<8xf32>) {
                    %39 = vector.transfer_read %reinterpret_cast[%c0_6, %arg23], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %39 : vector<8xf32>
                  }
                  %28 = vector.extract %results_19[0] : f32 from vector<8xf32>
                  %async_token_22, %results_23 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %28) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %29 = vector.extract %results_19[1] : f32 from vector<8xf32>
                  %async_token_24, %results_25 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %29) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %30 = vector.extract %results_19[2] : f32 from vector<8xf32>
                  %async_token_26, %results_27 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %30) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %31 = vector.extract %results_19[3] : f32 from vector<8xf32>
                  %async_token_28, %results_29 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %31) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %32 = vector.extract %results_19[4] : f32 from vector<8xf32>
                  %async_token_30, %results_31 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %32) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %33 = vector.extract %results_19[5] : f32 from vector<8xf32>
                  %async_token_32, %results_33 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %33) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %34 = vector.extract %results_19[6] : f32 from vector<8xf32>
                  %async_token_34, %results_35 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %34) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %35 = vector.extract %results_19[7] : f32 from vector<8xf32>
                  %async_token_36, %results_37 = air.execute [%async_token_16] -> (f32) {
                    %39 = func.call @__mulsf3(%results_17, %35) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %39 : f32
                  }
                  %36 = vector.from_elements %results_23, %results_25, %results_27, %results_29, %results_31, %results_33, %results_35, %results_37 : vector<8xf32>
                  %37 = arith.addf %results_21, %36 : vector<8xf32>
                  %async_token_38 = air.execute [%async_token_20] {
                    vector.transfer_write %37, %reinterpret_cast[%c0_6, %arg23] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
                  }
                  %38 = air.wait_all async [%async_token_18, %async_token_22, %async_token_24, %async_token_26, %async_token_28, %async_token_30, %async_token_32, %async_token_34, %async_token_36, %async_token_38] 
                  scf.yield %38 : !air.async.token
                }
                scf.yield %27 : !air.async.token
              }
              %async_token_14 = air.execute [%23] {
                memref.dealloc %results_11 : memref<2048xf32, 2 : i32>
              }
              %async_token_15 = air.execute [%24] {
                memref.dealloc %results_9 : memref<64xf32, 2 : i32>
              }
              scf.yield %26 : !air.async.token
            }
            %22 = air.channel.put async [%async_token, %21]  @channel_23[%arg15, %arg16] (%results[] [] []) {id = 48 : i32} : (memref<32xf32, 2 : i32>)
            %async_token_7 = air.execute [%22] {
              memref.dealloc %results : memref<32xf32, 2 : i32>
            }
            scf.yield %22 : !air.async.token
          } {orbit.compressed_phases = 64 : i64}
          air.wait_all [%17] 
        }
        air.wait_all [%15]  {air.segment_end}
      }
    }
    return
  }
}
