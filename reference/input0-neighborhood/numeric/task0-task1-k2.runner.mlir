module {
  func.func @_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i(%arg0: i32, %arg1: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>}, %arg2: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg3: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg4: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg5: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg6: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg7: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 256, 256>}, %arg8: memref<?x256xi32> {amoeba.logical_transfer_shape = array<i64: 512, 256>}) attributes {amoeba.graph_variant_id = "identity", amoeba.replica.count = 2 : i64, amoeba.replica.materialized_task = "Task_1", amoeba.replica.parent_task = "Task_1", amoeba.replica.shard_axis = 0 : i64, amoeba.replica.shard_trip_count = 10485760 : i64, amoeba.replica.total_trip_count = 20971520 : i64, amoeba.static_bound.arg.0 = 320 : i64, llvm.linkage = #llvm.linkage<external>} {
    %c320 = arith.constant 320 : index
    %c1024_i32 = arith.constant 1024 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<512x256xi32>
    %alloca_0 = memref.alloca() : memref<512x256xi32>
    %alloca_1 = memref.alloca() : memref<512x256xi32>
    %alloca_2 = memref.alloca() : memref<512xi32>
    %alloca_3 = memref.alloca() : memref<512x512xi32>
    %alloca_4 = memref.alloca() : memref<512x512xi32>
    %alloca_5 = memref.alloca() : memref<512x256xi32>
    %alloca_6 = memref.alloca() : memref<512x256xi32>
    %alloca_7 = memref.alloca() : memref<512x256xi32>
    %c256 = arith.constant 256 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c0_8 = arith.constant 0 : index
    %c160 = arith.constant 160 : index
    %true = arith.constant true
    %c0_9 = arith.constant 0 : index
    %dim = memref.dim %arg1, %c0_9 : memref<?x256xi32>
    %c0_10 = arith.constant 0 : index
    %dim_11 = memref.dim %arg2, %c0_10 : memref<?x256xi32>
    %c0_12 = arith.constant 0 : index
    %c160_13 = arith.constant 160 : index
    %c1_14 = arith.constant 1 : index
    %c0_15 = arith.constant 0 : index
    %c256_16 = arith.constant 256 : index
    %c1_17 = arith.constant 1 : index
    %c0_18 = arith.constant 0 : index
    %c256_19 = arith.constant 256 : index
    %c1_20 = arith.constant 1 : index
    %c0_i32_21 = arith.constant 0 : i32
    %false = arith.constant false
    scf.for %arg9 = %c0_12 to %c160_13 step %c1_14 {
      scf.for %arg10 = %c0_15 to %c256_16 step %c1_17 {
        %0:4 = scf.for %arg11 = %c0_18 to %c256_19 step %c1_20 iter_args(%arg12 = %c0_i32, %arg13 = %true, %arg14 = %c0_i32_21, %arg15 = %false) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_18 : index
          %c0_184 = arith.constant 0 : index
          %c160_185 = arith.constant 160 : index
          %2 = arith.andi %true, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_186 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_186 : index
          %6 = arith.andi %true, %true : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_187 = arith.constant true
          %17 = arith.xori %5, %true_187 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_188 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_188 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_189 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_189 : index
          %c256_190 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_190 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_7[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true, %44 : i1
          %c0_191 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_191 : index
          %47 = arith.cmpi slt, %43, %dim : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_192 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_192 : index
          %c256_193 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_193 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %91 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %56 = arith.andi %true, %42 : i1
          %c0_194 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_194 : index
          %58 = arith.cmpi slt, %41, %dim_11 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_195 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_195 : index
          %c256_196 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_196 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %91 = memref.load %arg2[%41, %39] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true : i1
          %72 = arith.andi %71, %44 : i1
          %c0_197 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_197 : index
          %c512_198 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_198 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_199 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_199 : index
          %c256_200 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_200 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_7[%43, %39] : memref<512x256xi32>
          }
          %82 = arith.addi %arg9, %c1_14 : index
          %83 = arith.cmpi sge, %82, %c160_13 : index
          %true_201 = arith.constant true
          %84 = arith.xori %83, %true_201 : i1
          %85 = arith.andi %true, %84 : i1
          %86 = arith.andi %4, %85 : i1
          %87 = arith.select %86, %3, %arg14 : i32
          %88 = arith.ori %86, %arg15 : i1
          %89 = arith.select %69, %70, %arg12 : i32
          %90 = arith.ori %69, %arg13 : i1
          scf.yield %89, %90, %87, %88 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_0.replica.0", amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 160, 256>]}
    %c256_22 = arith.constant 256 : index
    %c0_23 = arith.constant 0 : index
    %c1_24 = arith.constant 1 : index
    %c160_25 = arith.constant 160 : index
    %c320_26 = arith.constant 320 : index
    %true_27 = arith.constant true
    %c0_28 = arith.constant 0 : index
    %dim_29 = memref.dim %arg1, %c0_28 : memref<?x256xi32>
    %c0_30 = arith.constant 0 : index
    %dim_31 = memref.dim %arg2, %c0_30 : memref<?x256xi32>
    %c160_32 = arith.constant 160 : index
    %c320_33 = arith.constant 320 : index
    %c1_34 = arith.constant 1 : index
    %c0_35 = arith.constant 0 : index
    %c256_36 = arith.constant 256 : index
    %c1_37 = arith.constant 1 : index
    %c0_38 = arith.constant 0 : index
    %c256_39 = arith.constant 256 : index
    %c1_40 = arith.constant 1 : index
    %c0_i32_41 = arith.constant 0 : i32
    %false_42 = arith.constant false
    scf.for %arg9 = %c160_32 to %c320_33 step %c1_34 {
      scf.for %arg10 = %c0_35 to %c256_36 step %c1_37 {
        %0:4 = scf.for %arg11 = %c0_38 to %c256_39 step %c1_40 iter_args(%arg12 = %c0_i32, %arg13 = %true_27, %arg14 = %c0_i32_41, %arg15 = %false_42) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_38 : index
          %c160_184 = arith.constant 160 : index
          %c320_185 = arith.constant 320 : index
          %2 = arith.andi %true_27, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_186 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_186 : index
          %6 = arith.andi %true_27, %true_27 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_27, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_27, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_27, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_27, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_187 = arith.constant true
          %17 = arith.xori %5, %true_187 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_27, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_27, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_27, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_27, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_188 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_188 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_189 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_189 : index
          %c256_190 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_190 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_7[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_27, %44 : i1
          %c0_191 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_191 : index
          %47 = arith.cmpi slt, %43, %dim_29 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_192 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_192 : index
          %c256_193 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_193 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %91 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %56 = arith.andi %true_27, %42 : i1
          %c0_194 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_194 : index
          %58 = arith.cmpi slt, %41, %dim_31 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_195 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_195 : index
          %c256_196 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_196 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %91 = memref.load %arg2[%41, %39] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_27 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_197 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_197 : index
          %c512_198 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_198 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_199 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_199 : index
          %c256_200 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_200 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_7[%43, %39] : memref<512x256xi32>
          }
          %82 = arith.addi %arg9, %c1_34 : index
          %83 = arith.cmpi sge, %82, %c320_33 : index
          %true_201 = arith.constant true
          %84 = arith.xori %83, %true_201 : i1
          %85 = arith.andi %true_27, %84 : i1
          %86 = arith.andi %4, %85 : i1
          %87 = arith.select %86, %3, %arg14 : i32
          %88 = arith.ori %86, %arg15 : i1
          %89 = arith.select %69, %70, %arg12 : i32
          %90 = arith.ori %69, %arg13 : i1
          scf.yield %89, %90, %87, %88 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_0.replica.1", amoeba.tiling.output_region_lowers = [array<i64: 160, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 256>]}
    %c256_43 = arith.constant 256 : index
    %c0_44 = arith.constant 0 : index
    %c1_45 = arith.constant 1 : index
    %c0_46 = arith.constant 0 : index
    %c160_47 = arith.constant 160 : index
    %true_48 = arith.constant true
    %c0_49 = arith.constant 0 : index
    %dim_50 = memref.dim %arg1, %c0_49 : memref<?x256xi32>
    %c0_51 = arith.constant 0 : index
    %dim_52 = memref.dim %arg3, %c0_51 : memref<?x256xi32>
    %c0_53 = arith.constant 0 : index
    %c160_54 = arith.constant 160 : index
    %c1_55 = arith.constant 1 : index
    %c0_56 = arith.constant 0 : index
    %c256_57 = arith.constant 256 : index
    %c1_58 = arith.constant 1 : index
    %c0_59 = arith.constant 0 : index
    %c256_60 = arith.constant 256 : index
    %c1_61 = arith.constant 1 : index
    %c0_i32_62 = arith.constant 0 : i32
    %false_63 = arith.constant false
    scf.for %arg9 = %c0_53 to %c160_54 step %c1_55 {
      scf.for %arg10 = %c0_56 to %c256_57 step %c1_58 {
        %0:4 = scf.for %arg11 = %c0_59 to %c256_60 step %c1_61 iter_args(%arg12 = %c0_i32, %arg13 = %true_48, %arg14 = %c0_i32_62, %arg15 = %false_63) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_59 : index
          %c0_184 = arith.constant 0 : index
          %c160_185 = arith.constant 160 : index
          %2 = arith.andi %true_48, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_186 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_186 : index
          %6 = arith.andi %true_48, %true_48 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_48, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_48, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_48, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_48, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_187 = arith.constant true
          %17 = arith.xori %5, %true_187 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_48, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_48, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_48, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_48, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_188 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_188 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_189 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_189 : index
          %c256_190 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_190 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_6[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_48, %44 : i1
          %c0_191 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_191 : index
          %47 = arith.cmpi slt, %43, %dim_50 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_192 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_192 : index
          %c256_193 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_193 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %91 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %56 = arith.andi %true_48, %42 : i1
          %c0_194 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_194 : index
          %58 = arith.cmpi slt, %41, %dim_52 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_195 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_195 : index
          %c256_196 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_196 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %91 = memref.load %arg3[%41, %39] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_48 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_197 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_197 : index
          %c512_198 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_198 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_199 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_199 : index
          %c256_200 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_200 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_6[%43, %39] : memref<512x256xi32>
          }
          %82 = arith.addi %arg9, %c1_55 : index
          %83 = arith.cmpi sge, %82, %c160_54 : index
          %true_201 = arith.constant true
          %84 = arith.xori %83, %true_201 : i1
          %85 = arith.andi %true_48, %84 : i1
          %86 = arith.andi %4, %85 : i1
          %87 = arith.select %86, %3, %arg14 : i32
          %88 = arith.ori %86, %arg15 : i1
          %89 = arith.select %69, %70, %arg12 : i32
          %90 = arith.ori %69, %arg13 : i1
          scf.yield %89, %90, %87, %88 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_1.replica.0", amoeba.tiling.output_region_lowers = [array<i64: 0, 0>], amoeba.tiling.output_region_uppers = [array<i64: 160, 256>]}
    %c256_64 = arith.constant 256 : index
    %c0_65 = arith.constant 0 : index
    %c1_66 = arith.constant 1 : index
    %c160_67 = arith.constant 160 : index
    %c320_68 = arith.constant 320 : index
    %true_69 = arith.constant true
    %c0_70 = arith.constant 0 : index
    %dim_71 = memref.dim %arg1, %c0_70 : memref<?x256xi32>
    %c0_72 = arith.constant 0 : index
    %dim_73 = memref.dim %arg3, %c0_72 : memref<?x256xi32>
    %c160_74 = arith.constant 160 : index
    %c320_75 = arith.constant 320 : index
    %c1_76 = arith.constant 1 : index
    %c0_77 = arith.constant 0 : index
    %c256_78 = arith.constant 256 : index
    %c1_79 = arith.constant 1 : index
    %c0_80 = arith.constant 0 : index
    %c256_81 = arith.constant 256 : index
    %c1_82 = arith.constant 1 : index
    %c0_i32_83 = arith.constant 0 : i32
    %false_84 = arith.constant false
    scf.for %arg9 = %c160_74 to %c320_75 step %c1_76 {
      scf.for %arg10 = %c0_77 to %c256_78 step %c1_79 {
        %0:4 = scf.for %arg11 = %c0_80 to %c256_81 step %c1_82 iter_args(%arg12 = %c0_i32, %arg13 = %true_69, %arg14 = %c0_i32_83, %arg15 = %false_84) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_80 : index
          %c160_184 = arith.constant 160 : index
          %c320_185 = arith.constant 320 : index
          %2 = arith.andi %true_69, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_186 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_186 : index
          %6 = arith.andi %true_69, %true_69 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_69, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_69, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_69, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_69, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_187 = arith.constant true
          %17 = arith.xori %5, %true_187 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_69, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_69, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_69, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_69, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_188 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_188 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_189 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_189 : index
          %c256_190 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_190 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_6[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_69, %44 : i1
          %c0_191 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_191 : index
          %47 = arith.cmpi slt, %43, %dim_71 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_192 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_192 : index
          %c256_193 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_193 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %91 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %56 = arith.andi %true_69, %42 : i1
          %c0_194 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_194 : index
          %58 = arith.cmpi slt, %41, %dim_73 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_195 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_195 : index
          %c256_196 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_196 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %91 = memref.load %arg3[%41, %39] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_69 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_197 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_197 : index
          %c512_198 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_198 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_199 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_199 : index
          %c256_200 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_200 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_6[%43, %39] : memref<512x256xi32>
          }
          %82 = arith.addi %arg9, %c1_76 : index
          %83 = arith.cmpi sge, %82, %c320_75 : index
          %true_201 = arith.constant true
          %84 = arith.xori %83, %true_201 : i1
          %85 = arith.andi %true_69, %84 : i1
          %86 = arith.andi %4, %85 : i1
          %87 = arith.select %86, %3, %arg14 : i32
          %88 = arith.ori %86, %arg15 : i1
          %89 = arith.select %69, %70, %arg12 : i32
          %90 = arith.ori %69, %arg13 : i1
          scf.yield %89, %90, %87, %88 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_1.replica.1", amoeba.tiling.output_region_lowers = [array<i64: 160, 0>], amoeba.tiling.output_region_uppers = [array<i64: 320, 256>]}
    %c256_85 = arith.constant 256 : index
    %c0_86 = arith.constant 0 : index
    %c1_87 = arith.constant 1 : index
    %true_88 = arith.constant true
    %c0_89 = arith.constant 0 : index
    %dim_90 = memref.dim %arg1, %c0_89 : memref<?x256xi32>
    %c0_91 = arith.constant 0 : index
    %dim_92 = memref.dim %arg4, %c0_91 : memref<?x256xi32>
    %c0_93 = arith.constant 0 : index
    %c1_94 = arith.constant 1 : index
    %c0_95 = arith.constant 0 : index
    %c256_96 = arith.constant 256 : index
    %c1_97 = arith.constant 1 : index
    %c0_98 = arith.constant 0 : index
    %c256_99 = arith.constant 256 : index
    %c1_100 = arith.constant 1 : index
    %c0_i32_101 = arith.constant 0 : i32
    %false_102 = arith.constant false
    scf.for %arg9 = %c0_93 to %c320 step %c1_94 {
      scf.for %arg10 = %c0_95 to %c256_96 step %c1_97 {
        %0:4 = scf.for %arg11 = %c0_98 to %c256_99 step %c1_100 iter_args(%arg12 = %c0_i32, %arg13 = %true_88, %arg14 = %c0_i32_101, %arg15 = %false_102) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_98 : index
          %2 = arith.andi %true_88, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_184 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_184 : index
          %6 = arith.andi %true_88, %true_88 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_88, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_88, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_88, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_88, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_185 = arith.constant true
          %17 = arith.xori %5, %true_185 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_88, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_88, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_88, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_88, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_186 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_186 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_187 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_187 : index
          %c256_188 = arith.constant 256 : index
          %34 = arith.cmpi slt, %arg10, %c256_188 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_5[%arg9, %arg10] : memref<512x256xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_88, %44 : i1
          %c0_189 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_189 : index
          %47 = arith.cmpi slt, %43, %dim_90 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_190 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_190 : index
          %c256_191 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_191 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %91 = memref.load %arg1[%43, %41] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_200 = arith.constant 0 : i32
            scf.yield %c0_i32_200 : i32
          }
          %56 = arith.andi %true_88, %42 : i1
          %c0_192 = arith.constant 0 : index
          %57 = arith.cmpi sge, %41, %c0_192 : index
          %58 = arith.cmpi slt, %41, %dim_92 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %40 : i1
          %c0_193 = arith.constant 0 : index
          %62 = arith.cmpi sge, %39, %c0_193 : index
          %c256_194 = arith.constant 256 : index
          %63 = arith.cmpi slt, %39, %c256_194 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %91 = memref.load %arg4[%41, %39] : memref<?x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_200 = arith.constant 0 : i32
            scf.yield %c0_i32_200 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_88 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_195 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_195 : index
          %c512_196 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_196 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_197 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_197 : index
          %c256_198 = arith.constant 256 : index
          %79 = arith.cmpi slt, %39, %c256_198 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_5[%43, %39] : memref<512x256xi32>
          }
          %82 = arith.addi %arg9, %c1_94 : index
          %83 = arith.cmpi sge, %82, %c320 : index
          %true_199 = arith.constant true
          %84 = arith.xori %83, %true_199 : i1
          %85 = arith.andi %true_88, %84 : i1
          %86 = arith.andi %4, %85 : i1
          %87 = arith.select %86, %3, %arg14 : i32
          %88 = arith.ori %86, %arg15 : i1
          %89 = arith.select %69, %70, %arg12 : i32
          %90 = arith.ori %69, %arg13 : i1
          scf.yield %89, %90, %87, %88 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_2"}
    %c256_103 = arith.constant 256 : index
    %c0_104 = arith.constant 0 : index
    %c1_105 = arith.constant 1 : index
    %true_106 = arith.constant true
    %c0_107 = arith.constant 0 : index
    %c1_108 = arith.constant 1 : index
    %c0_109 = arith.constant 0 : index
    %c1_110 = arith.constant 1 : index
    %c0_111 = arith.constant 0 : index
    %c256_112 = arith.constant 256 : index
    %c1_113 = arith.constant 1 : index
    %c0_i32_114 = arith.constant 0 : i32
    %false_115 = arith.constant false
    scf.for %arg9 = %c0_107 to %c320 step %c1_108 {
      scf.for %arg10 = %c0_109 to %c320 step %c1_110 {
        %0:4 = scf.for %arg11 = %c0_111 to %c256_112 step %c1_113 iter_args(%arg12 = %c0_i32, %arg13 = %true_106, %arg14 = %c0_i32_114, %arg15 = %false_115) -> (i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_111 : index
          %2 = arith.andi %true_106, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %c0_184 = arith.constant 0 : index
          %5 = arith.cmpi eq, %arg11, %c0_184 : index
          %6 = arith.andi %true_106, %true_106 : i1
          %7 = arith.andi %6, %5 : i1
          %8 = arith.andi %true_106, %7 : i1
          %9 = arith.andi %6, %5 : i1
          %10 = arith.andi %true_106, %9 : i1
          %11 = arith.andi %6, %5 : i1
          %12 = arith.andi %true_106, %11 : i1
          %13 = arith.andi %6, %5 : i1
          %14 = arith.andi %true_106, %13 : i1
          %15 = arith.andi %6, %5 : i1
          %16 = arith.andi %4, %15 : i1
          %true_185 = arith.constant true
          %17 = arith.xori %5, %true_185 : i1
          %18 = arith.andi %6, %17 : i1
          %19 = arith.andi %true_106, %18 : i1
          %20 = arith.andi %6, %17 : i1
          %21 = arith.andi %true_106, %20 : i1
          %22 = arith.andi %6, %17 : i1
          %23 = arith.andi %true_106, %22 : i1
          %24 = arith.andi %6, %17 : i1
          %25 = arith.andi %4, %24 : i1
          %26 = arith.andi %true_106, %8 : i1
          %27 = arith.andi %26, %10 : i1
          %c0_186 = arith.constant 0 : index
          %28 = arith.cmpi sge, %arg9, %c0_186 : index
          %c512 = arith.constant 512 : index
          %29 = arith.cmpi slt, %arg9, %c512 : index
          %30 = arith.andi %28, %29 : i1
          %31 = arith.andi %27, %30 : i1
          %32 = arith.andi %31, %12 : i1
          %c0_187 = arith.constant 0 : index
          %33 = arith.cmpi sge, %arg10, %c0_187 : index
          %c512_188 = arith.constant 512 : index
          %34 = arith.cmpi slt, %arg10, %c512_188 : index
          %35 = arith.andi %33, %34 : i1
          %36 = arith.andi %32, %35 : i1
          scf.if %36 {
            memref.store %c0_i32, %alloca_4[%arg9, %arg10] : memref<512x512xi32>
          }
          %37 = arith.select %25, %3, %3 : i32
          %38 = arith.ori %25, %16 : i1
          %39 = arith.select %23, %arg10, %arg10 : index
          %40 = arith.ori %23, %12 : i1
          %41 = arith.select %21, %arg11, %arg11 : index
          %42 = arith.ori %21, %14 : i1
          %43 = arith.select %19, %arg9, %arg9 : index
          %44 = arith.ori %19, %10 : i1
          %45 = arith.andi %true_106, %44 : i1
          %c0_189 = arith.constant 0 : index
          %46 = arith.cmpi sge, %43, %c0_189 : index
          %c512_190 = arith.constant 512 : index
          %47 = arith.cmpi slt, %43, %c512_190 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = arith.andi %49, %42 : i1
          %c0_191 = arith.constant 0 : index
          %51 = arith.cmpi sge, %41, %c0_191 : index
          %c256_192 = arith.constant 256 : index
          %52 = arith.cmpi slt, %41, %c256_192 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = scf.if %54 -> (i32) {
            %91 = memref.load %alloca_7[%43, %41] : memref<512x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %56 = arith.andi %true_106, %40 : i1
          %c0_193 = arith.constant 0 : index
          %57 = arith.cmpi sge, %39, %c0_193 : index
          %c512_194 = arith.constant 512 : index
          %58 = arith.cmpi slt, %39, %c512_194 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %42 : i1
          %c0_195 = arith.constant 0 : index
          %62 = arith.cmpi sge, %41, %c0_195 : index
          %c256_196 = arith.constant 256 : index
          %63 = arith.cmpi slt, %41, %c256_196 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          %66 = scf.if %65 -> (i32) {
            %91 = memref.load %alloca_6[%39, %41] : memref<512x256xi32>
            scf.yield %91 : i32
          } else {
            %c0_i32_202 = arith.constant 0 : i32
            scf.yield %c0_i32_202 : i32
          }
          %67 = arith.andi %54, %65 : i1
          %68 = arith.muli %55, %66 : i32
          %69 = arith.andi %38, %67 : i1
          %70 = arith.addi %37, %68 : i32
          %71 = arith.andi %69, %true_106 : i1
          %72 = arith.andi %71, %44 : i1
          %c0_197 = arith.constant 0 : index
          %73 = arith.cmpi sge, %43, %c0_197 : index
          %c512_198 = arith.constant 512 : index
          %74 = arith.cmpi slt, %43, %c512_198 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = arith.andi %76, %40 : i1
          %c0_199 = arith.constant 0 : index
          %78 = arith.cmpi sge, %39, %c0_199 : index
          %c512_200 = arith.constant 512 : index
          %79 = arith.cmpi slt, %39, %c512_200 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          scf.if %81 {
            memref.store %70, %alloca_4[%43, %39] : memref<512x512xi32>
          }
          %82 = arith.addi %arg9, %c1_108 : index
          %83 = arith.cmpi sge, %82, %c320 : index
          %true_201 = arith.constant true
          %84 = arith.xori %83, %true_201 : i1
          %85 = arith.andi %true_106, %84 : i1
          %86 = arith.andi %4, %85 : i1
          %87 = arith.select %86, %3, %arg14 : i32
          %88 = arith.ori %86, %arg15 : i1
          %89 = arith.select %69, %70, %arg12 : i32
          %90 = arith.ori %69, %arg13 : i1
          scf.yield %89, %90, %87, %88 : i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_3", amoeba.semantic.incoming_edges = ["Task_0.replica.0|producer_consumer|tensor_wide", "Task_0.replica.1|producer_consumer|tensor_wide", "Task_1.replica.0|producer_consumer|tensor_wide", "Task_1.replica.1|producer_consumer|tensor_wide"]}
    %c0_116 = arith.constant 0 : index
    %c1_117 = arith.constant 1 : index
    %true_118 = arith.constant true
    %c0_119 = arith.constant 0 : index
    %c1_120 = arith.constant 1 : index
    %c0_121 = arith.constant 0 : index
    %c1_122 = arith.constant 1 : index
    %c0_i32_123 = arith.constant 0 : i32
    %false_124 = arith.constant false
    scf.for %arg9 = %c0_119 to %c320 step %c1_120 {
      %0:4 = scf.for %arg10 = %c0_121 to %c320 step %c1_122 iter_args(%arg11 = %c0_i32, %arg12 = %true_118, %arg13 = %c0_i32_123, %arg14 = %false_124) -> (i32, i1, i32, i1) {
        %1 = arith.cmpi eq, %arg10, %c0_121 : index
        %2 = arith.andi %true_118, %1 : i1
        %3 = arith.select %2, %c0_i32, %arg11 : i32
        %4 = arith.ori %2, %arg12 : i1
        %c0_184 = arith.constant 0 : index
        %5 = arith.cmpi eq, %arg10, %c0_184 : index
        %6 = arith.andi %true_118, %true_118 : i1
        %7 = arith.andi %6, %5 : i1
        %8 = arith.andi %true_118, %7 : i1
        %9 = arith.andi %6, %5 : i1
        %10 = arith.andi %true_118, %9 : i1
        %11 = arith.andi %6, %5 : i1
        %12 = arith.andi %true_118, %11 : i1
        %13 = arith.andi %6, %5 : i1
        %14 = arith.andi %4, %13 : i1
        %true_185 = arith.constant true
        %15 = arith.xori %5, %true_185 : i1
        %16 = arith.andi %6, %15 : i1
        %17 = arith.andi %true_118, %16 : i1
        %18 = arith.andi %6, %15 : i1
        %19 = arith.andi %true_118, %18 : i1
        %20 = arith.andi %6, %15 : i1
        %21 = arith.andi %4, %20 : i1
        %22 = arith.andi %true_118, %8 : i1
        %23 = arith.andi %22, %10 : i1
        %c0_186 = arith.constant 0 : index
        %24 = arith.cmpi sge, %arg9, %c0_186 : index
        %c512 = arith.constant 512 : index
        %25 = arith.cmpi slt, %arg9, %c512 : index
        %26 = arith.andi %24, %25 : i1
        %27 = arith.andi %23, %26 : i1
        scf.if %27 {
          memref.store %c0_i32, %alloca_2[%arg9] : memref<512xi32>
        }
        %28 = arith.select %21, %3, %3 : i32
        %29 = arith.ori %21, %14 : i1
        %30 = arith.select %19, %arg10, %arg10 : index
        %31 = arith.ori %19, %12 : i1
        %32 = arith.select %17, %arg9, %arg9 : index
        %33 = arith.ori %17, %10 : i1
        %34 = arith.andi %true_118, %33 : i1
        %c0_187 = arith.constant 0 : index
        %35 = arith.cmpi sge, %32, %c0_187 : index
        %c512_188 = arith.constant 512 : index
        %36 = arith.cmpi slt, %32, %c512_188 : index
        %37 = arith.andi %35, %36 : i1
        %38 = arith.andi %34, %37 : i1
        %39 = arith.andi %38, %31 : i1
        %c0_189 = arith.constant 0 : index
        %40 = arith.cmpi sge, %30, %c0_189 : index
        %c512_190 = arith.constant 512 : index
        %41 = arith.cmpi slt, %30, %c512_190 : index
        %42 = arith.andi %40, %41 : i1
        %43 = arith.andi %39, %42 : i1
        %44 = scf.if %43 -> (i32) {
          %77 = memref.load %alloca_4[%32, %30] : memref<512x512xi32>
          scf.yield %77 : i32
        } else {
          %c0_i32_198 = arith.constant 0 : i32
          scf.yield %c0_i32_198 : i32
        }
        %45 = arith.andi %43, %43 : i1
        %46 = arith.muli %44, %44 : i32
        %47 = arith.andi %45, %true_118 : i1
        %48 = arith.addi %46, %c1_i32 : i32
        %49 = arith.andi %47, %true_118 : i1
        %50 = arith.andi %49, %33 : i1
        %c0_191 = arith.constant 0 : index
        %51 = arith.cmpi sge, %32, %c0_191 : index
        %c512_192 = arith.constant 512 : index
        %52 = arith.cmpi slt, %32, %c512_192 : index
        %53 = arith.andi %51, %52 : i1
        %54 = arith.andi %50, %53 : i1
        %55 = arith.andi %54, %31 : i1
        %c0_193 = arith.constant 0 : index
        %56 = arith.cmpi sge, %30, %c0_193 : index
        %c512_194 = arith.constant 512 : index
        %57 = arith.cmpi slt, %30, %c512_194 : index
        %58 = arith.andi %56, %57 : i1
        %59 = arith.andi %55, %58 : i1
        scf.if %59 {
          memref.store %48, %alloca_3[%32, %30] : memref<512x512xi32>
        }
        %60 = arith.andi %29, %47 : i1
        %61 = arith.addi %28, %48 : i32
        %62 = arith.andi %60, %true_118 : i1
        %63 = arith.andi %62, %33 : i1
        %c0_195 = arith.constant 0 : index
        %64 = arith.cmpi sge, %32, %c0_195 : index
        %c512_196 = arith.constant 512 : index
        %65 = arith.cmpi slt, %32, %c512_196 : index
        %66 = arith.andi %64, %65 : i1
        %67 = arith.andi %63, %66 : i1
        scf.if %67 {
          memref.store %61, %alloca_2[%32] : memref<512xi32>
        }
        %68 = arith.addi %arg9, %c1_120 : index
        %69 = arith.cmpi sge, %68, %c320 : index
        %true_197 = arith.constant true
        %70 = arith.xori %69, %true_197 : i1
        %71 = arith.andi %true_118, %70 : i1
        %72 = arith.andi %4, %71 : i1
        %73 = arith.select %72, %3, %arg13 : i32
        %74 = arith.ori %72, %arg14 : i1
        %75 = arith.select %60, %61, %arg11 : i32
        %76 = arith.ori %60, %arg12 : i1
        scf.yield %75, %76, %73, %74 : i32, i1, i32, i1
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_4"}
    %c0_125 = arith.constant 0 : index
    %c1_126 = arith.constant 1 : index
    %true_127 = arith.constant true
    %c0_128 = arith.constant 0 : index
    %c1_129 = arith.constant 1 : index
    %c0_130 = arith.constant 0 : index
    %c1_131 = arith.constant 1 : index
    scf.for %arg9 = %c0_128 to %c320 step %c1_129 {
      scf.for %arg10 = %c0_130 to %c320 step %c1_131 {
        %0 = arith.cmpi eq, %arg10, %c0_130 : index
        %1 = arith.andi %true_127, %true_127 : i1
        %c0_184 = arith.constant 0 : index
        %2 = arith.cmpi sge, %arg9, %c0_184 : index
        %c512 = arith.constant 512 : index
        %3 = arith.cmpi slt, %arg9, %c512 : index
        %4 = arith.andi %2, %3 : i1
        %5 = arith.andi %1, %4 : i1
        %6 = scf.if %5 -> (i32) {
          %37 = memref.load %alloca_2[%arg9] : memref<512xi32>
          scf.yield %37 : i32
        } else {
          %c0_i32_194 = arith.constant 0 : i32
          scf.yield %c0_i32_194 : i32
        }
        %7 = arith.andi %5, %true_127 : i1
        %8 = arith.addi %6, %c1_i32 : i32
        %9 = arith.andi %true_127, %true_127 : i1
        %c0_185 = arith.constant 0 : index
        %10 = arith.cmpi sge, %arg9, %c0_185 : index
        %c512_186 = arith.constant 512 : index
        %11 = arith.cmpi slt, %arg9, %c512_186 : index
        %12 = arith.andi %10, %11 : i1
        %13 = arith.andi %9, %12 : i1
        %14 = arith.andi %13, %true_127 : i1
        %c0_187 = arith.constant 0 : index
        %15 = arith.cmpi sge, %arg10, %c0_187 : index
        %c512_188 = arith.constant 512 : index
        %16 = arith.cmpi slt, %arg10, %c512_188 : index
        %17 = arith.andi %15, %16 : i1
        %18 = arith.andi %14, %17 : i1
        %19 = scf.if %18 -> (i32) {
          %37 = memref.load %alloca_3[%arg9, %arg10] : memref<512x512xi32>
          scf.yield %37 : i32
        } else {
          %c0_i32_194 = arith.constant 0 : i32
          scf.yield %c0_i32_194 : i32
        }
        %20 = arith.andi %18, %true_127 : i1
        %21 = arith.muli %19, %c1024_i32 : i32
        %22 = arith.andi %20, %7 : i1
        %c0_i32_189 = arith.constant 0 : i32
        %23 = arith.cmpi ne, %8, %c0_i32_189 : i32
        %24 = arith.andi %22, %23 : i1
        %25 = scf.if %24 -> (i32) {
          %37 = arith.divsi %21, %8 : i32
          scf.yield %37 : i32
        } else {
          %c0_i32_194 = arith.constant 0 : i32
          scf.yield %c0_i32_194 : i32
        }
        %26 = arith.andi %24, %true_127 : i1
        %27 = arith.andi %26, %true_127 : i1
        %c0_190 = arith.constant 0 : index
        %28 = arith.cmpi sge, %arg9, %c0_190 : index
        %c512_191 = arith.constant 512 : index
        %29 = arith.cmpi slt, %arg9, %c512_191 : index
        %30 = arith.andi %28, %29 : i1
        %31 = arith.andi %27, %30 : i1
        %32 = arith.andi %31, %true_127 : i1
        %c0_192 = arith.constant 0 : index
        %33 = arith.cmpi sge, %arg10, %c0_192 : index
        %c512_193 = arith.constant 512 : index
        %34 = arith.cmpi slt, %arg10, %c512_193 : index
        %35 = arith.andi %33, %34 : i1
        %36 = arith.andi %32, %35 : i1
        scf.if %36 {
          memref.store %25, %alloca_3[%arg9, %arg10] : memref<512x512xi32>
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_5"}
    %c256_132 = arith.constant 256 : index
    %c0_133 = arith.constant 0 : index
    %c1_134 = arith.constant 1 : index
    %true_135 = arith.constant true
    %c0_136 = arith.constant 0 : index
    %c1_137 = arith.constant 1 : index
    %c0_138 = arith.constant 0 : index
    %c256_139 = arith.constant 256 : index
    %c1_140 = arith.constant 1 : index
    %c0_141 = arith.constant 0 : index
    %false_142 = arith.constant false
    %c0_143 = arith.constant 0 : index
    %false_144 = arith.constant false
    %c0_i32_145 = arith.constant 0 : i32
    %false_146 = arith.constant false
    %c0_i64 = arith.constant 0 : i64
    %false_147 = arith.constant false
    scf.for %arg9 = %c0_136 to %c320 step %c1_137 {
      scf.for %arg10 = %c0_138 to %c256_139 step %c1_140 {
        %c1_184 = arith.constant 1 : index
        %0 = arith.addi %c320, %c1_184 : index
        %c0_185 = arith.constant 0 : index
        %1:8 = scf.for %arg11 = %c0_185 to %0 step %c1_184 iter_args(%arg12 = %c0_141, %arg13 = %false_142, %arg14 = %c0_143, %arg15 = %false_144, %arg16 = %c0_i32_145, %arg17 = %false_146, %arg18 = %c0_i64, %arg19 = %false_147) -> (index, i1, index, i1, i32, i1, i64, i1) {
          %2 = arith.cmpi eq, %arg11, %c0_185 : index
          %c0_186 = arith.constant 0 : index
          %3 = arith.index_cast %c0_186 : index to i64
          %4 = arith.andi %true_135, %true_135 : i1
          %5 = arith.andi %4, %true_135 : i1
          %c0_187 = arith.constant 0 : index
          %6 = arith.cmpi sge, %arg9, %c0_187 : index
          %c512 = arith.constant 512 : index
          %7 = arith.cmpi slt, %arg9, %c512 : index
          %8 = arith.andi %6, %7 : i1
          %9 = arith.andi %5, %8 : i1
          %10 = arith.andi %9, %true_135 : i1
          %c0_188 = arith.constant 0 : index
          %11 = arith.cmpi sge, %arg10, %c0_188 : index
          %c256_189 = arith.constant 256 : index
          %12 = arith.cmpi slt, %arg10, %c256_189 : index
          %13 = arith.andi %11, %12 : i1
          %14 = arith.andi %10, %13 : i1
          %15 = arith.andi %14, %2 : i1
          scf.if %15 {
            memref.store %c0_i32, %alloca_1[%arg9, %arg10] : memref<512x256xi32>
          }
          %16 = arith.select %arg13, %arg12, %arg10 : index
          %17 = arith.ori %arg13, %true_135 : i1
          %18 = arith.select %arg15, %arg14, %arg9 : index
          %19 = arith.ori %arg15, %true_135 : i1
          %20 = arith.select %arg17, %arg16, %c0_i32 : i32
          %21 = arith.ori %arg17, %true_135 : i1
          %22 = arith.select %arg19, %arg18, %3 : i64
          %23 = arith.ori %arg19, %true_135 : i1
          %24 = arith.index_cast %22 : i64 to index
          %25 = arith.cmpi slt, %24, %c320 : index
          %26 = arith.andi %23, %true_135 : i1
          %27 = arith.andi %26, %25 : i1
          %28 = arith.andi %19, %27 : i1
          %29 = arith.andi %26, %25 : i1
          %30 = arith.andi %23, %29 : i1
          %31 = arith.andi %26, %25 : i1
          %32 = arith.andi %17, %31 : i1
          %33 = arith.andi %26, %25 : i1
          %34 = arith.andi %21, %33 : i1
          %true_190 = arith.constant true
          %35 = arith.xori %25, %true_190 : i1
          %36 = arith.andi %26, %35 : i1
          %37 = arith.andi %19, %36 : i1
          %38 = arith.andi %26, %35 : i1
          %39 = arith.andi %17, %38 : i1
          %40 = arith.andi %true_135, %37 : i1
          %c0_191 = arith.constant 0 : index
          %41 = arith.cmpi sge, %18, %c0_191 : index
          %c512_192 = arith.constant 512 : index
          %42 = arith.cmpi slt, %18, %c512_192 : index
          %43 = arith.andi %41, %42 : i1
          %44 = arith.andi %40, %43 : i1
          %45 = arith.andi %44, %39 : i1
          %c0_193 = arith.constant 0 : index
          %46 = arith.cmpi sge, %16, %c0_193 : index
          %c256_194 = arith.constant 256 : index
          %47 = arith.cmpi slt, %16, %c256_194 : index
          %48 = arith.andi %46, %47 : i1
          %49 = arith.andi %45, %48 : i1
          %50 = scf.if %49 -> (i32) {
            %114 = memref.load %alloca_1[%18, %16] : memref<512x256xi32>
            scf.yield %114 : i32
          } else {
            %c0_i32_213 = arith.constant 0 : i32
            scf.yield %c0_i32_213 : i32
          }
          %51 = arith.andi %49, %true_135 : i1
          %c0_i32_195 = arith.constant 0 : i32
          %52 = arith.cmpi ne, %c1024_i32, %c0_i32_195 : i32
          %53 = arith.andi %51, %52 : i1
          %54 = scf.if %53 -> (i32) {
            %114 = arith.divsi %50, %c1024_i32 : i32
            scf.yield %114 : i32
          } else {
            %c0_i32_213 = arith.constant 0 : i32
            scf.yield %c0_i32_213 : i32
          }
          %55 = arith.andi %53, %true_135 : i1
          %56 = arith.andi %55, %37 : i1
          %c0_196 = arith.constant 0 : index
          %57 = arith.cmpi sge, %18, %c0_196 : index
          %c512_197 = arith.constant 512 : index
          %58 = arith.cmpi slt, %18, %c512_197 : index
          %59 = arith.andi %57, %58 : i1
          %60 = arith.andi %56, %59 : i1
          %61 = arith.andi %60, %39 : i1
          %c0_198 = arith.constant 0 : index
          %62 = arith.cmpi sge, %16, %c0_198 : index
          %c256_199 = arith.constant 256 : index
          %63 = arith.cmpi slt, %16, %c256_199 : index
          %64 = arith.andi %62, %63 : i1
          %65 = arith.andi %61, %64 : i1
          scf.if %65 {
            memref.store %54, %alloca_1[%18, %16] : memref<512x256xi32>
          }
          %66 = arith.andi %true_135, %28 : i1
          %c0_200 = arith.constant 0 : index
          %67 = arith.cmpi sge, %18, %c0_200 : index
          %c512_201 = arith.constant 512 : index
          %68 = arith.cmpi slt, %18, %c512_201 : index
          %69 = arith.andi %67, %68 : i1
          %70 = arith.andi %66, %69 : i1
          %71 = arith.andi %70, %30 : i1
          %c0_202 = arith.constant 0 : index
          %72 = arith.cmpi sge, %24, %c0_202 : index
          %c512_203 = arith.constant 512 : index
          %73 = arith.cmpi slt, %24, %c512_203 : index
          %74 = arith.andi %72, %73 : i1
          %75 = arith.andi %71, %74 : i1
          %76 = scf.if %75 -> (i32) {
            %114 = memref.load %alloca_3[%18, %24] : memref<512x512xi32>
            scf.yield %114 : i32
          } else {
            %c0_i32_213 = arith.constant 0 : i32
            scf.yield %c0_i32_213 : i32
          }
          %77 = arith.andi %true_135, %30 : i1
          %c0_204 = arith.constant 0 : index
          %78 = arith.cmpi sge, %24, %c0_204 : index
          %c512_205 = arith.constant 512 : index
          %79 = arith.cmpi slt, %24, %c512_205 : index
          %80 = arith.andi %78, %79 : i1
          %81 = arith.andi %77, %80 : i1
          %82 = arith.andi %81, %32 : i1
          %c0_206 = arith.constant 0 : index
          %83 = arith.cmpi sge, %16, %c0_206 : index
          %c256_207 = arith.constant 256 : index
          %84 = arith.cmpi slt, %16, %c256_207 : index
          %85 = arith.andi %83, %84 : i1
          %86 = arith.andi %82, %85 : i1
          %87 = scf.if %86 -> (i32) {
            %114 = memref.load %alloca_5[%24, %16] : memref<512x256xi32>
            scf.yield %114 : i32
          } else {
            %c0_i32_213 = arith.constant 0 : i32
            scf.yield %c0_i32_213 : i32
          }
          %88 = arith.andi %75, %86 : i1
          %89 = arith.muli %76, %87 : i32
          %90 = arith.andi %34, %88 : i1
          %91 = arith.addi %20, %89 : i32
          %92 = arith.andi %90, %true_135 : i1
          %93 = arith.andi %92, %28 : i1
          %c0_208 = arith.constant 0 : index
          %94 = arith.cmpi sge, %18, %c0_208 : index
          %c512_209 = arith.constant 512 : index
          %95 = arith.cmpi slt, %18, %c512_209 : index
          %96 = arith.andi %94, %95 : i1
          %97 = arith.andi %93, %96 : i1
          %98 = arith.andi %97, %32 : i1
          %c0_210 = arith.constant 0 : index
          %99 = arith.cmpi sge, %16, %c0_210 : index
          %c256_211 = arith.constant 256 : index
          %100 = arith.cmpi slt, %16, %c256_211 : index
          %101 = arith.andi %99, %100 : i1
          %102 = arith.andi %98, %101 : i1
          scf.if %102 {
            memref.store %91, %alloca_1[%18, %16] : memref<512x256xi32>
          }
          %c1_212 = arith.constant 1 : index
          %103 = arith.andi %30, %true_135 : i1
          %104 = arith.addi %24, %c1_212 : index
          %105 = arith.index_cast %104 : index to i64
          %106 = arith.select %32, %16, %arg12 : index
          %107 = arith.ori %32, %arg13 : i1
          %108 = arith.select %28, %18, %arg14 : index
          %109 = arith.ori %28, %arg15 : i1
          %110 = arith.select %90, %91, %arg16 : i32
          %111 = arith.ori %90, %arg17 : i1
          %112 = arith.select %103, %105, %arg18 : i64
          %113 = arith.ori %103, %arg19 : i1
          scf.yield %106, %107, %108, %109, %110, %111, %112, %113 : index, i1, index, i1, i32, i1, i64, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_6"}
    %c256_148 = arith.constant 256 : index
    %c0_149 = arith.constant 0 : index
    %c1_150 = arith.constant 1 : index
    %true_151 = arith.constant true
    %c0_152 = arith.constant 0 : index
    %dim_153 = memref.dim %arg5, %c0_152 : memref<?x256xi32>
    %c0_154 = arith.constant 0 : index
    %dim_155 = memref.dim %arg6, %c0_154 : memref<?x256xi32>
    %c0_156 = arith.constant 0 : index
    %c1_157 = arith.constant 1 : index
    %c0_158 = arith.constant 0 : index
    %c256_159 = arith.constant 256 : index
    %c1_160 = arith.constant 1 : index
    %c0_161 = arith.constant 0 : index
    %c256_162 = arith.constant 256 : index
    %c1_163 = arith.constant 1 : index
    %c0_i32_164 = arith.constant 0 : i32
    %false_165 = arith.constant false
    %c0_i32_166 = arith.constant 0 : i32
    %false_167 = arith.constant false
    scf.for %arg9 = %c0_156 to %c320 step %c1_157 {
      scf.for %arg10 = %c0_158 to %c256_159 step %c1_160 {
        %0:8 = scf.for %arg11 = %c0_161 to %c256_162 step %c1_163 iter_args(%arg12 = %c0_i32, %arg13 = %true_151, %arg14 = %c0_i32, %arg15 = %true_151, %arg16 = %c0_i32_164, %arg17 = %false_165, %arg18 = %c0_i32_166, %arg19 = %false_167) -> (i32, i1, i32, i1, i32, i1, i32, i1) {
          %1 = arith.cmpi eq, %arg11, %c0_161 : index
          %2 = arith.andi %true_151, %1 : i1
          %3 = arith.select %2, %c0_i32, %arg12 : i32
          %4 = arith.ori %2, %arg13 : i1
          %5 = arith.andi %true_151, %1 : i1
          %6 = arith.select %5, %c0_i32, %arg14 : i32
          %7 = arith.ori %5, %arg15 : i1
          %c0_184 = arith.constant 0 : index
          %8 = arith.cmpi eq, %arg11, %c0_184 : index
          %9 = arith.andi %true_151, %true_151 : i1
          %10 = arith.andi %9, %8 : i1
          %11 = arith.andi %true_151, %10 : i1
          %12 = arith.andi %9, %8 : i1
          %13 = arith.andi %true_151, %12 : i1
          %14 = arith.andi %9, %8 : i1
          %15 = arith.andi %true_151, %14 : i1
          %16 = arith.andi %9, %8 : i1
          %17 = arith.andi %true_151, %16 : i1
          %18 = arith.andi %9, %8 : i1
          %19 = arith.andi %true_151, %18 : i1
          %20 = arith.andi %9, %8 : i1
          %21 = arith.andi %7, %20 : i1
          %22 = arith.andi %9, %8 : i1
          %23 = arith.andi %4, %22 : i1
          %true_185 = arith.constant true
          %24 = arith.xori %8, %true_185 : i1
          %25 = arith.andi %9, %24 : i1
          %26 = arith.andi %true_151, %25 : i1
          %27 = arith.andi %9, %24 : i1
          %28 = arith.andi %true_151, %27 : i1
          %29 = arith.andi %9, %24 : i1
          %30 = arith.andi %true_151, %29 : i1
          %31 = arith.andi %9, %24 : i1
          %32 = arith.andi %7, %31 : i1
          %33 = arith.andi %9, %24 : i1
          %34 = arith.andi %4, %33 : i1
          %35 = arith.andi %true_151, %11 : i1
          %36 = arith.andi %35, %13 : i1
          %c0_186 = arith.constant 0 : index
          %37 = arith.cmpi sge, %arg9, %c0_186 : index
          %c512 = arith.constant 512 : index
          %38 = arith.cmpi slt, %arg9, %c512 : index
          %39 = arith.andi %37, %38 : i1
          %40 = arith.andi %36, %39 : i1
          %41 = arith.andi %40, %15 : i1
          %c0_187 = arith.constant 0 : index
          %42 = arith.cmpi sge, %arg10, %c0_187 : index
          %c256_188 = arith.constant 256 : index
          %43 = arith.cmpi slt, %arg10, %c256_188 : index
          %44 = arith.andi %42, %43 : i1
          %45 = arith.andi %41, %44 : i1
          scf.if %45 {
            memref.store %c0_i32, %alloca_0[%arg9, %arg10] : memref<512x256xi32>
          }
          %46 = arith.andi %true_151, %17 : i1
          %47 = arith.andi %46, %13 : i1
          %c0_189 = arith.constant 0 : index
          %48 = arith.cmpi sge, %arg9, %c0_189 : index
          %c512_190 = arith.constant 512 : index
          %49 = arith.cmpi slt, %arg9, %c512_190 : index
          %50 = arith.andi %48, %49 : i1
          %51 = arith.andi %47, %50 : i1
          %52 = arith.andi %51, %15 : i1
          %c0_191 = arith.constant 0 : index
          %53 = arith.cmpi sge, %arg10, %c0_191 : index
          %c256_192 = arith.constant 256 : index
          %54 = arith.cmpi slt, %arg10, %c256_192 : index
          %55 = arith.andi %53, %54 : i1
          %56 = arith.andi %52, %55 : i1
          scf.if %56 {
            memref.store %c0_i32, %alloca[%arg9, %arg10] : memref<512x256xi32>
          }
          %57 = arith.select %34, %3, %3 : i32
          %58 = arith.ori %34, %23 : i1
          %59 = arith.select %32, %6, %6 : i32
          %60 = arith.ori %32, %21 : i1
          %61 = arith.select %30, %arg10, %arg10 : index
          %62 = arith.ori %30, %15 : i1
          %63 = arith.select %28, %arg11, %arg11 : index
          %64 = arith.ori %28, %19 : i1
          %65 = arith.select %26, %arg9, %arg9 : index
          %66 = arith.ori %26, %13 : i1
          %67 = arith.andi %true_151, %66 : i1
          %c0_193 = arith.constant 0 : index
          %68 = arith.cmpi sge, %65, %c0_193 : index
          %c512_194 = arith.constant 512 : index
          %69 = arith.cmpi slt, %65, %c512_194 : index
          %70 = arith.andi %68, %69 : i1
          %71 = arith.andi %67, %70 : i1
          %72 = arith.andi %71, %64 : i1
          %c0_195 = arith.constant 0 : index
          %73 = arith.cmpi sge, %63, %c0_195 : index
          %c256_196 = arith.constant 256 : index
          %74 = arith.cmpi slt, %63, %c256_196 : index
          %75 = arith.andi %73, %74 : i1
          %76 = arith.andi %72, %75 : i1
          %77 = scf.if %76 -> (i32) {
            %145 = memref.load %alloca_1[%65, %63] : memref<512x256xi32>
            scf.yield %145 : i32
          } else {
            %c0_i32_212 = arith.constant 0 : i32
            scf.yield %c0_i32_212 : i32
          }
          %78 = arith.andi %true_151, %64 : i1
          %c0_197 = arith.constant 0 : index
          %79 = arith.cmpi sge, %63, %c0_197 : index
          %80 = arith.cmpi slt, %63, %dim_153 : index
          %81 = arith.andi %79, %80 : i1
          %82 = arith.andi %78, %81 : i1
          %83 = arith.andi %82, %62 : i1
          %c0_198 = arith.constant 0 : index
          %84 = arith.cmpi sge, %61, %c0_198 : index
          %c256_199 = arith.constant 256 : index
          %85 = arith.cmpi slt, %61, %c256_199 : index
          %86 = arith.andi %84, %85 : i1
          %87 = arith.andi %83, %86 : i1
          %88 = scf.if %87 -> (i32) {
            %145 = memref.load %arg5[%63, %61] : memref<?x256xi32>
            scf.yield %145 : i32
          } else {
            %c0_i32_212 = arith.constant 0 : i32
            scf.yield %c0_i32_212 : i32
          }
          %89 = arith.andi %76, %87 : i1
          %90 = arith.muli %77, %88 : i32
          %91 = arith.andi %60, %89 : i1
          %92 = arith.addi %59, %90 : i32
          %93 = arith.andi %91, %true_151 : i1
          %94 = arith.andi %93, %66 : i1
          %c0_200 = arith.constant 0 : index
          %95 = arith.cmpi sge, %65, %c0_200 : index
          %c512_201 = arith.constant 512 : index
          %96 = arith.cmpi slt, %65, %c512_201 : index
          %97 = arith.andi %95, %96 : i1
          %98 = arith.andi %94, %97 : i1
          %99 = arith.andi %98, %62 : i1
          %c0_202 = arith.constant 0 : index
          %100 = arith.cmpi sge, %61, %c0_202 : index
          %c256_203 = arith.constant 256 : index
          %101 = arith.cmpi slt, %61, %c256_203 : index
          %102 = arith.andi %100, %101 : i1
          %103 = arith.andi %99, %102 : i1
          scf.if %103 {
            memref.store %92, %alloca_0[%65, %61] : memref<512x256xi32>
          }
          %104 = arith.andi %true_151, %64 : i1
          %c0_204 = arith.constant 0 : index
          %105 = arith.cmpi sge, %63, %c0_204 : index
          %106 = arith.cmpi slt, %63, %dim_155 : index
          %107 = arith.andi %105, %106 : i1
          %108 = arith.andi %104, %107 : i1
          %109 = arith.andi %108, %62 : i1
          %c0_205 = arith.constant 0 : index
          %110 = arith.cmpi sge, %61, %c0_205 : index
          %c256_206 = arith.constant 256 : index
          %111 = arith.cmpi slt, %61, %c256_206 : index
          %112 = arith.andi %110, %111 : i1
          %113 = arith.andi %109, %112 : i1
          %114 = scf.if %113 -> (i32) {
            %145 = memref.load %arg6[%63, %61] : memref<?x256xi32>
            scf.yield %145 : i32
          } else {
            %c0_i32_212 = arith.constant 0 : i32
            scf.yield %c0_i32_212 : i32
          }
          %115 = arith.andi %76, %113 : i1
          %116 = arith.muli %77, %114 : i32
          %117 = arith.andi %58, %115 : i1
          %118 = arith.addi %57, %116 : i32
          %119 = arith.andi %117, %true_151 : i1
          %120 = arith.andi %119, %66 : i1
          %c0_207 = arith.constant 0 : index
          %121 = arith.cmpi sge, %65, %c0_207 : index
          %c512_208 = arith.constant 512 : index
          %122 = arith.cmpi slt, %65, %c512_208 : index
          %123 = arith.andi %121, %122 : i1
          %124 = arith.andi %120, %123 : i1
          %125 = arith.andi %124, %62 : i1
          %c0_209 = arith.constant 0 : index
          %126 = arith.cmpi sge, %61, %c0_209 : index
          %c256_210 = arith.constant 256 : index
          %127 = arith.cmpi slt, %61, %c256_210 : index
          %128 = arith.andi %126, %127 : i1
          %129 = arith.andi %125, %128 : i1
          scf.if %129 {
            memref.store %118, %alloca[%65, %61] : memref<512x256xi32>
          }
          %130 = arith.addi %arg9, %c1_157 : index
          %131 = arith.cmpi sge, %130, %c320 : index
          %true_211 = arith.constant true
          %132 = arith.xori %131, %true_211 : i1
          %133 = arith.andi %true_151, %132 : i1
          %134 = arith.andi %4, %133 : i1
          %135 = arith.andi %true_151, %132 : i1
          %136 = arith.andi %7, %135 : i1
          %137 = arith.select %134, %3, %arg16 : i32
          %138 = arith.ori %134, %arg17 : i1
          %139 = arith.select %136, %6, %arg18 : i32
          %140 = arith.ori %136, %arg19 : i1
          %141 = arith.select %117, %118, %arg12 : i32
          %142 = arith.ori %117, %arg13 : i1
          %143 = arith.select %91, %92, %arg14 : i32
          %144 = arith.ori %91, %arg15 : i1
          scf.yield %141, %142, %143, %144, %137, %138, %139, %140 : i32, i1, i32, i1, i32, i1, i32, i1
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_7"}
    %c256_168 = arith.constant 256 : index
    %c0_169 = arith.constant 0 : index
    %c1_170 = arith.constant 1 : index
    %true_171 = arith.constant true
    %c0_172 = arith.constant 0 : index
    %dim_173 = memref.dim %arg8, %c0_172 : memref<?x256xi32>
    %c0_174 = arith.constant 0 : index
    %dim_175 = memref.dim %arg7, %c0_174 : memref<?x256xi32>
    %c0_176 = arith.constant 0 : index
    %c1_177 = arith.constant 1 : index
    %c0_178 = arith.constant 0 : index
    %c256_179 = arith.constant 256 : index
    %c1_180 = arith.constant 1 : index
    %c0_181 = arith.constant 0 : index
    %c256_182 = arith.constant 256 : index
    %c1_183 = arith.constant 1 : index
    scf.for %arg9 = %c0_176 to %c320 step %c1_177 {
      scf.for %arg10 = %c0_178 to %c256_179 step %c1_180 {
        scf.for %arg11 = %c0_181 to %c256_182 step %c1_183 {
          %0 = arith.cmpi eq, %arg11, %c0_181 : index
          %c0_184 = arith.constant 0 : index
          %1 = arith.cmpi eq, %arg11, %c0_184 : index
          %2 = arith.andi %true_171, %true_171 : i1
          %3 = arith.andi %2, %1 : i1
          %4 = arith.andi %true_171, %3 : i1
          %5 = arith.andi %2, %1 : i1
          %6 = arith.andi %true_171, %5 : i1
          %7 = arith.andi %2, %1 : i1
          %8 = arith.andi %true_171, %7 : i1
          %9 = arith.andi %2, %1 : i1
          %10 = arith.andi %true_171, %9 : i1
          %true_185 = arith.constant true
          %11 = arith.xori %1, %true_185 : i1
          %12 = arith.andi %2, %11 : i1
          %13 = arith.andi %true_171, %12 : i1
          %14 = arith.andi %2, %11 : i1
          %15 = arith.andi %true_171, %14 : i1
          %16 = arith.andi %2, %11 : i1
          %17 = arith.andi %true_171, %16 : i1
          %18 = arith.andi %true_171, %4 : i1
          %19 = arith.andi %18, %6 : i1
          %c0_186 = arith.constant 0 : index
          %20 = arith.cmpi sge, %arg9, %c0_186 : index
          %21 = arith.cmpi slt, %arg9, %dim_173 : index
          %22 = arith.andi %20, %21 : i1
          %23 = arith.andi %19, %22 : i1
          %24 = arith.andi %23, %8 : i1
          %c0_187 = arith.constant 0 : index
          %25 = arith.cmpi sge, %arg10, %c0_187 : index
          %c256_188 = arith.constant 256 : index
          %26 = arith.cmpi slt, %arg10, %c256_188 : index
          %27 = arith.andi %25, %26 : i1
          %28 = arith.andi %24, %27 : i1
          scf.if %28 {
            memref.store %c0_i32, %arg8[%arg9, %arg10] : memref<?x256xi32>
          }
          %29 = arith.select %17, %arg10, %arg10 : index
          %30 = arith.ori %17, %8 : i1
          %31 = arith.select %15, %arg11, %arg11 : index
          %32 = arith.ori %15, %10 : i1
          %33 = arith.select %13, %arg9, %arg9 : index
          %34 = arith.ori %13, %6 : i1
          %35 = arith.andi %true_171, %34 : i1
          %c0_189 = arith.constant 0 : index
          %36 = arith.cmpi sge, %33, %c0_189 : index
          %c512 = arith.constant 512 : index
          %37 = arith.cmpi slt, %33, %c512 : index
          %38 = arith.andi %36, %37 : i1
          %39 = arith.andi %35, %38 : i1
          %40 = arith.andi %39, %32 : i1
          %c0_190 = arith.constant 0 : index
          %41 = arith.cmpi sge, %31, %c0_190 : index
          %c256_191 = arith.constant 256 : index
          %42 = arith.cmpi slt, %31, %c256_191 : index
          %43 = arith.andi %41, %42 : i1
          %44 = arith.andi %40, %43 : i1
          %45 = scf.if %44 -> (i32) {
            %100 = memref.load %alloca_0[%33, %31] : memref<512x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_205 = arith.constant 0 : i32
            scf.yield %c0_i32_205 : i32
          }
          %46 = arith.andi %44, %true_171 : i1
          %47 = arith.addi %45, %c1_i32 : i32
          %48 = arith.andi %44, %46 : i1
          %49 = arith.muli %45, %47 : i32
          %50 = arith.andi %true_171, %34 : i1
          %c0_192 = arith.constant 0 : index
          %51 = arith.cmpi sge, %33, %c0_192 : index
          %c512_193 = arith.constant 512 : index
          %52 = arith.cmpi slt, %33, %c512_193 : index
          %53 = arith.andi %51, %52 : i1
          %54 = arith.andi %50, %53 : i1
          %55 = arith.andi %54, %32 : i1
          %c0_194 = arith.constant 0 : index
          %56 = arith.cmpi sge, %31, %c0_194 : index
          %c256_195 = arith.constant 256 : index
          %57 = arith.cmpi slt, %31, %c256_195 : index
          %58 = arith.andi %56, %57 : i1
          %59 = arith.andi %55, %58 : i1
          %60 = scf.if %59 -> (i32) {
            %100 = memref.load %alloca[%33, %31] : memref<512x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_205 = arith.constant 0 : i32
            scf.yield %c0_i32_205 : i32
          }
          %61 = arith.andi %48, %59 : i1
          %62 = arith.muli %49, %60 : i32
          %63 = arith.andi %true_171, %32 : i1
          %c0_196 = arith.constant 0 : index
          %64 = arith.cmpi sge, %31, %c0_196 : index
          %65 = arith.cmpi slt, %31, %dim_175 : index
          %66 = arith.andi %64, %65 : i1
          %67 = arith.andi %63, %66 : i1
          %68 = arith.andi %67, %30 : i1
          %c0_197 = arith.constant 0 : index
          %69 = arith.cmpi sge, %29, %c0_197 : index
          %c256_198 = arith.constant 256 : index
          %70 = arith.cmpi slt, %29, %c256_198 : index
          %71 = arith.andi %69, %70 : i1
          %72 = arith.andi %68, %71 : i1
          %73 = scf.if %72 -> (i32) {
            %100 = memref.load %arg7[%31, %29] : memref<?x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_205 = arith.constant 0 : i32
            scf.yield %c0_i32_205 : i32
          }
          %74 = arith.andi %61, %72 : i1
          %75 = arith.muli %62, %73 : i32
          %76 = arith.andi %true_171, %34 : i1
          %c0_199 = arith.constant 0 : index
          %77 = arith.cmpi sge, %33, %c0_199 : index
          %78 = arith.cmpi slt, %33, %dim_173 : index
          %79 = arith.andi %77, %78 : i1
          %80 = arith.andi %76, %79 : i1
          %81 = arith.andi %80, %30 : i1
          %c0_200 = arith.constant 0 : index
          %82 = arith.cmpi sge, %29, %c0_200 : index
          %c256_201 = arith.constant 256 : index
          %83 = arith.cmpi slt, %29, %c256_201 : index
          %84 = arith.andi %82, %83 : i1
          %85 = arith.andi %81, %84 : i1
          %86 = scf.if %85 -> (i32) {
            %100 = memref.load %arg8[%33, %29] : memref<?x256xi32>
            scf.yield %100 : i32
          } else {
            %c0_i32_205 = arith.constant 0 : i32
            scf.yield %c0_i32_205 : i32
          }
          %87 = arith.andi %85, %74 : i1
          %88 = arith.addi %86, %75 : i32
          %89 = arith.andi %87, %true_171 : i1
          %90 = arith.andi %89, %34 : i1
          %c0_202 = arith.constant 0 : index
          %91 = arith.cmpi sge, %33, %c0_202 : index
          %92 = arith.cmpi slt, %33, %dim_173 : index
          %93 = arith.andi %91, %92 : i1
          %94 = arith.andi %90, %93 : i1
          %95 = arith.andi %94, %30 : i1
          %c0_203 = arith.constant 0 : index
          %96 = arith.cmpi sge, %29, %c0_203 : index
          %c256_204 = arith.constant 256 : index
          %97 = arith.cmpi slt, %29, %c256_204 : index
          %98 = arith.andi %96, %97 : i1
          %99 = arith.andi %95, %98 : i1
          scf.if %99 {
            memref.store %88, %arg8[%33, %29] : memref<?x256xi32>
          }
        }
      }
    } {amoeba.host.task_completion, amoeba.host.task_name = "Task_8"}
    return
  }
  func.func private @fill_llama_nonuniform(%memref: memref<?x256xi32>, %mode: i32) attributes {llvm.emit_c_interface}
  func.func private @check_llama_nonuniform(%seq: i32, %x: memref<?x256xi32>, %wq: memref<?x256xi32>, %wk: memref<?x256xi32>, %wv: memref<?x256xi32>, %w_gate: memref<?x256xi32>, %w_up: memref<?x256xi32>, %w_down: memref<?x256xi32>, %output: memref<?x256xi32>) -> i64 attributes {llvm.emit_c_interface}
  func.func @main() -> i64 {
    %i256 = arith.constant 256 : index
    %i512 = arith.constant 512 : index
    %seq = arith.constant 320 : i32
    %m0 = arith.constant 0 : i32
    %m1 = arith.constant 1 : i32
    %m2 = arith.constant 2 : i32
    %m3 = arith.constant 3 : i32
    %m4 = arith.constant 4 : i32
    %m5 = arith.constant 5 : i32
    %m6 = arith.constant 6 : i32
    %m7 = arith.constant 7 : i32
    %x = memref.alloc(%i512) : memref<?x256xi32>
    %wq = memref.alloc(%i256) : memref<?x256xi32>
    %wk = memref.alloc(%i256) : memref<?x256xi32>
    %wv = memref.alloc(%i256) : memref<?x256xi32>
    %w_gate = memref.alloc(%i256) : memref<?x256xi32>
    %w_up = memref.alloc(%i256) : memref<?x256xi32>
    %w_down = memref.alloc(%i256) : memref<?x256xi32>
    %output = memref.alloc(%i512) : memref<?x256xi32>
    func.call @fill_llama_nonuniform(%x, %m0) : (memref<?x256xi32>, i32) -> ()
    func.call @fill_llama_nonuniform(%wq, %m1) : (memref<?x256xi32>, i32) -> ()
    func.call @fill_llama_nonuniform(%wk, %m2) : (memref<?x256xi32>, i32) -> ()
    func.call @fill_llama_nonuniform(%wv, %m3) : (memref<?x256xi32>, i32) -> ()
    func.call @fill_llama_nonuniform(%w_gate, %m4) : (memref<?x256xi32>, i32) -> ()
    func.call @fill_llama_nonuniform(%w_up, %m5) : (memref<?x256xi32>, i32) -> ()
    func.call @fill_llama_nonuniform(%w_down, %m6) : (memref<?x256xi32>, i32) -> ()
    func.call @fill_llama_nonuniform(%output, %m7) : (memref<?x256xi32>, i32) -> ()
    func.call @_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i(%seq, %x, %wq, %wk, %wv, %w_gate, %w_up, %w_down, %output) : (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> ()
    %encoded = func.call @check_llama_nonuniform(%seq, %x, %wq, %wk, %wv, %w_gate, %w_up, %w_down, %output) : (i32, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>, memref<?x256xi32>) -> i64
    return %encoded : i64
  }
}
