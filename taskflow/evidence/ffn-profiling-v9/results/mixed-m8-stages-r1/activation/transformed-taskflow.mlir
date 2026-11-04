module attributes {orbit.implementation = "scalar", orbit.vector_lanes = 1 : i64} {
  func.func @activation(%arg0: memref<8x11008xf32> {orbit.name = "G", orbit.role = "input"}, %arg1: memref<8x11008xf32> {orbit.name = "U", orbit.role = "input"}, %arg2: memref<8x11008xf32> {orbit.name = "H", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %done_writes = taskflow.task @swiglu will_reads(%arg0, %arg1 : memref<8x11008xf32>, memref<8x11008xf32>) will_writes(%arg2 : memref<8x11008xf32>) [original_read_memrefs(%arg0, %arg1 : memref<8x11008xf32>, memref<8x11008xf32>), original_write_memrefs(%arg2 : memref<8x11008xf32>)] : (memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> (memref<8x11008xf32>) {
    ^bb0(%arg3: memref<8x11008xf32>, %arg4: memref<8x11008xf32>, %arg5: memref<8x11008xf32>):
      %cst = arith.constant 1.000000e+00 : f32
      affine.for %arg6 = 0 to 8 {
        affine.for %arg7 = 0 to 11008 {
          %0 = affine.load %arg3[%arg6, %arg7] : memref<8x11008xf32>
          %1 = affine.load %arg4[%arg6, %arg7] : memref<8x11008xf32>
          %2 = arith.negf %0 : f32
          %3 = math.exp %2 : f32
          %4 = arith.addf %cst, %3 : f32
          %5 = arith.divf %0, %4 : f32
          %6 = arith.mulf %5, %1 : f32
          affine.store %6, %arg5[%arg6, %arg7] : memref<8x11008xf32>
        }
      }
      taskflow.yield done_writes(%arg5 : memref<8x11008xf32>)
    }
    return
  }
}

