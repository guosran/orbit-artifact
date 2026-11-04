; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_A2359EE81ADE3A3A.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [32 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %.loopexit

.loopexit:                                        ; preds = %.loopexit, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  %1 = load float, ptr @__aiecc_canon_1, align 4
  %2 = fmul float %1, 5.000000e-01
  store float %2, ptr @__aiecc_canon_0, align 4
  %3 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 4), align 4
  %4 = fmul float %3, 5.000000e-01
  store float %4, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4), align 4
  %5 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 8), align 4
  %6 = fmul float %5, 5.000000e-01
  store float %6, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 8), align 4
  %7 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 12), align 4
  %8 = fmul float %7, 5.000000e-01
  store float %8, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 12), align 4
  %9 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 16), align 4
  %10 = fmul float %9, 5.000000e-01
  store float %10, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 16), align 4
  %11 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 20), align 4
  %12 = fmul float %11, 5.000000e-01
  store float %12, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 20), align 4
  %13 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 24), align 4
  %14 = fmul float %13, 5.000000e-01
  store float %14, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 24), align 4
  %15 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 28), align 4
  %16 = fmul float %15, 5.000000e-01
  store float %16, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 28), align 4
  %17 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 32), align 4
  %18 = fmul float %17, 5.000000e-01
  store float %18, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 32), align 4
  %19 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 36), align 4
  %20 = fmul float %19, 5.000000e-01
  store float %20, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 36), align 4
  %21 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 40), align 4
  %22 = fmul float %21, 5.000000e-01
  store float %22, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 40), align 4
  %23 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 44), align 4
  %24 = fmul float %23, 5.000000e-01
  store float %24, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 44), align 4
  %25 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 48), align 4
  %26 = fmul float %25, 5.000000e-01
  store float %26, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 48), align 4
  %27 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 52), align 4
  %28 = fmul float %27, 5.000000e-01
  store float %28, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 52), align 4
  %29 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 56), align 4
  %30 = fmul float %29, 5.000000e-01
  store float %30, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 56), align 4
  %31 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 60), align 4
  %32 = fmul float %31, 5.000000e-01
  store float %32, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 60), align 4
  %33 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 64), align 4
  %34 = fmul float %33, 5.000000e-01
  store float %34, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 64), align 4
  %35 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 68), align 4
  %36 = fmul float %35, 5.000000e-01
  store float %36, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 68), align 4
  %37 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 72), align 4
  %38 = fmul float %37, 5.000000e-01
  store float %38, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 72), align 4
  %39 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 76), align 4
  %40 = fmul float %39, 5.000000e-01
  store float %40, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 76), align 4
  %41 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 80), align 4
  %42 = fmul float %41, 5.000000e-01
  store float %42, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 80), align 4
  %43 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 84), align 4
  %44 = fmul float %43, 5.000000e-01
  store float %44, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 84), align 4
  %45 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 88), align 4
  %46 = fmul float %45, 5.000000e-01
  store float %46, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 88), align 4
  %47 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 92), align 4
  %48 = fmul float %47, 5.000000e-01
  store float %48, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 92), align 4
  %49 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 96), align 4
  %50 = fmul float %49, 5.000000e-01
  store float %50, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 96), align 4
  %51 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 100), align 4
  %52 = fmul float %51, 5.000000e-01
  store float %52, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 100), align 4
  %53 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 104), align 4
  %54 = fmul float %53, 5.000000e-01
  store float %54, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 104), align 4
  %55 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 108), align 4
  %56 = fmul float %55, 5.000000e-01
  store float %56, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 108), align 4
  %57 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 112), align 4
  %58 = fmul float %57, 5.000000e-01
  store float %58, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 112), align 4
  %59 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 116), align 4
  %60 = fmul float %59, 5.000000e-01
  store float %60, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 116), align 4
  %61 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 120), align 4
  %62 = fmul float %61, 5.000000e-01
  store float %62, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 120), align 4
  %63 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 124), align 4
  %64 = fmul float %63, 5.000000e-01
  store float %64, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 124), align 4
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %.loopexit, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
