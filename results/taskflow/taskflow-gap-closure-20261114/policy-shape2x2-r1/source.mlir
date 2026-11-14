"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.role = "input"}, {amoeba.noalias, orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "Pointwise"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %1 = "arith.constant"() <{value = 0 : index}> : () -> index
      %2 = "arith.constant"() <{value = 1 : index}> : () -> index
      %3 = "arith.constant"() <{value = 64 : index}> : () -> index
      %4 = "arith.constant"() <{value = 64 : index}> : () -> index
      %5 = "taskflow.counter"(%1, %3, %2) : (index, index, index) -> index
      %6 = "taskflow.counter"(%5, %1, %4, %2) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%5, %6) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %7 = "memref.load"(%arg2, %arg4, %arg5) : (memref<64x64xf32>, index, index) -> f32
        %8 = "arith.addf"(%7, %7) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%8, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg3) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) {orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 2, 2>}} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    "func.return"() : () -> ()
  }) {orbit.noalias} : () -> ()
}) {orbit.source_mapping_binding = {body = "21f63871944907ebffb913748ddcbf8e24a4fc9a27b915d15fa91989aa21a80e", function = "pointwise", storages = ["arg0", "arg1"], tasks = ["Pointwise"]}, orbit.task_implementations = [{kind = "scalar", lanes = 1 : i64, task = 0 : i64}], orbit.task_tiles = [{sizes = array<i64: 8, 64>, task = 0 : i64}]} : () -> ()
