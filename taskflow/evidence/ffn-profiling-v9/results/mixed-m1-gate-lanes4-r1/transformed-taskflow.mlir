module attributes {orbit.implementation = "scalar-product-vector-add-f32", orbit.vector_lanes = 4 : i64} {
  func.func @gate(%arg0: memref<1x2048xf32> {orbit.name = "X", orbit.role = "input"}, %arg1: memref<2048x11008xf32> {orbit.name = "W_gate", orbit.role = "input"}, %arg2: memref<1x11008xf32> {orbit.name = "G", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %done_writes = taskflow.task @gate.initialize will_reads(%arg0, %arg1 : memref<1x2048xf32>, memref<2048x11008xf32>) will_writes(%arg2 : memref<1x11008xf32>) [original_read_memrefs(%arg0, %arg1 : memref<1x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%arg2 : memref<1x11008xf32>)] : (memref<1x2048xf32>, memref<2048x11008xf32>, memref<1x11008xf32>) -> (memref<1x11008xf32>) {
    ^bb0(%arg3: memref<1x2048xf32>, %arg4: memref<2048x11008xf32>, %arg5: memref<1x11008xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg6 = 0 to 1 {
        affine.for %arg7 = 0 to 11008 {
          affine.store %cst, %arg5[%arg6, %arg7] : memref<1x11008xf32>
        }
      }
      taskflow.yield done_writes(%arg5 : memref<1x11008xf32>)
    }
    %done_writes_0 = taskflow.task @gate will_reads(%arg0, %arg1 : memref<1x2048xf32>, memref<2048x11008xf32>) will_writes(%done_writes : memref<1x11008xf32>) [original_read_memrefs(%arg0, %arg1 : memref<1x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%arg2 : memref<1x11008xf32>)] {orbit.distributed_initialization} : (memref<1x2048xf32>, memref<2048x11008xf32>, memref<1x11008xf32>) -> (memref<1x11008xf32>) {
    ^bb0(%arg3: memref<1x2048xf32>, %arg4: memref<2048x11008xf32>, %arg5: memref<1x11008xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg6 = 0 to 1 {
        affine.for %arg7 = 0 to 11008 {
          affine.for %arg8 = 0 to 2048 {
            %0 = affine.load %arg3[%arg6, %arg8] : memref<1x2048xf32>
            %1 = affine.load %arg4[%arg8, %arg7] : memref<2048x11008xf32>
            %2 = affine.load %arg5[%arg6, %arg7] : memref<1x11008xf32>
            %3 = arith.mulf %0, %1 : f32
            %4 = arith.addf %2, %3 : f32
            affine.store %4, %arg5[%arg6, %arg7] : memref<1x11008xf32>
          }
        }
      }
      taskflow.yield done_writes(%arg5 : memref<1x11008xf32>)
    }
    return
  }
}

