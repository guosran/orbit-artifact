; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m32-k128-n64-t4x16x64-scalar-panel/hardware/air_project/canonical_AACBB4C593A65DE4.ll'
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

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_3() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %75, %0
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader5

.preheader5:                                      ; preds = %1, %73
  %2 = phi i32 [ 0, %1 ], [ %74, %73 ]
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

.preheader6:                                      ; preds = %.preheader5, %70
  %3 = phi i32 [ %71, %70 ], [ 0, %.preheader5 ]
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader6, %68
  %4 = phi i32 [ 0, %.preheader6 ], [ %69, %68 ]
  %5 = shl nuw nsw i32 %4, 6
  %6 = shl nuw nsw i32 %4, 4
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %66
  %7 = phi i32 [ 0, %.preheader4 ], [ %67, %66 ]
  %8 = add nuw nsw i32 %7, %6
  %9 = trunc nuw nsw i32 %8 to i20
  %10 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %9
  %.promoted = load float, ptr %10, align 4
  br label %11

11:                                               ; preds = %11, %.preheader
  %12 = phi i32 [ 0, %.preheader ], [ %65, %11 ]
  %13 = phi float [ %.promoted, %.preheader ], [ %64, %11 ]
  %14 = add nuw nsw i32 %12, %3
  %15 = add nuw nsw i32 %12, %5
  %16 = trunc nuw nsw i32 %15 to i20
  %17 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %16
  %18 = load float, ptr %17, align 4
  %19 = shl nuw nsw i32 %14, 4
  %20 = add nuw nsw i32 %19, %7
  %21 = trunc nuw nsw i32 %20 to i20
  %22 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %21
  %23 = load float, ptr %22, align 4
  %24 = fmul float %18, %23
  %25 = fadd float %13, %24
  %26 = or disjoint i32 %12, 1
  %27 = add nuw nsw i32 %26, %3
  %28 = add nuw nsw i32 %26, %5
  %29 = trunc nuw nsw i32 %28 to i20
  %30 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %29
  %31 = load float, ptr %30, align 4
  %32 = shl nuw nsw i32 %27, 4
  %33 = add nuw nsw i32 %32, %7
  %34 = trunc nuw nsw i32 %33 to i20
  %35 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %34
  %36 = load float, ptr %35, align 4
  %37 = fmul float %31, %36
  %38 = fadd float %25, %37
  %39 = or disjoint i32 %12, 2
  %40 = add nuw nsw i32 %39, %3
  %41 = add nuw nsw i32 %39, %5
  %42 = trunc nuw nsw i32 %41 to i20
  %43 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %42
  %44 = load float, ptr %43, align 4
  %45 = shl nuw nsw i32 %40, 4
  %46 = add nuw nsw i32 %45, %7
  %47 = trunc nuw nsw i32 %46 to i20
  %48 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %47
  %49 = load float, ptr %48, align 4
  %50 = fmul float %44, %49
  %51 = fadd float %38, %50
  %52 = or disjoint i32 %12, 3
  %53 = add nuw nsw i32 %52, %3
  %54 = add nuw nsw i32 %52, %5
  %55 = trunc nuw nsw i32 %54 to i20
  %56 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %55
  %57 = load float, ptr %56, align 4
  %58 = shl nuw nsw i32 %53, 4
  %59 = add nuw nsw i32 %58, %7
  %60 = trunc nuw nsw i32 %59 to i20
  %61 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %60
  %62 = load float, ptr %61, align 4
  %63 = fmul float %57, %62
  %64 = fadd float %51, %63
  %65 = add nuw nsw i32 %12, 4
  %exitcond7.not.3 = icmp eq i32 %65, 64
  br i1 %exitcond7.not.3, label %66, label %11, !llvm.loop !1

66:                                               ; preds = %11
  store float %64, ptr %10, align 4
  %67 = add nuw nsw i32 %7, 1
  %exitcond8.not = icmp eq i32 %67, 16
  br i1 %exitcond8.not, label %68, label %.preheader, !llvm.loop !1

68:                                               ; preds = %66
  %69 = add nuw nsw i32 %4, 1
  %exitcond9.not = icmp eq i32 %69, 4
  br i1 %exitcond9.not, label %70, label %.preheader4, !llvm.loop !1

70:                                               ; preds = %68
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %71 = add nuw nsw i32 %3, 64
  %72 = icmp eq i32 %3, 0
  br i1 %72, label %.preheader6, label %73, !llvm.loop !1

73:                                               ; preds = %70
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %74 = add nuw nsw i32 %2, 1
  %exitcond10.not = icmp eq i32 %74, 8
  br i1 %exitcond10.not, label %75, label %.preheader5, !llvm.loop !1

75:                                               ; preds = %73
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
