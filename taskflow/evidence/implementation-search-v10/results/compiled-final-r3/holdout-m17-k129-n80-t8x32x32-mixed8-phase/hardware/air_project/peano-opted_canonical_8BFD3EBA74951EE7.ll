; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-mixed8-phase/hardware/air_project/canonical_8BFD3EBA74951EE7.ll'
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

.loopexit:                                        ; preds = %44, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.loopexit, %42
  %1 = phi i32 [ 0, %.loopexit ], [ %43, %42 ]
  %2 = shl i32 %1, 5
  br label %3

3:                                                ; preds = %.preheader, %3
  %4 = phi i32 [ 0, %.preheader ], [ %40, %3 ]
  %5 = add nuw nsw i32 %4, %2
  %6 = trunc i32 %5 to i20
  %7 = getelementptr float, ptr @__aiecc_canon_1, i20 %6
  %8 = load float, ptr %7, align 32
  %9 = tail call float @__mulsf3(float %8, float 5.000000e-01)
  %10 = getelementptr inbounds nuw i8, ptr %7, i20 4
  %11 = load float, ptr %10, align 4
  %12 = tail call float @__mulsf3(float %11, float 5.000000e-01)
  %13 = getelementptr inbounds nuw i8, ptr %7, i20 8
  %14 = load float, ptr %13, align 8
  %15 = tail call float @__mulsf3(float %14, float 5.000000e-01)
  %16 = getelementptr inbounds nuw i8, ptr %7, i20 12
  %17 = load float, ptr %16, align 4
  %18 = tail call float @__mulsf3(float %17, float 5.000000e-01)
  %19 = getelementptr inbounds nuw i8, ptr %7, i20 16
  %20 = load float, ptr %19, align 16
  %21 = tail call float @__mulsf3(float %20, float 5.000000e-01)
  %22 = getelementptr inbounds nuw i8, ptr %7, i20 20
  %23 = load float, ptr %22, align 4
  %24 = tail call float @__mulsf3(float %23, float 5.000000e-01)
  %25 = getelementptr inbounds nuw i8, ptr %7, i20 24
  %26 = load float, ptr %25, align 8
  %27 = tail call float @__mulsf3(float %26, float 5.000000e-01)
  %28 = getelementptr inbounds nuw i8, ptr %7, i20 28
  %29 = load float, ptr %28, align 4
  %30 = tail call float @__mulsf3(float %29, float 5.000000e-01)
  %31 = insertelement <8 x float> poison, float %9, i64 0
  %32 = insertelement <8 x float> %31, float %12, i64 1
  %33 = insertelement <8 x float> %32, float %15, i64 2
  %34 = insertelement <8 x float> %33, float %18, i64 3
  %35 = insertelement <8 x float> %34, float %21, i64 4
  %36 = insertelement <8 x float> %35, float %24, i64 5
  %37 = insertelement <8 x float> %36, float %27, i64 6
  %38 = insertelement <8 x float> %37, float %30, i64 7
  %39 = getelementptr float, ptr @__aiecc_canon_0, i20 %6
  store <8 x float> %38, ptr %39, align 32
  %40 = add nuw nsw i32 %4, 8
  %41 = icmp samesign ult i32 %4, 24
  br i1 %41, label %3, label %42, !llvm.loop !1

42:                                               ; preds = %3
  %43 = add nuw nsw i32 %1, 1
  %exitcond.not = icmp eq i32 %43, 8
  br i1 %exitcond.not, label %44, label %.preheader, !llvm.loop !1

44:                                               ; preds = %42
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
