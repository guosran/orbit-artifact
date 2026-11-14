; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/taskflow-gap-closure-20261114/state2x2-r1/wave-1/hardware/air_project/canonical_BE928E0C48D1AEEE.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [2048 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_1() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %63, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader3

.preheader3:                                      ; preds = %1, %30
  %2 = phi i32 [ 0, %1 ], [ %31, %30 ]
  %3 = shl nuw nsw i32 %2, 6
  br label %4

4:                                                ; preds = %4, %.preheader3
  %5 = phi i32 [ 0, %.preheader3 ], [ %29, %4 ]
  %6 = add nuw nsw i32 %5, %3
  %7 = trunc nuw nsw i32 %6 to i20
  %8 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %7
  %9 = load float, ptr %8, align 4
  %10 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %7
  store float %9, ptr %10, align 4
  %11 = or disjoint i32 %5, 1
  %12 = add nuw nsw i32 %11, %3
  %13 = trunc nuw nsw i32 %12 to i20
  %14 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %13
  %15 = load float, ptr %14, align 4
  %16 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %13
  store float %15, ptr %16, align 4
  %17 = or disjoint i32 %5, 2
  %18 = add nuw nsw i32 %17, %3
  %19 = trunc nuw nsw i32 %18 to i20
  %20 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %19
  %21 = load float, ptr %20, align 4
  %22 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %19
  store float %21, ptr %22, align 4
  %23 = or disjoint i32 %5, 3
  %24 = add nuw nsw i32 %23, %3
  %25 = trunc nuw nsw i32 %24 to i20
  %26 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %25
  %27 = load float, ptr %26, align 4
  %28 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %25
  store float %27, ptr %28, align 4
  %29 = add nuw nsw i32 %5, 4
  %exitcond.not.3 = icmp eq i32 %29, 64
  br i1 %exitcond.not.3, label %30, label %4, !llvm.loop !1

30:                                               ; preds = %4
  %31 = add nuw nsw i32 %2, 1
  %exitcond6.not = icmp eq i32 %31, 16
  br i1 %exitcond6.not, label %.preheader, label %.preheader3, !llvm.loop !1

.preheader:                                       ; preds = %30, %61
  %32 = phi i32 [ %62, %61 ], [ 16, %30 ]
  %33 = shl nuw nsw i32 %32, 6
  %34 = add nuw nsw i32 %33, 1047552
  br label %35

35:                                               ; preds = %35, %.preheader
  %36 = phi i32 [ 0, %.preheader ], [ %60, %35 ]
  %37 = add nuw nsw i32 %36, %34
  %38 = trunc i32 %37 to i20
  %39 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %38
  %40 = load float, ptr %39, align 4
  %41 = fadd float %40, %40
  store float %41, ptr %39, align 4
  %42 = or disjoint i32 %36, 1
  %43 = add nuw nsw i32 %42, %34
  %44 = trunc i32 %43 to i20
  %45 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %44
  %46 = load float, ptr %45, align 4
  %47 = fadd float %46, %46
  store float %47, ptr %45, align 4
  %48 = or disjoint i32 %36, 2
  %49 = add nuw nsw i32 %48, %34
  %50 = trunc i32 %49 to i20
  %51 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %50
  %52 = load float, ptr %51, align 4
  %53 = fadd float %52, %52
  store float %53, ptr %51, align 4
  %54 = or disjoint i32 %36, 3
  %55 = add nuw nsw i32 %54, %34
  %56 = trunc i32 %55 to i20
  %57 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %56
  %58 = load float, ptr %57, align 4
  %59 = fadd float %58, %58
  store float %59, ptr %57, align 4
  %60 = add nuw nsw i32 %36, 4
  %exitcond7.not.3 = icmp eq i32 %60, 64
  br i1 %exitcond7.not.3, label %61, label %35, !llvm.loop !1

61:                                               ; preds = %35
  %62 = add nuw nsw i32 %32, 1
  %exitcond8.not = icmp eq i32 %62, 32
  br i1 %exitcond8.not, label %63, label %.preheader, !llvm.loop !1

63:                                               ; preds = %61
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
