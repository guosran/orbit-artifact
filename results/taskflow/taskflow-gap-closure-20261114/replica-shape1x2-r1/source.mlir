"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.role = "input"}, {amoeba.noalias, orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.0"}> ({
    ^bb0(%arg6: memref<64x64xf32>, %arg7: memref<64x64xf32>):
      %13 = "arith.constant"() <{value = 0 : index}> : () -> index
      %14 = "arith.constant"() <{value = 1 : index}> : () -> index
      %15 = "arith.constant"() <{value = 64 : index}> : () -> index
      %16 = "arith.constant"() <{value = 64 : index}> : () -> index
      %17 = "arith.constant"() <{value = 0 : index}> : () -> index
      %18 = "arith.constant"() <{value = 32 : index}> : () -> index
      %19 = "taskflow.counter"(%17, %18, %14) : (index, index, index) -> index
      %20 = "taskflow.counter"(%19, %13, %16, %14) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%19, %20) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg8: index, %arg9: index):
        %21 = "memref.load"(%arg6, %arg8, %arg9) : (memref<64x64xf32>, index, index) -> f32
        %22 = "arith.addf"(%21, %21) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%22, %arg7, %arg8, %arg9) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg7) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 0, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 0 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 1, 2>}, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %1 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.1"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %3 = "arith.constant"() <{value = 0 : index}> : () -> index
      %4 = "arith.constant"() <{value = 1 : index}> : () -> index
      %5 = "arith.constant"() <{value = 64 : index}> : () -> index
      %6 = "arith.constant"() <{value = 64 : index}> : () -> index
      %7 = "arith.constant"() <{value = 32 : index}> : () -> index
      %8 = "arith.constant"() <{value = 64 : index}> : () -> index
      %9 = "taskflow.counter"(%7, %8, %4) : (index, index, index) -> index
      %10 = "taskflow.counter"(%9, %3, %6, %4) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%9, %10) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %11 = "memref.load"(%arg2, %arg4, %arg5) : (memref<64x64xf32>, index, index) -> f32
        %12 = "arith.addf"(%11, %11) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%12, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg3) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 32, 64>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 1, 2>}, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %2 = "taskflow.join"(%0, %1, %arg1) <{axis = 0 : i64, region_lower = array<i64: 0, 0>, region_upper = array<i64: 64, 64>}> : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    "func.return"() : () -> ()
  }) {orbit.noalias} : () -> ()
}) : () -> ()
