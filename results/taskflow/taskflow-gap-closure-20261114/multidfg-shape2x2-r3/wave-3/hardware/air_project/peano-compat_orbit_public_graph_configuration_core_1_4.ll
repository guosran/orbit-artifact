; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@buf0 = external global [2048 x float]
@buf1 = external global [1024 x float]
@buf2 = external global [1024 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @core_1_4() {
  br label %1

1:                                                ; preds = %20, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %18, %1
  %3 = phi i32 [ %19, %18 ], [ 48, %1 ]
  %4 = icmp slt i32 %3, 64
  br i1 %4, label %5, label %20

5:                                                ; preds = %2
  %6 = sub i32 %3, 48
  br label %7

7:                                                ; preds = %10, %5
  %8 = phi i32 [ %17, %10 ], [ 0, %5 ]
  %9 = icmp slt i32 %8, 64
  br i1 %9, label %10, label %18

10:                                               ; preds = %7
  %11 = mul nuw nsw i32 %6, 64
  %12 = add nuw nsw i32 %11, %8
  %13 = getelementptr inbounds nuw float, ptr @buf2, i32 %12
  %14 = load float, ptr %13
  %15 = fadd float %14, %14
  %16 = getelementptr inbounds nuw float, ptr @buf0, i32 %12
  store float %15, ptr %16
  %17 = add i32 %8, 1
  br label %7, !llvm.loop !2

18:                                               ; preds = %7
  %19 = add i32 %3, 1
  br label %2, !llvm.loop !2

20:                                               ; preds = %2
  call void @llvm.aie2p.release(i32 51, i32 1)
  call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

!llvm.module.flags = !{!3}

!1 = !{!"llvm.loop.mustprogress"}
!2 = distinct !{!2, !1}
!3 = !{i32 2, !"Debug Info Version", i32 3}
