module {
  func.func @pointwise(%state: memref<64x64xf32> {amoeba.noalias, orbit.role="state"}) attributes {orbit.noalias} {
    %done = taskflow.task @Pointwise
        will_reads(%state : memref<64x64xf32>)
        will_writes(%state : memref<64x64xf32>)
        [original_read_memrefs(%state : memref<64x64xf32>),
         original_write_memrefs(%state : memref<64x64xf32>)]
        {orbit.placement={resource="",memory="",implementation="scalar",count=1:i64,shape=array<i64:2,2>}}
        : (memref<64x64xf32>, memref<64x64xf32>) -> memref<64x64xf32> {
      ^bb0(%read: memref<64x64xf32>, %write: memref<64x64xf32>):
        %zero = arith.constant 0 : index
        %one = arith.constant 1 : index
        %fifteen = arith.constant 64 : index
        %ten = arith.constant 64 : index
        %m = taskflow.counter from %zero to %fifteen step %one : index
        %n = taskflow.counter parent(%m : index) from %zero to %ten step %one : index
        "taskflow.hyperblock"(%m, %n)
            <{operandSegmentSizes = array<i32: 2, 0>}> ({
          ^bb0(%i: index, %j: index):
            %value = memref.load %read[%i, %j] : memref<64x64xf32>
            %twice = arith.addf %value, %value : f32
            memref.store %twice, %write[%i, %j] : memref<64x64xf32>
            "taskflow.hyperblock.yield"() : () -> ()
        }) : (index, index) -> ()
        taskflow.yield done_writes(%write : memref<64x64xf32>)
    }
    func.return
  }
}
