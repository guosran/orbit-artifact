; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "aie2p"

@buf0 = external global [1024 x float]
@buf1 = external global [1024 x float]

; Unknown intrinsic
declare void @llvm.aie2p.acquire(i32, i32)

; Unknown intrinsic
declare void @llvm.aie2p.release(i32, i32)

define void @core_0_3() {
  br label %1

1:                                                ; preds = %19, %0
  call void @llvm.aie2p.acquire(i32 49, i32 -1)
  call void @llvm.aie2p.acquire(i32 50, i32 -1)
  br label %2

2:                                                ; preds = %17, %1
  %3 = phi i32 [ %18, %17 ], [ 0, %1 ]
  %4 = icmp slt i32 %3, 32
  br i1 %4, label %5, label %19

5:                                                ; preds = %2
  br label %6

6:                                                ; preds = %9, %5
  %7 = phi i32 [ %16, %9 ], [ 0, %5 ]
  %8 = icmp slt i32 %7, 32
  br i1 %8, label %9, label %17

9:                                                ; preds = %6
  %10 = mul nuw nsw i32 %3, 32
  %11 = add nuw nsw i32 %10, %7
  %12 = getelementptr inbounds nuw float, ptr @buf1, i32 %11
  %13 = load float, ptr %12
  %14 = fadd float %13, %13
  %15 = getelementptr inbounds nuw float, ptr @buf0, i32 %11
  store float %14, ptr %15
  %16 = add i32 %7, 1
  br label %6, !llvm.loop !2

17:                                               ; preds = %6
  %18 = add i32 %3, 1
  br label %2, !llvm.loop !2

19:                                               ; preds = %2
  call void @llvm.aie2p.release(i32 51, i32 1)
  call void @llvm.aie2p.release(i32 48, i32 1)
  br label %1
}

!llvm.module.flags = !{!3}

!1 = !{!"llvm.loop.mustprogress"}
!2 = distinct !{!2, !1}
!3 = !{i32 2, !"Debug Info Version", i32 3}
