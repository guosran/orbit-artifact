; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-scalar-phase/hardware/air_project/canonical_3A847F142140A7EF.ll'
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
  br label %.preheader6

.preheader6:                                      ; preds = %186, %0
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
  br label %.preheader7

.preheader7:                                      ; preds = %.preheader6, %66
  %1 = phi i32 [ %67, %66 ], [ 0, %.preheader6 ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 54, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.preheader7, %64
  %2 = phi i32 [ 0, %.preheader7 ], [ %65, %64 ]
  %3 = shl nuw nsw i32 %2, 5
  %4 = shl nuw nsw i32 %2, 4
  br label %5

5:                                                ; preds = %.preheader, %62
  %6 = phi i32 [ 64, %.preheader ], [ %63, %62 ]
  %7 = add nsw i32 %6, -64
  %8 = add nuw nsw i32 %7, %4
  %9 = trunc nuw nsw i32 %8 to i20
  %10 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %9
  %.promoted = load float, ptr %10, align 4
  br label %11

11:                                               ; preds = %11, %5
  %12 = phi i32 [ 0, %5 ], [ %61, %11 ]
  %13 = phi float [ %.promoted, %5 ], [ %60, %11 ]
  %14 = add nuw nsw i32 %12, %3
  %15 = trunc nuw nsw i32 %14 to i20
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %15
  %17 = load float, ptr %16, align 4
  %18 = shl nuw nsw i32 %12, 4
  %19 = add nuw nsw i32 %18, %7
  %20 = trunc nuw nsw i32 %19 to i20
  %21 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %20
  %22 = load float, ptr %21, align 4
  %23 = fmul float %17, %22
  %24 = fadd float %13, %23
  %25 = or disjoint i32 %12, 1
  %26 = add nuw nsw i32 %25, %3
  %27 = trunc nuw nsw i32 %26 to i20
  %28 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %27
  %29 = load float, ptr %28, align 4
  %30 = shl nuw nsw i32 %25, 4
  %31 = add nuw nsw i32 %30, %7
  %32 = trunc nuw nsw i32 %31 to i20
  %33 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %32
  %34 = load float, ptr %33, align 4
  %35 = fmul float %29, %34
  %36 = fadd float %24, %35
  %37 = or disjoint i32 %12, 2
  %38 = add nuw nsw i32 %37, %3
  %39 = trunc nuw nsw i32 %38 to i20
  %40 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %39
  %41 = load float, ptr %40, align 4
  %42 = shl nuw nsw i32 %37, 4
  %43 = add nuw nsw i32 %42, %7
  %44 = trunc nuw nsw i32 %43 to i20
  %45 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %44
  %46 = load float, ptr %45, align 4
  %47 = fmul float %41, %46
  %48 = fadd float %36, %47
  %49 = or disjoint i32 %12, 3
  %50 = add nuw nsw i32 %49, %3
  %51 = trunc nuw nsw i32 %50 to i20
  %52 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %51
  %53 = load float, ptr %52, align 4
  %54 = shl nuw nsw i32 %49, 4
  %55 = add nuw nsw i32 %54, %7
  %56 = trunc nuw nsw i32 %55 to i20
  %57 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i20 %56
  %58 = load float, ptr %57, align 4
  %59 = fmul float %53, %58
  %60 = fadd float %48, %59
  %61 = add nuw nsw i32 %12, 4
  %exitcond8.not.3 = icmp eq i32 %61, 32
  br i1 %exitcond8.not.3, label %62, label %11, !llvm.loop !1

62:                                               ; preds = %11
  store float %60, ptr %10, align 4
  %63 = add nuw nsw i32 %6, 1
  %exitcond9.not = icmp eq i32 %63, 80
  br i1 %exitcond9.not, label %64, label %5, !llvm.loop !1

64:                                               ; preds = %62
  %65 = add nuw nsw i32 %2, 1
  %exitcond10.not = icmp eq i32 %65, 8
  br i1 %exitcond10.not, label %66, label %.preheader, !llvm.loop !1

66:                                               ; preds = %64
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 55, i32 1)
  %67 = add nuw nsw i32 %1, 1
  %exitcond11.not = icmp eq i32 %67, 4
  br i1 %exitcond11.not, label %68, label %.preheader7, !llvm.loop !1

68:                                               ; preds = %66
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 56, i32 -1)
  %69 = load float, ptr @__aiecc_canon_3, align 4
  %70 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 4), align 4
  %71 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 8), align 4
  %72 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 12), align 4
  %73 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 16), align 4
  %74 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 20), align 4
  %75 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 24), align 4
  %76 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 28), align 4
  %77 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 32), align 4
  %78 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 36), align 4
  %79 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 40), align 4
  %80 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 44), align 4
  %81 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 48), align 4
  %82 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 52), align 4
  %83 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 56), align 4
  %84 = load float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_3, i20 60), align 4
  br label %.preheader5

.preheader5:                                      ; preds = %68, %.preheader5
  %85 = phi i32 [ 0, %68 ], [ %185, %.preheader5 ]
  %86 = shl nuw nsw i32 %85, 4
  %87 = trunc nuw nsw i32 %85 to i20
  %88 = getelementptr inbounds nuw float, ptr @__aiecc_canon_4, i20 %87
  %89 = load float, ptr %88, align 4
  %90 = trunc nuw nsw i32 %86 to i20
  %91 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %90
  %92 = load float, ptr %91, align 4
  %93 = fmul float %89, %69
  %94 = fadd float %92, %93
  store float %94, ptr %91, align 4
  %95 = or disjoint i32 %86, 1
  %96 = trunc nuw nsw i32 %95 to i20
  %97 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %96
  %98 = load float, ptr %97, align 4
  %99 = fmul float %89, %70
  %100 = fadd float %98, %99
  store float %100, ptr %97, align 4
  %101 = or disjoint i32 %86, 2
  %102 = trunc nuw nsw i32 %101 to i20
  %103 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %102
  %104 = load float, ptr %103, align 4
  %105 = fmul float %89, %71
  %106 = fadd float %104, %105
  store float %106, ptr %103, align 4
  %107 = or disjoint i32 %86, 3
  %108 = trunc nuw nsw i32 %107 to i20
  %109 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %108
  %110 = load float, ptr %109, align 4
  %111 = fmul float %89, %72
  %112 = fadd float %110, %111
  store float %112, ptr %109, align 4
  %113 = or disjoint i32 %86, 4
  %114 = trunc nuw nsw i32 %113 to i20
  %115 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %114
  %116 = load float, ptr %115, align 4
  %117 = fmul float %89, %73
  %118 = fadd float %116, %117
  store float %118, ptr %115, align 4
  %119 = or disjoint i32 %86, 5
  %120 = trunc nuw nsw i32 %119 to i20
  %121 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %120
  %122 = load float, ptr %121, align 4
  %123 = fmul float %89, %74
  %124 = fadd float %122, %123
  store float %124, ptr %121, align 4
  %125 = or disjoint i32 %86, 6
  %126 = trunc nuw nsw i32 %125 to i20
  %127 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %126
  %128 = load float, ptr %127, align 4
  %129 = fmul float %89, %75
  %130 = fadd float %128, %129
  store float %130, ptr %127, align 4
  %131 = or disjoint i32 %86, 7
  %132 = trunc nuw nsw i32 %131 to i20
  %133 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %132
  %134 = load float, ptr %133, align 4
  %135 = fmul float %89, %76
  %136 = fadd float %134, %135
  store float %136, ptr %133, align 4
  %137 = or disjoint i32 %86, 8
  %138 = trunc nuw nsw i32 %137 to i20
  %139 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %138
  %140 = load float, ptr %139, align 4
  %141 = fmul float %89, %77
  %142 = fadd float %140, %141
  store float %142, ptr %139, align 4
  %143 = or disjoint i32 %86, 9
  %144 = trunc nuw nsw i32 %143 to i20
  %145 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %144
  %146 = load float, ptr %145, align 4
  %147 = fmul float %89, %78
  %148 = fadd float %146, %147
  store float %148, ptr %145, align 4
  %149 = or disjoint i32 %86, 10
  %150 = trunc nuw nsw i32 %149 to i20
  %151 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %150
  %152 = load float, ptr %151, align 4
  %153 = fmul float %89, %79
  %154 = fadd float %152, %153
  store float %154, ptr %151, align 4
  %155 = or disjoint i32 %86, 11
  %156 = trunc nuw nsw i32 %155 to i20
  %157 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %156
  %158 = load float, ptr %157, align 4
  %159 = fmul float %89, %80
  %160 = fadd float %158, %159
  store float %160, ptr %157, align 4
  %161 = or disjoint i32 %86, 12
  %162 = trunc nuw nsw i32 %161 to i20
  %163 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %162
  %164 = load float, ptr %163, align 4
  %165 = fmul float %89, %81
  %166 = fadd float %164, %165
  store float %166, ptr %163, align 4
  %167 = or disjoint i32 %86, 13
  %168 = trunc nuw nsw i32 %167 to i20
  %169 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %168
  %170 = load float, ptr %169, align 4
  %171 = fmul float %89, %82
  %172 = fadd float %170, %171
  store float %172, ptr %169, align 4
  %173 = or disjoint i32 %86, 14
  %174 = trunc nuw nsw i32 %173 to i20
  %175 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %174
  %176 = load float, ptr %175, align 4
  %177 = fmul float %89, %83
  %178 = fadd float %176, %177
  store float %178, ptr %175, align 4
  %179 = or disjoint i32 %86, 15
  %180 = trunc nuw nsw i32 %179 to i20
  %181 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i20 %180
  %182 = load float, ptr %181, align 4
  %183 = fmul float %89, %84
  %184 = fadd float %182, %183
  store float %184, ptr %181, align 4
  %185 = add nuw nsw i32 %85, 1
  %exitcond13.not = icmp eq i32 %185, 8
  br i1 %exitcond13.not, label %186, label %.preheader5, !llvm.loop !1

186:                                              ; preds = %.preheader5
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 57, i32 1)
  br label %.preheader6
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse noreturn nosync nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
