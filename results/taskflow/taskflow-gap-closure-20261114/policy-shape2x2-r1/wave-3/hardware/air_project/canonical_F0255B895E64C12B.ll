; ModuleID = 'core'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@__aiecc_canon_0 = external global [512 x float]
@__aiecc_canon_1 = external global [512 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @__aiecc_canon_2() {
  br label %1

1:                                                ; preds = %20, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %18, %1
  %3 = phi i32 [ %19, %18 ], [ 24, %1 ]
  %4 = icmp slt i32 %3, 32
  br i1 %4, label %5, label %20

5:                                                ; preds = %2
  %6 = sub i32 %3, 24
  br label %7

7:                                                ; preds = %10, %5
  %8 = phi i32 [ %17, %10 ], [ 0, %5 ]
  %9 = icmp slt i32 %8, 64
  br i1 %9, label %10, label %18

10:                                               ; preds = %7
  %11 = mul nuw nsw i32 %6, 64
  %12 = add nuw nsw i32 %11, %8
  %13 = getelementptr inbounds nuw float, ptr @__aiecc_canon_1, i32 %12
  %14 = load float, ptr %13, align 4
  %15 = fadd float %14, %14
  %16 = getelementptr inbounds nuw float, ptr @__aiecc_canon_0, i32 %12
  store float %15, ptr %16, align 4
  %17 = add i32 %8, 1
  br label %7, !llvm.loop !3

18:                                               ; preds = %7
  %19 = add i32 %3, 1
  br label %2, !llvm.loop !3

20:                                               ; preds = %2
  call void @llvm.aie2p.release(i32 51, i32 1)
  call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

!llvm.module.flags = !{!4}

!2 = !{!"llvm.loop.mustprogress"}
!3 = distinct !{!3, !2}
!4 = !{i32 2, !"Debug Info Version", i32 3}
