module {
  func.func @activation(%G: memref<8x11008xf32> {orbit.role = "input", orbit.name = "G"}, %U: memref<8x11008xf32> {orbit.role = "input", orbit.name = "U"}, %H: memref<8x11008xf32> {orbit.role = "output", orbit.name = "H"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %stage_result = taskflow.task @swiglu will_reads(%G, %U : memref<8x11008xf32>, memref<8x11008xf32>) will_writes(%H : memref<8x11008xf32>) [original_read_memrefs(%G, %U : memref<8x11008xf32>, memref<8x11008xf32>), original_write_memrefs(%H : memref<8x11008xf32>)] : (memref<8x11008xf32>, memref<8x11008xf32>, memref<8x11008xf32>) -> memref<8x11008xf32> {
    ^bb0(%G_b: memref<8x11008xf32>, %U_b: memref<8x11008xf32>, %H_b: memref<8x11008xf32>):
      %one = arith.constant 1.0 : f32
      affine.for %i = 0 to 8 {
        affine.for %j = 0 to 11008 {
          %g = affine.load %G_b[%i, %j] : memref<8x11008xf32>
          %u = affine.load %U_b[%i, %j] : memref<8x11008xf32>
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
    return
  }
}
