module {
  func.func @pointwise(%arg0: memref<15x10xf32> {amoeba.noalias, orbit.role = "input"}, %arg1: memref<15x10xf32> {amoeba.noalias, orbit.role = "output"}) attributes {orbit.noalias} {
    %done_writes = taskflow.task @Pointwise.tile.0.0 will_reads(%arg0 : memref<15x10xf32>) will_writes(%arg1 : memref<15x10xf32>) [original_read_memrefs(%arg0 : memref<15x10xf32>), original_write_memrefs(%arg1 : memref<15x10xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 0, 5>, amoeba.tiling.factor = 3 : i64, amoeba.tiling.original_range = array<i64: 0, 15>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 0 : i64} : (memref<15x10xf32>, memref<15x10xf32>) -> (memref<15x10xf32>) {
    ^bb0(%arg2: memref<15x10xf32>, %arg3: memref<15x10xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c15 = arith.constant 15 : index
      %c10 = arith.constant 10 : index
      %c0_2 = arith.constant 0 : index
      %c5 = arith.constant 5 : index
      affine.for %arg4 = 0 to 5 {
        affine.for %arg5 = 0 to 10 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<15x10xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<15x10xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<15x10xf32>)
    }
    %done_writes_0 = taskflow.task @Pointwise.tile.0.1 will_reads(%arg0 : memref<15x10xf32>) will_writes(%arg1 : memref<15x10xf32>) [original_read_memrefs(%arg0 : memref<15x10xf32>), original_write_memrefs(%arg1 : memref<15x10xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 5, 10>, amoeba.tiling.factor = 3 : i64, amoeba.tiling.original_range = array<i64: 0, 15>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 1 : i64} : (memref<15x10xf32>, memref<15x10xf32>) -> (memref<15x10xf32>) {
    ^bb0(%arg2: memref<15x10xf32>, %arg3: memref<15x10xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c15 = arith.constant 15 : index
      %c10 = arith.constant 10 : index
      %c5 = arith.constant 5 : index
      %c10_2 = arith.constant 10 : index
      affine.for %arg4 = 5 to 10 {
        affine.for %arg5 = 0 to 10 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<15x10xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<15x10xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<15x10xf32>)
    }
    %done_writes_1 = taskflow.task @Pointwise.tile.0.2 will_reads(%arg0 : memref<15x10xf32>) will_writes(%arg1 : memref<15x10xf32>) [original_read_memrefs(%arg0 : memref<15x10xf32>), original_write_memrefs(%arg1 : memref<15x10xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 10, 15>, amoeba.tiling.factor = 3 : i64, amoeba.tiling.original_range = array<i64: 0, 15>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 2 : i64} : (memref<15x10xf32>, memref<15x10xf32>) -> (memref<15x10xf32>) {
    ^bb0(%arg2: memref<15x10xf32>, %arg3: memref<15x10xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c15 = arith.constant 15 : index
      %c10 = arith.constant 10 : index
      %c10_2 = arith.constant 10 : index
      %c15_3 = arith.constant 15 : index
      affine.for %arg4 = 10 to 15 {
        affine.for %arg5 = 0 to 10 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<15x10xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<15x10xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<15x10xf32>)
    }
    %0 = taskflow.join states(%done_writes, %done_writes_0, %done_writes_1) base(%arg1) axis(0) region([0, 0], [15, 10]) : memref<15x10xf32>
    return
  }
}

