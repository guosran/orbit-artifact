; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/holdout-m17-k129-n80-t8x32x32-mixed8-phase/hardware/air_project/canonical_5F17220DAD70BBC5.ll'
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

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_5() local_unnamed_addr #2 {
  br label %.preheader

.preheader:                                       ; preds = %136, %0
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

.preheader8:                                      ; preds = %.preheader, %72
  %1 = phi i32 [ %73, %72 ], [ 0, %.preheader ]
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 54, i32 -1)
  br label %2

2:                                                ; preds = %.preheader8, %70
  %3 = phi i32 [ 8, %.preheader8 ], [ %71, %70 ]
  %4 = add nsw i32 %3, -8
  %5 = shl nuw nsw i32 %4, 5
  %6 = shl i32 %4, 4
  br label %7

7:                                                ; preds = %2, %67
  %8 = phi i32 [ 64, %2 ], [ %68, %67 ]
  %9 = add nsw i32 %8, -64
  %10 = add nuw nsw i32 %9, %6
  %11 = trunc i32 %10 to i20
  %12 = getelementptr float, ptr @__aiecc_canon_2, i20 %11
  %.promoted = load <8 x float>, ptr %12, align 32
  br label %13

13:                                               ; preds = %7, %13
  %14 = phi i32 [ 0, %7 ], [ %66, %13 ]
  %15 = phi <8 x float> [ %.promoted, %7 ], [ %65, %13 ]
  %16 = add nuw nsw i32 %14, %5
  %17 = trunc nuw nsw i32 %16 to i20
  %18 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %17
  %19 = load float, ptr %18, align 4
  %20 = shl nuw nsw i32 %14, 4
  %21 = add nuw nsw i32 %20, %9
  %22 = trunc i32 %21 to i20
  %23 = getelementptr float, ptr @__aiecc_canon_1, i20 %22
  %24 = load float, ptr %23, align 32
  %25 = tail call float @__mulsf3(float %19, float %24)
  %26 = getelementptr inbounds nuw i8, ptr %23, i20 4
  %27 = load float, ptr %26, align 4
  %28 = tail call float @__mulsf3(float %19, float %27)
  %29 = getelementptr inbounds nuw i8, ptr %23, i20 8
  %30 = load float, ptr %29, align 8
  %31 = tail call float @__mulsf3(float %19, float %30)
  %32 = getelementptr inbounds nuw i8, ptr %23, i20 12
  %33 = load float, ptr %32, align 4
  %34 = tail call float @__mulsf3(float %19, float %33)
  %35 = getelementptr inbounds nuw i8, ptr %23, i20 16
  %36 = load float, ptr %35, align 16
  %37 = tail call float @__mulsf3(float %19, float %36)
  %38 = getelementptr inbounds nuw i8, ptr %23, i20 20
  %39 = load float, ptr %38, align 4
  %40 = tail call float @__mulsf3(float %19, float %39)
  %41 = getelementptr inbounds nuw i8, ptr %23, i20 24
  %42 = load float, ptr %41, align 8
  %43 = tail call float @__mulsf3(float %19, float %42)
  %44 = getelementptr inbounds nuw i8, ptr %23, i20 28
  %45 = load float, ptr %44, align 4
  %46 = tail call float @__mulsf3(float %19, float %45)
  %47 = insertelement <8 x float> poison, float %25, i64 0
  %48 = insertelement <8 x float> %47, float %28, i64 1
  %49 = insertelement <8 x float> %48, float %31, i64 2
  %50 = insertelement <8 x float> %49, float %34, i64 3
  %51 = insertelement <8 x float> %50, float %37, i64 4
  %52 = insertelement <8 x float> %51, float %40, i64 5
  %53 = insertelement <8 x float> %52, float %43, i64 6
  %54 = insertelement <8 x float> %53, float %46, i64 7
  %55 = bitcast <8 x float> %15 to <4 x i64>
  %56 = bitcast <8 x float> %54 to <4 x i64>
  %57 = shufflevector <4 x i64> %55, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %58 = shufflevector <4 x i64> %56, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %59 = bitcast <32 x i64> %57 to <64 x float>
  %60 = bitcast <32 x i64> %58 to <64 x float>
  %61 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %59, <64 x float> %60, i32 60)
  %62 = bitcast <64 x float> %61 to <32 x i64>
  %63 = shufflevector <32 x i64> %62, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %64 = bitcast <8 x i64> %63 to <16 x float>
  %65 = shufflevector <16 x float> %64, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %65, ptr %12, align 32
  %66 = add nuw nsw i32 %14, 1
  %exitcond9.not = icmp eq i32 %66, 32
  br i1 %exitcond9.not, label %67, label %13, !llvm.loop !1

67:                                               ; preds = %13
  %68 = add nuw nsw i32 %8, 8
  %69 = icmp samesign ult i32 %8, 72
  br i1 %69, label %7, label %70, !llvm.loop !1

70:                                               ; preds = %67
  %71 = add nuw nsw i32 %3, 1
  %exitcond10.not = icmp eq i32 %71, 16
  br i1 %exitcond10.not, label %72, label %2, !llvm.loop !1

72:                                               ; preds = %70
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  tail call void @llvm.aie2p.release(i32 55, i32 1)
  %73 = add nuw nsw i32 %1, 1
  %exitcond11.not = icmp eq i32 %73, 4
  br i1 %exitcond11.not, label %74, label %.preheader8, !llvm.loop !1

74:                                               ; preds = %72
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  tail call void @llvm.aie2p.acquire(i32 56, i32 -1)
  br label %75

75:                                               ; preds = %74, %134
  %76 = phi i32 [ 8, %74 ], [ %135, %134 ]
  %77 = add nsw i32 %76, -8
  %78 = trunc nuw nsw i32 %77 to i20
  %79 = getelementptr inbounds nuw float, ptr @__aiecc_canon_4, i20 %78
  %80 = load float, ptr %79, align 4
  %81 = shl i32 %77, 4
  br label %82

82:                                               ; preds = %75, %82
  %83 = phi i32 [ 64, %75 ], [ %132, %82 ]
  %84 = add nsw i32 %83, -64
  %85 = trunc i32 %84 to i20
  %86 = getelementptr float, ptr @__aiecc_canon_3, i20 %85
  %87 = add nuw nsw i32 %84, %81
  %88 = trunc i32 %87 to i20
  %89 = getelementptr float, ptr @__aiecc_canon_2, i20 %88
  %90 = load <4 x i64>, ptr %89, align 32
  %91 = load float, ptr %86, align 32
  %92 = tail call float @__mulsf3(float %80, float %91)
  %93 = getelementptr inbounds nuw i8, ptr %86, i20 4
  %94 = load float, ptr %93, align 4
  %95 = tail call float @__mulsf3(float %80, float %94)
  %96 = getelementptr inbounds nuw i8, ptr %86, i20 8
  %97 = load float, ptr %96, align 8
  %98 = tail call float @__mulsf3(float %80, float %97)
  %99 = getelementptr inbounds nuw i8, ptr %86, i20 12
  %100 = load float, ptr %99, align 4
  %101 = tail call float @__mulsf3(float %80, float %100)
  %102 = getelementptr inbounds nuw i8, ptr %86, i20 16
  %103 = load float, ptr %102, align 16
  %104 = tail call float @__mulsf3(float %80, float %103)
  %105 = getelementptr inbounds nuw i8, ptr %86, i20 20
  %106 = load float, ptr %105, align 4
  %107 = tail call float @__mulsf3(float %80, float %106)
  %108 = getelementptr inbounds nuw i8, ptr %86, i20 24
  %109 = load float, ptr %108, align 8
  %110 = tail call float @__mulsf3(float %80, float %109)
  %111 = getelementptr inbounds nuw i8, ptr %86, i20 28
  %112 = load float, ptr %111, align 4
  %113 = tail call float @__mulsf3(float %80, float %112)
  %114 = insertelement <8 x float> poison, float %92, i64 0
  %115 = insertelement <8 x float> %114, float %95, i64 1
  %116 = insertelement <8 x float> %115, float %98, i64 2
  %117 = insertelement <8 x float> %116, float %101, i64 3
  %118 = insertelement <8 x float> %117, float %104, i64 4
  %119 = insertelement <8 x float> %118, float %107, i64 5
  %120 = insertelement <8 x float> %119, float %110, i64 6
  %121 = insertelement <8 x float> %120, float %113, i64 7
  %122 = bitcast <8 x float> %121 to <4 x i64>
  %123 = shufflevector <4 x i64> %90, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %124 = shufflevector <4 x i64> %122, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %125 = bitcast <32 x i64> %123 to <64 x float>
  %126 = bitcast <32 x i64> %124 to <64 x float>
  %127 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %125, <64 x float> %126, i32 60)
  %128 = bitcast <64 x float> %127 to <32 x i64>
  %129 = shufflevector <32 x i64> %128, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %130 = bitcast <8 x i64> %129 to <16 x float>
  %131 = shufflevector <16 x float> %130, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %131, ptr %89, align 32
  %132 = add nuw nsw i32 %83, 8
  %133 = icmp samesign ult i32 %83, 72
  br i1 %133, label %82, label %134, !llvm.loop !1

134:                                              ; preds = %82
  %135 = add nuw nsw i32 %76, 1
  %exitcond12.not = icmp eq i32 %135, 16
  br i1 %exitcond12.not, label %136, label %75, !llvm.loop !1

136:                                              ; preds = %134
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  tail call void @llvm.aie2p.release(i32 57, i32 1)
  br label %.preheader
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: read)
declare <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float>, <64 x float>, i32) #3

attributes #0 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync memory(none) }
attributes #2 = { nofree noreturn nosync }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: read) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.mustprogress"}
