; ModuleID = '/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r3/train-m32-k128-n64-t8x16x32-mixed8-panel/hardware/air_project/canonical_6BDDB00B071AA19D.ll'
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

; Function Attrs: nofree nosync memory(none)
declare float @__mulsf3(float, float) local_unnamed_addr #1

; Function Attrs: nofree noreturn nosync
define void @__aiecc_canon_3() local_unnamed_addr #2 {
  br label %1

1:                                                ; preds = %78, %0
  tail call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %.preheader5

.preheader5:                                      ; preds = %1, %76
  %2 = phi i32 [ 0, %1 ], [ %77, %76 ]
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

.preheader6:                                      ; preds = %.preheader5, %73
  %3 = phi i32 [ %74, %73 ], [ 0, %.preheader5 ]
  tail call void @llvm.aie2p.acquire(i32 52, i32 -1)
  br label %.preheader

.preheader:                                       ; preds = %.preheader6, %71
  %4 = phi i32 [ 0, %.preheader6 ], [ %72, %71 ]
  %5 = shl nuw nsw i32 %4, 5
  %6 = shl i32 %4, 4
  br label %7

7:                                                ; preds = %.preheader, %68
  %8 = phi i32 [ 16, %.preheader ], [ %69, %68 ]
  %9 = add nsw i32 %8, -16
  %10 = add nuw nsw i32 %9, %6
  %11 = trunc i32 %10 to i20
  %12 = getelementptr float, ptr @__aiecc_canon_1, i20 %11
  %.promoted = load <8 x float>, ptr %12, align 32
  br label %13

13:                                               ; preds = %7, %13
  %14 = phi i32 [ 0, %7 ], [ %67, %13 ]
  %15 = phi <8 x float> [ %.promoted, %7 ], [ %66, %13 ]
  %16 = add nuw nsw i32 %14, %3
  %17 = add nuw nsw i32 %14, %5
  %18 = trunc nuw nsw i32 %17 to i20
  %19 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i20 %18
  %20 = load float, ptr %19, align 4
  %21 = shl nuw nsw i32 %16, 4
  %22 = add nuw nsw i32 %21, %9
  %23 = trunc i32 %22 to i20
  %24 = getelementptr float, ptr @__aiecc_canon_2, i20 %23
  %25 = load float, ptr %24, align 32
  %26 = tail call float @__mulsf3(float %20, float %25)
  %27 = getelementptr inbounds nuw i8, ptr %24, i20 4
  %28 = load float, ptr %27, align 4
  %29 = tail call float @__mulsf3(float %20, float %28)
  %30 = getelementptr inbounds nuw i8, ptr %24, i20 8
  %31 = load float, ptr %30, align 8
  %32 = tail call float @__mulsf3(float %20, float %31)
  %33 = getelementptr inbounds nuw i8, ptr %24, i20 12
  %34 = load float, ptr %33, align 4
  %35 = tail call float @__mulsf3(float %20, float %34)
  %36 = getelementptr inbounds nuw i8, ptr %24, i20 16
  %37 = load float, ptr %36, align 16
  %38 = tail call float @__mulsf3(float %20, float %37)
  %39 = getelementptr inbounds nuw i8, ptr %24, i20 20
  %40 = load float, ptr %39, align 4
  %41 = tail call float @__mulsf3(float %20, float %40)
  %42 = getelementptr inbounds nuw i8, ptr %24, i20 24
  %43 = load float, ptr %42, align 8
  %44 = tail call float @__mulsf3(float %20, float %43)
  %45 = getelementptr inbounds nuw i8, ptr %24, i20 28
  %46 = load float, ptr %45, align 4
  %47 = tail call float @__mulsf3(float %20, float %46)
  %48 = insertelement <8 x float> poison, float %26, i64 0
  %49 = insertelement <8 x float> %48, float %29, i64 1
  %50 = insertelement <8 x float> %49, float %32, i64 2
  %51 = insertelement <8 x float> %50, float %35, i64 3
  %52 = insertelement <8 x float> %51, float %38, i64 4
  %53 = insertelement <8 x float> %52, float %41, i64 5
  %54 = insertelement <8 x float> %53, float %44, i64 6
  %55 = insertelement <8 x float> %54, float %47, i64 7
  %56 = bitcast <8 x float> %15 to <4 x i64>
  %57 = bitcast <8 x float> %55 to <4 x i64>
  %58 = shufflevector <4 x i64> %56, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %59 = shufflevector <4 x i64> %57, <4 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
  %60 = bitcast <32 x i64> %58 to <64 x float>
  %61 = bitcast <32 x i64> %59 to <64 x float>
  %62 = tail call <64 x float> @llvm.aie2p.ACC2048.accfloat.add.conf(<64 x float> %60, <64 x float> %61, i32 60)
  %63 = bitcast <64 x float> %62 to <32 x i64>
  %64 = shufflevector <32 x i64> %63, <32 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 poison, i32 poison, i32 poison, i32 poison>
  %65 = bitcast <8 x i64> %64 to <16 x float>
  %66 = shufflevector <16 x float> %65, <16 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %66, ptr %12, align 32
  %67 = add nuw nsw i32 %14, 1
  %exitcond7.not = icmp eq i32 %67, 32
  br i1 %exitcond7.not, label %68, label %13, !llvm.loop !1

68:                                               ; preds = %13
  %69 = add nuw nsw i32 %8, 8
  %70 = icmp samesign ult i32 %8, 24
  br i1 %70, label %7, label %71, !llvm.loop !1

71:                                               ; preds = %68
  %72 = add nuw nsw i32 %4, 1
  %exitcond8.not = icmp eq i32 %72, 8
  br i1 %exitcond8.not, label %73, label %.preheader, !llvm.loop !1

73:                                               ; preds = %71
  tail call void @llvm.aie2p.release(i32 53, i32 1)
  %74 = add nuw nsw i32 %3, 32
  %75 = icmp samesign ult i32 %3, 96
  br i1 %75, label %.preheader6, label %76, !llvm.loop !1

76:                                               ; preds = %73
  tail call void @llvm.aie2p.release(i32 48, i32 1)
  %77 = add nuw nsw i32 %2, 1
  %exitcond9.not = icmp eq i32 %77, 4
  br i1 %exitcond9.not, label %78, label %.preheader5, !llvm.loop !1

78:                                               ; preds = %76
  tail call void @llvm.aie2p.release(i32 51, i32 1)
  br label %1
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
