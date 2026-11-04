; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_51B599E972A8953D.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [512 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [16 x float]
@__aiecc_canon_3 = external local_unnamed_addr global [16 x float]
@__aiecc_canon_4 = external local_unnamed_addr global [1 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_5() local_unnamed_addr #1 {
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %58, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(64) @__aiecc_canon_2, i8 0, i64 64, i1 false)
  br label %.preheader

.preheader:                                       ; preds = %.preheader.preheader, %56
  %1 = phi i32 [ %57, %56 ], [ 0, %.preheader.preheader ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 54, i32 -1)
  br label %2

2:                                                ; preds = %.preheader, %54
  %3 = phi i32 [ 64, %.preheader ], [ %55, %54 ]
  %4 = add nsw i32 %3, -64
  %5 = trunc nuw nsw i32 %4 to i20
  %6 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %5
  %.promoted = load float, ptr %6, align 4
  br label %7

7:                                                ; preds = %7, %2
  %8 = phi i32 [ 0, %2 ], [ %53, %7 ]
  %9 = phi float [ %.promoted, %2 ], [ %52, %7 ]
  %10 = trunc nuw nsw i32 %8 to i20
  %11 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %10
  %12 = load float, ptr %11, align 4
  %13 = shl nuw nsw i32 %8, 4
  %14 = add nuw nsw i32 %13, %4
  %15 = trunc nuw nsw i32 %14 to i20
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %15
  %17 = load float, ptr %16, align 4
  %18 = fmul float %12, %17
  %19 = fadd float %9, %18
  %20 = or disjoint i32 %8, 1
  %21 = trunc nuw nsw i32 %20 to i20
  %22 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %21
  %23 = load float, ptr %22, align 4
  %24 = shl nuw nsw i32 %20, 4
  %25 = add nuw nsw i32 %24, %4
  %26 = trunc nuw nsw i32 %25 to i20
  %27 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %26
  %28 = load float, ptr %27, align 4
  %29 = fmul float %23, %28
  %30 = fadd float %19, %29
  %31 = or disjoint i32 %8, 2
  %32 = trunc nuw nsw i32 %31 to i20
  %33 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %32
  %34 = load float, ptr %33, align 4
  %35 = shl nuw nsw i32 %31, 4
  %36 = add nuw nsw i32 %35, %4
  %37 = trunc nuw nsw i32 %36 to i20
  %38 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %37
  %39 = load float, ptr %38, align 4
  %40 = fmul float %34, %39
  %41 = fadd float %30, %40
  %42 = or disjoint i32 %8, 3
  %43 = trunc nuw nsw i32 %42 to i20
  %44 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %43
  %45 = load float, ptr %44, align 4
  %46 = shl nuw nsw i32 %42, 4
  %47 = add nuw nsw i32 %46, %4
  %48 = trunc nuw nsw i32 %47 to i20
  %49 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %48
  %50 = load float, ptr %49, align 4
  %51 = fmul float %45, %50
  %52 = fadd float %41, %51
  %53 = add nuw nsw i32 %8, 4
  %exitcond.not.3 = icmp eq i32 %53, 32
  br i1 %exitcond.not.3, label %54, label %7, !llvm.loop !1

54:                                               ; preds = %7
  store float %52, ptr %6, align 4
  %55 = add nuw nsw i32 %3, 1
  %exitcond5.not = icmp eq i32 %55, 80
  br i1 %exitcond5.not, label %56, label %2, !llvm.loop !1

56:                                               ; preds = %54
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 55, i32 1)
  %57 = add nuw nsw i32 %1, 1
  %exitcond6.not = icmp eq i32 %57, 4
  br i1 %exitcond6.not, label %58, label %.preheader, !llvm.loop !1

58:                                               ; preds = %56
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 56, i32 -1)
  %59 = load float, ptr @__aiecc_canon_4, align 4
  %60 = load float, ptr @__aiecc_canon_3, align 4
  %61 = load float, ptr @__aiecc_canon_2, align 4
  %62 = fmul float %59, %60
  %63 = fadd float %61, %62
  store float %63, ptr @__aiecc_canon_2, align 4
  %64 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 4), align 4
  %65 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 4), align 4
  %66 = fmul float %59, %64
  %67 = fadd float %65, %66
  store float %67, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 4), align 4
  %68 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 8), align 4
  %69 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 8), align 4
  %70 = fmul float %59, %68
  %71 = fadd float %69, %70
  store float %71, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 8), align 4
  %72 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 12), align 4
  %73 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 12), align 4
  %74 = fmul float %59, %72
  %75 = fadd float %73, %74
  store float %75, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 12), align 4
  %76 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 16), align 4
  %77 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 16), align 4
  %78 = fmul float %59, %76
  %79 = fadd float %77, %78
  store float %79, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 16), align 4
  %80 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 20), align 4
  %81 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 20), align 4
  %82 = fmul float %59, %80
  %83 = fadd float %81, %82
  store float %83, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 20), align 4
  %84 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 24), align 4
  %85 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 24), align 4
  %86 = fmul float %59, %84
  %87 = fadd float %85, %86
  store float %87, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 24), align 4
  %88 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 28), align 4
  %89 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 28), align 4
  %90 = fmul float %59, %88
  %91 = fadd float %89, %90
  store float %91, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 28), align 4
  %92 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 32), align 4
  %93 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 32), align 4
  %94 = fmul float %59, %92
  %95 = fadd float %93, %94
  store float %95, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 32), align 4
  %96 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 36), align 4
  %97 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 36), align 4
  %98 = fmul float %59, %96
  %99 = fadd float %97, %98
  store float %99, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 36), align 4
  %100 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 40), align 4
  %101 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 40), align 4
  %102 = fmul float %59, %100
  %103 = fadd float %101, %102
  store float %103, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 40), align 4
  %104 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 44), align 4
  %105 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 44), align 4
  %106 = fmul float %59, %104
  %107 = fadd float %105, %106
  store float %107, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 44), align 4
  %108 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 48), align 4
  %109 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 48), align 4
  %110 = fmul float %59, %108
  %111 = fadd float %109, %110
  store float %111, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 48), align 4
  %112 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 52), align 4
  %113 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 52), align 4
  %114 = fmul float %59, %112
  %115 = fadd float %113, %114
  store float %115, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 52), align 4
  %116 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 56), align 4
  %117 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 56), align 4
  %118 = fmul float %59, %116
  %119 = fadd float %117, %118
  store float %119, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 56), align 4
  %120 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 60), align 4
  %121 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 60), align 4
  %122 = fmul float %59, %120
  %123 = fadd float %121, %122
  store float %123, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 60), align 4
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 57, i32 1)
  br label %.preheader.preheader
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #2

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
