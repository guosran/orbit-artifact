"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.role = "input"}, {amoeba.noalias, orbit.role = "output"}], function_type = (memref<32x32xf32>, memref<32x32xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<32x32xf32>, %arg1: memref<32x32xf32>):
    %0 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.0.replica.1.0"}> ({
    ^bb0(%arg14: memref<32x32xf32>, %arg15: memref<32x32xf32>):
      %43 = "arith.constant"() <{value = 0 : index}> : () -> index
      %44 = "arith.constant"() <{value = 1 : index}> : () -> index
      %45 = "arith.constant"() <{value = 32 : index}> : () -> index
      %46 = "arith.constant"() <{value = 32 : index}> : () -> index
      %47 = "arith.constant"() <{value = 0 : index}> : () -> index
      %48 = "arith.constant"() <{value = 16 : index}> : () -> index
      %49 = "taskflow.counter"(%47, %48, %44) : (index, index, index) -> index
      %50 = "arith.constant"() <{value = 0 : index}> : () -> index
      %51 = "arith.constant"() <{value = 16 : index}> : () -> index
      %52 = "taskflow.counter"(%49, %50, %51, %44) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%49, %52) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg16: index, %arg17: index):
        %53 = "memref.load"(%arg14, %arg16, %arg17) : (memref<32x32xf32>, index, index) -> f32
        %54 = "arith.addf"(%53, %53) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%54, %arg15, %arg16, %arg17) : (f32, memref<32x32xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg15) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<32x32xf32>) -> ()
    }) {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 0, 16>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.0", amoeba.tiling.part_index = 0 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.0"], orbit.replica.path = array<i64: 0, 0>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> memref<32x32xf32>
    %1 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.0.replica.1.1"}> ({
    ^bb0(%arg10: memref<32x32xf32>, %arg11: memref<32x32xf32>):
      %31 = "arith.constant"() <{value = 0 : index}> : () -> index
      %32 = "arith.constant"() <{value = 1 : index}> : () -> index
      %33 = "arith.constant"() <{value = 32 : index}> : () -> index
      %34 = "arith.constant"() <{value = 32 : index}> : () -> index
      %35 = "arith.constant"() <{value = 0 : index}> : () -> index
      %36 = "arith.constant"() <{value = 16 : index}> : () -> index
      %37 = "taskflow.counter"(%35, %36, %32) : (index, index, index) -> index
      %38 = "arith.constant"() <{value = 16 : index}> : () -> index
      %39 = "arith.constant"() <{value = 32 : index}> : () -> index
      %40 = "taskflow.counter"(%37, %38, %39, %32) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%37, %40) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg12: index, %arg13: index):
        %41 = "memref.load"(%arg10, %arg12, %arg13) : (memref<32x32xf32>, index, index) -> f32
        %42 = "arith.addf"(%41, %41) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%42, %arg11, %arg12, %arg13) : (f32, memref<32x32xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg11) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<32x32xf32>) -> ()
    }) {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 16, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.0", amoeba.tiling.part_index = 1 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.0"], orbit.replica.path = array<i64: 0, 1>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> memref<32x32xf32>
    %2 = "taskflow.join"(%0, %1, %arg1) <{axis = 1 : i64, region_lower = array<i64: 0, 0>, region_upper = array<i64: 16, 32>}> : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> memref<32x32xf32>
    %3 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.1.replica.1.0"}> ({
    ^bb0(%arg6: memref<32x32xf32>, %arg7: memref<32x32xf32>):
      %19 = "arith.constant"() <{value = 0 : index}> : () -> index
      %20 = "arith.constant"() <{value = 1 : index}> : () -> index
      %21 = "arith.constant"() <{value = 32 : index}> : () -> index
      %22 = "arith.constant"() <{value = 32 : index}> : () -> index
      %23 = "arith.constant"() <{value = 16 : index}> : () -> index
      %24 = "arith.constant"() <{value = 32 : index}> : () -> index
      %25 = "taskflow.counter"(%23, %24, %20) : (index, index, index) -> index
      %26 = "arith.constant"() <{value = 0 : index}> : () -> index
      %27 = "arith.constant"() <{value = 16 : index}> : () -> index
      %28 = "taskflow.counter"(%25, %26, %27, %20) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%25, %28) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg8: index, %arg9: index):
        %29 = "memref.load"(%arg6, %arg8, %arg9) : (memref<32x32xf32>, index, index) -> f32
        %30 = "arith.addf"(%29, %29) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%30, %arg7, %arg8, %arg9) : (f32, memref<32x32xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg7) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<32x32xf32>) -> ()
    }) {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 0, 16>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.1", amoeba.tiling.part_index = 0 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.1"], orbit.replica.path = array<i64: 1, 0>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> memref<32x32xf32>
    %4 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.1.replica.1.1"}> ({
    ^bb0(%arg2: memref<32x32xf32>, %arg3: memref<32x32xf32>):
      %7 = "arith.constant"() <{value = 0 : index}> : () -> index
      %8 = "arith.constant"() <{value = 1 : index}> : () -> index
      %9 = "arith.constant"() <{value = 32 : index}> : () -> index
      %10 = "arith.constant"() <{value = 32 : index}> : () -> index
      %11 = "arith.constant"() <{value = 16 : index}> : () -> index
      %12 = "arith.constant"() <{value = 32 : index}> : () -> index
      %13 = "taskflow.counter"(%11, %12, %8) : (index, index, index) -> index
      %14 = "arith.constant"() <{value = 16 : index}> : () -> index
      %15 = "arith.constant"() <{value = 32 : index}> : () -> index
      %16 = "taskflow.counter"(%13, %14, %15, %8) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%13, %16) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %17 = "memref.load"(%arg2, %arg4, %arg5) : (memref<32x32xf32>, index, index) -> f32
        %18 = "arith.addf"(%17, %17) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%18, %arg3, %arg4, %arg5) : (f32, memref<32x32xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg3) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<32x32xf32>) -> ()
    }) {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 16, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.1", amoeba.tiling.part_index = 1 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.1"], orbit.replica.path = array<i64: 1, 1>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> memref<32x32xf32>
    %5 = "taskflow.join"(%3, %4, %arg1) <{axis = 1 : i64, region_lower = array<i64: 16, 0>, region_upper = array<i64: 32, 32>}> : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> memref<32x32xf32>
    %6 = "taskflow.join"(%2, %5, %arg1) <{axis = 0 : i64, region_lower = array<i64: 0, 0>, region_upper = array<i64: 32, 32>}> : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> memref<32x32xf32>
    "func.return"() : () -> ()
  }) {orbit.noalias} : () -> ()
}) : () -> ()
