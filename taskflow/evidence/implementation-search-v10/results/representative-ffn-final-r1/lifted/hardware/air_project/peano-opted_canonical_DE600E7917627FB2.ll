; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/representative-ffn-final-r1/lifted/hardware/air_project/canonical_DE600E7917627FB2.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [64 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [2048 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [32 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_3() local_unnamed_addr #2 {
  br label %.preheader4.preheader

.preheader4.preheader:                            ; preds = %64, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %64 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(128) @__aiecc_canon_2, i8 0, i64 128, i1 false)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader4.preheader, %62
  %2 = phi i32 [ %63, %62 ], [ 0, %.preheader4.preheader ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %59
  %3 = phi i32 [ 0, %.preheader4 ], [ %60, %59 ]
  %4 = trunc i32 %3 to i20
  %5 = getelementptr float, ptr @__aiecc_canon_2, i20 %4
  %.promoted = load <8 x float>, ptr %5, align 32
  br label %6

6:                                                ; preds = %.preheader, %6
  %7 = phi i32 [ 0, %.preheader ], [ %58, %6 ]
  %8 = phi <8 x float> [ %.promoted, %.preheader ], [ %57, %6 ]
  %9 = trunc nuw nsw i32 %7 to i20
  %10 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %9
  %11 = load float, ptr %10, align 4
  %12 = shl nuw nsw i32 %7, 5
  %13 = add nuw nsw i32 %12, %3
  %14 = trunc i32 %13 to i20
  %15 = getelementptr float, ptr @__aiecc_canon_1, i20 %14
  %16 = load float, ptr %15, align 32
  %17 = tail call float @__mulsf3(float %11, float %16)
  %18 = getelementptr inbounds nuw i8, ptr %15, i20 4
  %19 = load float, ptr %18, align 4
  %20 = tail call float @__mulsf3(float %11, float %19)
  %21 = getelementptr inbounds nuw i8, ptr %15, i20 8
  %22 = load float, ptr %21, align 8
  %23 = tail call float @__mulsf3(float %11, float %22)
  %24 = getelementptr inbounds nuw i8, ptr %15, i20 12
  %25 = load float, ptr %24, align 4
  %26 = tail call float @__mulsf3(float %11, float %25)
  %27 = getelementptr inbounds nuw i8, ptr %15, i20 16
  %28 = load float, ptr %27, align 16
  %29 = tail call float @__mulsf3(float %11, float %28)
  %30 = getelementptr inbounds nuw i8, ptr %15, i20 20
  %31 = load float, ptr %30, align 4
  %32 = tail call float @__mulsf3(float %11, float %31)
  %33 = getelementptr inbounds nuw i8, ptr %15, i20 24
  %34 = load float, ptr %33, align 8
  %35 = tail call float @__mulsf3(float %11, float %34)
  %36 = getelementptr inbounds nuw i8, ptr %15, i20 28
  %37 = load float, ptr %36, align 4
  %38 = tail call float @__mulsf3(float %11, float %37)
  %39 = insertelement <8 x float> poison, float %17, i64 0
  %40 = insertelement <8 x float> %39, float %20, i64 1
  %41 = insertelement <8 x float> %40, float %23, i64 2
  %42 = insertelement <8 x float> %41, float %26, i64 3
  %43 = insertelement <8 x float> %42, float %29, i64 4
  %44 = insertelement <8 x float> %43, float %32, i64 5
  %45 = insertelement <8 x float> %44, float %35, i64 6
  %46 = insertelement <8 x float> %45, float %38, i64 7
  %47 = bitcast <8 x float> %8 to <4 x i64>
  %48 = bitcast <8 x float> %46 to <4 x i64>
  %49 = shufflevector <4 x i64> %47, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %50 = shufflevector <4 x i64> %48, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %51 = bitcast <32 x i64> %49 to <64 x float>
  %52 = bitcast <32 x i64> %50 to <64 x float>
  %53 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %51, <64 x float> %52, i32 60)
  %54 = bitcast <64 x float> %53 to <32 x i64>
  %55 = shufflevector <32 x i64> %54, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %56 = bitcast <8 x i64> %55 to <16 x float>
  %57 = shufflevector <16 x float> %56, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %57, ptr %5, align 32
  %58 = add nuw nsw i32 %7, 1
  %exitcond.not = icmp eq i32 %58, 64
  br i1 %exitcond.not, label %59, label %6, !llvm.loop !1

59:                                               ; preds = %6
  %60 = add nuw nsw i32 %3, 8
  %61 = icmp samesign ult i32 %3, 24
  br i1 %61, label %.preheader, label %62, !llvm.loop !1

62:                                               ; preds = %59
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %63 = add nuw nsw i32 %2, 1
  %exitcond5.not = icmp eq i32 %63, 32
  br i1 %exitcond5.not, label %64, label %.preheader4, !llvm.loop !1

64:                                               ; preds = %62
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %65 = add nuw nsw i32 %1, 1
  %exitcond6.not = icmp eq i32 %65, 344
  %spec.select = select i1 %exitcond6.not, i32 0, i32 %65
  br label %.preheader4.preheader, !llvm.loop !1
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
