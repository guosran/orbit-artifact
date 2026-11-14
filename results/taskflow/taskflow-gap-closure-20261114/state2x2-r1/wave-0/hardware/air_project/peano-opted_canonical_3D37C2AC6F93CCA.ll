; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/taskflow-gap-closure-20261114/state2x2-r1/wave-0/hardware/air_project/canonical_3D37C2AC6F93CCA.ll'
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

1:                                                ; preds = %62, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader2

.preheader2:                                      ; preds = %1, %30
  %2 = phi i32 [ 0, %1 ], [ %31, %30 ]
  %3 = shl nuw nsw i32 %2, 6
  br label %4

4:                                                ; preds = %4, %.preheader2
  %5 = phi i32 [ 0, %.preheader2 ], [ %29, %4 ]
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
  %exitcond5.not = icmp eq i32 %31, 16
  br i1 %exitcond5.not, label %.preheader, label %.preheader2, !llvm.loop !1

.preheader:                                       ; preds = %30, %60
  %32 = phi i32 [ %61, %60 ], [ 0, %30 ]
  %33 = shl nuw nsw i32 %32, 6
  br label %34

34:                                               ; preds = %34, %.preheader
  %35 = phi i32 [ 0, %.preheader ], [ %59, %34 ]
  %36 = add nuw nsw i32 %35, %33
  %37 = trunc nuw nsw i32 %36 to i20
  %38 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %37
  %39 = load float, ptr %38, align 4
  %40 = fadd float %39, %39
  store float %40, ptr %38, align 4
  %41 = or disjoint i32 %35, 1
  %42 = add nuw nsw i32 %41, %33
  %43 = trunc nuw nsw i32 %42 to i20
  %44 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %43
  %45 = load float, ptr %44, align 4
  %46 = fadd float %45, %45
  store float %46, ptr %44, align 4
  %47 = or disjoint i32 %35, 2
  %48 = add nuw nsw i32 %47, %33
  %49 = trunc nuw nsw i32 %48 to i20
  %50 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %49
  %51 = load float, ptr %50, align 4
  %52 = fadd float %51, %51
  store float %52, ptr %50, align 4
  %53 = or disjoint i32 %35, 3
  %54 = add nuw nsw i32 %53, %33
  %55 = trunc nuw nsw i32 %54 to i20
  %56 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4096), i20 %55
  %57 = load float, ptr %56, align 4
  %58 = fadd float %57, %57
  store float %58, ptr %56, align 4
  %59 = add nuw nsw i32 %35, 4
  %exitcond6.not.3 = icmp eq i32 %59, 64
  br i1 %exitcond6.not.3, label %60, label %34, !llvm.loop !1

60:                                               ; preds = %34
  %61 = add nuw nsw i32 %32, 1
  %exitcond7.not = icmp eq i32 %61, 16
  br i1 %exitcond7.not, label %62, label %.preheader, !llvm.loop !1

62:                                               ; preds = %60
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
