module {
  func.func @streams(%A: memref<4xf32> {orbit.role = "input", orbit.name = "A"}, %B: memref<4xf32> {orbit.role = "input", orbit.name = "B"}, %Y: memref<4xf32> {orbit.role = "output", orbit.name = "Y"}, %Z: memref<4xf32> {orbit.role = "output", orbit.name = "Z"}, %W: memref<4xf32> {orbit.role = "output", orbit.name = "W"}) attributes {orbit.noalias} {
    %done:3 = taskflow.task @grouped will_reads(%A, %B : memref<4xf32>, memref<4xf32>) will_writes(%Y, %Z, %W : memref<4xf32>, memref<4xf32>, memref<4xf32>)
      [original_read_memrefs(%A, %B : memref<4xf32>, memref<4xf32>), original_write_memrefs(%Y, %Z, %W : memref<4xf32>, memref<4xf32>, memref<4xf32>)]
      : (memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>, memref<4xf32>) -> (memref<4xf32>, memref<4xf32>, memref<4xf32>) {
    ^bb0(%A_b: memref<4xf32>, %B_b: memref<4xf32>, %Y_b: memref<4xf32>, %Z_b: memref<4xf32>, %W_b: memref<4xf32>):
      affine.for %i = 0 to 4 {
        %x0 = affine.load %A_b[%i] : memref<4xf32>
        %y0 = affine.load %B_b[%i] : memref<4xf32>
        %v0 = arith.addf %x0, %y0 : f32
        affine.store %v0, %Y_b[%i] : memref<4xf32>
        %x1 = affine.load %A_b[%i] : memref<4xf32>
        %y1 = affine.load %B_b[%i] : memref<4xf32>
        %v1 = arith.subf %x1, %y1 : f32
        affine.store %v1, %Z_b[%i] : memref<4xf32>
        %x2 = affine.load %A_b[%i] : memref<4xf32>
        %y2 = affine.load %B_b[%i] : memref<4xf32>
        %v2 = arith.mulf %x2, %y2 : f32
        affine.store %v2, %W_b[%i] : memref<4xf32>
      }
      taskflow.yield done_writes(%Y_b, %Z_b, %W_b : memref<4xf32>, memref<4xf32>, memref<4xf32>)
    }
    return
  }
}
