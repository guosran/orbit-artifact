// Source-owned two-stage pointwise graph: Y = (X + X) * (X + X).
module attributes {orbit.air_tile_sizes = array<i64: 32, 32, 1>} {
  func.func @pointwise(%X: memref<64x64xf32> {amoeba.noalias, orbit.role = "input", orbit.name = "X"},
                       %Y: memref<64x64xf32> {amoeba.noalias, orbit.role = "output", orbit.name = "Y"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %tmp = memref.alloc() {orbit.name = "T"} : memref<64x64xf32>
    %double_done = taskflow.task @double
      will_reads(%X : memref<64x64xf32>)
      will_writes(%tmp : memref<64x64xf32>)
      [original_read_memrefs(%X : memref<64x64xf32>), original_write_memrefs(%tmp : memref<64x64xf32>)]
      : (memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32> {
    ^bb0(%read: memref<64x64xf32>, %write: memref<64x64xf32>):
      %zero = arith.constant 0 : index
      %one = arith.constant 1 : index
      %bound = arith.constant 64 : index
      %m = taskflow.counter from %zero to %bound step %one : index
      %n = taskflow.counter parent(%m : index) from %zero to %bound step %one : index
      "taskflow.hyperblock"(%m, %n) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%i: index, %j: index):
        %v = memref.load %read[%i, %j] : memref<64x64xf32>
        %r = arith.addf %v, %v : f32
        memref.store %r, %write[%i, %j] : memref<64x64xf32>
        "taskflow.hyperblock.yield"() : () -> ()
      }) : (index, index) -> ()
      taskflow.yield done_writes(%write : memref<64x64xf32>)
    }
    %square_done = taskflow.task @square
      will_reads(%double_done : memref<64x64xf32>)
      will_writes(%Y : memref<64x64xf32>)
      [original_read_memrefs(%tmp : memref<64x64xf32>), original_write_memrefs(%Y : memref<64x64xf32>)]
      : (memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32> {
    ^bb0(%read: memref<64x64xf32>, %write: memref<64x64xf32>):
      %zero = arith.constant 0 : index
      %one = arith.constant 1 : index
      %bound = arith.constant 64 : index
      %m = taskflow.counter from %zero to %bound step %one : index
      %n = taskflow.counter parent(%m : index) from %zero to %bound step %one : index
      "taskflow.hyperblock"(%m, %n) <{operandSegmentSizes = array<i32: 2, 0>}> ({
      ^bb0(%i: index, %j: index):
        %v = memref.load %read[%i, %j] : memref<64x64xf32>
        %r = arith.mulf %v, %v : f32
        memref.store %r, %write[%i, %j] : memref<64x64xf32>
        "taskflow.hyperblock.yield"() : () -> ()
      }) : (index, index) -> ()
      taskflow.yield done_writes(%write : memref<64x64xf32>)
    }
    return
  }
}
