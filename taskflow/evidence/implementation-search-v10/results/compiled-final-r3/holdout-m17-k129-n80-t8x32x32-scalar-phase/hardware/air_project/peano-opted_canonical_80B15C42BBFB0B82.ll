; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_80B15C42BBFB0B82.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [128 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [128 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %101, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %1, %.preheader
  %2 = phi i32 [ 8, %1 ], [ %100, %.preheader ]
  %3 = shl nuw nsw i32 %2, 4
  %4 = add nuw nsw i32 %3, 1048448
  %5 = trunc i32 %4 to i20
  %6 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %5
  %7 = load float, ptr %6, align 4
  %8 = fmul float %7, 5.000000e-01
  %9 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %5
  store float %8, ptr %9, align 4
  %10 = add nuw nsw i32 %3, 1048449
  %11 = trunc i32 %10 to i20
  %12 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %11
  %13 = load float, ptr %12, align 4
  %14 = fmul float %13, 5.000000e-01
  %15 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %11
  store float %14, ptr %15, align 4
  %16 = add nuw nsw i32 %3, 1048450
  %17 = trunc i32 %16 to i20
  %18 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %17
  %19 = load float, ptr %18, align 4
  %20 = fmul float %19, 5.000000e-01
  %21 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %17
  store float %20, ptr %21, align 4
  %22 = add nuw nsw i32 %3, 1048451
  %23 = trunc i32 %22 to i20
  %24 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %23
  %25 = load float, ptr %24, align 4
  %26 = fmul float %25, 5.000000e-01
  %27 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %23
  store float %26, ptr %27, align 4
  %28 = add nuw nsw i32 %3, 1048452
  %29 = trunc i32 %28 to i20
  %30 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %29
  %31 = load float, ptr %30, align 4
  %32 = fmul float %31, 5.000000e-01
  %33 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %29
  store float %32, ptr %33, align 4
  %34 = add nuw nsw i32 %3, 1048453
  %35 = trunc i32 %34 to i20
  %36 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %35
  %37 = load float, ptr %36, align 4
  %38 = fmul float %37, 5.000000e-01
  %39 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %35
  store float %38, ptr %39, align 4
  %40 = add nuw nsw i32 %3, 1048454
  %41 = trunc i32 %40 to i20
  %42 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %41
  %43 = load float, ptr %42, align 4
  %44 = fmul float %43, 5.000000e-01
  %45 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %41
  store float %44, ptr %45, align 4
  %46 = add nuw nsw i32 %3, 1048455
  %47 = trunc i32 %46 to i20
  %48 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %47
  %49 = load float, ptr %48, align 4
  %50 = fmul float %49, 5.000000e-01
  %51 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %47
  store float %50, ptr %51, align 4
  %52 = add nuw nsw i32 %3, 1048456
  %53 = trunc i32 %52 to i20
  %54 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %53
  %55 = load float, ptr %54, align 4
  %56 = fmul float %55, 5.000000e-01
  %57 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %53
  store float %56, ptr %57, align 4
  %58 = add nuw nsw i32 %3, 1048457
  %59 = trunc i32 %58 to i20
  %60 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %59
  %61 = load float, ptr %60, align 4
  %62 = fmul float %61, 5.000000e-01
  %63 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %59
  store float %62, ptr %63, align 4
  %64 = add nuw nsw i32 %3, 1048458
  %65 = trunc i32 %64 to i20
  %66 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %65
  %67 = load float, ptr %66, align 4
  %68 = fmul float %67, 5.000000e-01
  %69 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %65
  store float %68, ptr %69, align 4
  %70 = add nuw nsw i32 %3, 1048459
  %71 = trunc i32 %70 to i20
  %72 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %71
  %73 = load float, ptr %72, align 4
  %74 = fmul float %73, 5.000000e-01
  %75 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %71
  store float %74, ptr %75, align 4
  %76 = add nuw nsw i32 %3, 1048460
  %77 = trunc i32 %76 to i20
  %78 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %77
  %79 = load float, ptr %78, align 4
  %80 = fmul float %79, 5.000000e-01
  %81 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %77
  store float %80, ptr %81, align 4
  %82 = add nuw nsw i32 %3, 1048461
  %83 = trunc i32 %82 to i20
  %84 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %83
  %85 = load float, ptr %84, align 4
  %86 = fmul float %85, 5.000000e-01
  %87 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %83
  store float %86, ptr %87, align 4
  %88 = add nuw nsw i32 %3, 1048462
  %89 = trunc i32 %88 to i20
  %90 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %89
  %91 = load float, ptr %90, align 4
  %92 = fmul float %91, 5.000000e-01
  %93 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %89
  store float %92, ptr %93, align 4
  %94 = add nuw nsw i32 %3, 1048463
  %95 = trunc i32 %94 to i20
  %96 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %95
  %97 = load float, ptr %96, align 4
  %98 = fmul float %97, 5.000000e-01
  %99 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %95
  store float %98, ptr %99, align 4
  %100 = add nuw nsw i32 %2, 1
  %exitcond.not = icmp eq i32 %100, 16
  br i1 %exitcond.not, label %101, label %.preheader, !llvm.loop !1

101:                                              ; preds = %.preheader
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
