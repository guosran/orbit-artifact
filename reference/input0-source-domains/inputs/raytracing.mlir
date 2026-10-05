#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<() -> (0)>
#map2 = affine_map<()[s0] -> (s0)>
#map3 = affine_map<(d0) -> (d0, 0)>
#map4 = affine_map<() -> (1)>
#map5 = affine_map<(d0) -> (d0, 1)>
#map6 = affine_map<() -> (2)>
#map7 = affine_map<(d0) -> (d0, 2)>
#map8 = affine_map<() -> (3)>
#map9 = affine_map<(d0) -> (d0, 3)>
#map10 = affine_map<() -> (4)>
#map11 = affine_map<(d0) -> (d0, 4)>
#map12 = affine_map<() -> (5)>
#map13 = affine_map<(d0) -> (d0, 5)>
#map14 = affine_map<() -> (6)>
#map15 = affine_map<(d0) -> (d0, 6)>
#map16 = affine_map<() -> (7)>
#map17 = affine_map<(d0) -> (d0, 7)>
#map18 = affine_map<(d0, d1) -> (d0, d1)>
#map19 = affine_map<() -> (8)>
"builtin.module"() ({
  "func.func"() <{function_type = (i32, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?x8xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> (), sym_name = "_Z15raytracing_funciPKiS0_S0_S0_S0_S0_S0_S0_S0_S0_PiS1_S1_S1_S1_S1_S1_S1_S1_PA8_iS1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_"}> ({
  ^bb0(%arg0: i32, %arg1: memref<?xi32>, %arg2: memref<?xi32>, %arg3: memref<?xi32>, %arg4: memref<?xi32>, %arg5: memref<?xi32>, %arg6: memref<?xi32>, %arg7: memref<?xi32>, %arg8: memref<?xi32>, %arg9: memref<?xi32>, %arg10: memref<?xi32>, %arg11: memref<?xi32>, %arg12: memref<?xi32>, %arg13: memref<?xi32>, %arg14: memref<?xi32>, %arg15: memref<?xi32>, %arg16: memref<?xi32>, %arg17: memref<?xi32>, %arg18: memref<?xi32>, %arg19: memref<?xi32>, %arg20: memref<?x8xi32>, %arg21: memref<?xi32>, %arg22: memref<?xi32>, %arg23: memref<?xi32>, %arg24: memref<?xi32>, %arg25: memref<?xi32>, %arg26: memref<?xi32>, %arg27: memref<?xi32>, %arg28: memref<?xi32>, %arg29: memref<?xi32>, %arg30: memref<?xi32>, %arg31: memref<?xi32>, %arg32: memref<?xi32>, %arg33: memref<?xi32>, %arg34: memref<?xi32>, %arg35: memref<?xi32>, %arg36: memref<?xi32>, %arg37: memref<?xi32>, %arg38: memref<?xi32>, %arg39: memref<?xi32>, %arg40: memref<?xi32>, %arg41: memref<?xi32>, %arg42: memref<?xi32>, %arg43: memref<?xi32>, %arg44: memref<?xi32>, %arg45: memref<?xi32>):
    %0 = "arith.constant"() <{value = 1472 : i32}> : () -> i32
    %1 = "arith.constant"() <{value = -32 : i32}> : () -> i32
    %2 = "arith.constant"() <{value = 8 : i32}> : () -> i32
    %3 = "arith.constant"() <{value = 1073741824 : i32}> : () -> i32
    %4 = "arith.constant"() <{value = 4096 : i32}> : () -> i32
    %5 = "arith.constant"() <{value = 1024 : i32}> : () -> i32
    %6 = "arith.constant"() <{value = 32 : i32}> : () -> i32
    %7 = "arith.constant"() <{value = 1 : i32}> : () -> i32
    %8 = "arith.constant"() <{value = 64 : i32}> : () -> i32
    %9 = "arith.constant"() <{value = 0 : i32}> : () -> i32
    %10 = "arith.index_cast"(%0) : (i32) -> index
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg75: index):
      %281 = "arith.index_cast"(%arg75) : (index) -> i32
      %282 = "arith.remsi"(%281, %8) : (i32, i32) -> i32
      "affine.store"(%282, %arg11, %arg75) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %283 = "arith.divsi"(%281, %8) : (i32, i32) -> i32
      "affine.store"(%283, %arg12, %arg75) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg74: index):
      %275 = "affine.load"(%arg11, %arg74) <{map = #map}> : (memref<?xi32>, index) -> i32
      %276 = "arith.addi"(%275, %1) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %277 = "arith.muli"(%276, %6) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      "affine.store"(%277, %arg13, %arg74) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %278 = "affine.load"(%arg12, %arg74) <{map = #map}> : (memref<?xi32>, index) -> i32
      %279 = "arith.addi"(%278, %1) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %280 = "arith.muli"(%279, %6) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      "affine.store"(%280, %arg14, %arg74) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.store"(%5, %arg15, %arg74) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg73: index):
      %260 = "affine.load"(%arg13, %arg73) <{map = #map}> : (memref<?xi32>, index) -> i32
      %261 = "arith.cmpi"(%260, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %262 = "scf.if"(%261) ({
        "scf.yield"(%260) : (i32) -> ()
      }, {
        %274 = "arith.subi"(%9, %260) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%274) : (i32) -> ()
      }) : (i1) -> i32
      %263 = "affine.load"(%arg14, %arg73) <{map = #map}> : (memref<?xi32>, index) -> i32
      %264 = "arith.cmpi"(%263, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %265 = "scf.if"(%264) ({
        "scf.yield"(%263) : (i32) -> ()
      }, {
        %273 = "arith.subi"(%9, %263) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%273) : (i32) -> ()
      }) : (i1) -> i32
      %266 = "affine.load"(%arg15, %arg73) <{map = #map}> : (memref<?xi32>, index) -> i32
      %267 = "arith.cmpi"(%266, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %268 = "scf.if"(%267) ({
        "scf.yield"(%266) : (i32) -> ()
      }, {
        %272 = "arith.subi"(%9, %266) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%272) : (i32) -> ()
      }) : (i1) -> i32
      %269 = "arith.addi"(%262, %265) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %270 = "arith.addi"(%269, %268) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %271 = "arith.addi"(%270, %7) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      "affine.store"(%271, %arg16, %arg73) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg72: index):
      %248 = "affine.load"(%arg13, %arg72) <{map = #map}> : (memref<?xi32>, index) -> i32
      %249 = "arith.muli"(%248, %5) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %250 = "affine.load"(%arg16, %arg72) <{map = #map}> : (memref<?xi32>, index) -> i32
      %251 = "arith.divsi"(%249, %250) : (i32, i32) -> i32
      "affine.store"(%251, %arg17, %arg72) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %252 = "affine.load"(%arg14, %arg72) <{map = #map}> : (memref<?xi32>, index) -> i32
      %253 = "arith.muli"(%252, %5) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %254 = "affine.load"(%arg16, %arg72) <{map = #map}> : (memref<?xi32>, index) -> i32
      %255 = "arith.divsi"(%253, %254) : (i32, i32) -> i32
      "affine.store"(%255, %arg18, %arg72) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %256 = "affine.load"(%arg15, %arg72) <{map = #map}> : (memref<?xi32>, index) -> i32
      %257 = "arith.muli"(%256, %5) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %258 = "affine.load"(%arg16, %arg72) <{map = #map}> : (memref<?xi32>, index) -> i32
      %259 = "arith.divsi"(%257, %258) : (i32, i32) -> i32
      "affine.store"(%259, %arg19, %arg72) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg71: index):
      %240 = "affine.load"(%arg17, %arg71) <{map = #map}> : (memref<?xi32>, index) -> i32
      %241 = "affine.load"(%arg1) <{map = #map1}> : (memref<?xi32>) -> i32
      %242 = "arith.subi"(%240, %241) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %243 = "affine.load"(%arg3) <{map = #map1}> : (memref<?xi32>) -> i32
      %244 = "affine.load"(%arg4) <{map = #map1}> : (memref<?xi32>) -> i32
      %245 = "arith.subi"(%243, %244) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %246 = "arith.cmpi"(%242, %244) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %247 = "arith.select"(%246, %245, %9) : (i1, i32, i32) -> i32
      "affine.store"(%247, %arg20, %arg71) <{map = #map3}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg70: index):
      %232 = "affine.load"(%arg17, %arg70) <{map = #map}> : (memref<?xi32>, index) -> i32
      %233 = "affine.load"(%arg1) <{map = #map4}> : (memref<?xi32>) -> i32
      %234 = "arith.subi"(%232, %233) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %235 = "affine.load"(%arg3) <{map = #map4}> : (memref<?xi32>) -> i32
      %236 = "affine.load"(%arg4) <{map = #map4}> : (memref<?xi32>) -> i32
      %237 = "arith.subi"(%235, %236) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %238 = "arith.cmpi"(%234, %236) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %239 = "arith.select"(%238, %237, %9) : (i1, i32, i32) -> i32
      "affine.store"(%239, %arg20, %arg70) <{map = #map5}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg69: index):
      %224 = "affine.load"(%arg17, %arg69) <{map = #map}> : (memref<?xi32>, index) -> i32
      %225 = "affine.load"(%arg1) <{map = #map6}> : (memref<?xi32>) -> i32
      %226 = "arith.subi"(%224, %225) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %227 = "affine.load"(%arg3) <{map = #map6}> : (memref<?xi32>) -> i32
      %228 = "affine.load"(%arg4) <{map = #map6}> : (memref<?xi32>) -> i32
      %229 = "arith.subi"(%227, %228) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %230 = "arith.cmpi"(%226, %228) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %231 = "arith.select"(%230, %229, %9) : (i1, i32, i32) -> i32
      "affine.store"(%231, %arg20, %arg69) <{map = #map7}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg68: index):
      %216 = "affine.load"(%arg17, %arg68) <{map = #map}> : (memref<?xi32>, index) -> i32
      %217 = "affine.load"(%arg1) <{map = #map8}> : (memref<?xi32>) -> i32
      %218 = "arith.subi"(%216, %217) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %219 = "affine.load"(%arg3) <{map = #map8}> : (memref<?xi32>) -> i32
      %220 = "affine.load"(%arg4) <{map = #map8}> : (memref<?xi32>) -> i32
      %221 = "arith.subi"(%219, %220) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %222 = "arith.cmpi"(%218, %220) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %223 = "arith.select"(%222, %221, %9) : (i1, i32, i32) -> i32
      "affine.store"(%223, %arg20, %arg68) <{map = #map9}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg67: index):
      %208 = "affine.load"(%arg17, %arg67) <{map = #map}> : (memref<?xi32>, index) -> i32
      %209 = "affine.load"(%arg1) <{map = #map10}> : (memref<?xi32>) -> i32
      %210 = "arith.subi"(%208, %209) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %211 = "affine.load"(%arg3) <{map = #map10}> : (memref<?xi32>) -> i32
      %212 = "affine.load"(%arg4) <{map = #map10}> : (memref<?xi32>) -> i32
      %213 = "arith.subi"(%211, %212) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %214 = "arith.cmpi"(%210, %212) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %215 = "arith.select"(%214, %213, %9) : (i1, i32, i32) -> i32
      "affine.store"(%215, %arg20, %arg67) <{map = #map11}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg66: index):
      %200 = "affine.load"(%arg17, %arg66) <{map = #map}> : (memref<?xi32>, index) -> i32
      %201 = "affine.load"(%arg1) <{map = #map12}> : (memref<?xi32>) -> i32
      %202 = "arith.subi"(%200, %201) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %203 = "affine.load"(%arg3) <{map = #map12}> : (memref<?xi32>) -> i32
      %204 = "affine.load"(%arg4) <{map = #map12}> : (memref<?xi32>) -> i32
      %205 = "arith.subi"(%203, %204) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %206 = "arith.cmpi"(%202, %204) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %207 = "arith.select"(%206, %205, %9) : (i1, i32, i32) -> i32
      "affine.store"(%207, %arg20, %arg66) <{map = #map13}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg65: index):
      %192 = "affine.load"(%arg17, %arg65) <{map = #map}> : (memref<?xi32>, index) -> i32
      %193 = "affine.load"(%arg1) <{map = #map14}> : (memref<?xi32>) -> i32
      %194 = "arith.subi"(%192, %193) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %195 = "affine.load"(%arg3) <{map = #map14}> : (memref<?xi32>) -> i32
      %196 = "affine.load"(%arg4) <{map = #map14}> : (memref<?xi32>) -> i32
      %197 = "arith.subi"(%195, %196) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %198 = "arith.cmpi"(%194, %196) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %199 = "arith.select"(%198, %197, %9) : (i1, i32, i32) -> i32
      "affine.store"(%199, %arg20, %arg65) <{map = #map15}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg64: index):
      %184 = "affine.load"(%arg17, %arg64) <{map = #map}> : (memref<?xi32>, index) -> i32
      %185 = "affine.load"(%arg1) <{map = #map16}> : (memref<?xi32>) -> i32
      %186 = "arith.subi"(%184, %185) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %187 = "affine.load"(%arg3) <{map = #map16}> : (memref<?xi32>) -> i32
      %188 = "affine.load"(%arg4) <{map = #map16}> : (memref<?xi32>) -> i32
      %189 = "arith.subi"(%187, %188) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %190 = "arith.cmpi"(%186, %188) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %191 = "arith.select"(%190, %189, %9) : (i1, i32, i32) -> i32
      "affine.store"(%191, %arg20, %arg64) <{map = #map17}> : (i32, memref<?x8xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg63: index):
      %181 = "affine.load"(%arg18, %arg63) <{map = #map}> : (memref<?xi32>, index) -> i32
      %182 = "arith.cmpi"(%181, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %183 = "arith.select"(%182, %4, %3) : (i1, i32, i32) -> i32
      "affine.store"(%183, %arg21, %arg63) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg59: index):
      %170 = "affine.load"(%arg21, %arg59) <{map = #map}> : (memref<?xi32>, index) -> i32
      %171 = "arith.cmpi"(%170, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %172 = "arith.select"(%171, %170, %3) : (i1, i32, i32) -> i32
      %173:2 = "affine.for"(%172, %2) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 0, 2>, step = 1 : index, upperBoundMap = #map19}> ({
      ^bb0(%arg60: index, %arg61: i32, %arg62: i32):
        %174 = "arith.index_cast"(%arg60) : (index) -> i32
        %175 = "affine.load"(%arg20, %arg59, %arg60) <{map = #map18}> : (memref<?x8xi32>, index, index) -> i32
        %176 = "arith.cmpi"(%175, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
        %177:2 = "scf.if"(%176) ({
          %178 = "arith.cmpi"(%175, %arg61) <{predicate = 2 : i64}> : (i32, i32) -> i1
          %179 = "arith.select"(%178, %175, %arg61) : (i1, i32, i32) -> i32
          %180 = "arith.select"(%178, %174, %arg62) : (i1, i32, i32) -> i32
          "scf.yield"(%179, %180) : (i32, i32) -> ()
        }, {
          "scf.yield"(%arg61, %arg62) : (i32, i32) -> ()
        }) : (i1) -> (i32, i32)
        "affine.yield"(%177#0, %177#1) : (i32, i32) -> ()
      }) : (i32, i32) -> (i32, i32)
      "affine.store"(%173#1, %arg22, %arg59) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.store"(%173#0, %arg23, %arg59) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg58: index):
      %158 = "affine.load"(%arg17, %arg58) <{map = #map}> : (memref<?xi32>, index) -> i32
      %159 = "affine.load"(%arg23, %arg58) <{map = #map}> : (memref<?xi32>, index) -> i32
      %160 = "arith.muli"(%158, %159) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %161 = "arith.divsi"(%160, %5) : (i32, i32) -> i32
      "affine.store"(%161, %arg24, %arg58) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %162 = "affine.load"(%arg18, %arg58) <{map = #map}> : (memref<?xi32>, index) -> i32
      %163 = "affine.load"(%arg23, %arg58) <{map = #map}> : (memref<?xi32>, index) -> i32
      %164 = "arith.muli"(%162, %163) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %165 = "arith.divsi"(%164, %5) : (i32, i32) -> i32
      "affine.store"(%165, %arg25, %arg58) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %166 = "affine.load"(%arg19, %arg58) <{map = #map}> : (memref<?xi32>, index) -> i32
      %167 = "affine.load"(%arg23, %arg58) <{map = #map}> : (memref<?xi32>, index) -> i32
      %168 = "arith.muli"(%166, %167) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %169 = "arith.divsi"(%168, %5) : (i32, i32) -> i32
      "affine.store"(%169, %arg26, %arg58) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg57: index):
      %155 = "affine.load"(%arg17, %arg57) <{map = #map}> : (memref<?xi32>, index) -> i32
      "affine.store"(%155, %arg27, %arg57) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %156 = "affine.load"(%arg18, %arg57) <{map = #map}> : (memref<?xi32>, index) -> i32
      "affine.store"(%156, %arg28, %arg57) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %157 = "affine.load"(%arg19, %arg57) <{map = #map}> : (memref<?xi32>, index) -> i32
      "affine.store"(%157, %arg29, %arg57) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg56: index):
      %148 = "affine.load"(%arg22, %arg56) <{map = #map}> : (memref<?xi32>, index) -> i32
      %149 = "arith.cmpi"(%148, %2) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %150 = "arith.select"(%149, %148, %9) : (i1, i32, i32) -> i32
      %151 = "arith.index_cast"(%150) : (i32) -> index
      %152 = "memref.load"(%arg5, %151) : (memref<?xi32>, index) -> i32
      "affine.store"(%152, %arg30, %arg56) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %153 = "memref.load"(%arg6, %151) : (memref<?xi32>, index) -> i32
      "affine.store"(%153, %arg31, %arg56) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %154 = "memref.load"(%arg7, %151) : (memref<?xi32>, index) -> i32
      "affine.store"(%154, %arg32, %arg56) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg55: index):
      %136 = "affine.load"(%arg29, %arg55) <{map = #map}> : (memref<?xi32>, index) -> i32
      %137 = "affine.load"(%arg10) <{map = #map1}> : (memref<?xi32>) -> i32
      %138 = "arith.addi"(%136, %137) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %139 = "arith.cmpi"(%138, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %140 = "scf.if"(%139) ({
        %147 = "arith.divsi"(%138, %5) : (i32, i32) -> i32
        "scf.yield"(%147) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      "affine.store"(%140, %arg33, %arg55) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %141 = "affine.load"(%arg29, %arg55) <{map = #map}> : (memref<?xi32>, index) -> i32
      %142 = "affine.load"(%arg10) <{map = #map4}> : (memref<?xi32>) -> i32
      %143 = "arith.addi"(%141, %142) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %144 = "arith.cmpi"(%143, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %145 = "scf.if"(%144) ({
        %146 = "arith.divsi"(%143, %5) : (i32, i32) -> i32
        "scf.yield"(%146) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      "affine.store"(%145, %arg34, %arg55) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg54: index):
      %124 = "affine.load"(%arg29, %arg54) <{map = #map}> : (memref<?xi32>, index) -> i32
      %125 = "affine.load"(%arg10) <{map = #map6}> : (memref<?xi32>) -> i32
      %126 = "arith.addi"(%124, %125) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %127 = "arith.cmpi"(%126, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %128 = "scf.if"(%127) ({
        %135 = "arith.divsi"(%126, %5) : (i32, i32) -> i32
        "scf.yield"(%135) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      "affine.store"(%128, %arg35, %arg54) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %129 = "affine.load"(%arg29, %arg54) <{map = #map}> : (memref<?xi32>, index) -> i32
      %130 = "affine.load"(%arg10) <{map = #map8}> : (memref<?xi32>) -> i32
      %131 = "arith.addi"(%129, %130) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %132 = "arith.cmpi"(%131, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
      %133 = "scf.if"(%132) ({
        %134 = "arith.divsi"(%131, %5) : (i32, i32) -> i32
        "scf.yield"(%134) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      "affine.store"(%133, %arg36, %arg54) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg53: index):
      %104 = "affine.load"(%arg22, %arg53) <{map = #map}> : (memref<?xi32>, index) -> i32
      %105 = "arith.cmpi"(%104, %2) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %106 = "scf.if"(%105) ({
        %122 = "arith.index_cast"(%104) : (i32) -> index
        %123 = "memref.load"(%arg4, %122) : (memref<?xi32>, index) -> i32
        "scf.yield"(%123) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      %107 = "affine.load"(%arg8) <{map = #map1}> : (memref<?xi32>) -> i32
      %108 = "affine.load"(%arg24, %arg53) <{map = #map}> : (memref<?xi32>, index) -> i32
      %109 = "arith.subi"(%107, %108) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %110 = "affine.load"(%arg9) <{map = #map1}> : (memref<?xi32>) -> i32
      %111 = "affine.load"(%arg25, %arg53) <{map = #map}> : (memref<?xi32>, index) -> i32
      %112 = "arith.subi"(%110, %111) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %113 = "arith.cmpi"(%109, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %114 = "scf.if"(%113) ({
        %121 = "arith.subi"(%9, %109) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%121) : (i32) -> ()
      }, {
        "scf.yield"(%109) : (i32) -> ()
      }) : (i1) -> i32
      %115 = "arith.cmpi"(%112, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %116 = "scf.if"(%115) ({
        %120 = "arith.subi"(%9, %112) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%120) : (i32) -> ()
      }, {
        "scf.yield"(%112) : (i32) -> ()
      }) : (i1) -> i32
      %117 = "arith.addi"(%114, %116) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %118 = "arith.cmpi"(%117, %106) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %119 = "arith.extui"(%118) : (i1) -> i32
      "affine.store"(%119, %arg37, %arg53) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg52: index):
      %84 = "affine.load"(%arg22, %arg52) <{map = #map}> : (memref<?xi32>, index) -> i32
      %85 = "arith.cmpi"(%84, %2) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %86 = "scf.if"(%85) ({
        %102 = "arith.index_cast"(%84) : (i32) -> index
        %103 = "memref.load"(%arg4, %102) : (memref<?xi32>, index) -> i32
        "scf.yield"(%103) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      %87 = "affine.load"(%arg8) <{map = #map4}> : (memref<?xi32>) -> i32
      %88 = "affine.load"(%arg24, %arg52) <{map = #map}> : (memref<?xi32>, index) -> i32
      %89 = "arith.subi"(%87, %88) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %90 = "affine.load"(%arg9) <{map = #map4}> : (memref<?xi32>) -> i32
      %91 = "affine.load"(%arg25, %arg52) <{map = #map}> : (memref<?xi32>, index) -> i32
      %92 = "arith.subi"(%90, %91) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %93 = "arith.cmpi"(%89, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %94 = "scf.if"(%93) ({
        %101 = "arith.subi"(%9, %89) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%101) : (i32) -> ()
      }, {
        "scf.yield"(%89) : (i32) -> ()
      }) : (i1) -> i32
      %95 = "arith.cmpi"(%92, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %96 = "scf.if"(%95) ({
        %100 = "arith.subi"(%9, %92) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%100) : (i32) -> ()
      }, {
        "scf.yield"(%92) : (i32) -> ()
      }) : (i1) -> i32
      %97 = "arith.addi"(%94, %96) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %98 = "arith.cmpi"(%97, %86) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %99 = "arith.extui"(%98) : (i1) -> i32
      "affine.store"(%99, %arg38, %arg52) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg51: index):
      %64 = "affine.load"(%arg22, %arg51) <{map = #map}> : (memref<?xi32>, index) -> i32
      %65 = "arith.cmpi"(%64, %2) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %66 = "scf.if"(%65) ({
        %82 = "arith.index_cast"(%64) : (i32) -> index
        %83 = "memref.load"(%arg4, %82) : (memref<?xi32>, index) -> i32
        "scf.yield"(%83) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      %67 = "affine.load"(%arg8) <{map = #map6}> : (memref<?xi32>) -> i32
      %68 = "affine.load"(%arg24, %arg51) <{map = #map}> : (memref<?xi32>, index) -> i32
      %69 = "arith.subi"(%67, %68) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %70 = "affine.load"(%arg9) <{map = #map6}> : (memref<?xi32>) -> i32
      %71 = "affine.load"(%arg25, %arg51) <{map = #map}> : (memref<?xi32>, index) -> i32
      %72 = "arith.subi"(%70, %71) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %73 = "arith.cmpi"(%69, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %74 = "scf.if"(%73) ({
        %81 = "arith.subi"(%9, %69) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%81) : (i32) -> ()
      }, {
        "scf.yield"(%69) : (i32) -> ()
      }) : (i1) -> i32
      %75 = "arith.cmpi"(%72, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %76 = "scf.if"(%75) ({
        %80 = "arith.subi"(%9, %72) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%80) : (i32) -> ()
      }, {
        "scf.yield"(%72) : (i32) -> ()
      }) : (i1) -> i32
      %77 = "arith.addi"(%74, %76) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %78 = "arith.cmpi"(%77, %66) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %79 = "arith.extui"(%78) : (i1) -> i32
      "affine.store"(%79, %arg39, %arg51) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg50: index):
      %44 = "affine.load"(%arg22, %arg50) <{map = #map}> : (memref<?xi32>, index) -> i32
      %45 = "arith.cmpi"(%44, %2) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %46 = "scf.if"(%45) ({
        %62 = "arith.index_cast"(%44) : (i32) -> index
        %63 = "memref.load"(%arg4, %62) : (memref<?xi32>, index) -> i32
        "scf.yield"(%63) : (i32) -> ()
      }, {
        "scf.yield"(%9) : (i32) -> ()
      }) : (i1) -> i32
      %47 = "affine.load"(%arg8) <{map = #map8}> : (memref<?xi32>) -> i32
      %48 = "affine.load"(%arg24, %arg50) <{map = #map}> : (memref<?xi32>, index) -> i32
      %49 = "arith.subi"(%47, %48) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %50 = "affine.load"(%arg9) <{map = #map8}> : (memref<?xi32>) -> i32
      %51 = "affine.load"(%arg25, %arg50) <{map = #map}> : (memref<?xi32>, index) -> i32
      %52 = "arith.subi"(%50, %51) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %53 = "arith.cmpi"(%49, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %54 = "scf.if"(%53) ({
        %61 = "arith.subi"(%9, %49) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%61) : (i32) -> ()
      }, {
        "scf.yield"(%49) : (i32) -> ()
      }) : (i1) -> i32
      %55 = "arith.cmpi"(%52, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %56 = "scf.if"(%55) ({
        %60 = "arith.subi"(%9, %52) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
        "scf.yield"(%60) : (i32) -> ()
      }, {
        "scf.yield"(%52) : (i32) -> ()
      }) : (i1) -> i32
      %57 = "arith.addi"(%54, %56) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %58 = "arith.cmpi"(%57, %46) <{predicate = 2 : i64}> : (i32, i32) -> i1
      %59 = "arith.extui"(%58) : (i1) -> i32
      "affine.store"(%59, %arg40, %arg50) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg49: index):
      %36 = "affine.load"(%arg33, %arg49) <{map = #map}> : (memref<?xi32>, index) -> i32
      %37 = "arith.addi"(%36, %8) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %38 = "affine.load"(%arg34, %arg49) <{map = #map}> : (memref<?xi32>, index) -> i32
      %39 = "arith.addi"(%37, %38) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %40 = "affine.load"(%arg35, %arg49) <{map = #map}> : (memref<?xi32>, index) -> i32
      %41 = "arith.addi"(%39, %40) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %42 = "affine.load"(%arg36, %arg49) <{map = #map}> : (memref<?xi32>, index) -> i32
      %43 = "arith.addi"(%41, %42) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      "affine.store"(%43, %arg41, %arg49) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg48: index):
      %28 = "affine.load"(%arg37, %arg48) <{map = #map}> : (memref<?xi32>, index) -> i32
      %29 = "affine.load"(%arg38, %arg48) <{map = #map}> : (memref<?xi32>, index) -> i32
      %30 = "arith.addi"(%28, %29) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %31 = "affine.load"(%arg39, %arg48) <{map = #map}> : (memref<?xi32>, index) -> i32
      %32 = "arith.addi"(%30, %31) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %33 = "affine.load"(%arg40, %arg48) <{map = #map}> : (memref<?xi32>, index) -> i32
      %34 = "arith.addi"(%32, %33) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %35 = "arith.addi"(%34, %7) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      "affine.store"(%35, %arg42, %arg48) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg47: index):
      %13 = "affine.load"(%arg30, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %14 = "affine.load"(%arg41, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %15 = "arith.muli"(%13, %14) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %16 = "affine.load"(%arg42, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %17 = "arith.divsi"(%15, %16) : (i32, i32) -> i32
      "affine.store"(%17, %arg43, %arg47) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %18 = "affine.load"(%arg31, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %19 = "affine.load"(%arg41, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %20 = "arith.muli"(%18, %19) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %21 = "affine.load"(%arg42, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %22 = "arith.divsi"(%20, %21) : (i32, i32) -> i32
      "affine.store"(%22, %arg44, %arg47) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      %23 = "affine.load"(%arg32, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %24 = "affine.load"(%arg41, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %25 = "arith.muli"(%23, %24) <{overflowFlags = #arith.overflow<none>}> : (i32, i32) -> i32
      %26 = "affine.load"(%arg42, %arg47) <{map = #map}> : (memref<?xi32>, index) -> i32
      %27 = "arith.divsi"(%25, %26) : (i32, i32) -> i32
      "affine.store"(%27, %arg45, %arg47) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "affine.for"(%10) <{lowerBoundMap = #map1, operandSegmentSizes = array<i32: 0, 1, 0>, step = 1 : index, upperBoundMap = #map2}> ({
    ^bb0(%arg46: index):
      %11 = "affine.load"(%arg23, %arg46) <{map = #map}> : (memref<?xi32>, index) -> i32
      %12 = "arith.cmpi"(%11, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
      "scf.if"(%12) ({
        "affine.store"(%9, %arg43, %arg46) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
        "affine.store"(%9, %arg44, %arg46) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
        "affine.store"(%9, %arg45, %arg46) <{map = #map}> : (i32, memref<?xi32>, index) -> ()
        "scf.yield"() : () -> ()
      }, {
      }) : (i1) -> ()
      "affine.yield"() : () -> ()
    }) : (index) -> ()
    "func.return"() : () -> ()
  }) {amoeba.static_bound.arg.0 = 1472 : i64, llvm.linkage = #llvm.linkage<external>} : () -> ()
}) : () -> ()

