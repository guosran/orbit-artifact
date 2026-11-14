; ModuleID = 'core'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@__aiecc_canon_0 = external global [704 x float]
@__aiecc_canon_1 = external global [704 x float]
@__aiecc_canon_2 = external global [704 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @__aiecc_canon_3() {
  br label %1

1:                                                ; preds = %36, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %17, %1
  %3 = phi i32 [ %18, %17 ], [ 0, %1 ]
  %4 = icmp slt i32 %3, 11
  br i1 %4, label %5, label %19

5:                                                ; preds = %2
  br label %6

6:                                                ; preds = %9, %5
  %7 = phi i32 [ %16, %9 ], [ 0, %5 ]
  %8 = icmp slt i32 %7, 64
  br i1 %8, label %9, label %17

9:                                                ; preds = %6
  %10 = mul nuw nsw i32 %3, 64
  %11 = add nuw nsw i32 %10, %7
  %12 = getelementptr inbounds nuw float, ptr @__aiecc_canon_2, i32 %11
  %13 = load float, ptr %12, align 4
  %14 = fadd float %13, %13
  %15 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i32 %11
  store float %14, ptr %15, align 4
  %16 = add i32 %7, 1
  br label %6, !llvm.loop !3

17:                                               ; preds = %6
  %18 = add i32 %3, 1
  br label %2, !llvm.loop !3

19:                                               ; preds = %2
  call void @llvm.aie2p.release(i32 51, i32 1)
  br label %20

20:                                               ; preds = %34, %19
  %21 = phi i32 [ %35, %34 ], [ 0, %19 ]
  %22 = icmp slt i32 %21, 11
  br i1 %22, label %23, label %36

23:                                               ; preds = %20
  br label %24

24:                                               ; preds = %27, %23
  %25 = phi i32 [ %33, %27 ], [ 0, %23 ]
  %26 = icmp slt i32 %25, 64
  br i1 %26, label %27, label %34

27:                                               ; preds = %24
  %28 = mul nuw nsw i32 %21, 64
  %29 = add nuw nsw i32 %28, %25
  %30 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i32 %29
  %31 = load float, ptr %30, align 4
  %32 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i32 %29
  store float %31, ptr %32, align 4
  %33 = add i32 %25, 1
  br label %24, !llvm.loop !3

34:                                               ; preds = %24
  %35 = add i32 %21, 1
  br label %20, !llvm.loop !3

36:                                               ; preds = %20
  call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

!llvm.module.flags = !{!4}

!2 = !{!"llvm.loop.mustprogress"}
!3 = distinct !{!3, !2}
!4 = !{i32 2, !"Debug Info Version", i32 3}
