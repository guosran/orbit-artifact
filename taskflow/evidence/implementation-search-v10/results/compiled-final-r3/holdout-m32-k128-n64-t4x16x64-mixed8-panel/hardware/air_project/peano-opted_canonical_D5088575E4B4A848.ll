; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m32-k128-n64-t4x16x64-mixed8-panel/hardware/air_project/canonical_D5088575E4B4A848.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [256 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [64 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [2048 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_3() local_unnamed_addr #2 {
  br label %1

1:                                                ; preds = %76, %0
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader5

.preheader5:                                      ; preds = %1, %74
  %2 = phi i32 [ 0, %1 ], [ %75, %74 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  store float 0.000000e+00, ptr @__aiecc_canon_1, align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 4), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 8), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 12), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 16), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 20), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 24), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 28), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 32), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 36), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 40), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 44), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 48), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 52), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 56), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 60), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 64), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 68), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 72), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 76), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 80), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 84), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 88), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 92), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 96), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 100), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 104), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 108), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 112), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 116), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 120), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 124), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 128), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 132), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 136), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 140), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 144), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 148), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 152), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 156), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 160), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 164), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 168), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 172), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 176), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 180), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 184), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 188), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 192), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 196), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 200), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 204), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 208), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 212), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 216), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 220), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 224), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 228), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 232), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 236), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 240), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 244), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 248), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 252), align 4
  br label %.preheader6

.preheader6:                                      ; preds = %.preheader5, %71
  %3 = phi i32 [ %72, %71 ], [ 0, %.preheader5 ]
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader6, %69
  %4 = phi i32 [ 0, %.preheader6 ], [ %70, %69 ]
  %5 = shl nuw nsw i32 %4, 6
  %6 = shl i32 %4, 4
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %66
  %7 = phi i32 [ 0, %.preheader4 ], [ %67, %66 ]
  %8 = add nuw nsw i32 %7, %6
  %9 = trunc i32 %8 to i20
  %10 = getelementptr float, ptr @__aiecc_canon_1, i20 %9
  %.promoted = load <8 x float>, ptr %10, align 32
  br label %11

11:                                               ; preds = %.preheader, %11
  %12 = phi i32 [ 0, %.preheader ], [ %65, %11 ]
  %13 = phi <8 x float> [ %.promoted, %.preheader ], [ %64, %11 ]
  %14 = add nuw nsw i32 %12, %3
  %15 = add nuw nsw i32 %12, %5
  %16 = trunc nuw nsw i32 %15 to i20
  %17 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %16
  %18 = load float, ptr %17, align 4
  %19 = shl nuw nsw i32 %14, 4
  %20 = add nuw nsw i32 %19, %7
  %21 = trunc i32 %20 to i20
  %22 = getelementptr float, ptr @__aiecc_canon_2, i20 %21
  %23 = load float, ptr %22, align 32
  %24 = tail call float @__mulsf3(float %18, float %23)
  %25 = getelementptr inbounds nuw i8, ptr %22, i20 4
  %26 = load float, ptr %25, align 4
  %27 = tail call float @__mulsf3(float %18, float %26)
  %28 = getelementptr inbounds nuw i8, ptr %22, i20 8
  %29 = load float, ptr %28, align 8
  %30 = tail call float @__mulsf3(float %18, float %29)
  %31 = getelementptr inbounds nuw i8, ptr %22, i20 12
  %32 = load float, ptr %31, align 4
  %33 = tail call float @__mulsf3(float %18, float %32)
  %34 = getelementptr inbounds nuw i8, ptr %22, i20 16
  %35 = load float, ptr %34, align 16
  %36 = tail call float @__mulsf3(float %18, float %35)
  %37 = getelementptr inbounds nuw i8, ptr %22, i20 20
  %38 = load float, ptr %37, align 4
  %39 = tail call float @__mulsf3(float %18, float %38)
  %40 = getelementptr inbounds nuw i8, ptr %22, i20 24
  %41 = load float, ptr %40, align 8
  %42 = tail call float @__mulsf3(float %18, float %41)
  %43 = getelementptr inbounds nuw i8, ptr %22, i20 28
  %44 = load float, ptr %43, align 4
  %45 = tail call float @__mulsf3(float %18, float %44)
  %46 = insertelement <8 x float> poison, float %24, i64 0
  %47 = insertelement <8 x float> %46, float %27, i64 1
  %48 = insertelement <8 x float> %47, float %30, i64 2
  %49 = insertelement <8 x float> %48, float %33, i64 3
  %50 = insertelement <8 x float> %49, float %36, i64 4
  %51 = insertelement <8 x float> %50, float %39, i64 5
  %52 = insertelement <8 x float> %51, float %42, i64 6
  %53 = insertelement <8 x float> %52, float %45, i64 7
  %54 = bitcast <8 x float> %13 to <4 x i64>
  %55 = bitcast <8 x float> %53 to <4 x i64>
  %56 = shufflevector <4 x i64> %54, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %57 = shufflevector <4 x i64> %55, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %58 = bitcast <32 x i64> %56 to <64 x float>
  %59 = bitcast <32 x i64> %57 to <64 x float>
  %60 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %58, <64 x float> %59, i32 60)
  %61 = bitcast <64 x float> %60 to <32 x i64>
  %62 = shufflevector <32 x i64> %61, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %63 = bitcast <8 x i64> %62 to <16 x float>
  %64 = shufflevector <16 x float> %63, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %64, ptr %10, align 32
  %65 = add nuw nsw i32 %12, 1
  %exitcond7.not = icmp eq i32 %65, 64
  br i1 %exitcond7.not, label %66, label %11, !llvm.loop !1

66:                                               ; preds = %11
  %67 = add nuw nsw i32 %7, 8
  %68 = icmp eq i32 %7, 0
  br i1 %68, label %.preheader, label %69, !llvm.loop !1

69:                                               ; preds = %66
  %70 = add nuw nsw i32 %4, 1
  %exitcond8.not = icmp eq i32 %70, 4
  br i1 %exitcond8.not, label %71, label %.preheader4, !llvm.loop !1

71:                                               ; preds = %69
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %72 = add nuw nsw i32 %3, 64
  %73 = icmp eq i32 %3, 0
  br i1 %73, label %.preheader6, label %74, !llvm.loop !1

74:                                               ; preds = %71
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %75 = add nuw nsw i32 %2, 1
  %exitcond9.not = icmp eq i32 %75, 8
  br i1 %exitcond9.not, label %76, label %.preheader5, !llvm.loop !1

76:                                               ; preds = %74
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %1
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: read)
declare <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float>, <64 x float>, i32) #3

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync memory(none) }
attributes #2 = { nofree noreturn nosync }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: read) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
