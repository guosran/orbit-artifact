; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-mixed8-phase/hardware/air_project/canonical_4D8DEB4461E2075E.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [256 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [256 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_2() local_unnamed_addr #2 {
  br label %.loopexit

.loopexit:                                        ; preds = %45, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.loopexit, %43
  %1 = phi i32 [ 8, %.loopexit ], [ %44, %43 ]
  %2 = shl nuw nsw i32 %1, 5
  %3 = add nuw nsw i32 %2, 1048320
  br label %4

4:                                                ; preds = %.preheader, %4
  %5 = phi i32 [ 0, %.preheader ], [ %41, %4 ]
  %6 = add nuw nsw i32 %5, %3
  %7 = trunc i32 %6 to i20
  %8 = getelementptr float, ptr @__aiecc_canon_1, i20 %7
  %9 = load float, ptr %8, align 32
  %10 = tail call float @__mulsf3(float %9, float 5.000000e-01)
  %11 = getelementptr inbounds nuw i8, ptr %8, i20 4
  %12 = load float, ptr %11, align 4
  %13 = tail call float @__mulsf3(float %12, float 5.000000e-01)
  %14 = getelementptr inbounds nuw i8, ptr %8, i20 8
  %15 = load float, ptr %14, align 8
  %16 = tail call float @__mulsf3(float %15, float 5.000000e-01)
  %17 = getelementptr inbounds nuw i8, ptr %8, i20 12
  %18 = load float, ptr %17, align 4
  %19 = tail call float @__mulsf3(float %18, float 5.000000e-01)
  %20 = getelementptr inbounds nuw i8, ptr %8, i20 16
  %21 = load float, ptr %20, align 16
  %22 = tail call float @__mulsf3(float %21, float 5.000000e-01)
  %23 = getelementptr inbounds nuw i8, ptr %8, i20 20
  %24 = load float, ptr %23, align 4
  %25 = tail call float @__mulsf3(float %24, float 5.000000e-01)
  %26 = getelementptr inbounds nuw i8, ptr %8, i20 24
  %27 = load float, ptr %26, align 8
  %28 = tail call float @__mulsf3(float %27, float 5.000000e-01)
  %29 = getelementptr inbounds nuw i8, ptr %8, i20 28
  %30 = load float, ptr %29, align 4
  %31 = tail call float @__mulsf3(float %30, float 5.000000e-01)
  %32 = insertelement <8 x float> poison, float %10, i64 0
  %33 = insertelement <8 x float> %32, float %13, i64 1
  %34 = insertelement <8 x float> %33, float %16, i64 2
  %35 = insertelement <8 x float> %34, float %19, i64 3
  %36 = insertelement <8 x float> %35, float %22, i64 4
  %37 = insertelement <8 x float> %36, float %25, i64 5
  %38 = insertelement <8 x float> %37, float %28, i64 6
  %39 = insertelement <8 x float> %38, float %31, i64 7
  %40 = getelementptr float, ptr @__aiecc_canon_0, i20 %7
  store <8 x float> %39, ptr %40, align 32
  %41 = add nuw nsw i32 %5, 8
  %42 = icmp samesign ult i32 %5, 24
  br i1 %42, label %4, label %43, !llvm.loop !1

43:                                               ; preds = %4
  %44 = add nuw nsw i32 %1, 1
  %exitcond.not = icmp eq i32 %44, 16
  br i1 %exitcond.not, label %45, label %.preheader, !llvm.loop !1

45:                                               ; preds = %43
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %.loopexit, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync memory(none) }
attributes #2 = { nofree noreturn nosync }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
