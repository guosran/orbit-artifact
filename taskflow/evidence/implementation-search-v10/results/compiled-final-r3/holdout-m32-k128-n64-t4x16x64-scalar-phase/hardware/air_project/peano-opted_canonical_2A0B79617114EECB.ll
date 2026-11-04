; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m32-k128-n64-t4x16x64-scalar-phase/hardware/air_project/canonical_2A0B79617114EECB.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [256 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [1024 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [64 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_3() local_unnamed_addr #1 {
  br label %.preheader7

.preheader7:                                      ; preds = %71, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %71 ]
  br label %.preheader5

.preheader5:                                      ; preds = %.preheader7, %69
  %2 = phi i32 [ 0, %.preheader7 ], [ %70, %69 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  store float 0.000000e+00, ptr @__aiecc_canon_2, align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 4), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 8), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 12), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 16), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 20), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 24), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 28), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 32), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 36), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 40), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 44), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 48), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 52), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 56), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 60), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 64), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 68), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 72), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 76), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 80), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 84), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 88), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 92), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 96), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 100), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 104), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 108), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 112), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 116), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 120), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 124), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 128), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 132), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 136), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 140), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 144), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 148), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 152), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 156), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 160), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 164), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 168), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 172), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 176), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 180), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 184), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 188), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 192), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 196), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 200), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 204), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 208), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 212), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 216), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 220), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 224), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 228), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 232), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 236), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 240), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 244), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 248), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 252), align 4
  br label %.preheader6

.preheader6:                                      ; preds = %.preheader5, %66
  %3 = phi i32 [ %67, %66 ], [ 0, %.preheader5 ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader6, %64
  %4 = phi i32 [ 0, %.preheader6 ], [ %65, %64 ]
  %5 = shl nuw nsw i32 %4, 6
  %6 = shl nuw nsw i32 %4, 4
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %62
  %7 = phi i32 [ 0, %.preheader4 ], [ %63, %62 ]
  %8 = add nuw nsw i32 %7, %6
  %9 = trunc nuw nsw i32 %8 to i20
  %10 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %9
  %.promoted = load float, ptr %10, align 4
  br label %11

11:                                               ; preds = %11, %.preheader
  %12 = phi i32 [ 0, %.preheader ], [ %61, %11 ]
  %13 = phi float [ %.promoted, %.preheader ], [ %60, %11 ]
  %14 = add nuw nsw i32 %12, %5
  %15 = trunc nuw nsw i32 %14 to i20
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %15
  %17 = load float, ptr %16, align 4
  %18 = shl nuw nsw i32 %12, 4
  %19 = add nuw nsw i32 %18, %7
  %20 = trunc nuw nsw i32 %19 to i20
  %21 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %20
  %22 = load float, ptr %21, align 4
  %23 = fmul float %17, %22
  %24 = fadd float %13, %23
  %25 = or disjoint i32 %12, 1
  %26 = add nuw nsw i32 %25, %5
  %27 = trunc nuw nsw i32 %26 to i20
  %28 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %27
  %29 = load float, ptr %28, align 4
  %30 = shl nuw nsw i32 %25, 4
  %31 = add nuw nsw i32 %30, %7
  %32 = trunc nuw nsw i32 %31 to i20
  %33 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %32
  %34 = load float, ptr %33, align 4
  %35 = fmul float %29, %34
  %36 = fadd float %24, %35
  %37 = or disjoint i32 %12, 2
  %38 = add nuw nsw i32 %37, %5
  %39 = trunc nuw nsw i32 %38 to i20
  %40 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %39
  %41 = load float, ptr %40, align 4
  %42 = shl nuw nsw i32 %37, 4
  %43 = add nuw nsw i32 %42, %7
  %44 = trunc nuw nsw i32 %43 to i20
  %45 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %44
  %46 = load float, ptr %45, align 4
  %47 = fmul float %41, %46
  %48 = fadd float %36, %47
  %49 = or disjoint i32 %12, 3
  %50 = add nuw nsw i32 %49, %5
  %51 = trunc nuw nsw i32 %50 to i20
  %52 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %51
  %53 = load float, ptr %52, align 4
  %54 = shl nuw nsw i32 %49, 4
  %55 = add nuw nsw i32 %54, %7
  %56 = trunc nuw nsw i32 %55 to i20
  %57 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %56
  %58 = load float, ptr %57, align 4
  %59 = fmul float %53, %58
  %60 = fadd float %48, %59
  %61 = add nuw nsw i32 %12, 4
  %exitcond8.not.3 = icmp eq i32 %61, 64
  br i1 %exitcond8.not.3, label %62, label %11, !llvm.loop !1

62:                                               ; preds = %11
  store float %60, ptr %10, align 4
  %63 = add nuw nsw i32 %7, 1
  %exitcond9.not = icmp eq i32 %63, 16
  br i1 %exitcond9.not, label %64, label %.preheader, !llvm.loop !1

64:                                               ; preds = %62
  %65 = add nuw nsw i32 %4, 1
  %exitcond10.not = icmp eq i32 %65, 4
  br i1 %exitcond10.not, label %66, label %.preheader4, !llvm.loop !1

66:                                               ; preds = %64
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %67 = add nuw nsw i32 %3, 1
  %68 = icmp eq i32 %3, 0
  br i1 %68, label %.preheader6, label %69, !llvm.loop !1

69:                                               ; preds = %66
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %70 = add nuw nsw i32 %2, 1
  %exitcond11.not = icmp eq i32 %70, 4
  br i1 %exitcond11.not, label %71, label %.preheader5, !llvm.loop !1

71:                                               ; preds = %69
  %72 = add nuw nsw i32 %1, 1
  %exitcond12.not = icmp eq i32 %72, 8
  %spec.select = select i1 %exitcond12.not, i32 0, i32 %72
  br label %.preheader7, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
