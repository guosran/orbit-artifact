; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/ffn-profiling-v9/mixed-m8-stages-r1/gate/hardware/air_project/canonical_22AFA7460690D056.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [512 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [4096 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [512 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_3() local_unnamed_addr #2 {
  br label %.loopexit

.loopexit:                                        ; preds = %92, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %92 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  br label %.preheader5

.preheader5:                                      ; preds = %.loopexit, %22
  %2 = phi i32 [ 0, %.loopexit ], [ %23, %22 ]
  %3 = shl nuw nsw i32 %2, 6
  br label %4

4:                                                ; preds = %4, %.preheader5
  %5 = phi i32 [ 0, %.preheader5 ], [ %21, %4 ]
  %6 = add nuw nsw i32 %5, %3
  %7 = trunc nuw nsw i32 %6 to i20
  %8 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %7
  store float 0.000000e+00, ptr %8, align 4
  %9 = or disjoint i32 %5, 1
  %10 = add nuw nsw i32 %9, %3
  %11 = trunc nuw nsw i32 %10 to i20
  %12 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %11
  store float 0.000000e+00, ptr %12, align 4
  %13 = or disjoint i32 %5, 2
  %14 = add nuw nsw i32 %13, %3
  %15 = trunc nuw nsw i32 %14 to i20
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %15
  store float 0.000000e+00, ptr %16, align 4
  %17 = or disjoint i32 %5, 3
  %18 = add nuw nsw i32 %17, %3
  %19 = trunc nuw nsw i32 %18 to i20
  %20 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %19
  store float 0.000000e+00, ptr %20, align 4
  %21 = add nuw nsw i32 %5, 4
  %exitcond.not.3 = icmp eq i32 %21, 64
  br i1 %exitcond.not.3, label %22, label %4, !llvm.loop !1

22:                                               ; preds = %4
  %23 = add nuw nsw i32 %2, 1
  %exitcond7.not = icmp eq i32 %23, 8
  br i1 %exitcond7.not, label %.preheader6, label %.preheader5, !llvm.loop !1

.preheader6:                                      ; preds = %22, %90
  %24 = phi i32 [ %91, %90 ], [ 0, %22 ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader6, %88
  %25 = phi i32 [ 0, %.preheader6 ], [ %89, %88 ]
  %26 = shl nuw nsw i32 %25, 6
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %85
  %27 = phi i32 [ 0, %.preheader4 ], [ %86, %85 ]
  %28 = add nuw nsw i32 %27, %26
  %29 = trunc i32 %28 to i20
  %30 = getelementptr float, ptr @__aiecc_canon_2, i20 %29
  %.promoted = load <8 x float>, ptr %30, align 32
  br label %31

31:                                               ; preds = %.preheader, %31
  %32 = phi i32 [ 0, %.preheader ], [ %84, %31 ]
  %33 = phi <8 x float> [ %.promoted, %.preheader ], [ %83, %31 ]
  %34 = or disjoint i32 %32, %26
  %35 = trunc nuw nsw i32 %34 to i20
  %36 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %35
  %37 = load float, ptr %36, align 4
  %38 = shl nuw nsw i32 %32, 6
  %39 = add nuw nsw i32 %38, %27
  %40 = trunc i32 %39 to i20
  %41 = getelementptr float, ptr @__aiecc_canon_1, i20 %40
  %42 = load float, ptr %41, align 32
  %43 = tail call float @__mulsf3(float %37, float %42)
  %44 = getelementptr inbounds nuw i8, ptr %41, i20 4
  %45 = load float, ptr %44, align 4
  %46 = tail call float @__mulsf3(float %37, float %45)
  %47 = getelementptr inbounds nuw i8, ptr %41, i20 8
  %48 = load float, ptr %47, align 8
  %49 = tail call float @__mulsf3(float %37, float %48)
  %50 = getelementptr inbounds nuw i8, ptr %41, i20 12
  %51 = load float, ptr %50, align 4
  %52 = tail call float @__mulsf3(float %37, float %51)
  %53 = getelementptr inbounds nuw i8, ptr %41, i20 16
  %54 = load float, ptr %53, align 16
  %55 = tail call float @__mulsf3(float %37, float %54)
  %56 = getelementptr inbounds nuw i8, ptr %41, i20 20
  %57 = load float, ptr %56, align 4
  %58 = tail call float @__mulsf3(float %37, float %57)
  %59 = getelementptr inbounds nuw i8, ptr %41, i20 24
  %60 = load float, ptr %59, align 8
  %61 = tail call float @__mulsf3(float %37, float %60)
  %62 = getelementptr inbounds nuw i8, ptr %41, i20 28
  %63 = load float, ptr %62, align 4
  %64 = tail call float @__mulsf3(float %37, float %63)
  %65 = insertelement <8 x float> poison, float %43, i64 0
  %66 = insertelement <8 x float> %65, float %46, i64 1
  %67 = insertelement <8 x float> %66, float %49, i64 2
  %68 = insertelement <8 x float> %67, float %52, i64 3
  %69 = insertelement <8 x float> %68, float %55, i64 4
  %70 = insertelement <8 x float> %69, float %58, i64 5
  %71 = insertelement <8 x float> %70, float %61, i64 6
  %72 = insertelement <8 x float> %71, float %64, i64 7
  %73 = bitcast <8 x float> %33 to <4 x i64>
  %74 = bitcast <8 x float> %72 to <4 x i64>
  %75 = shufflevector <4 x i64> %73, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %76 = shufflevector <4 x i64> %74, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %77 = bitcast <32 x i64> %75 to <64 x float>
  %78 = bitcast <32 x i64> %76 to <64 x float>
  %79 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %77, <64 x float> %78, i32 60)
  %80 = bitcast <64 x float> %79 to <32 x i64>
  %81 = shufflevector <32 x i64> %80, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %82 = bitcast <8 x i64> %81 to <16 x float>
  %83 = shufflevector <16 x float> %82, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %83, ptr %30, align 32
  %84 = add nuw nsw i32 %32, 1
  %exitcond8.not = icmp eq i32 %84, 64
  br i1 %exitcond8.not, label %85, label %31, !llvm.loop !1

85:                                               ; preds = %31
  %86 = add nuw nsw i32 %27, 8
  %87 = icmp samesign ult i32 %27, 56
  br i1 %87, label %.preheader, label %88, !llvm.loop !1

88:                                               ; preds = %85
  %89 = add nuw nsw i32 %25, 1
  %exitcond9.not = icmp eq i32 %89, 8
  br i1 %exitcond9.not, label %90, label %.preheader4, !llvm.loop !1

90:                                               ; preds = %88
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %91 = add nuw nsw i32 %24, 1
  %exitcond10.not = icmp eq i32 %91, 32
  br i1 %exitcond10.not, label %92, label %.preheader6, !llvm.loop !1

92:                                               ; preds = %90
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %93 = add nuw nsw i32 %1, 1
  %exitcond11.not = icmp eq i32 %93, 172
  %spec.select = select i1 %exitcond11.not, i32 0, i32 %93
  br label %.loopexit, !llvm.loop !1
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
