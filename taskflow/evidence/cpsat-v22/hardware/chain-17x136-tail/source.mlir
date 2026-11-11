module {
 func.func @chain_17x136_tail(%I: memref<17x136xf32> {orbit.role="input",orbit.name="I"},%R: memref<17x136xf32> {orbit.role="output",orbit.name="R"}) attributes {orbit.noalias,llvm.emit_c_interface} {
  %T=memref.alloc() {orbit.name="T"} : memref<17x136xf32>
  %done_T=taskflow.task @write_T will_reads(%I : memref<17x136xf32>) will_writes(%T : memref<17x136xf32>) [original_read_memrefs(%I : memref<17x136xf32>),original_write_memrefs(%T : memref<17x136xf32>)] : (memref<17x136xf32>,memref<17x136xf32>)->memref<17x136xf32> {
  ^bb0(%r0: memref<17x136xf32>,%dst: memref<17x136xf32>):
   affine.for %i=0 to 17 {
    affine.for %j=0 to 136 {
     %v0=affine.load %r0[%i,%j] : memref<17x136xf32>
     %c=arith.constant 1.000000 : f32
     %v=arith.addf %v0,%c : f32
     affine.store %v,%dst[%i,%j] : memref<17x136xf32>
    }
   }
   taskflow.yield done_writes(%dst : memref<17x136xf32>)
  }
  %done_R=taskflow.task @write_R will_reads(%done_T : memref<17x136xf32>) will_writes(%R : memref<17x136xf32>) [original_read_memrefs(%done_T : memref<17x136xf32>),original_write_memrefs(%R : memref<17x136xf32>)] : (memref<17x136xf32>,memref<17x136xf32>)->memref<17x136xf32> {
  ^bb0(%r0: memref<17x136xf32>,%dst: memref<17x136xf32>):
   affine.for %i=0 to 17 {
    affine.for %j=0 to 136 {
     %v0=affine.load %r0[%i,%j] : memref<17x136xf32>
     %c=arith.constant 2.000000 : f32
     %v=arith.mulf %v0,%c : f32
     affine.store %v,%dst[%i,%j] : memref<17x136xf32>
    }
   }
   taskflow.yield done_writes(%dst : memref<17x136xf32>)
  }
  memref.dealloc %T : memref<17x136xf32>
  return
 }
}
