"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.role = "input"}, {amoeba.noalias, orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<64x64xf32>
    %1:2 = "taskflow.task"(%arg0, %0, %arg0, %0) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Pointwise.split.0"}> ({
    ^bb0(%arg6: memref<64x64xf32>, %arg7: memref<64x64xf32>):
      %10 = "arith.constant"() <{value = 0 : index}> : () -> index
      %11 = "arith.constant"() <{value = 1 : index}> : () -> index
      %12 = "arith.constant"() <{value = 64 : index}> : () -> index
      %13 = "arith.constant"() <{value = 64 : index}> : () -> index
      %14 = "taskflow.counter"(%10, %12, %11) : (index, index, index) -> index
      %15 = "taskflow.counter"(%14, %10, %13, %11) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%14, %15) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg8: index, %arg9: index):
        %16 = "memref.load"(%arg6, %arg8, %arg9) : (memref<64x64xf32>, index, index) -> f32
        %17 = "arith.addf"(%16, %16) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%17, %arg7, %arg8, %arg9) <{nontemporal = false}> : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg6, %arg7) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<64x64xf32>, memref<64x64xf32>) -> ()
    }) {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise", amoeba.fission.part_index = 0 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 2, 2>}} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>)
    %2:2 = "taskflow.task"(%1#1, %arg1, %0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "Pointwise.split.1"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %3 = "arith.constant"() <{value = 0 : index}> : () -> index
      %4 = "arith.constant"() <{value = 1 : index}> : () -> index
      %5 = "arith.constant"() <{value = 64 : index}> : () -> index
      %6 = "arith.constant"() <{value = 64 : index}> : () -> index
      %7 = "taskflow.counter"(%3, %5, %4) : (index, index, index) -> index
      %8 = "taskflow.counter"(%7, %3, %6, %4) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%7, %8) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %9 = "memref.load"(%arg2, %arg4, %arg5) <{nontemporal = false}> : (memref<64x64xf32>, index, index) -> f32
        "memref.store"(%9, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg2, %arg3) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<64x64xf32>, memref<64x64xf32>) -> ()
    }) {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise", amoeba.fission.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 2, 2>}} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>)
    "func.return"() : () -> ()
  }) {orbit.noalias} : () -> ()
}) : () -> ()
