; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_9AC3D6C516B11148.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p:20:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-f32:32:32-i64:32-f64:32-a:0:32-n32"
target triple = "aie2p"

@__aiecc_canon_0 = external local_unnamed_addr global [256 x float]
@__aiecc_canon_1 = external local_unnamed_addr global [512 x float]
@__aiecc_canon_2 = external local_unnamed_addr global [128 x float]
@__aiecc_canon_3 = external local_unnamed_addr global [16 x float]
@__aiecc_canon_4 = external local_unnamed_addr global [8 x float]

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.acquire(i32, i32) #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.aie2p.release(i32, i32) #0

; Function Attrs: nofree norecurse noreturn nosync nounwind
define void @__aiecc_canon_5() local_unnamed_addr #1 {
  br label %.preheader

.preheader:                                       ; preds = %190, %0
  tail call void @llvm.aie2p.acquire(i32 49, i32 -1)
  store float 0.000000e+00, ptr @__aiecc_canon_2, align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 4), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 8), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 12), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 16), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 20), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 24), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 28), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 32), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 36), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 40), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 44), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 48), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 52), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 56), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 60), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 64), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 68), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 72), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 76), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 80), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 84), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 88), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 92), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 96), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 100), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 104), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 108), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 112), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 116), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 120), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 124), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 128), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 132), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 136), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 140), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 144), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 148), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 152), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 156), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 160), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 164), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 168), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 172), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 176), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 180), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 184), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 188), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 192), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 196), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 200), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 204), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 208), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 212), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 216), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 220), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 224), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 228), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 232), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 236), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 240), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 244), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 248), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 252), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 256), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 260), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 264), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 268), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 272), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 276), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 280), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 284), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 288), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 292), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 296), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 300), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 304), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 308), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 312), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 316), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 320), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 324), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 328), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 332), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 336), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 340), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 344), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 348), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 352), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 356), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 360), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 364), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 368), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 372), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 376), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 380), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 384), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 388), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 392), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 396), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 400), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 404), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 408), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 412), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 416), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 420), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 424), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 428), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 432), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 436), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 440), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 444), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 448), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 452), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 456), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 460), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 464), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 468), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 472), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 476), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 480), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 484), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 488), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 492), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 496), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 500), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 504), align 4
  store float 0.000000e+00, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_2, i20 508), align 4
  br label %.preheader8

.preheader8:                                      ; preds = %.preheader, %68
  %1 = phi i32 [ %69, %68 ], [ 0, %.preheader ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 54, i32 -1)
  br label %2

2:                                                ; preds = %.preheader8, %66
  %3 = phi i32 [ 8, %.preheader8 ], [ %67, %66 ]
  %4 = add nsw i32 %3, -8
  %5 = shl nuw nsw i32 %4, 5
  %6 = shl nuw nsw i32 %4, 4
  br label %7

7:                                                ; preds = %2, %64
  %8 = phi i32 [ 64, %2 ], [ %65, %64 ]
  %9 = add nsw i32 %8, -64
  %10 = add nuw nsw i32 %9, %6
  %11 = trunc nuw nsw i32 %10 to i20
  %12 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %11
  %.promoted = load float, ptr %12, align 4
  br label %13

13:                                               ; preds = %13, %7
  %14 = phi i32 [ 0, %7 ], [ %63, %13 ]
  %15 = phi float [ %.promoted, %7 ], [ %62, %13 ]
  %16 = add nuw nsw i32 %14, %5
  %17 = trunc nuw nsw i32 %16 to i20
  %18 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %17
  %19 = load float, ptr %18, align 4
  %20 = shl nuw nsw i32 %14, 4
  %21 = add nuw nsw i32 %20, %9
  %22 = trunc nuw nsw i32 %21 to i20
  %23 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %22
  %24 = load float, ptr %23, align 4
  %25 = fmul float %19, %24
  %26 = fadd float %15, %25
  %27 = or disjoint i32 %14, 1
  %28 = add nuw nsw i32 %27, %5
  %29 = trunc nuw nsw i32 %28 to i20
  %30 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %29
  %31 = load float, ptr %30, align 4
  %32 = shl nuw nsw i32 %27, 4
  %33 = add nuw nsw i32 %32, %9
  %34 = trunc nuw nsw i32 %33 to i20
  %35 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %34
  %36 = load float, ptr %35, align 4
  %37 = fmul float %31, %36
  %38 = fadd float %26, %37
  %39 = or disjoint i32 %14, 2
  %40 = add nuw nsw i32 %39, %5
  %41 = trunc nuw nsw i32 %40 to i20
  %42 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %41
  %43 = load float, ptr %42, align 4
  %44 = shl nuw nsw i32 %39, 4
  %45 = add nuw nsw i32 %44, %9
  %46 = trunc nuw nsw i32 %45 to i20
  %47 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %46
  %48 = load float, ptr %47, align 4
  %49 = fmul float %43, %48
  %50 = fadd float %38, %49
  %51 = or disjoint i32 %14, 3
  %52 = add nuw nsw i32 %51, %5
  %53 = trunc nuw nsw i32 %52 to i20
  %54 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %53
  %55 = load float, ptr %54, align 4
  %56 = shl nuw nsw i32 %51, 4
  %57 = add nuw nsw i32 %56, %9
  %58 = trunc nuw nsw i32 %57 to i20
  %59 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %58
  %60 = load float, ptr %59, align 4
  %61 = fmul float %55, %60
  %62 = fadd float %50, %61
  %63 = add nuw nsw i32 %14, 4
  %exitcond9.not.3 = icmp eq i32 %63, 32
  br i1 %exitcond9.not.3, label %64, label %13, !llvm.loop !1

64:                                               ; preds = %13
  store float %62, ptr %12, align 4
  %65 = add nuw nsw i32 %8, 1
  %exitcond10.not = icmp eq i32 %65, 80
  br i1 %exitcond10.not, label %66, label %7, !llvm.loop !1

66:                                               ; preds = %64
  %67 = add nuw nsw i32 %3, 1
  %exitcond11.not = icmp eq i32 %67, 16
  br i1 %exitcond11.not, label %68, label %2, !llvm.loop !1

68:                                               ; preds = %66
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 55, i32 1)
  %69 = add nuw nsw i32 %1, 1
  %exitcond12.not = icmp eq i32 %69, 4
  br i1 %exitcond12.not, label %70, label %.preheader8, !llvm.loop !1

70:                                               ; preds = %68
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 56, i32 -1)
  %71 = load float, ptr @__aiecc_canon_3, align 4
  %72 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 4), align 4
  %73 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 8), align 4
  %74 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 12), align 4
  %75 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 16), align 4
  %76 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 20), align 4
  %77 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 24), align 4
  %78 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 28), align 4
  %79 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 32), align 4
  %80 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 36), align 4
  %81 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 40), align 4
  %82 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 44), align 4
  %83 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 48), align 4
  %84 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 52), align 4
  %85 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 56), align 4
  %86 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 60), align 4
  br label %87

87:                                               ; preds = %70, %87
  %88 = phi i32 [ 8, %70 ], [ %189, %87 ]
  %89 = add nsw i32 %88, -8
  %90 = shl nuw nsw i32 %89, 4
  %91 = trunc nuw nsw i32 %89 to i20
  %92 = getelementptr inbounds nuw float, ptr @__aiecc_canon_4, i20 %91
  %93 = load float, ptr %92, align 4
  %94 = trunc nuw nsw i32 %90 to i20
  %95 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %94
  %96 = load float, ptr %95, align 4
  %97 = fmul float %93, %71
  %98 = fadd float %96, %97
  store float %98, ptr %95, align 4
  %99 = or disjoint i32 %90, 1
  %100 = trunc nuw nsw i32 %99 to i20
  %101 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %100
  %102 = load float, ptr %101, align 4
  %103 = fmul float %93, %72
  %104 = fadd float %102, %103
  store float %104, ptr %101, align 4
  %105 = or disjoint i32 %90, 2
  %106 = trunc nuw nsw i32 %105 to i20
  %107 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %106
  %108 = load float, ptr %107, align 4
  %109 = fmul float %93, %73
  %110 = fadd float %108, %109
  store float %110, ptr %107, align 4
  %111 = or disjoint i32 %90, 3
  %112 = trunc nuw nsw i32 %111 to i20
  %113 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %112
  %114 = load float, ptr %113, align 4
  %115 = fmul float %93, %74
  %116 = fadd float %114, %115
  store float %116, ptr %113, align 4
  %117 = or disjoint i32 %90, 4
  %118 = trunc nuw nsw i32 %117 to i20
  %119 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %118
  %120 = load float, ptr %119, align 4
  %121 = fmul float %93, %75
  %122 = fadd float %120, %121
  store float %122, ptr %119, align 4
  %123 = or disjoint i32 %90, 5
  %124 = trunc nuw nsw i32 %123 to i20
  %125 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %124
  %126 = load float, ptr %125, align 4
  %127 = fmul float %93, %76
  %128 = fadd float %126, %127
  store float %128, ptr %125, align 4
  %129 = or disjoint i32 %90, 6
  %130 = trunc nuw nsw i32 %129 to i20
  %131 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %130
  %132 = load float, ptr %131, align 4
  %133 = fmul float %93, %77
  %134 = fadd float %132, %133
  store float %134, ptr %131, align 4
  %135 = or disjoint i32 %90, 7
  %136 = trunc nuw nsw i32 %135 to i20
  %137 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %136
  %138 = load float, ptr %137, align 4
  %139 = fmul float %93, %78
  %140 = fadd float %138, %139
  store float %140, ptr %137, align 4
  %141 = or disjoint i32 %90, 8
  %142 = trunc nuw nsw i32 %141 to i20
  %143 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %142
  %144 = load float, ptr %143, align 4
  %145 = fmul float %93, %79
  %146 = fadd float %144, %145
  store float %146, ptr %143, align 4
  %147 = or disjoint i32 %90, 9
  %148 = trunc nuw nsw i32 %147 to i20
  %149 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %148
  %150 = load float, ptr %149, align 4
  %151 = fmul float %93, %80
  %152 = fadd float %150, %151
  store float %152, ptr %149, align 4
  %153 = or disjoint i32 %90, 10
  %154 = trunc nuw nsw i32 %153 to i20
  %155 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %154
  %156 = load float, ptr %155, align 4
  %157 = fmul float %93, %81
  %158 = fadd float %156, %157
  store float %158, ptr %155, align 4
  %159 = or disjoint i32 %90, 11
  %160 = trunc nuw nsw i32 %159 to i20
  %161 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %160
  %162 = load float, ptr %161, align 4
  %163 = fmul float %93, %82
  %164 = fadd float %162, %163
  store float %164, ptr %161, align 4
  %165 = or disjoint i32 %90, 12
  %166 = trunc nuw nsw i32 %165 to i20
  %167 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %166
  %168 = load float, ptr %167, align 4
  %169 = fmul float %93, %83
  %170 = fadd float %168, %169
  store float %170, ptr %167, align 4
  %171 = or disjoint i32 %90, 13
  %172 = trunc nuw nsw i32 %171 to i20
  %173 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %172
  %174 = load float, ptr %173, align 4
  %175 = fmul float %93, %84
  %176 = fadd float %174, %175
  store float %176, ptr %173, align 4
  %177 = or disjoint i32 %90, 14
  %178 = trunc nuw nsw i32 %177 to i20
  %179 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %178
  %180 = load float, ptr %179, align 4
  %181 = fmul float %93, %85
  %182 = fadd float %180, %181
  store float %182, ptr %179, align 4
  %183 = or disjoint i32 %90, 15
  %184 = trunc nuw nsw i32 %183 to i20
  %185 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %184
  %186 = load float, ptr %185, align 4
  %187 = fmul float %93, %86
  %188 = fadd float %186, %187
  store float %188, ptr %185, align 4
  %189 = add nuw nsw i32 %88, 1
  %exitcond14.not = icmp eq i32 %189, 16
  br i1 %exitcond14.not, label %190, label %87, !llvm.loop !1

190:                                              ; preds = %87
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 57, i32 1)
  br label %.preheader
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
