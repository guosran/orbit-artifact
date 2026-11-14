; ModuleID = 'core'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@__aiecc_canon_0 = external global [2048 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @__aiecc_canon_1() {
  br label %1

1:                                                ; preds = %34, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %16, %1
  %3 = phi i32 [ %17, %16 ], [ 0, %1 ]
  %4 = icmp slt i32 %3, 16
  br i1 %4, label %5, label %18

5:                                                ; preds = %2
  br label %6

6:                                                ; preds = %9, %5
  %7 = phi i32 [ %15, %9 ], [ 0, %5 ]
  %8 = icmp slt i32 %7, 64
  br i1 %8, label %9, label %16

9:                                                ; preds = %6
  %10 = mul nuw nsw i32 %3, 64
  %11 = add nuw nsw i32 %10, %7
  %12 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i32 %11
  %13 = load float, ptr %12, align 4
  %14 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i64 4096), i32 %11
  store float %13, ptr %14, align 4
  %15 = add i32 %7, 1
  br label %6, !llvm.loop !3

16:                                               ; preds = %6
  %17 = add i32 %3, 1
  br label %2, !llvm.loop !3

18:                                               ; preds = %32, %2
  %19 = phi i32 [ %33, %32 ], [ 0, %2 ]
  %20 = icmp slt i32 %19, 16
  br i1 %20, label %21, label %34

21:                                               ; preds = %18
  br label %22

22:                                               ; preds = %25, %21
  %23 = phi i32 [ %31, %25 ], [ 0, %21 ]
  %24 = icmp slt i32 %23, 64
  br i1 %24, label %25, label %32

25:                                               ; preds = %22
  %26 = mul nuw nsw i32 %19, 64
  %27 = add nuw nsw i32 %26, %23
  %28 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i64 4096), i32 %27
  %29 = load float, ptr %28, align 4
  %30 = fadd float %29, %29
  store float %30, ptr %28, align 4
  %31 = add i32 %23, 1
  br label %22, !llvm.loop !3

32:                                               ; preds = %22
  %33 = add i32 %19, 1
  br label %18, !llvm.loop !3

34:                                               ; preds = %18
  call void @llvm.aie2p.release(i32 51, i32 1)
  call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

!llvm.module.flags = !{!4}

!2 = !{!"llvm.loop.mustprogress"}
!3 = distinct !{!3, !2}
!4 = !{i32 2, !"Debug Info Version", i32 3}
