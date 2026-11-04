; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_389A4D6503BB94C6.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [256 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [256 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %.loopexit

.loopexit:                                        ; preds = %195, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.loopexit, %.preheader
  %1 = phi i32 [ 0, %.loopexit ], [ %194, %.preheader ]
  %2 = shl nuw nsw i32 %1, 5
  %3 = trunc nuw nsw i32 %2 to i20
  %4 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %3
  %5 = load float, ptr %4, align 4
  %6 = fmul float %5, 5.000000e-01
  %7 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %3
  store float %6, ptr %7, align 4
  %8 = or disjoint i32 %2, 1
  %9 = trunc nuw nsw i32 %8 to i20
  %10 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %9
  %11 = load float, ptr %10, align 4
  %12 = fmul float %11, 5.000000e-01
  %13 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %9
  store float %12, ptr %13, align 4
  %14 = or disjoint i32 %2, 2
  %15 = trunc nuw nsw i32 %14 to i20
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %15
  %17 = load float, ptr %16, align 4
  %18 = fmul float %17, 5.000000e-01
  %19 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %15
  store float %18, ptr %19, align 4
  %20 = or disjoint i32 %2, 3
  %21 = trunc nuw nsw i32 %20 to i20
  %22 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %21
  %23 = load float, ptr %22, align 4
  %24 = fmul float %23, 5.000000e-01
  %25 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %21
  store float %24, ptr %25, align 4
  %26 = or disjoint i32 %2, 4
  %27 = trunc nuw nsw i32 %26 to i20
  %28 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %27
  %29 = load float, ptr %28, align 4
  %30 = fmul float %29, 5.000000e-01
  %31 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %27
  store float %30, ptr %31, align 4
  %32 = or disjoint i32 %2, 5
  %33 = trunc nuw nsw i32 %32 to i20
  %34 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %33
  %35 = load float, ptr %34, align 4
  %36 = fmul float %35, 5.000000e-01
  %37 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %33
  store float %36, ptr %37, align 4
  %38 = or disjoint i32 %2, 6
  %39 = trunc nuw nsw i32 %38 to i20
  %40 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %39
  %41 = load float, ptr %40, align 4
  %42 = fmul float %41, 5.000000e-01
  %43 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %39
  store float %42, ptr %43, align 4
  %44 = or disjoint i32 %2, 7
  %45 = trunc nuw nsw i32 %44 to i20
  %46 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %45
  %47 = load float, ptr %46, align 4
  %48 = fmul float %47, 5.000000e-01
  %49 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %45
  store float %48, ptr %49, align 4
  %50 = or disjoint i32 %2, 8
  %51 = trunc nuw nsw i32 %50 to i20
  %52 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %51
  %53 = load float, ptr %52, align 4
  %54 = fmul float %53, 5.000000e-01
  %55 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %51
  store float %54, ptr %55, align 4
  %56 = or disjoint i32 %2, 9
  %57 = trunc nuw nsw i32 %56 to i20
  %58 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %57
  %59 = load float, ptr %58, align 4
  %60 = fmul float %59, 5.000000e-01
  %61 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %57
  store float %60, ptr %61, align 4
  %62 = or disjoint i32 %2, 10
  %63 = trunc nuw nsw i32 %62 to i20
  %64 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %63
  %65 = load float, ptr %64, align 4
  %66 = fmul float %65, 5.000000e-01
  %67 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %63
  store float %66, ptr %67, align 4
  %68 = or disjoint i32 %2, 11
  %69 = trunc nuw nsw i32 %68 to i20
  %70 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %69
  %71 = load float, ptr %70, align 4
  %72 = fmul float %71, 5.000000e-01
  %73 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %69
  store float %72, ptr %73, align 4
  %74 = or disjoint i32 %2, 12
  %75 = trunc nuw nsw i32 %74 to i20
  %76 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %75
  %77 = load float, ptr %76, align 4
  %78 = fmul float %77, 5.000000e-01
  %79 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %75
  store float %78, ptr %79, align 4
  %80 = or disjoint i32 %2, 13
  %81 = trunc nuw nsw i32 %80 to i20
  %82 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %81
  %83 = load float, ptr %82, align 4
  %84 = fmul float %83, 5.000000e-01
  %85 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %81
  store float %84, ptr %85, align 4
  %86 = or disjoint i32 %2, 14
  %87 = trunc nuw nsw i32 %86 to i20
  %88 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %87
  %89 = load float, ptr %88, align 4
  %90 = fmul float %89, 5.000000e-01
  %91 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %87
  store float %90, ptr %91, align 4
  %92 = or disjoint i32 %2, 15
  %93 = trunc nuw nsw i32 %92 to i20
  %94 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %93
  %95 = load float, ptr %94, align 4
  %96 = fmul float %95, 5.000000e-01
  %97 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %93
  store float %96, ptr %97, align 4
  %98 = or disjoint i32 %2, 16
  %99 = trunc nuw nsw i32 %98 to i20
  %100 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %99
  %101 = load float, ptr %100, align 4
  %102 = fmul float %101, 5.000000e-01
  %103 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %99
  store float %102, ptr %103, align 4
  %104 = or disjoint i32 %2, 17
  %105 = trunc nuw nsw i32 %104 to i20
  %106 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %105
  %107 = load float, ptr %106, align 4
  %108 = fmul float %107, 5.000000e-01
  %109 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %105
  store float %108, ptr %109, align 4
  %110 = or disjoint i32 %2, 18
  %111 = trunc nuw nsw i32 %110 to i20
  %112 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %111
  %113 = load float, ptr %112, align 4
  %114 = fmul float %113, 5.000000e-01
  %115 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %111
  store float %114, ptr %115, align 4
  %116 = or disjoint i32 %2, 19
  %117 = trunc nuw nsw i32 %116 to i20
  %118 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %117
  %119 = load float, ptr %118, align 4
  %120 = fmul float %119, 5.000000e-01
  %121 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %117
  store float %120, ptr %121, align 4
  %122 = or disjoint i32 %2, 20
  %123 = trunc nuw nsw i32 %122 to i20
  %124 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %123
  %125 = load float, ptr %124, align 4
  %126 = fmul float %125, 5.000000e-01
  %127 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %123
  store float %126, ptr %127, align 4
  %128 = or disjoint i32 %2, 21
  %129 = trunc nuw nsw i32 %128 to i20
  %130 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %129
  %131 = load float, ptr %130, align 4
  %132 = fmul float %131, 5.000000e-01
  %133 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %129
  store float %132, ptr %133, align 4
  %134 = or disjoint i32 %2, 22
  %135 = trunc nuw nsw i32 %134 to i20
  %136 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %135
  %137 = load float, ptr %136, align 4
  %138 = fmul float %137, 5.000000e-01
  %139 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %135
  store float %138, ptr %139, align 4
  %140 = or disjoint i32 %2, 23
  %141 = trunc nuw nsw i32 %140 to i20
  %142 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %141
  %143 = load float, ptr %142, align 4
  %144 = fmul float %143, 5.000000e-01
  %145 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %141
  store float %144, ptr %145, align 4
  %146 = or disjoint i32 %2, 24
  %147 = trunc nuw nsw i32 %146 to i20
  %148 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %147
  %149 = load float, ptr %148, align 4
  %150 = fmul float %149, 5.000000e-01
  %151 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %147
  store float %150, ptr %151, align 4
  %152 = or disjoint i32 %2, 25
  %153 = trunc nuw nsw i32 %152 to i20
  %154 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %153
  %155 = load float, ptr %154, align 4
  %156 = fmul float %155, 5.000000e-01
  %157 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %153
  store float %156, ptr %157, align 4
  %158 = or disjoint i32 %2, 26
  %159 = trunc nuw nsw i32 %158 to i20
  %160 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %159
  %161 = load float, ptr %160, align 4
  %162 = fmul float %161, 5.000000e-01
  %163 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %159
  store float %162, ptr %163, align 4
  %164 = or disjoint i32 %2, 27
  %165 = trunc nuw nsw i32 %164 to i20
  %166 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %165
  %167 = load float, ptr %166, align 4
  %168 = fmul float %167, 5.000000e-01
  %169 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %165
  store float %168, ptr %169, align 4
  %170 = or disjoint i32 %2, 28
  %171 = trunc nuw nsw i32 %170 to i20
  %172 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %171
  %173 = load float, ptr %172, align 4
  %174 = fmul float %173, 5.000000e-01
  %175 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %171
  store float %174, ptr %175, align 4
  %176 = or disjoint i32 %2, 29
  %177 = trunc nuw nsw i32 %176 to i20
  %178 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %177
  %179 = load float, ptr %178, align 4
  %180 = fmul float %179, 5.000000e-01
  %181 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %177
  store float %180, ptr %181, align 4
  %182 = or disjoint i32 %2, 30
  %183 = trunc nuw nsw i32 %182 to i20
  %184 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %183
  %185 = load float, ptr %184, align 4
  %186 = fmul float %185, 5.000000e-01
  %187 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %183
  store float %186, ptr %187, align 4
  %188 = or disjoint i32 %2, 31
  %189 = trunc nuw nsw i32 %188 to i20
  %190 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %189
  %191 = load float, ptr %190, align 4
  %192 = fmul float %191, 5.000000e-01
  %193 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %189
  store float %192, ptr %193, align 4
  %194 = add nuw nsw i32 %1, 1
  %exitcond.not = icmp eq i32 %194, 8
  br i1 %exitcond.not, label %195, label %.preheader, !llvm.loop !1

195:                                              ; preds = %.preheader
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %.loopexit, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
