; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_27C6392AE2FF26DA.ll'
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

1:                                                ; preds = %100, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %1, %.preheader
  %2 = phi i32 [ 0, %1 ], [ %99, %.preheader ]
  %3 = shl nuw nsw i32 %2, 4
  %4 = trunc i32 %3 to i20
  %5 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %4
  %6 = load float, ptr %5, align 4
  %7 = fmul float %6, 5.000000e-01
  %8 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %4
  store float %7, ptr %8, align 4
  %9 = or disjoint i32 %3, 1
  %10 = trunc i32 %9 to i20
  %11 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %10
  %12 = load float, ptr %11, align 4
  %13 = fmul float %12, 5.000000e-01
  %14 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %10
  store float %13, ptr %14, align 4
  %15 = or disjoint i32 %3, 2
  %16 = trunc i32 %15 to i20
  %17 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %16
  %18 = load float, ptr %17, align 4
  %19 = fmul float %18, 5.000000e-01
  %20 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %16
  store float %19, ptr %20, align 4
  %21 = or disjoint i32 %3, 3
  %22 = trunc i32 %21 to i20
  %23 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %22
  %24 = load float, ptr %23, align 4
  %25 = fmul float %24, 5.000000e-01
  %26 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %22
  store float %25, ptr %26, align 4
  %27 = or disjoint i32 %3, 4
  %28 = trunc i32 %27 to i20
  %29 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %28
  %30 = load float, ptr %29, align 4
  %31 = fmul float %30, 5.000000e-01
  %32 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %28
  store float %31, ptr %32, align 4
  %33 = or disjoint i32 %3, 5
  %34 = trunc i32 %33 to i20
  %35 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %34
  %36 = load float, ptr %35, align 4
  %37 = fmul float %36, 5.000000e-01
  %38 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %34
  store float %37, ptr %38, align 4
  %39 = or disjoint i32 %3, 6
  %40 = trunc i32 %39 to i20
  %41 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %40
  %42 = load float, ptr %41, align 4
  %43 = fmul float %42, 5.000000e-01
  %44 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %40
  store float %43, ptr %44, align 4
  %45 = or disjoint i32 %3, 7
  %46 = trunc i32 %45 to i20
  %47 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %46
  %48 = load float, ptr %47, align 4
  %49 = fmul float %48, 5.000000e-01
  %50 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %46
  store float %49, ptr %50, align 4
  %51 = or disjoint i32 %3, 8
  %52 = trunc i32 %51 to i20
  %53 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %52
  %54 = load float, ptr %53, align 4
  %55 = fmul float %54, 5.000000e-01
  %56 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %52
  store float %55, ptr %56, align 4
  %57 = or disjoint i32 %3, 9
  %58 = trunc i32 %57 to i20
  %59 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %58
  %60 = load float, ptr %59, align 4
  %61 = fmul float %60, 5.000000e-01
  %62 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %58
  store float %61, ptr %62, align 4
  %63 = or disjoint i32 %3, 10
  %64 = trunc i32 %63 to i20
  %65 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %64
  %66 = load float, ptr %65, align 4
  %67 = fmul float %66, 5.000000e-01
  %68 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %64
  store float %67, ptr %68, align 4
  %69 = or disjoint i32 %3, 11
  %70 = trunc i32 %69 to i20
  %71 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %70
  %72 = load float, ptr %71, align 4
  %73 = fmul float %72, 5.000000e-01
  %74 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %70
  store float %73, ptr %74, align 4
  %75 = or disjoint i32 %3, 12
  %76 = trunc i32 %75 to i20
  %77 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %76
  %78 = load float, ptr %77, align 4
  %79 = fmul float %78, 5.000000e-01
  %80 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %76
  store float %79, ptr %80, align 4
  %81 = or disjoint i32 %3, 13
  %82 = trunc i32 %81 to i20
  %83 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %82
  %84 = load float, ptr %83, align 4
  %85 = fmul float %84, 5.000000e-01
  %86 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %82
  store float %85, ptr %86, align 4
  %87 = or disjoint i32 %3, 14
  %88 = trunc i32 %87 to i20
  %89 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %88
  %90 = load float, ptr %89, align 4
  %91 = fmul float %90, 5.000000e-01
  %92 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %88
  store float %91, ptr %92, align 4
  %93 = or disjoint i32 %3, 15
  %94 = trunc i32 %93 to i20
  %95 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %94
  %96 = load float, ptr %95, align 4
  %97 = fmul float %96, 5.000000e-01
  %98 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %94
  store float %97, ptr %98, align 4
  %99 = add nuw nsw i32 %2, 1
  %exitcond.not = icmp eq i32 %99, 8
  br i1 %exitcond.not, label %100, label %.preheader, !llvm.loop !1

100:                                              ; preds = %.preheader
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
