module attributes {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_scope = "phase-local input copies; source output/reduction lifetime preserved", orbit.f32_lane_legalization = "scalar-product-vector-add-f32; scalar compiler-rt mul/div; source-ordered vector add/sub; no FMA/BF16", orbit.mapping_plan = "e8357bb95e79e677d6f4cada13f068cc62b01287821cb2135977c6962193de03", orbit.source_fingerprint = "d7e61ee155d2499dd3f48faeec8e03662e2fbfa736ac774de4028bd533ecfe27"} {
  func.func private @__mulsf3(f32, f32) -> f32 attributes {llvm.readnone, orbit.scalar_f32_builtin = "compiler-rt; same target scalar f32 operation; no vector approximation", passthrough = ["noinline", "nounwind"]}
  func.func @gemm(%arg0: memref<4x8xf32>, %arg1: memref<8x16xf32>, %arg2: memref<4x16xf32>) {
    %c1 = arith.constant 1 : index
    %0 = air.launch @orbit_launch async (%arg3, %arg4) in (%arg5=%c1, %arg6=%c1) args(%arg7=%arg0, %arg8=%arg1, %arg9=%arg2) : memref<4x8xf32>, memref<8x16xf32>, memref<4x16xf32> attributes {id = 3 : i32} {
      %1 = air.segment @orbit_segment async  args(%arg10=%arg7, %arg11=%arg8, %arg12=%arg9) : memref<4x8xf32>, memref<8x16xf32>, memref<4x16xf32> attributes {id = 2 : i32} {
        %c1_0 = arith.constant 1 : index
        %2 = air.herd @orbit_herd async  tile (%arg13, %arg14) in (%arg15=%c1_0, %arg16=%c1_0) args(%arg17=%arg10, %arg18=%arg11, %arg19=%arg12) : memref<4x8xf32>, memref<8x16xf32>, memref<4x16xf32> attributes {id = 1 : i32, orbit.mapping_strategy = "serial-tiled"} {
          %async_token, %results = air.execute -> (memref<8xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.2.4.loops.2.8.4"} : memref<8xf32, 2 : i32>
            air.execute_terminator %alloc : memref<8xf32, 2 : i32>
          } {id = 1 : i32}
          %async_token_1, %results_2 = air.execute -> (memref<32xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data.input.4.8.loops.2.8.4"} : memref<32xf32, 2 : i32>
            air.execute_terminator %alloc : memref<32xf32, 2 : i32>
          } {id = 2 : i32}
          %async_token_3, %results_4 = air.execute -> (memref<16xf32, 2 : i32>) {
            %alloc = memref.alloc() {orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : memref<16xf32, 2 : i32>
            air.execute_terminator %alloc : memref<16xf32, 2 : i32>
          } {id = 3 : i32}
          %3 = air.wait_all async  {id = 1 : i32}
          %c0 = arith.constant 0 : index
          %c2 = arith.constant 2 : index
          %c1_5 = arith.constant 1 : index
          %4 = scf.for %arg20 = %c0 to %c2 step %c1_5 iter_args(%arg21 = %3) -> (!air.async.token) {
            %c2_9 = arith.constant 2 : index
            %5 = arith.muli %arg20, %c2_9 : index
            %c2_10 = arith.constant 2 : index
            %6 = arith.muli %arg20, %c2_10 : index
            %c2_11 = arith.constant 2 : index
            %7 = arith.muli %arg20, %c2_11 : index
            %c0_12 = arith.constant 0 : index
            %c2_13 = arith.constant 2 : index
            %c1_14 = arith.constant 1 : index
            %8 = scf.for %arg22 = %c0_12 to %c2_13 step %c1_14 iter_args(%arg23 = %arg21) -> (!air.async.token) {
              %c8 = arith.constant 8 : index
              %9 = arith.muli %arg22, %c8 : index
              %c8_15 = arith.constant 8 : index
              %10 = arith.muli %arg22, %c8_15 : index
              %c8_16 = arith.constant 8 : index
              %11 = arith.muli %arg22, %c8_16 : index
              %reinterpret_cast = memref.reinterpret_cast %results_4 to offset: [0], sizes: [2, 8], strides: [8, 1] {orbit.initializer_task = "gemm.initialize", orbit.phase = 4 : i64, orbit.storage = "C"} : memref<16xf32, 2 : i32> to memref<2x8xf32, strided<[8, 1]>, 2 : i32>
              %cst = arith.constant 0.000000e+00 : f32
              %c0_17 = arith.constant 0 : index
              %c2_18 = arith.constant 2 : index
              %c1_19 = arith.constant 1 : index
              %12 = air.wait_all async  {id = 8 : i32}
              %13 = scf.for %arg24 = %c0_17 to %c2_18 step %c1_19 iter_args(%arg25 = %12) -> (!air.async.token) {
                %20 = arith.addi %arg24, %5 : index
                %c0_25 = arith.constant 0 : index
                %c8_26 = arith.constant 8 : index
                %c1_27 = arith.constant 1 : index
                %21 = air.wait_all async [%arg25]  {id = 6 : i32}
                %22 = scf.for %arg26 = %c0_25 to %c8_26 step %c1_27 iter_args(%arg27 = %21) -> (!air.async.token) {
                  %cst_28 = arith.constant 0.000000e+00 : f32
                  %24 = arith.addi %arg26, %9 : index
                  %25 = arith.subi %20, %7 : index
                  %26 = arith.subi %24, %11 : index
                  %async_token_29 = air.execute [%arg27] {
                    memref.store %cst_28, %reinterpret_cast[%25, %26] : memref<2x8xf32, strided<[8, 1]>, 2 : i32>
                  } {id = 4 : i32}
                  %27 = air.wait_all async [%async_token_29]  {id = 7 : i32}
                  scf.yield %27 : !air.async.token
                }
                %23 = air.wait_all async [%22]  {id = 9 : i32}
                scf.yield %23 : !air.async.token
              }
              %c0_20 = arith.constant 0 : index
              %c2_21 = arith.constant 2 : index
              %c1_22 = arith.constant 1 : index
              %14 = air.wait_all async [%13]  {id = 16 : i32}
              %15:2 = scf.for %arg24 = %c0_20 to %c2_21 step %c1_22 iter_args(%arg25 = %arg23, %arg26 = %14) -> (!air.async.token, !air.async.token) {
                %c4 = arith.constant 4 : index
                %20 = arith.muli %arg24, %c4 : index
                %c4_25 = arith.constant 4 : index
                %21 = arith.muli %arg24, %c4_25 : index
                %c4_26 = arith.constant 4 : index
                %22 = arith.muli %arg24, %c4_26 : index
                %reinterpret_cast_27 = memref.reinterpret_cast %results to offset: [0], sizes: [2, 4], strides: [4, 1] {orbit.phase = 4 : i64, orbit.storage = "A"} : memref<8xf32, 2 : i32> to memref<2x4xf32, strided<[4, 1]>, 2 : i32>
                %c0_28 = arith.constant 0 : index
                %23 = arith.addi %c0_28, %6 : index
                %c0_29 = arith.constant 0 : index
                %24 = arith.addi %c0_29, %21 : index
                %25 = air.dma_memcpy_nd async [%arg25] (%reinterpret_cast_27[0, 0] [2, 4] [4, 1], %arg17[%23, %24] [2, 4] [8, 1]) {id = 1 : i32, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "A", orbit.target_copies = array<i64: 8>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64} : (memref<2x4xf32, strided<[4, 1]>, 2 : i32>, memref<4x8xf32>)
                %reinterpret_cast_30 = memref.reinterpret_cast %results_2 to offset: [0], sizes: [4, 8], strides: [8, 1] {orbit.phase = 4 : i64, orbit.storage = "B"} : memref<32xf32, 2 : i32> to memref<4x8xf32, strided<[8, 1]>, 2 : i32>
                %c0_31 = arith.constant 0 : index
                %26 = arith.addi %c0_31, %22 : index
                %c0_32 = arith.constant 0 : index
                %27 = arith.addi %c0_32, %10 : index
                %28 = air.dma_memcpy_nd async [%arg25] (%reinterpret_cast_30[0, 0] [4, 8] [8, 1], %arg18[%26, %27] [4, 8] [16, 1]) {id = 2 : i32, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 4>, orbit.storage = "B", orbit.target_copies = array<i64: 9>, orbit.transfer = "host_to_l1", orbit.transfer_event = 1 : i64} : (memref<4x8xf32, strided<[8, 1]>, 2 : i32>, memref<8x16xf32>)
                air.wait_all [%25, %28]  {id = 2 : i32, orbit.computation_event = 3 : i64, orbit.phase = 4 : i64, orbit.phase_dependencies = array<i64: 3>, orbit.read_copies = array<i64: 8, 9, 10>, orbit.task = "gemm", orbit.write_copies = array<i64: 11>}
                %async_token_33, %results_34 = air.execute [%arg25, %25] -> (memref<2x4xf32, 2 : i32>) {
                  %cast = memref.cast %reinterpret_cast_27 : memref<2x4xf32, strided<[4, 1]>, 2 : i32> to memref<2x4xf32, 2 : i32>
                  air.execute_terminator %cast : memref<2x4xf32, 2 : i32>
                } {id = 5 : i32}
                %async_token_35, %results_36 = air.execute [%arg25, %28] -> (memref<4x8xf32, 2 : i32>) {
                  %cast = memref.cast %reinterpret_cast_30 : memref<4x8xf32, strided<[8, 1]>, 2 : i32> to memref<4x8xf32, 2 : i32>
                  air.execute_terminator %cast : memref<4x8xf32, 2 : i32>
                } {id = 6 : i32}
                %async_token_37, %results_38 = air.execute [%arg25] -> (memref<2x8xf32, 2 : i32>) {
                  %cast = memref.cast %reinterpret_cast : memref<2x8xf32, strided<[8, 1]>, 2 : i32> to memref<2x8xf32, 2 : i32>
                  air.execute_terminator %cast : memref<2x8xf32, 2 : i32>
                } {id = 7 : i32}
                %cst_39 = arith.constant 0.000000e+00 : f32
                %c0_40 = arith.constant 0 : index
                %c2_41 = arith.constant 2 : index
                %c1_42 = arith.constant 1 : index
                %29 = air.wait_all async [%arg25, %async_token_33, %async_token_35, %async_token_37]  {id = 14 : i32}
                %30 = scf.for %arg27 = %c0_40 to %c2_41 step %c1_42 iter_args(%arg28 = %29) -> (!air.async.token) {
                  %33 = arith.addi %arg27, %5 : index
                  %c0_43 = arith.constant 0 : index
                  %c8_44 = arith.constant 8 : index
                  %c8_45 = arith.constant 8 : index
                  %34 = air.wait_all async [%arg28, %arg28, %arg28]  {id = 12 : i32}
                  %35 = scf.for %arg29 = %c0_43 to %c8_44 step %c8_45 iter_args(%arg30 = %34) -> (!air.async.token) {
                    %37 = arith.addi %arg29, %9 : index
                    %c0_46 = arith.constant 0 : index
                    %c4_47 = arith.constant 4 : index
                    %c1_48 = arith.constant 1 : index
                    %38 = air.wait_all async [%arg30, %arg30, %arg30]  {id = 10 : i32}
                    %39 = scf.for %arg31 = %c0_46 to %c4_47 step %c1_48 iter_args(%arg32 = %38) -> (!air.async.token) {
                      %41 = arith.addi %arg31, %20 : index
                      %cst_49 = arith.constant 0.000000e+00 : f32
                      %42 = arith.subi %33, %6 : index
                      %43 = arith.subi %41, %21 : index
                      %async_token_50, %results_51 = air.execute [%arg32] -> (f32) {
                        %69 = memref.load %results_34[%42, %43] : memref<2x4xf32, 2 : i32>
                        air.execute_terminator %69 : f32
                      } {id = 8 : i32}
                      %44 = vector.broadcast %results_51 {orbit.invariant_scalar_broadcast} : f32 to vector<8xf32>
                      %cst_52 = arith.constant 0.000000e+00 : f32
                      %45 = arith.subi %41, %22 : index
                      %46 = arith.subi %37, %10 : index
                      %async_token_53, %results_54 = air.execute [%arg32] -> (vector<8xf32>) {
                        %69 = vector.transfer_read %results_36[%45, %46], %cst_52 : memref<4x8xf32, 2 : i32>, vector<8xf32>
                        air.execute_terminator %69 : vector<8xf32>
                      } {id = 9 : i32}
                      %cst_55 = arith.constant 0.000000e+00 : f32
                      %47 = arith.subi %33, %7 : index
                      %48 = arith.subi %37, %11 : index
                      %async_token_56, %results_57 = air.execute [%arg32] -> (vector<8xf32>) {
                        %69 = vector.transfer_read %results_38[%47, %48], %cst_55 : memref<2x8xf32, 2 : i32>, vector<8xf32>
                        air.execute_terminator %69 : vector<8xf32>
                      } {id = 10 : i32}
                      %cst_58 = arith.constant dense<0.000000e+00> : vector<8xf32>
                      %49 = vector.extract %results_54[0] : f32 from vector<8xf32>
                      %async_token_59, %results_60 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %49) {orbit.scalarized_lane = 0 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 11 : i32}
                      %50 = vector.insert %results_60, %cst_58 [0] : f32 into vector<8xf32>
                      %51 = vector.extract %results_54[1] : f32 from vector<8xf32>
                      %async_token_61, %results_62 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %51) {orbit.scalarized_lane = 1 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 12 : i32}
                      %52 = vector.insert %results_62, %50 [1] : f32 into vector<8xf32>
                      %53 = vector.extract %results_54[2] : f32 from vector<8xf32>
                      %async_token_63, %results_64 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %53) {orbit.scalarized_lane = 2 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 13 : i32}
                      %54 = vector.insert %results_64, %52 [2] : f32 into vector<8xf32>
                      %55 = vector.extract %results_54[3] : f32 from vector<8xf32>
                      %async_token_65, %results_66 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %55) {orbit.scalarized_lane = 3 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 14 : i32}
                      %56 = vector.insert %results_66, %54 [3] : f32 into vector<8xf32>
                      %57 = vector.extract %results_54[4] : f32 from vector<8xf32>
                      %async_token_67, %results_68 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %57) {orbit.scalarized_lane = 4 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 15 : i32}
                      %58 = vector.insert %results_68, %56 [4] : f32 into vector<8xf32>
                      %59 = vector.extract %results_54[5] : f32 from vector<8xf32>
                      %async_token_69, %results_70 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %59) {orbit.scalarized_lane = 5 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 16 : i32}
                      %60 = vector.insert %results_70, %58 [5] : f32 into vector<8xf32>
                      %61 = vector.extract %results_54[6] : f32 from vector<8xf32>
                      %async_token_71, %results_72 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %61) {orbit.scalarized_lane = 6 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 17 : i32}
                      %62 = vector.insert %results_72, %60 [6] : f32 into vector<8xf32>
                      %63 = vector.extract %results_54[7] : f32 from vector<8xf32>
                      %async_token_73, %results_74 = air.execute [%arg32, %async_token_50] -> (f32) {
                        %69 = func.call @__mulsf3(%results_51, %63) {orbit.scalarized_lane = 7 : i64, orbit.scalarized_operation = "arith.mulf"} : (f32, f32) -> f32
                        air.execute_terminator %69 : f32
                      } {id = 18 : i32}
                      %64 = vector.insert %results_74, %62 [7] : f32 into vector<8xf32>
                      %65 = arith.addf %results_57, %64 : vector<8xf32>
                      %66 = arith.subi %33, %7 : index
                      %67 = arith.subi %37, %11 : index
                      %async_token_75 = air.execute [%arg32, %async_token_56] {
                        vector.transfer_write %65, %results_38[%66, %67] : vector<8xf32>, memref<2x8xf32, 2 : i32>
                      } {id = 19 : i32}
                      %68 = air.wait_all async [%async_token_53, %async_token_59, %async_token_61, %async_token_63, %async_token_65, %async_token_67, %async_token_69, %async_token_71, %async_token_73, %async_token_75]  {id = 11 : i32}
                      scf.yield %68 : !air.async.token
                    }
                    %40 = air.wait_all async [%39]  {id = 13 : i32}
                    scf.yield %40 : !air.async.token
                  }
                  %36 = air.wait_all async [%35]  {id = 15 : i32}
                  scf.yield %36 : !air.async.token
                }
                %31 = air.wait_all async [%arg25]  {id = 3 : i32}
                %32 = air.wait_all async [%30]  {id = 17 : i32}
                scf.yield %31, %32 : !air.async.token, !air.async.token
              }
              %c0_23 = arith.constant 0 : index
              %16 = arith.addi %c0_23, %7 : index
              %c0_24 = arith.constant 0 : index
              %17 = arith.addi %c0_24, %11 : index
              %18 = air.dma_memcpy_nd async [%15#1, %15#0] (%arg19[%16, %17] [2, 8] [16, 1], %reinterpret_cast[0, 0] [2, 8] [8, 1]) {id = 3 : i32, orbit.phase = 5 : i64, orbit.retained_begin = 4 : i64, orbit.retained_end = 6 : i64, orbit.source_copies = array<i64: 14>, orbit.storage = "C", orbit.target_copies = array<i64: 15>, orbit.transfer = "l1_to_host", orbit.transfer_event = 7 : i64} : (memref<4x16xf32>, memref<2x8xf32, strided<[8, 1]>, 2 : i32>)
              %19 = air.wait_all async [%18]  {id = 4 : i32}
              scf.yield %19 : !air.async.token
            } {orbit.compressed_phases = 2 : i64}
            scf.yield %8 : !air.async.token
          } {orbit.compressed_phases = 2 : i64}
          air.wait_all [%4]  {id = 5 : i32}
          %async_token_6 = air.execute [%async_token] {
            memref.dealloc %results : memref<8xf32, 2 : i32>
          } {id = 20 : i32}
          %async_token_7 = air.execute [%async_token_1] {
            memref.dealloc %results_2 : memref<32xf32, 2 : i32>
          } {id = 21 : i32}
          %async_token_8 = air.execute [%async_token_3] {
            memref.dealloc %results_4 : memref<16xf32, 2 : i32>
          } {id = 22 : i32}
        }
      }
    }
    return
  }
}

