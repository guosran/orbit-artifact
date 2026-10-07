module {
func.func @__task_profile__(%arg0: memref<?x128xi32>, %arg1: i32, %arg2: i1, %arg3: i32, %arg4: memref<?x128xi32>, %arg5: index) -> i1 attributes {accelerator = "neura", dataflow_mode = "predicate"} {
  %0 = "neura.constant"() <{value = "%arg1"}> : () -> !neura.data<i32, i1>
  %1 = "neura.grant_once"() <{constant_value = "%arg2"}> : () -> !neura.data<i1, i1>
  %2 = "neura.grant_once"() <{constant_value = "%arg3"}> : () -> !neura.data<i32, i1>
  %3 = "neura.grant_once"() <{constant_value = true}> : () -> !neura.data<i1, i1>
  %4 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "root", counter_id = 0 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = "%arg5"} -> !neura.data<index, i1>
  %5 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %6 = "neura.grant_once"(%5) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %7 = neura.counter attributes {counter_dynamism = "constant_bound", counter_hierarchy = "leaf", counter_id = 1 : i32, lower_bound_value = 0 : index, step_value = 1 : index, upper_bound_value = 128 : index} -> !neura.data<index, i1>
  %8 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %9 = "neura.grant_once"(%8) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %10 = "neura.data_mov"(%4) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %11 = "neura.data_mov"(%7) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %12 = neura.load_indexed [%10, %11 : !neura.data<index, i1>, !neura.data<index, i1>]  {lhs_value = "%arg0"} : !neura.data<i32, i1>
  %13 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %14 = "neura.grant_once"(%13) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %15 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %16 = "neura.icmp"(%15) <{cmpType = "slt"}> {rhs_value = "%arg1"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
  %17 = "neura.data_mov"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %18 = "neura.grant_once"(%17) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %19 = "neura.data_mov"(%16) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %20 = "neura.data_mov"(%0) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %21 = "neura.data_mov"(%12) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %22 = "neura.sel"(%19, %20, %21) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %23 = "neura.data_mov"(%22) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %24 = "neura.grant_once"(%23) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %25 = "neura.data_mov"(%1) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %26 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %27 = neura.grant_predicate %25, %26 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
  %28 = "neura.data_mov"(%2) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %29 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %30 = neura.grant_predicate %28, %29 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
  %31 = "neura.data_mov"(%24) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %32 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %33 = neura.grant_predicate %31, %32 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
  %34 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %35 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %36 = neura.grant_predicate %34, %35 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
  %37 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %38 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %39 = neura.grant_predicate %37, %38 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
  %40 = "neura.data_mov"(%3) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %41 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %42 = neura.grant_predicate %40, %41 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
  %43 = "neura.data_mov"(%18) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %44 = "neura.not"(%43) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %45 = "neura.data_mov"(%14) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %46 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %47 = neura.grant_predicate %45, %46 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
  %48 = "neura.data_mov"(%2) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %49 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %50 = neura.grant_predicate %48, %49 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
  %51 = "neura.data_mov"(%24) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %52 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %53 = neura.grant_predicate %51, %52 : !neura.data<i32, i1>, !neura.data<i1, i1> -> !neura.data<i32, i1>
  %54 = "neura.data_mov"(%6) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %55 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %56 = neura.grant_predicate %54, %55 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
  %57 = "neura.data_mov"(%9) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %58 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %59 = neura.grant_predicate %57, %58 : !neura.data<index, i1>, !neura.data<i1, i1> -> !neura.data<index, i1>
  %60 = "neura.data_mov"(%3) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %61 = "neura.data_mov"(%44) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %62 = neura.grant_predicate %60, %61 : !neura.data<i1, i1>, !neura.data<i1, i1> -> !neura.data<i1, i1>
  %63 = "neura.data_mov"(%47) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %64 = "neura.icmp"(%63) <{cmpType = "sgt"}> {rhs_value = "%arg3"} : (!neura.data<i32, i1>) -> !neura.data<i1, i1>
  %65 = "neura.data_mov"(%42) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %66 = "neura.data_mov"(%62) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %67 = "neura.phi"(%65, %66) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
  %68 = "neura.data_mov"(%39) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %69 = "neura.data_mov"(%59) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %70 = "neura.phi"(%68, %69) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
  %71 = "neura.data_mov"(%36) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %72 = "neura.data_mov"(%56) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %73 = "neura.phi"(%71, %72) : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<index, i1>
  %74 = "neura.data_mov"(%33) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %75 = "neura.data_mov"(%53) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %76 = "neura.phi"(%74, %75) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %77 = "neura.data_mov"(%30) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %78 = "neura.data_mov"(%50) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %79 = "neura.phi"(%77, %78) : (!neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %80 = "neura.data_mov"(%27) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %81 = "neura.data_mov"(%64) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %82 = "neura.phi"(%80, %81) : (!neura.data<i1, i1>, !neura.data<i1, i1>) -> !neura.data<i1, i1>
  %83 = "neura.data_mov"(%82) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  %84 = "neura.data_mov"(%79) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %85 = "neura.data_mov"(%76) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %86 = "neura.sel"(%83, %84, %85) : (!neura.data<i1, i1>, !neura.data<i32, i1>, !neura.data<i32, i1>) -> !neura.data<i32, i1>
  %87 = "neura.data_mov"(%86) : (!neura.data<i32, i1>) -> !neura.data<i32, i1>
  %88 = "neura.data_mov"(%73) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  %89 = "neura.data_mov"(%70) : (!neura.data<index, i1>) -> !neura.data<index, i1>
  neura.store_indexed %87 to [%88, %89 : !neura.data<index, i1>, !neura.data<index, i1>]  {rhs_value = "%arg4"} : !neura.data<i32, i1>
  %90 = "neura.data_mov"(%67) : (!neura.data<i1, i1>) -> !neura.data<i1, i1>
  neura.return_value %90 : !neura.data<i1, i1>
  neura.yield
}
}
