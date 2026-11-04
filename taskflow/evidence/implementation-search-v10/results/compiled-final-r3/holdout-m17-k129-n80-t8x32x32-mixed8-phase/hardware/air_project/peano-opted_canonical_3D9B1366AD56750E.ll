; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-mixed8-phase/hardware/air_project/canonical_3D9B1366AD56750E.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [1024 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_3 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_4 = external local_unnamed_addr global [1 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_5() local_unnamed_addr #2 {
  br label %.preheader4.preheader

.preheader4.preheader:                            ; preds = %114, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(128) @__aiecc_canon_2, i8 0, i64 128, i1 false)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader4.preheader, %61
  %1 = phi i32 [ %62, %61 ], [ 0, %.preheader4.preheader ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 54, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %58
  %2 = phi i32 [ 0, %.preheader4 ], [ %59, %58 ]
  %3 = trunc i32 %2 to i20
  %4 = getelementptr float, ptr @__aiecc_canon_2, i20 %3
  %.promoted = load <8 x float>, ptr %4, align 32
  br label %5

5:                                                ; preds = %.preheader, %5
  %6 = phi i32 [ 0, %.preheader ], [ %57, %5 ]
  %7 = phi <8 x float> [ %.promoted, %.preheader ], [ %56, %5 ]
  %8 = trunc nuw nsw i32 %6 to i20
  %9 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %8
  %10 = load float, ptr %9, align 4
  %11 = shl nuw nsw i32 %6, 5
  %12 = add nuw nsw i32 %11, %2
  %13 = trunc i32 %12 to i20
  %14 = getelementptr float, ptr @__aiecc_canon_1, i20 %13
  %15 = load float, ptr %14, align 32
  %16 = tail call float @__mulsf3(float %10, float %15)
  %17 = getelementptr inbounds nuw i8, ptr %14, i20 4
  %18 = load float, ptr %17, align 4
  %19 = tail call float @__mulsf3(float %10, float %18)
  %20 = getelementptr inbounds nuw i8, ptr %14, i20 8
  %21 = load float, ptr %20, align 8
  %22 = tail call float @__mulsf3(float %10, float %21)
  %23 = getelementptr inbounds nuw i8, ptr %14, i20 12
  %24 = load float, ptr %23, align 4
  %25 = tail call float @__mulsf3(float %10, float %24)
  %26 = getelementptr inbounds nuw i8, ptr %14, i20 16
  %27 = load float, ptr %26, align 16
  %28 = tail call float @__mulsf3(float %10, float %27)
  %29 = getelementptr inbounds nuw i8, ptr %14, i20 20
  %30 = load float, ptr %29, align 4
  %31 = tail call float @__mulsf3(float %10, float %30)
  %32 = getelementptr inbounds nuw i8, ptr %14, i20 24
  %33 = load float, ptr %32, align 8
  %34 = tail call float @__mulsf3(float %10, float %33)
  %35 = getelementptr inbounds nuw i8, ptr %14, i20 28
  %36 = load float, ptr %35, align 4
  %37 = tail call float @__mulsf3(float %10, float %36)
  %38 = insertelement <8 x float> poison, float %16, i64 0
  %39 = insertelement <8 x float> %38, float %19, i64 1
  %40 = insertelement <8 x float> %39, float %22, i64 2
  %41 = insertelement <8 x float> %40, float %25, i64 3
  %42 = insertelement <8 x float> %41, float %28, i64 4
  %43 = insertelement <8 x float> %42, float %31, i64 5
  %44 = insertelement <8 x float> %43, float %34, i64 6
  %45 = insertelement <8 x float> %44, float %37, i64 7
  %46 = bitcast <8 x float> %7 to <4 x i64>
  %47 = bitcast <8 x float> %45 to <4 x i64>
  %48 = shufflevector <4 x i64> %46, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %49 = shufflevector <4 x i64> %47, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %50 = bitcast <32 x i64> %48 to <64 x float>
  %51 = bitcast <32 x i64> %49 to <64 x float>
  %52 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %50, <64 x float> %51, i32 60)
  %53 = bitcast <64 x float> %52 to <32 x i64>
  %54 = shufflevector <32 x i64> %53, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %55 = bitcast <8 x i64> %54 to <16 x float>
  %56 = shufflevector <16 x float> %55, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %56, ptr %4, align 32
  %57 = add nuw nsw i32 %6, 1
  %exitcond.not = icmp eq i32 %57, 32
  br i1 %exitcond.not, label %58, label %5, !llvm.loop !1

58:                                               ; preds = %5
  %59 = add nuw nsw i32 %2, 8
  %60 = icmp samesign ult i32 %2, 24
  br i1 %60, label %.preheader, label %61, !llvm.loop !1

61:                                               ; preds = %58
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 55, i32 1)
  %62 = add nuw nsw i32 %1, 1
  %exitcond5.not = icmp eq i32 %62, 4
  br i1 %exitcond5.not, label %63, label %.preheader4, !llvm.loop !1

63:                                               ; preds = %61
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 56, i32 -1)
  %64 = load float, ptr @__aiecc_canon_4, align 4
  br label %65

65:                                               ; preds = %63, %65
  %66 = phi i32 [ 0, %63 ], [ %112, %65 ]
  %67 = trunc nuw i32 %66 to i20
  %68 = getelementptr float, ptr @__aiecc_canon_3, i20 %67
  %69 = getelementptr float, ptr @__aiecc_canon_2, i20 %67
  %70 = load <4 x i64>, ptr %69, align 32
  %71 = load float, ptr %68, align 32
  %72 = tail call float @__mulsf3(float %64, float %71)
  %73 = getelementptr inbounds nuw i8, ptr %68, i20 4
  %74 = load float, ptr %73, align 4
  %75 = tail call float @__mulsf3(float %64, float %74)
  %76 = getelementptr inbounds nuw i8, ptr %68, i20 8
  %77 = load float, ptr %76, align 8
  %78 = tail call float @__mulsf3(float %64, float %77)
  %79 = getelementptr inbounds nuw i8, ptr %68, i20 12
  %80 = load float, ptr %79, align 4
  %81 = tail call float @__mulsf3(float %64, float %80)
  %82 = getelementptr inbounds nuw i8, ptr %68, i20 16
  %83 = load float, ptr %82, align 16
  %84 = tail call float @__mulsf3(float %64, float %83)
  %85 = getelementptr inbounds nuw i8, ptr %68, i20 20
  %86 = load float, ptr %85, align 4
  %87 = tail call float @__mulsf3(float %64, float %86)
  %88 = getelementptr inbounds nuw i8, ptr %68, i20 24
  %89 = load float, ptr %88, align 8
  %90 = tail call float @__mulsf3(float %64, float %89)
  %91 = getelementptr inbounds nuw i8, ptr %68, i20 28
  %92 = load float, ptr %91, align 4
  %93 = tail call float @__mulsf3(float %64, float %92)
  %94 = insertelement <8 x float> poison, float %72, i64 0
  %95 = insertelement <8 x float> %94, float %75, i64 1
  %96 = insertelement <8 x float> %95, float %78, i64 2
  %97 = insertelement <8 x float> %96, float %81, i64 3
  %98 = insertelement <8 x float> %97, float %84, i64 4
  %99 = insertelement <8 x float> %98, float %87, i64 5
  %100 = insertelement <8 x float> %99, float %90, i64 6
  %101 = insertelement <8 x float> %100, float %93, i64 7
  %102 = bitcast <8 x float> %101 to <4 x i64>
  %103 = shufflevector <4 x i64> %70, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %104 = shufflevector <4 x i64> %102, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %105 = bitcast <32 x i64> %103 to <64 x float>
  %106 = bitcast <32 x i64> %104 to <64 x float>
  %107 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %105, <64 x float> %106, i32 60)
  %108 = bitcast <64 x float> %107 to <32 x i64>
  %109 = shufflevector <32 x i64> %108, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %110 = bitcast <8 x i64> %109 to <16 x float>
  %111 = shufflevector <16 x float> %110, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %111, ptr %69, align 32
  %112 = add nuw nsw i32 %66, 8
  %113 = icmp samesign ult i32 %66, 24
  br i1 %113, label %65, label %114, !llvm.loop !1

114:                                              ; preds = %65
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 57, i32 1)
  br label %.preheader4.preheader
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: read)
declare <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float>, <64 x float>, i32) #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #4

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync memory(none) }
attributes #2 = { nofree noreturn nosync }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: read) }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
