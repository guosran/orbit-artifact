#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "524e4c6a826d08d8438c0185cf530ef7f15488c22f4677e94f170cbaf7bd3f20", orbit.source_fingerprint = "9795912d6d8439a7371a6f129a804117d1940ad841ed58f7ca9fe6c0b5b98e32"} {
  aie.device(npu2) @orbit_segment {
    %shim_noc_tile_1_0 = aie.tile(1, 0)
    %tile_1_2 = aie.tile(1, 2)
    %lock_1_2 = aie.lock(%tile_1_2, 5) {init = 1 : i32}
    %lock_1_2_0 = aie.lock(%tile_1_2, 4) {init = 0 : i32}
    %lock_1_2_1 = aie.lock(%tile_1_2, 3) {init = 1 : i32}
    %lock_1_2_2 = aie.lock(%tile_1_2, 2) {init = 0 : i32}
    %lock_1_2_3 = aie.lock(%tile_1_2, 1) {init = 1 : i32}
    %lock_1_2_4 = aie.lock(%tile_1_2, 0) {init = 0 : i32}
    %buf2 = aie.buffer(%tile_1_2) {sym_name = "buf2"} : memref<64xf32, 2 : i32> 
    %buf1 = aie.buffer(%tile_1_2) {sym_name = "buf1"} : memref<1024xf32, 2 : i32> 
    %buf0 = aie.buffer(%tile_1_2) {sym_name = "buf0"} : memref<16xf32, 2 : i32> 
    %__air_external_buffer = aie.external_buffer {sym_name = "__air_external_buffer"} : memref<1x64xf32>
    %__air_external_buffer_1 = aie.external_buffer {sym_name = "__air_external_buffer_1"} : memref<64x16xf32>
    %__air_external_buffer_2 = aie.external_buffer {sym_name = "__air_external_buffer_2"} : memref<1x16xf32>
    %mem_1_2 = aie.mem(%tile_1_2) {
      %c1_i32 = arith.constant 1 : i32
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_1_2_4, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf0 : memref<16xf32, 2 : i32> offset = 0 len = 16) {task_id = 0 : i32}
      aie.use_lock(%lock_1_2_3, Release, %c1_i32)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb5
      aie.end
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb4, ^bb5)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_1_2_1, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf2 : memref<64xf32, 2 : i32> offset = 0 len = 64) {task_id = 0 : i32}
      aie.use_lock(%lock_1_2_2, Release, %c1_i32)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb3
      %2 = aie.dma_start(S2MM, 1, ^bb6, ^bb2)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_1_2, AcquireGreaterEqual, %c1_i32)
      aie.dma_bd(%buf1 : memref<1024xf32, 2 : i32> offset = 0 len = 1024) {task_id = 0 : i32}
      aie.use_lock(%lock_1_2_0, Release, %c1_i32)
      aie.next_bd ^bb6
    }
    %core_1_2 = aie.core(%tile_1_2) {
      %c1_i32 = arith.constant 1 : i32
      %cst = arith.constant 0.000000e+00 : f32
      %c16 = arith.constant 16 : index
      %c8 = arith.constant 8 : index
      %c64 = arith.constant 64 : index
      %c1 = arith.constant 1 : index
      %c0 = arith.constant 0 : index
      cf.br ^bb1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%lock_1_2_3, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast = memref.reinterpret_cast %buf0 to offset: [0], sizes: [1, 16], strides: [16, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 1 : i64, orbit.storage = "C"} : memref<16xf32, 2 : i32> to memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      scf.for %arg0 = %c0 to %c16 step %c1 {
        memref.store %cst, %reinterpret_cast[%c0, %arg0] : memref<1x16xf32, strided<[16, 1]>, 2 : i32>
      } {loop_annotation = #loop_annotation}
      %reinterpret_cast_5 = memref.reinterpret_cast %buf2 to offset: [0], sizes: [1, 64], strides: [64, 1] {orbit.phase = 1 : i64, orbit.storage = "A"} : memref<64xf32, 2 : i32> to memref<1x64xf32, strided<[64, 1]>, 2 : i32>
      aie.use_lock(%lock_1_2_2, AcquireGreaterEqual, %c1_i32)
      %reinterpret_cast_6 = memref.reinterpret_cast %buf1 to offset: [0], sizes: [64, 16], strides: [16, 1] {orbit.phase = 1 : i64, orbit.storage = "B"} : memref<1024xf32, 2 : i32> to memref<64x16xf32, strided<[16, 1]>, 2 : i32>
      aie.use_lock(%lock_1_2_0, AcquireGreaterEqual, %c1_i32)
      aie.event(0)
      scf.for %arg0 = %c0 to %c16 step %c8 {
        scf.for %arg1 = %c0 to %c64 step %c1 {
          %0 = memref.load %reinterpret_cast_5[%c0, %arg1] : memref<1x64xf32, strided<[64, 1]>, 2 : i32>
          %1 = vector.transfer_read %reinterpret_cast_6[%arg1, %arg0], %cst : memref<64x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
          %2 = vector.transfer_read %reinterpret_cast[%c0, %arg0], %cst : memref<1x16xf32, strided<[16, 1]>, 2 : i32>, vector<8xf32>
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
          vector.transfer_write %20, %reinterpret_cast[%c0, %arg0] : vector<8xf32>, memref<1x16xf32, strided<[16, 1]>, 2 : i32>
        } {loop_annotation = #loop_annotation}
      } {loop_annotation = #loop_annotation}
      aie.event(1)
      aie.use_lock(%lock_1_2_1, Release, %c1_i32)
      aie.use_lock(%lock_1_2, Release, %c1_i32)
      aie.use_lock(%lock_1_2_4, Release, %c1_i32)
      cf.br ^bb1
    } {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_herd", air.herd_size = array<i64: 1, 1>, stack_size = 4096 : i32}
    func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.emit_c_interface, llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
    aie.flow(%shim_noc_tile_1_0, DMA : 0, %tile_1_2, DMA : 0) 
    aie.flow(%shim_noc_tile_1_0, DMA : 1, %tile_1_2, DMA : 1) 
    aie.flow(%tile_1_2, DMA : 0, %shim_noc_tile_1_0, DMA : 0) 
    aie.packet_flow(0) {
      aie.packet_source<%tile_1_2, Trace : 0>
      aie.packet_dest<%shim_noc_tile_1_0, DMA : 1>
    }  {keep_pkt_header = true}
    aie.shim_dma_allocation @air_channel_2(%shim_noc_tile_1_0, S2MM, 0)
    aie.shim_dma_allocation @air_channel_0(%shim_noc_tile_1_0, MM2S, 0)
    aie.shim_dma_allocation @air_channel_1(%shim_noc_tile_1_0, MM2S, 1)
    aie.runtime_sequence @orbit_segment_sequence(%arg0: memref<1x64xf32>, %arg1: memref<64x16xf32>, %arg2: memref<1x16xf32>) {
      %c213000_i32 = arith.constant 213000 : i32
      %c127_i32 = arith.constant 127 : i32
      %c213068_i32 = arith.constant 213068 : i32
      %c32512_i32 = arith.constant 32512 : i32
      %c15_i32 = arith.constant 15 : i32
      %c119308_i32 = arith.constant 119308 : i32
      %c131136_i32 = arith.constant 131136 : i32
      %c261892_i32 = arith.constant 261892 : i32
      %c289_i32 = arith.constant 289 : i32
      %c261888_i32 = arith.constant 261888 : i32
      %c741165903_i32 = arith.constant 741165903 : i32
      %c213220_i32 = arith.constant 213220 : i32
      %c18948645_i32 = arith.constant 18948645 : i32
      %c213216_i32 = arith.constant 213216 : i32
      %c0_i32 = arith.constant 0 : i32
      %c213204_i32 = arith.constant 213204 : i32
      %c7995392_i32 = arith.constant 7995392 : i32
      %c213200_i32 = arith.constant 213200 : i32
      %c212992_i32 = arith.constant 212992 : i32
      %c31232_i32 = arith.constant 31232 : i32
      aiex.npu.write32(%c212992_i32, %c31232_i32) {column = 1 : i32, row = 2 : i32} : i32, i32
      aiex.npu.write32(%c213200_i32, %c7995392_i32) {column = 1 : i32, row = 2 : i32} : i32, i32
      aiex.npu.write32(%c213204_i32, %c0_i32) {column = 1 : i32, row = 2 : i32} : i32, i32
      aiex.npu.write32(%c213216_i32, %c18948645_i32) {column = 1 : i32, row = 2 : i32} : i32, i32
      aiex.npu.write32(%c213220_i32, %c741165903_i32) {column = 1 : i32, row = 2 : i32} : i32, i32
      aiex.npu.write32(%c261888_i32, %c289_i32) {column = 1 : i32, row = 2 : i32} : i32, i32
      aiex.npu.write32(%c261892_i32, %c0_i32) {column = 1 : i32, row = 2 : i32} : i32, i32
      aiex.npu.writebd {bd_id = 15 : i32, buffer_length = 131072 : i32, buffer_offset = 131136 : i32, column = 1 : i32, d0_size = 0 : i32, d0_stride = 0 : i32, d0_zero_after = 0 : i32, d0_zero_before = 0 : i32, d1_size = 0 : i32, d1_stride = 0 : i32, d1_zero_after = 0 : i32, d1_zero_before = 0 : i32, d2_size = 0 : i32, d2_stride = 0 : i32, d2_zero_after = 0 : i32, d2_zero_before = 0 : i32, enable_packet = 1 : i32, iteration_current = 0 : i32, iteration_size = 0 : i32, iteration_stride = 0 : i32, lock_acq_enable = 0 : i32, lock_acq_id = 0 : i32, lock_acq_val = 0 : i32, lock_rel_id = 0 : i32, lock_rel_val = 0 : i32, next_bd = 0 : i32, out_of_order_id = 0 : i32, packet_id = 0 : i32, packet_type = 0 : i32, row = 0 : i32, use_next_bd = 0 : i32, valid_bd = 1 : i32}
      aiex.npu.address_patch(%c131136_i32 : i32) {addr = 33673700 : ui32, arg_idx = 2 : i32}
      aiex.npu.write32(%c119308_i32, %c15_i32) {column = 1 : i32, row = 0 : i32} : i32, i32
      aiex.npu.write32(%c212992_i32, %c32512_i32) {column = 0 : i32, row = 0 : i32} : i32, i32
      aiex.npu.write32(%c213068_i32, %c127_i32) {column = 0 : i32, row = 0 : i32} : i32, i32
      aiex.npu.write32(%c213000_i32, %c127_i32) {column = 0 : i32, row = 0 : i32} : i32, i32
      %0 = aiex.dma_configure_task_for @air_channel_2 {
        aie.dma_bd(%arg2 : memref<1x16xf32> offset = 0 len = 16 sizes = [16] strides = [1])
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @air_channel_0 {
        aie.dma_bd(%arg0 : memref<1x64xf32> offset = 0 len = 64 sizes = [64] strides = [1])
        aie.end
      }
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @air_channel_1 {
        aie.dma_bd(%arg1 : memref<64x16xf32> offset = 0 len = 1024 sizes = [1024] strides = [1])
        aie.end
      }
      aiex.dma_start_task(%2)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
    }
  } {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>}
  aie.device(npu2) {
    aie.runtime_sequence @gemm(%arg0: memref<1x64xf32>, %arg1: memref<64x16xf32>, %arg2: memref<1x16xf32>) {
      aiex.configure @orbit_segment {
        aiex.run @orbit_segment_sequence(%arg0, %arg1, %arg2) : (memref<1x64xf32>, memref<64x16xf32>, memref<1x16xf32>)
      }
    }
  }
}
