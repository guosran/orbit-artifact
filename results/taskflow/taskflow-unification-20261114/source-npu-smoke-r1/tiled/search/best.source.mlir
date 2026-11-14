"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.name = "X", orbit.role = "input"}, {amoeba.noalias, orbit.name = "Y", orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.name = "T"} : () -> memref<64x64xf32>
    %1 = "taskflow.task"(%arg0, %0, %arg0, %0) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "double.tile.0.0"}> ({
    ^bb0(%arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>):
      %21 = "arith.constant"() <{value = 0 : index}> : () -> index
      %22 = "arith.constant"() <{value = 1 : index}> : () -> index
      %23 = "arith.constant"() <{value = 64 : index}> : () -> index
      %24 = "arith.constant"() <{value = 0 : index}> : () -> index
      %25 = "arith.constant"() <{value = 32 : index}> : () -> index
      %26 = "taskflow.counter"(%24, %25, %22) : (index, index, index) -> index
      %27 = "taskflow.counter"(%26, %21, %23, %22) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%26, %27) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg12: index, %arg13: index):
        %28 = "memref.load"(%arg10, %arg12, %arg13) : (memref<64x64xf32>, index, index) -> f32
        %29 = "arith.addf"(%28, %28) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%29, %arg11, %arg12, %arg13) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg11) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 0, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "double", amoeba.tiling.part_index = 0 : i64} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %2 = "taskflow.task"(%arg0, %0, %arg0, %0) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "double.tile.0.1"}> ({
    ^bb0(%arg6: memref<64x64xf32>, %arg7: memref<64x64xf32>):
      %12 = "arith.constant"() <{value = 0 : index}> : () -> index
      %13 = "arith.constant"() <{value = 1 : index}> : () -> index
      %14 = "arith.constant"() <{value = 64 : index}> : () -> index
      %15 = "arith.constant"() <{value = 32 : index}> : () -> index
      %16 = "arith.constant"() <{value = 64 : index}> : () -> index
      %17 = "taskflow.counter"(%15, %16, %13) : (index, index, index) -> index
      %18 = "taskflow.counter"(%17, %12, %14, %13) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%17, %18) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg8: index, %arg9: index):
        %19 = "memref.load"(%arg6, %arg8, %arg9) : (memref<64x64xf32>, index, index) -> f32
        %20 = "arith.addf"(%19, %19) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%20, %arg7, %arg8, %arg9) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg7) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 32, 64>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "double", amoeba.tiling.part_index = 1 : i64} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %3 = "taskflow.join"(%1, %2, %0) <{axis = 0 : i64, region_lower = array<i64: 0, 0>, region_upper = array<i64: 64, 64>}> : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %4 = "taskflow.task"(%3, %arg1, %0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "square"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %5 = "arith.constant"() <{value = 0 : index}> : () -> index
      %6 = "arith.constant"() <{value = 1 : index}> : () -> index
      %7 = "arith.constant"() <{value = 64 : index}> : () -> index
      %8 = "taskflow.counter"(%5, %7, %6) : (index, index, index) -> index
      %9 = "taskflow.counter"(%8, %5, %7, %6) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%8, %9) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %10 = "memref.load"(%arg2, %arg4, %arg5) : (memref<64x64xf32>, index, index) -> f32
        %11 = "arith.mulf"(%10, %10) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%11, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg3) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.air_tile_sizes = array<i64: 32, 32, 1>} : () -> ()
