; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/train-m32-k128-n64-t8x32x32-scalar-panel/hardware/air_project/canonical_46CF5D64C35D9C05.ll'
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
  br label %.preheader2

.preheader2:                                      ; preds = %201, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %201 ]
  br label %2

2:                                                ; preds = %.preheader2, %198
  %3 = phi i32 [ 0, %.preheader2 ], [ %199, %198 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %2, %.preheader
  %4 = phi i32 [ 0, %2 ], [ %197, %.preheader ]
  %5 = shl nuw nsw i32 %4, 5
  %6 = trunc nuw nsw i32 %5 to i20
  %7 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %6
  %8 = load float, ptr %7, align 4
  %9 = fmul float %8, 5.000000e-01
  %10 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %6
  store float %9, ptr %10, align 4
  %11 = or disjoint i32 %5, 1
  %12 = trunc nuw nsw i32 %11 to i20
  %13 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %12
  %14 = load float, ptr %13, align 4
  %15 = fmul float %14, 5.000000e-01
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %12
  store float %15, ptr %16, align 4
  %17 = or disjoint i32 %5, 2
  %18 = trunc nuw nsw i32 %17 to i20
  %19 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %18
  %20 = load float, ptr %19, align 4
  %21 = fmul float %20, 5.000000e-01
  %22 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %18
  store float %21, ptr %22, align 4
  %23 = or disjoint i32 %5, 3
  %24 = trunc nuw nsw i32 %23 to i20
  %25 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %24
  %26 = load float, ptr %25, align 4
  %27 = fmul float %26, 5.000000e-01
  %28 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %24
  store float %27, ptr %28, align 4
  %29 = or disjoint i32 %5, 4
  %30 = trunc nuw nsw i32 %29 to i20
  %31 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %30
  %32 = load float, ptr %31, align 4
  %33 = fmul float %32, 5.000000e-01
  %34 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %30
  store float %33, ptr %34, align 4
  %35 = or disjoint i32 %5, 5
  %36 = trunc nuw nsw i32 %35 to i20
  %37 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %36
  %38 = load float, ptr %37, align 4
  %39 = fmul float %38, 5.000000e-01
  %40 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %36
  store float %39, ptr %40, align 4
  %41 = or disjoint i32 %5, 6
  %42 = trunc nuw nsw i32 %41 to i20
  %43 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %42
  %44 = load float, ptr %43, align 4
  %45 = fmul float %44, 5.000000e-01
  %46 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %42
  store float %45, ptr %46, align 4
  %47 = or disjoint i32 %5, 7
  %48 = trunc nuw nsw i32 %47 to i20
  %49 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %48
  %50 = load float, ptr %49, align 4
  %51 = fmul float %50, 5.000000e-01
  %52 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %48
  store float %51, ptr %52, align 4
  %53 = or disjoint i32 %5, 8
  %54 = trunc nuw nsw i32 %53 to i20
  %55 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %54
  %56 = load float, ptr %55, align 4
  %57 = fmul float %56, 5.000000e-01
  %58 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %54
  store float %57, ptr %58, align 4
  %59 = or disjoint i32 %5, 9
  %60 = trunc nuw nsw i32 %59 to i20
  %61 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %60
  %62 = load float, ptr %61, align 4
  %63 = fmul float %62, 5.000000e-01
  %64 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %60
  store float %63, ptr %64, align 4
  %65 = or disjoint i32 %5, 10
  %66 = trunc nuw nsw i32 %65 to i20
  %67 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %66
  %68 = load float, ptr %67, align 4
  %69 = fmul float %68, 5.000000e-01
  %70 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %66
  store float %69, ptr %70, align 4
  %71 = or disjoint i32 %5, 11
  %72 = trunc nuw nsw i32 %71 to i20
  %73 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %72
  %74 = load float, ptr %73, align 4
  %75 = fmul float %74, 5.000000e-01
  %76 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %72
  store float %75, ptr %76, align 4
  %77 = or disjoint i32 %5, 12
  %78 = trunc nuw nsw i32 %77 to i20
  %79 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %78
  %80 = load float, ptr %79, align 4
  %81 = fmul float %80, 5.000000e-01
  %82 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %78
  store float %81, ptr %82, align 4
  %83 = or disjoint i32 %5, 13
  %84 = trunc nuw nsw i32 %83 to i20
  %85 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %84
  %86 = load float, ptr %85, align 4
  %87 = fmul float %86, 5.000000e-01
  %88 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %84
  store float %87, ptr %88, align 4
  %89 = or disjoint i32 %5, 14
  %90 = trunc nuw nsw i32 %89 to i20
  %91 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %90
  %92 = load float, ptr %91, align 4
  %93 = fmul float %92, 5.000000e-01
  %94 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %90
  store float %93, ptr %94, align 4
  %95 = or disjoint i32 %5, 15
  %96 = trunc nuw nsw i32 %95 to i20
  %97 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %96
  %98 = load float, ptr %97, align 4
  %99 = fmul float %98, 5.000000e-01
  %100 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %96
  store float %99, ptr %100, align 4
  %101 = or disjoint i32 %5, 16
  %102 = trunc nuw nsw i32 %101 to i20
  %103 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %102
  %104 = load float, ptr %103, align 4
  %105 = fmul float %104, 5.000000e-01
  %106 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %102
  store float %105, ptr %106, align 4
  %107 = or disjoint i32 %5, 17
  %108 = trunc nuw nsw i32 %107 to i20
  %109 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %108
  %110 = load float, ptr %109, align 4
  %111 = fmul float %110, 5.000000e-01
  %112 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %108
  store float %111, ptr %112, align 4
  %113 = or disjoint i32 %5, 18
  %114 = trunc nuw nsw i32 %113 to i20
  %115 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %114
  %116 = load float, ptr %115, align 4
  %117 = fmul float %116, 5.000000e-01
  %118 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %114
  store float %117, ptr %118, align 4
  %119 = or disjoint i32 %5, 19
  %120 = trunc nuw nsw i32 %119 to i20
  %121 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %120
  %122 = load float, ptr %121, align 4
  %123 = fmul float %122, 5.000000e-01
  %124 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %120
  store float %123, ptr %124, align 4
  %125 = or disjoint i32 %5, 20
  %126 = trunc nuw nsw i32 %125 to i20
  %127 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %126
  %128 = load float, ptr %127, align 4
  %129 = fmul float %128, 5.000000e-01
  %130 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %126
  store float %129, ptr %130, align 4
  %131 = or disjoint i32 %5, 21
  %132 = trunc nuw nsw i32 %131 to i20
  %133 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %132
  %134 = load float, ptr %133, align 4
  %135 = fmul float %134, 5.000000e-01
  %136 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %132
  store float %135, ptr %136, align 4
  %137 = or disjoint i32 %5, 22
  %138 = trunc nuw nsw i32 %137 to i20
  %139 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %138
  %140 = load float, ptr %139, align 4
  %141 = fmul float %140, 5.000000e-01
  %142 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %138
  store float %141, ptr %142, align 4
  %143 = or disjoint i32 %5, 23
  %144 = trunc nuw nsw i32 %143 to i20
  %145 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %144
  %146 = load float, ptr %145, align 4
  %147 = fmul float %146, 5.000000e-01
  %148 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %144
  store float %147, ptr %148, align 4
  %149 = or disjoint i32 %5, 24
  %150 = trunc nuw nsw i32 %149 to i20
  %151 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %150
  %152 = load float, ptr %151, align 4
  %153 = fmul float %152, 5.000000e-01
  %154 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %150
  store float %153, ptr %154, align 4
  %155 = or disjoint i32 %5, 25
  %156 = trunc nuw nsw i32 %155 to i20
  %157 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %156
  %158 = load float, ptr %157, align 4
  %159 = fmul float %158, 5.000000e-01
  %160 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %156
  store float %159, ptr %160, align 4
  %161 = or disjoint i32 %5, 26
  %162 = trunc nuw nsw i32 %161 to i20
  %163 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %162
  %164 = load float, ptr %163, align 4
  %165 = fmul float %164, 5.000000e-01
  %166 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %162
  store float %165, ptr %166, align 4
  %167 = or disjoint i32 %5, 27
  %168 = trunc nuw nsw i32 %167 to i20
  %169 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %168
  %170 = load float, ptr %169, align 4
  %171 = fmul float %170, 5.000000e-01
  %172 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %168
  store float %171, ptr %172, align 4
  %173 = or disjoint i32 %5, 28
  %174 = trunc nuw nsw i32 %173 to i20
  %175 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %174
  %176 = load float, ptr %175, align 4
  %177 = fmul float %176, 5.000000e-01
  %178 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %174
  store float %177, ptr %178, align 4
  %179 = or disjoint i32 %5, 29
  %180 = trunc nuw nsw i32 %179 to i20
  %181 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %180
  %182 = load float, ptr %181, align 4
  %183 = fmul float %182, 5.000000e-01
  %184 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %180
  store float %183, ptr %184, align 4
  %185 = or disjoint i32 %5, 30
  %186 = trunc nuw nsw i32 %185 to i20
  %187 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %186
  %188 = load float, ptr %187, align 4
  %189 = fmul float %188, 5.000000e-01
  %190 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %186
  store float %189, ptr %190, align 4
  %191 = or disjoint i32 %5, 31
  %192 = trunc nuw nsw i32 %191 to i20
  %193 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %192
  %194 = load float, ptr %193, align 4
  %195 = fmul float %194, 5.000000e-01
  %196 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %192
  store float %195, ptr %196, align 4
  %197 = add nuw nsw i32 %4, 1
  %exitcond.not = icmp eq i32 %197, 8
  br i1 %exitcond.not, label %198, label %.preheader, !llvm.loop !1

198:                                              ; preds = %.preheader
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  %199 = add nuw nsw i32 %3, 1
  %200 = icmp eq i32 %3, 0
  br i1 %200, label %2, label %201, !llvm.loop !1

201:                                              ; preds = %198
  %202 = add nuw nsw i32 %1, 1
  %exitcond3.not = icmp eq i32 %202, 4
  %spec.select = select i1 %exitcond3.not, i32 0, i32 %202
  br label %.preheader2, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
