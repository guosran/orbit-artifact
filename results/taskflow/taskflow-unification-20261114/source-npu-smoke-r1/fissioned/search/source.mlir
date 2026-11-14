module attributes {orbit.air_tile_sizes = array<i64: 32, 32, 1>} {
  func.func @pointwise(%arg0: memref<64x64xf32> {amoeba.noalias, orbit.name = "X", orbit.role = "input"}, %arg1: memref<64x64xf32> {amoeba.noalias, orbit.name = "Y", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %alloc = memref.alloc() {orbit.name = "T"} : memref<64x64xf32>
    %alloc_0 = memref.alloc() : memref<64x64xf32>
    %done_writes = taskflow.task @double.split.0 will_reads(%arg0 : memref<64x64xf32>) will_writes(%alloc_0 : memref<64x64xf32>) [original_read_memrefs(%arg0 : memref<64x64xf32>), original_write_memrefs(%alloc_0 : memref<64x64xf32>)] {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "double", amoeba.fission.part_index = 0 : i64} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %0 = taskflow.counter from %c0 to %c64 step %c1 : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c64 step %c1 : index
      "taskflow.hyperblock"(%0, %1) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %2 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
        %3 = arith.addf %2, %2 : f32
        memref.store %3, %arg3[%arg4, %arg5] : memref<64x64xf32>
        taskflow.hyperblock.yield
      }) : (index, index) -> ()
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_1 = taskflow.task @double.split.1 will_reads(%done_writes : memref<64x64xf32>) will_writes(%alloc : memref<64x64xf32>) [original_read_memrefs(%alloc_0 : memref<64x64xf32>), original_write_memrefs(%alloc : memref<64x64xf32>)] {amoeba.fission.left_nodes = array<i64: 0, 1>, amoeba.fission.parent_task = "double", amoeba.fission.part_index = 1 : i64} : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %0 = taskflow.counter from %c0 to %c64 step %c1 : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c64 step %c1 : index
      "taskflow.hyperblock"(%0, %1) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %2 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
        memref.store %2, %arg3[%arg4, %arg5] : memref<64x64xf32>
        taskflow.hyperblock.yield
      }) : (index, index) -> ()
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    %done_writes_2 = taskflow.task @square will_reads(%done_writes_1 : memref<64x64xf32>) will_writes(%arg1 : memref<64x64xf32>) [original_read_memrefs(%alloc : memref<64x64xf32>), original_write_memrefs(%arg1 : memref<64x64xf32>)] : (memref<64x64xf32>, memref<64x64xf32>) -> (memref<64x64xf32>) {
    ^bb0(%arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c64 = arith.constant 64 : index
      %0 = taskflow.counter from %c0 to %c64 step %c1 : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c64 step %c1 : index
      "taskflow.hyperblock"(%0, %1) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %2 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
        %3 = arith.mulf %2, %2 : f32
        memref.store %3, %arg3[%arg4, %arg5] : memref<64x64xf32>
        taskflow.hyperblock.yield
      }) : (index, index) -> ()
      taskflow.yield done_writes(%arg3 : memref<64x64xf32>)
    }
    return
  }
}

