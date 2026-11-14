#map = affine_map<()[s0] -> (s0)>
#map1 = affine_map<()[s0] -> (s0 * 4096)>
#map2 = affine_map<()[s0] -> (s0 * 4096 + 2048)>
#map3 = affine_map<()[s0] -> (s0 * 2688 + 147456)>
#map4 = affine_map<()[s0] -> (s0 * 256)>
#map5 = affine_map<()[s0] -> (s0 * 512)>
module {
  func.func private @proj_qmm_zero(memref<32xf32, 2 : i32>, i32) attributes {link_with = "proj_qmm.o"}
  func.func private @proj_qmm_acc256(memref<256xbf16, 2 : i32>, memref<2560xbf16, 2 : i32>, memref<32xf32, 2 : i32>) attributes {link_with = "proj_qmm.o"}
  func.func private @proj_qmm_acc256_c(memref<256xbf16, 2 : i32>, memref<2560xbf16, 2 : i32>, memref<32xf32, 2 : i32>, memref<352xbf16, 2 : i32>, i32, i32) attributes {link_with = "proj_qmm.o"}
  func.func private @proj_qmm_rc_arm(memref<352xbf16, 2 : i32>, i32) attributes {link_with = "proj_qmm.o"}
  func.func private @proj_qmm_flush_row(memref<32xf32, 2 : i32>, memref<48xbf16, 2 : i32>, i32) attributes {link_with = "proj_qmm.o"}
  func.func private @rms_norm_aie(memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, i32) attributes {link_with = "rms_residual.o"}
  func.func private @residual_add_aie(memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>) attributes {link_with = "rms_residual.o"}
  func.func private @glu_aie(memref<512xbf16, 2 : i32>, memref<1024xbf16, 2 : i32>, i32) attributes {link_with = "glu.o"}
  func.func private @rope_compute(memref<2048xbf16, 2 : i32>, memref<256xbf16, 2 : i32>, memref<256xbf16, 2 : i32>, memref<2560xbf16, 2 : i32>, memref<2688xbf16, 2 : i32>, i32) attributes {link_with = "rope.o"}
  func.func private @attn_qk_blk(memref<1024xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<16xbf16, 2 : i32>, memref<8xf32, 2 : i32>, memref<192xbf16, 2 : i32>, i32, i32) attributes {link_with = "attn_qk.ll", link_with_mode = "merge"}
  func.func private @attn_kv_blk(memref<192xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<1024xf32, 2 : i32>, memref<16xf32, 2 : i32>, i32, i32) attributes {link_with = "attn_kv.ll", link_with_mode = "merge"}
  func.func private @attn_kv_fin(memref<1024xf32, 2 : i32>, memref<16xf32, 2 : i32>, memref<1024xbf16, 2 : i32>) attributes {link_with = "attn_kv.ll", link_with_mode = "merge"}
  air.channel @rmsX [1] {channel_type = "npu_dma_packet"}
  air.channel @rmsW [1]
  air.channel @rmsW2 [1]
  air.channel @xnorm [1] {channel_type = "npu_dma_packet"}
  air.channel @inX [1, 1] {air.shared_resident_ring, broadcast_shape = [4 : index, 4 : index]}
  air.channel @ropeLUT [1]
  air.channel @ropeQ [1]
  air.channel @toAttnQ [2]
  air.channel @toAttnKV [1] {channel_type = "npu_dma_packet"}
  air.channel @toK [2]
  air.channel @toV [2]
  air.channel @appendK [1] {channel_type = "npu_dma_packet"}
  air.channel @appendV [1] {channel_type = "npu_dma_packet"}
  air.channel @inKV_K [1]
  air.channel @inKV_V [1]
  air.channel @attnO [2]
  air.channel @inW [4]
  air.channel @wL2ToL1 [4, 4] {air.shared_resident_ring}
  air.channel @outA [4, 4] {channel_type = "npu_dma_packet"}
  air.channel @toMain [4] {channel_type = "npu_dma_packet"}
  air.channel @outY [1, 1] {broadcast_shape = [1 : index, 3 : index], channel_type = "npu_dma_packet"}
  air.channel @toShim [3]
  air.channel @layerOut [1]
  air.channel @gluOut [1]
  func.func @q4nx_decode(%arg0: memref<2048xbf16>, %arg1: memref<983040000xbf16>, %arg2: memref<246272xbf16>, %arg3: memref<158208xbf16>, %arg4: memref<37748736xbf16>) {
    %c0 = arith.constant 0 : index
    %c61 = arith.constant 61 : index
    %c1 = arith.constant 1 : index
    scf.for %arg5 = %c0 to %c61 step %c1 {
      %c1_0 = arith.constant 1 : index
      %c1_1 = arith.constant 1 : index
      air.launch (%arg6, %arg7) in (%arg8=%c1_0, %arg9=%c1_1) args(%arg10=%arg0, %arg11=%arg1, %arg12=%arg2, %arg13=%arg3, %arg14=%arg4, %arg15=%arg5) : memref<2048xbf16>, memref<983040000xbf16>, memref<246272xbf16>, memref<158208xbf16>, memref<37748736xbf16>, index attributes {air.preserve_shim_dma_order} {
        %c24576000 = arith.constant 24576000 : index
        %0 = arith.muli %arg15, %c24576000 : index
        %c1048576 = arith.constant 1048576 : index
        %1 = arith.muli %arg15, %c1048576 : index
        %c1_i32 = arith.constant 1 : i32
        %c0_i32 = arith.constant 0 : i32
        %c36 = arith.constant 36 : index
        %2 = arith.cmpi slt, %arg15, %c36 : index
        %3 = arith.select %2, %c1_i32, %c0_i32 : i32
        %4 = arith.index_cast %3 : i32 to index
        scf.index_switch %4 
        case 0 {
          %c884736000 = arith.constant 884736000 : index
          %c36_2 = arith.constant 36 : index
          %5 = arith.subi %arg15, %c36_2 : index
          %c3932160 = arith.constant 3932160 : index
          %6 = arith.muli %5, %c3932160 : index
          %7 = arith.addi %c884736000, %6 : index
          %c4608 = arith.constant 4608 : index
          %c36_3 = arith.constant 36 : index
          %8 = arith.subi %arg15, %c36_3 : index
          %c6144 = arith.constant 6144 : index
          %9 = arith.muli %8, %c6144 : index
          %10 = arith.addi %c4608, %9 : index
          air.channel.put  @rmsX[] (%arg10[0] [2048] [1]) : (memref<2048xbf16>)
          air.channel.put  @rmsW[] (%arg12[244224] [2048] [1]) : (memref<246272xbf16>)
          air.channel.put  @rmsW2[] (%arg12[0] [2048] [1]) : (memref<246272xbf16>)
          %c0_4 = arith.constant 0 : index
          %c4 = arith.constant 4 : index
          %c1_5 = arith.constant 1 : index
          scf.parallel (%arg16) = (%c0_4) to (%c4) step (%c1_5) {
            %c983040 = arith.constant 983040 : index
            %12 = arith.muli %arg16, %c983040 : index
            %13 = arith.addi %7, %12 : index
            air.channel.put  @inW[%arg16] (%arg11[%13] [491520] [1]) : (memref<983040000xbf16>)
            %c491520 = arith.constant 491520 : index
            %14 = arith.addi %13, %c491520 : index
            air.channel.put  @inW[%arg16] (%arg11[%14] [491520] [1]) : (memref<983040000xbf16>)
            scf.reduce 
          }
          %11 = affine.apply #map()[%10]
          %c0_6 = arith.constant 0 : index
          air.channel.get  @layerOut[%c0_6] (%arg13[0, %11] [12, 512] [512, 1]) : (memref<158208xbf16>)
          scf.yield
        }
        default {
          air.channel.put  @rmsX[] (%arg10[0] [2048] [1]) : (memref<2048xbf16>)
          %5 = affine.apply #map1()[%arg15]
          air.channel.put  @rmsW[] (%arg12[%5] [2048] [1]) : (memref<246272xbf16>)
          %6 = affine.apply #map2()[%arg15]
          air.channel.put  @rmsW2[] (%arg12[%6] [2048] [1]) : (memref<246272xbf16>)
          %7 = affine.apply #map3()[%arg15]
          air.channel.put  @ropeLUT[] (%arg12[%7] [2688] [1]) : (memref<246272xbf16>)
          %c0_2 = arith.constant 0 : index
          %c4 = arith.constant 4 : index
          %c1_3 = arith.constant 1 : index
          scf.parallel (%arg16) = (%c0_2) to (%c4) step (%c1_3) {
            %c409600 = arith.constant 409600 : index
            %22 = arith.muli %arg16, %c409600 : index
            %23 = arith.addi %0, %22 : index
            air.channel.put  @inW[%arg16] (%arg11[%23] [204800] [1]) : (memref<983040000xbf16>)
            %c204800 = arith.constant 204800 : index
            %24 = arith.addi %23, %c204800 : index
            air.channel.put  @inW[%arg16] (%arg11[%24] [204800] [1]) : (memref<983040000xbf16>)
            scf.reduce 
          }
          %c524032 = arith.constant 524032 : index
          %8 = arith.addi %1, %c524032 : index
          %9 = affine.apply #map()[%8]
          %c0_4 = arith.constant 0 : index
          %10 = air.channel.get async  @appendK[%c0_4] (%arg14[0, %9] [1, 256] [524288, 1]) : (memref<37748736xbf16>)
          %c1048320 = arith.constant 1048320 : index
          %11 = arith.addi %1, %c1048320 : index
          %12 = affine.apply #map()[%11]
          %c0_5 = arith.constant 0 : index
          %13 = air.channel.get async  @appendV[%c0_5] (%arg14[0, %12] [1, 256] [524288, 1]) : (memref<37748736xbf16>)
          %14 = affine.apply #map()[%1]
          %c0_6 = arith.constant 0 : index
          %15 = air.channel.put async [%10]  @inKV_K[%c0_6] (%arg14[0, 0, %14] [128, 16, 256] [4096, 256, 1]) : (memref<37748736xbf16>)
          %c524288 = arith.constant 524288 : index
          %16 = arith.addi %1, %c524288 : index
          %17 = affine.apply #map()[%16]
          %c0_7 = arith.constant 0 : index
          %18 = air.channel.put async [%13]  @inKV_V[%c0_7] (%arg14[0, 0, %17] [128, 16, 256] [4096, 256, 1]) : (memref<37748736xbf16>)
          %c1638400 = arith.constant 1638400 : index
          %19 = arith.addi %0, %c1638400 : index
          %c0_8 = arith.constant 0 : index
          %c4_9 = arith.constant 4 : index
          %c1_10 = arith.constant 1 : index
          scf.parallel (%arg16) = (%c0_8) to (%c4_9) step (%c1_10) {
            %c327680 = arith.constant 327680 : index
            %22 = arith.muli %arg16, %c327680 : index
            %23 = arith.addi %19, %22 : index
            air.channel.put  @inW[%arg16] (%arg11[%23] [163840] [1]) : (memref<983040000xbf16>)
            %c163840 = arith.constant 163840 : index
            %24 = arith.addi %23, %c163840 : index
            air.channel.put  @inW[%arg16] (%arg11[%24] [163840] [1]) : (memref<983040000xbf16>)
            scf.reduce 
          }
          %c2949120 = arith.constant 2949120 : index
          %20 = arith.addi %0, %c2949120 : index
          %c0_11 = arith.constant 0 : index
          %c4_12 = arith.constant 4 : index
          %c1_13 = arith.constant 1 : index
          scf.parallel (%arg16) = (%c0_11) to (%c4_12) step (%c1_13) {
            %c3604480 = arith.constant 3604480 : index
            %22 = arith.muli %arg16, %c3604480 : index
            %23 = arith.addi %20, %22 : index
            air.channel.put  @inW[%arg16] (%arg11[%23] [1802240] [1]) : (memref<983040000xbf16>)
            %c1802240 = arith.constant 1802240 : index
            %24 = arith.addi %23, %c1802240 : index
            air.channel.put  @inW[%arg16] (%arg11[%24] [1802240] [1]) : (memref<983040000xbf16>)
            scf.reduce 
          }
          %c17367040 = arith.constant 17367040 : index
          %21 = arith.addi %0, %c17367040 : index
          %c0_14 = arith.constant 0 : index
          %c4_15 = arith.constant 4 : index
          %c1_16 = arith.constant 1 : index
          scf.parallel (%arg16) = (%c0_14) to (%c4_15) step (%c1_16) {
            %c1802240 = arith.constant 1802240 : index
            %22 = arith.muli %arg16, %c1802240 : index
            %23 = arith.addi %21, %22 : index
            air.channel.put  @inW[%arg16] (%arg11[%23] [901120] [1]) : (memref<983040000xbf16>)
            %c901120 = arith.constant 901120 : index
            %24 = arith.addi %23, %c901120 : index
            air.channel.put  @inW[%arg16] (%arg11[%24] [901120] [1]) : (memref<983040000xbf16>)
            scf.reduce 
          }
          %c0_17 = arith.constant 0 : index
          air.channel.get  @layerOut[%c0_17] (%arg10[0] [2048] [1]) : (memref<2048xbf16>)
        }
        air.segment @seg  args(%arg16=%arg15) : index {
          %c36_2 = arith.constant 36 : index
          %5 = arith.cmpi slt, %arg16, %c36_2 : index
          %c1_i32_3 = arith.constant 1 : i32
          %c0_i32_4 = arith.constant 0 : i32
          %6 = arith.select %5, %c1_i32_3, %c0_i32_4 : i32
          %7 = arith.index_cast %6 : i32 to index
          scf.index_switch %7 
          case 0 {
            %c0_34 = arith.constant 0 : index
            %c48 = arith.constant 48 : index
            %c1_35 = arith.constant 1 : index
            scf.for %arg17 = %c0_34 to %c48 step %c1_35 {
              %alloc_36 = memref.alloc() {air.memtile_col = 3 : i32} : memref<512xbf16, 1 : i32>
              air.channel.get  @xnorm[] (%alloc_36[0] [512] [1]) : (memref<512xbf16, 1 : i32>)
              %c0_37 = arith.constant 0 : index
              %c2_38 = arith.constant 2 : index
              %c1_39 = arith.constant 1 : index
              scf.for %arg18 = %c0_37 to %c2_38 step %c1_39 {
                %8 = affine.apply #map4()[%arg18]
                air.channel.put  @inX[] (%alloc_36[%8] [256] [1]) : (memref<512xbf16, 1 : i32>)
              }
              memref.dealloc %alloc_36 : memref<512xbf16, 1 : i32>
            }
            scf.yield
          }
          default {
            %c0_34 = arith.constant 0 : index
            %c300 = arith.constant 300 : index
            %c1_35 = arith.constant 1 : index
            scf.for %arg17 = %c0_34 to %c300 step %c1_35 {
              %alloc_36 = memref.alloc() {air.memtile_col = 3 : i32} : memref<512xbf16, 1 : i32>
              air.channel.get  @xnorm[] (%alloc_36[0] [512] [1]) : (memref<512xbf16, 1 : i32>)
              %c0_37 = arith.constant 0 : index
              %c2_38 = arith.constant 2 : index
              %c1_39 = arith.constant 1 : index
              scf.for %arg18 = %c0_37 to %c2_38 step %c1_39 {
                %8 = affine.apply #map4()[%arg18]
                air.channel.put  @inX[] (%alloc_36[%8] [256] [1]) : (memref<512xbf16, 1 : i32>)
              }
              memref.dealloc %alloc_36 : memref<512xbf16, 1 : i32>
            }
          }
          %c0_5 = arith.constant 0 : index
          %c600 = arith.constant 600 : index
          %c1_6 = arith.constant 1 : index
          scf.for %arg17 = %c0_5 to %c600 step %c1_6 {
            %alloc_34 = memref.alloc() {air.memtile_col = 0 : i32} : memref<10240xbf16, 1 : i32>
            %c0_35 = arith.constant 0 : index
            air.channel.get  @inW[%c0_35] (%alloc_34[] [] []) : (memref<10240xbf16, 1 : i32>)
            %c0_36 = arith.constant 0 : index
            %c0_37 = arith.constant 0 : index
            air.channel.put  @wL2ToL1[%c0_36, %c0_37] (%alloc_34[0] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c0_38 = arith.constant 0 : index
            %c1_39 = arith.constant 1 : index
            air.channel.put  @wL2ToL1[%c0_38, %c1_39] (%alloc_34[2560] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c0_40 = arith.constant 0 : index
            %c2_41 = arith.constant 2 : index
            air.channel.put  @wL2ToL1[%c0_40, %c2_41] (%alloc_34[5120] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c0_42 = arith.constant 0 : index
            %c3 = arith.constant 3 : index
            air.channel.put  @wL2ToL1[%c0_42, %c3] (%alloc_34[7680] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            memref.dealloc %alloc_34 : memref<10240xbf16, 1 : i32>
          }
          %c0_7 = arith.constant 0 : index
          %c600_8 = arith.constant 600 : index
          %c1_9 = arith.constant 1 : index
          scf.for %arg17 = %c0_7 to %c600_8 step %c1_9 {
            %alloc_34 = memref.alloc() {air.memtile_col = 1 : i32} : memref<10240xbf16, 1 : i32>
            %c1_35 = arith.constant 1 : index
            air.channel.get  @inW[%c1_35] (%alloc_34[] [] []) : (memref<10240xbf16, 1 : i32>)
            %c1_36 = arith.constant 1 : index
            %c0_37 = arith.constant 0 : index
            air.channel.put  @wL2ToL1[%c1_36, %c0_37] (%alloc_34[0] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c1_38 = arith.constant 1 : index
            %c1_39 = arith.constant 1 : index
            air.channel.put  @wL2ToL1[%c1_38, %c1_39] (%alloc_34[2560] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c1_40 = arith.constant 1 : index
            %c2_41 = arith.constant 2 : index
            air.channel.put  @wL2ToL1[%c1_40, %c2_41] (%alloc_34[5120] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c1_42 = arith.constant 1 : index
            %c3 = arith.constant 3 : index
            air.channel.put  @wL2ToL1[%c1_42, %c3] (%alloc_34[7680] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            memref.dealloc %alloc_34 : memref<10240xbf16, 1 : i32>
          }
          %c0_10 = arith.constant 0 : index
          %c600_11 = arith.constant 600 : index
          %c1_12 = arith.constant 1 : index
          scf.for %arg17 = %c0_10 to %c600_11 step %c1_12 {
            %alloc_34 = memref.alloc() {air.memtile_col = 6 : i32} : memref<10240xbf16, 1 : i32>
            %c2_35 = arith.constant 2 : index
            air.channel.get  @inW[%c2_35] (%alloc_34[] [] []) : (memref<10240xbf16, 1 : i32>)
            %c2_36 = arith.constant 2 : index
            %c0_37 = arith.constant 0 : index
            air.channel.put  @wL2ToL1[%c2_36, %c0_37] (%alloc_34[0] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c2_38 = arith.constant 2 : index
            %c1_39 = arith.constant 1 : index
            air.channel.put  @wL2ToL1[%c2_38, %c1_39] (%alloc_34[2560] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c2_40 = arith.constant 2 : index
            %c2_41 = arith.constant 2 : index
            air.channel.put  @wL2ToL1[%c2_40, %c2_41] (%alloc_34[5120] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c2_42 = arith.constant 2 : index
            %c3 = arith.constant 3 : index
            air.channel.put  @wL2ToL1[%c2_42, %c3] (%alloc_34[7680] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            memref.dealloc %alloc_34 : memref<10240xbf16, 1 : i32>
          }
          %c0_13 = arith.constant 0 : index
          %c600_14 = arith.constant 600 : index
          %c1_15 = arith.constant 1 : index
          scf.for %arg17 = %c0_13 to %c600_14 step %c1_15 {
            %alloc_34 = memref.alloc() {air.memtile_col = 7 : i32} : memref<10240xbf16, 1 : i32>
            %c3 = arith.constant 3 : index
            air.channel.get  @inW[%c3] (%alloc_34[] [] []) : (memref<10240xbf16, 1 : i32>)
            %c3_35 = arith.constant 3 : index
            %c0_36 = arith.constant 0 : index
            air.channel.put  @wL2ToL1[%c3_35, %c0_36] (%alloc_34[0] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c3_37 = arith.constant 3 : index
            %c1_38 = arith.constant 1 : index
            air.channel.put  @wL2ToL1[%c3_37, %c1_38] (%alloc_34[2560] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c3_39 = arith.constant 3 : index
            %c2_40 = arith.constant 2 : index
            air.channel.put  @wL2ToL1[%c3_39, %c2_40] (%alloc_34[5120] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            %c3_41 = arith.constant 3 : index
            %c3_42 = arith.constant 3 : index
            air.channel.put  @wL2ToL1[%c3_41, %c3_42] (%alloc_34[7680] [2560] [1]) : (memref<10240xbf16, 1 : i32>)
            memref.dealloc %alloc_34 : memref<10240xbf16, 1 : i32>
          }
          scf.index_switch %7 
          case 0 {
            %c0_34 = arith.constant 0 : index
            %c12 = arith.constant 12 : index
            %c1_35 = arith.constant 1 : index
            scf.for %arg17 = %c0_34 to %c12 step %c1_35 {
              %alloc_36 = memref.alloc() {air.memtile_col = 0 : i32} : memref<130xbf16, 1 : i32>
              %c0_37 = arith.constant 0 : index
              %c0_38 = arith.constant 0 : index
              air.channel.get  @outA[%c0_37, %c0_38] (%alloc_36[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_39 = arith.constant 0 : index
              %c1_40 = arith.constant 1 : index
              air.channel.get  @outA[%c0_39, %c1_40] (%alloc_36[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_41 = arith.constant 0 : index
              %c2_42 = arith.constant 2 : index
              air.channel.get  @outA[%c0_41, %c2_42] (%alloc_36[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_43 = arith.constant 0 : index
              %c3 = arith.constant 3 : index
              air.channel.get  @outA[%c0_43, %c3] (%alloc_36[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_44 = arith.constant 0 : index
              air.channel.put  @toMain[%c0_44] (%alloc_36[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_36 : memref<130xbf16, 1 : i32>
              %alloc_45 = memref.alloc() {air.memtile_col = 1 : i32} : memref<130xbf16, 1 : i32>
              %c1_46 = arith.constant 1 : index
              %c0_47 = arith.constant 0 : index
              air.channel.get  @outA[%c1_46, %c0_47] (%alloc_45[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_48 = arith.constant 1 : index
              %c1_49 = arith.constant 1 : index
              air.channel.get  @outA[%c1_48, %c1_49] (%alloc_45[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_50 = arith.constant 1 : index
              %c2_51 = arith.constant 2 : index
              air.channel.get  @outA[%c1_50, %c2_51] (%alloc_45[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_52 = arith.constant 1 : index
              %c3_53 = arith.constant 3 : index
              air.channel.get  @outA[%c1_52, %c3_53] (%alloc_45[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_54 = arith.constant 1 : index
              air.channel.put  @toMain[%c1_54] (%alloc_45[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_45 : memref<130xbf16, 1 : i32>
              %alloc_55 = memref.alloc() {air.memtile_col = 6 : i32} : memref<130xbf16, 1 : i32>
              %c2_56 = arith.constant 2 : index
              %c0_57 = arith.constant 0 : index
              air.channel.get  @outA[%c2_56, %c0_57] (%alloc_55[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_58 = arith.constant 2 : index
              %c1_59 = arith.constant 1 : index
              air.channel.get  @outA[%c2_58, %c1_59] (%alloc_55[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_60 = arith.constant 2 : index
              %c2_61 = arith.constant 2 : index
              air.channel.get  @outA[%c2_60, %c2_61] (%alloc_55[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_62 = arith.constant 2 : index
              %c3_63 = arith.constant 3 : index
              air.channel.get  @outA[%c2_62, %c3_63] (%alloc_55[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_64 = arith.constant 2 : index
              air.channel.put  @toMain[%c2_64] (%alloc_55[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_55 : memref<130xbf16, 1 : i32>
              %alloc_65 = memref.alloc() {air.memtile_col = 7 : i32} : memref<130xbf16, 1 : i32>
              %c3_66 = arith.constant 3 : index
              %c0_67 = arith.constant 0 : index
              air.channel.get  @outA[%c3_66, %c0_67] (%alloc_65[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_68 = arith.constant 3 : index
              %c1_69 = arith.constant 1 : index
              air.channel.get  @outA[%c3_68, %c1_69] (%alloc_65[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_70 = arith.constant 3 : index
              %c2_71 = arith.constant 2 : index
              air.channel.get  @outA[%c3_70, %c2_71] (%alloc_65[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_72 = arith.constant 3 : index
              %c3_73 = arith.constant 3 : index
              air.channel.get  @outA[%c3_72, %c3_73] (%alloc_65[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_74 = arith.constant 3 : index
              air.channel.put  @toMain[%c3_74] (%alloc_65[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_65 : memref<130xbf16, 1 : i32>
              %alloc_75 = memref.alloc() {air.memtile_col = 4 : i32} : memref<514xbf16, 1 : i32>
              %c0_76 = arith.constant 0 : index
              air.channel.get  @toMain[%c0_76] (%alloc_75[0] [130] [1]) : (memref<514xbf16, 1 : i32>)
              %c1_77 = arith.constant 1 : index
              air.channel.get  @toMain[%c1_77] (%alloc_75[130] [128] [1]) : (memref<514xbf16, 1 : i32>)
              %c2_78 = arith.constant 2 : index
              air.channel.get  @toMain[%c2_78] (%alloc_75[258] [128] [1]) : (memref<514xbf16, 1 : i32>)
              %c3_79 = arith.constant 3 : index
              air.channel.get  @toMain[%c3_79] (%alloc_75[386] [128] [1]) : (memref<514xbf16, 1 : i32>)
              %c0_80 = arith.constant 0 : index
              %c0_81 = arith.constant 0 : index
              air.channel.put  @outY[%c0_80, %c0_81] (%alloc_75[0] [514] [1]) : (memref<514xbf16, 1 : i32>)
              memref.dealloc %alloc_75 : memref<514xbf16, 1 : i32>
            }
            scf.yield
          }
          default {
            %c0_34 = arith.constant 0 : index
            %c57 = arith.constant 57 : index
            %c1_35 = arith.constant 1 : index
            scf.for %arg17 = %c0_34 to %c57 step %c1_35 {
              %alloc_36 = memref.alloc() {air.memtile_col = 0 : i32} : memref<130xbf16, 1 : i32>
              %c0_37 = arith.constant 0 : index
              %c0_38 = arith.constant 0 : index
              air.channel.get  @outA[%c0_37, %c0_38] (%alloc_36[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_39 = arith.constant 0 : index
              %c1_40 = arith.constant 1 : index
              air.channel.get  @outA[%c0_39, %c1_40] (%alloc_36[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_41 = arith.constant 0 : index
              %c2_42 = arith.constant 2 : index
              air.channel.get  @outA[%c0_41, %c2_42] (%alloc_36[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_43 = arith.constant 0 : index
              %c3 = arith.constant 3 : index
              air.channel.get  @outA[%c0_43, %c3] (%alloc_36[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c0_44 = arith.constant 0 : index
              air.channel.put  @toMain[%c0_44] (%alloc_36[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_36 : memref<130xbf16, 1 : i32>
              %alloc_45 = memref.alloc() {air.memtile_col = 1 : i32} : memref<130xbf16, 1 : i32>
              %c1_46 = arith.constant 1 : index
              %c0_47 = arith.constant 0 : index
              air.channel.get  @outA[%c1_46, %c0_47] (%alloc_45[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_48 = arith.constant 1 : index
              %c1_49 = arith.constant 1 : index
              air.channel.get  @outA[%c1_48, %c1_49] (%alloc_45[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_50 = arith.constant 1 : index
              %c2_51 = arith.constant 2 : index
              air.channel.get  @outA[%c1_50, %c2_51] (%alloc_45[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_52 = arith.constant 1 : index
              %c3_53 = arith.constant 3 : index
              air.channel.get  @outA[%c1_52, %c3_53] (%alloc_45[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c1_54 = arith.constant 1 : index
              air.channel.put  @toMain[%c1_54] (%alloc_45[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_45 : memref<130xbf16, 1 : i32>
              %alloc_55 = memref.alloc() {air.memtile_col = 6 : i32} : memref<130xbf16, 1 : i32>
              %c2_56 = arith.constant 2 : index
              %c0_57 = arith.constant 0 : index
              air.channel.get  @outA[%c2_56, %c0_57] (%alloc_55[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_58 = arith.constant 2 : index
              %c1_59 = arith.constant 1 : index
              air.channel.get  @outA[%c2_58, %c1_59] (%alloc_55[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_60 = arith.constant 2 : index
              %c2_61 = arith.constant 2 : index
              air.channel.get  @outA[%c2_60, %c2_61] (%alloc_55[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_62 = arith.constant 2 : index
              %c3_63 = arith.constant 3 : index
              air.channel.get  @outA[%c2_62, %c3_63] (%alloc_55[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c2_64 = arith.constant 2 : index
              air.channel.put  @toMain[%c2_64] (%alloc_55[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_55 : memref<130xbf16, 1 : i32>
              %alloc_65 = memref.alloc() {air.memtile_col = 7 : i32} : memref<130xbf16, 1 : i32>
              %c3_66 = arith.constant 3 : index
              %c0_67 = arith.constant 0 : index
              air.channel.get  @outA[%c3_66, %c0_67] (%alloc_65[0] [34] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_68 = arith.constant 3 : index
              %c1_69 = arith.constant 1 : index
              air.channel.get  @outA[%c3_68, %c1_69] (%alloc_65[34] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_70 = arith.constant 3 : index
              %c2_71 = arith.constant 2 : index
              air.channel.get  @outA[%c3_70, %c2_71] (%alloc_65[66] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_72 = arith.constant 3 : index
              %c3_73 = arith.constant 3 : index
              air.channel.get  @outA[%c3_72, %c3_73] (%alloc_65[98] [32] [1]) : (memref<130xbf16, 1 : i32>)
              %c3_74 = arith.constant 3 : index
              air.channel.put  @toMain[%c3_74] (%alloc_65[0] [130] [1]) : (memref<130xbf16, 1 : i32>)
              memref.dealloc %alloc_65 : memref<130xbf16, 1 : i32>
              %alloc_75 = memref.alloc() {air.memtile_col = 4 : i32} : memref<514xbf16, 1 : i32>
              %c0_76 = arith.constant 0 : index
              air.channel.get  @toMain[%c0_76] (%alloc_75[0] [130] [1]) : (memref<514xbf16, 1 : i32>)
              %c1_77 = arith.constant 1 : index
              air.channel.get  @toMain[%c1_77] (%alloc_75[130] [128] [1]) : (memref<514xbf16, 1 : i32>)
              %c2_78 = arith.constant 2 : index
              air.channel.get  @toMain[%c2_78] (%alloc_75[258] [128] [1]) : (memref<514xbf16, 1 : i32>)
              %c3_79 = arith.constant 3 : index
              air.channel.get  @toMain[%c3_79] (%alloc_75[386] [128] [1]) : (memref<514xbf16, 1 : i32>)
              %c0_80 = arith.constant 0 : index
              %c0_81 = arith.constant 0 : index
              air.channel.put  @outY[%c0_80, %c0_81] (%alloc_75[0] [514] [1]) : (memref<514xbf16, 1 : i32>)
              memref.dealloc %alloc_75 : memref<514xbf16, 1 : i32>
            }
          }
          %c1_16 = arith.constant 1 : index
          %c1_17 = arith.constant 1 : index
          air.herd @rope  tile (%arg17, %arg18) in (%arg19=%c1_16, %arg20=%c1_17) args(%arg21=%6) : i32 attributes {link_with = "rope.o", x_loc = 2 : i64, y_loc = 3 : i64} {
            %8 = arith.index_cast %arg21 : i32 to index
            scf.index_switch %8 
            case 0 {
              scf.yield
            }
            default {
              %alloc_34 = memref.alloc() : memref<2560xbf16, 2 : i32>
              %c0_35 = arith.constant 0 : index
              %c0_36 = arith.constant 0 : index
              air.channel.get  @outY[%c0_35, %c0_36] (%alloc_34[0] [512] [1]) : (memref<2560xbf16, 2 : i32>)
              %c0_37 = arith.constant 0 : index
              %c0_38 = arith.constant 0 : index
              air.channel.get  @outY[%c0_37, %c0_38] (%alloc_34[512] [512] [1]) : (memref<2560xbf16, 2 : i32>)
              %c0_39 = arith.constant 0 : index
              %c0_40 = arith.constant 0 : index
              air.channel.get  @outY[%c0_39, %c0_40] (%alloc_34[1024] [512] [1]) : (memref<2560xbf16, 2 : i32>)
              %c0_41 = arith.constant 0 : index
              %c0_42 = arith.constant 0 : index
              air.channel.get  @outY[%c0_41, %c0_42] (%alloc_34[1536] [512] [1]) : (memref<2560xbf16, 2 : i32>)
              %c0_43 = arith.constant 0 : index
              %c0_44 = arith.constant 0 : index
              air.channel.get  @outY[%c0_43, %c0_44] (%alloc_34[2048] [512] [1]) : (memref<2560xbf16, 2 : i32>)
              %alloc_45 = memref.alloc() : memref<2688xbf16, 2 : i32>
              %c0_46 = arith.constant 0 : index
              air.channel.get  @ropeLUT[%c0_46] (%alloc_45[] [] []) : (memref<2688xbf16, 2 : i32>)
              %alloc_47 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %alloc_48 = memref.alloc() : memref<256xbf16, 2 : i32>
              %alloc_49 = memref.alloc() : memref<256xbf16, 2 : i32>
              func.call @rope_compute(%alloc_47, %alloc_48, %alloc_49, %alloc_34, %alloc_45, %arg21) : (memref<2048xbf16, 2 : i32>, memref<256xbf16, 2 : i32>, memref<256xbf16, 2 : i32>, memref<2560xbf16, 2 : i32>, memref<2688xbf16, 2 : i32>, i32) -> ()
              %c0_50 = arith.constant 0 : index
              air.channel.put  @ropeQ[%c0_50] (%alloc_47[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
              %c0_51 = arith.constant 0 : index
              air.channel.put  @appendK[%c0_51] (%alloc_48[0] [256] [1]) : (memref<256xbf16, 2 : i32>)
              %c0_52 = arith.constant 0 : index
              air.channel.put  @appendV[%c0_52] (%alloc_49[0] [256] [1]) : (memref<256xbf16, 2 : i32>)
              memref.dealloc %alloc_34 : memref<2560xbf16, 2 : i32>
              memref.dealloc %alloc_45 : memref<2688xbf16, 2 : i32>
              memref.dealloc %alloc_47 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_48 : memref<256xbf16, 2 : i32>
              memref.dealloc %alloc_49 : memref<256xbf16, 2 : i32>
            }
          }
          scf.index_switch %7 
          case 0 {
            scf.yield
          }
          default {
            %alloc_34 = memref.alloc() {air.memtile_col = 5 : i32, air.no_split} : memref<2048xbf16, 1 : i32>
            %c0_35 = arith.constant 0 : index
            air.channel.get  @ropeQ[%c0_35] (%alloc_34[] [] []) : (memref<2048xbf16, 1 : i32>)
            %c0_36 = arith.constant 0 : index
            air.channel.put  @toAttnQ[%c0_36] (%alloc_34[0, 0, 0] [16, 8, 8] [8, 128, 1]) : (memref<2048xbf16, 1 : i32>)
            %c1_37 = arith.constant 1 : index
            air.channel.put  @toAttnQ[%c1_37] (%alloc_34[0, 8, 0] [16, 8, 8] [8, 128, 1]) : (memref<2048xbf16, 1 : i32>)
            memref.dealloc %alloc_34 : memref<2048xbf16, 1 : i32>
          }
          %alloc = memref.alloc() : memref<192xbf16, 2 : i32>
          %c2048_i32 = arith.constant 2048 : i32
          scf.index_switch %7 
          case 0 {
            scf.yield
          }
          default {
            %c128 = arith.constant 128 : index
            %8 = affine.apply #map()[%c128]
            %c0_34 = arith.constant 0 : index
            %c1_35 = arith.constant 1 : index
            scf.for %arg17 = %c0_34 to %8 step %c1_35 {
              %alloc_36 = memref.alloc() {air.memtile_col = 4 : i32} : memref<4096xbf16, 1 : i32>
              %alloc_37 = memref.alloc() {air.memtile_col = 4 : i32} : memref<4096xbf16, 1 : i32>
              %c0_38 = arith.constant 0 : index
              air.channel.get  @inKV_K[%c0_38] (%alloc_36[] [] []) : (memref<4096xbf16, 1 : i32>)
              %c0_39 = arith.constant 0 : index
              air.channel.get  @inKV_V[%c0_39] (%alloc_37[] [] []) : (memref<4096xbf16, 1 : i32>)
              %c0_40 = arith.constant 0 : index
              air.channel.put  @toK[%c0_40] (%alloc_36[0, 0, 0] [16, 16, 8] [8, 256, 1]) : (memref<4096xbf16, 1 : i32>)
              %c0_41 = arith.constant 0 : index
              air.channel.put  @toV[%c0_41] (%alloc_37[0, 0, 0, 0] [2, 16, 8, 8] [2048, 8, 256, 1]) : (memref<4096xbf16, 1 : i32>)
              %c1_42 = arith.constant 1 : index
              air.channel.put  @toK[%c1_42] (%alloc_36[0, 0, 128] [16, 16, 8] [8, 256, 1]) : (memref<4096xbf16, 1 : i32>)
              %c1_43 = arith.constant 1 : index
              air.channel.put  @toV[%c1_43] (%alloc_37[0, 0, 0, 128] [2, 16, 8, 8] [2048, 8, 256, 1]) : (memref<4096xbf16, 1 : i32>)
              memref.dealloc %alloc_36 : memref<4096xbf16, 1 : i32>
              memref.dealloc %alloc_37 : memref<4096xbf16, 1 : i32>
            }
          }
          %alloc_18 = memref.alloc() : memref<192xbf16, 2 : i32>
          %c2048_i32_19 = arith.constant 2048 : i32
          scf.index_switch %7 
          case 0 {
            scf.yield
          }
          default {
          }
          %c1_20 = arith.constant 1 : index
          %c4 = arith.constant 4 : index
          air.herd @attn_blk  tile (%arg17, %arg18) in (%arg19=%c1_20, %arg20=%c4) args(%arg21=%alloc, %arg22=%alloc_18, %arg23=%c2048_i32, %arg24=%6) : memref<192xbf16, 2 : i32>, memref<192xbf16, 2 : i32>, i32, i32 attributes {x_loc = 4 : i64, y_loc = 2 : i64} {
            %8 = arith.index_cast %arg24 : i32 to index
            scf.index_switch %8 
            case 0 {
              scf.yield
            }
            default {
              %c2_34 = arith.constant 2 : index
              %9 = arith.cmpi slt, %arg18, %c2_34 : index
              scf.if %9 {
                %c0_35 = arith.constant 0 : index
                %10 = arith.cmpi eq, %arg18, %c0_35 : index
                scf.if %10 {
                  %alloc_36 = memref.alloc() : memref<1024xbf16, 2 : i32>
                  %c0_37 = arith.constant 0 : index
                  air.channel.get  @toAttnQ[%c0_37] (%alloc_36[] [] []) : (memref<1024xbf16, 2 : i32>)
                  %alloc_38 = memref.alloc() : memref<16xbf16, 2 : i32>
                  %alloc_39 = memref.alloc() : memref<8xf32, 2 : i32>
                  %c128 = arith.constant 128 : index
                  %11 = affine.apply #map()[%c128]
                  %c0_40 = arith.constant 0 : index
                  %c1_41 = arith.constant 1 : index
                  scf.for %arg25 = %c0_40 to %11 step %c1_41 {
                    %alloc_42 = memref.alloc() : memref<2048xbf16, 2 : i32>
                    %c0_43 = arith.constant 0 : index
                    air.channel.get  @toK[%c0_43] (%alloc_42[] [] []) : (memref<2048xbf16, 2 : i32>)
                    %12 = affine.apply #map()[%arg25]
                    %13 = arith.index_cast %12 : index to i32
                    func.call @attn_qk_blk(%alloc_36, %alloc_42, %alloc_38, %alloc_39, %arg21, %13, %arg23) : (memref<1024xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<16xbf16, 2 : i32>, memref<8xf32, 2 : i32>, memref<192xbf16, 2 : i32>, i32, i32) -> ()
                    memref.dealloc %alloc_42 : memref<2048xbf16, 2 : i32>
                  }
                  memref.dealloc %alloc_36 : memref<1024xbf16, 2 : i32>
                  memref.dealloc %alloc_38 : memref<16xbf16, 2 : i32>
                  memref.dealloc %alloc_39 : memref<8xf32, 2 : i32>
                } else {
                  %alloc_36 = memref.alloc() : memref<1024xf32, 2 : i32>
                  %alloc_37 = memref.alloc() : memref<16xf32, 2 : i32>
                  %alloc_38 = memref.alloc() : memref<1024xbf16, 2 : i32>
                  %c128 = arith.constant 128 : index
                  %11 = affine.apply #map()[%c128]
                  %c0_39 = arith.constant 0 : index
                  %c1_40 = arith.constant 1 : index
                  scf.for %arg25 = %c0_39 to %11 step %c1_40 {
                    %alloc_42 = memref.alloc() : memref<2048xbf16, 2 : i32>
                    %c0_43 = arith.constant 0 : index
                    air.channel.get  @toV[%c0_43] (%alloc_42[] [] []) : (memref<2048xbf16, 2 : i32>)
                    %12 = affine.apply #map()[%arg25]
                    %13 = arith.index_cast %12 : index to i32
                    func.call @attn_kv_blk(%arg21, %alloc_42, %alloc_36, %alloc_37, %13, %arg23) : (memref<192xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<1024xf32, 2 : i32>, memref<16xf32, 2 : i32>, i32, i32) -> ()
                    memref.dealloc %alloc_42 : memref<2048xbf16, 2 : i32>
                  }
                  func.call @attn_kv_fin(%alloc_36, %alloc_37, %alloc_38) : (memref<1024xf32, 2 : i32>, memref<16xf32, 2 : i32>, memref<1024xbf16, 2 : i32>) -> ()
                  %c0_41 = arith.constant 0 : index
                  air.channel.put  @attnO[%c0_41] (%alloc_38[0, 0, 0] [8, 16, 8] [8, 64, 1]) : (memref<1024xbf16, 2 : i32>)
                  memref.dealloc %alloc_38 : memref<1024xbf16, 2 : i32>
                  memref.dealloc %alloc_36 : memref<1024xf32, 2 : i32>
                  memref.dealloc %alloc_37 : memref<16xf32, 2 : i32>
                }
              } else {
                %c2_35 = arith.constant 2 : index
                %10 = arith.cmpi eq, %arg18, %c2_35 : index
                scf.if %10 {
                  %alloc_36 = memref.alloc() : memref<1024xbf16, 2 : i32>
                  %c1_37 = arith.constant 1 : index
                  air.channel.get  @toAttnQ[%c1_37] (%alloc_36[] [] []) : (memref<1024xbf16, 2 : i32>)
                  %alloc_38 = memref.alloc() : memref<16xbf16, 2 : i32>
                  %alloc_39 = memref.alloc() : memref<8xf32, 2 : i32>
                  %c128 = arith.constant 128 : index
                  %11 = affine.apply #map()[%c128]
                  %c0_40 = arith.constant 0 : index
                  %c1_41 = arith.constant 1 : index
                  scf.for %arg25 = %c0_40 to %11 step %c1_41 {
                    %alloc_42 = memref.alloc() : memref<2048xbf16, 2 : i32>
                    %c1_43 = arith.constant 1 : index
                    air.channel.get  @toK[%c1_43] (%alloc_42[] [] []) : (memref<2048xbf16, 2 : i32>)
                    %12 = affine.apply #map()[%arg25]
                    %13 = arith.index_cast %12 : index to i32
                    func.call @attn_qk_blk(%alloc_36, %alloc_42, %alloc_38, %alloc_39, %arg22, %13, %arg23) : (memref<1024xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<16xbf16, 2 : i32>, memref<8xf32, 2 : i32>, memref<192xbf16, 2 : i32>, i32, i32) -> ()
                    memref.dealloc %alloc_42 : memref<2048xbf16, 2 : i32>
                  }
                  memref.dealloc %alloc_36 : memref<1024xbf16, 2 : i32>
                  memref.dealloc %alloc_38 : memref<16xbf16, 2 : i32>
                  memref.dealloc %alloc_39 : memref<8xf32, 2 : i32>
                } else {
                  %alloc_36 = memref.alloc() : memref<1024xf32, 2 : i32>
                  %alloc_37 = memref.alloc() : memref<16xf32, 2 : i32>
                  %alloc_38 = memref.alloc() : memref<1024xbf16, 2 : i32>
                  %c128 = arith.constant 128 : index
                  %11 = affine.apply #map()[%c128]
                  %c0_39 = arith.constant 0 : index
                  %c1_40 = arith.constant 1 : index
                  scf.for %arg25 = %c0_39 to %11 step %c1_40 {
                    %alloc_42 = memref.alloc() : memref<2048xbf16, 2 : i32>
                    %c1_43 = arith.constant 1 : index
                    air.channel.get  @toV[%c1_43] (%alloc_42[] [] []) : (memref<2048xbf16, 2 : i32>)
                    %12 = affine.apply #map()[%arg25]
                    %13 = arith.index_cast %12 : index to i32
                    func.call @attn_kv_blk(%arg22, %alloc_42, %alloc_36, %alloc_37, %13, %arg23) : (memref<192xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<1024xf32, 2 : i32>, memref<16xf32, 2 : i32>, i32, i32) -> ()
                    memref.dealloc %alloc_42 : memref<2048xbf16, 2 : i32>
                  }
                  func.call @attn_kv_fin(%alloc_36, %alloc_37, %alloc_38) : (memref<1024xf32, 2 : i32>, memref<16xf32, 2 : i32>, memref<1024xbf16, 2 : i32>) -> ()
                  %c1_41 = arith.constant 1 : index
                  air.channel.put  @attnO[%c1_41] (%alloc_38[0, 0, 0] [8, 16, 8] [8, 64, 1]) : (memref<1024xbf16, 2 : i32>)
                  memref.dealloc %alloc_38 : memref<1024xbf16, 2 : i32>
                  memref.dealloc %alloc_36 : memref<1024xf32, 2 : i32>
                  memref.dealloc %alloc_37 : memref<16xf32, 2 : i32>
                }
              }
            }
          }
          memref.dealloc %alloc_18 : memref<192xbf16, 2 : i32>
          memref.dealloc %alloc : memref<192xbf16, 2 : i32>
          scf.index_switch %7 
          case 0 {
            scf.yield
          }
          default {
            %alloc_34 = memref.alloc() {air.memtile_col = 5 : i32} : memref<2048xbf16, 1 : i32>
            %c0_35 = arith.constant 0 : index
            air.channel.get  @attnO[%c0_35] (%alloc_34[0] [1024] [1]) : (memref<2048xbf16, 1 : i32>)
            %c1_36 = arith.constant 1 : index
            air.channel.get  @attnO[%c1_36] (%alloc_34[1024] [1024] [1]) : (memref<2048xbf16, 1 : i32>)
            %c0_37 = arith.constant 0 : index
            %c4_38 = arith.constant 4 : index
            %c1_39 = arith.constant 1 : index
            scf.for %arg17 = %c0_37 to %c4_38 step %c1_39 {
              %c0_40 = arith.constant 0 : index
              air.channel.put  @xnorm[%c0_40] (%alloc_34[0] [2048] [1]) : (memref<2048xbf16, 1 : i32>)
            }
            memref.dealloc %alloc_34 : memref<2048xbf16, 1 : i32>
          }
          %c1_21 = arith.constant 1 : index
          %c1_22 = arith.constant 1 : index
          air.herd @glu  tile (%arg17, %arg18) in (%arg19=%c1_21, %arg20=%c1_22) args(%arg21=%6) : i32 attributes {link_with = "glu.o", x_loc = 5 : i64, y_loc = 3 : i64} {
            %8 = arith.index_cast %arg21 : i32 to index
            scf.index_switch %8 
            case 0 {
              scf.yield
            }
            default {
              %c0_34 = arith.constant 0 : index
              %c11 = arith.constant 11 : index
              %c1_35 = arith.constant 1 : index
              scf.for %arg22 = %c0_34 to %c11 step %c1_35 {
                %alloc_36 = memref.alloc() : memref<1024xbf16, 2 : i32>
                %c0_37 = arith.constant 0 : index
                %c2_38 = arith.constant 2 : index
                air.channel.get  @outY[%c0_37, %c2_38] (%alloc_36[0] [1024] [1]) : (memref<1024xbf16, 2 : i32>)
                %alloc_39 = memref.alloc() : memref<512xbf16, 2 : i32>
                func.call @glu_aie(%alloc_39, %alloc_36, %arg21) : (memref<512xbf16, 2 : i32>, memref<1024xbf16, 2 : i32>, i32) -> ()
                air.channel.put  @gluOut[] (%alloc_39[0] [512] [1]) : (memref<512xbf16, 2 : i32>)
                memref.dealloc %alloc_36 : memref<1024xbf16, 2 : i32>
                memref.dealloc %alloc_39 : memref<512xbf16, 2 : i32>
                %alloc_40 = memref.alloc() : memref<1024xbf16, 2 : i32>
                %c0_41 = arith.constant 0 : index
                %c2_42 = arith.constant 2 : index
                air.channel.get  @outY[%c0_41, %c2_42] (%alloc_40[0] [1024] [1]) : (memref<1024xbf16, 2 : i32>)
                %alloc_43 = memref.alloc() : memref<512xbf16, 2 : i32>
                func.call @glu_aie(%alloc_43, %alloc_40, %arg21) : (memref<512xbf16, 2 : i32>, memref<1024xbf16, 2 : i32>, i32) -> ()
                air.channel.put  @gluOut[] (%alloc_43[0] [512] [1]) : (memref<512xbf16, 2 : i32>)
                memref.dealloc %alloc_40 : memref<1024xbf16, 2 : i32>
                memref.dealloc %alloc_43 : memref<512xbf16, 2 : i32>
              }
            }
          }
          %alloc_23 = memref.alloc() {air.memtile_col = 3 : i32} : memref<11264xbf16, 1 : i32>
          %c0_24 = arith.constant 0 : index
          %c22 = arith.constant 22 : index
          %c1_25 = arith.constant 1 : index
          scf.for %arg17 = %c0_24 to %c22 step %c1_25 {
            %8 = affine.apply #map5()[%arg17]
            air.channel.get  @gluOut[] (%alloc_23[%8] [512] [1]) : (memref<11264xbf16, 1 : i32>)
          }
          %c0_26 = arith.constant 0 : index
          %c4_27 = arith.constant 4 : index
          %c1_28 = arith.constant 1 : index
          scf.for %arg17 = %c0_26 to %c4_27 step %c1_28 {
            air.channel.put  @xnorm[] (%alloc_23[0] [11264] [1]) : (memref<11264xbf16, 1 : i32>)
          }
          memref.dealloc %alloc_23 : memref<11264xbf16, 1 : i32>
          %c2 = arith.constant 2 : index
          %c4_29 = arith.constant 4 : index
          air.herd @proj_blk0  tile (%arg17, %arg18) in (%arg19=%c2, %arg20=%c4_29) args(%arg21=%6) : i32 attributes {link_with = "proj_qmm.o", x_loc = 0 : i64, y_loc = 2 : i64} {
            %c0_34 = arith.constant 0 : index
            %8 = arith.addi %c0_34, %arg17 : index
            %c5 = arith.constant 5 : index
            %c4_35 = arith.constant 4 : index
            %c44 = arith.constant 44 : index
            %c4_36 = arith.constant 4 : index
            %c4_37 = arith.constant 4 : index
            %c4_38 = arith.constant 4 : index
            %c4_39 = arith.constant 4 : index
            %c22_40 = arith.constant 22 : index
            %c0_41 = arith.constant 0 : index
            %c1_42 = arith.constant 1 : index
            %c2_43 = arith.constant 2 : index
            %c1_44 = arith.constant 1 : index
            %c2_45 = arith.constant 2 : index
            %c0_i32_46 = arith.constant 0 : i32
            %9 = arith.index_cast %arg21 : i32 to index
            %c1_47 = arith.constant 1 : index
            %c1_48 = arith.constant 1 : index
            %10 = scf.index_switch %9 -> index 
            case 0 {
              scf.yield %c1_48 : index
            }
            default {
              %c4_51 = arith.constant 4 : index
              scf.yield %c4_51 : index
            }
            %c0_49 = arith.constant 0 : index
            %c1_50 = arith.constant 1 : index
            scf.for %arg22 = %c0_49 to %10 step %c1_50 {
              %c12 = arith.constant 12 : index
              %11 = scf.index_switch %9 -> index 
              case 0 {
                scf.yield %c12 : index
              }
              default {
                %14 = scf.index_switch %arg22 -> index 
                case 0 {
                  scf.yield %c5 : index
                }
                case 1 {
                  scf.yield %c4_35 : index
                }
                case 2 {
                  scf.yield %c44 : index
                }
                default {
                  scf.yield %c4_36 : index
                }
                scf.yield %14 : index
              }
              %c4_51 = arith.constant 4 : index
              %12 = scf.index_switch %9 -> index 
              case 0 {
                scf.yield %c4_51 : index
              }
              default {
                %14 = scf.index_switch %arg22 -> index 
                case 0 {
                  scf.yield %c4_37 : index
                }
                case 1 {
                  scf.yield %c4_38 : index
                }
                case 2 {
                  scf.yield %c4_39 : index
                }
                default {
                  scf.yield %c22_40 : index
                }
                scf.yield %14 : index
              }
              %13 = scf.index_switch %9 -> index 
              case 0 {
                scf.yield %c1_47 : index
              }
              default {
                %14 = scf.index_switch %arg22 -> index 
                case 0 {
                  scf.yield %c0_41 : index
                }
                case 1 {
                  scf.yield %c1_42 : index
                }
                case 2 {
                  scf.yield %c2_43 : index
                }
                default {
                  scf.yield %c1_44 : index
                }
                scf.yield %14 : index
              }
              %c0_52 = arith.constant 0 : index
              %c1_53 = arith.constant 1 : index
              scf.for %arg23 = %c0_52 to %11 step %c1_53 {
                %14 = arith.muli %12, %c2_45 : index
                %alloc_54 = memref.alloc() : memref<32xf32, 2 : i32>
                func.call @proj_qmm_zero(%alloc_54, %arg21) : (memref<32xf32, 2 : i32>, i32) -> ()
                %15 = affine.apply #map()[%14]
                %c0_55 = arith.constant 0 : index
                %c1_56 = arith.constant 1 : index
                %c5_57 = arith.constant 5 : index
                scf.for %arg24 = %c0_55 to %15 step %c5_57 {
                  %19 = arith.subi %15, %arg24 : index
                  %20 = arith.minsi %c5_57, %19 : index
                  scf.for %arg25 = %c0_55 to %20 step %c1_56 {
                    %alloc_59 = memref.alloc() : memref<256xbf16, 2 : i32>
                    %21 = affine.apply #map()[%8]
                    %22 = affine.apply #map()[%arg18]
                    air.channel.get  @inX[%21, %22] (%alloc_59[] [] []) : (memref<256xbf16, 2 : i32>)
                    %alloc_60 = memref.alloc() : memref<2560xbf16, 2 : i32>
                    %23 = affine.apply #map()[%8]
                    %24 = affine.apply #map()[%arg18]
                    air.channel.get  @wL2ToL1[%23, %24] (%alloc_60[] [] []) : (memref<2560xbf16, 2 : i32>)
                    func.call @proj_qmm_acc256(%alloc_59, %alloc_60, %alloc_54) : (memref<256xbf16, 2 : i32>, memref<2560xbf16, 2 : i32>, memref<32xf32, 2 : i32>) -> ()
                    memref.dealloc %alloc_59 : memref<256xbf16, 2 : i32>
                    memref.dealloc %alloc_60 : memref<2560xbf16, 2 : i32>
                  }
                }
                %alloc_58 = memref.alloc() : memref<48xbf16, 2 : i32>
                func.call @proj_qmm_flush_row(%alloc_54, %alloc_58, %c0_i32_46) : (memref<32xf32, 2 : i32>, memref<48xbf16, 2 : i32>, i32) -> ()
                %16 = affine.apply #map()[%13]
                %17 = affine.apply #map()[%8]
                %18 = affine.apply #map()[%arg18]
                air.channel.put  @outA[%17, %18] (%alloc_58[14] [34] [1]) dest(%16) : (memref<48xbf16, 2 : i32>)
                memref.dealloc %alloc_58 : memref<48xbf16, 2 : i32>
                memref.dealloc %alloc_54 : memref<32xf32, 2 : i32>
              }
            }
          }
          %c2_30 = arith.constant 2 : index
          %c4_31 = arith.constant 4 : index
          air.herd @proj_blk1  tile (%arg17, %arg18) in (%arg19=%c2_30, %arg20=%c4_31) args(%arg21=%6) : i32 attributes {link_with = "proj_qmm.o", x_loc = 6 : i64, y_loc = 2 : i64} {
            %c2_34 = arith.constant 2 : index
            %8 = arith.addi %c2_34, %arg17 : index
            %c5 = arith.constant 5 : index
            %c4_35 = arith.constant 4 : index
            %c44 = arith.constant 44 : index
            %c4_36 = arith.constant 4 : index
            %c4_37 = arith.constant 4 : index
            %c4_38 = arith.constant 4 : index
            %c4_39 = arith.constant 4 : index
            %c22_40 = arith.constant 22 : index
            %c0_41 = arith.constant 0 : index
            %c1_42 = arith.constant 1 : index
            %c2_43 = arith.constant 2 : index
            %c1_44 = arith.constant 1 : index
            %c2_45 = arith.constant 2 : index
            %c0_i32_46 = arith.constant 0 : i32
            %9 = arith.index_cast %arg21 : i32 to index
            %c1_47 = arith.constant 1 : index
            %c1_48 = arith.constant 1 : index
            %10 = scf.index_switch %9 -> index 
            case 0 {
              scf.yield %c1_48 : index
            }
            default {
              %c4_51 = arith.constant 4 : index
              scf.yield %c4_51 : index
            }
            %c0_49 = arith.constant 0 : index
            %c1_50 = arith.constant 1 : index
            scf.for %arg22 = %c0_49 to %10 step %c1_50 {
              %c12 = arith.constant 12 : index
              %11 = scf.index_switch %9 -> index 
              case 0 {
                scf.yield %c12 : index
              }
              default {
                %14 = scf.index_switch %arg22 -> index 
                case 0 {
                  scf.yield %c5 : index
                }
                case 1 {
                  scf.yield %c4_35 : index
                }
                case 2 {
                  scf.yield %c44 : index
                }
                default {
                  scf.yield %c4_36 : index
                }
                scf.yield %14 : index
              }
              %c4_51 = arith.constant 4 : index
              %12 = scf.index_switch %9 -> index 
              case 0 {
                scf.yield %c4_51 : index
              }
              default {
                %14 = scf.index_switch %arg22 -> index 
                case 0 {
                  scf.yield %c4_37 : index
                }
                case 1 {
                  scf.yield %c4_38 : index
                }
                case 2 {
                  scf.yield %c4_39 : index
                }
                default {
                  scf.yield %c22_40 : index
                }
                scf.yield %14 : index
              }
              %13 = scf.index_switch %9 -> index 
              case 0 {
                scf.yield %c1_47 : index
              }
              default {
                %14 = scf.index_switch %arg22 -> index 
                case 0 {
                  scf.yield %c0_41 : index
                }
                case 1 {
                  scf.yield %c1_42 : index
                }
                case 2 {
                  scf.yield %c2_43 : index
                }
                default {
                  scf.yield %c1_44 : index
                }
                scf.yield %14 : index
              }
              %c0_52 = arith.constant 0 : index
              %c1_53 = arith.constant 1 : index
              scf.for %arg23 = %c0_52 to %11 step %c1_53 {
                %14 = arith.muli %12, %c2_45 : index
                %alloc_54 = memref.alloc() : memref<32xf32, 2 : i32>
                func.call @proj_qmm_zero(%alloc_54, %arg21) : (memref<32xf32, 2 : i32>, i32) -> ()
                %15 = affine.apply #map()[%14]
                %c0_55 = arith.constant 0 : index
                %c1_56 = arith.constant 1 : index
                scf.for %arg24 = %c0_55 to %15 step %c1_56 {
                  %alloc_58 = memref.alloc() : memref<256xbf16, 2 : i32>
                  %19 = affine.apply #map()[%8]
                  %20 = affine.apply #map()[%arg18]
                  air.channel.get  @inX[%19, %20] (%alloc_58[] [] []) : (memref<256xbf16, 2 : i32>)
                  %alloc_59 = memref.alloc() : memref<2560xbf16, 2 : i32>
                  %21 = affine.apply #map()[%8]
                  %22 = affine.apply #map()[%arg18]
                  air.channel.get  @wL2ToL1[%21, %22] (%alloc_59[] [] []) : (memref<2560xbf16, 2 : i32>)
                  func.call @proj_qmm_acc256(%alloc_58, %alloc_59, %alloc_54) : (memref<256xbf16, 2 : i32>, memref<2560xbf16, 2 : i32>, memref<32xf32, 2 : i32>) -> ()
                  memref.dealloc %alloc_58 : memref<256xbf16, 2 : i32>
                  memref.dealloc %alloc_59 : memref<2560xbf16, 2 : i32>
                }
                %alloc_57 = memref.alloc() : memref<48xbf16, 2 : i32>
                func.call @proj_qmm_flush_row(%alloc_54, %alloc_57, %c0_i32_46) : (memref<32xf32, 2 : i32>, memref<48xbf16, 2 : i32>, i32) -> ()
                %16 = affine.apply #map()[%13]
                %17 = affine.apply #map()[%8]
                %18 = affine.apply #map()[%arg18]
                air.channel.put  @outA[%17, %18] (%alloc_57[14] [34] [1]) dest(%16) : (memref<48xbf16, 2 : i32>)
                memref.dealloc %alloc_57 : memref<48xbf16, 2 : i32>
                memref.dealloc %alloc_54 : memref<32xf32, 2 : i32>
              }
            }
          }
          %c1_32 = arith.constant 1 : index
          %c1_33 = arith.constant 1 : index
          air.herd @rms  tile (%arg17, %arg18) in (%arg19=%c1_32, %arg20=%c1_33) args(%arg21=%6) : i32 attributes {link_with = "rms_residual.o", x_loc = 2 : i64, y_loc = 2 : i64} {
            %8 = arith.index_cast %arg21 : i32 to index
            %9 = affine.apply #map()[%8]
            scf.index_switch %9 
            case 0 {
              %alloc_34 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_35 = arith.constant 0 : index
              air.channel.get  @rmsX[%c0_35] (%alloc_34[] [] []) : (memref<2048xbf16, 2 : i32>)
              %alloc_36 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_37 = arith.constant 0 : index
              air.channel.get  @rmsW[%c0_37] (%alloc_36[] [] []) : (memref<2048xbf16, 2 : i32>)
              %alloc_38 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_39 = arith.constant 0 : index
              air.channel.get  @rmsW2[%c0_39] (%alloc_38[] [] []) : (memref<2048xbf16, 2 : i32>)
              memref.dealloc %alloc_38 : memref<2048xbf16, 2 : i32>
              %alloc_40 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %alloc_41 = memref.alloc() : memref<2048xbf16, 2 : i32>
              func.call @rms_norm_aie(%alloc_40, %alloc_34, %alloc_36, %arg21) : (memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, i32) -> ()
              %c0_42 = arith.constant 0 : index
              %c3 = arith.constant 3 : index
              %c1_43 = arith.constant 1 : index
              scf.for %arg22 = %c0_42 to %c3 step %c1_43 {
                %c0_44 = arith.constant 0 : index
                %c4_45 = arith.constant 4 : index
                %c1_46 = arith.constant 1 : index
                scf.for %arg23 = %c0_44 to %c4_45 step %c1_46 {
                  air.channel.put  @xnorm[] (%alloc_40[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
                }
                %c0_47 = arith.constant 0 : index
                %c1_48 = arith.constant 1 : index
                air.channel.get  @outY[%c0_47, %c1_48] (%alloc_41[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
                air.channel.put  @layerOut[] (%alloc_41[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
              }
              memref.dealloc %alloc_34 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_36 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_40 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_41 : memref<2048xbf16, 2 : i32>
              scf.yield
            }
            default {
              %alloc_34 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_35 = arith.constant 0 : index
              air.channel.get  @rmsX[%c0_35] (%alloc_34[] [] []) : (memref<2048xbf16, 2 : i32>)
              %alloc_36 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_37 = arith.constant 0 : index
              air.channel.get  @rmsW[%c0_37] (%alloc_36[] [] []) : (memref<2048xbf16, 2 : i32>)
              %alloc_38 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_39 = arith.constant 0 : index
              air.channel.get  @rmsW2[%c0_39] (%alloc_38[] [] []) : (memref<2048xbf16, 2 : i32>)
              %alloc_40 = memref.alloc() : memref<2048xbf16, 2 : i32>
              func.call @rms_norm_aie(%alloc_40, %alloc_34, %alloc_36, %arg21) : (memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, i32) -> ()
              %c0_41 = arith.constant 0 : index
              %c5 = arith.constant 5 : index
              %c1_42 = arith.constant 1 : index
              scf.for %arg22 = %c0_41 to %c5 step %c1_42 {
                air.channel.put  @xnorm[] (%alloc_40[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
              }
              %alloc_43 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_44 = arith.constant 0 : index
              %c1_45 = arith.constant 1 : index
              air.channel.get  @outY[%c0_44, %c1_45] (%alloc_43[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
              %alloc_46 = memref.alloc() : memref<2048xbf16, 2 : i32>
              func.call @residual_add_aie(%alloc_46, %alloc_34, %alloc_43) : (memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>) -> ()
              memref.dealloc %alloc_34 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_43 : memref<2048xbf16, 2 : i32>
              func.call @rms_norm_aie(%alloc_40, %alloc_46, %alloc_38, %arg21) : (memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, i32) -> ()
              %c0_47 = arith.constant 0 : index
              %c44 = arith.constant 44 : index
              %c1_48 = arith.constant 1 : index
              scf.for %arg22 = %c0_47 to %c44 step %c1_48 {
                air.channel.put  @xnorm[] (%alloc_40[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
              }
              memref.dealloc %alloc_40 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_36 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_38 : memref<2048xbf16, 2 : i32>
              %alloc_49 = memref.alloc() : memref<2048xbf16, 2 : i32>
              %c0_50 = arith.constant 0 : index
              %c1_51 = arith.constant 1 : index
              air.channel.get  @outY[%c0_50, %c1_51] (%alloc_49[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
              %alloc_52 = memref.alloc() : memref<2048xbf16, 2 : i32>
              func.call @residual_add_aie(%alloc_52, %alloc_46, %alloc_49) : (memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>, memref<2048xbf16, 2 : i32>) -> ()
              memref.dealloc %alloc_46 : memref<2048xbf16, 2 : i32>
              memref.dealloc %alloc_49 : memref<2048xbf16, 2 : i32>
              air.channel.put  @layerOut[] (%alloc_52[0] [2048] [1]) : (memref<2048xbf16, 2 : i32>)
              memref.dealloc %alloc_52 : memref<2048xbf16, 2 : i32>
            }
          }
        }
      }
    }
    return
  }
}
