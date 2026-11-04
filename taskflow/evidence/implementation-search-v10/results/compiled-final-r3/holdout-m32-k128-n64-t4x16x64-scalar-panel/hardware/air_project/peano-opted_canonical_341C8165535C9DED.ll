; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m32-k128-n64-t4x16x64-scalar-panel/hardware/air_project/canonical_341C8165535C9DED.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [64 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [64 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %.preheader2

.preheader2:                                      ; preds = %132, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %132 ]
  br label %.preheader

.preheader:                                       ; preds = %.preheader2, %.preheader
  %2 = phi i32 [ 0, %.preheader2 ], [ %131, %.preheader ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  %3 = load float, ptr @__aiecc_canon_1, align 4
  %4 = fmul float %3, 5.000000e-01
  store float %4, ptr @__aiecc_canon_0, align 4
  %5 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 4), align 4
  %6 = fmul float %5, 5.000000e-01
  store float %6, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 4), align 4
  %7 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 8), align 4
  %8 = fmul float %7, 5.000000e-01
  store float %8, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 8), align 4
  %9 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 12), align 4
  %10 = fmul float %9, 5.000000e-01
  store float %10, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 12), align 4
  %11 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 16), align 4
  %12 = fmul float %11, 5.000000e-01
  store float %12, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 16), align 4
  %13 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 20), align 4
  %14 = fmul float %13, 5.000000e-01
  store float %14, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 20), align 4
  %15 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 24), align 4
  %16 = fmul float %15, 5.000000e-01
  store float %16, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 24), align 4
  %17 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 28), align 4
  %18 = fmul float %17, 5.000000e-01
  store float %18, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 28), align 4
  %19 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 32), align 4
  %20 = fmul float %19, 5.000000e-01
  store float %20, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 32), align 4
  %21 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 36), align 4
  %22 = fmul float %21, 5.000000e-01
  store float %22, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 36), align 4
  %23 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 40), align 4
  %24 = fmul float %23, 5.000000e-01
  store float %24, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 40), align 4
  %25 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 44), align 4
  %26 = fmul float %25, 5.000000e-01
  store float %26, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 44), align 4
  %27 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 48), align 4
  %28 = fmul float %27, 5.000000e-01
  store float %28, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 48), align 4
  %29 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 52), align 4
  %30 = fmul float %29, 5.000000e-01
  store float %30, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 52), align 4
  %31 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 56), align 4
  %32 = fmul float %31, 5.000000e-01
  store float %32, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 56), align 4
  %33 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 60), align 4
  %34 = fmul float %33, 5.000000e-01
  store float %34, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 60), align 4
  %35 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 64), align 4
  %36 = fmul float %35, 5.000000e-01
  store float %36, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 64), align 4
  %37 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 68), align 4
  %38 = fmul float %37, 5.000000e-01
  store float %38, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 68), align 4
  %39 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 72), align 4
  %40 = fmul float %39, 5.000000e-01
  store float %40, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 72), align 4
  %41 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 76), align 4
  %42 = fmul float %41, 5.000000e-01
  store float %42, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 76), align 4
  %43 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 80), align 4
  %44 = fmul float %43, 5.000000e-01
  store float %44, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 80), align 4
  %45 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 84), align 4
  %46 = fmul float %45, 5.000000e-01
  store float %46, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 84), align 4
  %47 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 88), align 4
  %48 = fmul float %47, 5.000000e-01
  store float %48, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 88), align 4
  %49 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 92), align 4
  %50 = fmul float %49, 5.000000e-01
  store float %50, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 92), align 4
  %51 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 96), align 4
  %52 = fmul float %51, 5.000000e-01
  store float %52, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 96), align 4
  %53 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 100), align 4
  %54 = fmul float %53, 5.000000e-01
  store float %54, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 100), align 4
  %55 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 104), align 4
  %56 = fmul float %55, 5.000000e-01
  store float %56, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 104), align 4
  %57 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 108), align 4
  %58 = fmul float %57, 5.000000e-01
  store float %58, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 108), align 4
  %59 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 112), align 4
  %60 = fmul float %59, 5.000000e-01
  store float %60, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 112), align 4
  %61 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 116), align 4
  %62 = fmul float %61, 5.000000e-01
  store float %62, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 116), align 4
  %63 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 120), align 4
  %64 = fmul float %63, 5.000000e-01
  store float %64, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 120), align 4
  %65 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 124), align 4
  %66 = fmul float %65, 5.000000e-01
  store float %66, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 124), align 4
  %67 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 128), align 4
  %68 = fmul float %67, 5.000000e-01
  store float %68, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 128), align 4
  %69 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 132), align 4
  %70 = fmul float %69, 5.000000e-01
  store float %70, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 132), align 4
  %71 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 136), align 4
  %72 = fmul float %71, 5.000000e-01
  store float %72, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 136), align 4
  %73 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 140), align 4
  %74 = fmul float %73, 5.000000e-01
  store float %74, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 140), align 4
  %75 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 144), align 4
  %76 = fmul float %75, 5.000000e-01
  store float %76, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 144), align 4
  %77 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 148), align 4
  %78 = fmul float %77, 5.000000e-01
  store float %78, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 148), align 4
  %79 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 152), align 4
  %80 = fmul float %79, 5.000000e-01
  store float %80, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 152), align 4
  %81 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 156), align 4
  %82 = fmul float %81, 5.000000e-01
  store float %82, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 156), align 4
  %83 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 160), align 4
  %84 = fmul float %83, 5.000000e-01
  store float %84, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 160), align 4
  %85 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 164), align 4
  %86 = fmul float %85, 5.000000e-01
  store float %86, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 164), align 4
  %87 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 168), align 4
  %88 = fmul float %87, 5.000000e-01
  store float %88, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 168), align 4
  %89 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 172), align 4
  %90 = fmul float %89, 5.000000e-01
  store float %90, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 172), align 4
  %91 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 176), align 4
  %92 = fmul float %91, 5.000000e-01
  store float %92, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 176), align 4
  %93 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 180), align 4
  %94 = fmul float %93, 5.000000e-01
  store float %94, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 180), align 4
  %95 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 184), align 4
  %96 = fmul float %95, 5.000000e-01
  store float %96, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 184), align 4
  %97 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 188), align 4
  %98 = fmul float %97, 5.000000e-01
  store float %98, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 188), align 4
  %99 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 192), align 4
  %100 = fmul float %99, 5.000000e-01
  store float %100, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 192), align 4
  %101 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 196), align 4
  %102 = fmul float %101, 5.000000e-01
  store float %102, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 196), align 4
  %103 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 200), align 4
  %104 = fmul float %103, 5.000000e-01
  store float %104, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 200), align 4
  %105 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 204), align 4
  %106 = fmul float %105, 5.000000e-01
  store float %106, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 204), align 4
  %107 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 208), align 4
  %108 = fmul float %107, 5.000000e-01
  store float %108, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 208), align 4
  %109 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 212), align 4
  %110 = fmul float %109, 5.000000e-01
  store float %110, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 212), align 4
  %111 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 216), align 4
  %112 = fmul float %111, 5.000000e-01
  store float %112, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 216), align 4
  %113 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 220), align 4
  %114 = fmul float %113, 5.000000e-01
  store float %114, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 220), align 4
  %115 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 224), align 4
  %116 = fmul float %115, 5.000000e-01
  store float %116, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 224), align 4
  %117 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 228), align 4
  %118 = fmul float %117, 5.000000e-01
  store float %118, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 228), align 4
  %119 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 232), align 4
  %120 = fmul float %119, 5.000000e-01
  store float %120, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 232), align 4
  %121 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 236), align 4
  %122 = fmul float %121, 5.000000e-01
  store float %122, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 236), align 4
  %123 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 240), align 4
  %124 = fmul float %123, 5.000000e-01
  store float %124, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 240), align 4
  %125 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 244), align 4
  %126 = fmul float %125, 5.000000e-01
  store float %126, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 244), align 4
  %127 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 248), align 4
  %128 = fmul float %127, 5.000000e-01
  store float %128, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 248), align 4
  %129 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 252), align 4
  %130 = fmul float %129, 5.000000e-01
  store float %130, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i20 252), align 4
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  %131 = add nuw nsw i32 %2, 1
  %exitcond3.not = icmp eq i32 %131, 4
  br i1 %exitcond3.not, label %132, label %.preheader, !llvm.loop !1

132:                                              ; preds = %.preheader
  %133 = add nuw nsw i32 %1, 1
  %exitcond4.not = icmp eq i32 %133, 8
  %spec.select = select i1 %exitcond4.not, i32 0, i32 %133
  br label %.preheader2, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
