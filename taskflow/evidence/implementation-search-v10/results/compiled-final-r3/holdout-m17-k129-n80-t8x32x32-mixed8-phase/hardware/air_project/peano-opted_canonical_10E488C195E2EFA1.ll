; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-mixed8-phase/hardware/air_project/canonical_10E488C195E2EFA1.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [16 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [16 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_2() local_unnamed_addr #2 {
  br label %1

1:                                                ; preds = %41, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %1, %2
  %3 = phi i32 [ 64, %1 ], [ %39, %2 ]
  %4 = add nuw nsw i32 %3, 1048512
  %5 = trunc i32 %4 to i20
  %6 = getelementptr float, ptr @__aiecc_canon_0, i20 %5
  %7 = load float, ptr %6, align 32
  %8 = tail call float @__mulsf3(float %7, float 5.000000e-01)
  %9 = getelementptr inbounds nuw i8, ptr %6, i20 4
  %10 = load float, ptr %9, align 4
  %11 = tail call float @__mulsf3(float %10, float 5.000000e-01)
  %12 = getelementptr inbounds nuw i8, ptr %6, i20 8
  %13 = load float, ptr %12, align 8
  %14 = tail call float @__mulsf3(float %13, float 5.000000e-01)
  %15 = getelementptr inbounds nuw i8, ptr %6, i20 12
  %16 = load float, ptr %15, align 4
  %17 = tail call float @__mulsf3(float %16, float 5.000000e-01)
  %18 = getelementptr inbounds nuw i8, ptr %6, i20 16
  %19 = load float, ptr %18, align 16
  %20 = tail call float @__mulsf3(float %19, float 5.000000e-01)
  %21 = getelementptr inbounds nuw i8, ptr %6, i20 20
  %22 = load float, ptr %21, align 4
  %23 = tail call float @__mulsf3(float %22, float 5.000000e-01)
  %24 = getelementptr inbounds nuw i8, ptr %6, i20 24
  %25 = load float, ptr %24, align 8
  %26 = tail call float @__mulsf3(float %25, float 5.000000e-01)
  %27 = getelementptr inbounds nuw i8, ptr %6, i20 28
  %28 = load float, ptr %27, align 4
  %29 = tail call float @__mulsf3(float %28, float 5.000000e-01)
  %30 = insertelement <8 x float> poison, float %8, i64 0
  %31 = insertelement <8 x float> %30, float %11, i64 1
  %32 = insertelement <8 x float> %31, float %14, i64 2
  %33 = insertelement <8 x float> %32, float %17, i64 3
  %34 = insertelement <8 x float> %33, float %20, i64 4
  %35 = insertelement <8 x float> %34, float %23, i64 5
  %36 = insertelement <8 x float> %35, float %26, i64 6
  %37 = insertelement <8 x float> %36, float %29, i64 7
  %38 = getelementptr float, ptr @__aiecc_canon_1, i20 %5
  store <8 x float> %37, ptr %38, align 32
  %39 = add nuw nsw i32 %3, 8
  %40 = icmp samesign ult i32 %3, 72
  br i1 %40, label %2, label %41, !llvm.loop !1

41:                                               ; preds = %2
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync memory(none) }
attributes #2 = { nofree noreturn nosync }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
