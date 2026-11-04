#map = affine_map<(d0, d1) -> (d1)>
"builtin.module"() ({
  "func.func"() <{function_type = (f32, f32) -> f32, sym_name = "__mulsf3", sym_visibility = "private"}> ({
  }) {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]} : () -> ()
  "func.func"() <{function_type = (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> (), sym_name = "gemm_scale"}> ({
  ^bb0(%arg0: memref<32x128xf32>, %arg1: memref<128x64xf32>, %arg2: memref<32x64xf32>, %arg3: memref<32x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg117: index, %arg118: index, %arg119: index, %arg120: index, %arg121: memref<32x128xf32>, %arg122: memref<128x64xf32>, %arg123: memref<32x64xf32>, %arg124: memref<32x64xf32>):
      "air.segment"(%arg121, %arg122, %arg123, %arg124) ({
      ^bb0(%arg125: memref<32x128xf32>, %arg126: memref<128x64xf32>, %arg127: memref<32x64xf32>, %arg128: memref<32x64xf32>):
        %413 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%413, %413, %arg125, %arg126, %arg127, %arg128) ({
        ^bb0(%arg129: index, %arg130: index, %arg131: index, %arg132: index, %arg133: memref<32x128xf32>, %arg134: memref<128x64xf32>, %arg135: memref<32x64xf32>, %arg136: memref<32x64xf32>):
          %414 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : () -> memref<256xf32, 2 : i32>
          %415 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %416 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<64xf32, 2 : i32>
          %417 = "air.wait_all"() : () -> !air.async.token
          %418 = "memref.reinterpret_cast"(%415) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 32 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %419 = "air.dma_memcpy_nd"(%417, %418, %arg134) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 32 : i64, orbit.readonly_retained_begin = 32 : i64, orbit.readonly_retained_end = 48 : i64, orbit.source_copies = array<i64: 16, 20>, orbit.storage = "B", orbit.target_copies = array<i64: 25, 26>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%419) : (!air.async.token) -> ()
          %420 = "arith.constant"() <{value = 0 : index}> : () -> index
          %421 = "arith.constant"() <{value = 8 : index}> : () -> index
          %422 = "arith.constant"() <{value = 1 : index}> : () -> index
          %423 = "scf.for"(%420, %421, %422, %419) ({
          ^bb0(%arg137: index, %arg138: !air.async.token):
            %424 = "arith.constant"() <{value = 4 : index}> : () -> index
            %425 = "arith.muli"(%arg137, %424) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %426 = "arith.constant"() <{value = 4 : index}> : () -> index
            %427 = "arith.muli"(%arg137, %426) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %428 = "arith.constant"() <{value = 4 : index}> : () -> index
            %429 = "arith.muli"(%arg137, %428) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %430 = "memref.reinterpret_cast"(%416) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 32 : i64, orbit.storage = "intermediate"} : (memref<64xf32, 2 : i32>) -> memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %431 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %432 = "arith.constant"() <{value = 0 : index}> : () -> index
            %433 = "arith.constant"() <{value = 4 : index}> : () -> index
            %434 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%432, %433, %434) ({
            ^bb0(%arg144: index):
              %508 = "arith.addi"(%arg144, %425) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %509 = "arith.constant"() <{value = 0 : index}> : () -> index
              %510 = "arith.constant"() <{value = 16 : index}> : () -> index
              %511 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%509, %510, %511) ({
              ^bb0(%arg145: index):
                %512 = "arith.subi"(%508, %429) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%431, %430, %512, %arg145) <{nontemporal = false}> : (f32, memref<4x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %435 = "arith.constant"() <{value = 0 : index}> : () -> index
            %436 = "arith.constant"() <{value = 2 : index}> : () -> index
            %437 = "arith.constant"() <{value = 1 : index}> : () -> index
            %438 = "scf.for"(%435, %436, %437, %arg138) ({
            ^bb0(%arg139: index, %arg140: !air.async.token):
              %443 = "arith.constant"() <{value = 64 : index}> : () -> index
              %444 = "arith.muli"(%arg139, %443) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %445 = "arith.constant"() <{value = 64 : index}> : () -> index
              %446 = "arith.muli"(%arg139, %445) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %447 = "arith.constant"() <{value = 64 : index}> : () -> index
              %448 = "arith.muli"(%arg139, %447) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %449 = "memref.reinterpret_cast"(%414) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 32 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %450 = "arith.constant"() <{value = 0 : index}> : () -> index
              %451 = "arith.addi"(%450, %427) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %452 = "arith.constant"() <{value = 0 : index}> : () -> index
              %453 = "arith.addi"(%452, %446) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %454 = "air.dma_memcpy_nd"(%arg140, %449, %arg133, %451, %453) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 32 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 24>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 4, 64>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<4x64xf32, strided<[64, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%454) {orbit.computation_event = 3 : i64, orbit.phase = 32 : i64, orbit.phase_dependencies = array<i64: 31>, orbit.read_copies = array<i64: 24, 25, 27>, orbit.task = "gemm", orbit.write_copies = array<i64: 28>} : (!air.async.token) -> ()
              %455 = "memref.cast"(%449) : (memref<4x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<4x64xf32, 2 : i32>
              %456 = "memref.cast"(%418) : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<128x16xf32, 2 : i32>
              %457 = "memref.cast"(%430) : (memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<4x16xf32, 2 : i32>
              %458 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %459 = "arith.constant"() <{value = 0 : index}> : () -> index
              %460 = "arith.constant"() <{value = 4 : index}> : () -> index
              %461 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%459, %460, %461) ({
              ^bb0(%arg141: index):
                %463 = "arith.addi"(%arg141, %425) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %464 = "arith.constant"() <{value = 0 : index}> : () -> index
                %465 = "arith.constant"() <{value = 16 : index}> : () -> index
                %466 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%464, %465, %466) ({
                ^bb0(%arg142: index):
                  %467 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %468 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %469 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%467, %468, %469) ({
                  ^bb0(%arg143: index):
                    %470 = "arith.addi"(%arg143, %444) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %471 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %472 = "arith.subi"(%463, %427) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %473 = "arith.subi"(%470, %446) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %474 = "memref.load"(%455, %472, %473) <{nontemporal = false}> : (memref<4x64xf32, 2 : i32>, index, index) -> f32
                    %475 = "vector.broadcast"(%474) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                    %476 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %477 = "vector.transfer_read"(%456, %470, %arg142, %476) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<128x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %478 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %479 = "arith.subi"(%463, %429) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %480 = "vector.transfer_read"(%457, %479, %arg142, %478) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %481 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                    %482 = "vector.extract"(%477) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %483 = "func.call"(%474, %482) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %484 = "vector.insert"(%483, %481) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %485 = "vector.extract"(%477) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %486 = "func.call"(%474, %485) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %487 = "vector.insert"(%486, %484) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %488 = "vector.extract"(%477) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %489 = "func.call"(%474, %488) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %490 = "vector.insert"(%489, %487) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %491 = "vector.extract"(%477) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %492 = "func.call"(%474, %491) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %493 = "vector.insert"(%492, %490) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %494 = "vector.extract"(%477) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %495 = "func.call"(%474, %494) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %496 = "vector.insert"(%495, %493) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %497 = "vector.extract"(%477) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %498 = "func.call"(%474, %497) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %499 = "vector.insert"(%498, %496) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %500 = "vector.extract"(%477) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %501 = "func.call"(%474, %500) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %502 = "vector.insert"(%501, %499) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %503 = "vector.extract"(%477) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %504 = "func.call"(%474, %503) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %505 = "vector.insert"(%504, %502) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %506 = "arith.addf"(%480, %505) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %507 = "arith.subi"(%463, %429) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%506, %457, %507, %arg142) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x16xf32, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %462 = "air.wait_all"(%arg140) : (!air.async.token) -> !air.async.token
              "scf.yield"(%462) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %439 = "arith.constant"() <{value = 0 : index}> : () -> index
            %440 = "arith.addi"(%439, %429) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %441 = "air.dma_memcpy_nd"(%438, %arg136, %440, %430) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 33 : i64, orbit.retained_begin = 32 : i64, orbit.retained_end = 34 : i64, orbit.source_copies = array<i64: 30>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 31>, orbit.transfer = "l1_to_host", orbit.transfer_event = 6 : i64, static_dst_offsets = array<i64: -9223372036854775808, 0>, static_dst_sizes = array<i64: 4, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %442 = "air.wait_all"(%441) : (!air.async.token) -> !air.async.token
            "scf.yield"(%442) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 8 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%423) : (!air.async.token) -> ()
          "memref.dealloc"(%414) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%415) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%416) : (memref<64xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg88: index, %arg89: index, %arg90: index, %arg91: index, %arg92: memref<32x128xf32>, %arg93: memref<128x64xf32>, %arg94: memref<32x64xf32>, %arg95: memref<32x64xf32>):
      "air.segment"(%arg92, %arg93, %arg94, %arg95) ({
      ^bb0(%arg96: memref<32x128xf32>, %arg97: memref<128x64xf32>, %arg98: memref<32x64xf32>, %arg99: memref<32x64xf32>):
        %305 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%305, %305, %arg96, %arg97, %arg98, %arg99) ({
        ^bb0(%arg100: index, %arg101: index, %arg102: index, %arg103: index, %arg104: memref<32x128xf32>, %arg105: memref<128x64xf32>, %arg106: memref<32x64xf32>, %arg107: memref<32x64xf32>):
          %306 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : () -> memref<256xf32, 2 : i32>
          %307 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %308 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<64xf32, 2 : i32>
          %309 = "air.wait_all"() : () -> !air.async.token
          %310 = "memref.reinterpret_cast"(%307) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 48 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %311 = "air.dma_memcpy_nd"(%309, %310, %arg105) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 48 : i64, orbit.readonly_retained_begin = 48 : i64, orbit.readonly_retained_end = 64 : i64, orbit.source_copies = array<i64: 17, 21>, orbit.storage = "B", orbit.target_copies = array<i64: 75, 76>, orbit.transfer = "host_to_l1", orbit.transfer_event = 50 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 16>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%311) : (!air.async.token) -> ()
          %312 = "arith.constant"() <{value = 0 : index}> : () -> index
          %313 = "arith.constant"() <{value = 8 : index}> : () -> index
          %314 = "arith.constant"() <{value = 1 : index}> : () -> index
          %315 = "scf.for"(%312, %313, %314, %311) ({
          ^bb0(%arg108: index, %arg109: !air.async.token):
            %316 = "arith.constant"() <{value = 4 : index}> : () -> index
            %317 = "arith.muli"(%arg108, %316) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %318 = "arith.constant"() <{value = 4 : index}> : () -> index
            %319 = "arith.muli"(%arg108, %318) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %320 = "arith.constant"() <{value = 4 : index}> : () -> index
            %321 = "arith.muli"(%arg108, %320) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %322 = "memref.reinterpret_cast"(%308) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 48 : i64, orbit.storage = "intermediate"} : (memref<64xf32, 2 : i32>) -> memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %323 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %324 = "arith.constant"() <{value = 0 : index}> : () -> index
            %325 = "arith.constant"() <{value = 4 : index}> : () -> index
            %326 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%324, %325, %326) ({
            ^bb0(%arg115: index):
              %406 = "arith.addi"(%arg115, %317) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %407 = "arith.constant"() <{value = 16 : index}> : () -> index
              %408 = "arith.constant"() <{value = 32 : index}> : () -> index
              %409 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%407, %408, %409) ({
              ^bb0(%arg116: index):
                %410 = "arith.constant"() <{value = 16 : index}> : () -> index
                %411 = "arith.subi"(%arg116, %410) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %412 = "arith.subi"(%406, %321) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%323, %322, %412, %411) <{nontemporal = false}> : (f32, memref<4x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %327 = "arith.constant"() <{value = 0 : index}> : () -> index
            %328 = "arith.constant"() <{value = 2 : index}> : () -> index
            %329 = "arith.constant"() <{value = 1 : index}> : () -> index
            %330 = "scf.for"(%327, %328, %329, %arg109) ({
            ^bb0(%arg110: index, %arg111: !air.async.token):
              %335 = "arith.constant"() <{value = 64 : index}> : () -> index
              %336 = "arith.muli"(%arg110, %335) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %337 = "arith.constant"() <{value = 64 : index}> : () -> index
              %338 = "arith.muli"(%arg110, %337) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %339 = "arith.constant"() <{value = 64 : index}> : () -> index
              %340 = "arith.muli"(%arg110, %339) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %341 = "memref.reinterpret_cast"(%306) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 48 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %342 = "arith.constant"() <{value = 0 : index}> : () -> index
              %343 = "arith.addi"(%342, %319) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %344 = "arith.constant"() <{value = 0 : index}> : () -> index
              %345 = "arith.addi"(%344, %338) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %346 = "air.dma_memcpy_nd"(%arg111, %341, %arg104, %343, %345) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 48 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 74>, orbit.transfer = "host_to_l1", orbit.transfer_event = 49 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 4, 64>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<4x64xf32, strided<[64, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%346) {orbit.computation_event = 52 : i64, orbit.phase = 48 : i64, orbit.phase_dependencies = array<i64: 47>, orbit.read_copies = array<i64: 74, 75, 77>, orbit.task = "gemm", orbit.write_copies = array<i64: 78>} : (!air.async.token) -> ()
              %347 = "memref.cast"(%341) : (memref<4x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<4x64xf32, 2 : i32>
              %348 = "memref.cast"(%310) : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<128x16xf32, 2 : i32>
              %349 = "memref.cast"(%322) : (memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<4x16xf32, 2 : i32>
              %350 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %351 = "arith.constant"() <{value = 0 : index}> : () -> index
              %352 = "arith.constant"() <{value = 4 : index}> : () -> index
              %353 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%351, %352, %353) ({
              ^bb0(%arg112: index):
                %355 = "arith.addi"(%arg112, %317) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %356 = "arith.constant"() <{value = 16 : index}> : () -> index
                %357 = "arith.constant"() <{value = 32 : index}> : () -> index
                %358 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%356, %357, %358) ({
                ^bb0(%arg113: index):
                  %359 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %360 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %361 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%359, %360, %361) ({
                  ^bb0(%arg114: index):
                    %362 = "arith.addi"(%arg114, %336) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %363 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %364 = "arith.subi"(%355, %319) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %365 = "arith.subi"(%362, %338) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %366 = "memref.load"(%347, %364, %365) <{nontemporal = false}> : (memref<4x64xf32, 2 : i32>, index, index) -> f32
                    %367 = "vector.broadcast"(%366) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                    %368 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %369 = "arith.constant"() <{value = 16 : index}> : () -> index
                    %370 = "arith.subi"(%arg113, %369) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %371 = "vector.transfer_read"(%348, %362, %370, %368) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<128x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %372 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %373 = "arith.subi"(%355, %321) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %374 = "arith.constant"() <{value = 16 : index}> : () -> index
                    %375 = "arith.subi"(%arg113, %374) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %376 = "vector.transfer_read"(%349, %373, %375, %372) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %377 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                    %378 = "vector.extract"(%371) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %379 = "func.call"(%366, %378) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %380 = "vector.insert"(%379, %377) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %381 = "vector.extract"(%371) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %382 = "func.call"(%366, %381) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %383 = "vector.insert"(%382, %380) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %384 = "vector.extract"(%371) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %385 = "func.call"(%366, %384) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %386 = "vector.insert"(%385, %383) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %387 = "vector.extract"(%371) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %388 = "func.call"(%366, %387) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %389 = "vector.insert"(%388, %386) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %390 = "vector.extract"(%371) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %391 = "func.call"(%366, %390) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %392 = "vector.insert"(%391, %389) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %393 = "vector.extract"(%371) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %394 = "func.call"(%366, %393) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %395 = "vector.insert"(%394, %392) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %396 = "vector.extract"(%371) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %397 = "func.call"(%366, %396) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %398 = "vector.insert"(%397, %395) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %399 = "vector.extract"(%371) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %400 = "func.call"(%366, %399) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %401 = "vector.insert"(%400, %398) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %402 = "arith.addf"(%376, %401) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %403 = "arith.subi"(%355, %321) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %404 = "arith.constant"() <{value = 16 : index}> : () -> index
                    %405 = "arith.subi"(%arg113, %404) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%402, %349, %403, %405) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x16xf32, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %354 = "air.wait_all"(%arg111) : (!air.async.token) -> !air.async.token
              "scf.yield"(%354) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %331 = "arith.constant"() <{value = 0 : index}> : () -> index
            %332 = "arith.addi"(%331, %321) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %333 = "air.dma_memcpy_nd"(%330, %arg107, %332, %322) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 49 : i64, orbit.retained_begin = 48 : i64, orbit.retained_end = 50 : i64, orbit.source_copies = array<i64: 80>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 81>, orbit.transfer = "l1_to_host", orbit.transfer_event = 55 : i64, static_dst_offsets = array<i64: -9223372036854775808, 16>, static_dst_sizes = array<i64: 4, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %334 = "air.wait_all"(%333) : (!air.async.token) -> !air.async.token
            "scf.yield"(%334) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 8 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%315) : (!air.async.token) -> ()
          "memref.dealloc"(%306) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%307) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%308) : (memref<64xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_48"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_48"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_48"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg59: index, %arg60: index, %arg61: index, %arg62: index, %arg63: memref<32x128xf32>, %arg64: memref<128x64xf32>, %arg65: memref<32x64xf32>, %arg66: memref<32x64xf32>):
      "air.segment"(%arg63, %arg64, %arg65, %arg66) ({
      ^bb0(%arg67: memref<32x128xf32>, %arg68: memref<128x64xf32>, %arg69: memref<32x64xf32>, %arg70: memref<32x64xf32>):
        %197 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%197, %197, %arg67, %arg68, %arg69, %arg70) ({
        ^bb0(%arg71: index, %arg72: index, %arg73: index, %arg74: index, %arg75: memref<32x128xf32>, %arg76: memref<128x64xf32>, %arg77: memref<32x64xf32>, %arg78: memref<32x64xf32>):
          %198 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : () -> memref<256xf32, 2 : i32>
          %199 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %200 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<64xf32, 2 : i32>
          %201 = "air.wait_all"() : () -> !air.async.token
          %202 = "memref.reinterpret_cast"(%199) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 64 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %203 = "air.dma_memcpy_nd"(%201, %202, %arg76) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 64 : i64, orbit.readonly_retained_begin = 64 : i64, orbit.readonly_retained_end = 80 : i64, orbit.source_copies = array<i64: 18, 22>, orbit.storage = "B", orbit.target_copies = array<i64: 125, 126>, orbit.transfer = "host_to_l1", orbit.transfer_event = 99 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 32>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%203) : (!air.async.token) -> ()
          %204 = "arith.constant"() <{value = 0 : index}> : () -> index
          %205 = "arith.constant"() <{value = 8 : index}> : () -> index
          %206 = "arith.constant"() <{value = 1 : index}> : () -> index
          %207 = "scf.for"(%204, %205, %206, %203) ({
          ^bb0(%arg79: index, %arg80: !air.async.token):
            %208 = "arith.constant"() <{value = 4 : index}> : () -> index
            %209 = "arith.muli"(%arg79, %208) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %210 = "arith.constant"() <{value = 4 : index}> : () -> index
            %211 = "arith.muli"(%arg79, %210) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %212 = "arith.constant"() <{value = 4 : index}> : () -> index
            %213 = "arith.muli"(%arg79, %212) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %214 = "memref.reinterpret_cast"(%200) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 64 : i64, orbit.storage = "intermediate"} : (memref<64xf32, 2 : i32>) -> memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %215 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %216 = "arith.constant"() <{value = 0 : index}> : () -> index
            %217 = "arith.constant"() <{value = 4 : index}> : () -> index
            %218 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%216, %217, %218) ({
            ^bb0(%arg86: index):
              %298 = "arith.addi"(%arg86, %209) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %299 = "arith.constant"() <{value = 32 : index}> : () -> index
              %300 = "arith.constant"() <{value = 48 : index}> : () -> index
              %301 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%299, %300, %301) ({
              ^bb0(%arg87: index):
                %302 = "arith.constant"() <{value = 32 : index}> : () -> index
                %303 = "arith.subi"(%arg87, %302) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %304 = "arith.subi"(%298, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%215, %214, %304, %303) <{nontemporal = false}> : (f32, memref<4x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %219 = "arith.constant"() <{value = 0 : index}> : () -> index
            %220 = "arith.constant"() <{value = 2 : index}> : () -> index
            %221 = "arith.constant"() <{value = 1 : index}> : () -> index
            %222 = "scf.for"(%219, %220, %221, %arg80) ({
            ^bb0(%arg81: index, %arg82: !air.async.token):
              %227 = "arith.constant"() <{value = 64 : index}> : () -> index
              %228 = "arith.muli"(%arg81, %227) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %229 = "arith.constant"() <{value = 64 : index}> : () -> index
              %230 = "arith.muli"(%arg81, %229) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %231 = "arith.constant"() <{value = 64 : index}> : () -> index
              %232 = "arith.muli"(%arg81, %231) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %233 = "memref.reinterpret_cast"(%198) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 64 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %234 = "arith.constant"() <{value = 0 : index}> : () -> index
              %235 = "arith.addi"(%234, %211) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %236 = "arith.constant"() <{value = 0 : index}> : () -> index
              %237 = "arith.addi"(%236, %230) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %238 = "air.dma_memcpy_nd"(%arg82, %233, %arg75, %235, %237) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 64 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 124>, orbit.transfer = "host_to_l1", orbit.transfer_event = 98 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 4, 64>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<4x64xf32, strided<[64, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%238) {orbit.computation_event = 101 : i64, orbit.phase = 64 : i64, orbit.phase_dependencies = array<i64: 63>, orbit.read_copies = array<i64: 124, 125, 127>, orbit.task = "gemm", orbit.write_copies = array<i64: 128>} : (!air.async.token) -> ()
              %239 = "memref.cast"(%233) : (memref<4x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<4x64xf32, 2 : i32>
              %240 = "memref.cast"(%202) : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<128x16xf32, 2 : i32>
              %241 = "memref.cast"(%214) : (memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<4x16xf32, 2 : i32>
              %242 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %243 = "arith.constant"() <{value = 0 : index}> : () -> index
              %244 = "arith.constant"() <{value = 4 : index}> : () -> index
              %245 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%243, %244, %245) ({
              ^bb0(%arg83: index):
                %247 = "arith.addi"(%arg83, %209) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %248 = "arith.constant"() <{value = 32 : index}> : () -> index
                %249 = "arith.constant"() <{value = 48 : index}> : () -> index
                %250 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%248, %249, %250) ({
                ^bb0(%arg84: index):
                  %251 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %252 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %253 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%251, %252, %253) ({
                  ^bb0(%arg85: index):
                    %254 = "arith.addi"(%arg85, %228) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %255 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %256 = "arith.subi"(%247, %211) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %257 = "arith.subi"(%254, %230) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %258 = "memref.load"(%239, %256, %257) <{nontemporal = false}> : (memref<4x64xf32, 2 : i32>, index, index) -> f32
                    %259 = "vector.broadcast"(%258) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                    %260 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %261 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %262 = "arith.subi"(%arg84, %261) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %263 = "vector.transfer_read"(%240, %254, %262, %260) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<128x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %264 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %265 = "arith.subi"(%247, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %266 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %267 = "arith.subi"(%arg84, %266) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %268 = "vector.transfer_read"(%241, %265, %267, %264) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %269 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                    %270 = "vector.extract"(%263) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %271 = "func.call"(%258, %270) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %272 = "vector.insert"(%271, %269) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %273 = "vector.extract"(%263) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %274 = "func.call"(%258, %273) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %275 = "vector.insert"(%274, %272) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %276 = "vector.extract"(%263) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %277 = "func.call"(%258, %276) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %278 = "vector.insert"(%277, %275) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %279 = "vector.extract"(%263) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %280 = "func.call"(%258, %279) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %281 = "vector.insert"(%280, %278) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %282 = "vector.extract"(%263) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %283 = "func.call"(%258, %282) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %284 = "vector.insert"(%283, %281) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %285 = "vector.extract"(%263) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %286 = "func.call"(%258, %285) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %287 = "vector.insert"(%286, %284) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %288 = "vector.extract"(%263) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %289 = "func.call"(%258, %288) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %290 = "vector.insert"(%289, %287) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %291 = "vector.extract"(%263) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %292 = "func.call"(%258, %291) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %293 = "vector.insert"(%292, %290) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %294 = "arith.addf"(%268, %293) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %295 = "arith.subi"(%247, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %296 = "arith.constant"() <{value = 32 : index}> : () -> index
                    %297 = "arith.subi"(%arg84, %296) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%294, %241, %295, %297) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x16xf32, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %246 = "air.wait_all"(%arg82) : (!air.async.token) -> !air.async.token
              "scf.yield"(%246) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %223 = "arith.constant"() <{value = 0 : index}> : () -> index
            %224 = "arith.addi"(%223, %213) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %225 = "air.dma_memcpy_nd"(%222, %arg78, %224, %214) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 65 : i64, orbit.retained_begin = 64 : i64, orbit.retained_end = 66 : i64, orbit.source_copies = array<i64: 130>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 131>, orbit.transfer = "l1_to_host", orbit.transfer_event = 104 : i64, static_dst_offsets = array<i64: -9223372036854775808, 32>, static_dst_sizes = array<i64: 4, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %226 = "air.wait_all"(%225) : (!air.async.token) -> !air.async.token
            "scf.yield"(%226) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 8 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%207) : (!air.async.token) -> ()
          "memref.dealloc"(%198) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%199) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%200) : (memref<64xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_64"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_64"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_64"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg30: index, %arg31: index, %arg32: index, %arg33: index, %arg34: memref<32x128xf32>, %arg35: memref<128x64xf32>, %arg36: memref<32x64xf32>, %arg37: memref<32x64xf32>):
      "air.segment"(%arg34, %arg35, %arg36, %arg37) ({
      ^bb0(%arg38: memref<32x128xf32>, %arg39: memref<128x64xf32>, %arg40: memref<32x64xf32>, %arg41: memref<32x64xf32>):
        %89 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%89, %89, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<32x128xf32>, %arg47: memref<128x64xf32>, %arg48: memref<32x64xf32>, %arg49: memref<32x64xf32>):
          %90 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.4.64.loops.4.16.64"} : () -> memref<256xf32, 2 : i32>
          %91 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.readonly-panel"} : () -> memref<2048xf32, 2 : i32>
          %92 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<64xf32, 2 : i32>
          %93 = "air.wait_all"() : () -> !air.async.token
          %94 = "memref.reinterpret_cast"(%91) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 128, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 80 : i64, orbit.storage = "B"} : (memref<2048xf32, 2 : i32>) -> memref<128x16xf32, strided<[16, 1]>, 2 : i32>
          %95 = "air.dma_memcpy_nd"(%93, %94, %arg47) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 80 : i64, orbit.readonly_retained_begin = 80 : i64, orbit.readonly_retained_end = 96 : i64, orbit.source_copies = array<i64: 19, 23>, orbit.storage = "B", orbit.target_copies = array<i64: 175, 176>, orbit.transfer = "host_to_l1", orbit.transfer_event = 148 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 128, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: 0, 48>, static_src_sizes = array<i64: 128, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<128x16xf32, strided<[16, 1]>, 2 : i32>, memref<128x64xf32>) -> !air.async.token
          "air.wait_all"(%95) : (!air.async.token) -> ()
          %96 = "arith.constant"() <{value = 0 : index}> : () -> index
          %97 = "arith.constant"() <{value = 8 : index}> : () -> index
          %98 = "arith.constant"() <{value = 1 : index}> : () -> index
          %99 = "scf.for"(%96, %97, %98, %95) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %100 = "arith.constant"() <{value = 4 : index}> : () -> index
            %101 = "arith.muli"(%arg50, %100) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %102 = "arith.constant"() <{value = 4 : index}> : () -> index
            %103 = "arith.muli"(%arg50, %102) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %104 = "arith.constant"() <{value = 4 : index}> : () -> index
            %105 = "arith.muli"(%arg50, %104) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %106 = "memref.reinterpret_cast"(%92) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 16>, static_strides = array<i64: 16, 1>}> {orbit.initializer_task = "gemm.initialize", orbit.phase = 80 : i64, orbit.storage = "intermediate"} : (memref<64xf32, 2 : i32>) -> memref<4x16xf32, strided<[16, 1]>, 2 : i32>
            %107 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
            %108 = "arith.constant"() <{value = 0 : index}> : () -> index
            %109 = "arith.constant"() <{value = 4 : index}> : () -> index
            %110 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%108, %109, %110) ({
            ^bb0(%arg57: index):
              %190 = "arith.addi"(%arg57, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %191 = "arith.constant"() <{value = 48 : index}> : () -> index
              %192 = "arith.constant"() <{value = 64 : index}> : () -> index
              %193 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%191, %192, %193) ({
              ^bb0(%arg58: index):
                %194 = "arith.constant"() <{value = 48 : index}> : () -> index
                %195 = "arith.subi"(%arg58, %194) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %196 = "arith.subi"(%190, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                "memref.store"(%107, %106, %196, %195) <{nontemporal = false}> : (f32, memref<4x16xf32, strided<[16, 1]>, 2 : i32>, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            %111 = "arith.constant"() <{value = 0 : index}> : () -> index
            %112 = "arith.constant"() <{value = 2 : index}> : () -> index
            %113 = "arith.constant"() <{value = 1 : index}> : () -> index
            %114 = "scf.for"(%111, %112, %113, %arg51) ({
            ^bb0(%arg52: index, %arg53: !air.async.token):
              %119 = "arith.constant"() <{value = 64 : index}> : () -> index
              %120 = "arith.muli"(%arg52, %119) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %121 = "arith.constant"() <{value = 64 : index}> : () -> index
              %122 = "arith.muli"(%arg52, %121) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %123 = "arith.constant"() <{value = 64 : index}> : () -> index
              %124 = "arith.muli"(%arg52, %123) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %125 = "memref.reinterpret_cast"(%90) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 80 : i64, orbit.storage = "A"} : (memref<256xf32, 2 : i32>) -> memref<4x64xf32, strided<[64, 1]>, 2 : i32>
              %126 = "arith.constant"() <{value = 0 : index}> : () -> index
              %127 = "arith.addi"(%126, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %128 = "arith.constant"() <{value = 0 : index}> : () -> index
              %129 = "arith.addi"(%128, %122) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %130 = "air.dma_memcpy_nd"(%arg53, %125, %arg46, %127, %129) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 80 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 174>, orbit.transfer = "host_to_l1", orbit.transfer_event = 147 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 64>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 4, 64>, static_src_strides = array<i64: 128, 1>} : (!air.async.token, memref<4x64xf32, strided<[64, 1]>, 2 : i32>, memref<32x128xf32>, index, index) -> !air.async.token
              "air.wait_all"(%130) {orbit.computation_event = 150 : i64, orbit.phase = 80 : i64, orbit.phase_dependencies = array<i64: 79>, orbit.read_copies = array<i64: 174, 175, 177>, orbit.task = "gemm", orbit.write_copies = array<i64: 178>} : (!air.async.token) -> ()
              %131 = "memref.cast"(%125) : (memref<4x64xf32, strided<[64, 1]>, 2 : i32>) -> memref<4x64xf32, 2 : i32>
              %132 = "memref.cast"(%94) : (memref<128x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<128x16xf32, 2 : i32>
              %133 = "memref.cast"(%106) : (memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<4x16xf32, 2 : i32>
              %134 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
              %135 = "arith.constant"() <{value = 0 : index}> : () -> index
              %136 = "arith.constant"() <{value = 4 : index}> : () -> index
              %137 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%135, %136, %137) ({
              ^bb0(%arg54: index):
                %139 = "arith.addi"(%arg54, %101) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %140 = "arith.constant"() <{value = 48 : index}> : () -> index
                %141 = "arith.constant"() <{value = 64 : index}> : () -> index
                %142 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%140, %141, %142) ({
                ^bb0(%arg55: index):
                  %143 = "arith.constant"() <{value = 0 : index}> : () -> index
                  %144 = "arith.constant"() <{value = 64 : index}> : () -> index
                  %145 = "arith.constant"() <{value = 1 : index}> : () -> index
                  "scf.for"(%143, %144, %145) ({
                  ^bb0(%arg56: index):
                    %146 = "arith.addi"(%arg56, %120) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %147 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %148 = "arith.subi"(%139, %103) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %149 = "arith.subi"(%146, %122) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %150 = "memref.load"(%131, %148, %149) <{nontemporal = false}> : (memref<4x64xf32, 2 : i32>, index, index) -> f32
                    %151 = "vector.broadcast"(%150) {orbit.invariant_scalar_broadcast} : (f32) -> vector<8xf32>
                    %152 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %153 = "arith.constant"() <{value = 48 : index}> : () -> index
                    %154 = "arith.subi"(%arg55, %153) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %155 = "vector.transfer_read"(%132, %146, %154, %152) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<128x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %156 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                    %157 = "arith.subi"(%139, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %158 = "arith.constant"() <{value = 48 : index}> : () -> index
                    %159 = "arith.subi"(%arg55, %158) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %160 = "vector.transfer_read"(%133, %157, %159, %156) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                    %161 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                    %162 = "vector.extract"(%155) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                    %163 = "func.call"(%150, %162) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %164 = "vector.insert"(%163, %161) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %165 = "vector.extract"(%155) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                    %166 = "func.call"(%150, %165) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %167 = "vector.insert"(%166, %164) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %168 = "vector.extract"(%155) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                    %169 = "func.call"(%150, %168) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %170 = "vector.insert"(%169, %167) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %171 = "vector.extract"(%155) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                    %172 = "func.call"(%150, %171) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %173 = "vector.insert"(%172, %170) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %174 = "vector.extract"(%155) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                    %175 = "func.call"(%150, %174) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %176 = "vector.insert"(%175, %173) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %177 = "vector.extract"(%155) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                    %178 = "func.call"(%150, %177) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %179 = "vector.insert"(%178, %176) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %180 = "vector.extract"(%155) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                    %181 = "func.call"(%150, %180) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %182 = "vector.insert"(%181, %179) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %183 = "vector.extract"(%155) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                    %184 = "func.call"(%150, %183) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                    %185 = "vector.insert"(%184, %182) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                    %186 = "arith.addf"(%160, %185) <{fastmath = #arith.fastmath<none>}> : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
                    %187 = "arith.subi"(%139, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    %188 = "arith.constant"() <{value = 48 : index}> : () -> index
                    %189 = "arith.subi"(%arg55, %188) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                    "vector.transfer_write"(%186, %133, %187, %189) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x16xf32, 2 : i32>, index, index) -> ()
                    "scf.yield"() : () -> ()
                  }) : (index, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %138 = "air.wait_all"(%arg53) : (!air.async.token) -> !air.async.token
              "scf.yield"(%138) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            %115 = "arith.constant"() <{value = 0 : index}> : () -> index
            %116 = "arith.addi"(%115, %105) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %117 = "air.dma_memcpy_nd"(%114, %arg49, %116, %106) {operandSegmentSizes = array<i32: 1, 1, 1, 0, 0, 1, 0, 0, 0>, orbit.phase = 81 : i64, orbit.retained_begin = 80 : i64, orbit.retained_end = 82 : i64, orbit.source_copies = array<i64: 180>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 181>, orbit.transfer = "l1_to_host", orbit.transfer_event = 153 : i64, static_dst_offsets = array<i64: -9223372036854775808, 48>, static_dst_sizes = array<i64: 4, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<32x64xf32>, index, memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
            %118 = "air.wait_all"(%117) : (!air.async.token) -> !air.async.token
            "scf.yield"(%118) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 8 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%99) : (!air.async.token) -> ()
          "memref.dealloc"(%90) : (memref<256xf32, 2 : i32>) -> ()
          "memref.dealloc"(%91) : (memref<2048xf32, 2 : i32>) -> ()
          "memref.dealloc"(%92) : (memref<64xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_80"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_80"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_80"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<32x128xf32>, %arg9: memref<128x64xf32>, %arg10: memref<32x64xf32>, %arg11: memref<32x64xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<32x128xf32>, %arg13: memref<128x64xf32>, %arg14: memref<32x64xf32>, %arg15: memref<32x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<32x128xf32>, %arg21: memref<128x64xf32>, %arg22: memref<32x64xf32>, %arg23: memref<32x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<64xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.4.16.loops.4.16"} : () -> memref<64xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 8 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "scf.for"(%5, %6, %7, %4) ({
          ^bb0(%arg24: index, %arg25: !air.async.token):
            %9 = "arith.constant"() <{value = 4 : index}> : () -> index
            %10 = "arith.muli"(%arg24, %9) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %11 = "arith.constant"() <{value = 4 : index}> : () -> index
            %12 = "arith.muli"(%arg24, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 4 : index}> : () -> index
            %14 = "arith.muli"(%arg24, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 0 : index}> : () -> index
            %16 = "arith.constant"() <{value = 4 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg25) ({
            ^bb0(%arg26: index, %arg27: !air.async.token):
              %19 = "arith.constant"() <{value = 16 : index}> : () -> index
              %20 = "arith.muli"(%arg26, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 16 : index}> : () -> index
              %22 = "arith.muli"(%arg26, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 16 : index}> : () -> index
              %24 = "arith.muli"(%arg26, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 96 : i64, orbit.storage = "Y"} : (memref<64xf32, 2 : i32>) -> memref<4x16xf32, strided<[16, 1]>, 2 : i32>
              %26 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 4, 16>, static_strides = array<i64: 16, 1>}> {orbit.phase = 96 : i64, orbit.storage = "intermediate"} : (memref<64xf32, 2 : i32>) -> memref<4x16xf32, strided<[16, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0 : index}> : () -> index
              %28 = "arith.addi"(%27, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %29 = "arith.constant"() <{value = 0 : index}> : () -> index
              %30 = "arith.addi"(%29, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "air.dma_memcpy_nd"(%arg27, %26, %arg23, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 96 : i64, orbit.source_copies = array<i64: 31>, orbit.storage = "intermediate", orbit.target_copies = array<i64: 224>, orbit.transfer = "host_to_l1", orbit.transfer_event = 196 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 4, 16>, static_dst_strides = array<i64: 16, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 4, 16>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<4x16xf32, strided<[16, 1]>, 2 : i32>, memref<32x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%31) {orbit.computation_event = 197 : i64, orbit.phase = 96 : i64, orbit.phase_dependencies = array<i64: 95>, orbit.read_copies = array<i64: 224>, orbit.task = "scale", orbit.write_copies = array<i64: 225>} : (!air.async.token) -> ()
              %32 = "memref.cast"(%25) : (memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<4x16xf32, 2 : i32>
              %33 = "memref.cast"(%26) : (memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> memref<4x16xf32, 2 : i32>
              %34 = "arith.constant"() <{value = 5.000000e-01 : f32}> : () -> f32
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.constant"() <{value = 4 : index}> : () -> index
              %37 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%35, %36, %37) ({
              ^bb0(%arg28: index):
                %44 = "arith.addi"(%arg28, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %45 = "arith.constant"() <{value = 0 : index}> : () -> index
                %46 = "arith.constant"() <{value = 16 : index}> : () -> index
                %47 = "arith.constant"() <{value = 8 : index}> : () -> index
                "scf.for"(%45, %46, %47) ({
                ^bb0(%arg29: index):
                  %48 = "arith.addi"(%arg29, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %49 = "arith.constant"() <{value = dense<5.000000e-01> : vector<8xf32>}> : () -> vector<8xf32>
                  %50 = "arith.constant"() <{value = 0.000000e+00 : f32}> : () -> f32
                  %51 = "arith.subi"(%44, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "arith.subi"(%48, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %53 = "vector.transfer_read"(%33, %51, %52, %50) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 2, 1, 0>, permutation_map = #map}> : (memref<4x16xf32, 2 : i32>, index, index, f32) -> vector<8xf32>
                  %54 = "arith.constant"() <{value = dense<0.000000e+00> : vector<8xf32>}> : () -> vector<8xf32>
                  %55 = "vector.extract"(%53) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %56 = "vector.extract"(%49) <{static_position = array<i64: 0>}> : (vector<8xf32>) -> f32
                  %57 = "func.call"(%55, %56) <{callee = @__mulsf3}> {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %58 = "vector.insert"(%57, %54) <{static_position = array<i64: 0>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %59 = "vector.extract"(%53) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %60 = "vector.extract"(%49) <{static_position = array<i64: 1>}> : (vector<8xf32>) -> f32
                  %61 = "func.call"(%59, %60) <{callee = @__mulsf3}> {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %62 = "vector.insert"(%61, %58) <{static_position = array<i64: 1>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %63 = "vector.extract"(%53) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %64 = "vector.extract"(%49) <{static_position = array<i64: 2>}> : (vector<8xf32>) -> f32
                  %65 = "func.call"(%63, %64) <{callee = @__mulsf3}> {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %66 = "vector.insert"(%65, %62) <{static_position = array<i64: 2>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %67 = "vector.extract"(%53) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %68 = "vector.extract"(%49) <{static_position = array<i64: 3>}> : (vector<8xf32>) -> f32
                  %69 = "func.call"(%67, %68) <{callee = @__mulsf3}> {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %70 = "vector.insert"(%69, %66) <{static_position = array<i64: 3>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %71 = "vector.extract"(%53) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %72 = "vector.extract"(%49) <{static_position = array<i64: 4>}> : (vector<8xf32>) -> f32
                  %73 = "func.call"(%71, %72) <{callee = @__mulsf3}> {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %74 = "vector.insert"(%73, %70) <{static_position = array<i64: 4>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %75 = "vector.extract"(%53) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %76 = "vector.extract"(%49) <{static_position = array<i64: 5>}> : (vector<8xf32>) -> f32
                  %77 = "func.call"(%75, %76) <{callee = @__mulsf3}> {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %78 = "vector.insert"(%77, %74) <{static_position = array<i64: 5>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %79 = "vector.extract"(%53) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %80 = "vector.extract"(%49) <{static_position = array<i64: 6>}> : (vector<8xf32>) -> f32
                  %81 = "func.call"(%79, %80) <{callee = @__mulsf3}> {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %82 = "vector.insert"(%81, %78) <{static_position = array<i64: 6>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %83 = "vector.extract"(%53) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %84 = "vector.extract"(%49) <{static_position = array<i64: 7>}> : (vector<8xf32>) -> f32
                  %85 = "func.call"(%83, %84) <{callee = @__mulsf3}> {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                  %86 = "vector.insert"(%85, %82) <{static_position = array<i64: 7>}> : (f32, vector<8xf32>) -> vector<8xf32>
                  %87 = "arith.subi"(%44, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %88 = "arith.subi"(%48, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "vector.transfer_write"(%86, %32, %87, %88) <{in_bounds = [false], operandSegmentSizes = array<i32: 1, 1, 2, 0>, permutation_map = #map}> : (vector<8xf32>, memref<4x16xf32, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %38 = "arith.constant"() <{value = 0 : index}> : () -> index
              %39 = "arith.addi"(%38, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %40 = "arith.constant"() <{value = 0 : index}> : () -> index
              %41 = "arith.addi"(%40, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %42 = "air.dma_memcpy_nd"(%arg27, %arg22, %39, %41, %25) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 96 : i64, orbit.source_copies = array<i64: 225>, orbit.storage = "Y", orbit.target_copies = array<i64: 226>, orbit.transfer = "l1_to_host", orbit.transfer_event = 198 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 4, 16>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 4, 16>, static_src_strides = array<i64: 16, 1>} : (!air.async.token, memref<32x64xf32>, index, index, memref<4x16xf32, strided<[16, 1]>, 2 : i32>) -> !air.async.token
              %43 = "air.wait_all"(%42) : (!air.async.token) -> !air.async.token
              "scf.yield"(%43) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 4 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 8 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<64xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<64xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.mapping_strategy = "serial-tiled", sym_name = "orbit_herd_96"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_96"} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_96"} : (index, index, memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>, memref<32x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_scope = "readonly users within a single execution group; no cross-stage SRAM retention", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "128b42b7546feae14889d2c6b5f4cbf0843173c5c25a01781d5ccd052fb5f1a7", orbit.source_fingerprint = "ed4aa1161ac94d0400f98772a1e792c6a4d22d1d95d6afe17b4dad5786d90f2c"} : () -> ()

