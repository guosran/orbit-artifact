module {
  func.func @pointwise(%arg0: memref<32x32xf32> {amoeba.noalias, orbit.role = "input"}, %arg1: memref<32x32xf32> {amoeba.noalias, orbit.role = "output"}) attributes {orbit.noalias} {
    %done_writes = taskflow.task @Pointwise.replica.0.0.replica.1.0 will_reads(%arg0 : memref<32x32xf32>) will_writes(%arg1 : memref<32x32xf32>) [original_read_memrefs(%arg0 : memref<32x32xf32>), original_write_memrefs(%arg1 : memref<32x32xf32>)] {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 0, 16>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.0", amoeba.tiling.part_index = 0 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.0"], orbit.replica.path = array<i64: 0, 0>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>) -> (memref<32x32xf32>) {
    ^bb0(%arg2: memref<32x32xf32>, %arg3: memref<32x32xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32 = arith.constant 32 : index
      %c32_3 = arith.constant 32 : index
      %c0_4 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %c0_5 = arith.constant 0 : index
      %c16_6 = arith.constant 16 : index
      affine.for %arg4 = 0 to 16 {
        affine.for %arg5 = 0 to 16 {
          %3 = memref.load %arg2[%arg4, %arg5] : memref<32x32xf32>
          %4 = arith.addf %3, %3 : f32
          memref.store %4, %arg3[%arg4, %arg5] : memref<32x32xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<32x32xf32>)
    }
    %done_writes_0 = taskflow.task @Pointwise.replica.0.0.replica.1.1 will_reads(%arg0 : memref<32x32xf32>) will_writes(%arg1 : memref<32x32xf32>) [original_read_memrefs(%arg0 : memref<32x32xf32>), original_write_memrefs(%arg1 : memref<32x32xf32>)] {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 16, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.0", amoeba.tiling.part_index = 1 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.0"], orbit.replica.path = array<i64: 0, 1>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>) -> (memref<32x32xf32>) {
    ^bb0(%arg2: memref<32x32xf32>, %arg3: memref<32x32xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32 = arith.constant 32 : index
      %c32_3 = arith.constant 32 : index
      %c0_4 = arith.constant 0 : index
      %c16 = arith.constant 16 : index
      %c16_5 = arith.constant 16 : index
      %c32_6 = arith.constant 32 : index
      affine.for %arg4 = 0 to 16 {
        affine.for %arg5 = 16 to 32 {
          %3 = memref.load %arg2[%arg4, %arg5] : memref<32x32xf32>
          %4 = arith.addf %3, %3 : f32
          memref.store %4, %arg3[%arg4, %arg5] : memref<32x32xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<32x32xf32>)
    }
    %0 = taskflow.join states(%done_writes, %done_writes_0) base(%arg1) axis(1) region([0, 0], [16, 32]) : memref<32x32xf32>
    %done_writes_1 = taskflow.task @Pointwise.replica.0.1.replica.1.0 will_reads(%arg0 : memref<32x32xf32>) will_writes(%arg1 : memref<32x32xf32>) [original_read_memrefs(%arg0 : memref<32x32xf32>), original_write_memrefs(%arg1 : memref<32x32xf32>)] {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 0, 16>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.1", amoeba.tiling.part_index = 0 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.1"], orbit.replica.path = array<i64: 1, 0>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>) -> (memref<32x32xf32>) {
    ^bb0(%arg2: memref<32x32xf32>, %arg3: memref<32x32xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32 = arith.constant 32 : index
      %c32_3 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c32_4 = arith.constant 32 : index
      %c0_5 = arith.constant 0 : index
      %c16_6 = arith.constant 16 : index
      affine.for %arg4 = 16 to 32 {
        affine.for %arg5 = 0 to 16 {
          %3 = memref.load %arg2[%arg4, %arg5] : memref<32x32xf32>
          %4 = arith.addf %3, %3 : f32
          memref.store %4, %arg3[%arg4, %arg5] : memref<32x32xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<32x32xf32>)
    }
    %done_writes_2 = taskflow.task @Pointwise.replica.0.1.replica.1.1 will_reads(%arg0 : memref<32x32xf32>) will_writes(%arg1 : memref<32x32xf32>) [original_read_memrefs(%arg0 : memref<32x32xf32>), original_write_memrefs(%arg1 : memref<32x32xf32>)] {amoeba.tiling.axis = 1 : i64, amoeba.tiling.derived_range = array<i64: 16, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 32>, amoeba.tiling.parent_task = "Pointwise.replica.0.1", amoeba.tiling.part_index = 1 : i64, orbit.replica.count = 2 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.level_counts = array<i64: 2, 2>, orbit.replica.owners = ["pointwise/Pointwise", "pointwise/Pointwise.replica.0.1"], orbit.replica.path = array<i64: 1, 1>, orbit.replica.requires_independent_resources} : (memref<32x32xf32>, memref<32x32xf32>) -> (memref<32x32xf32>) {
    ^bb0(%arg2: memref<32x32xf32>, %arg3: memref<32x32xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c32 = arith.constant 32 : index
      %c32_3 = arith.constant 32 : index
      %c16 = arith.constant 16 : index
      %c32_4 = arith.constant 32 : index
      %c16_5 = arith.constant 16 : index
      %c32_6 = arith.constant 32 : index
      affine.for %arg4 = 16 to 32 {
        affine.for %arg5 = 16 to 32 {
          %3 = memref.load %arg2[%arg4, %arg5] : memref<32x32xf32>
          %4 = arith.addf %3, %3 : f32
          memref.store %4, %arg3[%arg4, %arg5] : memref<32x32xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<32x32xf32>)
    }
    %1 = taskflow.join states(%done_writes_1, %done_writes_2) base(%arg1) axis(1) region([16, 0], [32, 32]) : memref<32x32xf32>
    %2 = taskflow.join states(%0, %1) base(%arg1) axis(0) region([0, 0], [32, 32]) : memref<32x32xf32>
    return
  }
}

