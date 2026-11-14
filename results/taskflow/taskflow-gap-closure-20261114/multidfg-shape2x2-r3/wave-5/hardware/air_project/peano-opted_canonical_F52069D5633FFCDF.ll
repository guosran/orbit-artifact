; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/taskflow-gap-closure-20261114/multidfg-shape2x2-r3/wave-5/hardware/air_project/canonical_F52069D5633FFCDF.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [2048 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [1024 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %1, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.memcpy.p0.p0.i20(ptr noundef nonnull align 4 dereferenceable(4096) @__aiecc_canon_1, ptr noundef nonnull align 4 dereferenceable(4096) getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 4096, i1 false)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i20(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i20, i1 immarg) #2

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
