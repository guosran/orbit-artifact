module {func.func @shared(%X: memref<1x8xf32> {orbit.role="input",orbit.name="X"},%Y: memref<1x8xf32> {orbit.role="output",orbit.name="Y"},%Z: memref<1x8xf32> {orbit.role="output",orbit.name="Z"}) attributes {orbit.noalias,llvm.emit_c_interface} {
 %da=taskflow.task @a will_reads(%X : memref<1x8xf32>) will_writes(%Y : memref<1x8xf32>) [original_read_memrefs(%X : memref<1x8xf32>),original_write_memrefs(%Y : memref<1x8xf32>)] : (memref<1x8xf32>,memref<1x8xf32>)->memref<1x8xf32> {
 ^bb0(%x: memref<1x8xf32>,%o: memref<1x8xf32>):
 affine.for %i=0 to 1 {affine.for %j=0 to 8 {%v=affine.load %x[%i,%j] : memref<1x8xf32>
 %c=arith.constant 1.0 : f32
 %r=arith.addf %v,%c : f32
 affine.store %r,%o[%i,%j] : memref<1x8xf32>}}
 taskflow.yield done_writes(%o : memref<1x8xf32>)
 }
 %db=taskflow.task @b will_reads(%X : memref<1x8xf32>) will_writes(%Z : memref<1x8xf32>) [original_read_memrefs(%X : memref<1x8xf32>),original_write_memrefs(%Z : memref<1x8xf32>)] : (memref<1x8xf32>,memref<1x8xf32>)->memref<1x8xf32> {
 ^bb0(%x: memref<1x8xf32>,%o: memref<1x8xf32>):
 affine.for %i=0 to 1 {affine.for %j=0 to 8 {%v=affine.load %x[%i,%j] : memref<1x8xf32>
 %c=arith.constant 2.0 : f32
 %r=arith.mulf %v,%c : f32
 affine.store %r,%o[%i,%j] : memref<1x8xf32>}}
 taskflow.yield done_writes(%o : memref<1x8xf32>)
 }
return
}}
