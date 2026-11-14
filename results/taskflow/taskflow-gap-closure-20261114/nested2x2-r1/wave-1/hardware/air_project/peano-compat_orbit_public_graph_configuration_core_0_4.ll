; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@buf0 = external global [256 x float]
@buf1 = external global [256 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @core_0_4() {
  br label %1

1:                                                ; preds = %20, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %18, %1
  %3 = phi i32 [ %19, %18 ], [ 0, %1 ]
  %4 = icmp slt i32 %3, 16
  br i1 %4, label %5, label %20

5:                                                ; preds = %2
  br label %6

6:                                                ; preds = %9, %5
  %7 = phi i32 [ %17, %9 ], [ 16, %5 ]
  %8 = icmp slt i32 %7, 32
  br i1 %8, label %9, label %18

9:                                                ; preds = %6
  %10 = sub i32 %7, 16
  %11 = mul nuw nsw i32 %3, 16
  %12 = add nuw nsw i32 %11, %10
  %13 = getelementptr inbounds nuw float, ptr @buf1, i32 %12
  %14 = load float, ptr %13
  %15 = fadd float %14, %14
  %16 = getelementptr inbounds nuw float, ptr @buf0, i32 %12
  store float %15, ptr %16
  %17 = add i32 %7, 1
  br label %6, !llvm.loop !2

18:                                               ; preds = %6
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
