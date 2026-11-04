module {
  func.func @ffn(%X: memref<8x2048xf32> {orbit.role = "input", orbit.name = "X"}, %W_gate: memref<2048x11008xf32> {orbit.role = "input", orbit.name = "W_gate"}, %W_up: memref<2048x11008xf32> {orbit.role = "input", orbit.name = "W_up"}, %W_down: memref<11008x2048xf32> {orbit.role = "input", orbit.name = "W_down"}, %Y: memref<8x2048xf32> {orbit.role = "output", orbit.name = "Y"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %G = memref.alloc() {orbit.name = "G"} : memref<8x11008xf32>
    %U = memref.alloc() {orbit.name = "U"} : memref<8x11008xf32>
    %H = memref.alloc() {orbit.name = "H"} : memref<8x11008xf32>
    %G_done = taskflow.task @gate will_reads(%X, %W_gate : memref<8x2048xf32>, memref<2048x11008xf32>) will_writes(%G : memref<8x11008xf32>) [original_read_memrefs(%X, %W_gate : memref<8x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%G : memref<8x11008xf32>)] : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> memref<8x11008xf32> {
    ^bb0(%X_b: memref<8x2048xf32>, %W_gate_b: memref<2048x11008xf32>, %G_b: memref<8x11008xf32>):
      %zero = arith.constant 0.0 : f32
      affine.for %i = 0 to 8 {
        affine.for %j = 0 to 11008 {
          affine.store %zero, %G_b[%i, %j] : memref<8x11008xf32>
          affine.for %k = 0 to 2048 {
            %x = affine.load %X_b[%i, %k] : memref<8x2048xf32>
            %w = affine.load %W_gate_b[%k, %j] : memref<2048x11008xf32>
            %old = affine.load %G_b[%i, %j] : memref<8x11008xf32>
            %p = arith.mulf %x, %w : f32
            %sum = arith.addf %old, %p : f32
            affine.store %sum, %G_b[%i, %j] : memref<8x11008xf32>
          }
        }
      }
      taskflow.yield done_writes(%G_b : memref<8x11008xf32>)
    }
    %U_done = taskflow.task @up will_reads(%X, %W_up : memref<8x2048xf32>, memref<2048x11008xf32>) will_writes(%U : memref<8x11008xf32>) [original_read_memrefs(%X, %W_up : memref<8x2048xf32>, memref<2048x11008xf32>), original_write_memrefs(%U : memref<8x11008xf32>)] : (memref<8x2048xf32>, memref<2048x11008xf32>, memref<8x11008xf32>) -> memref<8x11008xf32> {
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
    %H_done = taskflow.task @swiglu will_reads(%G_done, %U_done : memref<8x11008xf32>, memref<8x11008xf32>) will_writes(%H : memref<8x11008xf32>) [original_read_memrefs(%G_done, %U_done : memref<8x11008xf32>, memref<8x11008xf32>), original_write_memrefs(%H : memref<8x11008xf32>)] : (memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> memref<8x11008xf32> {
    ^bb0(%G_done_b: memref<8x11008xf32>, %U_done_b: memref<8x11008xf32>, %H_b: memref<8x11008xf32>):
      %one = arith.constant 1.0 : f32
      affine.for %i = 0 to 8 {
        affine.for %j = 0 to 11008 {
          %g = affine.load %G_done_b[%i, %j] : memref<8x11008xf32>
          %u = affine.load %U_done_b[%i, %j] : memref<8x11008xf32>
          %neg = arith.negf %g : f32
          %e = math.exp %neg : f32
          %den = arith.addf %one, %e : f32
          %sig = arith.divf %g, %den : f32
          %h = arith.mulf %sig, %u : f32
          affine.store %h, %H_b[%i, %j] : memref<8x11008xf32>
        }
      }
      taskflow.yield done_writes(%H_b : memref<8x11008xf32>)
    }
    %Y_done = taskflow.task @down will_reads(%H_done, %W_down : memref<8x11008xf32>, memref<11008x2048xf32>) will_writes(%Y : memref<8x2048xf32>) [original_read_memrefs(%H_done, %W_down : memref<8x11008xf32>, memref<11008x2048xf32>), original_write_memrefs(%Y : memref<8x2048xf32>)] : (memref<8x11008xf32>, memref<11008x2048xf32>, memref<8x2048xf32>) -> memref<8x2048xf32> {
    ^bb0(%H_done_b: memref<8x11008xf32>, %W_down_b: memref<11008x2048xf32>, %Y_b: memref<8x2048xf32>):
      %zero = arith.constant 0.0 : f32
      affine.for %i = 0 to 8 {
        affine.for %j = 0 to 2048 {
          affine.store %zero, %Y_b[%i, %j] : memref<8x2048xf32>
          affine.for %k = 0 to 11008 {
            %x = affine.load %H_done_b[%i, %k] : memref<8x11008xf32>
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
    memref.dealloc %G : memref<8x11008xf32>
    memref.dealloc %U : memref<8x11008xf32>
    memref.dealloc %H : memref<8x11008xf32>
    return
  }
}
