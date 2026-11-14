; ModuleID = 'core'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@__aiecc_canon_0 = external global [256 x float]
@__aiecc_canon_1 = external global [256 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @__aiecc_canon_2() {
  br label %1

1:                                                ; preds = %21, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %19, %1
  %3 = phi i32 [ %20, %19 ], [ 16, %1 ]
  %4 = icmp slt i32 %3, 32
  br i1 %4, label %5, label %21

5:                                                ; preds = %2
  %6 = sub i32 %3, 16
  br label %7

7:                                                ; preds = %10, %5
  %8 = phi i32 [ %18, %10 ], [ 16, %5 ]
  %9 = icmp slt i32 %8, 32
  br i1 %9, label %10, label %19

10:                                               ; preds = %7
  %11 = sub i32 %8, 16
  %12 = mul nuw nsw i32 %6, 16
  %13 = add nuw nsw i32 %12, %11
  %14 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i32 %13
  %15 = load float, ptr %14, align 4
  %16 = fadd float %15, %15
  %17 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i32 %13
  store float %16, ptr %17, align 4
  %18 = add i32 %8, 1
  br label %7, !llvm.loop !3

19:                                               ; preds = %7
  %20 = add i32 %3, 1
  br label %2, !llvm.loop !3

21:                                               ; preds = %2
  call void @llvm.aie2p.release(i32 51, i32 1)
  call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

!llvm.module.flags = !{!4}

!2 = !{!"llvm.loop.mustprogress"}
!3 = distinct !{!3, !2}
!4 = !{i32 2, !"Debug Info Version", i32 3}
