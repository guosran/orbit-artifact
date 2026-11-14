module attributes {orbit.air_tile_sizes = array<i64: 32, 32, 1>} {
  func.func @pointwise(%arg0: memref<64x64xf32> {amoeba.noalias, orbit.name = "X", orbit.role = "input"}, %arg1: memref<64x64xf32> {amoeba.noalias, orbit.name = "Y", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %alloc = memref.alloc() {orbit.name = "T"} : memref<64x64xf32>
    %done_reads, %done_writes = taskflow.task @double.fuse.square will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c0_0 = arith.constant 0 : index
      %c1_1 = arith.constant 1 : index
      %c64_2 = arith.constant 64 : index
      affine.for %arg4 = 0 to 64 {
        affine.for %arg5 = 0 to 64 {
          %0 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %1 = arith.addf %0, %0 : f32
          %2 = arith.mulf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_reads(%arg2 : memref<64x64xf32>) done_writes(%arg3 : memref<64x64xf32>)
    }
    return
  }
}

