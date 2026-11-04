; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/representative-ffn-final-r1/lifted/hardware/air_project/canonical_E8E36F0368A5BC08.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [32 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [32 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_3() local_unnamed_addr #1 {
  br label %.loopexit

.loopexit:                                        ; preds = %94, %0
  %1 = phi i32 [ 0, %0 ], [ %spec.select, %94 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %2

2:                                                ; preds = %2, %.loopexit
  %3 = phi i32 [ 0, %.loopexit ], [ %93, %2 ]
  %4 = trunc nuw nsw i32 %3 to i20
  %5 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %4
  %6 = load float, ptr %5, align 4
  %7 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %4
  %8 = load float, ptr %7, align 4
  %9 = fneg float %6
  %.inv = fcmp olt float %9, 0xC055F33340000000
  %10 = select i1 %.inv, float 0xC055F33340000000, float %9
  %.inv2 = fcmp ogt float %10, 0x4056333340000000
  %11 = select i1 %.inv2, float 0x4056333340000000, float %10
  %12 = fmul float %11, 0x3FF7154760000000
  %13 = fadd float %12, 5.000000e-01
  %14 = fptosi float %13 to i32
  %15 = sitofp i32 %14 to float
  %16 = fcmp olt float %13, %15
  %17 = fadd float %15, -1.000000e+00
  %18 = select i1 %16, float %17, float %15
  %.inv3 = fcmp olt float %18, -1.270000e+02
  %19 = select i1 %.inv3, float -1.270000e+02, float %18
  %.inv4 = fcmp ogt float %19, 1.270000e+02
  %20 = select i1 %.inv4, float 1.270000e+02, float %19
  %21 = fmul float %20, 0x3FE6300000000000
  %22 = fsub float %11, %21
  %23 = fmul float %20, 0x3F2BD01060000000
  %24 = fadd float %23, %22
  %25 = fmul float %24, 0x3F2A0D2CE0000000
  %26 = fadd float %25, 0x3F56E879C0000000
  %27 = fmul float %24, %26
  %28 = fadd float %27, 0x3F81112100000000
  %29 = fmul float %24, %28
  %30 = fadd float %29, 0x3FA5553820000000
  %31 = fmul float %24, %30
  %32 = fadd float %31, 0x3FC5555540000000
  %33 = fmul float %24, %32
  %34 = fadd float %33, 5.000000e-01
  %35 = fmul float %24, %24
  %36 = fmul float %35, %34
  %37 = fadd float %24, %36
  %38 = fadd float %37, 1.000000e+00
  %39 = fptosi float %20 to i32
  %40 = shl i32 %39, 23
  %41 = add i32 %40, 1065353216
  %42 = bitcast i32 %41 to float
  %43 = fmul float %38, %42
  %44 = fadd float %43, 1.000000e+00
  %45 = fdiv float %6, %44
  %46 = fmul float %8, %45
  %47 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %4
  store float %46, ptr %47, align 4
  %48 = or disjoint i32 %3, 1
  %49 = trunc nuw nsw i32 %48 to i20
  %50 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %49
  %51 = load float, ptr %50, align 4
  %52 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %49
  %53 = load float, ptr %52, align 4
  %54 = fneg float %51
  %.inv.1 = fcmp olt float %54, 0xC055F33340000000
  %55 = select i1 %.inv.1, float 0xC055F33340000000, float %54
  %.inv2.1 = fcmp ogt float %55, 0x4056333340000000
  %56 = select i1 %.inv2.1, float 0x4056333340000000, float %55
  %57 = fmul float %56, 0x3FF7154760000000
  %58 = fadd float %57, 5.000000e-01
  %59 = fptosi float %58 to i32
  %60 = sitofp i32 %59 to float
  %61 = fcmp olt float %58, %60
  %62 = fadd float %60, -1.000000e+00
  %63 = select i1 %61, float %62, float %60
  %.inv3.1 = fcmp olt float %63, -1.270000e+02
  %64 = select i1 %.inv3.1, float -1.270000e+02, float %63
  %.inv4.1 = fcmp ogt float %64, 1.270000e+02
  %65 = select i1 %.inv4.1, float 1.270000e+02, float %64
  %66 = fmul float %65, 0x3FE6300000000000
  %67 = fsub float %56, %66
  %68 = fmul float %65, 0x3F2BD01060000000
  %69 = fadd float %68, %67
  %70 = fmul float %69, 0x3F2A0D2CE0000000
  %71 = fadd float %70, 0x3F56E879C0000000
  %72 = fmul float %69, %71
  %73 = fadd float %72, 0x3F81112100000000
  %74 = fmul float %69, %73
  %75 = fadd float %74, 0x3FA5553820000000
  %76 = fmul float %69, %75
  %77 = fadd float %76, 0x3FC5555540000000
  %78 = fmul float %69, %77
  %79 = fadd float %78, 5.000000e-01
  %80 = fmul float %69, %69
  %81 = fmul float %80, %79
  %82 = fadd float %69, %81
  %83 = fadd float %82, 1.000000e+00
  %84 = fptosi float %65 to i32
  %85 = shl i32 %84, 23
  %86 = add i32 %85, 1065353216
  %87 = bitcast i32 %86 to float
  %88 = fmul float %83, %87
  %89 = fadd float %88, 1.000000e+00
  %90 = fdiv float %51, %89
  %91 = fmul float %53, %90
  %92 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %49
  store float %91, ptr %92, align 4
  %93 = add nuw nsw i32 %3, 2
  %exitcond.not.1 = icmp eq i32 %93, 32
  br i1 %exitcond.not.1, label %94, label %2, !llvm.loop !1

94:                                               ; preds = %2
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %95 = add nuw nsw i32 %1, 1
  %exitcond5.not = icmp eq i32 %95, 344
  %spec.select = select i1 %exitcond5.not, i32 0, i32 %95
  br label %.loopexit, !llvm.loop !1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
