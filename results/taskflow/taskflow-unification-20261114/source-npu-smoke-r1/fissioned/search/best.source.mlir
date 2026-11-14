"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.name = "X", orbit.role = "input"}, {amoeba.noalias, orbit.name = "Y", orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.name = "T"} : () -> memref<64x64xf32>
    %1 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<64x64xf32>
    %2:2 = "taskflow.task"(%arg0, %0, %arg0, %0) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "double.split.0.fuse.double.split.1"}> ({
    ^bb0(%arg6: memref<64x64xf32>, %arg7: memref<64x64xf32>):
      %11 = "arith.constant"() <{value = 0 : index}> : () -> index
      %12 = "arith.constant"() <{value = 1 : index}> : () -> index
      %13 = "arith.constant"() <{value = 64 : index}> : () -> index
      %14 = "arith.constant"() <{value = 0 : index}> : () -> index
      %15 = "arith.constant"() <{value = 1 : index}> : () -> index
      %16 = "arith.constant"() <{value = 64 : index}> : () -> index
      %17 = "taskflow.counter"(%11, %13, %12) : (index, index, index) -> index
      %18 = "taskflow.counter"(%17, %11, %13, %12) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%17, %18) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg8: index, %arg9: index):
        %19 = "memref.load"(%arg6, %arg8, %arg9) : (memref<64x64xf32>, index, index) -> f32
        %20 = "arith.addf"(%19, %19) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%20, %arg7, %arg8, %arg9) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg6, %arg7) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<64x64xf32>, memref<64x64xf32>) -> ()
    }) : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>)
    %3 = "taskflow.task"(%2#1, %arg1, %0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 0, 1, 0>, task_name = "square"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %4 = "arith.constant"() <{value = 0 : index}> : () -> index
      %5 = "arith.constant"() <{value = 1 : index}> : () -> index
      %6 = "arith.constant"() <{value = 64 : index}> : () -> index
      %7 = "taskflow.counter"(%4, %6, %5) : (index, index, index) -> index
      %8 = "taskflow.counter"(%7, %4, %6, %5) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%7, %8) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %9 = "memref.load"(%arg2, %arg4, %arg5) : (memref<64x64xf32>, index, index) -> f32
        %10 = "arith.mulf"(%9, %9) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%10, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg3) <{operandSegmentSizes = array<i32: 0, 1, 0>}> : (memref<64x64xf32>) -> ()
    }) : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32>
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.air_tile_sizes = array<i64: 32, 32, 1>} : () -> ()
