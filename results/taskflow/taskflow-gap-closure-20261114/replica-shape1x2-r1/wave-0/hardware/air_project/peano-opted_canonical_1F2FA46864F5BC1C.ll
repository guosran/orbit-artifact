; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/taskflow-gap-closure-20261114/replica-shape1x2-r1/wave-0/hardware/air_project/canonical_1F2FA46864F5BC1C.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [1024 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [1024 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %36, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %1, %34
  %2 = phi i32 [ 0, %1 ], [ %35, %34 ]
  %3 = shl nuw nsw i32 %2, 6
  br label %4

4:                                                ; preds = %4, %.preheader
  %5 = phi i32 [ 0, %.preheader ], [ %33, %4 ]
  %6 = add nuw nsw i32 %5, %3
  %7 = trunc nuw nsw i32 %6 to i20
  %8 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %7
  %9 = load float, ptr %8, align 4
  %10 = fadd float %9, %9
  %11 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %7
  store float %10, ptr %11, align 4
  %12 = or disjoint i32 %5, 1
  %13 = add nuw nsw i32 %12, %3
  %14 = trunc nuw nsw i32 %13 to i20
  %15 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %14
  %16 = load float, ptr %15, align 4
  %17 = fadd float %16, %16
  %18 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %14
  store float %17, ptr %18, align 4
  %19 = or disjoint i32 %5, 2
  %20 = add nuw nsw i32 %19, %3
  %21 = trunc nuw nsw i32 %20 to i20
  %22 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %21
  %23 = load float, ptr %22, align 4
  %24 = fadd float %23, %23
  %25 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %21
  store float %24, ptr %25, align 4
  %26 = or disjoint i32 %5, 3
  %27 = add nuw nsw i32 %26, %3
  %28 = trunc nuw nsw i32 %27 to i20
  %29 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %28
  %30 = load float, ptr %29, align 4
  %31 = fadd float %30, %30
  %32 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %28
  store float %31, ptr %32, align 4
  %33 = add nuw nsw i32 %5, 4
  %exitcond.not.3 = icmp eq i32 %33, 64
  br i1 %exitcond.not.3, label %34, label %4, !llvm.loop !1

34:                                               ; preds = %4
  %35 = add nuw nsw i32 %2, 1
  %exitcond1.not = icmp eq i32 %35, 16
  br i1 %exitcond1.not, label %36, label %.preheader, !llvm.loop !1

36:                                               ; preds = %34
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
