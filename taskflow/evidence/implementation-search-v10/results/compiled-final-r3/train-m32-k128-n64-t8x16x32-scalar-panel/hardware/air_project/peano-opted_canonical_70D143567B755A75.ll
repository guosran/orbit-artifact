; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/train-m32-k128-n64-t8x16x32-scalar-panel/hardware/air_project/canonical_70D143567B755A75.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [256 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [128 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [2048 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_3() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %77, %0
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader5

.preheader5:                                      ; preds = %1, %75
  %2 = phi i32 [ 0, %1 ], [ %76, %75 ]
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  store float 0.000000e+00, ptr @__aiecc_canon_1, align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 4), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 8), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 12), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 16), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 20), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 24), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 28), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 32), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 36), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 40), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 44), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 48), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 52), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 56), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 60), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 64), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 68), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 72), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 76), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 80), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 84), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 88), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 92), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 96), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 100), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 104), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 108), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 112), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 116), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 120), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 124), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 128), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 132), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 136), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 140), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 144), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 148), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 152), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 156), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 160), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 164), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 168), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 172), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 176), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 180), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 184), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 188), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 192), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 196), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 200), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 204), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 208), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 212), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 216), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 220), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 224), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 228), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 232), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 236), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 240), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 244), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 248), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 252), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 256), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 260), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 264), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 268), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 272), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 276), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 280), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 284), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 288), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 292), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 296), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 300), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 304), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 308), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 312), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 316), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 320), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 324), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 328), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 332), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 336), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 340), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 344), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 348), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 352), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 356), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 360), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 364), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 368), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 372), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 376), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 380), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 384), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 388), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 392), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 396), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 400), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 404), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 408), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 412), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 416), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 420), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 424), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 428), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 432), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 436), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 440), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 444), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 448), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 452), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 456), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 460), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 464), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 468), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 472), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 476), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 480), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 484), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 488), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 492), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 496), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 500), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 504), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_1, i20 508), align 4
  br label %.preheader6

.preheader6:                                      ; preds = %.preheader5, %72
  %3 = phi i32 [ %73, %72 ], [ 0, %.preheader5 ]
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.preheader6, %70
  %4 = phi i32 [ 0, %.preheader6 ], [ %71, %70 ]
  %5 = shl nuw nsw i32 %4, 5
  %6 = shl nuw nsw i32 %4, 4
  br label %7

7:                                                ; preds = %.preheader, %68
  %8 = phi i32 [ 48, %.preheader ], [ %69, %68 ]
  %9 = add nsw i32 %8, -48
  %10 = add nuw nsw i32 %9, %6
  %11 = trunc nuw nsw i32 %10 to i20
  %12 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %11
  %.promoted = load float, ptr %12, align 4
  br label %13

13:                                               ; preds = %13, %7
  %14 = phi i32 [ 0, %7 ], [ %67, %13 ]
  %15 = phi float [ %.promoted, %7 ], [ %66, %13 ]
  %16 = add nuw nsw i32 %14, %3
  %17 = add nuw nsw i32 %14, %5
  %18 = trunc nuw nsw i32 %17 to i20
  %19 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %18
  %20 = load float, ptr %19, align 4
  %21 = shl nuw nsw i32 %16, 4
  %22 = add nuw nsw i32 %21, %9
  %23 = trunc nuw nsw i32 %22 to i20
  %24 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %23
  %25 = load float, ptr %24, align 4
  %26 = fmul float %20, %25
  %27 = fadd float %15, %26
  %28 = or disjoint i32 %14, 1
  %29 = add nuw nsw i32 %28, %3
  %30 = add nuw nsw i32 %28, %5
  %31 = trunc nuw nsw i32 %30 to i20
  %32 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %31
  %33 = load float, ptr %32, align 4
  %34 = shl nuw nsw i32 %29, 4
  %35 = add nuw nsw i32 %34, %9
  %36 = trunc nuw nsw i32 %35 to i20
  %37 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %36
  %38 = load float, ptr %37, align 4
  %39 = fmul float %33, %38
  %40 = fadd float %27, %39
  %41 = or disjoint i32 %14, 2
  %42 = add nuw nsw i32 %41, %3
  %43 = add nuw nsw i32 %41, %5
  %44 = trunc nuw nsw i32 %43 to i20
  %45 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %44
  %46 = load float, ptr %45, align 4
  %47 = shl nuw nsw i32 %42, 4
  %48 = add nuw nsw i32 %47, %9
  %49 = trunc nuw nsw i32 %48 to i20
  %50 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %49
  %51 = load float, ptr %50, align 4
  %52 = fmul float %46, %51
  %53 = fadd float %40, %52
  %54 = or disjoint i32 %14, 3
  %55 = add nuw nsw i32 %54, %3
  %56 = add nuw nsw i32 %54, %5
  %57 = trunc nuw nsw i32 %56 to i20
  %58 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %57
  %59 = load float, ptr %58, align 4
  %60 = shl nuw nsw i32 %55, 4
  %61 = add nuw nsw i32 %60, %9
  %62 = trunc nuw nsw i32 %61 to i20
  %63 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %62
  %64 = load float, ptr %63, align 4
  %65 = fmul float %59, %64
  %66 = fadd float %53, %65
  %67 = add nuw nsw i32 %14, 4
  %exitcond7.not.3 = icmp eq i32 %67, 32
  br i1 %exitcond7.not.3, label %68, label %13, !llvm.loop !1

68:                                               ; preds = %13
  store float %66, ptr %12, align 4
  %69 = add nuw nsw i32 %8, 1
  %exitcond8.not = icmp eq i32 %69, 64
  br i1 %exitcond8.not, label %70, label %7, !llvm.loop !1

70:                                               ; preds = %68
  %71 = add nuw nsw i32 %4, 1
  %exitcond9.not = icmp eq i32 %71, 8
  br i1 %exitcond9.not, label %72, label %.preheader, !llvm.loop !1

72:                                               ; preds = %70
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %73 = add nuw nsw i32 %3, 32
  %74 = icmp samesign ult i32 %3, 96
  br i1 %74, label %.preheader6, label %75, !llvm.loop !1

75:                                               ; preds = %72
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %76 = add nuw nsw i32 %2, 1
  %exitcond10.not = icmp eq i32 %76, 4
  br i1 %exitcond10.not, label %77, label %.preheader5, !llvm.loop !1

77:                                               ; preds = %75
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %1
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
