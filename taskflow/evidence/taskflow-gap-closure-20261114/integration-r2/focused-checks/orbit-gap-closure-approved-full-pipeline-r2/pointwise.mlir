// RUN: mlir-amoeba-opt %s '--tile-task=task-name=Pointwise axis=0 factor=3' --verify-each | FileCheck %s --check-prefix=THREE
// RUN: mlir-amoeba-opt %s '--tile-task=task-name=Pointwise axis=0 factor=5' --verify-each | FileCheck %s --check-prefix=FIVE
// RUN: mlir-amoeba-opt %s '--tile-task=task-name=Pointwise axis=0 factor=6' --verify-each | FileCheck %s --check-prefix=SIX
// RUN: mlir-amoeba-opt %s '--tile-task=task-name=Pointwise axis=0 factor=9' --verify-each | FileCheck %s --check-prefix=NINE
// RUN: mlir-amoeba-opt %s '--pass-pipeline=builtin.module(func.func(tile-task{task-name=Pointwise axis=0 factor=3},tile-task{task-name=Pointwise.tile.0.0 axis=1 factor=5}))' --verify-each | FileCheck %s --check-prefix=MULTI
// No power-of-two whitelist or accumulated factor cap: uneven intervals cover
// the exact domain, and a second action may tile a derived child on another axis.
module {
  func.func @pointwise(%input: memref<15x10xf32> {amoeba.noalias, orbit.role = "input"},
                       %output: memref<15x10xf32> {amoeba.noalias, orbit.role = "output"}) attributes {orbit.noalias} {
    %done = taskflow.task @Pointwise
        will_reads(%input : memref<15x10xf32>)
        will_writes(%output : memref<15x10xf32>)
        [original_read_memrefs(%input : memref<15x10xf32>),
         original_write_memrefs(%output : memref<15x10xf32>)]
        : (memref<15x10xf32>, memref<15x10xf32>) -> memref<15x10xf32> {
      ^bb0(%read: memref<15x10xf32>, %write: memref<15x10xf32>):
        %zero = arith.constant 0 : index
        %one = arith.constant 1 : index
        %fifteen = arith.constant 15 : index
        %ten = arith.constant 10 : index
        %m = taskflow.counter from %zero to %fifteen step %one : index
        %n = taskflow.counter parent(%m : index) from %zero to %ten step %one : index
        "taskflow.hyperblock"(%m, %n)
            <{operandSegmentSizes = array<i32: 2, 0>}> ({
          ^bb0(%i: index, %j: index):
            %value = memref.load %read[%i, %j] : memref<15x10xf32>
            %twice = arith.addf %value, %value : f32
            memref.store %twice, %write[%i, %j] : memref<15x10xf32>
            "taskflow.hyperblock.yield"() : () -> ()
        }) : (index, index) -> ()
        taskflow.yield done_writes(%write : memref<15x10xf32>)
    }
    func.return
  }
}
