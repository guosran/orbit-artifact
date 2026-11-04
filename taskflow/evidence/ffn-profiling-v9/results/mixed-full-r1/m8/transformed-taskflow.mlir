module attributes {orbit.implementation = "scalar-product-vector-add-f32", orbit.vector_lanes = 8 : i64} {
  func.func @ffn(%arg0: memref<8x2048xf32> {orbit.name = "X", orbit.role = "input"}, %arg1: memref<2048x11008xf32> {orbit.name = "W_gate", orbit.role = "input"}, %arg2: memref<2048x11008xf32> {orbit.name = "W_up", orbit.role = "input"}, %arg3: memref<11008x2048xf32> {orbit.name = "W_down", orbit.role = "input"}, %arg4: memref<8x2048xf32> {orbit.name = "Y", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %alloc = memref.alloc() {orbit.name = "G"} : memref<8x11008xf32>
    %alloc_0 = memref.alloc() {orbit.name = "U"} : memref<8x11008xf32>
    %alloc_1 = memref.alloc() {orbit.name = "H"} : memref<8x11008xf32>
    %done_writes = taskflow.task @gate.initialize will_reads(%arg0, %arg1 : memref<8x2048xf32>, memref<2048x11008xf32>) will_writes(%alloc : memref<8x11008xf32>) [original_read_memrefs(%arg0, %arg1 : memref<8x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%alloc : memref<8x11008xf32>)] : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> (memref<8x11008xf32>) {
    ^bb0(%arg5: memref<8x2048xf32>, %arg6: memref<2048x11008xf32>, %arg7: memref<8x11008xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg8 = 0 to 8 {
        affine.for %arg9 = 0 to 11008 {
          affine.store %cst, %arg7[%arg8, %arg9] : memref<8x11008xf32>
        }
      }
      taskflow.yield done_writes(%arg7 : memref<8x11008xf32>)
    }
    %done_writes_2 = taskflow.task @gate will_reads(%arg0, %arg1 : memref<8x2048xf32>, memref<2048x11008xf32>) will_writes(%done_writes : memref<8x11008xf32>) [original_read_memrefs(%arg0, %arg1 : memref<8x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%alloc : memref<8x11008xf32>)] {orbit.distributed_initialization} : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> (memref<8x11008xf32>) {
    ^bb0(%arg5: memref<8x2048xf32>, %arg6: memref<2048x11008xf32>, %arg7: memref<8x11008xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg8 = 0 to 8 {
        affine.for %arg9 = 0 to 11008 {
          affine.for %arg10 = 0 to 2048 {
            %0 = affine.load %arg5[%arg8, %arg10] : memref<8x2048xf32>
            %1 = affine.load %arg6[%arg10, %arg9] : memref<2048x11008xf32>
            %2 = affine.load %arg7[%arg8, %arg9] : memref<8x11008xf32>
            %3 = arith.mulf %0, %1 : f32
            %4 = arith.addf %2, %3 : f32
            affine.store %4, %arg7[%arg8, %arg9] : memref<8x11008xf32>
          }
        }
      }
      taskflow.yield done_writes(%arg7 : memref<8x11008xf32>)
    }
    %done_writes_3 = taskflow.task @up.initialize will_reads(%arg0, %arg2 : memref<8x2048xf32>, memref<2048x11008xf32>) will_writes(%alloc_0 : memref<8x11008xf32>) [original_read_memrefs(%arg0, %arg2 : memref<8x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%alloc_0 : memref<8x11008xf32>)] : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> (memref<8x11008xf32>) {
    ^bb0(%arg5: memref<8x2048xf32>, %arg6: memref<2048x11008xf32>, %arg7: memref<8x11008xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg8 = 0 to 8 {
        affine.for %arg9 = 0 to 11008 {
          affine.store %cst, %arg7[%arg8, %arg9] : memref<8x11008xf32>
        }
      }
      taskflow.yield done_writes(%arg7 : memref<8x11008xf32>)
    }
    %done_writes_4 = taskflow.task @up will_reads(%arg0, %arg2 : memref<8x2048xf32>, memref<2048x11008xf32>) will_writes(%done_writes_3 : memref<8x11008xf32>) [original_read_memrefs(%arg0, %arg2 : memref<8x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%alloc_0 : memref<8x11008xf32>)] {orbit.distributed_initialization} : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> (memref<8x11008xf32>) {
    ^bb0(%arg5: memref<8x2048xf32>, %arg6: memref<2048x11008xf32>, %arg7: memref<8x11008xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg8 = 0 to 8 {
        affine.for %arg9 = 0 to 11008 {
          affine.for %arg10 = 0 to 2048 {
            %0 = affine.load %arg5[%arg8, %arg10] : memref<8x2048xf32>
            %1 = affine.load %arg6[%arg10, %arg9] : memref<2048x11008xf32>
            %2 = affine.load %arg7[%arg8, %arg9] : memref<8x11008xf32>
            %3 = arith.mulf %0, %1 : f32
            %4 = arith.addf %2, %3 : f32
            affine.store %4, %arg7[%arg8, %arg9] : memref<8x11008xf32>
          }
        }
      }
      taskflow.yield done_writes(%arg7 : memref<8x11008xf32>)
    }
    %done_writes_5 = taskflow.task @swiglu will_reads(%done_writes_2, %done_writes_4 : memref<8x11008xf32>, memref<8x11008xf32>) will_writes(%alloc_1 : memref<8x11008xf32>) [original_read_memrefs(%done_writes_2, %done_writes_4 : memref<8x11008xf32>, memref<8x11008xf32>), original_write_memrefs(%alloc_1 : memref<8x11008xf32>)] : (memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> (memref<8x11008xf32>) {
    ^bb0(%arg5: memref<8x11008xf32>, %arg6: memref<8x11008xf32>, %arg7: memref<8x11008xf32>):
      %cst = arith.constant 1.000000e+00 : f32
      affine.for %arg8 = 0 to 8 {
        affine.for %arg9 = 0 to 11008 {
          %0 = affine.load %arg5[%arg8, %arg9] : memref<8x11008xf32>
          %1 = affine.load %arg6[%arg8, %arg9] : memref<8x11008xf32>
          %2 = arith.negf %0 : f32
          %3 = math.exp %2 : f32
          %4 = arith.addf %cst, %3 : f32
          %5 = arith.divf %0, %4 : f32
          %6 = arith.mulf %5, %1 : f32
          affine.store %6, %arg7[%arg8, %arg9] : memref<8x11008xf32>
        }
      }
      taskflow.yield done_writes(%arg7 : memref<8x11008xf32>)
    }
    %done_writes_6 = taskflow.task @down.initialize will_reads(%done_writes_5, %arg3 : memref<8x11008xf32>, memref<11008x2048xf32>) will_writes(%arg4 : memref<8x2048xf32>) [original_read_memrefs(%done_writes_5, %arg3 : memref<8x11008xf32>, memref<11008x2048xf32>), original_write_memrefs(%arg4 : memref<8x2048xf32>)] : (memref<8x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>) -> (memref<8x2048xf32>) {
    ^bb0(%arg5: memref<8x11008xf32>, %arg6: memref<11008x2048xf32>, %arg7: memref<8x2048xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg8 = 0 to 8 {
        affine.for %arg9 = 0 to 2048 {
          affine.store %cst, %arg7[%arg8, %arg9] : memref<8x2048xf32>
        }
      }
      taskflow.yield done_writes(%arg7 : memref<8x2048xf32>)
    }
    %done_writes_7 = taskflow.task @down will_reads(%done_writes_5, %arg3 : memref<8x11008xf32>, memref<11008x2048xf32>) will_writes(%done_writes_6 : memref<8x2048xf32>) [original_read_memrefs(%done_writes_5, %arg3 : memref<8x11008xf32>, memref<11008x2048xf32>), original_write_memrefs(%arg4 : memref<8x2048xf32>)] {orbit.distributed_initialization} : (memref<8x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>) -> (memref<8x2048xf32>) {
    ^bb0(%arg5: memref<8x11008xf32>, %arg6: memref<11008x2048xf32>, %arg7: memref<8x2048xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg8 = 0 to 8 {
        affine.for %arg9 = 0 to 2048 {
          affine.for %arg10 = 0 to 11008 {
            %0 = affine.load %arg5[%arg8, %arg10] : memref<8x11008xf32>
            %1 = affine.load %arg6[%arg10, %arg9] : memref<11008x2048xf32>
            %2 = affine.load %arg7[%arg8, %arg9] : memref<8x2048xf32>
            %3 = arith.mulf %0, %1 : f32
            %4 = arith.addf %2, %3 : f32
            affine.store %4, %arg7[%arg8, %arg9] : memref<8x2048xf32>
          }
        }
      }
      taskflow.yield done_writes(%arg7 : memref<8x2048xf32>)
    }
    memref.dealloc %alloc : memref<8x11008xf32>
    memref.dealloc %alloc_0 : memref<8x11008xf32>
    memref.dealloc %alloc_1 : memref<8x11008xf32>
    return
  }
}

