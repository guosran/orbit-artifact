module {
"func.func"() <{function_type = (!neura.data<memref<?x128xi32>, i1>, !neura.data<i32, i1>, !neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<memref<?x128xi32>, i1>, !neura.data<index, i1>) -> (), sym_name = "__joint_task_mapper_replay__"}> ({
^bb0(%arg0: !neura.data<memref<?x128xi32>, i1>, %arg1: !neura.data<i32, i1>, %arg2: !neura.data<i1, i1>, %arg3: !neura.data<i32, i1>, %arg4: !neura.data<memref<?x128xi32>, i1>, %arg5: !neura.data<index, i1>):
  %0 = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
  %1 = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i1, i1>
  %2 = "neura.constant"() <{value = "%input3"}> : () -> !neura.data<i32, i1>
  %3 = "neura.counter"() <{counter_dynamism = "symbol_bound", counter_hierarchy = "root", counter_id = 0 : i32, operandSegmentSizes = array<i32: 0, 0, 0>}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%input5"} : () -> !neura.data<index, i1>
  %4 = "neura.counter"() <{counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, operandSegmentSizes = array<i32: 0, 0, 0>}> {lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} : () -> !neura.data<index, i1>
  %5 = "neura.data_mov"(%3) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %6 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %7 = "neura.load_indexed"(%5, %6) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
  %8 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %9 = "neura.icmp"(%8) <{cmpType = "slt"}> {rhs_value = "%input1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
  %10 = "neura.data_mov"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %11 = "neura.data_mov"(%0) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %12 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %13 = "neura.sel"(%10, %11, %12) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %14 = "neura.data_mov"(%1) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %15 = "neura.data_mov"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %16 = "neura.grant_predicate"(%14, %15) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
  %17 = "neura.data_mov"(%2) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %18 = "neura.data_mov"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %19 = "neura.grant_predicate"(%17, %18) : (!neura.data<i32, i1>, !neura.data<i1, i1>) -> !neura.data<i32, i1>
  %20 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %21 = "neura.data_mov"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %22 = "neura.grant_predicate"(%20, %21) : (!neura.data<i32, i1>, !neura.data<i1, i1>) -> !neura.data<i32, i1>
  %23 = "neura.data_mov"(%3) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %24 = "neura.data_mov"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %25 = "neura.grant_predicate"(%23, %24) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
  %26 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %27 = "neura.data_mov"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %28 = "neura.grant_predicate"(%26, %27) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
  %29 = "neura.data_mov"(%9) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %30 = "neura.not"(%29) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %31 = "neura.data_mov"(%7) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %32 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %33 = "neura.grant_predicate"(%31, %32) : (!neura.data<i32, i1>, !neura.data<i1, i1>) -> !neura.data<i32, i1>
  %34 = "neura.data_mov"(%2) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %35 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %36 = "neura.grant_predicate"(%34, %35) : (!neura.data<i32, i1>, !neura.data<i1, i1>) -> !neura.data<i32, i1>
  %37 = "neura.data_mov"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %38 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %39 = "neura.grant_predicate"(%37, %38) : (!neura.data<i32, i1>, !neura.data<i1, i1>) -> !neura.data<i32, i1>
  %40 = "neura.data_mov"(%3) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %41 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %42 = "neura.grant_predicate"(%40, %41) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
  %43 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %44 = "neura.data_mov"(%30) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %45 = "neura.grant_predicate"(%43, %44) : (!neura.data<index, i1>, !neura.data<i1, i1>) -> !neura.data<index, i1>
  %46 = "neura.data_mov"(%33) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %47 = "neura.icmp"(%46) <{cmpType = "sgt"}> {rhs_value = "%input3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
  %48 = "neura.data_mov"(%28) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %49 = "neura.data_mov"(%45) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %50 = "neura.phi"(%48, %49) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
  %51 = "neura.data_mov"(%25) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %52 = "neura.data_mov"(%42) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %53 = "neura.phi"(%51, %52) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
  %54 = "neura.data_mov"(%22) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %55 = "neura.data_mov"(%39) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %56 = "neura.phi"(%54, %55) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %57 = "neura.data_mov"(%19) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %58 = "neura.data_mov"(%36) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %59 = "neura.phi"(%57, %58) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %60 = "neura.data_mov"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %61 = "neura.data_mov"(%47) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %62 = "neura.phi"(%60, %61) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
  %63 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %64 = "neura.data_mov"(%59) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %65 = "neura.data_mov"(%56) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %66 = "neura.sel"(%63, %64, %65) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %67 = "neura.data_mov"(%66) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %68 = "neura.data_mov"(%53) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %69 = "neura.data_mov"(%50) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  "neura.store_indexed"(%67, %68, %69) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input4"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
  "func.return"() : () -> ()
}) {accelerator = "neura"} : () -> ()
}
