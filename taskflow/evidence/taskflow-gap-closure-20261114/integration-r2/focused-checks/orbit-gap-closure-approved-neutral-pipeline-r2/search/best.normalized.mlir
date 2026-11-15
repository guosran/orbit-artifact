#map = affine_map<() -> (0)>
#map1 = affine_map<() -> (10)>
#map2 = affine_map<() -> (15)>
"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.role = "input"}, {amoeba.noalias, orbit.role = "output"}], function_type = (memref<15x10xf32>, memref<15x10xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<15x10xf32>, %arg1: memref<15x10xf32>):
    %0 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise"}> ({
    ^bb0(%arg2: memref<15x10xf32>, %arg3: memref<15x10xf32>):
      %1 = "arith.constant"() <{value = 0 : index}> : () -> index
      %2 = "arith.constant"() <{value = 1 : index}> : () -> index
      %3 = "arith.constant"() <{value = 15 : index}> : () -> index
      %4 = "arith.constant"() <{value = 10 : index}> : () -> index
      "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg4: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg5: index):
          %5 = "memref.load"(%arg2, %arg4, %arg5) : (memref<15x10xf32>, index, index) -> f32
          %6 = "arith.addf"(%5, %5) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%6, %arg3, %arg4, %arg5) : (f32, memref<15x10xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg3) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<15x10xf32>) -> ()
    }) : (memref<15x10xf32>, memref<15x10xf32>, memref<15x10xf32>, memref<15x10xf32>) -> memref<15x10xf32>
    "func.return"() : () -> ()
  }) {orbit.noalias} : () -> ()
}) : () -> ()
