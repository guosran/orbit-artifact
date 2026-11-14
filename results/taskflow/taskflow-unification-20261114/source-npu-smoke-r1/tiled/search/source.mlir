module attributes {orbit.air_tile_sizes = array<i64: 32, 32, 1>} {
  func.func @pointwise(%arg0: memref<64x64xf32> {amoeba.noalias, orbit.name = "X", orbit.role = "input"}, %arg1: memref<64x64xf32> {amoeba.noalias, orbit.name = "Y", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %alloc = memref.alloc() {orbit.name = "T"} : memref<64x64xf32>
    %done_writes = taskflow.task @double.tile.0.0 will_reads(%arg0 : memref<64x64xf32>) will_writes(%alloc : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%alloc : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 0, 32>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "double", amoeba.tiling.part_index = 0 : i64} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c0_2 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %1 = taskflow.counter from %c0_2 to %c32 step %c1 : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c64 step %c1 : index
      "taskflow.hyperblock"(%1, %2) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %3 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
        %4 = arith.addf %3, %3 : f32
        memref.store %4, %arg3[%arg4, %arg5] : memref<64x64xf32>
        taskflow.hyperblock.yield
      }) : (index, index) -> ()
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_0 = taskflow.task @double.tile.0.1 will_reads(%arg0 : memref<64x64xf32>) will_writes(%alloc : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%alloc : memref<64x64xf32>)] {amoeba.tiling.axis = 0 : i64, amoeba.tiling.derived_range = array<i64: 32, 64>, amoeba.tiling.factor = 2 : i64, amoeba.tiling.original_range = array<i64: 0, 64>, amoeba.tiling.parent_task = "double", amoeba.tiling.part_index = 1 : i64} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %c32 = arith.constant 32 : index
      %c64_2 = arith.constant 64 : index
      %1 = taskflow.counter from %c32 to %c64_2 step %c1 : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c64 step %c1 : index
      "taskflow.hyperblock"(%1, %2) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %3 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
        %4 = arith.addf %3, %3 : f32
        memref.store %4, %arg3[%arg4, %arg5] : memref<64x64xf32>
        taskflow.hyperblock.yield
      }) : (index, index) -> ()
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %0 = taskflow.join states(%done_writes, %done_writes_0) base(%alloc) axis(0) region([0, 0], [64, 64]) : memref<64x64xf32>
    %done_writes_1 = taskflow.task @square will_reads(%0 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%alloc : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %1 = taskflow.counter from %c0 to %c64 step %c1 : index
      %2 = taskflow.counter parent(%1 : index) from %c0 to %c64 step %c1 : index
      "taskflow.hyperblock"(%1, %2) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %3 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
        %4 = arith.mulf %3, %3 : f32
        memref.store %4, %arg3[%arg4, %arg5] : memref<64x64xf32>
        taskflow.hyperblock.yield
      }) : (index, index) -> ()
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    return
  }
}

