; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/taskflow-gap-closure-20261114/crosscore-r1/wave-0/hardware/air_project/canonical_6FDB59200064E131.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [1024 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [1024 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_2() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %196, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %1, %.preheader
  %2 = phi i32 [ 0, %1 ], [ %195, %.preheader ]
  %3 = shl nuw nsw i32 %2, 5
  %4 = trunc nuw nsw i32 %3 to i20
  %5 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %4
  %6 = load float, ptr %5, align 4
  %7 = fadd float %6, %6
  %8 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %4
  store float %7, ptr %8, align 4
  %9 = or disjoint i32 %3, 1
  %10 = trunc nuw nsw i32 %9 to i20
  %11 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %10
  %12 = load float, ptr %11, align 4
  %13 = fadd float %12, %12
  %14 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %10
  store float %13, ptr %14, align 4
  %15 = or disjoint i32 %3, 2
  %16 = trunc nuw nsw i32 %15 to i20
  %17 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %16
  %18 = load float, ptr %17, align 4
  %19 = fadd float %18, %18
  %20 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %16
  store float %19, ptr %20, align 4
  %21 = or disjoint i32 %3, 3
  %22 = trunc nuw nsw i32 %21 to i20
  %23 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %22
  %24 = load float, ptr %23, align 4
  %25 = fadd float %24, %24
  %26 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %22
  store float %25, ptr %26, align 4
  %27 = or disjoint i32 %3, 4
  %28 = trunc nuw nsw i32 %27 to i20
  %29 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %28
  %30 = load float, ptr %29, align 4
  %31 = fadd float %30, %30
  %32 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %28
  store float %31, ptr %32, align 4
  %33 = or disjoint i32 %3, 5
  %34 = trunc nuw nsw i32 %33 to i20
  %35 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %34
  %36 = load float, ptr %35, align 4
  %37 = fadd float %36, %36
  %38 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %34
  store float %37, ptr %38, align 4
  %39 = or disjoint i32 %3, 6
  %40 = trunc nuw nsw i32 %39 to i20
  %41 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %40
  %42 = load float, ptr %41, align 4
  %43 = fadd float %42, %42
  %44 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %40
  store float %43, ptr %44, align 4
  %45 = or disjoint i32 %3, 7
  %46 = trunc nuw nsw i32 %45 to i20
  %47 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %46
  %48 = load float, ptr %47, align 4
  %49 = fadd float %48, %48
  %50 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %46
  store float %49, ptr %50, align 4
  %51 = or disjoint i32 %3, 8
  %52 = trunc nuw nsw i32 %51 to i20
  %53 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %52
  %54 = load float, ptr %53, align 4
  %55 = fadd float %54, %54
  %56 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %52
  store float %55, ptr %56, align 4
  %57 = or disjoint i32 %3, 9
  %58 = trunc nuw nsw i32 %57 to i20
  %59 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %58
  %60 = load float, ptr %59, align 4
  %61 = fadd float %60, %60
  %62 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %58
  store float %61, ptr %62, align 4
  %63 = or disjoint i32 %3, 10
  %64 = trunc nuw nsw i32 %63 to i20
  %65 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %64
  %66 = load float, ptr %65, align 4
  %67 = fadd float %66, %66
  %68 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %64
  store float %67, ptr %68, align 4
  %69 = or disjoint i32 %3, 11
  %70 = trunc nuw nsw i32 %69 to i20
  %71 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %70
  %72 = load float, ptr %71, align 4
  %73 = fadd float %72, %72
  %74 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %70
  store float %73, ptr %74, align 4
  %75 = or disjoint i32 %3, 12
  %76 = trunc nuw nsw i32 %75 to i20
  %77 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %76
  %78 = load float, ptr %77, align 4
  %79 = fadd float %78, %78
  %80 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %76
  store float %79, ptr %80, align 4
  %81 = or disjoint i32 %3, 13
  %82 = trunc nuw nsw i32 %81 to i20
  %83 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %82
  %84 = load float, ptr %83, align 4
  %85 = fadd float %84, %84
  %86 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %82
  store float %85, ptr %86, align 4
  %87 = or disjoint i32 %3, 14
  %88 = trunc nuw nsw i32 %87 to i20
  %89 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %88
  %90 = load float, ptr %89, align 4
  %91 = fadd float %90, %90
  %92 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %88
  store float %91, ptr %92, align 4
  %93 = or disjoint i32 %3, 15
  %94 = trunc nuw nsw i32 %93 to i20
  %95 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %94
  %96 = load float, ptr %95, align 4
  %97 = fadd float %96, %96
  %98 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %94
  store float %97, ptr %98, align 4
  %99 = or disjoint i32 %3, 16
  %100 = trunc nuw nsw i32 %99 to i20
  %101 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %100
  %102 = load float, ptr %101, align 4
  %103 = fadd float %102, %102
  %104 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %100
  store float %103, ptr %104, align 4
  %105 = or disjoint i32 %3, 17
  %106 = trunc nuw nsw i32 %105 to i20
  %107 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %106
  %108 = load float, ptr %107, align 4
  %109 = fadd float %108, %108
  %110 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %106
  store float %109, ptr %110, align 4
  %111 = or disjoint i32 %3, 18
  %112 = trunc nuw nsw i32 %111 to i20
  %113 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %112
  %114 = load float, ptr %113, align 4
  %115 = fadd float %114, %114
  %116 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %112
  store float %115, ptr %116, align 4
  %117 = or disjoint i32 %3, 19
  %118 = trunc nuw nsw i32 %117 to i20
  %119 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %118
  %120 = load float, ptr %119, align 4
  %121 = fadd float %120, %120
  %122 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %118
  store float %121, ptr %122, align 4
  %123 = or disjoint i32 %3, 20
  %124 = trunc nuw nsw i32 %123 to i20
  %125 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %124
  %126 = load float, ptr %125, align 4
  %127 = fadd float %126, %126
  %128 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %124
  store float %127, ptr %128, align 4
  %129 = or disjoint i32 %3, 21
  %130 = trunc nuw nsw i32 %129 to i20
  %131 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %130
  %132 = load float, ptr %131, align 4
  %133 = fadd float %132, %132
  %134 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %130
  store float %133, ptr %134, align 4
  %135 = or disjoint i32 %3, 22
  %136 = trunc nuw nsw i32 %135 to i20
  %137 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %136
  %138 = load float, ptr %137, align 4
  %139 = fadd float %138, %138
  %140 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %136
  store float %139, ptr %140, align 4
  %141 = or disjoint i32 %3, 23
  %142 = trunc nuw nsw i32 %141 to i20
  %143 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %142
  %144 = load float, ptr %143, align 4
  %145 = fadd float %144, %144
  %146 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %142
  store float %145, ptr %146, align 4
  %147 = or disjoint i32 %3, 24
  %148 = trunc nuw nsw i32 %147 to i20
  %149 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %148
  %150 = load float, ptr %149, align 4
  %151 = fadd float %150, %150
  %152 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %148
  store float %151, ptr %152, align 4
  %153 = or disjoint i32 %3, 25
  %154 = trunc nuw nsw i32 %153 to i20
  %155 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %154
  %156 = load float, ptr %155, align 4
  %157 = fadd float %156, %156
  %158 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %154
  store float %157, ptr %158, align 4
  %159 = or disjoint i32 %3, 26
  %160 = trunc nuw nsw i32 %159 to i20
  %161 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %160
  %162 = load float, ptr %161, align 4
  %163 = fadd float %162, %162
  %164 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %160
  store float %163, ptr %164, align 4
  %165 = or disjoint i32 %3, 27
  %166 = trunc nuw nsw i32 %165 to i20
  %167 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %166
  %168 = load float, ptr %167, align 4
  %169 = fadd float %168, %168
  %170 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %166
  store float %169, ptr %170, align 4
  %171 = or disjoint i32 %3, 28
  %172 = trunc nuw nsw i32 %171 to i20
  %173 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %172
  %174 = load float, ptr %173, align 4
  %175 = fadd float %174, %174
  %176 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %172
  store float %175, ptr %176, align 4
  %177 = or disjoint i32 %3, 29
  %178 = trunc nuw nsw i32 %177 to i20
  %179 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %178
  %180 = load float, ptr %179, align 4
  %181 = fadd float %180, %180
  %182 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %178
  store float %181, ptr %182, align 4
  %183 = or disjoint i32 %3, 30
  %184 = trunc nuw nsw i32 %183 to i20
  %185 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %184
  %186 = load float, ptr %185, align 4
  %187 = fadd float %186, %186
  %188 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %184
  store float %187, ptr %188, align 4
  %189 = or disjoint i32 %3, 31
  %190 = trunc nuw nsw i32 %189 to i20
  %191 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %190
  %192 = load float, ptr %191, align 4
  %193 = fadd float %192, %192
  %194 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %190
  store float %193, ptr %194, align 4
  %195 = add nuw nsw i32 %2, 1
  %exitcond.not = icmp eq i32 %195, 32
  br i1 %exitcond.not, label %196, label %.preheader, !llvm.loop !1

196:                                              ; preds = %.preheader
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
