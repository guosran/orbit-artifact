#map = affine_map<(d0, d1) -> (d0, d1)>
#map1 = affine_map<() -> (0)>
#map2 = affine_map<()[s0] -> (s0)>
#map3 = affine_map<(d0) -> (d0, d0)>
#map4 = affine_map<(d0) -> (d0)>
#map5 = affine_map<(d0)[s0] -> (-d0 + s0 - 1)>
#map6 = affine_map<(d0, d1)[s0] -> (-d0 + s0 - 1, d1)>
#map7 = affine_map<(d0)[s0] -> (-d0 + s0 - 1, -d0 + s0 - 1)>
"builtin.module"() ({
  "func.func"() <{function_type = (i32, memref<?x100xi32>, memref<?xi32>, memref<?x100xi32>, memref<?x100xi32>, memref<?x100xi32>, memref<?xi32>, memref<?xi32>, memref<?x100xi32>, memref<?xi32>) -> (), sym_name = "_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?x100xi32>, %arg2: memref<?xi32>, %arg3: memref<?x100xi32>, %arg4: memref<?x100xi32>, %arg5: memref<?x100xi32>, %arg6: memref<?xi32>, %arg7: memref<?xi32>, %arg8: memref<?x100xi32>, %arg9: memref<?xi32>):
    %0 = "arith.constant"() <{value = 8 : i32}> : () -> i32
    %1 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %2 = "arith.constant"() <{value = 1 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 1024 : i32}> : () -> i32
    %4 = "arith.constant"() <{value = -1 : i32}> : () -> i32
    %5 = "arith.constant"() <{value = -1024 : i32}> : () -> i32
    %6 = "arith.index_cast"(%0) : (i32) -> index
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg28: index):
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg29: index):
        %111 = "affine.load"(%arg1, %arg28, %arg29) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
        "affine.store"(%111, %arg3, %arg28, %arg29) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg26: index):
      %107 = "arith.index_cast"(%arg26) : (index) -> i32
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg27: index):
        %108 = "arith.index_cast"(%arg27) : (index) -> i32
        %109 = "arith.cmpi"(%107, %108) <{predicate = 0 : i64}> : (i32, i32) -> i1
        %110 = "arith.select"(%109, %3, %1) : (i1, i32, i32) -> i32
        "affine.store"(%110, %arg4, %arg26, %arg27) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        "affine.store"(%1, %arg5, %arg26, %arg27) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        "affine.store"(%110, %arg8, %arg26, %arg27) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg23: index):
      %83 = "arith.index_cast"(%arg23) : (index) -> i32
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg24: index):
        %84 = "arith.index_cast"(%arg24) : (index) -> i32
        "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg25: index):
          %94 = "arith.index_cast"(%arg25) : (index) -> i32
          %95 = "arith.cmpi"(%94, %83) <{predicate = 2 : i64}> : (i32, i32) -> i1
          %96 = "arith.extui"(%95) : (i1) -> i32
          %97 = "arith.cmpi"(%94, %84) <{predicate = 2 : i64}> : (i32, i32) -> i1
          %98 = "arith.extui"(%97) : (i1) -> i32
          %99 = "arith.muli"(%96, %98) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %100 = "affine.load"(%arg3, %arg23, %arg24) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
          %101 = "affine.load"(%arg3, %arg23, %arg25) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
          %102 = "affine.load"(%arg3, %arg25, %arg24) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
          %103 = "arith.muli"(%101, %102) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %104 = "arith.divsi"(%103, %3) : (i32, i32) -> i32
          %105 = "arith.muli"(%99, %104) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %106 = "arith.subi"(%100, %105) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%106, %arg3, %arg23, %arg24) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : (index) -> ()
        %85 = "arith.cmpi"(%83, %84) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %86 = "arith.extui"(%85) : (i1) -> i32
        %87 = "affine.load"(%arg3, %arg24) <{map = #map3}> : (memref<?x100xi32>, index) -> i32
        %88 = "arith.addi"(%87, %5) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %89 = "arith.muli"(%86, %88) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %90 = "arith.addi"(%89, %3) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %91 = "affine.load"(%arg3, %arg23, %arg24) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
        %92 = "arith.muli"(%91, %3) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %93 = "arith.divsi"(%92, %90) : (i32, i32) -> i32
        "affine.store"(%93, %arg3, %arg23, %arg24) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg21: index):
      %71 = "arith.index_cast"(%arg21) : (index) -> i32
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg22: index):
        %72 = "arith.index_cast"(%arg22) : (index) -> i32
        %73 = "arith.cmpi"(%71, %72) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %74 = "arith.extui"(%73) : (i1) -> i32
        %75 = "arith.cmpi"(%71, %72) <{predicate = 0 : i64}> : (i32, i32) -> i1
        %76 = "arith.extui"(%75) : (i1) -> i32
        %77 = "arith.subi"(%2, %74) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %78 = "affine.load"(%arg3, %arg21, %arg22) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
        %79 = "arith.muli"(%74, %78) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %80 = "arith.muli"(%76, %3) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %81 = "arith.addi"(%79, %80) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "affine.store"(%81, %arg4, %arg21, %arg22) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        %82 = "arith.muli"(%77, %78) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "affine.store"(%82, %arg5, %arg21, %arg22) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg19: index):
      %59 = "arith.index_cast"(%arg19) : (index) -> i32
      %60 = "affine.load"(%arg2, %arg19) <{map = #map4}> : (memref<?xi32>, index) -> i32
      "affine.store"(%60, %arg6, %arg19) <{map = #map4}> : (i32, memref<?xi32>, index) -> ()
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg20: index):
        %61 = "arith.index_cast"(%arg20) : (index) -> i32
        %62 = "arith.cmpi"(%61, %59) <{predicate = 2 : i64}> : (i32, i32) -> i1
        %63 = "arith.extui"(%62) : (i1) -> i32
        %64 = "affine.load"(%arg6, %arg19) <{map = #map4}> : (memref<?xi32>, index) -> i32
        %65 = "affine.load"(%arg4, %arg19, %arg20) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
        %66 = "affine.load"(%arg6, %arg20) <{map = #map4}> : (memref<?xi32>, index) -> i32
        %67 = "arith.muli"(%65, %66) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %68 = "arith.divsi"(%67, %3) : (i32, i32) -> i32
        %69 = "arith.muli"(%63, %68) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %70 = "arith.subi"(%64, %69) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "affine.store"(%70, %arg6, %arg19) <{map = #map4}> : (i32, memref<?xi32>, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    %7 = "arith.addi"(%0, %4) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg17: index):
      %42 = "arith.index_cast"(%arg17) : (index) -> i32
      %43 = "arith.subi"(%7, %42) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %44 = "affine.load"(%arg6, %arg17, %6) <{map = #map5}> : (memref<?xi32>, index, index) -> i32
      "affine.store"(%44, %arg7, %arg17, %6) <{map = #map5}> : (i32, memref<?xi32>, index, index) -> ()
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg18: index):
        %49 = "arith.index_cast"(%arg18) : (index) -> i32
        %50 = "arith.cmpi"(%49, %43) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %51 = "arith.extui"(%50) : (i1) -> i32
        %52 = "affine.load"(%arg7, %arg17, %6) <{map = #map5}> : (memref<?xi32>, index, index) -> i32
        %53 = "affine.load"(%arg5, %arg17, %arg18, %6) <{map = #map6}> : (memref<?x100xi32>, index, index, index) -> i32
        %54 = "affine.load"(%arg7, %arg18) <{map = #map4}> : (memref<?xi32>, index) -> i32
        %55 = "arith.muli"(%53, %54) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %56 = "arith.divsi"(%55, %3) : (i32, i32) -> i32
        %57 = "arith.muli"(%51, %56) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %58 = "arith.subi"(%52, %57) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "affine.store"(%58, %arg7, %arg17, %6) <{map = #map5}> : (i32, memref<?xi32>, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      %45 = "affine.load"(%arg7, %arg17, %6) <{map = #map5}> : (memref<?xi32>, index, index) -> i32
      %46 = "arith.muli"(%45, %3) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %47 = "affine.load"(%arg5, %arg17, %6) <{map = #map7}> : (memref<?x100xi32>, index, index) -> i32
      %48 = "arith.divsi"(%46, %47) : (i32, i32) -> i32
      "affine.store"(%48, %arg7, %arg17, %6) <{map = #map5}> : (i32, memref<?xi32>, index, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg14: index):
      %28 = "arith.index_cast"(%arg14) : (index) -> i32
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg15: index):
        %29 = "arith.index_cast"(%arg15) : (index) -> i32
        %30 = "arith.cmpi"(%29, %28) <{predicate = 0 : i64}> : (i32, i32) -> i1
        %31 = "arith.select"(%30, %3, %1) : (i1, i32, i32) -> i32
        "affine.store"(%31, %arg8, %arg15, %arg14) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
        "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg16: index):
          %32 = "arith.index_cast"(%arg16) : (index) -> i32
          %33 = "arith.cmpi"(%32, %29) <{predicate = 2 : i64}> : (i32, i32) -> i1
          %34 = "arith.extui"(%33) : (i1) -> i32
          %35 = "affine.load"(%arg8, %arg15, %arg14) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
          %36 = "affine.load"(%arg4, %arg15, %arg16) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
          %37 = "affine.load"(%arg8, %arg16, %arg14) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
          %38 = "arith.muli"(%36, %37) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %39 = "arith.divsi"(%38, %3) : (i32, i32) -> i32
          %40 = "arith.muli"(%34, %39) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %41 = "arith.subi"(%35, %40) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%41, %arg8, %arg15, %arg14) <{map = #map}> : (i32, memref<?x100xi32>, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : (index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg11: index):
      "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
      ^bb0(%arg12: index):
        %12 = "arith.index_cast"(%arg12) : (index) -> i32
        %13 = "arith.subi"(%7, %12) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
        ^bb0(%arg13: index):
          %18 = "arith.index_cast"(%arg13) : (index) -> i32
          %19 = "arith.cmpi"(%18, %13) <{predicate = 4 : i64}> : (i32, i32) -> i1
          %20 = "arith.extui"(%19) : (i1) -> i32
          %21 = "affine.load"(%arg8, %arg12, %arg11, %6) <{map = #map6}> : (memref<?x100xi32>, index, index, index) -> i32
          %22 = "affine.load"(%arg5, %arg12, %arg13, %6) <{map = #map6}> : (memref<?x100xi32>, index, index, index) -> i32
          %23 = "affine.load"(%arg8, %arg13, %arg11) <{map = #map}> : (memref<?x100xi32>, index, index) -> i32
          %24 = "arith.muli"(%22, %23) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %25 = "arith.divsi"(%24, %3) : (i32, i32) -> i32
          %26 = "arith.muli"(%20, %25) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          %27 = "arith.subi"(%21, %26) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
          "affine.store"(%27, %arg8, %arg12, %arg11, %6) <{map = #map6}> : (i32, memref<?x100xi32>, index, index, index) -> ()
          "affine.yield"() : () -> ()
        }) : (index) -> ()
        %14 = "affine.load"(%arg8, %arg12, %arg11, %6) <{map = #map6}> : (memref<?x100xi32>, index, index, index) -> i32
        %15 = "arith.muli"(%14, %3) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        %16 = "affine.load"(%arg5, %arg12, %6) <{map = #map7}> : (memref<?x100xi32>, index, index) -> i32
        %17 = "arith.divsi"(%15, %16) : (i32, i32) -> i32
        "affine.store"(%17, %arg8, %arg12, %arg11, %6) <{map = #map6}> : (i32, memref<?x100xi32>, index, index, index) -> ()
        "affine.yield"() : () -> ()
      }) : (index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.store"(%3, %arg9) <{map = #map1}> : (i32, memref<?xi32>) -> ()
    "affine.for"(%6) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg10: index):
      %8 = "affine.load"(%arg5, %arg10) <{map = #map3}> : (memref<?x100xi32>, index) -> i32
      %9 = "affine.load"(%arg9) <{map = #map1}> : (memref<?xi32>) -> i32
      %10 = "arith.muli"(%9, %8) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %11 = "arith.divsi"(%10, %3) : (i32, i32) -> i32
      "affine.store"(%11, %arg9) <{map = #map1}> : (i32, memref<?xi32>) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "func.return"() : () -> ()
  }) {amoeba.static_bound.arg.0 = 8 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) {amoeba.lu_affine_repair_input_status = "malformed-determinant-carry", amoeba.lu_affine_repair_pass = "repair-lu-affine-determinant-carry-v1", amoeba.lu_affine_repair_reason = "inserted determinant carry load and rewired product", amoeba.lu_affine_repair_source_file = "reference/input0-source-domains/source/lu_func.cpp", amoeba.lu_affine_repair_source_verified = true, amoeba.lu_affine_repair_status = "repaired"} : () -> ()

