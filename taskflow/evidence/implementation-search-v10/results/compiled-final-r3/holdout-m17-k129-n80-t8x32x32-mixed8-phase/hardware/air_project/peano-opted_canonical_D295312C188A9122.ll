; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-mixed8-phase/hardware/air_project/canonical_D295312C188A9122.ll'
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
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %117, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(128) @__aiecc_canon_2, i8 0, i64 128, i1 false)
  br label %.preheader

.preheader:                                       ; preds = %.preheader.preheader, %63
  %1 = phi i32 [ %64, %63 ], [ 0, %.preheader.preheader ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 54, i32 -1)
  br label %2

2:                                                ; preds = %.preheader, %60
  %3 = phi i32 [ 32, %.preheader ], [ %61, %60 ]
  %4 = add nsw i32 %3, -32
  %5 = trunc i32 %4 to i20
  %6 = getelementptr float, ptr @__aiecc_canon_2, i20 %5
  %.promoted = load <8 x float>, ptr %6, align 32
  br label %7

7:                                                ; preds = %2, %7
  %8 = phi i32 [ 0, %2 ], [ %59, %7 ]
  %9 = phi <8 x float> [ %.promoted, %2 ], [ %58, %7 ]
  %10 = trunc nuw nsw i32 %8 to i20
  %11 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %10
  %12 = load float, ptr %11, align 4
  %13 = shl nuw nsw i32 %8, 5
  %14 = add nuw nsw i32 %13, %4
  %15 = trunc i32 %14 to i20
  %16 = getelementptr float, ptr @__aiecc_canon_1, i20 %15
  %17 = load float, ptr %16, align 32
  %18 = tail call float @__mulsf3(float %12, float %17)
  %19 = getelementptr inbounds nuw i8, ptr %16, i20 4
  %20 = load float, ptr %19, align 4
  %21 = tail call float @__mulsf3(float %12, float %20)
  %22 = getelementptr inbounds nuw i8, ptr %16, i20 8
  %23 = load float, ptr %22, align 8
  %24 = tail call float @__mulsf3(float %12, float %23)
  %25 = getelementptr inbounds nuw i8, ptr %16, i20 12
  %26 = load float, ptr %25, align 4
  %27 = tail call float @__mulsf3(float %12, float %26)
  %28 = getelementptr inbounds nuw i8, ptr %16, i20 16
  %29 = load float, ptr %28, align 16
  %30 = tail call float @__mulsf3(float %12, float %29)
  %31 = getelementptr inbounds nuw i8, ptr %16, i20 20
  %32 = load float, ptr %31, align 4
  %33 = tail call float @__mulsf3(float %12, float %32)
  %34 = getelementptr inbounds nuw i8, ptr %16, i20 24
  %35 = load float, ptr %34, align 8
  %36 = tail call float @__mulsf3(float %12, float %35)
  %37 = getelementptr inbounds nuw i8, ptr %16, i20 28
  %38 = load float, ptr %37, align 4
  %39 = tail call float @__mulsf3(float %12, float %38)
  %40 = insertelement <8 x float> poison, float %18, i64 0
  %41 = insertelement <8 x float> %40, float %21, i64 1
  %42 = insertelement <8 x float> %41, float %24, i64 2
  %43 = insertelement <8 x float> %42, float %27, i64 3
  %44 = insertelement <8 x float> %43, float %30, i64 4
  %45 = insertelement <8 x float> %44, float %33, i64 5
  %46 = insertelement <8 x float> %45, float %36, i64 6
  %47 = insertelement <8 x float> %46, float %39, i64 7
  %48 = bitcast <8 x float> %9 to <4 x i64>
  %49 = bitcast <8 x float> %47 to <4 x i64>
  %50 = shufflevector <4 x i64> %48, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %51 = shufflevector <4 x i64> %49, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %52 = bitcast <32 x i64> %50 to <64 x float>
  %53 = bitcast <32 x i64> %51 to <64 x float>
  %54 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %52, <64 x float> %53, i32 60)
  %55 = bitcast <64 x float> %54 to <32 x i64>
  %56 = shufflevector <32 x i64> %55, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %57 = bitcast <8 x i64> %56 to <16 x float>
  %58 = shufflevector <16 x float> %57, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %58, ptr %6, align 32
  %59 = add nuw nsw i32 %8, 1
  %exitcond.not = icmp eq i32 %59, 32
  br i1 %exitcond.not, label %60, label %7, !llvm.loop !1

60:                                               ; preds = %7
  %61 = add nuw nsw i32 %3, 8
  %62 = icmp samesign ult i32 %3, 56
  br i1 %62, label %2, label %63, !llvm.loop !1

63:                                               ; preds = %60
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 55, i32 1)
  %64 = add nuw nsw i32 %1, 1
  %exitcond5.not = icmp eq i32 %64, 4
  br i1 %exitcond5.not, label %65, label %.preheader, !llvm.loop !1

65:                                               ; preds = %63
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 56, i32 -1)
  %66 = load float, ptr @__aiecc_canon_4, align 4
  br label %67

67:                                               ; preds = %65, %67
  %68 = phi i32 [ 32, %65 ], [ %115, %67 ]
  %69 = add nuw nsw i32 %68, 1048544
  %70 = trunc i32 %69 to i20
  %71 = getelementptr float, ptr @__aiecc_canon_3, i20 %70
  %72 = getelementptr float, ptr @__aiecc_canon_2, i20 %70
  %73 = load <4 x i64>, ptr %72, align 32
  %74 = load float, ptr %71, align 32
  %75 = tail call float @__mulsf3(float %66, float %74)
  %76 = getelementptr inbounds nuw i8, ptr %71, i20 4
  %77 = load float, ptr %76, align 4
  %78 = tail call float @__mulsf3(float %66, float %77)
  %79 = getelementptr inbounds nuw i8, ptr %71, i20 8
  %80 = load float, ptr %79, align 8
  %81 = tail call float @__mulsf3(float %66, float %80)
  %82 = getelementptr inbounds nuw i8, ptr %71, i20 12
  %83 = load float, ptr %82, align 4
  %84 = tail call float @__mulsf3(float %66, float %83)
  %85 = getelementptr inbounds nuw i8, ptr %71, i20 16
  %86 = load float, ptr %85, align 16
  %87 = tail call float @__mulsf3(float %66, float %86)
  %88 = getelementptr inbounds nuw i8, ptr %71, i20 20
  %89 = load float, ptr %88, align 4
  %90 = tail call float @__mulsf3(float %66, float %89)
  %91 = getelementptr inbounds nuw i8, ptr %71, i20 24
  %92 = load float, ptr %91, align 8
  %93 = tail call float @__mulsf3(float %66, float %92)
  %94 = getelementptr inbounds nuw i8, ptr %71, i20 28
  %95 = load float, ptr %94, align 4
  %96 = tail call float @__mulsf3(float %66, float %95)
  %97 = insertelement <8 x float> poison, float %75, i64 0
  %98 = insertelement <8 x float> %97, float %78, i64 1
  %99 = insertelement <8 x float> %98, float %81, i64 2
  %100 = insertelement <8 x float> %99, float %84, i64 3
  %101 = insertelement <8 x float> %100, float %87, i64 4
  %102 = insertelement <8 x float> %101, float %90, i64 5
  %103 = insertelement <8 x float> %102, float %93, i64 6
  %104 = insertelement <8 x float> %103, float %96, i64 7
  %105 = bitcast <8 x float> %104 to <4 x i64>
  %106 = shufflevector <4 x i64> %73, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %107 = shufflevector <4 x i64> %105, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %108 = bitcast <32 x i64> %106 to <64 x float>
  %109 = bitcast <32 x i64> %107 to <64 x float>
  %110 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %108, <64 x float> %109, i32 60)
  %111 = bitcast <64 x float> %110 to <32 x i64>
  %112 = shufflevector <32 x i64> %111, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %113 = bitcast <8 x i64> %112 to <16 x float>
  %114 = shufflevector <16 x float> %113, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %114, ptr %72, align 32
  %115 = add nuw nsw i32 %68, 8
  %116 = icmp samesign ult i32 %68, 56
  br i1 %116, label %67, label %117, !llvm.loop !1

117:                                              ; preds = %67
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 57, i32 1)
  br label %.preheader.preheader
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
