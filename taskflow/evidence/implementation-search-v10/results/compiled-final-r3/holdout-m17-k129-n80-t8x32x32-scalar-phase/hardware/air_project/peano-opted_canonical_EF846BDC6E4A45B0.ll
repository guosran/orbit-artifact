; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_EF846BDC6E4A45B0.ll'
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

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_5() local_unnamed_addr #1 {
  br label %.preheader4.preheader

.preheader4.preheader:                            ; preds = %56, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(128) @__aiecc_canon_2, i8 0, i64 128, i1 false)
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader4.preheader, %54
  %1 = phi i32 [ %55, %54 ], [ 0, %.preheader4.preheader ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 54, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.preheader4, %52
  %2 = phi i32 [ 0, %.preheader4 ], [ %53, %52 ]
  %3 = trunc nuw nsw i32 %2 to i20
  %4 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %3
  %.promoted = load float, ptr %4, align 4
  br label %5

5:                                                ; preds = %5, %.preheader
  %6 = phi i32 [ 0, %.preheader ], [ %51, %5 ]
  %7 = phi float [ %.promoted, %.preheader ], [ %50, %5 ]
  %8 = trunc nuw nsw i32 %6 to i20
  %9 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %8
  %10 = load float, ptr %9, align 4
  %11 = shl nuw nsw i32 %6, 5
  %12 = add nuw nsw i32 %11, %2
  %13 = trunc nuw nsw i32 %12 to i20
  %14 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %13
  %15 = load float, ptr %14, align 4
  %16 = fmul float %10, %15
  %17 = fadd float %7, %16
  %18 = or disjoint i32 %6, 1
  %19 = trunc nuw nsw i32 %18 to i20
  %20 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %19
  %21 = load float, ptr %20, align 4
  %22 = shl nuw nsw i32 %18, 5
  %23 = add nuw nsw i32 %22, %2
  %24 = trunc nuw nsw i32 %23 to i20
  %25 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %24
  %26 = load float, ptr %25, align 4
  %27 = fmul float %21, %26
  %28 = fadd float %17, %27
  %29 = or disjoint i32 %6, 2
  %30 = trunc nuw nsw i32 %29 to i20
  %31 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %30
  %32 = load float, ptr %31, align 4
  %33 = shl nuw nsw i32 %29, 5
  %34 = add nuw nsw i32 %33, %2
  %35 = trunc nuw nsw i32 %34 to i20
  %36 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %35
  %37 = load float, ptr %36, align 4
  %38 = fmul float %32, %37
  %39 = fadd float %28, %38
  %40 = or disjoint i32 %6, 3
  %41 = trunc nuw nsw i32 %40 to i20
  %42 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %41
  %43 = load float, ptr %42, align 4
  %44 = shl nuw nsw i32 %40, 5
  %45 = add nuw nsw i32 %44, %2
  %46 = trunc nuw nsw i32 %45 to i20
  %47 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %46
  %48 = load float, ptr %47, align 4
  %49 = fmul float %43, %48
  %50 = fadd float %39, %49
  %51 = add nuw nsw i32 %6, 4
  %exitcond.not.3 = icmp eq i32 %51, 32
  br i1 %exitcond.not.3, label %52, label %5, !llvm.loop !1

52:                                               ; preds = %5
  store float %50, ptr %4, align 4
  %53 = add nuw nsw i32 %2, 1
  %exitcond5.not = icmp eq i32 %53, 32
  br i1 %exitcond5.not, label %54, label %.preheader, !llvm.loop !1

54:                                               ; preds = %52
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 55, i32 1)
  %55 = add nuw nsw i32 %1, 1
  %exitcond6.not = icmp eq i32 %55, 4
  br i1 %exitcond6.not, label %56, label %.preheader4, !llvm.loop !1

56:                                               ; preds = %54
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 56, i32 -1)
  %57 = load float, ptr @__aiecc_canon_4, align 4
  %58 = load float, ptr @__aiecc_canon_3, align 4
  %59 = load float, ptr @__aiecc_canon_2, align 4
  %60 = fmul float %57, %58
  %61 = fadd float %59, %60
  store float %61, ptr @__aiecc_canon_2, align 4
  %62 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 4), align 4
  %63 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 4), align 4
  %64 = fmul float %57, %62
  %65 = fadd float %63, %64
  store float %65, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 4), align 4
  %66 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 8), align 4
  %67 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 8), align 4
  %68 = fmul float %57, %66
  %69 = fadd float %67, %68
  store float %69, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 8), align 4
  %70 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 12), align 4
  %71 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 12), align 4
  %72 = fmul float %57, %70
  %73 = fadd float %71, %72
  store float %73, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 12), align 4
  %74 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 16), align 4
  %75 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 16), align 4
  %76 = fmul float %57, %74
  %77 = fadd float %75, %76
  store float %77, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 16), align 4
  %78 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 20), align 4
  %79 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 20), align 4
  %80 = fmul float %57, %78
  %81 = fadd float %79, %80
  store float %81, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 20), align 4
  %82 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 24), align 4
  %83 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 24), align 4
  %84 = fmul float %57, %82
  %85 = fadd float %83, %84
  store float %85, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 24), align 4
  %86 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 28), align 4
  %87 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 28), align 4
  %88 = fmul float %57, %86
  %89 = fadd float %87, %88
  store float %89, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 28), align 4
  %90 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 32), align 4
  %91 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 32), align 4
  %92 = fmul float %57, %90
  %93 = fadd float %91, %92
  store float %93, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 32), align 4
  %94 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 36), align 4
  %95 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 36), align 4
  %96 = fmul float %57, %94
  %97 = fadd float %95, %96
  store float %97, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 36), align 4
  %98 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 40), align 4
  %99 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 40), align 4
  %100 = fmul float %57, %98
  %101 = fadd float %99, %100
  store float %101, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 40), align 4
  %102 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 44), align 4
  %103 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 44), align 4
  %104 = fmul float %57, %102
  %105 = fadd float %103, %104
  store float %105, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 44), align 4
  %106 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 48), align 4
  %107 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 48), align 4
  %108 = fmul float %57, %106
  %109 = fadd float %107, %108
  store float %109, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 48), align 4
  %110 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 52), align 4
  %111 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 52), align 4
  %112 = fmul float %57, %110
  %113 = fadd float %111, %112
  store float %113, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 52), align 4
  %114 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 56), align 4
  %115 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 56), align 4
  %116 = fmul float %57, %114
  %117 = fadd float %115, %116
  store float %117, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 56), align 4
  %118 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 60), align 4
  %119 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 60), align 4
  %120 = fmul float %57, %118
  %121 = fadd float %119, %120
  store float %121, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 60), align 4
  %122 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 64), align 4
  %123 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 64), align 4
  %124 = fmul float %57, %122
  %125 = fadd float %123, %124
  store float %125, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 64), align 4
  %126 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 68), align 4
  %127 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 68), align 4
  %128 = fmul float %57, %126
  %129 = fadd float %127, %128
  store float %129, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 68), align 4
  %130 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 72), align 4
  %131 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 72), align 4
  %132 = fmul float %57, %130
  %133 = fadd float %131, %132
  store float %133, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 72), align 4
  %134 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 76), align 4
  %135 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 76), align 4
  %136 = fmul float %57, %134
  %137 = fadd float %135, %136
  store float %137, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 76), align 4
  %138 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 80), align 4
  %139 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 80), align 4
  %140 = fmul float %57, %138
  %141 = fadd float %139, %140
  store float %141, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 80), align 4
  %142 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 84), align 4
  %143 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 84), align 4
  %144 = fmul float %57, %142
  %145 = fadd float %143, %144
  store float %145, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 84), align 4
  %146 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 88), align 4
  %147 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 88), align 4
  %148 = fmul float %57, %146
  %149 = fadd float %147, %148
  store float %149, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 88), align 4
  %150 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 92), align 4
  %151 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 92), align 4
  %152 = fmul float %57, %150
  %153 = fadd float %151, %152
  store float %153, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 92), align 4
  %154 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 96), align 4
  %155 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 96), align 4
  %156 = fmul float %57, %154
  %157 = fadd float %155, %156
  store float %157, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 96), align 4
  %158 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 100), align 4
  %159 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 100), align 4
  %160 = fmul float %57, %158
  %161 = fadd float %159, %160
  store float %161, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 100), align 4
  %162 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 104), align 4
  %163 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 104), align 4
  %164 = fmul float %57, %162
  %165 = fadd float %163, %164
  store float %165, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 104), align 4
  %166 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 108), align 4
  %167 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 108), align 4
  %168 = fmul float %57, %166
  %169 = fadd float %167, %168
  store float %169, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 108), align 4
  %170 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 112), align 4
  %171 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 112), align 4
  %172 = fmul float %57, %170
  %173 = fadd float %171, %172
  store float %173, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 112), align 4
  %174 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 116), align 4
  %175 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 116), align 4
  %176 = fmul float %57, %174
  %177 = fadd float %175, %176
  store float %177, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 116), align 4
  %178 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 120), align 4
  %179 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 120), align 4
  %180 = fmul float %57, %178
  %181 = fadd float %179, %180
  store float %181, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 120), align 4
  %182 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 124), align 4
  %183 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 124), align 4
  %184 = fmul float %57, %182
  %185 = fadd float %183, %184
  store float %185, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 124), align 4
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 57, i32 1)
  br label %.preheader4.preheader
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
