"builtin.module"() ({
  "func.func"() <{arg_attrs = [{amoeba.noalias, orbit.name = "X", orbit.role = "input"}, {amoeba.noalias, orbit.name = "Y", orbit.role = "output"}], function_type = (memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>):
    %0 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.name = "T"} : () -> memref<64x64xf32>
    %1:2 = "taskflow.task"(%arg0, %arg1, %arg0, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 0, 1, 1>, resultSegmentSizes = array<i32: 1, 1, 0>, task_name = "double.fuse.square"}> ({
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %2 = "arith.constant"() <{value = 0 : index}> : () -> index
      %3 = "arith.constant"() <{value = 1 : index}> : () -> index
      %4 = "arith.constant"() <{value = 64 : index}> : () -> index
      %5 = "arith.constant"() <{value = 0 : index}> : () -> index
      %6 = "arith.constant"() <{value = 1 : index}> : () -> index
      %7 = "arith.constant"() <{value = 64 : index}> : () -> index
      %8 = "taskflow.counter"(%2, %4, %3) : (index, index, index) -> index
      %9 = "taskflow.counter"(%8, %2, %4, %3) : (index, index, index, index) -> index
      "taskflow.hyperblock"(%8, %9) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %10 = "memref.load"(%arg2, %arg4, %arg5) : (memref<64x64xf32>, index, index) -> f32
        %11 = "arith.addf"(%10, %10) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        %12 = "arith.mulf"(%11, %11) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
        "memref.store"(%12, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
        "taskflow.hyperblock.yield"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
      }) : (index, index) -> ()
      "taskflow.yield"(%arg2, %arg3) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<64x64xf32>, memref<64x64xf32>) -> ()
    }) : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>)
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.air_tile_sizes = array<i64: 32, 32, 1>} : () -> ()
