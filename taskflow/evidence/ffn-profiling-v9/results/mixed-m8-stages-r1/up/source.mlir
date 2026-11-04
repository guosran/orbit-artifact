module {
  func.func @up(%X: memref<8x2048xf32> {orbit.role = "input", orbit.name = "X"}, %W_up: memref<2048x11008xf32> {orbit.role = "input", orbit.name = "W_up"}, %U: memref<8x11008xf32> {orbit.role = "output", orbit.name = "U"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %stage_result = taskflow.task @up will_reads(%X, %W_up : memref<8x2048xf32>, memref<2048x11008xf32>) will_writes(%U : memref<8x11008xf32>) [original_read_memrefs(%X, %W_up : memref<8x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%U : memref<8x11008xf32>)] : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> memref<8x11008xf32> {
    ^bb0(%X_b: memref<8x2048xf32>, %W_up_b: memref<2048x11008xf32>, %U_b: memref<8x11008xf32>):
      %zero = arith.constant 0.0 : f32
      affine.for %i = 0 to 8 {
        affine.for %j = 0 to 11008 {
          affine.store %zero, %U_b[%i, %j] : memref<8x11008xf32>
          affine.for %k = 0 to 2048 {
            %x = affine.load %X_b[%i, %k] : memref<8x2048xf32>
            %w = affine.load %W_up_b[%k, %j] : memref<2048x11008xf32>
            %old = affine.load %U_b[%i, %j] : memref<8x11008xf32>
            %p = arith.mulf %x, %w : f32
            %sum = arith.addf %old, %p : f32
            affine.store %sum, %U_b[%i, %j] : memref<8x11008xf32>
          }
        }
      }
      taskflow.yield done_writes(%U_b : memref<8x11008xf32>)
    }
    return
  }
}
