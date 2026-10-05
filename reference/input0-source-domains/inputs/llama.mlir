#map = affine_map<(d0, d1) -> (d0, d1)>
#map1 = affine_map<() -> (0)>
#map2 = affine_map<() -> (256)>
#map3 = affine_map<()[s0] -> (s0)>
#map4 = affine_map<(d0) -> (d0)>
"builtin.module"() ({
  "func.func"() <{function_type = (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> (), sym_name = "_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?x256xi32>, %arg2: memref<?x256xi32>, %arg3: memref<?x256xi32>, %arg4: memref<?x256xi32>, %arg5: memref<?x256xi32>, %arg6: memref<?x256xi32>, %arg7: memref<?x256xi32>, %arg8: memref<?x256xi32>):
    %0 = "arith.constant"() <{value = 320 : i32}> : () -> i32
    %1 = "arith.constant"() <{value = 1024 : i32}> : () -> i32
    %2 = "arith.constant"() <{value = 1 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %4 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %5 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %6 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %7 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512xi32>
    %8 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x512xi32>
    %9 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x512xi32>
    %10 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %11 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %12 = "memref.alloca"() <{operandSegmentSizes = array<i32: 0, 0>}> : () -> memref<512x256xi32>
    %13 = "arith.index_cast"(%0) : (i32) -> index
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg38: index):
      "affine.for"() <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg39: index):
        "affine.store"(%3, %12, %arg38, %arg39) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
        %63 = "affine.for"(%3) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 1>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg40: index, %arg41: i32):
          %64 = "affine.load"(%arg1, %arg38, %arg40) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %65 = "affine.load"(%arg2, %arg40, %arg39) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %66 = "arith.muli"(%64, %65) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %67 = "arith.addi"(%arg41, %66) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%67, %12, %arg38, %arg39) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
          "affine.yield"(%67) : (i32) -> ()
        }) : (i32) -> i32
        "affine.yield"() : () -> ()
      }) : () -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg34: index):
      "affine.for"() <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg35: index):
        "affine.store"(%3, %11, %arg34, %arg35) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
        %58 = "affine.for"(%3) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 1>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg36: index, %arg37: i32):
          %59 = "affine.load"(%arg1, %arg34, %arg36) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %60 = "affine.load"(%arg3, %arg36, %arg35) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %61 = "arith.muli"(%59, %60) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %62 = "arith.addi"(%arg37, %61) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%62, %11, %arg34, %arg35) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
          "affine.yield"(%62) : (i32) -> ()
        }) : (i32) -> i32
        "affine.yield"() : () -> ()
      }) : () -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg30: index):
      "affine.for"() <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg31: index):
        "affine.store"(%3, %10, %arg30, %arg31) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
        %53 = "affine.for"(%3) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 1>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg32: index, %arg33: i32):
          %54 = "affine.load"(%arg1, %arg30, %arg32) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %55 = "affine.load"(%arg4, %arg32, %arg31) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %56 = "arith.muli"(%54, %55) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %57 = "arith.addi"(%arg33, %56) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%57, %10, %arg30, %arg31) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
          "affine.yield"(%57) : (i32) -> ()
        }) : (i32) -> i32
        "affine.yield"() : () -> ()
      }) : () -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg26: index):
      "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
      ^bb0(%arg27: index):
        "affine.store"(%3, %9, %arg26, %arg27) <{map = #map}> : (i32, memref<512x512xi32>, index, index) -> ()
        %48 = "affine.for"(%3) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 1>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg28: index, %arg29: i32):
          %49 = "affine.load"(%12, %arg26, %arg28) <{map = #map}> : (memref<512x256xi32>, index, index) -> i32
          %50 = "affine.load"(%11, %arg27, %arg28) <{map = #map}> : (memref<512x256xi32>, index, index) -> i32
          %51 = "arith.muli"(%49, %50) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %52 = "arith.addi"(%arg29, %51) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%52, %9, %arg26, %arg27) <{map = #map}> : (i32, memref<512x512xi32>, index, index) -> ()
          "affine.yield"(%52) : (i32) -> ()
        }) : (i32) -> i32
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg23: index):
      "affine.store"(%3, %7, %arg23) <{map = #map4}> : (i32, memref<512xi32>, index) -> ()
      %43 = "affine.for"(%13, %3) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 1>, step = 1 : index, upperBoundMap = #map3}> ({
      ^bb0(%arg24: index, %arg25: i32):
        %44 = "affine.load"(%9, %arg23, %arg24) <{map = #map}> : (memref<512x512xi32>, index, index) -> i32
        %45 = "arith.muli"(%44, %44) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %46 = "arith.addi"(%45, %2) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "affine.store"(%46, %8, %arg23, %arg24) <{map = #map}> : (i32, memref<512x512xi32>, index, index) -> ()
        %47 = "arith.addi"(%arg25, %46) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "affine.store"(%47, %7, %arg23) <{map = #map4}> : (i32, memref<512xi32>, index) -> ()
        "affine.yield"(%47) : (i32) -> ()
      }) : (index, i32) -> i32
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg21: index):
      %38 = "affine.load"(%7, %arg21) <{map = #map4}> : (memref<512xi32>, index) -> i32
      %39 = "arith.addi"(%38, %2) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
      ^bb0(%arg22: index):
        %40 = "affine.load"(%8, %arg21, %arg22) <{map = #map}> : (memref<512x512xi32>, index, index) -> i32
        %41 = "arith.muli"(%40, %1) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %42 = "arith.divsi"(%41, %39) : (i32, i32) -> i32
        "affine.store"(%42, %8, %arg21, %arg22) <{map = #map}> : (i32, memref<512x512xi32>, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg17: index):
      "affine.for"() <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg18: index):
        "affine.store"(%3, %6, %arg17, %arg18) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
        %31 = "affine.for"(%13, %3) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 1>, step = 1 : index, upperBoundMap = #map3}> ({
        ^bb0(%arg19: index, %arg20: i32):
          %34 = "affine.load"(%8, %arg17, %arg19) <{map = #map}> : (memref<512x512xi32>, index, index) -> i32
          %35 = "affine.load"(%10, %arg19, %arg18) <{map = #map}> : (memref<512x256xi32>, index, index) -> i32
          %36 = "arith.muli"(%34, %35) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %37 = "arith.addi"(%arg20, %36) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%37, %6, %arg17, %arg18) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
          "affine.yield"(%37) : (i32) -> ()
        }) : (index, i32) -> i32
        %32 = "affine.load"(%6, %arg17, %arg18) <{map = #map}> : (memref<512x256xi32>, index, index) -> i32
        %33 = "arith.divsi"(%32, %1) : (i32, i32) -> i32
        "affine.store"(%33, %6, %arg17, %arg18) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg12: index):
      "affine.for"() <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg13: index):
        "affine.store"(%3, %5, %arg12, %arg13) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
        "affine.store"(%3, %4, %arg12, %arg13) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
        %23:2 = "affine.for"(%3, %3) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 2>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg14: index, %arg15: i32, %arg16: i32):
          %24 = "affine.load"(%6, %arg12, %arg14) <{map = #map}> : (memref<512x256xi32>, index, index) -> i32
          %25 = "affine.load"(%arg5, %arg14, %arg13) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %26 = "arith.muli"(%24, %25) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %27 = "arith.addi"(%arg16, %26) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%27, %5, %arg12, %arg13) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
          %28 = "affine.load"(%arg6, %arg14, %arg13) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %29 = "arith.muli"(%24, %28) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %30 = "arith.addi"(%arg15, %29) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%30, %4, %arg12, %arg13) <{map = #map}> : (i32, memref<512x256xi32>, index, index) -> ()
          "affine.yield"(%30, %27) : (i32, i32) -> ()
        }) : (i32, i32) -> (i32, i32)
        "affine.yield"() : () -> ()
      }) : () -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%13) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map3}> ({
    ^bb0(%arg9: index):
      "affine.for"() <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg10: index):
        "affine.store"(%3, %arg8, %arg9, %arg10) <{map = #map}> : (i32, memref<?x256xi32>, index, index) -> ()
        "affine.for"() <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 0>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg11: index):
          %14 = "affine.load"(%5, %arg9, %arg11) <{map = #map}> : (memref<512x256xi32>, index, index) -> i32
          %15 = "arith.addi"(%14, %2) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %16 = "arith.muli"(%14, %15) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %17 = "affine.load"(%4, %arg9, %arg11) <{map = #map}> : (memref<512x256xi32>, index, index) -> i32
          %18 = "arith.muli"(%16, %17) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %19 = "affine.load"(%arg7, %arg11, %arg10) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %20 = "arith.muli"(%18, %19) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %21 = "affine.load"(%arg8, %arg9, %arg10) <{map = #map}> : (memref<?x256xi32>, index, index) -> i32
          %22 = "arith.addi"(%21, %20) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%22, %arg8, %arg9, %arg10) <{map = #map}> : (i32, memref<?x256xi32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : () -> ()
        "affine.yield"() : () -> ()
      }) : () -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "func.return"() : () -> ()
  }) {amoeba.static_bound.arg.0 = 320 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) : () -> ()

