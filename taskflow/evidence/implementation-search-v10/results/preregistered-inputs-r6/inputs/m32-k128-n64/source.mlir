module {
  func.func @gemm_scale(%A: memref<32x128xf32> {orbit.role = "input", orbit.name = "A"}, %B: memref<128x64xf32> {orbit.role = "input", orbit.name = "B"}, %Y: memref<32x64xf32> {orbit.role = "output", orbit.name = "Y"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %C = memref.alloc() {orbit.name = "intermediate"} : memref<32x64xf32>
    %C_done = taskflow.task @gemm will_reads(%A, %B : memref<32x128xf32>, memref<128x64xf32>) will_writes(%C : memref<32x64xf32>) [original_read_memrefs(%A, %B : memref<32x128xf32>, memref<128x64xf32>), original_write_memrefs(%C : memref<32x64xf32>)] : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>) -> memref<32x64xf32> {
    ^bb0(%A_b: memref<32x128xf32>, %B_b: memref<128x64xf32>, %C_b: memref<32x64xf32>):
      %zero = arith.constant 0.0 : f32
      affine.for %i = 0 to 32 {
        affine.for %j = 0 to 64 {
          affine.store %zero, %C_b[%i, %j] : memref<32x64xf32>
          affine.for %k = 0 to 128 {
            %x = affine.load %A_b[%i, %k] : memref<32x128xf32>
            %w = affine.load %B_b[%k, %j] : memref<128x64xf32>
            %old = affine.load %C_b[%i, %j] : memref<32x64xf32>
            %p = arith.mulf %x, %w : f32
            %sum = arith.addf %old, %p : f32
            affine.store %sum, %C_b[%i, %j] : memref<32x64xf32>
          }
        }
      }
      taskflow.yield done_writes(%C_b : memref<32x64xf32>)
    }
    %Y_done = taskflow.task @scale will_reads(%C_done : memref<32x64xf32>) will_writes(%Y : memref<32x64xf32>) [original_read_memrefs(%C_done : memref<32x64xf32>), original_write_memrefs(%Y : memref<32x64xf32>)] : (memref<32x64xf32>, memref<32x64xf32>) -> memref<32x64xf32> {
    ^bb0(%tmp: memref<32x64xf32>, %out: memref<32x64xf32>):
      %factor = arith.constant 0.5 : f32
      affine.for %i = 0 to 32 {
        affine.for %j = 0 to 64 {
          %x = affine.load %tmp[%i, %j] : memref<32x64xf32>
          %y = arith.mulf %x, %factor : f32
          affine.store %y, %out[%i, %j] : memref<32x64xf32>
        }
      }
      taskflow.yield done_writes(%out : memref<32x64xf32>)
    }
    memref.dealloc %C : memref<32x64xf32>
    return
  }
}
