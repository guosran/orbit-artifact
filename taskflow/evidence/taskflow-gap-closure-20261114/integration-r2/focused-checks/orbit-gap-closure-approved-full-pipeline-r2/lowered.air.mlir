"builtin.module"() ({
  "func.func"() <{function_type = (memref<15x10xf32>, memref<15x10xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<15x10xf32>, %arg1: memref<15x10xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1) ({
    ^bb0(%arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: memref<15x10xf32>, %arg7: memref<15x10xf32>):
      "air.segment"(%arg6, %arg7) ({
      ^bb0(%arg8: memref<15x10xf32>, %arg9: memref<15x10xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg8, %arg9) ({
        ^bb0(%arg10: index, %arg11: index, %arg12: index, %arg13: index, %arg14: memref<15x10xf32>, %arg15: memref<15x10xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 1 : i64, orbit.storage = "arg0", orbit.tile_pool = "storage-0.data"} : () -> memref<15x10xf32, 2 : i32>
          %3 = "air.dma_memcpy_nd"(%2, %arg14) {operandSegmentSizes = array<i32: 0, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0, 1, 2>, orbit.storage = "arg0", orbit.target_copies = array<i64: 3, 4, 5>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 15, 10>, static_dst_strides = array<i64: 10, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 15, 10>, static_src_strides = array<i64: 10, 1>} : (memref<15x10xf32, 2 : i32>, memref<15x10xf32>) -> !air.async.token
          %4 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 3 : i64, orbit.storage = "arg1", orbit.tile_pool = "storage-1.data"} : () -> memref<15x10xf32, 2 : i32>
          "air.wait_all"(%3) {orbit.computation_event = 1 : i64, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 3>, orbit.source_dependencies = array<i64>, orbit.source_instance = 0 : i64, orbit.task = "Pointwise.tile.0.0", orbit.write_copies = array<i64: 6>} : (!air.async.token) -> ()
          %5 = "arith.constant"() <{value = 0 : index}> {orbit.task = "Pointwise.tile.0.0"} : () -> index
          %6 = "arith.constant"() <{value = 1 : index}> {orbit.task = "Pointwise.tile.0.0"} : () -> index
          %7 = "arith.constant"() <{value = 15 : index}> {orbit.task = "Pointwise.tile.0.0"} : () -> index
          %8 = "arith.constant"() <{value = 10 : index}> {orbit.task = "Pointwise.tile.0.0"} : () -> index
          %9 = "arith.constant"() <{value = 0 : index}> {orbit.task = "Pointwise.tile.0.0"} : () -> index
          %10 = "arith.constant"() <{value = 5 : index}> {orbit.task = "Pointwise.tile.0.0"} : () -> index
          %11 = "arith.constant"() <{value = 0 : index}> : () -> index
          %12 = "arith.constant"() <{value = 5 : index}> : () -> index
          %13 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%11, %12, %13) ({
          ^bb0(%arg20: index):
            %46 = "arith.constant"() <{value = 0 : index}> : () -> index
            %47 = "arith.constant"() <{value = 10 : index}> : () -> index
            %48 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%46, %47, %48) ({
            ^bb0(%arg21: index):
              %49 = "memref.load"(%2, %arg20, %arg21) : (memref<15x10xf32, 2 : i32>, index, index) -> f32
              %50 = "arith.addf"(%49, %49) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%50, %4, %arg20, %arg21) : (f32, memref<15x10xf32, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %14 = "air.wait_all"() {orbit.task_completion = "Pointwise.tile.0.0"} : () -> !air.async.token
          "air.wait_all"(%14) {orbit.computation_event = 2 : i64, orbit.public_dependencies = array<i64: 0, 1>, orbit.read_copies = array<i64: 4>, orbit.source_dependencies = array<i64>, orbit.source_instance = 1 : i64, orbit.task = "Pointwise.tile.0.1", orbit.write_copies = array<i64: 7>} : (!air.async.token) -> ()
          %15 = "arith.constant"() <{value = 0 : index}> {orbit.task = "Pointwise.tile.0.1"} : () -> index
          %16 = "arith.constant"() <{value = 1 : index}> {orbit.task = "Pointwise.tile.0.1"} : () -> index
          %17 = "arith.constant"() <{value = 15 : index}> {orbit.task = "Pointwise.tile.0.1"} : () -> index
          %18 = "arith.constant"() <{value = 10 : index}> {orbit.task = "Pointwise.tile.0.1"} : () -> index
          %19 = "arith.constant"() <{value = 5 : index}> {orbit.task = "Pointwise.tile.0.1"} : () -> index
          %20 = "arith.constant"() <{value = 10 : index}> {orbit.task = "Pointwise.tile.0.1"} : () -> index
          %21 = "arith.constant"() <{value = 5 : index}> : () -> index
          %22 = "arith.constant"() <{value = 10 : index}> : () -> index
          %23 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%21, %22, %23) ({
          ^bb0(%arg18: index):
            %41 = "arith.constant"() <{value = 0 : index}> : () -> index
            %42 = "arith.constant"() <{value = 10 : index}> : () -> index
            %43 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%41, %42, %43) ({
            ^bb0(%arg19: index):
              %44 = "memref.load"(%2, %arg18, %arg19) : (memref<15x10xf32, 2 : i32>, index, index) -> f32
              %45 = "arith.addf"(%44, %44) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%45, %4, %arg18, %arg19) : (f32, memref<15x10xf32, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %24 = "air.wait_all"() {orbit.task_completion = "Pointwise.tile.0.1"} : () -> !air.async.token
          "air.wait_all"(%24) {orbit.computation_event = 3 : i64, orbit.public_dependencies = array<i64: 0, 2>, orbit.read_copies = array<i64: 5>, orbit.source_dependencies = array<i64>, orbit.source_instance = 2 : i64, orbit.task = "Pointwise.tile.0.2", orbit.write_copies = array<i64: 8>} : (!air.async.token) -> ()
          %25 = "arith.constant"() <{value = 0 : index}> {orbit.task = "Pointwise.tile.0.2"} : () -> index
          %26 = "arith.constant"() <{value = 1 : index}> {orbit.task = "Pointwise.tile.0.2"} : () -> index
          %27 = "arith.constant"() <{value = 15 : index}> {orbit.task = "Pointwise.tile.0.2"} : () -> index
          %28 = "arith.constant"() <{value = 10 : index}> {orbit.task = "Pointwise.tile.0.2"} : () -> index
          %29 = "arith.constant"() <{value = 10 : index}> {orbit.task = "Pointwise.tile.0.2"} : () -> index
          %30 = "arith.constant"() <{value = 15 : index}> {orbit.task = "Pointwise.tile.0.2"} : () -> index
          %31 = "arith.constant"() <{value = 10 : index}> : () -> index
          %32 = "arith.constant"() <{value = 15 : index}> : () -> index
          %33 = "arith.constant"() <{value = 1 : index}> : () -> index
          "scf.for"(%31, %32, %33) ({
          ^bb0(%arg16: index):
            %36 = "arith.constant"() <{value = 0 : index}> : () -> index
            %37 = "arith.constant"() <{value = 10 : index}> : () -> index
            %38 = "arith.constant"() <{value = 1 : index}> : () -> index
            "scf.for"(%36, %37, %38) ({
            ^bb0(%arg17: index):
              %39 = "memref.load"(%2, %arg16, %arg17) : (memref<15x10xf32, 2 : i32>, index, index) -> f32
              %40 = "arith.addf"(%39, %39) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
              "memref.store"(%40, %4, %arg16, %arg17) : (f32, memref<15x10xf32, 2 : i32>, index, index) -> ()
              "scf.yield"() : () -> ()
            }) : (index, index, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          %34 = "air.wait_all"() {orbit.task_completion = "Pointwise.tile.0.2"} : () -> !air.async.token
          %35 = "air.dma_memcpy_nd"(%34, %arg15, %4) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 0, 0, 0>, orbit.phase = 2 : i64, orbit.source_copies = array<i64: 6, 7, 8>, orbit.storage = "arg1", orbit.target_copies = array<i64: 9, 10, 11>, orbit.transfer = "l1_to_host", orbit.transfer_event = 4 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 15, 10>, static_dst_strides = array<i64: 10, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 15, 10>, static_src_strides = array<i64: 10, 1>} : (!air.async.token, memref<15x10xf32>, memref<15x10xf32, 2 : i32>) -> !air.async.token
          "air.wait_all"(%35) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<15x10xf32, 2 : i32>) -> ()
          "memref.dealloc"(%4) : (memref<15x10xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 2>, orbit.mapping_strategy = "single-herd-resident", sym_name = "orbit_herd"} : (index, index, memref<15x10xf32>, memref<15x10xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 2>, sym_name = "orbit_segment"} : (memref<15x10xf32>, memref<15x10xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 2>, sym_name = "orbit_launch"} : (index, index, memref<15x10xf32>, memref<15x10xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_realization = "phase-local", orbit.data_organization_scope = "whole-program local copies; intermediate and input copies shared by all consumers in one herd", orbit.graph_schedule_realization = "common execution groups and explicit copy/release dependencies; source compute order preserved; conservative timing reservations are separate from runtime arbitration", orbit.mapping_plan = "eb0bee77ae71b96c80a34e28322cf9f253edff356382d75f4d902e14a5247648", orbit.program_graph = "9958a4881b517a370a53095e34c4bbb253e1c8a0a9c7bb4583790d0b148a424e", orbit.source_fingerprint = "de6088c680f5b91fdf98f23584c854e38224df7e8e454edb15b6d975dbdafe12"} : () -> ()

