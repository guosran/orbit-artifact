#map = affine_map<() -> (0)>
#map1 = affine_map<() -> (64)>
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
      "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
      ^bb0(%arg4: index):
        "affine.for"() <{lowerBoundMap = #map, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map1}> ({
        ^bb0(%arg5: index):
          %8 = "memref.load"(%arg2, %arg4, %arg5) : (memref<64x64xf32>, index, index) -> f32
          %9 = "arith.addf"(%8, %8) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          %10 = "arith.mulf"(%9, %9) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
          "memref.store"(%10, %arg3, %arg4, %arg5) : (f32, memref<64x64xf32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "taskflow.yield"(%arg2, %arg3) <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (memref<64x64xf32>, memref<64x64xf32>) -> ()
    }) : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>)
    "func.return"() : () -> ()
  }) {llvm.emit_c_interface, orbit.noalias} : () -> ()
}) {orbit.air_tile_sizes = array<i64: 32, 32, 1>} : () -> ()
