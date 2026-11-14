#map = affine_map<() -> (0)>
#map1 = affine_map<() -> (64)>
#map2 = affine_map<() -> (11)>
#map3 = affine_map<() -> (22)>
#map4 = affine_map<() -> (33)>
#map5 = affine_map<() -> (44)>
#map6 = affine_map<() -> (54)>
"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.role = "input"}, {amoeba.noalias, orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<11x64xf32>
    %1:2 = "taskflow.task"(%arg0, %0, %arg0, %0) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Pointwise.replica.0.0.split.0"}> ({
    ^bb0(%arg26: memref<64x64xf32>, %arg27: memref<11x64xf32>):
      %56 = "arith.constant"() <{value = 0 : index}> : () -> index
      %57 = "arith.constant"() <{value = 1 : index}> : () -> index
      %58 = "arith.constant"() <{value = 64 : index}> : () -> index
      %59 = "arith.constant"() <{value = 64 : index}> : () -> index
      %60 = "arith.constant"() <{value = 0 : index}> : () -> index
      %61 = "arith.constant"() <{value = 11 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg28: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg29: index):
          %62 = "memref.load"(%arg26, %arg28, %arg29) : (memref<64x64xf32>, index, index) -> f32
          %63 = "arith.addf"(%62, %62) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%63, %arg27, %arg28, %arg29) <{nontemporal = false}> : (f32, memref<11x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg26, %arg27) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<64x64xf32>, memref<11x64xf32>) -> ()
    }) {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise.replica.0.0", amoeba.fission.part_index = 0 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.3", resource = "npu.tile.0.3", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<11x64xf32>, memref<64x64xf32>, memref<11x64xf32>) -> (memref<64x64xf32>, memref<11x64xf32>)
    %2:2 = "taskflow.task"(%1#1, %arg1, %0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Pointwise.replica.0.0.split.1"}> ({
    ^bb0(%arg22: memref<11x64xf32>, %arg23: memref<64x64xf32>):
      %49 = "arith.constant"() <{value = 0 : index}> : () -> index
      %50 = "arith.constant"() <{value = 1 : index}> : () -> index
      %51 = "arith.constant"() <{value = 64 : index}> : () -> index
      %52 = "arith.constant"() <{value = 64 : index}> : () -> index
      %53 = "arith.constant"() <{value = 0 : index}> : () -> index
      %54 = "arith.constant"() <{value = 11 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg24: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg25: index):
          %55 = "memref.load"(%arg22, %arg24, %arg25) <{nontemporal = false}> : (memref<11x64xf32>, index, index) -> f32
          "memref.store"(%55, %arg23, %arg24, %arg25) : (f32, memref<64x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg22, %arg23) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<11x64xf32>, memref<64x64xf32>) -> ()
    }) {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise.replica.0.0", amoeba.fission.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.3", resource = "npu.tile.0.3", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.requires_independent_resources} : (memref<11x64xf32>, memref<64x64xf32>, memref<11x64xf32>, memref<64x64xf32>) -> (memref<11x64xf32>, memref<64x64xf32>)
    %3 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.1"}> ({
    ^bb0(%arg18: memref<64x64xf32>, %arg19: memref<64x64xf32>):
      %41 = "arith.constant"() <{value = 0 : index}> : () -> index
      %42 = "arith.constant"() <{value = 1 : index}> : () -> index
      %43 = "arith.constant"() <{value = 64 : index}> : () -> index
      %44 = "arith.constant"() <{value = 64 : index}> : () -> index
      %45 = "arith.constant"() <{value = 11 : index}> : () -> index
      %46 = "arith.constant"() <{value = 22 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map2, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map3}> ({
      ^bb0(%arg20: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg21: index):
          %47 = "memref.load"(%arg18, %arg20, %arg21) : (memref<64x64xf32>, index, index) -> f32
          %48 = "arith.addf"(%47, %47) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%48, %arg19, %arg20, %arg21) : (f32, memref<64x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg19) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 11, 22>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.1.3", resource = "npu.tile.1.3", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %4 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.2"}> ({
    ^bb0(%arg14: memref<64x64xf32>, %arg15: memref<64x64xf32>):
      %33 = "arith.constant"() <{value = 0 : index}> : () -> index
      %34 = "arith.constant"() <{value = 1 : index}> : () -> index
      %35 = "arith.constant"() <{value = 64 : index}> : () -> index
      %36 = "arith.constant"() <{value = 64 : index}> : () -> index
      %37 = "arith.constant"() <{value = 22 : index}> : () -> index
      %38 = "arith.constant"() <{value = 33 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map3, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map4}> ({
      ^bb0(%arg16: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg17: index):
          %39 = "memref.load"(%arg14, %arg16, %arg17) : (memref<64x64xf32>, index, index) -> f32
          %40 = "arith.addf"(%39, %39) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%40, %arg15, %arg16, %arg17) : (f32, memref<64x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg15) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 22, 33>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 2 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.4", resource = "npu.tile.0.4", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 2 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %5 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.3"}> ({
    ^bb0(%arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>):
      %25 = "arith.constant"() <{value = 0 : index}> : () -> index
      %26 = "arith.constant"() <{value = 1 : index}> : () -> index
      %27 = "arith.constant"() <{value = 64 : index}> : () -> index
      %28 = "arith.constant"() <{value = 64 : index}> : () -> index
      %29 = "arith.constant"() <{value = 33 : index}> : () -> index
      %30 = "arith.constant"() <{value = 44 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map4, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map5}> ({
      ^bb0(%arg12: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg13: index):
          %31 = "memref.load"(%arg10, %arg12, %arg13) : (memref<64x64xf32>, index, index) -> f32
          %32 = "arith.addf"(%31, %31) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%32, %arg11, %arg12, %arg13) : (f32, memref<64x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg11) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 33, 44>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 3 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.1.4", resource = "npu.tile.1.4", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 3 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %6 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.4"}> ({
    ^bb0(%arg6: memref<64x64xf32>, %arg7: memref<64x64xf32>):
      %17 = "arith.constant"() <{value = 0 : index}> : () -> index
      %18 = "arith.constant"() <{value = 1 : index}> : () -> index
      %19 = "arith.constant"() <{value = 64 : index}> : () -> index
      %20 = "arith.constant"() <{value = 64 : index}> : () -> index
      %21 = "arith.constant"() <{value = 44 : index}> : () -> index
      %22 = "arith.constant"() <{value = 54 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map5, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map6}> ({
      ^bb0(%arg8: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg9: index):
          %23 = "memref.load"(%arg6, %arg8, %arg9) : (memref<64x64xf32>, index, index) -> f32
          %24 = "arith.addf"(%23, %23) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%24, %arg7, %arg8, %arg9) : (f32, memref<64x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg7) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 44, 54>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 4 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.5", resource = "npu.tile.0.5", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 4 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %7 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise.replica.0.5"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %9 = "arith.constant"() <{value = 0 : index}> : () -> index
      %10 = "arith.constant"() <{value = 1 : index}> : () -> index
      %11 = "arith.constant"() <{value = 64 : index}> : () -> index
      %12 = "arith.constant"() <{value = 64 : index}> : () -> index
      %13 = "arith.constant"() <{value = 54 : index}> : () -> index
      %14 = "arith.constant"() <{value = 64 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map6, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
      ^bb0(%arg4: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg5: index):
          %15 = "memref.load"(%arg2, %arg4, %arg5) : (memref<64x64xf32>, index, index) -> f32
          %16 = "arith.addf"(%15, %15) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%16, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg3) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 54, 64>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 5 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.1.5", resource = "npu.tile.1.5", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 5 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    %8 = "taskflow.join"(%2#1, %3, %4, %5, %6, %7, %arg1) <{axis = 0 : i64, region_lower = array<i64: 0, 0>, region_upper = array<i64: 64, 64>}> : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    "func.return"() : () -> ()
  }) {orbit.noalias} : () -> ()
}) : () -> ()
