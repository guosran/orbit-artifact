module {
  func.func @pointwise(%arg0: memref<64x64xf32> {amoeba.noalias, orbit.role = "state"}) attributes {orbit.noalias} {
    %done_writes = taskflow.task @Pointwise will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg0 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg0 : memref<64x64xf32>)] {orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 2, 2>}} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg1: memref<64x64xf32>, %arg2: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_0 = arith.constant 64 : index
      affine.for %arg3 = 0 to 64 {
        affine.for %arg4 = 0 to 64 {
          %0 = memref.load %arg1[%arg3, %arg4] : memref<64x64xf32>
          %1 = arith.addf %0, %0 : f32
          memref.store %1, %arg2[%arg3, %arg4] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg2 : memref<64x64xf32>)
    }
    return
  }
}

