; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-mixed8-phase/hardware/air_project/canonical_6C518A41F72C8D4D.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [32 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_2() local_unnamed_addr #2 {
  br label %.loopexit

.loopexit:                                        ; preds = %39, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %1

1:                                                ; preds = %.loopexit, %1
  %2 = phi i32 [ 0, %.loopexit ], [ %37, %1 ]
  %3 = trunc nuw i32 %2 to i20
  %4 = getelementptr float, ptr @__aiecc_canon_1, i20 %3
  %5 = load float, ptr %4, align 32
  %6 = tail call float @__mulsf3(float %5, float 5.000000e-01)
  %7 = getelementptr inbounds nuw i8, ptr %4, i20 4
  %8 = load float, ptr %7, align 4
  %9 = tail call float @__mulsf3(float %8, float 5.000000e-01)
  %10 = getelementptr inbounds nuw i8, ptr %4, i20 8
  %11 = load float, ptr %10, align 8
  %12 = tail call float @__mulsf3(float %11, float 5.000000e-01)
  %13 = getelementptr inbounds nuw i8, ptr %4, i20 12
  %14 = load float, ptr %13, align 4
  %15 = tail call float @__mulsf3(float %14, float 5.000000e-01)
  %16 = getelementptr inbounds nuw i8, ptr %4, i20 16
  %17 = load float, ptr %16, align 16
  %18 = tail call float @__mulsf3(float %17, float 5.000000e-01)
  %19 = getelementptr inbounds nuw i8, ptr %4, i20 20
  %20 = load float, ptr %19, align 4
  %21 = tail call float @__mulsf3(float %20, float 5.000000e-01)
  %22 = getelementptr inbounds nuw i8, ptr %4, i20 24
  %23 = load float, ptr %22, align 8
  %24 = tail call float @__mulsf3(float %23, float 5.000000e-01)
  %25 = getelementptr inbounds nuw i8, ptr %4, i20 28
  %26 = load float, ptr %25, align 4
  %27 = tail call float @__mulsf3(float %26, float 5.000000e-01)
  %28 = insertelement <8 x float> poison, float %6, i64 0
  %29 = insertelement <8 x float> %28, float %9, i64 1
  %30 = insertelement <8 x float> %29, float %12, i64 2
  %31 = insertelement <8 x float> %30, float %15, i64 3
  %32 = insertelement <8 x float> %31, float %18, i64 4
  %33 = insertelement <8 x float> %32, float %21, i64 5
  %34 = insertelement <8 x float> %33, float %24, i64 6
  %35 = insertelement <8 x float> %34, float %27, i64 7
  %36 = getelementptr float, ptr @__aiecc_canon_0, i20 %3
  store <8 x float> %35, ptr %36, align 32
  %37 = add nuw nsw i32 %2, 8
  %38 = icmp samesign ult i32 %2, 24
  br i1 %38, label %1, label %39, !llvm.loop !1

39:                                               ; preds = %1
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
