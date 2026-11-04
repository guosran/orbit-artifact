#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> (), sym_name = "ffn"}> ({
  ^bb0(%arg0: memref<5x2048xf32>, %arg1: memref<2048x11008xf32>, %arg2: memref<2048x11008xf32>, %arg3: memref<11008x2048xf32>, %arg4: memref<5x2048xf32>, %arg5: memref<5x11008xf32>, %arg6: memref<5x11008xf32>, %arg7: memref<5x11008xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg285: index, %arg286: index, %arg287: index, %arg288: index, %arg289: memref<5x2048xf32>, %arg290: memref<2048x11008xf32>, %arg291: memref<2048x11008xf32>, %arg292: memref<11008x2048xf32>, %arg293: memref<5x2048xf32>, %arg294: memref<5x11008xf32>, %arg295: memref<5x11008xf32>, %arg296: memref<5x11008xf32>):
      "air.segment"(%arg289, %arg290, %arg291, %arg292, %arg293, %arg294, %arg295, %arg296) ({
      ^bb0(%arg297: memref<5x2048xf32>, %arg298: memref<2048x11008xf32>, %arg299: memref<2048x11008xf32>, %arg300: memref<11008x2048xf32>, %arg301: memref<5x2048xf32>, %arg302: memref<5x11008xf32>, %arg303: memref<5x11008xf32>, %arg304: memref<5x11008xf32>):
        %604 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%604, %604, %arg297, %arg298, %arg299, %arg300, %arg301, %arg302, %arg303, %arg304) ({
        ^bb0(%arg305: index, %arg306: index, %arg307: index, %arg308: index, %arg309: memref<5x2048xf32>, %arg310: memref<2048x11008xf32>, %arg311: memref<2048x11008xf32>, %arg312: memref<11008x2048xf32>, %arg313: memref<5x2048xf32>, %arg314: memref<5x11008xf32>, %arg315: memref<5x11008xf32>, %arg316: memref<5x11008xf32>):
          %605 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %606 = "arith.constant"() <{value = 64 : index}> : () -> index
          %607 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %608 = "arith.constant"() <{value = 32 : index}> : () -> index
          %609 = "arith.constant"() <{value = 1 : index}> : () -> index
          %610 = "arith.constant"() <{value = 344 : index}> : () -> index
          %611 = "arith.constant"() <{value = 0 : index}> : () -> index
          %612 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.32.64"} : () -> memref<256xf32, 2 : i32>
          %613 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.32.loops.4.32.64"} : () -> memref<2048xf32, 2 : i32>
          %614 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : () -> memref<128xf32, 2 : i32>
          %615 = "air.wait_all"() : () -> !air.async.token
          %616 = "scf.for"(%611, %610, %609, %615) ({
          ^bb0(%arg317: index, %arg318: !air.async.token):
            %617 = "arith.muli"(%arg317, %608) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %618 = "arith.muli"(%arg317, %608) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %619 = "arith.muli"(%arg317, %608) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %620 = "memref.reinterpret_cast"(%614) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gate.initialize", orbit.phase = 688 : i64, orbit.storage = "G"} : (memref<128xf32, 2 : i32>) -> memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %621 = "arith.constant"() <{value = 0 : index}> : () -> index
            %622 = "arith.constant"() <{value = 4 : index}> : () -> index
            %623 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%621, %622, %623) ({
            ^bb0(%arg324: index):
              %679 = "arith.constant"() <{value = 0 : index}> : () -> index
              %680 = "arith.constant"() <{value = 32 : index}> : () -> index
              %681 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%679, %680, %681) ({
              ^bb0(%arg325: index):
                %682 = "arith.addi"(%arg325, %617) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %683 = "arith.subi"(%682, %619) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%607, %620, %arg324, %683) <{nontemporal = false}> : (f32, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %624 = "scf.for"(%611, %608, %609, %arg318) ({
            ^bb0(%arg319: index, %arg320: !air.async.token):
              %627 = "arith.muli"(%arg319, %606) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %628 = "arith.muli"(%arg319, %606) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %629 = "arith.muli"(%arg319, %606) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %630 = "memref.reinterpret_cast"(%612) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 688 : i64, orbit.storage = "X"} : (memref<256xf32, 2 : i32>) -> memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %631 = "air.dma_memcpy_nd"(%arg320, %630, %arg309, %628) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 688 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 33088>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 4, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<4x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x2048xf32>, index) -> !air.async.token
              %632 = "memref.reinterpret_cast"(%613) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 688 : i64, orbit.storage = "W_gate"} : (memref<2048xf32, 2 : i32>) -> memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %633 = "air.dma_memcpy_nd"(%arg320, %632, %arg310, %629, %618) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 688 : i64, orbit.source_copies = array<i64: 64>, orbit.storage = "W_gate", orbit.target_copies = array<i64: 33089>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x32xf32, strided<[32, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%631, %633) {orbit.computation_event = 3 : i64, orbit.phase = 688 : i64, orbit.phase_dependencies = array<i64: 687>, orbit.read_copies = array<i64: 33088, 33089, 33090>, orbit.task = "gate", orbit.write_copies = array<i64: 33091>} : (!air.async.token, !air.async.token) -> ()
              %634 = "arith.constant"() <{value = 0 : index}> : () -> index
              %635 = "arith.constant"() <{value = 4 : index}> : () -> index
              %636 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%634, %635, %636) ({
              ^bb0(%arg321: index):
                %638 = "arith.constant"() <{value = 0 : index}> : () -> index
                %639 = "arith.constant"() <{value = 32 : index}> : () -> index
                %640 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%638, %639, %640) ({
                ^bb0(%arg322: index):
                  %641 = "arith.addi"(%arg322, %617) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %642 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %643 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %644 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%642, %643, %644) ({
                  ^bb0(%arg323: index):
                    %645 = "arith.addi"(%arg323, %627) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %646 = "arith.subi"(%645, %628) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %647 = "memref.load"(%630, %arg321, %646) <{nontemporal = false}> : (memref<4x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %648 = "arith.subi"(%645, %629) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %649 = "arith.subi"(%641, %618) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %650 = "vector.transfer_read"(%632, %648, %649, %607) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %651 = "arith.subi"(%641, %619) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %652 = "vector.transfer_read"(%620, %arg321, %651, %607) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %653 = "vector.extract"(%650) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %654 = "func.call"(%647, %653) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %655 = "vector.insert"(%654, %605) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %656 = "vector.extract"(%650) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %657 = "func.call"(%647, %656) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %658 = "vector.insert"(%657, %655) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %659 = "vector.extract"(%650) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %660 = "func.call"(%647, %659) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %661 = "vector.insert"(%660, %658) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %662 = "vector.extract"(%650) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %663 = "func.call"(%647, %662) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %664 = "vector.insert"(%663, %661) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %665 = "vector.extract"(%650) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %666 = "func.call"(%647, %665) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %667 = "vector.insert"(%666, %664) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %668 = "vector.extract"(%650) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %669 = "func.call"(%647, %668) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %670 = "vector.insert"(%669, %667) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %671 = "vector.extract"(%650) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %672 = "func.call"(%647, %671) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %673 = "vector.insert"(%672, %670) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %674 = "vector.extract"(%650) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %675 = "func.call"(%647, %674) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %676 = "vector.insert"(%675, %673) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %677 = "arith.addf"(%652, %676) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %678 = "arith.subi"(%641, %619) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%677, %620, %arg321, %678) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %637 = "air.wait_all"(%arg320) : (!air.async.token) -> !air.async.token
              "scf.yield"(%637) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %625 = "air.dma_memcpy_nd"(%624, %arg314, %619, %620) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 719 : i64, orbit.retained_begin = 688 : i64, orbit.retained_end = 720 : i64, orbit.source_copies = array<i64: 33184>, orbit.storage = "G", orbit.target_copies = array<i64: 33185>, orbit.transfer = "l1_to_host", orbit.transfer_event = 97 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 4, 32>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<4x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %626 = "air.wait_all"(%625) : (!air.async.token) -> !air.async.token
            "scf.yield"(%626) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 344 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%616) : (!air.async.token) -> ()
          "memref.dealloc"(%612) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%613) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%614) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg244: index, %arg245: index, %arg246: index, %arg247: index, %arg248: memref<5x2048xf32>, %arg249: memref<2048x11008xf32>, %arg250: memref<2048x11008xf32>, %arg251: memref<11008x2048xf32>, %arg252: memref<5x2048xf32>, %arg253: memref<5x11008xf32>, %arg254: memref<5x11008xf32>, %arg255: memref<5x11008xf32>):
      "air.segment"(%arg248, %arg249, %arg250, %arg251, %arg252, %arg253, %arg254, %arg255) ({
      ^bb0(%arg256: memref<5x2048xf32>, %arg257: memref<2048x11008xf32>, %arg258: memref<2048x11008xf32>, %arg259: memref<11008x2048xf32>, %arg260: memref<5x2048xf32>, %arg261: memref<5x11008xf32>, %arg262: memref<5x11008xf32>, %arg263: memref<5x11008xf32>):
        %519 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%519, %519, %arg256, %arg257, %arg258, %arg259, %arg260, %arg261, %arg262, %arg263) ({
        ^bb0(%arg264: index, %arg265: index, %arg266: index, %arg267: index, %arg268: memref<5x2048xf32>, %arg269: memref<2048x11008xf32>, %arg270: memref<2048x11008xf32>, %arg271: memref<11008x2048xf32>, %arg272: memref<5x2048xf32>, %arg273: memref<5x11008xf32>, %arg274: memref<5x11008xf32>, %arg275: memref<5x11008xf32>):
          %520 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %521 = "arith.constant"() <{value = 64 : index}> : () -> index
          %522 = "arith.constant"() <{value = 4 : index}> : () -> index
          %523 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %524 = "arith.constant"() <{value = 32 : index}> : () -> index
          %525 = "arith.constant"() <{value = 1 : index}> : () -> index
          %526 = "arith.constant"() <{value = 344 : index}> : () -> index
          %527 = "arith.constant"() <{value = 0 : index}> : () -> index
          %528 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.64.loops.1.32.64"} : () -> memref<64xf32, 2 : i32>
          %529 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.64.32.loops.1.32.64"} : () -> memref<2048xf32, 2 : i32>
          %530 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data"} : () -> memref<32xf32, 2 : i32>
          %531 = "air.wait_all"() : () -> !air.async.token
          %532 = "scf.for"(%527, %526, %525, %531) ({
          ^bb0(%arg276: index, %arg277: !air.async.token):
            %533 = "arith.muli"(%arg276, %524) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %534 = "arith.muli"(%arg276, %524) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %535 = "arith.muli"(%arg276, %524) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %536 = "memref.reinterpret_cast"(%530) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "gate.initialize", orbit.phase = 11696 : i64, orbit.storage = "G"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %537 = "arith.constant"() <{value = 4 : index}> : () -> index
            %538 = "arith.constant"() <{value = 5 : index}> : () -> index
            %539 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%537, %538, %539) ({
            ^bb0(%arg283: index):
              %598 = "arith.constant"() <{value = 0 : index}> : () -> index
              %599 = "arith.constant"() <{value = 32 : index}> : () -> index
              %600 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%598, %599, %600) ({
              ^bb0(%arg284: index):
                %601 = "arith.addi"(%arg284, %533) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %602 = "arith.subi"(%arg283, %522) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %603 = "arith.subi"(%601, %535) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%523, %536, %602, %603) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %540 = "scf.for"(%527, %524, %525, %arg277) ({
            ^bb0(%arg278: index, %arg279: !air.async.token):
              %543 = "arith.muli"(%arg278, %521) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %544 = "arith.muli"(%arg278, %521) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %545 = "arith.muli"(%arg278, %521) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %546 = "memref.reinterpret_cast"(%528) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 11696 : i64, orbit.storage = "X"} : (memref<64xf32, 2 : i32>) -> memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %547 = "air.dma_memcpy_nd"(%arg279, %546, %arg268, %544) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 11696 : i64, orbit.source_copies = array<i64: 32>, orbit.storage = "X", orbit.target_copies = array<i64: 66800>, orbit.transfer = "host_to_l1", orbit.transfer_event = 33712 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 4, -9223372036854775808>, static_src_sizes = array<i64: 1, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<1x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x2048xf32>, index) -> !air.async.token
              %548 = "memref.reinterpret_cast"(%529) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 11696 : i64, orbit.storage = "W_gate"} : (memref<2048xf32, 2 : i32>) -> memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %549 = "air.dma_memcpy_nd"(%arg279, %548, %arg269, %545, %534) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 11696 : i64, orbit.source_copies = array<i64: 64>, orbit.storage = "W_gate", orbit.target_copies = array<i64: 66801>, orbit.transfer = "host_to_l1", orbit.transfer_event = 33713 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x32xf32, strided<[32, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%547, %549) {orbit.computation_event = 33715 : i64, orbit.phase = 11696 : i64, orbit.phase_dependencies = array<i64: 11695>, orbit.read_copies = array<i64: 66800, 66801, 66802>, orbit.task = "gate", orbit.write_copies = array<i64: 66803>} : (!air.async.token, !air.async.token) -> ()
              %550 = "arith.constant"() <{value = 4 : index}> : () -> index
              %551 = "arith.constant"() <{value = 5 : index}> : () -> index
              %552 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%550, %551, %552) ({
              ^bb0(%arg280: index):
                %554 = "arith.constant"() <{value = 0 : index}> : () -> index
                %555 = "arith.constant"() <{value = 32 : index}> : () -> index
                %556 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%554, %555, %556) ({
                ^bb0(%arg281: index):
                  %557 = "arith.addi"(%arg281, %533) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %558 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %559 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %560 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%558, %559, %560) ({
                  ^bb0(%arg282: index):
                    %561 = "arith.addi"(%arg282, %543) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %562 = "arith.subi"(%arg280, %522) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %563 = "arith.subi"(%561, %544) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %564 = "memref.load"(%546, %562, %563) <{nontemporal = false}> : (memref<1x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %565 = "arith.subi"(%561, %545) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %566 = "arith.subi"(%557, %534) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %567 = "vector.transfer_read"(%548, %565, %566, %523) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %568 = "arith.subi"(%arg280, %522) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %569 = "arith.subi"(%557, %535) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %570 = "vector.transfer_read"(%536, %568, %569, %523) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %571 = "vector.extract"(%567) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %572 = "func.call"(%564, %571) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %573 = "vector.insert"(%572, %520) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %574 = "vector.extract"(%567) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %575 = "func.call"(%564, %574) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %576 = "vector.insert"(%575, %573) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %577 = "vector.extract"(%567) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %578 = "func.call"(%564, %577) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %579 = "vector.insert"(%578, %576) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %580 = "vector.extract"(%567) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %581 = "func.call"(%564, %580) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %582 = "vector.insert"(%581, %579) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %583 = "vector.extract"(%567) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %584 = "func.call"(%564, %583) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %585 = "vector.insert"(%584, %582) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %586 = "vector.extract"(%567) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %587 = "func.call"(%564, %586) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %588 = "vector.insert"(%587, %585) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %589 = "vector.extract"(%567) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %590 = "func.call"(%564, %589) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %591 = "vector.insert"(%590, %588) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %592 = "vector.extract"(%567) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %593 = "func.call"(%564, %592) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %594 = "vector.insert"(%593, %591) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %595 = "arith.addf"(%570, %594) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %596 = "arith.subi"(%arg280, %522) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %597 = "arith.subi"(%557, %535) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%595, %536, %596, %597) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %553 = "air.wait_all"(%arg279) : (!air.async.token) -> !air.async.token
              "scf.yield"(%553) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %541 = "air.dma_memcpy_nd"(%540, %arg273, %535, %536) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 11727 : i64, orbit.retained_begin = 11696 : i64, orbit.retained_end = 11728 : i64, orbit.source_copies = array<i64: 66896>, orbit.storage = "G", orbit.target_copies = array<i64: 66897>, orbit.transfer = "l1_to_host", orbit.transfer_event = 33809 : i64, static_dst_offsets = array<i64: 4, -9223372036854775808>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %542 = "air.wait_all"(%541) : (!air.async.token) -> !air.async.token
            "scf.yield"(%542) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 344 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%532) : (!air.async.token) -> ()
          "memref.dealloc"(%528) : (memref<64xf32, 2 : i32>) -> ()
          "memref.dealloc"(%529) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%530) : (memref<32xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_11696"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_11696"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_11696"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg203: index, %arg204: index, %arg205: index, %arg206: index, %arg207: memref<5x2048xf32>, %arg208: memref<2048x11008xf32>, %arg209: memref<2048x11008xf32>, %arg210: memref<11008x2048xf32>, %arg211: memref<5x2048xf32>, %arg212: memref<5x11008xf32>, %arg213: memref<5x11008xf32>, %arg214: memref<5x11008xf32>):
      "air.segment"(%arg207, %arg208, %arg209, %arg210, %arg211, %arg212, %arg213, %arg214) ({
      ^bb0(%arg215: memref<5x2048xf32>, %arg216: memref<2048x11008xf32>, %arg217: memref<2048x11008xf32>, %arg218: memref<11008x2048xf32>, %arg219: memref<5x2048xf32>, %arg220: memref<5x11008xf32>, %arg221: memref<5x11008xf32>, %arg222: memref<5x11008xf32>):
        %439 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%439, %439, %arg215, %arg216, %arg217, %arg218, %arg219, %arg220, %arg221, %arg222) ({
        ^bb0(%arg223: index, %arg224: index, %arg225: index, %arg226: index, %arg227: memref<5x2048xf32>, %arg228: memref<2048x11008xf32>, %arg229: memref<2048x11008xf32>, %arg230: memref<11008x2048xf32>, %arg231: memref<5x2048xf32>, %arg232: memref<5x11008xf32>, %arg233: memref<5x11008xf32>, %arg234: memref<5x11008xf32>):
          %440 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %441 = "arith.constant"() <{value = 64 : index}> : () -> index
          %442 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %443 = "arith.constant"() <{value = 32 : index}> : () -> index
          %444 = "arith.constant"() <{value = 1 : index}> : () -> index
          %445 = "arith.constant"() <{value = 344 : index}> : () -> index
          %446 = "arith.constant"() <{value = 0 : index}> : () -> index
          %447 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.32.64"} : () -> memref<256xf32, 2 : i32>
          %448 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.64.32.loops.4.32.64"} : () -> memref<2048xf32, 2 : i32>
          %449 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data"} : () -> memref<128xf32, 2 : i32>
          %450 = "air.wait_all"() : () -> !air.async.token
          %451 = "scf.for"(%446, %445, %444, %450) ({
          ^bb0(%arg235: index, %arg236: !air.async.token):
            %452 = "arith.muli"(%arg235, %443) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %453 = "arith.muli"(%arg235, %443) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %454 = "arith.muli"(%arg235, %443) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %455 = "memref.reinterpret_cast"(%449) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "up.initialize", orbit.phase = 23392 : i64, orbit.storage = "U"} : (memref<128xf32, 2 : i32>) -> memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %456 = "arith.constant"() <{value = 0 : index}> : () -> index
            %457 = "arith.constant"() <{value = 4 : index}> : () -> index
            %458 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%456, %457, %458) ({
            ^bb0(%arg242: index):
              %514 = "arith.constant"() <{value = 0 : index}> : () -> index
              %515 = "arith.constant"() <{value = 32 : index}> : () -> index
              %516 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%514, %515, %516) ({
              ^bb0(%arg243: index):
                %517 = "arith.addi"(%arg243, %452) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %518 = "arith.subi"(%517, %454) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%442, %455, %arg242, %518) <{nontemporal = false}> : (f32, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %459 = "scf.for"(%446, %443, %444, %arg236) ({
            ^bb0(%arg237: index, %arg238: !air.async.token):
              %462 = "arith.muli"(%arg237, %441) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %463 = "arith.muli"(%arg237, %441) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %464 = "arith.muli"(%arg237, %441) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %465 = "memref.reinterpret_cast"(%447) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 23392 : i64, orbit.storage = "X"} : (memref<256xf32, 2 : i32>) -> memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %466 = "air.dma_memcpy_nd"(%arg238, %465, %arg227, %463) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 23392 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 100512>, orbit.transfer = "host_to_l1", orbit.transfer_event = 67424 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 4, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<4x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x2048xf32>, index) -> !air.async.token
              %467 = "memref.reinterpret_cast"(%448) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 23392 : i64, orbit.storage = "W_up"} : (memref<2048xf32, 2 : i32>) -> memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %468 = "air.dma_memcpy_nd"(%arg238, %467, %arg229, %464, %453) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 23392 : i64, orbit.source_copies = array<i64: 11072>, orbit.storage = "W_up", orbit.target_copies = array<i64: 100513>, orbit.transfer = "host_to_l1", orbit.transfer_event = 67425 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x32xf32, strided<[32, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%466, %468) {orbit.computation_event = 67427 : i64, orbit.phase = 23392 : i64, orbit.phase_dependencies = array<i64: 23391>, orbit.read_copies = array<i64: 100512, 100513, 100514>, orbit.task = "up", orbit.write_copies = array<i64: 100515>} : (!air.async.token, !air.async.token) -> ()
              %469 = "arith.constant"() <{value = 0 : index}> : () -> index
              %470 = "arith.constant"() <{value = 4 : index}> : () -> index
              %471 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%469, %470, %471) ({
              ^bb0(%arg239: index):
                %473 = "arith.constant"() <{value = 0 : index}> : () -> index
                %474 = "arith.constant"() <{value = 32 : index}> : () -> index
                %475 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%473, %474, %475) ({
                ^bb0(%arg240: index):
                  %476 = "arith.addi"(%arg240, %452) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %477 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %478 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %479 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%477, %478, %479) ({
                  ^bb0(%arg241: index):
                    %480 = "arith.addi"(%arg241, %462) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %481 = "arith.subi"(%480, %463) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %482 = "memref.load"(%465, %arg239, %481) <{nontemporal = false}> : (memref<4x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %483 = "arith.subi"(%480, %464) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %484 = "arith.subi"(%476, %453) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %485 = "vector.transfer_read"(%467, %483, %484, %442) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %486 = "arith.subi"(%476, %454) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %487 = "vector.transfer_read"(%455, %arg239, %486, %442) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %488 = "vector.extract"(%485) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %489 = "func.call"(%482, %488) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %490 = "vector.insert"(%489, %440) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %491 = "vector.extract"(%485) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %492 = "func.call"(%482, %491) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %493 = "vector.insert"(%492, %490) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %494 = "vector.extract"(%485) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %495 = "func.call"(%482, %494) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %496 = "vector.insert"(%495, %493) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %497 = "vector.extract"(%485) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %498 = "func.call"(%482, %497) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %499 = "vector.insert"(%498, %496) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %500 = "vector.extract"(%485) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %501 = "func.call"(%482, %500) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %502 = "vector.insert"(%501, %499) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %503 = "vector.extract"(%485) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %504 = "func.call"(%482, %503) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %505 = "vector.insert"(%504, %502) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %506 = "vector.extract"(%485) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %507 = "func.call"(%482, %506) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %508 = "vector.insert"(%507, %505) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %509 = "vector.extract"(%485) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %510 = "func.call"(%482, %509) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %511 = "vector.insert"(%510, %508) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %512 = "arith.addf"(%487, %511) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %513 = "arith.subi"(%476, %454) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%512, %455, %arg239, %513) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %472 = "air.wait_all"(%arg238) : (!air.async.token) -> !air.async.token
              "scf.yield"(%472) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %460 = "air.dma_memcpy_nd"(%459, %arg233, %454, %455) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 23423 : i64, orbit.retained_begin = 23392 : i64, orbit.retained_end = 23424 : i64, orbit.source_copies = array<i64: 100608>, orbit.storage = "U", orbit.target_copies = array<i64: 100609>, orbit.transfer = "l1_to_host", orbit.transfer_event = 67521 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 4, 32>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<4x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %461 = "air.wait_all"(%460) : (!air.async.token) -> !air.async.token
            "scf.yield"(%461) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 344 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%451) : (!air.async.token) -> ()
          "memref.dealloc"(%447) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%448) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%449) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_23392"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_23392"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_23392"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg162: index, %arg163: index, %arg164: index, %arg165: index, %arg166: memref<5x2048xf32>, %arg167: memref<2048x11008xf32>, %arg168: memref<2048x11008xf32>, %arg169: memref<11008x2048xf32>, %arg170: memref<5x2048xf32>, %arg171: memref<5x11008xf32>, %arg172: memref<5x11008xf32>, %arg173: memref<5x11008xf32>):
      "air.segment"(%arg166, %arg167, %arg168, %arg169, %arg170, %arg171, %arg172, %arg173) ({
      ^bb0(%arg174: memref<5x2048xf32>, %arg175: memref<2048x11008xf32>, %arg176: memref<2048x11008xf32>, %arg177: memref<11008x2048xf32>, %arg178: memref<5x2048xf32>, %arg179: memref<5x11008xf32>, %arg180: memref<5x11008xf32>, %arg181: memref<5x11008xf32>):
        %354 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%354, %354, %arg174, %arg175, %arg176, %arg177, %arg178, %arg179, %arg180, %arg181) ({
        ^bb0(%arg182: index, %arg183: index, %arg184: index, %arg185: index, %arg186: memref<5x2048xf32>, %arg187: memref<2048x11008xf32>, %arg188: memref<2048x11008xf32>, %arg189: memref<11008x2048xf32>, %arg190: memref<5x2048xf32>, %arg191: memref<5x11008xf32>, %arg192: memref<5x11008xf32>, %arg193: memref<5x11008xf32>):
          %355 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %356 = "arith.constant"() <{value = 64 : index}> : () -> index
          %357 = "arith.constant"() <{value = 4 : index}> : () -> index
          %358 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %359 = "arith.constant"() <{value = 32 : index}> : () -> index
          %360 = "arith.constant"() <{value = 1 : index}> : () -> index
          %361 = "arith.constant"() <{value = 344 : index}> : () -> index
          %362 = "arith.constant"() <{value = 0 : index}> : () -> index
          %363 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.1.64.loops.1.32.64"} : () -> memref<64xf32, 2 : i32>
          %364 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.64.32.loops.1.32.64"} : () -> memref<2048xf32, 2 : i32>
          %365 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data"} : () -> memref<32xf32, 2 : i32>
          %366 = "air.wait_all"() : () -> !air.async.token
          %367 = "scf.for"(%362, %361, %360, %366) ({
          ^bb0(%arg194: index, %arg195: !air.async.token):
            %368 = "arith.muli"(%arg194, %359) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %369 = "arith.muli"(%arg194, %359) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %370 = "arith.muli"(%arg194, %359) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %371 = "memref.reinterpret_cast"(%365) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "up.initialize", orbit.phase = 34400 : i64, orbit.storage = "U"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %372 = "arith.constant"() <{value = 4 : index}> : () -> index
            %373 = "arith.constant"() <{value = 5 : index}> : () -> index
            %374 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%372, %373, %374) ({
            ^bb0(%arg201: index):
              %433 = "arith.constant"() <{value = 0 : index}> : () -> index
              %434 = "arith.constant"() <{value = 32 : index}> : () -> index
              %435 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%433, %434, %435) ({
              ^bb0(%arg202: index):
                %436 = "arith.addi"(%arg202, %368) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %437 = "arith.subi"(%arg201, %357) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %438 = "arith.subi"(%436, %370) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%358, %371, %437, %438) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %375 = "scf.for"(%362, %359, %360, %arg195) ({
            ^bb0(%arg196: index, %arg197: !air.async.token):
              %378 = "arith.muli"(%arg196, %356) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %379 = "arith.muli"(%arg196, %356) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %380 = "arith.muli"(%arg196, %356) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %381 = "memref.reinterpret_cast"(%363) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 34400 : i64, orbit.storage = "X"} : (memref<64xf32, 2 : i32>) -> memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %382 = "air.dma_memcpy_nd"(%arg197, %381, %arg186, %379) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 34400 : i64, orbit.source_copies = array<i64: 32>, orbit.storage = "X", orbit.target_copies = array<i64: 134224>, orbit.transfer = "host_to_l1", orbit.transfer_event = 101136 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 4, -9223372036854775808>, static_src_sizes = array<i64: 1, 64>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<1x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x2048xf32>, index) -> !air.async.token
              %383 = "memref.reinterpret_cast"(%364) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 34400 : i64, orbit.storage = "W_up"} : (memref<2048xf32, 2 : i32>) -> memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %384 = "air.dma_memcpy_nd"(%arg197, %383, %arg188, %380, %369) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 34400 : i64, orbit.source_copies = array<i64: 11072>, orbit.storage = "W_up", orbit.target_copies = array<i64: 134225>, orbit.transfer = "host_to_l1", orbit.transfer_event = 101137 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<64x32xf32, strided<[32, 1]>, 2 : i32>, memref<2048x11008xf32>, index, index) -> !air.async.token
              "air.wait_all"(%382, %384) {orbit.computation_event = 101139 : i64, orbit.phase = 34400 : i64, orbit.phase_dependencies = array<i64: 34399>, orbit.read_copies = array<i64: 134224, 134225, 134226>, orbit.task = "up", orbit.write_copies = array<i64: 134227>} : (!air.async.token, !air.async.token) -> ()
              %385 = "arith.constant"() <{value = 4 : index}> : () -> index
              %386 = "arith.constant"() <{value = 5 : index}> : () -> index
              %387 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%385, %386, %387) ({
              ^bb0(%arg198: index):
                %389 = "arith.constant"() <{value = 0 : index}> : () -> index
                %390 = "arith.constant"() <{value = 32 : index}> : () -> index
                %391 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%389, %390, %391) ({
                ^bb0(%arg199: index):
                  %392 = "arith.addi"(%arg199, %368) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %393 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %394 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %395 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%393, %394, %395) ({
                  ^bb0(%arg200: index):
                    %396 = "arith.addi"(%arg200, %378) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %397 = "arith.subi"(%arg198, %357) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %398 = "arith.subi"(%396, %379) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %399 = "memref.load"(%381, %397, %398) <{nontemporal = false}> : (memref<1x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %400 = "arith.subi"(%396, %380) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %401 = "arith.subi"(%392, %369) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %402 = "vector.transfer_read"(%383, %400, %401, %358) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %403 = "arith.subi"(%arg198, %357) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %404 = "arith.subi"(%392, %370) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %405 = "vector.transfer_read"(%371, %403, %404, %358) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %406 = "vector.extract"(%402) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %407 = "func.call"(%399, %406) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %408 = "vector.insert"(%407, %355) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %409 = "vector.extract"(%402) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %410 = "func.call"(%399, %409) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %411 = "vector.insert"(%410, %408) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %412 = "vector.extract"(%402) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %413 = "func.call"(%399, %412) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %414 = "vector.insert"(%413, %411) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %415 = "vector.extract"(%402) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %416 = "func.call"(%399, %415) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %417 = "vector.insert"(%416, %414) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %418 = "vector.extract"(%402) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %419 = "func.call"(%399, %418) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %420 = "vector.insert"(%419, %417) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %421 = "vector.extract"(%402) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %422 = "func.call"(%399, %421) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %423 = "vector.insert"(%422, %420) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %424 = "vector.extract"(%402) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %425 = "func.call"(%399, %424) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %426 = "vector.insert"(%425, %423) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %427 = "vector.extract"(%402) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %428 = "func.call"(%399, %427) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %429 = "vector.insert"(%428, %426) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %430 = "arith.addf"(%405, %429) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %431 = "arith.subi"(%arg198, %357) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %432 = "arith.subi"(%392, %370) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%430, %371, %431, %432) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %388 = "air.wait_all"(%arg197) : (!air.async.token) -> !air.async.token
              "scf.yield"(%388) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 32 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %376 = "air.dma_memcpy_nd"(%375, %arg192, %370, %371) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 34431 : i64, orbit.retained_begin = 34400 : i64, orbit.retained_end = 34432 : i64, orbit.source_copies = array<i64: 134320>, orbit.storage = "U", orbit.target_copies = array<i64: 134321>, orbit.transfer = "l1_to_host", orbit.transfer_event = 101233 : i64, static_dst_offsets = array<i64: 4, -9223372036854775808>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %377 = "air.wait_all"(%376) : (!air.async.token) -> !air.async.token
            "scf.yield"(%377) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 344 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%367) : (!air.async.token) -> ()
          "memref.dealloc"(%363) : (memref<64xf32, 2 : i32>) -> ()
          "memref.dealloc"(%364) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%365) : (memref<32xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_34400"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_34400"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_34400"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg126: index, %arg127: index, %arg128: index, %arg129: index, %arg130: memref<5x2048xf32>, %arg131: memref<2048x11008xf32>, %arg132: memref<2048x11008xf32>, %arg133: memref<11008x2048xf32>, %arg134: memref<5x2048xf32>, %arg135: memref<5x11008xf32>, %arg136: memref<5x11008xf32>, %arg137: memref<5x11008xf32>):
      "air.segment"(%arg130, %arg131, %arg132, %arg133, %arg134, %arg135, %arg136, %arg137) ({
      ^bb0(%arg138: memref<5x2048xf32>, %arg139: memref<2048x11008xf32>, %arg140: memref<2048x11008xf32>, %arg141: memref<11008x2048xf32>, %arg142: memref<5x2048xf32>, %arg143: memref<5x11008xf32>, %arg144: memref<5x11008xf32>, %arg145: memref<5x11008xf32>):
        %262 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%262, %262, %arg138, %arg139, %arg140, %arg141, %arg142, %arg143, %arg144, %arg145) ({
        ^bb0(%arg146: index, %arg147: index, %arg148: index, %arg149: index, %arg150: memref<5x2048xf32>, %arg151: memref<2048x11008xf32>, %arg152: memref<2048x11008xf32>, %arg153: memref<11008x2048xf32>, %arg154: memref<5x2048xf32>, %arg155: memref<5x11008xf32>, %arg156: memref<5x11008xf32>, %arg157: memref<5x11008xf32>):
          %263 = "arith.constant"() <{value = 127 : i32}> : () -> i32
          %264 = "arith.constant"() <{value = 23 : i32}> : () -> i32
          %265 = "arith.constant"() <{value = 1.270000e+02 : f32}> : () -> f32
          %266 = "arith.constant"() <{value = -1.270000e+02 : f32}> : () -> f32
          %267 = "arith.constant"() <{value = 8.880000e+01 : f32}> : () -> f32
          %268 = "arith.constant"() <{value = -8.780000e+01 : f32}> : () -> f32
          %269 = "arith.constant"() <{value = 0.166666657 : f32}> : () -> f32
          %270 = "arith.constant"() <{value = 0.0416657962 : f32}> : () -> f32
          %271 = "arith.constant"() <{value = 0.00833345205 : f32}> : () -> f32
          %272 = "arith.constant"() <{value = 0.00139819994 : f32}> : () -> f32
          %273 = "arith.constant"() <{value = 1.98756912E-4 : f32}> : () -> f32
          %274 = "arith.constant"() <{value = 2.12194442E-4 : f32}> : () -> f32
          %275 = "arith.constant"() <{value = -0.693359375 : f32}> : () -> f32
          %276 = "arith.constant"() <{value = 1.44269502 : f32}> : () -> f32
          %277 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %278 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
          %279 = "arith.constant"() <{value = 32 : index}> : () -> index
          %280 = "arith.constant"() <{value = 1 : index}> : () -> index
          %281 = "arith.constant"() <{value = 344 : index}> : () -> index
          %282 = "arith.constant"() <{value = 0 : index}> : () -> index
          %283 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data.input.4.32.loops.4.32"} : () -> memref<128xf32, 2 : i32>
          %284 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data.input.4.32.loops.4.32"} : () -> memref<128xf32, 2 : i32>
          %285 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data"} : () -> memref<128xf32, 2 : i32>
          %286 = "air.wait_all"() : () -> !air.async.token
          %287 = "scf.for"(%282, %281, %280, %286) ({
          ^bb0(%arg158: index, %arg159: !air.async.token):
            %288 = "arith.muli"(%arg158, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %289 = "arith.muli"(%arg158, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %290 = "arith.muli"(%arg158, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %291 = "arith.muli"(%arg158, %279) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %292 = "memref.reinterpret_cast"(%283) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 45408 : i64, orbit.storage = "G"} : (memref<128xf32, 2 : i32>) -> memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %293 = "air.dma_memcpy_nd"(%arg159, %292, %arg155, %289) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 45408 : i64, orbit.source_copies = array<i64: 33185>, orbit.storage = "G", orbit.target_copies = array<i64: 167936>, orbit.transfer = "host_to_l1", orbit.transfer_event = 134848 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 4, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
            %294 = "memref.reinterpret_cast"(%284) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 45408 : i64, orbit.storage = "U"} : (memref<128xf32, 2 : i32>) -> memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %295 = "air.dma_memcpy_nd"(%arg159, %294, %arg156, %290) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 45408 : i64, orbit.source_copies = array<i64: 100609>, orbit.storage = "U", orbit.target_copies = array<i64: 167937>, orbit.transfer = "host_to_l1", orbit.transfer_event = 134849 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 4, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
            %296 = "memref.reinterpret_cast"(%285) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 45408 : i64, orbit.storage = "H"} : (memref<128xf32, 2 : i32>) -> memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            "air.wait_all"(%293, %295) {orbit.computation_event = 134850 : i64, orbit.phase = 45408 : i64, orbit.phase_dependencies = array<i64: 45407>, orbit.read_copies = array<i64: 167936, 167937>, orbit.task = "swiglu", orbit.write_copies = array<i64: 167938>} : (!air.async.token, !air.async.token) -> ()
            %297 = "arith.constant"() <{value = 0 : index}> : () -> index
            %298 = "arith.constant"() <{value = 4 : index}> : () -> index
            %299 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%297, %298, %299) ({
            ^bb0(%arg160: index):
              %302 = "arith.constant"() <{value = 0 : index}> : () -> index
              %303 = "arith.constant"() <{value = 32 : index}> : () -> index
              %304 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%302, %303, %304) ({
              ^bb0(%arg161: index):
                %305 = "arith.addi"(%arg161, %288) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %306 = "arith.subi"(%305, %289) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %307 = "memref.load"(%292, %arg160, %306) <{nontemporal = false}> : (memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %308 = "arith.subi"(%305, %290) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %309 = "memref.load"(%294, %arg160, %308) <{nontemporal = false}> : (memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %310 = "arith.negf"(%307) <{fastmath = #arith.fastmath<none>}> : (f32) -> f32
                %311 = "arith.cmpf"(%310, %268) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %312 = "arith.select"(%311, %310, %268) : (i1, f32, f32) -> f32
                %313 = "arith.cmpf"(%312, %267) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %314 = "arith.select"(%313, %312, %267) : (i1, f32, f32) -> f32
                %315 = "arith.mulf"(%314, %276) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %316 = "arith.addf"(%315, %277) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %317 = "arith.fptosi"(%316) : (f32) -> i32
                %318 = "arith.sitofp"(%317) : (i32) -> f32
                %319 = "arith.cmpf"(%316, %318) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f32, f32) -> i1
                %320 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
                %321 = "arith.subf"(%318, %320) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %322 = "arith.select"(%319, %321, %318) : (i1, f32, f32) -> f32
                %323 = "arith.cmpf"(%322, %266) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %324 = "arith.select"(%323, %322, %266) : (i1, f32, f32) -> f32
                %325 = "arith.cmpf"(%324, %265) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %326 = "arith.select"(%325, %324, %265) : (i1, f32, f32) -> f32
                %327 = "arith.mulf"(%326, %275) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %328 = "arith.addf"(%327, %314) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %329 = "arith.mulf"(%326, %274) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %330 = "arith.addf"(%329, %328) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %331 = "arith.mulf"(%330, %273) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %332 = "arith.addf"(%331, %272) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %333 = "arith.mulf"(%332, %330) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %334 = "arith.addf"(%333, %271) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %335 = "arith.mulf"(%334, %330) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %336 = "arith.addf"(%335, %270) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %337 = "arith.mulf"(%336, %330) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %338 = "arith.addf"(%337, %269) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %339 = "arith.mulf"(%338, %330) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %340 = "arith.addf"(%339, %277) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %341 = "arith.mulf"(%330, %330) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %342 = "arith.mulf"(%340, %341) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %343 = "arith.addf"(%342, %330) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %344 = "arith.addf"(%343, %278) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %345 = "arith.fptosi"(%326) : (f32) -> i32
                %346 = "arith.addi"(%345, %263) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %347 = "arith.shli"(%346, %264) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %348 = "arith.bitcast"(%347) : (i32) -> f32
                %349 = "arith.mulf"(%344, %348) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %350 = "arith.addf"(%349, %278) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %351 = "arith.divf"(%307, %350) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %352 = "arith.mulf"(%351, %309) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %353 = "arith.subi"(%305, %291) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%352, %296, %arg160, %353) <{nontemporal = false}> : (f32, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %300 = "air.dma_memcpy_nd"(%arg159, %arg157, %291, %296) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 45408 : i64, orbit.source_copies = array<i64: 167938>, orbit.storage = "H", orbit.target_copies = array<i64: 167939>, orbit.transfer = "l1_to_host", orbit.transfer_event = 134851 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 4, 32>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<4x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %301 = "air.wait_all"(%300) : (!air.async.token) -> !air.async.token
            "scf.yield"(%301) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 344 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%287) : (!air.async.token) -> ()
          "memref.dealloc"(%283) : (memref<128xf32, 2 : i32>) -> ()
          "memref.dealloc"(%284) : (memref<128xf32, 2 : i32>) -> ()
          "memref.dealloc"(%285) : (memref<128xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_45408"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_45408"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_45408"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg90: index, %arg91: index, %arg92: index, %arg93: index, %arg94: memref<5x2048xf32>, %arg95: memref<2048x11008xf32>, %arg96: memref<2048x11008xf32>, %arg97: memref<11008x2048xf32>, %arg98: memref<5x2048xf32>, %arg99: memref<5x11008xf32>, %arg100: memref<5x11008xf32>, %arg101: memref<5x11008xf32>):
      "air.segment"(%arg94, %arg95, %arg96, %arg97, %arg98, %arg99, %arg100, %arg101) ({
      ^bb0(%arg102: memref<5x2048xf32>, %arg103: memref<2048x11008xf32>, %arg104: memref<2048x11008xf32>, %arg105: memref<11008x2048xf32>, %arg106: memref<5x2048xf32>, %arg107: memref<5x11008xf32>, %arg108: memref<5x11008xf32>, %arg109: memref<5x11008xf32>):
        %166 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%166, %166, %arg102, %arg103, %arg104, %arg105, %arg106, %arg107, %arg108, %arg109) ({
        ^bb0(%arg110: index, %arg111: index, %arg112: index, %arg113: index, %arg114: memref<5x2048xf32>, %arg115: memref<2048x11008xf32>, %arg116: memref<2048x11008xf32>, %arg117: memref<11008x2048xf32>, %arg118: memref<5x2048xf32>, %arg119: memref<5x11008xf32>, %arg120: memref<5x11008xf32>, %arg121: memref<5x11008xf32>):
          %167 = "arith.constant"() <{value = 127 : i32}> : () -> i32
          %168 = "arith.constant"() <{value = 23 : i32}> : () -> i32
          %169 = "arith.constant"() <{value = 1.270000e+02 : f32}> : () -> f32
          %170 = "arith.constant"() <{value = -1.270000e+02 : f32}> : () -> f32
          %171 = "arith.constant"() <{value = 8.880000e+01 : f32}> : () -> f32
          %172 = "arith.constant"() <{value = -8.780000e+01 : f32}> : () -> f32
          %173 = "arith.constant"() <{value = 0.166666657 : f32}> : () -> f32
          %174 = "arith.constant"() <{value = 0.0416657962 : f32}> : () -> f32
          %175 = "arith.constant"() <{value = 0.00833345205 : f32}> : () -> f32
          %176 = "arith.constant"() <{value = 0.00139819994 : f32}> : () -> f32
          %177 = "arith.constant"() <{value = 1.98756912E-4 : f32}> : () -> f32
          %178 = "arith.constant"() <{value = 2.12194442E-4 : f32}> : () -> f32
          %179 = "arith.constant"() <{value = -0.693359375 : f32}> : () -> f32
          %180 = "arith.constant"() <{value = 1.44269502 : f32}> : () -> f32
          %181 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
          %182 = "arith.constant"() <{value = 4 : index}> : () -> index
          %183 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
          %184 = "arith.constant"() <{value = 32 : index}> : () -> index
          %185 = "arith.constant"() <{value = 1 : index}> : () -> index
          %186 = "arith.constant"() <{value = 344 : index}> : () -> index
          %187 = "arith.constant"() <{value = 0 : index}> : () -> index
          %188 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 5 : i64, orbit.tile_pool = "storage-5.data.input.1.32.loops.1.32"} : () -> memref<32xf32, 2 : i32>
          %189 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 6 : i64, orbit.tile_pool = "storage-6.data.input.1.32.loops.1.32"} : () -> memref<32xf32, 2 : i32>
          %190 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data"} : () -> memref<32xf32, 2 : i32>
          %191 = "air.wait_all"() : () -> !air.async.token
          %192 = "scf.for"(%187, %186, %185, %191) ({
          ^bb0(%arg122: index, %arg123: !air.async.token):
            %193 = "arith.muli"(%arg122, %184) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %194 = "arith.muli"(%arg122, %184) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %195 = "arith.muli"(%arg122, %184) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %196 = "arith.muli"(%arg122, %184) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %197 = "memref.reinterpret_cast"(%188) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 45752 : i64, orbit.storage = "G"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %198 = "air.dma_memcpy_nd"(%arg123, %197, %arg119, %194) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 45752 : i64, orbit.source_copies = array<i64: 66897>, orbit.storage = "G", orbit.target_copies = array<i64: 169312>, orbit.transfer = "host_to_l1", orbit.transfer_event = 136224 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 4, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
            %199 = "memref.reinterpret_cast"(%189) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 45752 : i64, orbit.storage = "U"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %200 = "air.dma_memcpy_nd"(%arg123, %199, %arg120, %195) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 45752 : i64, orbit.source_copies = array<i64: 134321>, orbit.storage = "U", orbit.target_copies = array<i64: 169313>, orbit.transfer = "host_to_l1", orbit.transfer_event = 136225 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: 4, -9223372036854775808>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
            %201 = "memref.reinterpret_cast"(%190) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 45752 : i64, orbit.storage = "H"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            "air.wait_all"(%198, %200) {orbit.computation_event = 136226 : i64, orbit.phase = 45752 : i64, orbit.phase_dependencies = array<i64: 45751>, orbit.read_copies = array<i64: 169312, 169313>, orbit.task = "swiglu", orbit.write_copies = array<i64: 169314>} : (!air.async.token, !air.async.token) -> ()
            %202 = "arith.constant"() <{value = 4 : index}> : () -> index
            %203 = "arith.constant"() <{value = 5 : index}> : () -> index
            %204 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%202, %203, %204) ({
            ^bb0(%arg124: index):
              %207 = "arith.constant"() <{value = 0 : index}> : () -> index
              %208 = "arith.constant"() <{value = 32 : index}> : () -> index
              %209 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%207, %208, %209) ({
              ^bb0(%arg125: index):
                %210 = "arith.addi"(%arg125, %193) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %211 = "arith.subi"(%arg124, %182) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %212 = "arith.subi"(%210, %194) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %213 = "memref.load"(%197, %211, %212) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %214 = "arith.subi"(%arg124, %182) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %215 = "arith.subi"(%210, %195) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %216 = "memref.load"(%199, %214, %215) <{nontemporal = false}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                %217 = "arith.negf"(%213) <{fastmath = #arith.fastmath<none>}> : (f32) -> f32
                %218 = "arith.cmpf"(%217, %172) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %219 = "arith.select"(%218, %217, %172) : (i1, f32, f32) -> f32
                %220 = "arith.cmpf"(%219, %171) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %221 = "arith.select"(%220, %219, %171) : (i1, f32, f32) -> f32
                %222 = "arith.mulf"(%221, %180) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %223 = "arith.addf"(%222, %181) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %224 = "arith.fptosi"(%223) : (f32) -> i32
                %225 = "arith.sitofp"(%224) : (i32) -> f32
                %226 = "arith.cmpf"(%223, %225) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f32, f32) -> i1
                %227 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
                %228 = "arith.subf"(%225, %227) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %229 = "arith.select"(%226, %228, %225) : (i1, f32, f32) -> f32
                %230 = "arith.cmpf"(%229, %170) <{fastmath = #arith.fastmath<none>, predicate = 10 : i64}> : (f32, f32) -> i1
                %231 = "arith.select"(%230, %229, %170) : (i1, f32, f32) -> f32
                %232 = "arith.cmpf"(%231, %169) <{fastmath = #arith.fastmath<none>, predicate = 12 : i64}> : (f32, f32) -> i1
                %233 = "arith.select"(%232, %231, %169) : (i1, f32, f32) -> f32
                %234 = "arith.mulf"(%233, %179) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %235 = "arith.addf"(%234, %221) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %236 = "arith.mulf"(%233, %178) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %237 = "arith.addf"(%236, %235) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %238 = "arith.mulf"(%237, %177) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %239 = "arith.addf"(%238, %176) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %240 = "arith.mulf"(%239, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %241 = "arith.addf"(%240, %175) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %242 = "arith.mulf"(%241, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %243 = "arith.addf"(%242, %174) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %244 = "arith.mulf"(%243, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %245 = "arith.addf"(%244, %173) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %246 = "arith.mulf"(%245, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %247 = "arith.addf"(%246, %181) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %248 = "arith.mulf"(%237, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %249 = "arith.mulf"(%247, %248) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %250 = "arith.addf"(%249, %237) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %251 = "arith.addf"(%250, %183) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %252 = "arith.fptosi"(%233) : (f32) -> i32
                %253 = "arith.addi"(%252, %167) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %254 = "arith.shli"(%253, %168) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
                %255 = "arith.bitcast"(%254) : (i32) -> f32
                %256 = "arith.mulf"(%251, %255) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %257 = "arith.addf"(%256, %183) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %258 = "arith.divf"(%213, %257) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %259 = "arith.mulf"(%258, %216) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                %260 = "arith.subi"(%arg124, %182) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %261 = "arith.subi"(%210, %196) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%259, %201, %260, %261) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %205 = "air.dma_memcpy_nd"(%arg123, %arg121, %196, %201) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 45752 : i64, orbit.source_copies = array<i64: 169314>, orbit.storage = "H", orbit.target_copies = array<i64: 169315>, orbit.transfer = "l1_to_host", orbit.transfer_event = 136227 : i64, static_dst_offsets = array<i64: 4, -9223372036854775808>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 11008, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x11008xf32>, index, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %206 = "air.wait_all"(%205) : (!air.async.token) -> !air.async.token
            "scf.yield"(%206) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 344 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%192) : (!air.async.token) -> ()
          "memref.dealloc"(%188) : (memref<32xf32, 2 : i32>) -> ()
          "memref.dealloc"(%189) : (memref<32xf32, 2 : i32>) -> ()
          "memref.dealloc"(%190) : (memref<32xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_45752"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_45752"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_45752"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg49: index, %arg50: index, %arg51: index, %arg52: index, %arg53: memref<5x2048xf32>, %arg54: memref<2048x11008xf32>, %arg55: memref<2048x11008xf32>, %arg56: memref<11008x2048xf32>, %arg57: memref<5x2048xf32>, %arg58: memref<5x11008xf32>, %arg59: memref<5x11008xf32>, %arg60: memref<5x11008xf32>):
      "air.segment"(%arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60) ({
      ^bb0(%arg61: memref<5x2048xf32>, %arg62: memref<2048x11008xf32>, %arg63: memref<2048x11008xf32>, %arg64: memref<11008x2048xf32>, %arg65: memref<5x2048xf32>, %arg66: memref<5x11008xf32>, %arg67: memref<5x11008xf32>, %arg68: memref<5x11008xf32>):
        %86 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%86, %86, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68) ({
        ^bb0(%arg69: index, %arg70: index, %arg71: index, %arg72: index, %arg73: memref<5x2048xf32>, %arg74: memref<2048x11008xf32>, %arg75: memref<2048x11008xf32>, %arg76: memref<11008x2048xf32>, %arg77: memref<5x2048xf32>, %arg78: memref<5x11008xf32>, %arg79: memref<5x11008xf32>, %arg80: memref<5x11008xf32>):
          %87 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %88 = "arith.constant"() <{value = 172 : index}> : () -> index
          %89 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %90 = "arith.constant"() <{value = 32 : index}> : () -> index
          %91 = "arith.constant"() <{value = 1 : index}> : () -> index
          %92 = "arith.constant"() <{value = 64 : index}> : () -> index
          %93 = "arith.constant"() <{value = 0 : index}> : () -> index
          %94 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.64.32.loops.4.32.64"} : () -> memref<2048xf32, 2 : i32>
          %95 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<128xf32, 2 : i32>
          %96 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data.input.4.64.loops.4.32.64"} : () -> memref<256xf32, 2 : i32>
          %97 = "air.wait_all"() : () -> !air.async.token
          %98 = "scf.for"(%93, %92, %91, %97) ({
          ^bb0(%arg81: index, %arg82: !air.async.token):
            %99 = "arith.muli"(%arg81, %90) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %100 = "arith.muli"(%arg81, %90) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %101 = "arith.muli"(%arg81, %90) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %102 = "memref.reinterpret_cast"(%95) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "down.initialize", orbit.phase = 46224 : i64, orbit.storage = "Y"} : (memref<128xf32, 2 : i32>) -> memref<4x32xf32, strided<[32, 1]>, 2 : i32>
            %103 = "arith.constant"() <{value = 0 : index}> : () -> index
            %104 = "arith.constant"() <{value = 4 : index}> : () -> index
            %105 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%103, %104, %105) ({
            ^bb0(%arg88: index):
              %161 = "arith.constant"() <{value = 0 : index}> : () -> index
              %162 = "arith.constant"() <{value = 32 : index}> : () -> index
              %163 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%161, %162, %163) ({
              ^bb0(%arg89: index):
                %164 = "arith.addi"(%arg89, %99) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %165 = "arith.subi"(%164, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%89, %102, %arg88, %165) <{nontemporal = false}> : (f32, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %106 = "scf.for"(%93, %88, %91, %arg82) ({
            ^bb0(%arg83: index, %arg84: !air.async.token):
              %109 = "arith.muli"(%arg83, %92) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %110 = "arith.muli"(%arg83, %92) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %111 = "arith.muli"(%arg83, %92) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %112 = "memref.reinterpret_cast"(%94) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 46224 : i64, orbit.storage = "W_down"} : (memref<2048xf32, 2 : i32>) -> memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %113 = "air.dma_memcpy_nd"(%arg84, %112, %arg76, %110, %100) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 46224 : i64, orbit.source_copies = array<i64: 22080>, orbit.storage = "W_down", orbit.target_copies = array<i64: 170688>, orbit.transfer = "host_to_l1", orbit.transfer_event = 137600 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 32>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<64x32xf32, strided<[32, 1]>, 2 : i32>, memref<11008x2048xf32>, index, index) -> !air.async.token
              %114 = "memref.reinterpret_cast"(%96) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 46224 : i64, orbit.storage = "H"} : (memref<256xf32, 2 : i32>) -> memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %115 = "air.dma_memcpy_nd"(%arg84, %114, %arg80, %111) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 46224 : i64, orbit.source_copies = array<i64: 167939, 167943>, orbit.storage = "H", orbit.target_copies = array<i64: 170689, 170690>, orbit.transfer = "host_to_l1", orbit.transfer_event = 137601 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, -9223372036854775808>, static_src_sizes = array<i64: 4, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<4x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
              "air.wait_all"(%113, %115) {orbit.computation_event = 137603 : i64, orbit.phase = 46224 : i64, orbit.phase_dependencies = array<i64: 46223>, orbit.read_copies = array<i64: 170688, 170691, 170689, 170690>, orbit.task = "down", orbit.write_copies = array<i64: 170692>} : (!air.async.token, !air.async.token) -> ()
              %116 = "arith.constant"() <{value = 0 : index}> : () -> index
              %117 = "arith.constant"() <{value = 4 : index}> : () -> index
              %118 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%116, %117, %118) ({
              ^bb0(%arg85: index):
                %120 = "arith.constant"() <{value = 0 : index}> : () -> index
                %121 = "arith.constant"() <{value = 32 : index}> : () -> index
                %122 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%120, %121, %122) ({
                ^bb0(%arg86: index):
                  %123 = "arith.addi"(%arg86, %99) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %124 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %125 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %126 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%124, %125, %126) ({
                  ^bb0(%arg87: index):
                    %127 = "arith.addi"(%arg87, %109) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %128 = "arith.subi"(%127, %111) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %129 = "memref.load"(%114, %arg85, %128) <{nontemporal = false}> : (memref<4x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %130 = "arith.subi"(%127, %110) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %131 = "arith.subi"(%123, %100) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %132 = "vector.transfer_read"(%112, %130, %131, %89) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %133 = "arith.subi"(%123, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %134 = "vector.transfer_read"(%102, %arg85, %133, %89) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %135 = "vector.extract"(%132) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %136 = "func.call"(%129, %135) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %137 = "vector.insert"(%136, %87) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %138 = "vector.extract"(%132) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %139 = "func.call"(%129, %138) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %140 = "vector.insert"(%139, %137) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %141 = "vector.extract"(%132) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %142 = "func.call"(%129, %141) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %143 = "vector.insert"(%142, %140) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %144 = "vector.extract"(%132) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %145 = "func.call"(%129, %144) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %146 = "vector.insert"(%145, %143) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %147 = "vector.extract"(%132) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %148 = "func.call"(%129, %147) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %149 = "vector.insert"(%148, %146) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %150 = "vector.extract"(%132) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %151 = "func.call"(%129, %150) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %152 = "vector.insert"(%151, %149) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %153 = "vector.extract"(%132) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %154 = "func.call"(%129, %153) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %155 = "vector.insert"(%154, %152) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %156 = "vector.extract"(%132) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %157 = "func.call"(%129, %156) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %158 = "vector.insert"(%157, %155) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %159 = "arith.addf"(%134, %158) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %160 = "arith.subi"(%123, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%159, %102, %arg85, %160) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %119 = "air.wait_all"(%arg84) : (!air.async.token) -> !air.async.token
              "scf.yield"(%119) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %107 = "air.dma_memcpy_nd"(%106, %arg77, %101, %102) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 46395 : i64, orbit.retained_begin = 46224 : i64, orbit.retained_end = 46396 : i64, orbit.source_copies = array<i64: 171376>, orbit.storage = "Y", orbit.target_copies = array<i64: 171377>, orbit.transfer = "l1_to_host", orbit.transfer_event = 138117 : i64, static_dst_offsets = array<i64: 0, -9223372036854775808>, static_dst_sizes = array<i64: 4, 32>, static_dst_strides = array<i64: 2048, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x2048xf32>, index, memref<4x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %108 = "air.wait_all"(%107) : (!air.async.token) -> !air.async.token
            "scf.yield"(%108) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 64 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%98) : (!air.async.token) -> ()
          "memref.dealloc"(%94) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%95) : (memref<128xf32, 2 : i32>) -> ()
          "memref.dealloc"(%96) : (memref<256xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_46224"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_46224"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_46224"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7) ({
    ^bb0(%arg8: index, %arg9: index, %arg10: index, %arg11: index, %arg12: memref<5x2048xf32>, %arg13: memref<2048x11008xf32>, %arg14: memref<2048x11008xf32>, %arg15: memref<11008x2048xf32>, %arg16: memref<5x2048xf32>, %arg17: memref<5x11008xf32>, %arg18: memref<5x11008xf32>, %arg19: memref<5x11008xf32>):
      "air.segment"(%arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19) ({
      ^bb0(%arg20: memref<5x2048xf32>, %arg21: memref<2048x11008xf32>, %arg22: memref<2048x11008xf32>, %arg23: memref<11008x2048xf32>, %arg24: memref<5x2048xf32>, %arg25: memref<5x11008xf32>, %arg26: memref<5x11008xf32>, %arg27: memref<5x11008xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27) ({
        ^bb0(%arg28: index, %arg29: index, %arg30: index, %arg31: index, %arg32: memref<5x2048xf32>, %arg33: memref<2048x11008xf32>, %arg34: memref<2048x11008xf32>, %arg35: memref<11008x2048xf32>, %arg36: memref<5x2048xf32>, %arg37: memref<5x11008xf32>, %arg38: memref<5x11008xf32>, %arg39: memref<5x11008xf32>):
          %2 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
          %3 = "arith.constant"() <{value = 172 : index}> : () -> index
          %4 = "arith.constant"() <{value = 4 : index}> : () -> index
          %5 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
          %6 = "arith.constant"() <{value = 32 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "arith.constant"() <{value = 64 : index}> : () -> index
          %9 = "arith.constant"() <{value = 0 : index}> : () -> index
          %10 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.64.32.loops.1.32.64"} : () -> memref<2048xf32, 2 : i32>
          %11 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 4 : i64, orbit.tile_pool = "storage-4.data"} : () -> memref<32xf32, 2 : i32>
          %12 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 7 : i64, orbit.tile_pool = "storage-7.data.input.1.64.loops.1.32.64"} : () -> memref<64xf32, 2 : i32>
          %13 = "air.wait_all"() : () -> !air.async.token
          %14 = "scf.for"(%9, %8, %7, %13) ({
          ^bb0(%arg40: index, %arg41: !air.async.token):
            %15 = "arith.muli"(%arg40, %6) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %16 = "arith.muli"(%arg40, %6) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %17 = "arith.muli"(%arg40, %6) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %18 = "memref.reinterpret_cast"(%11) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 32>, static_strides = array<i64: 32, 1>}> {orbit.initializer_task = "down.initialize", orbit.phase = 57232 : i64, orbit.storage = "Y"} : (memref<32xf32, 2 : i32>) -> memref<1x32xf32, strided<[32, 1]>, 2 : i32>
            %19 = "arith.constant"() <{value = 4 : index}> : () -> index
            %20 = "arith.constant"() <{value = 5 : index}> : () -> index
            %21 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%19, %20, %21) ({
            ^bb0(%arg47: index):
              %80 = "arith.constant"() <{value = 0 : index}> : () -> index
              %81 = "arith.constant"() <{value = 32 : index}> : () -> index
              %82 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%80, %81, %82) ({
              ^bb0(%arg48: index):
                %83 = "arith.addi"(%arg48, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %84 = "arith.subi"(%arg47, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %85 = "arith.subi"(%83, %17) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%5, %18, %84, %85) <{nontemporal = false}> : (f32, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %22 = "scf.for"(%9, %3, %7, %arg41) ({
            ^bb0(%arg42: index, %arg43: !air.async.token):
              %25 = "arith.muli"(%arg42, %8) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %26 = "arith.muli"(%arg42, %8) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %27 = "arith.muli"(%arg42, %8) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %28 = "memref.reinterpret_cast"(%10) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 64, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 57232 : i64, orbit.storage = "W_down"} : (memref<2048xf32, 2 : i32>) -> memref<64x32xf32, strided<[32, 1]>, 2 : i32>
              %29 = "air.dma_memcpy_nd"(%arg43, %28, %arg35, %26, %16) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 57232 : i64, orbit.source_copies = array<i64: 22080>, orbit.storage = "W_down", orbit.target_copies = array<i64: 214848>, orbit.transfer = "host_to_l1", orbit.transfer_event = 170752 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 64, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 64, 32>, static_src_strides = array<i64: 2048, 1>} : (!air.async.token, memref<64x32xf32, strided<[32, 1]>, 2 : i32>, memref<11008x2048xf32>, index, index) -> !air.async.token
              %30 = "memref.reinterpret_cast"(%12) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 1, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 57232 : i64, orbit.storage = "H"} : (memref<64xf32, 2 : i32>) -> memref<1x64xf32, strided<[64, 1]>, 2 : i32>
              %31 = "air.dma_memcpy_nd"(%arg43, %30, %arg39, %27) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 1, 0, 0>, orbit.phase = 57232 : i64, orbit.source_copies = array<i64: 169315, 169319>, orbit.storage = "H", orbit.target_copies = array<i64: 214849, 214850>, orbit.transfer = "host_to_l1", orbit.transfer_event = 170753 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 1, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 4, -9223372036854775808>, static_src_sizes = array<i64: 1, 64>, static_src_strides = array<i64: 11008, 1>} : (!air.async.token, memref<1x64xf32, strided<[64, 1]>, 2 : i32>, memref<5x11008xf32>, index) -> !air.async.token
              "air.wait_all"(%29, %31) {orbit.computation_event = 170755 : i64, orbit.phase = 57232 : i64, orbit.phase_dependencies = array<i64: 57231>, orbit.read_copies = array<i64: 214848, 214851, 214849, 214850>, orbit.task = "down", orbit.write_copies = array<i64: 214852>} : (!air.async.token, !air.async.token) -> ()
              %32 = "arith.constant"() <{value = 4 : index}> : () -> index
              %33 = "arith.constant"() <{value = 5 : index}> : () -> index
              %34 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%32, %33, %34) ({
              ^bb0(%arg44: index):
                %36 = "arith.constant"() <{value = 0 : index}> : () -> index
                %37 = "arith.constant"() <{value = 32 : index}> : () -> index
                %38 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%36, %37, %38) ({
                ^bb0(%arg45: index):
                  %39 = "arith.addi"(%arg45, %15) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %40 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %41 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %42 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%40, %41, %42) ({
                  ^bb0(%arg46: index):
                    %43 = "arith.addi"(%arg46, %25) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %44 = "arith.subi"(%arg44, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %45 = "arith.subi"(%43, %27) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %46 = "memref.load"(%30, %44, %45) <{nontemporal = false}> : (memref<1x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
                    %47 = "arith.subi"(%43, %26) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %48 = "arith.subi"(%39, %16) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %49 = "vector.transfer_read"(%28, %47, %48, %5) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<64x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %50 = "arith.subi"(%arg44, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %51 = "arith.subi"(%39, %17) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %52 = "vector.transfer_read"(%18, %50, %51, %5) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %53 = "vector.extract"(%49) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %54 = "func.call"(%46, %53) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %55 = "vector.insert"(%54, %2) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %56 = "vector.extract"(%49) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %57 = "func.call"(%46, %56) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %58 = "vector.insert"(%57, %55) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %59 = "vector.extract"(%49) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %60 = "func.call"(%46, %59) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %61 = "vector.insert"(%60, %58) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %62 = "vector.extract"(%49) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %63 = "func.call"(%46, %62) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %64 = "vector.insert"(%63, %61) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %65 = "vector.extract"(%49) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %66 = "func.call"(%46, %65) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %67 = "vector.insert"(%66, %64) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %68 = "vector.extract"(%49) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %69 = "func.call"(%46, %68) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %70 = "vector.insert"(%69, %67) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %71 = "vector.extract"(%49) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %72 = "func.call"(%46, %71) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %73 = "vector.insert"(%72, %70) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %74 = "vector.extract"(%49) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %75 = "func.call"(%46, %74) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %76 = "vector.insert"(%75, %73) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %77 = "arith.addf"(%52, %76) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %78 = "arith.subi"(%arg44, %4) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %79 = "arith.subi"(%39, %17) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%77, %18, %78, %79) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<1x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %35 = "air.wait_all"(%arg43) : (!air.async.token) -> !air.async.token
              "scf.yield"(%35) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 172 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %23 = "air.dma_memcpy_nd"(%22, %arg36, %17, %18) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 57403 : i64, orbit.retained_begin = 57232 : i64, orbit.retained_end = 57404 : i64, orbit.source_copies = array<i64: 215536>, orbit.storage = "Y", orbit.target_copies = array<i64: 215537>, orbit.transfer = "l1_to_host", orbit.transfer_event = 171269 : i64, static_dst_offsets = array<i64: 4, -9223372036854775808>, static_dst_sizes = array<i64: 1, 32>, static_dst_strides = array<i64: 2048, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 1, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<5x2048xf32>, index, memref<1x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
            %24 = "air.wait_all"(%23) : (!air.async.token) -> !air.async.token
            "scf.yield"(%24) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 64 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%14) : (!air.async.token) -> ()
          "memref.dealloc"(%10) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%11) : (memref<32xf32, 2 : i32>) -> ()
          "memref.dealloc"(%12) : (memref<64xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 8>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_57232"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 8>, sym_name = "orbit_segment_57232"} : (memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 8>, sym_name = "orbit_launch_57232"} : (index, index, memref<5x2048xf32>, memref<2048x11008xf32>, memref<2048x11008xf32>, memref<11008x2048xf32>, memref<5x2048xf32>, memref<5x11008xf32>, memref<5x11008xf32>, memref<5x11008xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "b17368bc3d1715cf23dbe0d39fee112916672cb9f5730905ae10a62506be8cc4", orbit.math_approximation = "mlir-f32-cephes-exp; unfused-mul-add; bounded-floor-i32; finite-input-contract; flush-denormals; no-global-fastmath", orbit.source_fingerprint = "8c0c18e9f7ab0e83c0d958c735fe9d4b466e5b15e5cdf11aa852370d1e3f1414"} : () -> ()

