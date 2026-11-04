#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.async_herd_scope = "module", orbit.channel_conversion_scope = "module", orbit.channel_input_fingerprint = "54d2201698282640109a4cb4fac0ef7938a04d26a2a793baeb8c6fe0dd2909ea", orbit.channel_legalization = "checked-storage-compute-dma-ports-v1", orbit.channel_pre_merge_fingerprint = "b6cb2b3234e90287bb5a97086f8a103758104c70ce47b2809476e64c4ad136e7", orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.local_release_scope = "static-hardware-stage", orbit.mapping_plan = "b2fac988bd30bacd29b0bb139ebc7aec8ffeda478b40e1fcb3637512c890e51d", orbit.source_fingerprint = "912511a293a64cce8e0d6c281bea7fa9b2ada1f653348173aee833f4c600a053"} {
  aie.device(npu2) @orbit_segment_62 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf56 = aie.buffer(%tile_0_2) {sym_name = "buf56"} : memref<16xf32, 2 : i32> 
    %buf55 = aie.buffer(%tile_0_2) {sym_name = "buf55"} : memref<16xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x80xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf56 : memref<16xf32, 2 : i32> offset = 0 len = 16) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf55 : memref<16xf32, 2 : i32> offset = 0 len = 16) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 5.000000e-01 : f32
      %c64 = arith.constant 64 : index
      %c80 = arith.constant 80 : index
      %c8 = arith.constant 8 : index
      %cst_3 = arith.constant 0.000000e+00 : f32
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf56 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 62 : i64, orbit.storage = "Y"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      %reinterpret_cast_4 = memref.reinterpret_cast %buf55 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 62 : i64, orbit.storage = "intermediate"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c64 to %c80 step %c8 {
        %0 = arith.subi %arg0, %c64 : index
        %1 = vector.transfer_read %reinterpret_cast_4[%c0, %0], %cst_3 : memref<1x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
        %2 = vector.extract %1[0] : f32 from vector<8xf32>
        %3 = func.call @__mulsf3(%2, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %4 = vector.extract %1[1] : f32 from vector<8xf32>
        %5 = func.call @__mulsf3(%4, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %6 = vector.extract %1[2] : f32 from vector<8xf32>
        %7 = func.call @__mulsf3(%6, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %8 = vector.extract %1[3] : f32 from vector<8xf32>
        %9 = func.call @__mulsf3(%8, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %10 = vector.extract %1[4] : f32 from vector<8xf32>
        %11 = func.call @__mulsf3(%10, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %12 = vector.extract %1[5] : f32 from vector<8xf32>
        %13 = func.call @__mulsf3(%12, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %14 = vector.extract %1[6] : f32 from vector<8xf32>
        %15 = func.call @__mulsf3(%14, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %16 = vector.extract %1[7] : f32 from vector<8xf32>
        %17 = func.call @__mulsf3(%16, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %18 = vector.from_elements %3, %5, %7, %9, %11, %13, %15, %17 : vector<8xf32>
        vector.transfer_write %18, %reinterpret_cast[%c0, %0] : vector<8xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_62", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_56(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_55(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_62_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_56 {
        aie.dma_bd(%arg2 : memref<17x80xf32> offset = 1344 len = 16 sizes = [16] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_55 {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 1344 len = 16 sizes = [16] strides = [1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_60 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf54 = aie.buffer(%tile_0_2) {sym_name = "buf54"} : memref<32xf32, 2 : i32> 
    %buf53 = aie.buffer(%tile_0_2) {sym_name = "buf53"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x80xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf53 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf54 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 5.000000e-01 : f32
      %c8 = arith.constant 8 : index
      %cst_3 = arith.constant 0.000000e+00 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf53 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 60 : i64, orbit.storage = "Y"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        %reinterpret_cast_4 = memref.reinterpret_cast %buf54 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 60 : i64, orbit.storage = "intermediate"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c0 to %c32 step %c8 {
          %0 = vector.transfer_read %reinterpret_cast_4[%c0, %arg1], %cst_3 : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
          %1 = vector.extract %0[0] : f32 from vector<8xf32>
          %2 = func.call @__mulsf3(%1, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %3 = vector.extract %0[1] : f32 from vector<8xf32>
          %4 = func.call @__mulsf3(%3, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %5 = vector.extract %0[2] : f32 from vector<8xf32>
          %6 = func.call @__mulsf3(%5, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %7 = vector.extract %0[3] : f32 from vector<8xf32>
          %8 = func.call @__mulsf3(%7, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %9 = vector.extract %0[4] : f32 from vector<8xf32>
          %10 = func.call @__mulsf3(%9, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %11 = vector.extract %0[5] : f32 from vector<8xf32>
          %12 = func.call @__mulsf3(%11, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %13 = vector.extract %0[6] : f32 from vector<8xf32>
          %14 = func.call @__mulsf3(%13, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %15 = vector.extract %0[7] : f32 from vector<8xf32>
          %16 = func.call @__mulsf3(%15, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %17 = vector.from_elements %2, %4, %6, %8, %10, %12, %14, %16 : vector<8xf32>
          vector.transfer_write %17, %reinterpret_cast[%c0, %arg1] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_2, Release, %c1_i32)
        aie.use_lock(%lock_0_2, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_60", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_54(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_53(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_60_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_54 {
        aie.dma_bd(%arg2 : memref<17x80xf32> offset = 1280 len = 64 sizes = [64] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_53 {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 1280 len = 64 sizes = [64] strides = [1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_59 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf52 = aie.buffer(%tile_0_2) {sym_name = "buf52"} : memref<128xf32, 2 : i32> 
    %buf51 = aie.buffer(%tile_0_2) {sym_name = "buf51"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x80xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf52 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf51 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 5.000000e-01 : f32
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %c64 = arith.constant 64 : index
      %c80 = arith.constant 80 : index
      %cst_3 = arith.constant 0.000000e+00 : f32
      %c1 = arith.constant 1 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf52 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 59 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
      %reinterpret_cast_4 = memref.reinterpret_cast %buf51 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 59 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c8 to %c16 step %c1 {
        scf.for %arg1 = %c64 to %c80 step %c8 {
          %0 = arith.subi %arg0, %c8 : index
          %1 = arith.subi %arg1, %c64 : index
          %2 = vector.transfer_read %reinterpret_cast_4[%0, %1], %cst_3 : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
          %3 = vector.extract %2[0] : f32 from vector<8xf32>
          %4 = func.call @__mulsf3(%3, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %5 = vector.extract %2[1] : f32 from vector<8xf32>
          %6 = func.call @__mulsf3(%5, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %7 = vector.extract %2[2] : f32 from vector<8xf32>
          %8 = func.call @__mulsf3(%7, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %9 = vector.extract %2[3] : f32 from vector<8xf32>
          %10 = func.call @__mulsf3(%9, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %11 = vector.extract %2[4] : f32 from vector<8xf32>
          %12 = func.call @__mulsf3(%11, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %13 = vector.extract %2[5] : f32 from vector<8xf32>
          %14 = func.call @__mulsf3(%13, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %15 = vector.extract %2[6] : f32 from vector<8xf32>
          %16 = func.call @__mulsf3(%15, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %17 = vector.extract %2[7] : f32 from vector<8xf32>
          %18 = func.call @__mulsf3(%17, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %19 = vector.from_elements %4, %6, %8, %10, %12, %14, %16, %18 : vector<8xf32>
          vector.transfer_write %19, %reinterpret_cast[%0, %1] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_59", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_52(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_51(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_59_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_52 {
        aie.dma_bd(%arg2 : memref<17x80xf32> offset = 704 len = 128 sizes = [8, 16] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_51 {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 704 len = 128 sizes = [8, 16] strides = [80, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_57 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf50 = aie.buffer(%tile_0_2) {sym_name = "buf50"} : memref<256xf32, 2 : i32> 
    %buf49 = aie.buffer(%tile_0_2) {sym_name = "buf49"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x80xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf49 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf50 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 5.000000e-01 : f32
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %cst_3 = arith.constant 0.000000e+00 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf49 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 57 : i64, orbit.storage = "Y"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        %reinterpret_cast_4 = memref.reinterpret_cast %buf50 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 57 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c8 to %c16 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c8 {
            %0 = arith.subi %arg1, %c8 : index
            %1 = vector.transfer_read %reinterpret_cast_4[%0, %arg2], %cst_3 : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
            %2 = vector.extract %1[0] : f32 from vector<8xf32>
            %3 = func.call @__mulsf3(%2, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %4 = vector.extract %1[1] : f32 from vector<8xf32>
            %5 = func.call @__mulsf3(%4, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %6 = vector.extract %1[2] : f32 from vector<8xf32>
            %7 = func.call @__mulsf3(%6, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %8 = vector.extract %1[3] : f32 from vector<8xf32>
            %9 = func.call @__mulsf3(%8, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %10 = vector.extract %1[4] : f32 from vector<8xf32>
            %11 = func.call @__mulsf3(%10, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %12 = vector.extract %1[5] : f32 from vector<8xf32>
            %13 = func.call @__mulsf3(%12, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %14 = vector.extract %1[6] : f32 from vector<8xf32>
            %15 = func.call @__mulsf3(%14, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %16 = vector.extract %1[7] : f32 from vector<8xf32>
            %17 = func.call @__mulsf3(%16, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %18 = vector.from_elements %3, %5, %7, %9, %11, %13, %15, %17 : vector<8xf32>
            vector.transfer_write %18, %reinterpret_cast[%0, %arg2] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_2, Release, %c1_i32)
        aie.use_lock(%lock_0_2, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_57", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_50(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_49(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_57_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_50 {
        aie.dma_bd(%arg2 : memref<17x80xf32> offset = 640 len = 512 sizes = [2, 8, 32] strides = [32, 80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_49 {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 640 len = 512 sizes = [2, 8, 32] strides = [32, 80, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_56 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf48 = aie.buffer(%tile_0_2) {sym_name = "buf48"} : memref<128xf32, 2 : i32> 
    %buf47 = aie.buffer(%tile_0_2) {sym_name = "buf47"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x80xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf48 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf47 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 5.000000e-01 : f32
      %c8 = arith.constant 8 : index
      %c64 = arith.constant 64 : index
      %c80 = arith.constant 80 : index
      %cst_3 = arith.constant 0.000000e+00 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf48 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 56 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
      %reinterpret_cast_4 = memref.reinterpret_cast %buf47 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 56 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c64 to %c80 step %c8 {
          %0 = arith.subi %arg1, %c64 : index
          %1 = vector.transfer_read %reinterpret_cast_4[%arg0, %0], %cst_3 : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
          %2 = vector.extract %1[0] : f32 from vector<8xf32>
          %3 = func.call @__mulsf3(%2, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %4 = vector.extract %1[1] : f32 from vector<8xf32>
          %5 = func.call @__mulsf3(%4, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %6 = vector.extract %1[2] : f32 from vector<8xf32>
          %7 = func.call @__mulsf3(%6, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %8 = vector.extract %1[3] : f32 from vector<8xf32>
          %9 = func.call @__mulsf3(%8, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %10 = vector.extract %1[4] : f32 from vector<8xf32>
          %11 = func.call @__mulsf3(%10, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %12 = vector.extract %1[5] : f32 from vector<8xf32>
          %13 = func.call @__mulsf3(%12, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %14 = vector.extract %1[6] : f32 from vector<8xf32>
          %15 = func.call @__mulsf3(%14, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %16 = vector.extract %1[7] : f32 from vector<8xf32>
          %17 = func.call @__mulsf3(%16, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %18 = vector.from_elements %3, %5, %7, %9, %11, %13, %15, %17 : vector<8xf32>
          vector.transfer_write %18, %reinterpret_cast[%arg0, %0] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_56", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_48(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_47(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_56_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_48 {
        aie.dma_bd(%arg2 : memref<17x80xf32> offset = 64 len = 128 sizes = [8, 16] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_47 {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 64 len = 128 sizes = [8, 16] strides = [80, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_54 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf46 = aie.buffer(%tile_0_2) {sym_name = "buf46"} : memref<256xf32, 2 : i32> 
    %buf45 = aie.buffer(%tile_0_2) {sym_name = "buf45"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x80xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf45 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf46 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c2 = arith.constant 2 : index
      %c32 = arith.constant 32 : index
      %cst = arith.constant 5.000000e-01 : f32
      %c8 = arith.constant 8 : index
      %cst_3 = arith.constant 0.000000e+00 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      scf.for %arg0 = %c0 to %c2 step %c1 {
        aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast = memref.reinterpret_cast %buf45 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 54 : i64, orbit.storage = "Y"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        %reinterpret_cast_4 = memref.reinterpret_cast %buf46 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 54 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c8 {
            %0 = vector.transfer_read %reinterpret_cast_4[%arg1, %arg2], %cst_3 : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
            %1 = vector.extract %0[0] : f32 from vector<8xf32>
            %2 = func.call @__mulsf3(%1, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %3 = vector.extract %0[1] : f32 from vector<8xf32>
            %4 = func.call @__mulsf3(%3, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %5 = vector.extract %0[2] : f32 from vector<8xf32>
            %6 = func.call @__mulsf3(%5, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %7 = vector.extract %0[3] : f32 from vector<8xf32>
            %8 = func.call @__mulsf3(%7, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %9 = vector.extract %0[4] : f32 from vector<8xf32>
            %10 = func.call @__mulsf3(%9, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %11 = vector.extract %0[5] : f32 from vector<8xf32>
            %12 = func.call @__mulsf3(%11, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %13 = vector.extract %0[6] : f32 from vector<8xf32>
            %14 = func.call @__mulsf3(%13, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %15 = vector.extract %0[7] : f32 from vector<8xf32>
            %16 = func.call @__mulsf3(%15, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %17 = vector.from_elements %2, %4, %6, %8, %10, %12, %14, %16 : vector<8xf32>
            vector.transfer_write %17, %reinterpret_cast[%arg1, %arg2] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_2, Release, %c1_i32)
        aie.use_lock(%lock_0_2, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_54", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_46(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_45(%shim_noc_tile_0_0, MM2S, 0)
    aie.runtime_sequence @orbit_segment_54_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air_channel_46 {
        aie.dma_bd(%arg2 : memref<17x80xf32> offset = 0 len = 512 sizes = [2, 8, 32] strides = [32, 80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_45 {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 0 len = 512 sizes = [2, 8, 32] strides = [32, 80, 1])
        aie.end
      }
      aiex.dma_start_task(%1)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_49_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf44 = aie.buffer(%tile_0_2) {sym_name = "buf44"} : memref<1xf32, 2 : i32> 
    %buf43 = aie.buffer(%tile_0_2) {sym_name = "buf43"} : memref<16xf32, 2 : i32> 
    %buf42 = aie.buffer(%tile_0_2) {sym_name = "buf42"} : memref<16xf32, 2 : i32> 
    %buf41 = aie.buffer(%tile_0_2) {sym_name = "buf41"} : memref<512xf32, 2 : i32> 
    %buf40 = aie.buffer(%tile_0_2) {sym_name = "buf40"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf42 : memref<16xf32, 2 : i32> offset = 0 len = 16) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf40 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 16>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf44 : memref<1xf32, 2 : i32> offset = 0 len = 1) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 16>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf41 : memref<512xf32, 2 : i32> offset = 0 len = 512) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 17>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf43 : memref<16xf32, 2 : i32> offset = 0 len = 16) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 17>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(16) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(17) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage8_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage8_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage8_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_49 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf44 = aie.buffer(%tile_0_2) {sym_name = "buf44"} : memref<1xf32, 2 : i32> 
    %buf43 = aie.buffer(%tile_0_2) {sym_name = "buf43"} : memref<16xf32, 2 : i32> 
    %buf42 = aie.buffer(%tile_0_2) {sym_name = "buf42"} : memref<16xf32, 2 : i32> 
    %buf41 = aie.buffer(%tile_0_2) {sym_name = "buf41"} : memref<512xf32, 2 : i32> 
    %buf40 = aie.buffer(%tile_0_2) {sym_name = "buf40"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf42 : memref<16xf32, 2 : i32> offset = 0 len = 16) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf40 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 16>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf44 : memref<1xf32, 2 : i32> offset = 0 len = 1) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 16>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf41 : memref<512xf32, 2 : i32> offset = 0 len = 512) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 17>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf43 : memref<16xf32, 2 : i32> offset = 0 len = 16) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 17>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c64 = arith.constant 64 : index
      %c80 = arith.constant 80 : index
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf42 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 49 : i64, orbit.storage = "intermediate"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      scf.for %arg0 = %c64 to %c80 step %c1 {
        %0 = arith.subi %arg0, %c64 : index
        memref.store %cst, %reinterpret_cast[%c0, %0] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf40 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 49 : i64, orbit.storage = "A"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf41 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 49 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c64 to %c80 step %c8 {
          scf.for %arg2 = %c0 to %c32 step %c1 {
            %0 = memref.load %reinterpret_cast_11[%c0, %arg2] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %1 = arith.subi %arg1, %c64 : index
            %2 = vector.transfer_read %reinterpret_cast_12[%arg2, %1], %cst : memref<32x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
            %3 = vector.transfer_read %reinterpret_cast[%c0, %1], %cst : memref<1x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
            %4 = vector.extract %2[0] : f32 from vector<8xf32>
            %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %6 = vector.extract %2[1] : f32 from vector<8xf32>
            %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %8 = vector.extract %2[2] : f32 from vector<8xf32>
            %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %10 = vector.extract %2[3] : f32 from vector<8xf32>
            %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %12 = vector.extract %2[4] : f32 from vector<8xf32>
            %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %14 = vector.extract %2[5] : f32 from vector<8xf32>
            %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %16 = vector.extract %2[6] : f32 from vector<8xf32>
            %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %18 = vector.extract %2[7] : f32 from vector<8xf32>
            %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
            %21 = arith.addf %3, %20 : vector<8xf32>
            vector.transfer_write %21, %reinterpret_cast[%c0, %1] : vector<8xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf44 to offset: [0], sizes: [1, 1], strides: [1, 1] {orbit.phase = 53 : i64, orbit.storage = "A"} : memref<1xf32, 2 : i32> to memref<1x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf43 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 53 : i64, orbit.storage = "B"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c64 to %c80 step %c8 {
        %0 = memref.load %reinterpret_cast_9[%c0, %c0] : memref<1x1xf32, strided<[1, 1]>, 2 : i32>
        %1 = arith.subi %arg0, %c64 : index
        %2 = vector.transfer_read %reinterpret_cast_10[%c0, %1], %cst : memref<1x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
        %3 = vector.transfer_read %reinterpret_cast[%c0, %1], %cst : memref<1x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
        %4 = vector.extract %2[0] : f32 from vector<8xf32>
        %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %6 = vector.extract %2[1] : f32 from vector<8xf32>
        %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %8 = vector.extract %2[2] : f32 from vector<8xf32>
        %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %10 = vector.extract %2[3] : f32 from vector<8xf32>
        %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %12 = vector.extract %2[4] : f32 from vector<8xf32>
        %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %14 = vector.extract %2[5] : f32 from vector<8xf32>
        %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %16 = vector.extract %2[6] : f32 from vector<8xf32>
        %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %18 = vector.extract %2[7] : f32 from vector<8xf32>
        %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
        %21 = arith.addf %3, %20 : vector<8xf32>
        vector.transfer_write %21, %reinterpret_cast[%c0, %1] : vector<8xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_49", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(16) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(17) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage8_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage8_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage8_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_49_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage8_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 1344 len = 16 sizes = [16] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage8_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 2064 len = 128 sizes = [128] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 16>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage8_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 2192 len = 1 sizes = [1] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 16>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage8_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 64 len = 2048 sizes = [128, 16] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 17>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage8_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10304 len = 16 sizes = [16] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 17>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_49_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_44_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf39 = aie.buffer(%tile_0_2) {sym_name = "buf39"} : memref<1xf32, 2 : i32> 
    %buf38 = aie.buffer(%tile_0_2) {sym_name = "buf38"} : memref<32xf32, 2 : i32> 
    %buf37 = aie.buffer(%tile_0_2) {sym_name = "buf37"} : memref<32xf32, 2 : i32> 
    %buf36 = aie.buffer(%tile_0_2) {sym_name = "buf36"} : memref<1024xf32, 2 : i32> 
    %buf35 = aie.buffer(%tile_0_2) {sym_name = "buf35"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf37 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf35 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 14>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf39 : memref<1xf32, 2 : i32> offset = 0 len = 1) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 14>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf36 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 15>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf38 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 15>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(14) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(15) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage7_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage7_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage7_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_44 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf39 = aie.buffer(%tile_0_2) {sym_name = "buf39"} : memref<1xf32, 2 : i32> 
    %buf38 = aie.buffer(%tile_0_2) {sym_name = "buf38"} : memref<32xf32, 2 : i32> 
    %buf37 = aie.buffer(%tile_0_2) {sym_name = "buf37"} : memref<32xf32, 2 : i32> 
    %buf36 = aie.buffer(%tile_0_2) {sym_name = "buf36"} : memref<1024xf32, 2 : i32> 
    %buf35 = aie.buffer(%tile_0_2) {sym_name = "buf35"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf37 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf35 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 14>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf39 : memref<1xf32, 2 : i32> offset = 0 len = 1) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 14>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf36 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 15>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf38 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 15>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf37 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 44 : i64, orbit.storage = "intermediate"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      scf.for %arg0 = %c32 to %c64 step %c1 {
        %0 = arith.subi %arg0, %c32 : index
        memref.store %cst, %reinterpret_cast[%c0, %0] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf35 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 44 : i64, orbit.storage = "A"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf36 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 44 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c32 to %c64 step %c8 {
          scf.for %arg2 = %c0 to %c32 step %c1 {
            %0 = memref.load %reinterpret_cast_11[%c0, %arg2] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %1 = arith.subi %arg1, %c32 : index
            %2 = vector.transfer_read %reinterpret_cast_12[%arg2, %1], %cst : memref<32x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
            %3 = vector.transfer_read %reinterpret_cast[%c0, %1], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
            %4 = vector.extract %2[0] : f32 from vector<8xf32>
            %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %6 = vector.extract %2[1] : f32 from vector<8xf32>
            %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %8 = vector.extract %2[2] : f32 from vector<8xf32>
            %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %10 = vector.extract %2[3] : f32 from vector<8xf32>
            %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %12 = vector.extract %2[4] : f32 from vector<8xf32>
            %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %14 = vector.extract %2[5] : f32 from vector<8xf32>
            %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %16 = vector.extract %2[6] : f32 from vector<8xf32>
            %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %18 = vector.extract %2[7] : f32 from vector<8xf32>
            %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
            %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
            %21 = arith.addf %3, %20 : vector<8xf32>
            vector.transfer_write %21, %reinterpret_cast[%c0, %1] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf39 to offset: [0], sizes: [1, 1], strides: [1, 1] {orbit.phase = 48 : i64, orbit.storage = "A"} : memref<1xf32, 2 : i32> to memref<1x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf38 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 48 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c32 to %c64 step %c8 {
        %0 = memref.load %reinterpret_cast_9[%c0, %c0] : memref<1x1xf32, strided<[1, 1]>, 2 : i32>
        %1 = arith.subi %arg0, %c32 : index
        %2 = vector.transfer_read %reinterpret_cast_10[%c0, %1], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
        %3 = vector.transfer_read %reinterpret_cast[%c0, %1], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
        %4 = vector.extract %2[0] : f32 from vector<8xf32>
        %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %6 = vector.extract %2[1] : f32 from vector<8xf32>
        %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %8 = vector.extract %2[2] : f32 from vector<8xf32>
        %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %10 = vector.extract %2[3] : f32 from vector<8xf32>
        %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %12 = vector.extract %2[4] : f32 from vector<8xf32>
        %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %14 = vector.extract %2[5] : f32 from vector<8xf32>
        %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %16 = vector.extract %2[6] : f32 from vector<8xf32>
        %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %18 = vector.extract %2[7] : f32 from vector<8xf32>
        %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
        %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
        %21 = arith.addf %3, %20 : vector<8xf32>
        vector.transfer_write %21, %reinterpret_cast[%c0, %1] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_44", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(14) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(15) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage7_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage7_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage7_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_44_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage7_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 1312 len = 32 sizes = [32] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage7_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 2064 len = 128 sizes = [128] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 14>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage7_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 2192 len = 1 sizes = [1] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 14>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage7_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 32 len = 4096 sizes = [128, 32] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 15>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage7_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10272 len = 32 sizes = [32] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 15>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_44_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_39_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf34 = aie.buffer(%tile_0_2) {sym_name = "buf34"} : memref<1xf32, 2 : i32> 
    %buf33 = aie.buffer(%tile_0_2) {sym_name = "buf33"} : memref<32xf32, 2 : i32> 
    %buf32 = aie.buffer(%tile_0_2) {sym_name = "buf32"} : memref<32xf32, 2 : i32> 
    %buf31 = aie.buffer(%tile_0_2) {sym_name = "buf31"} : memref<1024xf32, 2 : i32> 
    %buf30 = aie.buffer(%tile_0_2) {sym_name = "buf30"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf32 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf30 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 12>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf34 : memref<1xf32, 2 : i32> offset = 0 len = 1) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 12>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf31 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 13>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf33 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 13>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(12) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(13) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage6_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage6_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage6_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_39 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf34 = aie.buffer(%tile_0_2) {sym_name = "buf34"} : memref<1xf32, 2 : i32> 
    %buf33 = aie.buffer(%tile_0_2) {sym_name = "buf33"} : memref<32xf32, 2 : i32> 
    %buf32 = aie.buffer(%tile_0_2) {sym_name = "buf32"} : memref<32xf32, 2 : i32> 
    %buf31 = aie.buffer(%tile_0_2) {sym_name = "buf31"} : memref<1024xf32, 2 : i32> 
    %buf30 = aie.buffer(%tile_0_2) {sym_name = "buf30"} : memref<32xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf32 : memref<32xf32, 2 : i32> offset = 0 len = 32) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf30 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 12>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf34 : memref<1xf32, 2 : i32> offset = 0 len = 1) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 12>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf31 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 13>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf33 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 13>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf32 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 39 : i64, orbit.storage = "intermediate"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      scf.for %arg0 = %c0 to %c32 step %c1 {
        memref.store %cst, %reinterpret_cast[%c0, %arg0] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf30 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 39 : i64, orbit.storage = "A"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf31 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 39 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c0 to %c32 step %c8 {
          scf.for %arg2 = %c0 to %c32 step %c1 {
            %0 = memref.load %reinterpret_cast_11[%c0, %arg2] : memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %1 = vector.transfer_read %reinterpret_cast_12[%arg2, %arg1], %cst : memref<32x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
            %2 = vector.transfer_read %reinterpret_cast[%c0, %arg1], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
            vector.transfer_write %20, %reinterpret_cast[%c0, %arg1] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf34 to offset: [0], sizes: [1, 1], strides: [1, 1] {orbit.phase = 43 : i64, orbit.storage = "A"} : memref<1xf32, 2 : i32> to memref<1x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf33 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 43 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c32 step %c8 {
        %0 = memref.load %reinterpret_cast_9[%c0, %c0] : memref<1x1xf32, strided<[1, 1]>, 2 : i32>
        %1 = vector.transfer_read %reinterpret_cast_10[%c0, %arg0], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
        %2 = vector.transfer_read %reinterpret_cast[%c0, %arg0], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
        vector.transfer_write %20, %reinterpret_cast[%c0, %arg0] : vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_39", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(12) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(13) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage6_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage6_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage6_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_39_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage6_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 1280 len = 32 sizes = [32] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage6_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 2064 len = 128 sizes = [128] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 12>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage6_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 2192 len = 1 sizes = [1] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 12>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage6_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 0 len = 4096 sizes = [128, 32] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 13>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage6_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10240 len = 32 sizes = [32] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 13>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_39_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_34_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf29 = aie.buffer(%tile_0_2) {sym_name = "buf29"} : memref<8xf32, 2 : i32> 
    %buf28 = aie.buffer(%tile_0_2) {sym_name = "buf28"} : memref<16xf32, 2 : i32> 
    %buf27 = aie.buffer(%tile_0_2) {sym_name = "buf27"} : memref<128xf32, 2 : i32> 
    %buf26 = aie.buffer(%tile_0_2) {sym_name = "buf26"} : memref<512xf32, 2 : i32> 
    %buf25 = aie.buffer(%tile_0_2) {sym_name = "buf25"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf27 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf25 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 10>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf29 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 10>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf26 : memref<512xf32, 2 : i32> offset = 0 len = 512) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 11>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf28 : memref<16xf32, 2 : i32> offset = 0 len = 16) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 11>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(10) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(11) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage5_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage5_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage5_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_34 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf29 = aie.buffer(%tile_0_2) {sym_name = "buf29"} : memref<8xf32, 2 : i32> 
    %buf28 = aie.buffer(%tile_0_2) {sym_name = "buf28"} : memref<16xf32, 2 : i32> 
    %buf27 = aie.buffer(%tile_0_2) {sym_name = "buf27"} : memref<128xf32, 2 : i32> 
    %buf26 = aie.buffer(%tile_0_2) {sym_name = "buf26"} : memref<512xf32, 2 : i32> 
    %buf25 = aie.buffer(%tile_0_2) {sym_name = "buf25"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf27 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf25 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 10>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf29 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 10>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf26 : memref<512xf32, 2 : i32> offset = 0 len = 512) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 11>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf28 : memref<16xf32, 2 : i32> offset = 0 len = 16) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 11>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %c64 = arith.constant 64 : index
      %c80 = arith.constant 80 : index
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf27 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 34 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
      scf.for %arg0 = %c8 to %c16 step %c1 {
        scf.for %arg1 = %c64 to %c80 step %c1 {
          %0 = arith.subi %arg0, %c8 : index
          %1 = arith.subi %arg1, %c64 : index
          memref.store %cst, %reinterpret_cast[%0, %1] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf25 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 34 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf26 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 34 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c8 to %c16 step %c1 {
          scf.for %arg2 = %c64 to %c80 step %c8 {
            scf.for %arg3 = %c0 to %c32 step %c1 {
              %0 = arith.subi %arg1, %c8 : index
              %1 = memref.load %reinterpret_cast_11[%0, %arg3] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %2 = arith.subi %arg2, %c64 : index
              %3 = vector.transfer_read %reinterpret_cast_12[%arg3, %2], %cst : memref<32x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
              %4 = vector.transfer_read %reinterpret_cast[%0, %2], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %22, %reinterpret_cast[%0, %2] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf29 to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 38 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf28 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 38 : i64, orbit.storage = "B"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c8 to %c16 step %c1 {
        scf.for %arg1 = %c64 to %c80 step %c8 {
          %0 = arith.subi %arg0, %c8 : index
          %1 = memref.load %reinterpret_cast_9[%0, %c0] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %2 = arith.subi %arg1, %c64 : index
          %3 = vector.transfer_read %reinterpret_cast_10[%c0, %2], %cst : memref<1x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
          %4 = vector.transfer_read %reinterpret_cast[%0, %2], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
          vector.transfer_write %22, %reinterpret_cast[%0, %2] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_34", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(10) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(11) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage5_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage5_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage5_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_34_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage5_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 704 len = 128 sizes = [8, 16] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage5_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 1032 len = 1024 sizes = [4, 8, 32] strides = [32, 129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 10>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage5_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 1160 len = 8 sizes = [8, 1] strides = [129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 10>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage5_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 64 len = 2048 sizes = [128, 16] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 11>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage5_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10304 len = 16 sizes = [16] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 11>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_34_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_29_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf24 = aie.buffer(%tile_0_2) {sym_name = "buf24"} : memref<8xf32, 2 : i32> 
    %buf23 = aie.buffer(%tile_0_2) {sym_name = "buf23"} : memref<32xf32, 2 : i32> 
    %buf22 = aie.buffer(%tile_0_2) {sym_name = "buf22"} : memref<256xf32, 2 : i32> 
    %buf21 = aie.buffer(%tile_0_2) {sym_name = "buf21"} : memref<1024xf32, 2 : i32> 
    %buf20 = aie.buffer(%tile_0_2) {sym_name = "buf20"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf22 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf20 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 8>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf24 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 8>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf21 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 9>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf23 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 9>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(8) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(9) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage4_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage4_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage4_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_29 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf24 = aie.buffer(%tile_0_2) {sym_name = "buf24"} : memref<8xf32, 2 : i32> 
    %buf23 = aie.buffer(%tile_0_2) {sym_name = "buf23"} : memref<32xf32, 2 : i32> 
    %buf22 = aie.buffer(%tile_0_2) {sym_name = "buf22"} : memref<256xf32, 2 : i32> 
    %buf21 = aie.buffer(%tile_0_2) {sym_name = "buf21"} : memref<1024xf32, 2 : i32> 
    %buf20 = aie.buffer(%tile_0_2) {sym_name = "buf20"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf22 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf20 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 8>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf24 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 8>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf21 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 9>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf23 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 9>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c4 = arith.constant 4 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf22 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 29 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
      scf.for %arg0 = %c8 to %c16 step %c1 {
        scf.for %arg1 = %c32 to %c64 step %c1 {
          %0 = arith.subi %arg0, %c8 : index
          %1 = arith.subi %arg1, %c32 : index
          memref.store %cst, %reinterpret_cast[%0, %1] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf20 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 29 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf21 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 29 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c8 to %c16 step %c1 {
          scf.for %arg2 = %c32 to %c64 step %c8 {
            scf.for %arg3 = %c0 to %c32 step %c1 {
              %0 = arith.subi %arg1, %c8 : index
              %1 = memref.load %reinterpret_cast_11[%0, %arg3] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %2 = arith.subi %arg2, %c32 : index
              %3 = vector.transfer_read %reinterpret_cast_12[%arg3, %2], %cst : memref<32x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %4 = vector.transfer_read %reinterpret_cast[%0, %2], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %22, %reinterpret_cast[%0, %2] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf24 to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 33 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf23 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 33 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c8 to %c16 step %c1 {
        scf.for %arg1 = %c32 to %c64 step %c8 {
          %0 = arith.subi %arg0, %c8 : index
          %1 = memref.load %reinterpret_cast_9[%0, %c0] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %2 = arith.subi %arg1, %c32 : index
          %3 = vector.transfer_read %reinterpret_cast_10[%c0, %2], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
          %4 = vector.transfer_read %reinterpret_cast[%0, %2], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
          vector.transfer_write %22, %reinterpret_cast[%0, %2] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_29", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(8) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(9) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage4_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage4_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage4_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_29_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage4_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 672 len = 256 sizes = [8, 32] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage4_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 1032 len = 1024 sizes = [4, 8, 32] strides = [32, 129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 8>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage4_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 1160 len = 8 sizes = [8, 1] strides = [129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 8>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage4_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 32 len = 4096 sizes = [128, 32] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 9>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage4_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10272 len = 32 sizes = [32] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 9>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_29_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_24_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf19 = aie.buffer(%tile_0_2) {sym_name = "buf19"} : memref<8xf32, 2 : i32> 
    %buf18 = aie.buffer(%tile_0_2) {sym_name = "buf18"} : memref<32xf32, 2 : i32> 
    %buf17 = aie.buffer(%tile_0_2) {sym_name = "buf17"} : memref<256xf32, 2 : i32> 
    %buf16 = aie.buffer(%tile_0_2) {sym_name = "buf16"} : memref<1024xf32, 2 : i32> 
    %buf15 = aie.buffer(%tile_0_2) {sym_name = "buf15"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf17 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf15 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 6>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf19 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 6>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf16 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 7>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf18 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 7>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(6) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(7) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage3_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage3_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage3_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_24 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf19 = aie.buffer(%tile_0_2) {sym_name = "buf19"} : memref<8xf32, 2 : i32> 
    %buf18 = aie.buffer(%tile_0_2) {sym_name = "buf18"} : memref<32xf32, 2 : i32> 
    %buf17 = aie.buffer(%tile_0_2) {sym_name = "buf17"} : memref<256xf32, 2 : i32> 
    %buf16 = aie.buffer(%tile_0_2) {sym_name = "buf16"} : memref<1024xf32, 2 : i32> 
    %buf15 = aie.buffer(%tile_0_2) {sym_name = "buf15"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf17 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf15 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 6>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf19 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 6>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf16 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 7>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf18 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 7>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf17 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 24 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
      scf.for %arg0 = %c8 to %c16 step %c1 {
        scf.for %arg1 = %c0 to %c32 step %c1 {
          %0 = arith.subi %arg0, %c8 : index
          memref.store %cst, %reinterpret_cast[%0, %arg1] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf15 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 24 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf16 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 24 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c8 to %c16 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c8 {
            scf.for %arg3 = %c0 to %c32 step %c1 {
              %0 = arith.subi %arg1, %c8 : index
              %1 = memref.load %reinterpret_cast_11[%0, %arg3] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %2 = vector.transfer_read %reinterpret_cast_12[%arg3, %arg2], %cst : memref<32x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %3 = vector.transfer_read %reinterpret_cast[%0, %arg2], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %21, %reinterpret_cast[%0, %arg2] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf19 to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 28 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf18 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 28 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c8 to %c16 step %c1 {
        scf.for %arg1 = %c0 to %c32 step %c8 {
          %0 = arith.subi %arg0, %c8 : index
          %1 = memref.load %reinterpret_cast_9[%0, %c0] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %2 = vector.transfer_read %reinterpret_cast_10[%c0, %arg1], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
          %3 = vector.transfer_read %reinterpret_cast[%0, %arg1], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
          vector.transfer_write %21, %reinterpret_cast[%0, %arg1] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_24", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(6) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(7) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage3_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage3_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage3_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_24_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage3_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 640 len = 256 sizes = [8, 32] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage3_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 1032 len = 1024 sizes = [4, 8, 32] strides = [32, 129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 6>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage3_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 1160 len = 8 sizes = [8, 1] strides = [129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 6>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage3_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 0 len = 4096 sizes = [128, 32] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 7>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage3_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10240 len = 32 sizes = [32] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 7>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_24_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_19_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf14 = aie.buffer(%tile_0_2) {sym_name = "buf14"} : memref<8xf32, 2 : i32> 
    %buf13 = aie.buffer(%tile_0_2) {sym_name = "buf13"} : memref<16xf32, 2 : i32> 
    %buf12 = aie.buffer(%tile_0_2) {sym_name = "buf12"} : memref<128xf32, 2 : i32> 
    %buf11 = aie.buffer(%tile_0_2) {sym_name = "buf11"} : memref<512xf32, 2 : i32> 
    %buf10 = aie.buffer(%tile_0_2) {sym_name = "buf10"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf12 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf10 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 4>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf14 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 4>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf11 : memref<512xf32, 2 : i32> offset = 0 len = 512) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 5>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf13 : memref<16xf32, 2 : i32> offset = 0 len = 16) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 5>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(4) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(5) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage2_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage2_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage2_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_19 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf14 = aie.buffer(%tile_0_2) {sym_name = "buf14"} : memref<8xf32, 2 : i32> 
    %buf13 = aie.buffer(%tile_0_2) {sym_name = "buf13"} : memref<16xf32, 2 : i32> 
    %buf12 = aie.buffer(%tile_0_2) {sym_name = "buf12"} : memref<128xf32, 2 : i32> 
    %buf11 = aie.buffer(%tile_0_2) {sym_name = "buf11"} : memref<512xf32, 2 : i32> 
    %buf10 = aie.buffer(%tile_0_2) {sym_name = "buf10"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf12 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf10 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 4>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf14 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 4>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf11 : memref<512xf32, 2 : i32> offset = 0 len = 512) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 5>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf13 : memref<16xf32, 2 : i32> offset = 0 len = 16) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 5>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c8 = arith.constant 8 : index
      %c64 = arith.constant 64 : index
      %c80 = arith.constant 80 : index
      %c4 = arith.constant 4 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf12 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 19 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c64 to %c80 step %c1 {
          %0 = arith.subi %arg1, %c64 : index
          memref.store %cst, %reinterpret_cast[%arg0, %0] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf10 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 19 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf11 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 19 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c64 to %c80 step %c8 {
            scf.for %arg3 = %c0 to %c32 step %c1 {
              %0 = memref.load %reinterpret_cast_11[%arg1, %arg3] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %1 = arith.subi %arg2, %c64 : index
              %2 = vector.transfer_read %reinterpret_cast_12[%arg3, %1], %cst : memref<32x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
              %3 = vector.transfer_read %reinterpret_cast[%arg1, %1], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
              %4 = vector.extract %2[0] : f32 from vector<8xf32>
              %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %6 = vector.extract %2[1] : f32 from vector<8xf32>
              %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %8 = vector.extract %2[2] : f32 from vector<8xf32>
              %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %10 = vector.extract %2[3] : f32 from vector<8xf32>
              %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %12 = vector.extract %2[4] : f32 from vector<8xf32>
              %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %14 = vector.extract %2[5] : f32 from vector<8xf32>
              %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %16 = vector.extract %2[6] : f32 from vector<8xf32>
              %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %18 = vector.extract %2[7] : f32 from vector<8xf32>
              %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
              %21 = arith.addf %3, %20 : vector<8xf32>
              vector.transfer_write %21, %reinterpret_cast[%arg1, %1] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf14 to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 23 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf13 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.phase = 23 : i64, orbit.storage = "B"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c64 to %c80 step %c8 {
          %0 = memref.load %reinterpret_cast_9[%arg0, %c0] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %1 = arith.subi %arg1, %c64 : index
          %2 = vector.transfer_read %reinterpret_cast_10[%c0, %1], %cst : memref<1x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
          %3 = vector.transfer_read %reinterpret_cast[%arg0, %1], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
          %4 = vector.extract %2[0] : f32 from vector<8xf32>
          %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %6 = vector.extract %2[1] : f32 from vector<8xf32>
          %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %8 = vector.extract %2[2] : f32 from vector<8xf32>
          %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %10 = vector.extract %2[3] : f32 from vector<8xf32>
          %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %12 = vector.extract %2[4] : f32 from vector<8xf32>
          %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %14 = vector.extract %2[5] : f32 from vector<8xf32>
          %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %16 = vector.extract %2[6] : f32 from vector<8xf32>
          %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %18 = vector.extract %2[7] : f32 from vector<8xf32>
          %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
          %21 = arith.addf %3, %20 : vector<8xf32>
          vector.transfer_write %21, %reinterpret_cast[%arg0, %1] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_19", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(4) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(5) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage2_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage2_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage2_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_19_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage2_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 64 len = 128 sizes = [8, 16] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage2_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 0 len = 1024 sizes = [4, 8, 32] strides = [32, 129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 4>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage2_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 128 len = 8 sizes = [8, 1] strides = [129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 4>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage2_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 64 len = 2048 sizes = [128, 16] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 5>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage2_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10304 len = 16 sizes = [16] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 5>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_19_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_14_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf9 = aie.buffer(%tile_0_2) {sym_name = "buf9"} : memref<8xf32, 2 : i32> 
    %buf8 = aie.buffer(%tile_0_2) {sym_name = "buf8"} : memref<32xf32, 2 : i32> 
    %buf7 = aie.buffer(%tile_0_2) {sym_name = "buf7"} : memref<256xf32, 2 : i32> 
    %buf6 = aie.buffer(%tile_0_2) {sym_name = "buf6"} : memref<1024xf32, 2 : i32> 
    %buf5 = aie.buffer(%tile_0_2) {sym_name = "buf5"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf7 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf5 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 2>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf9 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 2>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf6 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 3>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf8 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 3>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(2) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(3) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage1_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage1_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage1_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_14 {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf9 = aie.buffer(%tile_0_2) {sym_name = "buf9"} : memref<8xf32, 2 : i32> 
    %buf8 = aie.buffer(%tile_0_2) {sym_name = "buf8"} : memref<32xf32, 2 : i32> 
    %buf7 = aie.buffer(%tile_0_2) {sym_name = "buf7"} : memref<256xf32, 2 : i32> 
    %buf6 = aie.buffer(%tile_0_2) {sym_name = "buf6"} : memref<1024xf32, 2 : i32> 
    %buf5 = aie.buffer(%tile_0_2) {sym_name = "buf5"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf7 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf5 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 2>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf9 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 2>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf6 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 3>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf8 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 3>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c64 = arith.constant 64 : index
      %c4 = arith.constant 4 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf7 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 14 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c32 to %c64 step %c1 {
          %0 = arith.subi %arg1, %c32 : index
          memref.store %cst, %reinterpret_cast[%arg0, %0] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf5 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 14 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf6 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 14 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c32 to %c64 step %c8 {
            scf.for %arg3 = %c0 to %c32 step %c1 {
              %0 = memref.load %reinterpret_cast_11[%arg1, %arg3] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %1 = arith.subi %arg2, %c32 : index
              %2 = vector.transfer_read %reinterpret_cast_12[%arg3, %1], %cst : memref<32x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %3 = vector.transfer_read %reinterpret_cast[%arg1, %1], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %4 = vector.extract %2[0] : f32 from vector<8xf32>
              %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %6 = vector.extract %2[1] : f32 from vector<8xf32>
              %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %8 = vector.extract %2[2] : f32 from vector<8xf32>
              %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %10 = vector.extract %2[3] : f32 from vector<8xf32>
              %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %12 = vector.extract %2[4] : f32 from vector<8xf32>
              %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %14 = vector.extract %2[5] : f32 from vector<8xf32>
              %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %16 = vector.extract %2[6] : f32 from vector<8xf32>
              %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %18 = vector.extract %2[7] : f32 from vector<8xf32>
              %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
              %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
              %21 = arith.addf %3, %20 : vector<8xf32>
              vector.transfer_write %21, %reinterpret_cast[%arg1, %1] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf9 to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 18 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf8 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 18 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c32 to %c64 step %c8 {
          %0 = memref.load %reinterpret_cast_9[%arg0, %c0] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %1 = arith.subi %arg1, %c32 : index
          %2 = vector.transfer_read %reinterpret_cast_10[%c0, %1], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
          %3 = vector.transfer_read %reinterpret_cast[%arg0, %1], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
          %4 = vector.extract %2[0] : f32 from vector<8xf32>
          %5 = func.call @__mulsf3(%0, %4) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %6 = vector.extract %2[1] : f32 from vector<8xf32>
          %7 = func.call @__mulsf3(%0, %6) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %8 = vector.extract %2[2] : f32 from vector<8xf32>
          %9 = func.call @__mulsf3(%0, %8) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %10 = vector.extract %2[3] : f32 from vector<8xf32>
          %11 = func.call @__mulsf3(%0, %10) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %12 = vector.extract %2[4] : f32 from vector<8xf32>
          %13 = func.call @__mulsf3(%0, %12) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %14 = vector.extract %2[5] : f32 from vector<8xf32>
          %15 = func.call @__mulsf3(%0, %14) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %16 = vector.extract %2[6] : f32 from vector<8xf32>
          %17 = func.call @__mulsf3(%0, %16) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %18 = vector.extract %2[7] : f32 from vector<8xf32>
          %19 = func.call @__mulsf3(%0, %18) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
          %20 = vector.from_elements %5, %7, %9, %11, %13, %15, %17, %19 : vector<8xf32>
          %21 = arith.addf %3, %20 : vector<8xf32>
          vector.transfer_write %21, %reinterpret_cast[%arg0, %1] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_14", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(2) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(3) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage1_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage1_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage1_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_14_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage1_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 32 len = 256 sizes = [8, 32] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage1_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 0 len = 1024 sizes = [4, 8, 32] strides = [32, 129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 2>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage1_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 128 len = 8 sizes = [8, 1] strides = [129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 2>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage1_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 32 len = 4096 sizes = [128, 32] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 3>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage1_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10272 len = 32 sizes = [32] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 3>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_14_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment_reset {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<8xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<32xf32, 2 : i32> 
    %buf2 = aie.buffer(%tile_0_2) {sym_name = "buf2"} : memref<256xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<1024xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 0>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 0>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 1>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 1>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      aie.end
    }
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(0) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(1) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage0_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage0_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage0_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) @orbit_segment {
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %lock_0_2 = aie.lock(%tile_0_2, 9) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 8) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 7) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 6) {init = 0 : i32}
    %lock_0_2_3 = aie.lock(%tile_0_2, 5) {init = 1 : i32}
    %lock_0_2_4 = aie.lock(%tile_0_2, 4) {init = 0 : i32}
    %lock_0_2_5 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_6 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_7 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_8 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<8xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<32xf32, 2 : i32> 
    %buf2 = aie.buffer(%tile_0_2) {sym_name = "buf2"} : memref<256xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<1024xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<17x129xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<129x80xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<17x80xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_8, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<256xf32, 2 : i32> offset = 0 len = 256) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_7, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // 5 preds: ^bb4, ^bb6, ^bb8, ^bb9, ^bb10
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5, repeat_count = 3)
    ^bb4:  // pred: ^bb3
      aie.use_lock(%lock_0_2_5, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<256xf32, 2 : i32> offset = 0 len = 256) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 0>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_6, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 0, ^bb6, ^bb7)
    ^bb6:  // pred: ^bb5
      aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<8xf32, 2 : i32> offset = 0 len = 8) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 0>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_4, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb7:  // pred: ^bb5
      %3 = aie.dma_start(S2MM, 1, ^bb8, ^bb9, repeat_count = 3)
    ^bb8:  // pred: ^bb7
      aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 1>, task_id = 0 : i32}
      aie.use_lock(%lock_0_2_2, Release, %c1_i32)
      aie.next_bd ^bb2
    ^bb9:  // pred: ^bb7
      %4 = aie.dma_start(S2MM, 1, ^bb10, ^bb2)
    ^bb10:  // pred: ^bb9
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<32xf32, 2 : i32> offset = 0 len = 32) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 1>, task_id = 1 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb2
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c4 = arith.constant 4 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_7, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 9 : i64, orbit.storage = "intermediate"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c0 to %c32 step %c1 {
          memref.store %cst, %reinterpret_cast[%arg0, %arg1] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %reinterpret_cast_11 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 9 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_6, AcquireGreaterEqual, %c1_i32)
        %reinterpret_cast_12 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [32, 32], strides: [32, 1] {orbit.phase = 9 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<32x32xf32, strided<[32, 1]>, 2 : i32>
        aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
        scf.for %arg1 = %c0 to %c8 step %c1 {
          scf.for %arg2 = %c0 to %c32 step %c8 {
            scf.for %arg3 = %c0 to %c32 step %c1 {
              %0 = memref.load %reinterpret_cast_11[%arg1, %arg3] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
              %1 = vector.transfer_read %reinterpret_cast_12[%arg3, %arg2], %cst : memref<32x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
              %2 = vector.transfer_read %reinterpret_cast[%arg1, %arg2], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
              vector.transfer_write %20, %reinterpret_cast[%arg1, %arg2] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
        } {loop_annotation = #loop_annotation}
        aie.use_lock(%lock_0_2_5, Release, %c1_i32)
        aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_9 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [8, 1], strides: [1, 1] {orbit.phase = 13 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<8x1xf32, strided<[1, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_4, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_10 = memref.reinterpret_cast %buf3 to offset: [0], sizes: [1, 32], strides: [32, 1] {orbit.phase = 13 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<1x32xf32, strided<[32, 1]>, 2 : i32>
      aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
      scf.for %arg0 = %c0 to %c8 step %c1 {
        scf.for %arg1 = %c0 to %c32 step %c8 {
          %0 = memref.load %reinterpret_cast_9[%arg0, %c0] : memref<8x1xf32, strided<[1, 1]>, 2 : i32>
          %1 = vector.transfer_read %reinterpret_cast_10[%c0, %arg1], %cst : memref<1x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
          %2 = vector.transfer_read %reinterpret_cast[%arg0, %arg1], %cst : memref<8x32xf32, strided<[32, 1]>, 2 : i32>, vector<8xf32>
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
          vector.transfer_write %20, %reinterpret_cast[%arg0, %arg1] : vector<8xf32>, memref<8x32xf32, strided<[32, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.use_lock(%lock_0_2_8, Release, %c1_i32)
      aie.use_lock(%lock_0_2_3, Release, %c1_i32)
      aie.use_lock(%lock_0_2, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.packet_flow(0) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 0>
      aie.packet_dest<%tile_0_2, DMA : 0>
    } 
    aie.packet_flow(1) {
      aie.packet_source<%shim_noc_tile_0_0, DMA : 1>
      aie.packet_dest<%tile_0_2, DMA : 1>
    } 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air___orbit_fifo_stage0_storage3_out(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage0_storage0_in(%shim_noc_tile_0_0, MM2S, 0)
    aie.shim_dma_allocation @air___orbit_fifo_stage0_storage1_in(%shim_noc_tile_0_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_sequence(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      %0 = aiex.dma_configure_task_for @air___orbit_fifo_stage0_storage3_out {
        aie.dma_bd(%arg3 : memref<17x80xf32> offset = 0 len = 256 sizes = [8, 32] strides = [80, 1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air___orbit_fifo_stage0_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 0 len = 1024 sizes = [4, 8, 32] strides = [32, 129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 0>}
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air___orbit_fifo_stage0_storage0_in {
        aie.dma_bd(%arg0 : memref<17x129xf32> offset = 128 len = 8 sizes = [8, 1] strides = [129, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 0>}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @air___orbit_fifo_stage0_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 0 len = 4096 sizes = [128, 32] strides = [80, 1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 1>}
        aie.end
      }
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @air___orbit_fifo_stage0_storage1_in {
        aie.dma_bd(%arg1 : memref<129x80xf32> offset = 10240 len = 32 sizes = [32] strides = [1]) {packet = #aie.packet_info<pkt_type = 0, pkt_id = 1>}
        aie.end
      }
      aiex.dma_start_task(%4)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      aiex.dma_free_task(%3)
      aiex.dma_free_task(%4)
      aiex.npu.load_pdi {device_ref = @orbit_segment_reset}
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @gemm_scale(%arg0: memref<17x129xf32>, %arg1: memref<129x80xf32>, %arg2: memref<17x80xf32>, %arg3: memref<17x80xf32>) {
      aiex.configure @orbit_segment {
        aiex.run @orbit_segment_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_14 {
        aiex.run @orbit_segment_14_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_19 {
        aiex.run @orbit_segment_19_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_24 {
        aiex.run @orbit_segment_24_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_29 {
        aiex.run @orbit_segment_29_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_34 {
        aiex.run @orbit_segment_34_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_39 {
        aiex.run @orbit_segment_39_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_44 {
        aiex.run @orbit_segment_44_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_49 {
        aiex.run @orbit_segment_49_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_54 {
        aiex.run @orbit_segment_54_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_56 {
        aiex.run @orbit_segment_56_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_57 {
        aiex.run @orbit_segment_57_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_59 {
        aiex.run @orbit_segment_59_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_60 {
        aiex.run @orbit_segment_60_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
      aiex.configure @orbit_segment_62 {
        aiex.run @orbit_segment_62_sequence(%arg0, %arg1, %arg2, %arg3) : (memref<17x129xf32>, memref<129x80xf32>, memref<17x80xf32>, memref<17x80xf32>)
      }
    }
  }
}
