module {
  func.func @pointwise(%arg0: memref<64x64xf32> {amoeba.noalias, orbit.role = "input"}, %arg1: memref<64x64xf32> {amoeba.noalias, orbit.role = "output"}) attributes {orbit.noalias} {
    %done_writes = taskflow.task @Pointwise.replica.0.0 will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 0, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 0 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 1, 2>}, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_1 = arith.constant 64 : index
      %c0_2 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      affine.for %arg4 = 0 to 32 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_0 = taskflow.task @Pointwise.replica.0.1 will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 32, 64>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "", resource = "", shape = array<i64: 1, 2>}, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_1 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c64_2 = arith.constant 64 : index
      affine.for %arg4 = 32 to 64 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %0 = taskflow.join states(%done_writes, %done_writes_0) base(%arg1) axis(0) region([0, 0], [64, 64]) : memref<64x64xf32>
    return
  }
}

