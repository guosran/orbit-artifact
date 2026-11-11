module {
 func.func @fork_join_17x64(%I: memref<17x64xf32> {orbit.role="input",orbit.name="I"},%R: memref<17x64xf32> {orbit.role="output",orbit.name="R"}) attributes {orbit.noalias,llvm.emit_c_interface} {
  %X=memref.alloc() {orbit.name="X"} : memref<17x64xf32>
  %Y=memref.alloc() {orbit.name="Y"} : memref<17x64xf32>
  %Z=memref.alloc() {orbit.name="Z"} : memref<17x64xf32>
  %done_X=taskflow.task @write_X will_reads(%I : memref<17x64xf32>) will_writes(%X : memref<17x64xf32>) [original_read_memrefs(%I : memref<17x64xf32>),original_write_memrefs(%X : memref<17x64xf32>)] : (memref<17x64xf32>,memref<17x64xf32>)->memref<17x64xf32> {
  ^bb0(%r0: memref<17x64xf32>,%dst: memref<17x64xf32>):
   affine.for %i=0 to 17 {
    affine.for %j=0 to 64 {
     %v0=affine.load %r0[%i,%j] : memref<17x64xf32>
     %c=arith.constant 1.000000 : f32
     %v=arith.addf %v0,%c : f32
     affine.store %v,%dst[%i,%j] : memref<17x64xf32>
    }
   }
   taskflow.yield done_writes(%dst : memref<17x64xf32>)
  }
  %done_Y=taskflow.task @write_Y will_reads(%done_X : memref<17x64xf32>) will_writes(%Y : memref<17x64xf32>) [original_read_memrefs(%done_X : memref<17x64xf32>),original_write_memrefs(%Y : memref<17x64xf32>)] : (memref<17x64xf32>,memref<17x64xf32>)->memref<17x64xf32> {
  ^bb0(%r0: memref<17x64xf32>,%dst: memref<17x64xf32>):
   affine.for %i=0 to 17 {
    affine.for %j=0 to 64 {
     %v0=affine.load %r0[%i,%j] : memref<17x64xf32>
     %c=arith.constant 2.000000 : f32
     %v=arith.mulf %v0,%c : f32
     affine.store %v,%dst[%i,%j] : memref<17x64xf32>
    }
   }
   taskflow.yield done_writes(%dst : memref<17x64xf32>)
  }
  %done_Z=taskflow.task @write_Z will_reads(%done_X : memref<17x64xf32>) will_writes(%Z : memref<17x64xf32>) [original_read_memrefs(%done_X : memref<17x64xf32>),original_write_memrefs(%Z : memref<17x64xf32>)] : (memref<17x64xf32>,memref<17x64xf32>)->memref<17x64xf32> {
  ^bb0(%r0: memref<17x64xf32>,%dst: memref<17x64xf32>):
   affine.for %i=0 to 17 {
    affine.for %j=0 to 64 {
     %v0=affine.load %r0[%i,%j] : memref<17x64xf32>
     %c=arith.constant 1.000000 : f32
     %v=arith.subf %v0,%c : f32
     affine.store %v,%dst[%i,%j] : memref<17x64xf32>
    }
   }
   taskflow.yield done_writes(%dst : memref<17x64xf32>)
  }
  %done_R=taskflow.task @write_R will_reads(%done_Y,%done_Z : memref<17x64xf32>,memref<17x64xf32>) will_writes(%R : memref<17x64xf32>) [original_read_memrefs(%done_Y,%done_Z : memref<17x64xf32>,memref<17x64xf32>),original_write_memrefs(%R : memref<17x64xf32>)] : (memref<17x64xf32>,memref<17x64xf32>,memref<17x64xf32>)->memref<17x64xf32> {
  ^bb0(%r0: memref<17x64xf32>,%r1: memref<17x64xf32>,%dst: memref<17x64xf32>):
   affine.for %i=0 to 17 {
    affine.for %j=0 to 64 {
     %v0=affine.load %r0[%i,%j] : memref<17x64xf32>
     %v1=affine.load %r1[%i,%j] : memref<17x64xf32>
     %v=arith.addf %v0,%v1 : f32
     affine.store %v,%dst[%i,%j] : memref<17x64xf32>
    }
   }
   taskflow.yield done_writes(%dst : memref<17x64xf32>)
  }
  memref.dealloc %X : memref<17x64xf32>
  memref.dealloc %Y : memref<17x64xf32>
  memref.dealloc %Z : memref<17x64xf32>
  return
 }
}
