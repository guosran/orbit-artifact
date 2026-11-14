; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/taskflow-gap-closure-20261114/three-row-r4/wave-2/hardware/air_project/canonical_C78895C24A8FC82A.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [704 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [704 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %37, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %1, %35
  %2 = phi i32 [ 11, %1 ], [ %36, %35 ]
  %3 = shl nuw nsw i32 %2, 6
  %4 = add nuw nsw i32 %3, 1047872
  br label %5

5:                                                ; preds = %5, %.preheader
  %6 = phi i32 [ 0, %.preheader ], [ %34, %5 ]
  %7 = add nuw nsw i32 %6, %4
  %8 = trunc i32 %7 to i20
  %9 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %8
  %10 = load float, ptr %9, align 4
  %11 = fadd float %10, %10
  %12 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %8
  store float %11, ptr %12, align 4
  %13 = or disjoint i32 %6, 1
  %14 = add nuw nsw i32 %13, %4
  %15 = trunc i32 %14 to i20
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %15
  %17 = load float, ptr %16, align 4
  %18 = fadd float %17, %17
  %19 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %15
  store float %18, ptr %19, align 4
  %20 = or disjoint i32 %6, 2
  %21 = add nuw nsw i32 %20, %4
  %22 = trunc i32 %21 to i20
  %23 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %22
  %24 = load float, ptr %23, align 4
  %25 = fadd float %24, %24
  %26 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %22
  store float %25, ptr %26, align 4
  %27 = or disjoint i32 %6, 3
  %28 = add nuw nsw i32 %27, %4
  %29 = trunc i32 %28 to i20
  %30 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %29
  %31 = load float, ptr %30, align 4
  %32 = fadd float %31, %31
  %33 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %29
  store float %32, ptr %33, align 4
  %34 = add nuw nsw i32 %6, 4
  %exitcond.not.3 = icmp eq i32 %34, 64
  br i1 %exitcond.not.3, label %35, label %5, !llvm.loop !1

35:                                               ; preds = %5
  %36 = add nuw nsw i32 %2, 1
  %exitcond2.not = icmp eq i32 %36, 22
  br i1 %exitcond2.not, label %37, label %.preheader, !llvm.loop !1

37:                                               ; preds = %35
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
