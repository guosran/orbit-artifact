module {
  func.func @pointwise(%arg0: memref<64x64xf32> {amoeba.noalias, orbit.role = "input"}, %arg1: memref<64x64xf32> {amoeba.noalias, orbit.role = "output"}) attributes {orbit.noalias} {
    %alloc = memref.alloc() : memref<11x64xf32>
    %done_reads, %done_writes = taskflow.task @Pointwise.replica.0.0.split.0 will_reads(%arg0 : memref<64x64xf32>) will_writes(%alloc : memref<11x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%alloc : memref<11x64xf32>)] {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise.replica.0.0", amoeba.fission.part_index = 0 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.3", resource = "npu.tile.0.3", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<11x64xf32>) -> (memref<64x64xf32>, memref<11x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<11x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_7 = arith.constant 64 : index
      %c0_8 = arith.constant 0 : index
      %c11 = arith.constant 11 : index
      affine.for %arg4 = 0 to 11 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<11x64xf32>
        }
      }
      taskflow.yield done_reads(%arg2 : memref<64x64xf32>) done_writes(%arg3 : memref<11x64xf32>)
    }
    %done_reads_0, %done_writes_1 = taskflow.task @Pointwise.replica.0.0.split.1 will_reads(%done_writes : memref<11x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%alloc : memref<11x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "Pointwise.replica.0.0", amoeba.fission.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.3", resource = "npu.tile.0.3", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 0 : i64, orbit.replica.requires_independent_resources} : (memref<11x64xf32>, memref<64x64xf32>) -> (memref<11x64xf32>, memref<64x64xf32>) {
    ^bb0(%arg2: memref<11x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_7 = arith.constant 64 : index
      %c0_8 = arith.constant 0 : index
      %c11 = arith.constant 11 : index
      affine.for %arg4 = 0 to 11 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<11x64xf32>
          memref.store %1, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_reads(%arg2 : memref<11x64xf32>) done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_2 = taskflow.task @Pointwise.replica.0.1 will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 11, 22>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 1 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.1.3", resource = "npu.tile.1.3", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 1 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_7 = arith.constant 64 : index
      %c11 = arith.constant 11 : index
      %c22 = arith.constant 22 : index
      affine.for %arg4 = 11 to 22 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_3 = taskflow.task @Pointwise.replica.0.2 will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 22, 33>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 2 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.4", resource = "npu.tile.0.4", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 2 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_7 = arith.constant 64 : index
      %c22 = arith.constant 22 : index
      %c33 = arith.constant 33 : index
      affine.for %arg4 = 22 to 33 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_4 = taskflow.task @Pointwise.replica.0.3 will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 33, 44>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 3 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.1.4", resource = "npu.tile.1.4", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 3 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_7 = arith.constant 64 : index
      %c33 = arith.constant 33 : index
      %c44 = arith.constant 44 : index
      affine.for %arg4 = 33 to 44 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_5 = taskflow.task @Pointwise.replica.0.4 will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 44, 54>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 4 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.0.5", resource = "npu.tile.0.5", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 4 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_7 = arith.constant 64 : index
      %c44 = arith.constant 44 : index
      %c54 = arith.constant 54 : index
      affine.for %arg4 = 44 to 54 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_6 = taskflow.task @Pointwise.replica.0.5 will_reads(%arg0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 54, 64>, amoeba.tiling.factor = 6 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "Pointwise", amoeba.tiling.part_index = 5 : i64, orbit.placement = {count = 1 : i64, implementation = "scalar", memory = "npu.l1.1.5", resource = "npu.tile.1.5", shape = array<i64: 1, 1>}, orbit.replica.count = 6 : i64, orbit.replica.group = "pointwise/Pointwise", orbit.replica.instance = 5 : i64, orbit.replica.requires_independent_resources} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c64_7 = arith.constant 64 : index
      %c54 = arith.constant 54 : index
      %c64_8 = arith.constant 64 : index
      affine.for %arg4 = 54 to 64 {
        affine.for %arg5 = 0 to 64 {
          %1 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
          %2 = arith.addf %1, %1 : f32
          memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        }
      }
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %0 = taskflow.join states(%done_writes_1, %done_writes_2, %done_writes_3, %done_writes_4, %done_writes_5, %done_writes_6) base(%arg1) axis(0) region([0, 0], [64, 64]) : memref<64x64xf32>
    return
  }
}

