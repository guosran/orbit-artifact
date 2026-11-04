#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "13ac5e875a1e8305d92c6a274094e0782c4c942ab4bb853866772d97fb0cd2aa", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} {
  aie.device(npu2) @orbit_segment_80 {
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
    %lock_0_2 = aie.lock(%tile_0_2, 3) {init = 1 : i32}
    %lock_0_2_0 = aie.lock(%tile_0_2, 2) {init = 0 : i32}
    %lock_0_2_1 = aie.lock(%tile_0_2, 1) {init = 1 : i32}
    %lock_0_2_2 = aie.lock(%tile_0_2, 0) {init = 0 : i32}
    %buf4 = aie.buffer(%tile_0_2) {sym_name = "buf4"} : memref<128xf32, 2 : i32> 
    %buf3 = aie.buffer(%tile_0_2) {sym_name = "buf3"} : memref<128xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<32x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<32x64xf32>
    %mem_0_2 = aie.mem(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf3 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_1, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb3
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb2)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_0_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf4 : memref<128xf32, 2 : i32> offset = 0 len = 128) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb4
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 0.000000e+00 : f32
      %cst_3 = arith.constant 5.000000e-01 : f32
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      scf.for %arg0 = %c0 to %c4 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_1, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf3 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          %reinterpret_cast_4 = memref.reinterpret_cast %buf4 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
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
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd_80", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    air.channel @channel_3 [1, 1]
    air.channel @channel_4 [1, 1]
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_0_0, DMA : 0, %tile_0_2, DMA : 0) 
    aie.flow(%tile_0_2, DMA : 0, %shim_noc_tile_0_0, DMA : 0) 
    aie.shim_dma_allocation @air_channel_4(%shim_noc_tile_0_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_3(%shim_noc_tile_0_0, MM2S, 0)
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
    %buf1 = aie.buffer(%tile_0_2) {sym_name = "buf1"} : memref<512xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_0_2) {sym_name = "buf0"} : memref<256xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<32x128xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<128x64xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<32x64xf32>
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
      aie.dma_bd(%buf1 : memref<512xf32, 2 : i32> offset = 0 len = 512) {task_id = 0 : i32}
      aie.use_lock(%lock_0_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_0_2 = aie.core(%tile_0_2) {
      %c1_i32 = arith.constant 1 : i32
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %cst = arith.constant 0.000000e+00 : f32
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb2
      cf.br ^bb2
    ^bb2:  // pred: ^bb1
      scf.for %arg0 = %c0 to %c4 step %c1 {
        scf.for %arg1 = %c0 to %c4 step %c1 {
          aie.use_lock(%lock_0_2_3, AcquireGreaterEqual, %c1_i32)
          %reinterpret_cast = memref.reinterpret_cast %buf2 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
          scf.for %arg2 = %c0 to %c8 step %c1 {
            scf.for %arg3 = %c0 to %c16 step %c1 {
              memref.store %cst, %reinterpret_cast[%arg2, %arg3] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
            } {loop_annotation = #loop_annotation}
          } {loop_annotation = #loop_annotation}
          scf.for %arg2 = %c0 to %c4 step %c1 {
            %reinterpret_cast_5 = memref.reinterpret_cast %buf0 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 16 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
            aie.use_lock(%lock_0_2_2, AcquireGreaterEqual, %c1_i32)
            %reinterpret_cast_6 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 16 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
            aie.use_lock(%lock_0_2_0, AcquireGreaterEqual, %c1_i32)
            scf.for %arg3 = %c0 to %c8 step %c1 {
              scf.for %arg4 = %c0 to %c16 step %c8 {
                scf.for %arg5 = %c0 to %c32 step %c1 {
                  %0 = memref.load %reinterpret_cast_5[%arg3, %arg5] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                  %1 = vector.transfer_read %reinterpret_cast_6[%arg5, %arg4], %cst : memref<32x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                  %2 = vector.transfer_read %reinterpret_cast[%arg3, %arg4], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
                  vector.transfer_write %20, %reinterpret_cast[%arg3, %arg4] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
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
    airrt.segment_metadata attributes {dma_allocations = [], sym_name = "orbit_segment_80"}{
      airrt.herd_metadata {dma_allocations = [{channel = 0 : i64, col = 0 : i64, id = 10 : i64, location = -1 : i64, row = 0 : i64}, {channel = 2 : i64, col = 0 : i64, id = 9 : i64, location = -1 : i64, row = 0 : i64}], loc_x = 0 : i64, loc_y = 2 : i64, size_x = 1 : i64, size_y = 1 : i64, sym_name = "orbit_herd_80"}
    }
  }
  air.channel @channel_0 [1, 1]
  air.channel @channel_1 [1, 1]
  air.channel @channel_2 [1, 1]
  air.channel @channel_3 [1, 1]
  air.channel @channel_4 [1, 1]
  func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
  func.func @gemm_scale(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg0, %arg9=%arg1, %arg10=%arg3) : memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32> attributes {id = 1 : i32} {
      %c16 = arith.constant 16 : index
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c32 = arith.constant 32 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %2 = air.wait_all async 
      %3 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %2) -> (!air.async.token) {
        %9 = arith.muli %arg11, %c8 : index
        %10 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %11 = scf.for %arg15 = %c0 to %c4 step %c1_0 iter_args(%arg16 = %arg14) -> (!air.async.token) {
            %12 = arith.muli %arg15, %c32 : index
            %13 = air.channel.put async [%arg16]  @channel_0[%c0, %c0] (%arg8[%9, %12] [8, 32] [128, 1]) {id = 1 : i32, metadataArray = [{base = "air_channel_0", index = 0 : i32}]} : (memref<32x128xf32>)
            scf.yield %13 : !air.async.token
          }
          scf.yield %11 : !air.async.token
        }
        scf.yield %10 : !air.async.token
      }
      %4 = air.wait_all async 
      %5 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %4) -> (!air.async.token) {
        %9 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %10 = arith.muli %arg13, %c16 : index
          %11 = scf.for %arg15 = %c0 to %c4 step %c1_0 iter_args(%arg16 = %arg14) -> (!air.async.token) {
            %12 = arith.muli %arg15, %c32 : index
            %13 = air.channel.put async [%arg16]  @channel_1[%c0, %c0] (%arg9[%12, %10] [32, 16] [64, 1]) {id = 2 : i32, metadataArray = [{base = "air_channel_1", index = 0 : i32}]} : (memref<128x64xf32>)
            scf.yield %13 : !air.async.token
          }
          scf.yield %11 : !air.async.token
        }
        scf.yield %9 : !air.async.token
      }
      %6 = air.wait_all async 
      %7 = scf.for %arg11 = %c0 to %c4 step %c1_0 iter_args(%arg12 = %6) -> (!air.async.token) {
        %9 = arith.muli %arg11, %c8 : index
        %10 = scf.for %arg13 = %c0 to %c4 step %c1_0 iter_args(%arg14 = %arg12) -> (!air.async.token) {
          %11 = arith.muli %arg13, %c16 : index
          %12 = air.channel.get async [%arg14]  @channel_2[%c0, %c0] (%arg10[%9, %11] [8, 16] [64, 1]) {id = 3 : i32, metadataArray = [{base = "air_channel_2", index = 0 : i32}]} : (memref<32x64xf32>)
          scf.yield %12 : !air.async.token
        }
        scf.yield %10 : !air.async.token
      }
      %8 = air.segment @orbit_segment async  attributes {id = 2 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c4_1 = arith.constant 4 : index
        %c1_2 = arith.constant 1 : index
        %c0_3 = arith.constant 0 : index
        %9 = air.wait_all async 
        %10 = scf.for %arg11 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg12 = %9) -> (!air.async.token) {
          %14 = scf.for %arg13 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg14 = %arg12) -> (!air.async.token) {
            %15 = air.wait_all async 
            scf.yield %15 : !air.async.token
          }
          scf.yield %14 : !air.async.token
        }
        %11 = air.wait_all async 
        %12 = scf.for %arg11 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg12 = %11) -> (!air.async.token) {
          %14 = scf.for %arg13 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg14 = %arg12) -> (!air.async.token) {
            %15 = air.wait_all async 
            scf.yield %15 : !air.async.token
          }
          scf.yield %14 : !air.async.token
        }
        %13 = air.herd @orbit_herd async  tile (%arg11, %arg12) in (%arg13=%c1_2, %arg14=%c1_2) attributes {id = 3 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %c32_4 = arith.constant 32 : index
          %cst = arith.constant 0.000000e+00 : f32
          %c16_5 = arith.constant 16 : index
          %c8_6 = arith.constant 8 : index
          %c1_7 = arith.constant 1 : index
          %c4_8 = arith.constant 4 : index
          %c0_9 = arith.constant 0 : index
          %14 = air.wait_all async 
          %15 = scf.for %arg15 = %c0_9 to %c4_8 step %c1_7 iter_args(%arg16 = %14) -> (!air.async.token) {
            %16 = scf.for %arg17 = %c0_9 to %c4_8 step %c1_7 iter_args(%arg18 = %arg16) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : memref<128xf32, 2 : i32>
                air.execute_terminator %alloc : memref<128xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 16 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %17 = air.wait_all async 
              %18 = scf.for %arg19 = %c0_9 to %c8_6 step %c1_7 iter_args(%arg20 = %17) -> (!air.async.token) {
                %22 = scf.for %arg21 = %c0_9 to %c16_5 step %c1_7 iter_args(%arg22 = %arg20) -> (!air.async.token) {
                  %async_token_11 = air.execute [%arg22] {
                    memref.store %cst, %reinterpret_cast[%arg19, %arg21] : memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  scf.yield %async_token_11 : !air.async.token
                }
                scf.yield %22 : !air.async.token
              }
              %19 = air.wait_all async [%arg18, %18] 
              %20 = scf.for %arg19 = %c0_9 to %c4_8 step %c1_7 iter_args(%arg20 = %19) -> (!air.async.token) {
                %async_token_11, %results_12 = air.execute -> (memref<512xf32, 2 : i32>) {
                  %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.32.16.loops.8.16.32"} : memref<512xf32, 2 : i32>
                  air.execute_terminator %alloc : memref<512xf32, 2 : i32>
                }
                %async_token_13, %results_14 = air.execute -> (memref<256xf32, 2 : i32>) {
                  %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.8.32.loops.8.16.32"} : memref<256xf32, 2 : i32>
                  air.execute_terminator %alloc : memref<256xf32, 2 : i32>
                }
                %reinterpret_cast_15 = memref.reinterpret_cast %results_14 to offset: [0], sizes: [8, 32], strides: [32, 1] {orbit.phase = 16 : i64, orbit.storage = "A"} : memref<256xf32, 2 : i32> to memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                %22 = air.channel.get async [%async_token_13, %arg20]  @channel_0[%arg11, %arg12] (%results_14[] [] []) {id = 4 : i32} : (memref<256xf32, 2 : i32>)
                %reinterpret_cast_16 = memref.reinterpret_cast %results_12 to offset: [0], sizes: [32, 16], strides: [16, 1] {orbit.phase = 16 : i64, orbit.storage = "B"} : memref<512xf32, 2 : i32> to memref<32x16xf32, strided<[16, 1]>, 2 : i32>
                %23 = air.channel.get async [%async_token_11, %arg20]  @channel_1[%arg11, %arg12] (%results_12[] [] []) {id = 5 : i32} : (memref<512xf32, 2 : i32>)
                air.wait_all [%22, %23]  {orbit.computation_event = 3 : i64, orbit.phase = 16 : i64, orbit.phase_dependencies = array<i64: 15>, orbit.read_copies = array<i64: 32, 33, 34>, orbit.task = "gemm", orbit.write_copies = array<i64: 35>}
                %24 = air.wait_all async [%22, %23] 
                %25 = scf.for %arg21 = %c0_9 to %c8_6 step %c1_7 iter_args(%arg22 = %24) -> (!air.async.token) {
                  %26 = scf.for %arg23 = %c0_9 to %c16_5 step %c8_6 iter_args(%arg24 = %arg22) -> (!air.async.token) {
                    %27 = scf.for %arg25 = %c0_9 to %c32_4 step %c1_7 iter_args(%arg26 = %arg24) -> (!air.async.token) {
                      %async_token_19, %results_20 = air.execute [%arg26] -> (f32) {
                        %39 = memref.load %reinterpret_cast_15[%arg21, %arg25] : memref<8x32xf32, strided<[32, 1]>, 2 : i32>
                        air.execute_terminator %39 : f32
                      }
                      %async_token_21, %results_22 = air.execute [%arg26] -> (vector<8xf32>) {
                        %39 = vector.transfer_read %reinterpret_cast_16[%arg25, %arg23], %cst : memref<32x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                        air.execute_terminator %39 : vector<8xf32>
                      }
                      %async_token_23, %results_24 = air.execute [%arg26] -> (vector<8xf32>) {
                        %39 = vector.transfer_read %reinterpret_cast[%arg21, %arg23], %cst : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                        air.execute_terminator %39 : vector<8xf32>
                      }
                      %28 = vector.extract %results_22[0] : f32 from vector<8xf32>
                      %async_token_25, %results_26 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %28) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %29 = vector.extract %results_22[1] : f32 from vector<8xf32>
                      %async_token_27, %results_28 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %29) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %30 = vector.extract %results_22[2] : f32 from vector<8xf32>
                      %async_token_29, %results_30 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %30) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %31 = vector.extract %results_22[3] : f32 from vector<8xf32>
                      %async_token_31, %results_32 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %31) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %32 = vector.extract %results_22[4] : f32 from vector<8xf32>
                      %async_token_33, %results_34 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %32) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %33 = vector.extract %results_22[5] : f32 from vector<8xf32>
                      %async_token_35, %results_36 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %33) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %34 = vector.extract %results_22[6] : f32 from vector<8xf32>
                      %async_token_37, %results_38 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %34) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %35 = vector.extract %results_22[7] : f32 from vector<8xf32>
                      %async_token_39, %results_40 = air.execute [%async_token_19] -> (f32) {
                        %39 = func.call @__mulsf3(%results_20, %35) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %39 : f32
                      }
                      %36 = vector.from_elements %results_26, %results_28, %results_30, %results_32, %results_34, %results_36, %results_38, %results_40 : vector<8xf32>
                      %37 = arith.addf %results_24, %36 : vector<8xf32>
                      %async_token_41 = air.execute [%async_token_23] {
                        vector.transfer_write %37, %reinterpret_cast[%arg21, %arg23] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                      }
                      %38 = air.wait_all async [%async_token_21, %async_token_25, %async_token_27, %async_token_29, %async_token_31, %async_token_33, %async_token_35, %async_token_37, %async_token_39, %async_token_41] 
                      scf.yield %38 : !air.async.token
                    }
                    scf.yield %27 : !air.async.token
                  }
                  scf.yield %26 : !air.async.token
                }
                %async_token_17 = air.execute [%22] {
                  memref.dealloc %results_14 : memref<256xf32, 2 : i32>
                }
                %async_token_18 = air.execute [%23] {
                  memref.dealloc %results_12 : memref<512xf32, 2 : i32>
                }
                scf.yield %25 : !air.async.token
              }
              %21 = air.channel.put async [%async_token, %20]  @channel_2[%arg11, %arg12] (%results[] [] []) {id = 6 : i32} : (memref<128xf32, 2 : i32>)
              %async_token_10 = air.execute [%21] {
                memref.dealloc %results : memref<128xf32, 2 : i32>
              }
              scf.yield %21 : !air.async.token
            } {orbit.compressed_phases = 4 : i64}
            scf.yield %16 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%15] 
        }
        air.wait_all [%10, %12, %13]  {air.segment_end}
      }
    }
    %1 = air.launch @orbit_launch_80 async [%0] (%arg4, %arg5) in (%arg6=%c1, %arg7=%c1) args(%arg8=%arg2, %arg9=%arg3) : memref<32x64xf32>, memref<32x64xf32> attributes {id = 4 : i32} {
      %c4 = arith.constant 4 : index
      %c8 = arith.constant 8 : index
      %c16 = arith.constant 16 : index
      %c1_0 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      %2 = air.wait_all async 
      %3 = scf.for %arg10 = %c0 to %c4 step %c1_0 iter_args(%arg11 = %2) -> (!air.async.token) {
        %7 = arith.muli %arg10, %c8 : index
        %8 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %9 = arith.muli %arg12, %c16 : index
          %10 = air.channel.put async [%arg13]  @channel_3[%c0, %c0] (%arg9[%7, %9] [8, 16] [64, 1]) {id = 7 : i32, metadataArray = [{base = "air_channel_3", index = 0 : i32}]} : (memref<32x64xf32>)
          scf.yield %10 : !air.async.token
        }
        scf.yield %8 : !air.async.token
      }
      %4 = air.wait_all async 
      %5 = scf.for %arg10 = %c0 to %c4 step %c1_0 iter_args(%arg11 = %4) -> (!air.async.token) {
        %7 = arith.muli %arg10, %c8 : index
        %8 = scf.for %arg12 = %c0 to %c4 step %c1_0 iter_args(%arg13 = %arg11) -> (!air.async.token) {
          %9 = arith.muli %arg12, %c16 : index
          %10 = air.channel.get async [%arg13]  @channel_4[%c0, %c0] (%arg8[%7, %9] [8, 16] [64, 1]) {id = 8 : i32, metadataArray = [{base = "air_channel_4", index = 0 : i32}]} : (memref<32x64xf32>)
          scf.yield %10 : !air.async.token
        }
        scf.yield %8 : !air.async.token
      }
      %6 = air.segment @orbit_segment_80 async  attributes {id = 5 : i32, x_loc = 0 : i64, x_size = 8 : i64, y_loc = 2 : i64, y_size = 6 : i64} {
        %c4_1 = arith.constant 4 : index
        %c1_2 = arith.constant 1 : index
        %c0_3 = arith.constant 0 : index
        %7 = air.wait_all async 
        %8 = scf.for %arg10 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg11 = %7) -> (!air.async.token) {
          %12 = scf.for %arg12 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %13 = air.wait_all async 
            scf.yield %13 : !air.async.token
          }
          scf.yield %12 : !air.async.token
        }
        %9 = air.wait_all async 
        %10 = scf.for %arg10 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg11 = %9) -> (!air.async.token) {
          %12 = scf.for %arg12 = %c0_3 to %c4_1 step %c1_2 iter_args(%arg13 = %arg11) -> (!air.async.token) {
            %13 = air.wait_all async 
            scf.yield %13 : !air.async.token
          }
          scf.yield %12 : !air.async.token
        }
        %11 = air.herd @orbit_herd_80 async  tile (%arg10, %arg11) in (%arg12=%c1_2, %arg13=%c1_2) attributes {id = 6 : i32, orbit.mapping_strategy = "serial-tiled", x_loc = 0 : i64, y_loc = 2 : i64} {
          %cst = arith.constant 5.000000e-01 : f32
          %cst_4 = arith.constant 0.000000e+00 : f32
          %c16_5 = arith.constant 16 : index
          %c8_6 = arith.constant 8 : index
          %c1_7 = arith.constant 1 : index
          %c4_8 = arith.constant 4 : index
          %c0_9 = arith.constant 0 : index
          %12 = air.wait_all async 
          %13 = scf.for %arg14 = %c0_9 to %c4_8 step %c1_7 iter_args(%arg15 = %12) -> (!air.async.token) {
            %14 = scf.for %arg16 = %c0_9 to %c4_8 step %c1_7 iter_args(%arg17 = %arg15) -> (!air.async.token) {
              %async_token, %results = air.execute -> (memref<128xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.8.16.loops.8.16"} : memref<128xf32, 2 : i32>
                air.execute_terminator %alloc : memref<128xf32, 2 : i32>
              }
              %async_token_10, %results_11 = air.execute -> (memref<128xf32, 2 : i32>) {
                %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<128xf32, 2 : i32>
                air.execute_terminator %alloc : memref<128xf32, 2 : i32>
              }
              %reinterpret_cast = memref.reinterpret_cast %results_11 to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "Y"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %reinterpret_cast_12 = memref.reinterpret_cast %results to offset: [0], sizes: [8, 16], strides: [16, 1] {orbit.phase = 80 : i64, orbit.storage = "intermediate"} : memref<128xf32, 2 : i32> to memref<8x16xf32, strided<[16, 1]>, 2 : i32>
              %15 = air.channel.get async [%async_token, %arg17]  @channel_3[%arg10, %arg11] (%results[] [] []) {id = 9 : i32} : (memref<128xf32, 2 : i32>)
              air.wait_all [%15]  {orbit.computation_event = 225 : i64, orbit.phase = 80 : i64, orbit.phase_dependencies = array<i64: 79>, orbit.read_copies = array<i64: 256>, orbit.task = "scale", orbit.write_copies = array<i64: 257>}
              %16 = scf.for %arg18 = %c0_9 to %c8_6 step %c1_7 iter_args(%arg19 = %15) -> (!air.async.token) {
                %18 = scf.for %arg20 = %c0_9 to %c16_5 step %c8_6 iter_args(%arg21 = %arg19) -> (!air.async.token) {
                  %async_token_15, %results_16 = air.execute [%arg21] -> (vector<8xf32>) {
                    %29 = vector.transfer_read %reinterpret_cast_12[%arg18, %arg20], %cst_4 : memref<8x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
                    air.execute_terminator %29 : vector<8xf32>
                  }
                  %19 = vector.extract %results_16[0] : f32 from vector<8xf32>
                  %async_token_17, %results_18 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%19, %cst) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %20 = vector.extract %results_16[1] : f32 from vector<8xf32>
                  %async_token_19, %results_20 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%20, %cst) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %21 = vector.extract %results_16[2] : f32 from vector<8xf32>
                  %async_token_21, %results_22 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%21, %cst) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %22 = vector.extract %results_16[3] : f32 from vector<8xf32>
                  %async_token_23, %results_24 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%22, %cst) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %23 = vector.extract %results_16[4] : f32 from vector<8xf32>
                  %async_token_25, %results_26 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%23, %cst) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %24 = vector.extract %results_16[5] : f32 from vector<8xf32>
                  %async_token_27, %results_28 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%24, %cst) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %25 = vector.extract %results_16[6] : f32 from vector<8xf32>
                  %async_token_29, %results_30 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%25, %cst) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %26 = vector.extract %results_16[7] : f32 from vector<8xf32>
                  %async_token_31, %results_32 = air.execute [%arg21] -> (f32) {
                    %29 = func.call @__mulsf3(%26, %cst) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    air.execute_terminator %29 : f32
                  }
                  %27 = vector.from_elements %results_18, %results_20, %results_22, %results_24, %results_26, %results_28, %results_30, %results_32 : vector<8xf32>
                  %async_token_33 = air.execute [%arg21] {
                    vector.transfer_write %27, %reinterpret_cast[%arg18, %arg20] : vector<8xf32>, memref<8x16xf32, strided<[16, 1]>, 2 : i32>
                  }
                  %28 = air.wait_all async [%async_token_15, %async_token_17, %async_token_19, %async_token_21, %async_token_23, %async_token_25, %async_token_27, %async_token_29, %async_token_31, %async_token_33] 
                  scf.yield %28 : !air.async.token
                }
                scf.yield %18 : !air.async.token
              }
              %17 = air.channel.put async [%async_token_10, %16]  @channel_4[%arg10, %arg11] (%results_11[] [] []) {id = 10 : i32} : (memref<128xf32, 2 : i32>)
              %async_token_13 = air.execute [%17] {
                memref.dealloc %results_11 : memref<128xf32, 2 : i32>
              }
              %async_token_14 = air.execute [%15] {
                memref.dealloc %results : memref<128xf32, 2 : i32>
              }
              scf.yield %17 : !air.async.token
            } {orbit.compressed_phases = 4 : i64}
            scf.yield %14 : !air.async.token
          } {orbit.compressed_phases = 4 : i64}
          air.wait_all [%13] 
        }
        air.wait_all [%8, %10, %11]  {air.segment_end}
      }
    }
    return
  }
}
