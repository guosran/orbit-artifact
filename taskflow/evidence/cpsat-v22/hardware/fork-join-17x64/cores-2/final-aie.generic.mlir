#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"builtin.module"() ({
  "aie.device"() <{device = 8 : i32, sym_name = "orbit_segment"}> ({
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 1 : i32, row = 0 : i32}> : () -> index
    %2 = "aie.tile"() <{col = 1 : i32, row = 2 : i32}> : () -> index
    %3 = "aie.tile"() <{col = 0 : i32, row = 2 : i32}> : () -> index
    %4 = "aie.lock"(%2) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %5 = "aie.lock"(%2) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %6 = "aie.lock"(%2) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %7 = "aie.lock"(%2) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %8 = "aie.lock"(%3) <{init = 1 : i32, lockID = 3 : i32}> : (index) -> index
    %9 = "aie.lock"(%3) <{init = 0 : i32, lockID = 2 : i32}> : (index) -> index
    %10 = "aie.lock"(%3) <{init = 1 : i32, lockID = 1 : i32}> : (index) -> index
    %11 = "aie.lock"(%3) <{init = 0 : i32, lockID = 0 : i32}> : (index) -> index
    %12 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf9"}> : (index) -> memref<512xf32, 2 : i32>
    %13 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf8"}> : (index) -> memref<512xf32, 2 : i32>
    %14 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf7"}> : (index) -> memref<512xf32, 2 : i32>
    %15 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf6"}> : (index) -> memref<512xf32, 2 : i32>
    %16 = "aie.buffer"(%3) <{aligned = true, sym_name = "buf5"}> : (index) -> memref<512xf32, 2 : i32>
    %17 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf4"}> : (index) -> memref<576xf32, 2 : i32>
    %18 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf3"}> : (index) -> memref<576xf32, 2 : i32>
    %19 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf2"}> : (index) -> memref<576xf32, 2 : i32>
    %20 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf1"}> : (index) -> memref<576xf32, 2 : i32>
    %21 = "aie.buffer"(%2) <{aligned = true, sym_name = "buf0"}> : (index) -> memref<576xf32, 2 : i32>
    %22 = "aie.external_buffer"() <{sym_name = "__air_external_buffer"}> : () -> memref<17x64xf32>
    %23 = "aie.external_buffer"() <{sym_name = "__air_external_buffer_1"}> : () -> memref<17x64xf32>
    %24 = "aie.mem"(%3) ({
      %85 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %86 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%11, %85) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%13) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<512xf32, 2 : i32>) -> ()
      "aie.use_lock"(%10, %85) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %87 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%8, %85) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%12) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<512xf32, 2 : i32>) -> ()
      "aie.use_lock"(%9, %85) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %25 = "aie.core"(%3) <{stack_size = 8192 : i32}> ({
      %60 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %61 = "arith.constant"() <{value = 8 : index}> : () -> index
      %62 = "arith.constant"() <{value = 64 : index}> : () -> index
      %63 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
      %64 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
      %65 = "arith.constant"() <{value = 1 : index}> : () -> index
      %66 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%10, %60) <{action = 2 : i32}> : (index, i32) -> ()
      %67 = "memref.reinterpret_cast"(%12) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "aie.use_lock"(%9, %60) <{action = 2 : i32}> : (index, i32) -> ()
      %68 = "memref.reinterpret_cast"(%14) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%66, %61, %65) ({
      ^bb0(%arg18: index):
        "scf.for"(%66, %62, %65) ({
        ^bb0(%arg19: index):
          %83 = "memref.load"(%67, %arg18, %arg19) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %84 = "arith.addf"(%83, %63) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%84, %68, %arg18, %arg19) : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %69 = "memref.reinterpret_cast"(%14) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      %70 = "memref.reinterpret_cast"(%15) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "Y"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%66, %61, %65) ({
      ^bb0(%arg16: index):
        "scf.for"(%66, %62, %65) ({
        ^bb0(%arg17: index):
          %81 = "memref.load"(%69, %arg16, %arg17) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %82 = "arith.mulf"(%81, %64) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%82, %70, %arg16, %arg17) : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %71 = "memref.reinterpret_cast"(%14) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "X"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      %72 = "memref.reinterpret_cast"(%16) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "Z"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%66, %61, %65) ({
      ^bb0(%arg14: index):
        "scf.for"(%66, %62, %65) ({
        ^bb0(%arg15: index):
          %79 = "memref.load"(%71, %arg14, %arg15) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %80 = "arith.subf"(%79, %63) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%80, %72, %arg14, %arg15) : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %73 = "memref.reinterpret_cast"(%13) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      %74 = "memref.reinterpret_cast"(%15) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Y"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      %75 = "memref.reinterpret_cast"(%16) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 8, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Z"} : (memref<512xf32, 2 : i32>) -> memref<8x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%66, %61, %65) ({
      ^bb0(%arg12: index):
        "scf.for"(%66, %62, %65) ({
        ^bb0(%arg13: index):
          %76 = "memref.load"(%74, %arg12, %arg13) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %77 = "memref.load"(%75, %arg12, %arg13) : (memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %78 = "arith.addf"(%76, %77) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%78, %73, %arg12, %arg13) : (f32, memref<8x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%8, %60) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%11, %60) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_shard_1", air.herd_size = array<i64: 1, 1>} : (index) -> index
    %26 = "aie.mem"(%2) ({
      %57 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %58 = "aie.dma_start"()[^bb1, ^bb3] <{channel = 0 : i32, channel_dir = 1 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%7, %57) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%18) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<576xf32, 2 : i32>) -> ()
      "aie.use_lock"(%6, %57) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb1] : () -> ()
    ^bb2:  // pred: ^bb3
      "aie.end"() : () -> ()
    ^bb3:  // pred: ^bb0
      %59 = "aie.dma_start"()[^bb4, ^bb2] <{channel = 0 : i32, channel_dir = 0 : i32, repeat_count = 0 : i32}> : () -> i1
    ^bb4:  // 2 preds: ^bb3, ^bb4
      "aie.use_lock"(%4, %57) <{action = 2 : i32}> : (index, i32) -> ()
      "aie.dma_bd"(%17) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32}> {task_id = 0 : i32} : (memref<576xf32, 2 : i32>) -> ()
      "aie.use_lock"(%5, %57) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.next_bd"()[^bb4] : () -> ()
    }) : (index) -> index
    %27 = "aie.core"(%2) <{stack_size = 8192 : i32}> ({
      %32 = "arith.constant"() <{value = 1 : i32}> : () -> i32
      %33 = "arith.constant"() <{value = 9 : index}> : () -> index
      %34 = "arith.constant"() <{value = 64 : index}> : () -> index
      %35 = "arith.constant"() <{value = 1.000000e+00 : f32}> : () -> f32
      %36 = "arith.constant"() <{value = 2.000000e+00 : f32}> : () -> f32
      %37 = "arith.constant"() <{value = 1 : index}> : () -> index
      %38 = "arith.constant"() <{value = 0 : index}> : () -> index
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // 2 preds: ^bb0, ^bb1
      "aie.use_lock"(%6, %32) <{action = 2 : i32}> : (index, i32) -> ()
      %39 = "memref.reinterpret_cast"(%17) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "I"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "aie.use_lock"(%5, %32) <{action = 2 : i32}> : (index, i32) -> ()
      %40 = "memref.reinterpret_cast"(%19) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%38, %33, %37) ({
      ^bb0(%arg10: index):
        "scf.for"(%38, %34, %37) ({
        ^bb0(%arg11: index):
          %55 = "memref.load"(%39, %arg10, %arg11) : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %56 = "arith.addf"(%55, %35) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%56, %40, %arg10, %arg11) : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %41 = "memref.reinterpret_cast"(%19) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "X"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      %42 = "memref.reinterpret_cast"(%20) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 1 : i64, orbit.storage = "Y"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%38, %33, %37) ({
      ^bb0(%arg8: index):
        "scf.for"(%38, %34, %37) ({
        ^bb0(%arg9: index):
          %53 = "memref.load"(%41, %arg8, %arg9) : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %54 = "arith.mulf"(%53, %36) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%54, %42, %arg8, %arg9) : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %43 = "memref.reinterpret_cast"(%19) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "X"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      %44 = "memref.reinterpret_cast"(%21) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 2 : i64, orbit.storage = "Z"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%38, %33, %37) ({
      ^bb0(%arg6: index):
        "scf.for"(%38, %34, %37) ({
        ^bb0(%arg7: index):
          %51 = "memref.load"(%43, %arg6, %arg7) : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %52 = "arith.subf"(%51, %35) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%52, %44, %arg6, %arg7) : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      %45 = "memref.reinterpret_cast"(%18) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "R"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      %46 = "memref.reinterpret_cast"(%20) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Y"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      %47 = "memref.reinterpret_cast"(%21) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 9, 64>, static_strides = array<i64: 64, 1>}> {orbit.phase = 3 : i64, orbit.storage = "Z"} : (memref<576xf32, 2 : i32>) -> memref<9x64xf32, strided<[64, 1]>, 2 : i32>
      "scf.for"(%38, %33, %37) ({
      ^bb0(%arg4: index):
        "scf.for"(%38, %34, %37) ({
        ^bb0(%arg5: index):
          %48 = "memref.load"(%46, %arg4, %arg5) : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %49 = "memref.load"(%47, %arg4, %arg5) : (memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> f32
          %50 = "arith.addf"(%48, %49) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%50, %45, %arg4, %arg5) : (f32, memref<9x64xf32, strided<[64, 1]>, 2 : i32>, index, index) -> ()
          "scf.yield"() : () -> ()
        }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
        "scf.yield"() : () -> ()
      }) {loop_annotation = #loop_annotation} : (index, index, index) -> ()
      "aie.use_lock"(%4, %32) <{action = 1 : i32}> : (index, i32) -> ()
      "aie.use_lock"(%7, %32) <{action = 1 : i32}> : (index, i32) -> ()
      "cf.br"()[^bb1] : () -> ()
    }) {air.herd_local_id = array<i64: 0, 0>, air.herd_name = "orbit_shard_0", air.herd_size = array<i64: 1, 1>} : (index) -> index
    "aie.flow"(%1, %2) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%2, %1) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%0, %3) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.flow"(%3, %0) <{dest_bundle = 1 : i32, dest_channel = 0 : i32, source_bundle = 1 : i32, source_channel = 0 : i32}> : (index, index) -> ()
    "aie.shim_dma_allocation"(%1) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_1"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 0 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_3"}> : (index) -> ()
    "aie.shim_dma_allocation"(%1) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_0"}> : (index) -> ()
    "aie.shim_dma_allocation"(%0) <{channel_dir = 1 : i32, channel_index = 0 : i64, plio = false, sym_name = "air_channel_2"}> : (index) -> ()
    "aie.runtime_sequence"() <{sym_name = "orbit_segment_sequence"}> ({
    ^bb0(%arg2: memref<17x64xf32>, %arg3: memref<17x64xf32>):
      %28 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_1, issue_token = true}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32, static_sizes = array<i64: 576>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%28) : (index) -> ()
      %29 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_3, issue_token = true}> ({
        "aie.dma_bd"(%arg3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 576 : i32, static_sizes = array<i64: 512>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%29) : (index) -> ()
      %30 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_0}> ({
        "aie.dma_bd"(%arg2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 576 : i32, static_offset = 0 : i32, static_sizes = array<i64: 576>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%30) : (index) -> ()
      %31 = "aiex.dma_configure_task_for"() <{alloc = @air_channel_2}> ({
        "aie.dma_bd"(%arg2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0, 0, 0>, static_len = 512 : i32, static_offset = 576 : i32, static_sizes = array<i64: 512>, static_strides = array<i64: 1>}> : (memref<17x64xf32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%31) : (index) -> ()
      "aiex.dma_await_task"(%28) : (index) -> ()
      "aiex.dma_await_task"(%29) : (index) -> ()
      "aiex.dma_free_task"(%30) : (index) -> ()
      "aiex.dma_free_task"(%31) : (index) -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) {dlti.dl_spec = #dlti.dl_spec<index = 32 : i64>} : () -> ()
  "aie.device"() <{device = 8 : i32, sym_name = "main"}> ({
    "aie.runtime_sequence"() <{sym_name = "fork_join_17x64"}> ({
    ^bb0(%arg0: memref<17x64xf32>, %arg1: memref<17x64xf32>):
      "aiex.configure"() <{symbol = @orbit_segment}> ({
        "aiex.run"(%arg0, %arg1) <{runtime_sequence_symbol = @orbit_segment_sequence}> : (memref<17x64xf32>, memref<17x64xf32>) -> ()
      }) : () -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "retain-across-users", orbit.data_organization_realization = "tiled-phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "independent physical shards; per-shard normalized graph and concrete placement in manifest", orbit.multicore_realization = "independent row shards, one segment, disjoint static local pools", orbit.source_fingerprint = "fe49f7fffb21a469683af2bf55f1e4dbee7a15a4b25a95dc73c267a0b2efec74"} : () -> ()

