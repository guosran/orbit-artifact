; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_3EF7032E570EAC0D.ll'
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

.loopexit:                                        ; preds = %196, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.loopexit, %.preheader
  %1 = phi i32 [ 8, %.loopexit ], [ %195, %.preheader ]
  %2 = shl nuw nsw i32 %1, 5
  %3 = add nuw nsw i32 %2, 1048320
  %4 = trunc i32 %3 to i20
  %5 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %4
  %6 = load float, ptr %5, align 4
  %7 = fmul float %6, 5.000000e-01
  %8 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %4
  store float %7, ptr %8, align 4
  %9 = add nuw nsw i32 %2, 1048321
  %10 = trunc i32 %9 to i20
  %11 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %10
  %12 = load float, ptr %11, align 4
  %13 = fmul float %12, 5.000000e-01
  %14 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %10
  store float %13, ptr %14, align 4
  %15 = add nuw nsw i32 %2, 1048322
  %16 = trunc i32 %15 to i20
  %17 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %16
  %18 = load float, ptr %17, align 4
  %19 = fmul float %18, 5.000000e-01
  %20 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %16
  store float %19, ptr %20, align 4
  %21 = add nuw nsw i32 %2, 1048323
  %22 = trunc i32 %21 to i20
  %23 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %22
  %24 = load float, ptr %23, align 4
  %25 = fmul float %24, 5.000000e-01
  %26 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %22
  store float %25, ptr %26, align 4
  %27 = add nuw nsw i32 %2, 1048324
  %28 = trunc i32 %27 to i20
  %29 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %28
  %30 = load float, ptr %29, align 4
  %31 = fmul float %30, 5.000000e-01
  %32 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %28
  store float %31, ptr %32, align 4
  %33 = add nuw nsw i32 %2, 1048325
  %34 = trunc i32 %33 to i20
  %35 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %34
  %36 = load float, ptr %35, align 4
  %37 = fmul float %36, 5.000000e-01
  %38 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %34
  store float %37, ptr %38, align 4
  %39 = add nuw nsw i32 %2, 1048326
  %40 = trunc i32 %39 to i20
  %41 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %40
  %42 = load float, ptr %41, align 4
  %43 = fmul float %42, 5.000000e-01
  %44 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %40
  store float %43, ptr %44, align 4
  %45 = add nuw nsw i32 %2, 1048327
  %46 = trunc i32 %45 to i20
  %47 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %46
  %48 = load float, ptr %47, align 4
  %49 = fmul float %48, 5.000000e-01
  %50 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %46
  store float %49, ptr %50, align 4
  %51 = add nuw nsw i32 %2, 1048328
  %52 = trunc i32 %51 to i20
  %53 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %52
  %54 = load float, ptr %53, align 4
  %55 = fmul float %54, 5.000000e-01
  %56 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %52
  store float %55, ptr %56, align 4
  %57 = add nuw nsw i32 %2, 1048329
  %58 = trunc i32 %57 to i20
  %59 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %58
  %60 = load float, ptr %59, align 4
  %61 = fmul float %60, 5.000000e-01
  %62 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %58
  store float %61, ptr %62, align 4
  %63 = add nuw nsw i32 %2, 1048330
  %64 = trunc i32 %63 to i20
  %65 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %64
  %66 = load float, ptr %65, align 4
  %67 = fmul float %66, 5.000000e-01
  %68 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %64
  store float %67, ptr %68, align 4
  %69 = add nuw nsw i32 %2, 1048331
  %70 = trunc i32 %69 to i20
  %71 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %70
  %72 = load float, ptr %71, align 4
  %73 = fmul float %72, 5.000000e-01
  %74 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %70
  store float %73, ptr %74, align 4
  %75 = add nuw nsw i32 %2, 1048332
  %76 = trunc i32 %75 to i20
  %77 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %76
  %78 = load float, ptr %77, align 4
  %79 = fmul float %78, 5.000000e-01
  %80 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %76
  store float %79, ptr %80, align 4
  %81 = add nuw nsw i32 %2, 1048333
  %82 = trunc i32 %81 to i20
  %83 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %82
  %84 = load float, ptr %83, align 4
  %85 = fmul float %84, 5.000000e-01
  %86 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %82
  store float %85, ptr %86, align 4
  %87 = add nuw nsw i32 %2, 1048334
  %88 = trunc i32 %87 to i20
  %89 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %88
  %90 = load float, ptr %89, align 4
  %91 = fmul float %90, 5.000000e-01
  %92 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %88
  store float %91, ptr %92, align 4
  %93 = add nuw nsw i32 %2, 1048335
  %94 = trunc i32 %93 to i20
  %95 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %94
  %96 = load float, ptr %95, align 4
  %97 = fmul float %96, 5.000000e-01
  %98 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %94
  store float %97, ptr %98, align 4
  %99 = add nuw nsw i32 %2, 1048336
  %100 = trunc i32 %99 to i20
  %101 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %100
  %102 = load float, ptr %101, align 4
  %103 = fmul float %102, 5.000000e-01
  %104 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %100
  store float %103, ptr %104, align 4
  %105 = add nuw nsw i32 %2, 1048337
  %106 = trunc i32 %105 to i20
  %107 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %106
  %108 = load float, ptr %107, align 4
  %109 = fmul float %108, 5.000000e-01
  %110 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %106
  store float %109, ptr %110, align 4
  %111 = add nuw nsw i32 %2, 1048338
  %112 = trunc i32 %111 to i20
  %113 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %112
  %114 = load float, ptr %113, align 4
  %115 = fmul float %114, 5.000000e-01
  %116 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %112
  store float %115, ptr %116, align 4
  %117 = add nuw nsw i32 %2, 1048339
  %118 = trunc i32 %117 to i20
  %119 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %118
  %120 = load float, ptr %119, align 4
  %121 = fmul float %120, 5.000000e-01
  %122 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %118
  store float %121, ptr %122, align 4
  %123 = add nuw nsw i32 %2, 1048340
  %124 = trunc i32 %123 to i20
  %125 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %124
  %126 = load float, ptr %125, align 4
  %127 = fmul float %126, 5.000000e-01
  %128 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %124
  store float %127, ptr %128, align 4
  %129 = add nuw nsw i32 %2, 1048341
  %130 = trunc i32 %129 to i20
  %131 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %130
  %132 = load float, ptr %131, align 4
  %133 = fmul float %132, 5.000000e-01
  %134 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %130
  store float %133, ptr %134, align 4
  %135 = add nuw nsw i32 %2, 1048342
  %136 = trunc i32 %135 to i20
  %137 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %136
  %138 = load float, ptr %137, align 4
  %139 = fmul float %138, 5.000000e-01
  %140 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %136
  store float %139, ptr %140, align 4
  %141 = add nuw nsw i32 %2, 1048343
  %142 = trunc i32 %141 to i20
  %143 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %142
  %144 = load float, ptr %143, align 4
  %145 = fmul float %144, 5.000000e-01
  %146 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %142
  store float %145, ptr %146, align 4
  %147 = add nuw nsw i32 %2, 1048344
  %148 = trunc i32 %147 to i20
  %149 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %148
  %150 = load float, ptr %149, align 4
  %151 = fmul float %150, 5.000000e-01
  %152 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %148
  store float %151, ptr %152, align 4
  %153 = add nuw nsw i32 %2, 1048345
  %154 = trunc i32 %153 to i20
  %155 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %154
  %156 = load float, ptr %155, align 4
  %157 = fmul float %156, 5.000000e-01
  %158 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %154
  store float %157, ptr %158, align 4
  %159 = add nuw nsw i32 %2, 1048346
  %160 = trunc i32 %159 to i20
  %161 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %160
  %162 = load float, ptr %161, align 4
  %163 = fmul float %162, 5.000000e-01
  %164 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %160
  store float %163, ptr %164, align 4
  %165 = add nuw nsw i32 %2, 1048347
  %166 = trunc i32 %165 to i20
  %167 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %166
  %168 = load float, ptr %167, align 4
  %169 = fmul float %168, 5.000000e-01
  %170 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %166
  store float %169, ptr %170, align 4
  %171 = add nuw nsw i32 %2, 1048348
  %172 = trunc i32 %171 to i20
  %173 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %172
  %174 = load float, ptr %173, align 4
  %175 = fmul float %174, 5.000000e-01
  %176 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %172
  store float %175, ptr %176, align 4
  %177 = add nuw nsw i32 %2, 1048349
  %178 = trunc i32 %177 to i20
  %179 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %178
  %180 = load float, ptr %179, align 4
  %181 = fmul float %180, 5.000000e-01
  %182 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %178
  store float %181, ptr %182, align 4
  %183 = add nuw nsw i32 %2, 1048350
  %184 = trunc i32 %183 to i20
  %185 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %184
  %186 = load float, ptr %185, align 4
  %187 = fmul float %186, 5.000000e-01
  %188 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %184
  store float %187, ptr %188, align 4
  %189 = add nuw nsw i32 %2, 1048351
  %190 = trunc i32 %189 to i20
  %191 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %190
  %192 = load float, ptr %191, align 4
  %193 = fmul float %192, 5.000000e-01
  %194 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %190
  store float %193, ptr %194, align 4
  %195 = add nuw nsw i32 %1, 1
  %exitcond.not = icmp eq i32 %195, 16
  br i1 %exitcond.not, label %196, label %.preheader, !llvm.loop !1

196:                                              ; preds = %.preheader
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
