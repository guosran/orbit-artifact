; ModuleID = 'core'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@__aiecc_canon_0 = external global [2048 x float]
@__aiecc_canon_1 = external global [1024 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @__aiecc_canon_2() {
  br label %1

1:                                                ; preds = %19, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %17, %1
  %3 = phi i32 [ %18, %17 ], [ 48, %1 ]
  %4 = icmp slt i32 %3, 64
  br i1 %4, label %5, label %19

5:                                                ; preds = %2
  %6 = sub i32 %3, 48
  br label %7

7:                                                ; preds = %10, %5
  %8 = phi i32 [ %16, %10 ], [ 0, %5 ]
  %9 = icmp slt i32 %8, 64
  br i1 %9, label %10, label %17

10:                                               ; preds = %7
  %11 = mul nuw nsw i32 %6, 64
  %12 = add nuw nsw i32 %11, %8
  %13 = getelementptr inbounds nuw float, ptr getelementptr inbounds nuw (i8, ptr @__aiecc_canon_0, i64 4096), i32 %12
  %14 = load float, ptr %13, align 4
  %15 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i32 %12
  store float %14, ptr %15, align 4
  %16 = add i32 %8, 1
  br label %7, !llvm.loop !3

17:                                               ; preds = %7
  %18 = add i32 %3, 1
  br label %2, !llvm.loop !3

19:                                               ; preds = %2
  call void @llvm.aie2p.release(i32 51, i32 1)
  call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

!llvm.module.flags = !{!4}

!2 = !{!"llvm.loop.mustprogress"}
!3 = distinct !{!3, !2}
!4 = !{i32 2, !"Debug Info Version", i32 3}
