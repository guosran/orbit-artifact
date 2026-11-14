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
      %0 = taskflow.counter from %c0 to %c64 step %c1 : index
      %1 = taskflow.counter parent(%0 : index) from %c0 to %c64 step %c1 : index
      "taskflow.hyperblock"(%0, %1) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%arg4: index, %arg5: index):
        %2 = memref.load %arg2[%arg4, %arg5] : memref<64x64xf32>
        %3 = arith.addf %2, %2 : f32
        %4 = arith.mulf %3, %3 : f32
        memref.store %4, %arg3[%arg4, %arg5] : memref<64x64xf32>
        taskflow.hyperblock.yield
      }) : (index, index) -> ()
      taskflow.yield done_reads(%arg2 : memref<64x64xf32>) done_writes(%arg3 : memref<64x64xf32>)
    }
    return
  }
}

