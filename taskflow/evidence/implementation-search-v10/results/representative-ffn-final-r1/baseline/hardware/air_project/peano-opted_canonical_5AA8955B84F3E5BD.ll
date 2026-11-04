; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/representative-ffn-final-r1/baseline/hardware/air_project/canonical_5AA8955B84F3E5BD.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [320 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [320 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [320 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_3() local_unnamed_addr #1 {
  br label %.loopexit

.loopexit:                                        ; preds = %100, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %100 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.loopexit, %98
  %2 = phi i32 [ 0, %.loopexit ], [ %99, %98 ]
  %3 = shl nuw nsw i32 %2, 6
  br label %4

4:                                                ; preds = %4, %.preheader
  %5 = phi i32 [ 0, %.preheader ], [ %97, %4 ]
  %6 = add nuw nsw i32 %5, %3
  %7 = trunc nuw nsw i32 %6 to i20
  %8 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %7
  %9 = load float, ptr %8, align 4
  %10 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %7
  %11 = load float, ptr %10, align 4
  %12 = fneg float %9
  %.inv = fcmp olt float %12, 0xC055F33340000000
  %13 = select i1 %.inv, float 0xC055F33340000000, float %12
  %.inv2 = fcmp ogt float %13, 0x4056333340000000
  %14 = select i1 %.inv2, float 0x4056333340000000, float %13
  %15 = fmul float %14, 0x3FF7154760000000
  %16 = fadd float %15, 5.000000e-01
  %17 = fptosi float %16 to i32
  %18 = sitofp i32 %17 to float
  %19 = fcmp olt float %16, %18
  %20 = fadd float %18, -1.000000e+00
  %21 = select i1 %19, float %20, float %18
  %.inv3 = fcmp olt float %21, -1.270000e+02
  %22 = select i1 %.inv3, float -1.270000e+02, float %21
  %.inv4 = fcmp ogt float %22, 1.270000e+02
  %23 = select i1 %.inv4, float 1.270000e+02, float %22
  %24 = fmul float %23, 0x3FE6300000000000
  %25 = fsub float %14, %24
  %26 = fmul float %23, 0x3F2BD01060000000
  %27 = fadd float %26, %25
  %28 = fmul float %27, 0x3F2A0D2CE0000000
  %29 = fadd float %28, 0x3F56E879C0000000
  %30 = fmul float %27, %29
  %31 = fadd float %30, 0x3F81112100000000
  %32 = fmul float %27, %31
  %33 = fadd float %32, 0x3FA5553820000000
  %34 = fmul float %27, %33
  %35 = fadd float %34, 0x3FC5555540000000
  %36 = fmul float %27, %35
  %37 = fadd float %36, 5.000000e-01
  %38 = fmul float %27, %27
  %39 = fmul float %38, %37
  %40 = fadd float %27, %39
  %41 = fadd float %40, 1.000000e+00
  %42 = fptosi float %23 to i32
  %43 = shl i32 %42, 23
  %44 = add i32 %43, 1065353216
  %45 = bitcast i32 %44 to float
  %46 = fmul float %41, %45
  %47 = fadd float %46, 1.000000e+00
  %48 = fdiv float %9, %47
  %49 = fmul float %11, %48
  %50 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %7
  store float %49, ptr %50, align 4
  %51 = or disjoint i32 %5, 1
  %52 = add nuw nsw i32 %51, %3
  %53 = trunc nuw nsw i32 %52 to i20
  %54 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %53
  %55 = load float, ptr %54, align 4
  %56 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %53
  %57 = load float, ptr %56, align 4
  %58 = fneg float %55
  %.inv.1 = fcmp olt float %58, 0xC055F33340000000
  %59 = select i1 %.inv.1, float 0xC055F33340000000, float %58
  %.inv2.1 = fcmp ogt float %59, 0x4056333340000000
  %60 = select i1 %.inv2.1, float 0x4056333340000000, float %59
  %61 = fmul float %60, 0x3FF7154760000000
  %62 = fadd float %61, 5.000000e-01
  %63 = fptosi float %62 to i32
  %64 = sitofp i32 %63 to float
  %65 = fcmp olt float %62, %64
  %66 = fadd float %64, -1.000000e+00
  %67 = select i1 %65, float %66, float %64
  %.inv3.1 = fcmp olt float %67, -1.270000e+02
  %68 = select i1 %.inv3.1, float -1.270000e+02, float %67
  %.inv4.1 = fcmp ogt float %68, 1.270000e+02
  %69 = select i1 %.inv4.1, float 1.270000e+02, float %68
  %70 = fmul float %69, 0x3FE6300000000000
  %71 = fsub float %60, %70
  %72 = fmul float %69, 0x3F2BD01060000000
  %73 = fadd float %72, %71
  %74 = fmul float %73, 0x3F2A0D2CE0000000
  %75 = fadd float %74, 0x3F56E879C0000000
  %76 = fmul float %73, %75
  %77 = fadd float %76, 0x3F81112100000000
  %78 = fmul float %73, %77
  %79 = fadd float %78, 0x3FA5553820000000
  %80 = fmul float %73, %79
  %81 = fadd float %80, 0x3FC5555540000000
  %82 = fmul float %73, %81
  %83 = fadd float %82, 5.000000e-01
  %84 = fmul float %73, %73
  %85 = fmul float %84, %83
  %86 = fadd float %73, %85
  %87 = fadd float %86, 1.000000e+00
  %88 = fptosi float %69 to i32
  %89 = shl i32 %88, 23
  %90 = add i32 %89, 1065353216
  %91 = bitcast i32 %90 to float
  %92 = fmul float %87, %91
  %93 = fadd float %92, 1.000000e+00
  %94 = fdiv float %55, %93
  %95 = fmul float %57, %94
  %96 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %53
  store float %95, ptr %96, align 4
  %97 = add nuw nsw i32 %5, 2
  %exitcond.not.1 = icmp eq i32 %97, 64
  br i1 %exitcond.not.1, label %98, label %4, !llvm.loop !1

98:                                               ; preds = %4
  %99 = add nuw nsw i32 %2, 1
  %exitcond5.not = icmp eq i32 %99, 5
  br i1 %exitcond5.not, label %100, label %.preheader, !llvm.loop !1

100:                                              ; preds = %98
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %101 = add nuw nsw i32 %1, 1
  %exitcond6.not = icmp eq i32 %101, 172
  %spec.select = select i1 %exitcond6.not, i32 0, i32 %101
  br label %.loopexit, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
