module {
  func.func @pointwise(%arg0: memref<64x64xf32> {amoeba.noalias, orbit.role = "input"}, %arg1: memref<64x64xf32> {amoeba.noalias, orbit.role = "output"}) attributes {orbit.noalias} {
    %alloc = memref.alloc() : memref<64x64xf32>
    %done_reads, %done_writes = taskflow.task @Pointwise.split.0 will_reads(%arg0 : memref<64x64xf32>) will_writes(%alloc : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%alloc : memref<64x64xf32>)] {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise", amoeba.fission.part_index = 0 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 2, 2>}} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_2 = arith.constant 64 : index
      affine.for %arg4 = 0 to 64 {
        affine.for %arg5 = 0 to 64 {
          %0 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %1 = arith.addf %0, %0 : f32
          memref.store %1, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_reads(%arg2 : memref<64x64xf32>) done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_reads_0, %done_writes_1 = taskflow.task @Pointwise.split.1 will_reads(%done_writes : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%alloc : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise", amoeba.fission.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 2, 2>}} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>, memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_2 = arith.constant 64 : index
      affine.for %arg4 = 0 to 64 {
        affine.for %arg5 = 0 to 64 {
          %0 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          memref.store %0, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_reads(%arg2 : memref<64x64xf32>) done_writes(%arg3 : memref<64x64xf32>)
    }
    return
  }
}

