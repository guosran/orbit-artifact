; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/ffn-profiling-v9/baseline/m8/full/hardware/air_project/canonical_CEE3EA7194312008.ll'
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

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_3() local_unnamed_addr #1 {
  br label %.loopexit

.loopexit:                                        ; preds = %88, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %88 ]
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

.preheader6:                                      ; preds = %22, %86
  %24 = phi i32 [ %87, %86 ], [ 0, %22 ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader6, %84
  %25 = phi i32 [ 0, %.preheader6 ], [ %85, %84 ]
  %26 = shl nuw nsw i32 %25, 6
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %82
  %27 = phi i32 [ 0, %.preheader4 ], [ %83, %82 ]
  %28 = add nuw nsw i32 %27, %26
  %29 = trunc nuw nsw i32 %28 to i20
  %30 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %29
  %.promoted = load float, ptr %30, align 4
  br label %31

31:                                               ; preds = %31, %.preheader
  %32 = phi i32 [ 0, %.preheader ], [ %81, %31 ]
  %33 = phi float [ %.promoted, %.preheader ], [ %80, %31 ]
  %34 = or disjoint i32 %32, %26
  %35 = trunc nuw nsw i32 %34 to i20
  %36 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %35
  %37 = load float, ptr %36, align 4
  %38 = shl nuw nsw i32 %32, 6
  %39 = add nuw nsw i32 %38, %27
  %40 = trunc nuw nsw i32 %39 to i20
  %41 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %40
  %42 = load float, ptr %41, align 4
  %43 = fmul float %37, %42
  %44 = fadd float %33, %43
  %45 = or disjoint i32 %32, 1
  %46 = or disjoint i32 %45, %26
  %47 = trunc nuw nsw i32 %46 to i20
  %48 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %47
  %49 = load float, ptr %48, align 4
  %50 = shl nuw nsw i32 %45, 6
  %51 = add nuw nsw i32 %50, %27
  %52 = trunc nuw nsw i32 %51 to i20
  %53 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %52
  %54 = load float, ptr %53, align 4
  %55 = fmul float %49, %54
  %56 = fadd float %44, %55
  %57 = or disjoint i32 %32, 2
  %58 = or disjoint i32 %57, %26
  %59 = trunc nuw nsw i32 %58 to i20
  %60 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %59
  %61 = load float, ptr %60, align 4
  %62 = shl nuw nsw i32 %57, 6
  %63 = add nuw nsw i32 %62, %27
  %64 = trunc nuw nsw i32 %63 to i20
  %65 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %64
  %66 = load float, ptr %65, align 4
  %67 = fmul float %61, %66
  %68 = fadd float %56, %67
  %69 = or disjoint i32 %32, 3
  %70 = or disjoint i32 %69, %26
  %71 = trunc nuw nsw i32 %70 to i20
  %72 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %71
  %73 = load float, ptr %72, align 4
  %74 = shl nuw nsw i32 %69, 6
  %75 = add nuw nsw i32 %74, %27
  %76 = trunc nuw nsw i32 %75 to i20
  %77 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %76
  %78 = load float, ptr %77, align 4
  %79 = fmul float %73, %78
  %80 = fadd float %68, %79
  %81 = add nuw nsw i32 %32, 4
  %exitcond8.not.3 = icmp eq i32 %81, 64
  br i1 %exitcond8.not.3, label %82, label %31, !llvm.loop !1

82:                                               ; preds = %31
  store float %80, ptr %30, align 4
  %83 = add nuw nsw i32 %27, 1
  %exitcond9.not = icmp eq i32 %83, 64
  br i1 %exitcond9.not, label %84, label %.preheader, !llvm.loop !1

84:                                               ; preds = %82
  %85 = add nuw nsw i32 %25, 1
  %exitcond10.not = icmp eq i32 %85, 8
  br i1 %exitcond10.not, label %86, label %.preheader4, !llvm.loop !1

86:                                               ; preds = %84
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %87 = add nuw nsw i32 %24, 1
  %exitcond11.not = icmp eq i32 %87, 32
  br i1 %exitcond11.not, label %88, label %.preheader6, !llvm.loop !1

88:                                               ; preds = %86
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %89 = add nuw nsw i32 %1, 1
  %exitcond12.not = icmp eq i32 %89, 172
  %spec.select = select i1 %exitcond12.not, i32 0, i32 %89
  br label %.loopexit, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
