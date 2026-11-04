; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/native-selected-compiled-final-r1/implementation-residency/hardware/air_project/canonical_83B2541BFE59D2F4.ll'
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

.preheader2:                                      ; preds = %49, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %49 ]
  br label %2

2:                                                ; preds = %.preheader2, %47
  %3 = phi i32 [ 0, %.preheader2 ], [ %48, %47 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %2, %45
  %4 = phi i32 [ 0, %2 ], [ %46, %45 ]
  %5 = shl i32 %4, 4
  br label %6

6:                                                ; preds = %.preheader, %6
  %7 = phi i32 [ 0, %.preheader ], [ %43, %6 ]
  %8 = add nuw nsw i32 %7, %5
  %9 = trunc i32 %8 to i20
  %10 = getelementptr float, ptr @__aiecc_canon_1, i20 %9
  %11 = load float, ptr %10, align 32
  %12 = tail call float @__mulsf3(float %11, float 5.000000e-01)
  %13 = getelementptr inbounds nuw i8, ptr %10, i20 4
  %14 = load float, ptr %13, align 4
  %15 = tail call float @__mulsf3(float %14, float 5.000000e-01)
  %16 = getelementptr inbounds nuw i8, ptr %10, i20 8
  %17 = load float, ptr %16, align 8
  %18 = tail call float @__mulsf3(float %17, float 5.000000e-01)
  %19 = getelementptr inbounds nuw i8, ptr %10, i20 12
  %20 = load float, ptr %19, align 4
  %21 = tail call float @__mulsf3(float %20, float 5.000000e-01)
  %22 = getelementptr inbounds nuw i8, ptr %10, i20 16
  %23 = load float, ptr %22, align 16
  %24 = tail call float @__mulsf3(float %23, float 5.000000e-01)
  %25 = getelementptr inbounds nuw i8, ptr %10, i20 20
  %26 = load float, ptr %25, align 4
  %27 = tail call float @__mulsf3(float %26, float 5.000000e-01)
  %28 = getelementptr inbounds nuw i8, ptr %10, i20 24
  %29 = load float, ptr %28, align 8
  %30 = tail call float @__mulsf3(float %29, float 5.000000e-01)
  %31 = getelementptr inbounds nuw i8, ptr %10, i20 28
  %32 = load float, ptr %31, align 4
  %33 = tail call float @__mulsf3(float %32, float 5.000000e-01)
  %34 = insertelement <8 x float> poison, float %12, i64 0
  %35 = insertelement <8 x float> %34, float %15, i64 1
  %36 = insertelement <8 x float> %35, float %18, i64 2
  %37 = insertelement <8 x float> %36, float %21, i64 3
  %38 = insertelement <8 x float> %37, float %24, i64 4
  %39 = insertelement <8 x float> %38, float %27, i64 5
  %40 = insertelement <8 x float> %39, float %30, i64 6
  %41 = insertelement <8 x float> %40, float %33, i64 7
  %42 = getelementptr float, ptr @__aiecc_canon_0, i20 %9
  store <8 x float> %41, ptr %42, align 32
  %43 = add nuw nsw i32 %7, 8
  %44 = icmp eq i32 %7, 0
  br i1 %44, label %6, label %45, !llvm.loop !1

45:                                               ; preds = %6
  %46 = add nuw nsw i32 %4, 1
  %exitcond.not = icmp eq i32 %46, 8
  br i1 %exitcond.not, label %47, label %.preheader, !llvm.loop !1

47:                                               ; preds = %45
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  %48 = add nuw nsw i32 %3, 1
  %exitcond3.not = icmp eq i32 %48, 4
  br i1 %exitcond3.not, label %49, label %2, !llvm.loop !1

49:                                               ; preds = %47
  %50 = add nuw nsw i32 %1, 1
  %exitcond4.not = icmp eq i32 %50, 4
  %spec.select = select i1 %exitcond4.not, i32 0, i32 %50
  br label %.preheader2, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync memory(none) }
attributes #2 = { nofree noreturn nosync }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
