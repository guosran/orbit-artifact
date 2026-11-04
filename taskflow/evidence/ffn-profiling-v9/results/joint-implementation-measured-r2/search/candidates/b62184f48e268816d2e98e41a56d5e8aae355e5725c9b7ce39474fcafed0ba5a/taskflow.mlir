module attributes {orbit.air_tile_sizes = array<i64: 8, 16, 32>, orbit.mapping = {data_organization = "retain-across-users", grouping = "readonly-panel-scope", panel_loop = 1 : i64, residency = "readonly-panel", reuse_loop = 0 : i64, storage = 1 : i64}} {
  func.func @gemm_scale(%arg0: memref<32x128xf32> {orbit.name = "A", orbit.role = "input"}, %arg1: memref<128x64xf32> {orbit.name = "B", orbit.role = "input"}, %arg2: memref<32x64xf32> {orbit.name = "Y", orbit.role = "output"}) attributes {llvm.emit_c_interface, orbit.noalias} {
    %alloc = memref.alloc() {orbit.name = "intermediate"} : memref<32x64xf32>
    %done_writes = taskflow.task @gemm.initialize will_reads(%arg0, %arg1 : memref<32x128xf32>, memref<128x64xf32>) will_writes(%alloc : memref<32x64xf32>) [original_read_memrefs(%arg0, %arg1 : memref<32x128xf32>, memref<128x64xf32>), original_write_memrefs(%alloc : memref<32x64xf32>)] : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>) -> (memref<32x64xf32>) {
    ^bb0(%arg3: memref<32x128xf32>, %arg4: memref<128x64xf32>, %arg5: memref<32x64xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg6 = 0 to 32 {
        affine.for %arg7 = 0 to 64 {
          affine.store %cst, %arg5[%arg6, %arg7] : memref<32x64xf32>
        }
      }
      taskflow.yield done_writes(%arg5 : memref<32x64xf32>)
    }
    %done_writes_0 = taskflow.task @gemm will_reads(%arg0, %arg1 : memref<32x128xf32>, memref<128x64xf32>) will_writes(%done_writes : memref<32x64xf32>) [original_read_memrefs(%arg0, %arg1 : memref<32x128xf32>, memref<128x64xf32>), original_write_memrefs(%alloc : memref<32x64xf32>)] {orbit.distributed_initialization} : (memref<32x128xf32>, memref<128x64xf32>, memref<32x64xf32>) -> (memref<32x64xf32>) {
    ^bb0(%arg3: memref<32x128xf32>, %arg4: memref<128x64xf32>, %arg5: memref<32x64xf32>):
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg6 = 0 to 32 {
        affine.for %arg7 = 0 to 64 {
          affine.for %arg8 = 0 to 128 {
            %0 = affine.load %arg3[%arg6, %arg8] : memref<32x128xf32>
            %1 = affine.load %arg4[%arg8, %arg7] : memref<128x64xf32>
            %2 = affine.load %arg5[%arg6, %arg7] : memref<32x64xf32>
            %3 = arith.mulf %0, %1 : f32
            %4 = arith.addf %2, %3 : f32
            affine.store %4, %arg5[%arg6, %arg7] : memref<32x64xf32>
          }
        }
      }
      taskflow.yield done_writes(%arg5 : memref<32x64xf32>)
    }
    %done_writes_1 = taskflow.task @scale will_reads(%done_writes_0 : memref<32x64xf32>) will_writes(%arg2 : memref<32x64xf32>) [original_read_memrefs(%done_writes_0 : memref<32x64xf32>), original_write_memrefs(%arg2 : memref<32x64xf32>)] : (memref<32x64xf32>, memref<32x64xf32>) -> (memref<32x64xf32>) {
    ^bb0(%arg3: memref<32x64xf32>, %arg4: memref<32x64xf32>):
      %cst = arith.constant 5.000000e-01 : f32
      affine.for %arg5 = 0 to 32 {
        affine.for %arg6 = 0 to 64 {
          %0 = affine.load %arg3[%arg5, %arg6] : memref<32x64xf32>
          %1 = arith.mulf %0, %cst : f32
          affine.store %1, %arg4[%arg5, %arg6] : memref<32x64xf32>
        }
      }
      taskflow.yield done_writes(%arg4 : memref<32x64xf32>)
    }
    memref.dealloc %alloc : memref<32x64xf32>
    return
  }
}
