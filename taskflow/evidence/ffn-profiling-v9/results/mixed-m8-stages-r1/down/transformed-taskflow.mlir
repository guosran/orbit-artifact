module attributes {orbit.implementation = "scalar-product-vector-add-f32", orbit.vector_lanes = 8 : i64} {
  func.func @down(%arg0: memref<8x11008xf32> {orbit.name = "H", orbit.role = "input"}, %arg1: memref<11008x2048xf32> {orbit.name = "W_down", orbit.role = "input"}, %arg2: memref<8x2048xf32> {orbit.name = "Y", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %done_writes = taskflow.task @down.initialize will_reads(%arg0, %arg1 : memref<8x11008xf32>, memref<11008x2048xf32>) will_writes(%arg2 : memref<8x2048xf32>) [original_read_memrefs(%arg0, %arg1 : memref<8x11008xf32>, memref<11008x2048xf32>), original_write_memrefs(%arg2 : memref<8x2048xf32>)] : (memref<8x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>) -> (memref<8x2048xf32>) {
    ^bb0(%arg3: memref<8x11008xf32>, %arg4: memref<11008x2048xf32>, %arg5: memref<8x2048xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg6 = 0 to 8 {
        affine.for %arg7 = 0 to 2048 {
          affine.store %cst, %arg5[%arg6, %arg7] : memref<8x2048xf32>
        }
      }
      taskflow.yield done_writes(%arg5 : memref<8x2048xf32>)
    }
    %done_writes_0 = taskflow.task @down will_reads(%arg0, %arg1 : memref<8x11008xf32>, memref<11008x2048xf32>) will_writes(%done_writes : memref<8x2048xf32>) [original_read_memrefs(%arg0, %arg1 : memref<8x11008xf32>, memref<11008x2048xf32>), original_write_memrefs(%arg2 : memref<8x2048xf32>)] {orbit.distributed_initialization} : (memref<8x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>) -> (memref<8x2048xf32>) {
    ^bb0(%arg3: memref<8x11008xf32>, %arg4: memref<11008x2048xf32>, %arg5: memref<8x2048xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg6 = 0 to 8 {
        affine.for %arg7 = 0 to 2048 {
          affine.for %arg8 = 0 to 11008 {
            %0 = affine.load %arg3[%arg6, %arg8] : memref<8x11008xf32>
            %1 = affine.load %arg4[%arg8, %arg7] : memref<11008x2048xf32>
            %2 = affine.load %arg5[%arg6, %arg7] : memref<8x2048xf32>
            %3 = arith.mulf %0, %1 : f32
            %4 = arith.addf %2, %3 : f32
            affine.store %4, %arg5[%arg6, %arg7] : memref<8x2048xf32>
          }
        }
      }
      taskflow.yield done_writes(%arg5 : memref<8x2048xf32>)
    }
    return
  }
}

