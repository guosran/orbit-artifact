module {
  func.func @down(%H: memref<8x11008xf32> {orbit.role = "input", orbit.name = "H"}, %W_down: memref<11008x2048xf32> {orbit.role = "input", orbit.name = "W_down"}, %Y: memref<8x2048xf32> {orbit.role = "output", orbit.name = "Y"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %stage_result = taskflow.task @down will_reads(%H, %W_down : memref<8x11008xf32>, memref<11008x2048xf32>) will_writes(%Y : memref<8x2048xf32>) [original_read_memrefs(%H, %W_down : memref<8x11008xf32>, memref<11008x2048xf32>), original_write_memrefs(%Y : memref<8x2048xf32>)] : (memref<8x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>) -> memref<8x2048xf32> {
    ^bb0(%H_b: memref<8x11008xf32>, %W_down_b: memref<11008x2048xf32>, %Y_b: memref<8x2048xf32>):
      %zero = arith.constant 0.0 : f32
      affine.for %i = 0 to 8 {
        affine.for %j = 0 to 2048 {
          affine.store %zero, %Y_b[%i, %j] : memref<8x2048xf32>
          affine.for %k = 0 to 11008 {
            %x = affine.load %H_b[%i, %k] : memref<8x11008xf32>
            %w = affine.load %W_down_b[%k, %j] : memref<11008x2048xf32>
            %old = affine.load %Y_b[%i, %j] : memref<8x2048xf32>
            %p = arith.mulf %x, %w : f32
            %sum = arith.addf %old, %p : f32
            affine.store %sum, %Y_b[%i, %j] : memref<8x2048xf32>
          }
        }
      }
      taskflow.yield done_writes(%Y_b : memref<8x2048xf32>)
    }
    return
  }
}
