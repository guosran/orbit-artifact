; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/train-m16-k128-n64-t8x16x32-mixed8-panel/hardware/air_project/canonical_53002C047C27EE44.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [128 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [128 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_2() local_unnamed_addr #2 {
  br label %.preheader2

.preheader2:                                      ; preds = %48, %0
  br label %1

1:                                                ; preds = %.preheader2, %46
  %2 = phi i32 [ 0, %.preheader2 ], [ %47, %46 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %1, %44
  %3 = phi i32 [ 0, %1 ], [ %45, %44 ]
  %4 = shl i32 %3, 4
  br label %5

5:                                                ; preds = %.preheader, %5
  %6 = phi i32 [ 0, %.preheader ], [ %42, %5 ]
  %7 = add nuw nsw i32 %6, %4
  %8 = trunc i32 %7 to i20
  %9 = getelementptr float, ptr @__aiecc_canon_1, i20 %8
  %10 = load float, ptr %9, align 32
  %11 = tail call float @__mulsf3(float %10, float 5.000000e-01)
  %12 = getelementptr inbounds nuw i8, ptr %9, i20 4
  %13 = load float, ptr %12, align 4
  %14 = tail call float @__mulsf3(float %13, float 5.000000e-01)
  %15 = getelementptr inbounds nuw i8, ptr %9, i20 8
  %16 = load float, ptr %15, align 8
  %17 = tail call float @__mulsf3(float %16, float 5.000000e-01)
  %18 = getelementptr inbounds nuw i8, ptr %9, i20 12
  %19 = load float, ptr %18, align 4
  %20 = tail call float @__mulsf3(float %19, float 5.000000e-01)
  %21 = getelementptr inbounds nuw i8, ptr %9, i20 16
  %22 = load float, ptr %21, align 16
  %23 = tail call float @__mulsf3(float %22, float 5.000000e-01)
  %24 = getelementptr inbounds nuw i8, ptr %9, i20 20
  %25 = load float, ptr %24, align 4
  %26 = tail call float @__mulsf3(float %25, float 5.000000e-01)
  %27 = getelementptr inbounds nuw i8, ptr %9, i20 24
  %28 = load float, ptr %27, align 8
  %29 = tail call float @__mulsf3(float %28, float 5.000000e-01)
  %30 = getelementptr inbounds nuw i8, ptr %9, i20 28
  %31 = load float, ptr %30, align 4
  %32 = tail call float @__mulsf3(float %31, float 5.000000e-01)
  %33 = insertelement <8 x float> poison, float %11, i64 0
  %34 = insertelement <8 x float> %33, float %14, i64 1
  %35 = insertelement <8 x float> %34, float %17, i64 2
  %36 = insertelement <8 x float> %35, float %20, i64 3
  %37 = insertelement <8 x float> %36, float %23, i64 4
  %38 = insertelement <8 x float> %37, float %26, i64 5
  %39 = insertelement <8 x float> %38, float %29, i64 6
  %40 = insertelement <8 x float> %39, float %32, i64 7
  %41 = getelementptr float, ptr @__aiecc_canon_0, i20 %8
  store <8 x float> %40, ptr %41, align 32
  %42 = add nuw nsw i32 %6, 8
  %43 = icmp eq i32 %6, 0
  br i1 %43, label %5, label %44, !llvm.loop !1

44:                                               ; preds = %5
  %45 = add nuw nsw i32 %3, 1
  %exitcond.not = icmp eq i32 %45, 8
  br i1 %exitcond.not, label %46, label %.preheader, !llvm.loop !1

46:                                               ; preds = %44
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  %47 = add nuw nsw i32 %2, 1
  %exitcond3.not = icmp eq i32 %47, 4
  br i1 %exitcond3.not, label %48, label %1, !llvm.loop !1

48:                                               ; preds = %46
  br label %.preheader2, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync memory(none) }
attributes #2 = { nofree noreturn nosync }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
