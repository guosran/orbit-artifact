; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_98457656F79C5B6F.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [16 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [16 x float]

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
  %2 = load float, ptr @__aiecc_canon_0, align 4
  %3 = fmul float %2, 5.000000e-01
  store float %3, ptr @__aiecc_canon_1, align 4
  %4 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4), align 4
  %5 = fmul float %4, 5.000000e-01
  store float %5, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 4), align 4
  %6 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 8), align 4
  %7 = fmul float %6, 5.000000e-01
  store float %7, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 8), align 4
  %8 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 12), align 4
  %9 = fmul float %8, 5.000000e-01
  store float %9, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 12), align 4
  %10 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 16), align 4
  %11 = fmul float %10, 5.000000e-01
  store float %11, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 16), align 4
  %12 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 20), align 4
  %13 = fmul float %12, 5.000000e-01
  store float %13, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 20), align 4
  %14 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 24), align 4
  %15 = fmul float %14, 5.000000e-01
  store float %15, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 24), align 4
  %16 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 28), align 4
  %17 = fmul float %16, 5.000000e-01
  store float %17, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 28), align 4
  %18 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 32), align 4
  %19 = fmul float %18, 5.000000e-01
  store float %19, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 32), align 4
  %20 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 36), align 4
  %21 = fmul float %20, 5.000000e-01
  store float %21, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 36), align 4
  %22 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 40), align 4
  %23 = fmul float %22, 5.000000e-01
  store float %23, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 40), align 4
  %24 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 44), align 4
  %25 = fmul float %24, 5.000000e-01
  store float %25, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 44), align 4
  %26 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 48), align 4
  %27 = fmul float %26, 5.000000e-01
  store float %27, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 48), align 4
  %28 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 52), align 4
  %29 = fmul float %28, 5.000000e-01
  store float %29, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 52), align 4
  %30 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 56), align 4
  %31 = fmul float %30, 5.000000e-01
  store float %31, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 56), align 4
  %32 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 60), align 4
  %33 = fmul float %32, 5.000000e-01
  store float %33, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 60), align 4
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
