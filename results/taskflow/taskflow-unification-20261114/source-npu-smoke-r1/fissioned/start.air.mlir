"builtin.module"() ({
  "func.func"() <{function_type = (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> (), sym_name = "pointwise"}> ({
  ^bb0(%arg0: memref<64x64xf32>, %arg1: memref<64x64xf32>, %arg2: memref<64x64xf32>, %arg3: memref<64x64xf32>):
    %0 = "arith.constant"() <{value = 1 : index}> : () -> index
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg56: index, %arg57: index, %arg58: index, %arg59: index, %arg60: memref<64x64xf32>, %arg61: memref<64x64xf32>, %arg62: memref<64x64xf32>, %arg63: memref<64x64xf32>):
      "air.segment"(%arg60, %arg61, %arg62, %arg63) ({
      ^bb0(%arg64: memref<64x64xf32>, %arg65: memref<64x64xf32>, %arg66: memref<64x64xf32>, %arg67: memref<64x64xf32>):
        %110 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%110, %110, %arg64, %arg65, %arg66, %arg67) ({
        ^bb0(%arg68: index, %arg69: index, %arg70: index, %arg71: index, %arg72: memref<64x64xf32>, %arg73: memref<64x64xf32>, %arg74: memref<64x64xf32>, %arg75: memref<64x64xf32>):
          %111 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 4 : i64, orbit.storage_index = 0 : i64, orbit.tile_pool = "storage-0.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %112 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 5 : i64, orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data"} : () -> memref<1024xf32, 2 : i32>
          %113 = "air.wait_all"() : () -> !air.async.token
          %114 = "arith.constant"() <{value = 0 : index}> : () -> index
          %115 = "arith.constant"() <{value = 2 : index}> : () -> index
          %116 = "arith.constant"() <{value = 1 : index}> : () -> index
          %117 = "scf.for"(%114, %115, %116, %113) ({
          ^bb0(%arg76: index, %arg77: !air.async.token):
            %118 = "arith.constant"() <{value = 32 : index}> : () -> index
            %119 = "arith.muli"(%arg76, %118) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %120 = "arith.constant"() <{value = 32 : index}> : () -> index
            %121 = "arith.muli"(%arg76, %120) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %122 = "arith.constant"() <{value = 32 : index}> : () -> index
            %123 = "arith.muli"(%arg76, %122) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %124 = "arith.constant"() <{value = 0 : index}> : () -> index
            %125 = "arith.constant"() <{value = 2 : index}> : () -> index
            %126 = "arith.constant"() <{value = 1 : index}> : () -> index
            %127 = "scf.for"(%124, %125, %126, %arg77) ({
            ^bb0(%arg78: index, %arg79: !air.async.token):
              %128 = "arith.constant"() <{value = 32 : index}> : () -> index
              %129 = "arith.muli"(%arg78, %128) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %130 = "arith.constant"() <{value = 32 : index}> : () -> index
              %131 = "arith.muli"(%arg78, %130) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %132 = "arith.constant"() <{value = 32 : index}> : () -> index
              %133 = "arith.muli"(%arg78, %132) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %134 = "memref.reinterpret_cast"(%111) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "X"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %135 = "arith.constant"() <{value = 0 : index}> : () -> index
              %136 = "arith.addi"(%135, %121) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %137 = "arith.constant"() <{value = 0 : index}> : () -> index
              %138 = "arith.addi"(%137, %131) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %139 = "air.dma_memcpy_nd"(%arg79, %134, %arg72, %136, %138) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 0>, orbit.storage = "X", orbit.target_copies = array<i64: 4>, orbit.transfer = "host_to_l1", orbit.transfer_event = 0 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index, index) -> !air.async.token
              %140 = "memref.reinterpret_cast"(%112) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "alloc3"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              "air.wait_all"(%arg79, %139) {orbit.computation_event = 1 : i64, orbit.phase = 0 : i64, orbit.phase_dependencies = array<i64>, orbit.public_dependencies = array<i64: 0>, orbit.read_copies = array<i64: 4>, orbit.source_instance = 0 : i64, orbit.task = "double.split.0", orbit.write_copies = array<i64: 5>} : (!air.async.token, !air.async.token) -> ()
              %141 = "arith.constant"() <{value = 0 : index}> : () -> index
              %142 = "arith.constant"() <{value = 1 : index}> : () -> index
              %143 = "arith.constant"() <{value = 64 : index}> : () -> index
              %144 = "arith.constant"() <{value = 0 : index}> : () -> index
              %145 = "arith.constant"() <{value = 32 : index}> : () -> index
              %146 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%144, %145, %146) ({
              ^bb0(%arg80: index):
                %154 = "arith.addi"(%arg80, %119) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %155 = "arith.constant"() <{value = 0 : index}> : () -> index
                %156 = "arith.constant"() <{value = 32 : index}> : () -> index
                %157 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%155, %156, %157) ({
                ^bb0(%arg81: index):
                  %158 = "arith.addi"(%arg81, %129) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %159 = "arith.subi"(%154, %121) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %160 = "arith.subi"(%158, %131) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %161 = "memref.load"(%134, %159, %160) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %162 = "arith.addf"(%161, %161) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %163 = "arith.subi"(%154, %123) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %164 = "arith.subi"(%158, %133) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%162, %140, %163, %164) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %147 = "memref.reinterpret_cast"(%112) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 0 : i64, orbit.storage = "alloc3"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %148 = "arith.constant"() <{value = 0 : index}> : () -> index
              %149 = "arith.addi"(%148, %123) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %150 = "arith.constant"() <{value = 0 : index}> : () -> index
              %151 = "arith.addi"(%150, %133) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %152 = "air.dma_memcpy_nd"(%arg79, %arg75, %149, %151, %147) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 0 : i64, orbit.source_copies = array<i64: 5>, orbit.storage = "alloc3", orbit.target_copies = array<i64: 6>, orbit.transfer = "l1_to_host", orbit.transfer_event = 2 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %153 = "air.wait_all"(%152) : (!air.async.token) -> !air.async.token
              "scf.yield"(%153) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%127) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%117) : (!air.async.token) -> ()
          "memref.dealloc"(%111) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%112) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.execution_group = 0 : i64, orbit.group_members = array<i64: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg30: index, %arg31: index, %arg32: index, %arg33: index, %arg34: memref<64x64xf32>, %arg35: memref<64x64xf32>, %arg36: memref<64x64xf32>, %arg37: memref<64x64xf32>):
      "air.segment"(%arg34, %arg35, %arg36, %arg37) ({
      ^bb0(%arg38: memref<64x64xf32>, %arg39: memref<64x64xf32>, %arg40: memref<64x64xf32>, %arg41: memref<64x64xf32>):
        %56 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%56, %56, %arg38, %arg39, %arg40, %arg41) ({
        ^bb0(%arg42: index, %arg43: index, %arg44: index, %arg45: index, %arg46: memref<64x64xf32>, %arg47: memref<64x64xf32>, %arg48: memref<64x64xf32>, %arg49: memref<64x64xf32>):
          %57 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 7 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data"} : () -> memref<1024xf32, 2 : i32>
          %58 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 6 : i64, orbit.storage_index = 3 : i64, orbit.tile_pool = "storage-3.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %59 = "air.wait_all"() : () -> !air.async.token
          %60 = "arith.constant"() <{value = 0 : index}> : () -> index
          %61 = "arith.constant"() <{value = 2 : index}> : () -> index
          %62 = "arith.constant"() <{value = 1 : index}> : () -> index
          %63 = "scf.for"(%60, %61, %62, %59) ({
          ^bb0(%arg50: index, %arg51: !air.async.token):
            %64 = "arith.constant"() <{value = 32 : index}> : () -> index
            %65 = "arith.muli"(%arg50, %64) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %66 = "arith.constant"() <{value = 32 : index}> : () -> index
            %67 = "arith.muli"(%arg50, %66) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %68 = "arith.constant"() <{value = 32 : index}> : () -> index
            %69 = "arith.muli"(%arg50, %68) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %70 = "arith.constant"() <{value = 0 : index}> : () -> index
            %71 = "arith.constant"() <{value = 2 : index}> : () -> index
            %72 = "arith.constant"() <{value = 1 : index}> : () -> index
            %73 = "scf.for"(%70, %71, %72, %arg51) ({
            ^bb0(%arg52: index, %arg53: !air.async.token):
              %74 = "arith.constant"() <{value = 32 : index}> : () -> index
              %75 = "arith.muli"(%arg52, %74) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %76 = "arith.constant"() <{value = 32 : index}> : () -> index
              %77 = "arith.muli"(%arg52, %76) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %78 = "arith.constant"() <{value = 32 : index}> : () -> index
              %79 = "arith.muli"(%arg52, %78) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %80 = "memref.reinterpret_cast"(%57) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %81 = "memref.reinterpret_cast"(%58) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "alloc3"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %82 = "arith.constant"() <{value = 0 : index}> : () -> index
              %83 = "arith.addi"(%82, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %84 = "arith.constant"() <{value = 0 : index}> : () -> index
              %85 = "arith.addi"(%84, %79) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %86 = "air.dma_memcpy_nd"(%arg53, %81, %arg49, %83, %85) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 6>, orbit.storage = "alloc3", orbit.target_copies = array<i64: 16>, orbit.transfer = "host_to_l1", orbit.transfer_event = 12 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%arg53, %86) {orbit.computation_event = 13 : i64, orbit.phase = 4 : i64, orbit.phase_dependencies = array<i64: 3>, orbit.public_dependencies = array<i64: 11, 12>, orbit.read_copies = array<i64: 16>, orbit.source_instance = 4 : i64, orbit.task = "double.split.1", orbit.write_copies = array<i64: 17>} : (!air.async.token, !air.async.token) -> ()
              %87 = "arith.constant"() <{value = 0 : index}> : () -> index
              %88 = "arith.constant"() <{value = 1 : index}> : () -> index
              %89 = "arith.constant"() <{value = 64 : index}> : () -> index
              %90 = "arith.constant"() <{value = 0 : index}> : () -> index
              %91 = "arith.constant"() <{value = 32 : index}> : () -> index
              %92 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%90, %91, %92) ({
              ^bb0(%arg54: index):
                %100 = "arith.addi"(%arg54, %65) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %101 = "arith.constant"() <{value = 0 : index}> : () -> index
                %102 = "arith.constant"() <{value = 32 : index}> : () -> index
                %103 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%101, %102, %103) ({
                ^bb0(%arg55: index):
                  %104 = "arith.addi"(%arg55, %75) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %105 = "arith.subi"(%100, %69) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %106 = "arith.subi"(%104, %79) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %107 = "memref.load"(%81, %105, %106) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %108 = "arith.subi"(%100, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %109 = "arith.subi"(%104, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%107, %80, %108, %109) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %93 = "memref.reinterpret_cast"(%57) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 4 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %94 = "arith.constant"() <{value = 0 : index}> : () -> index
              %95 = "arith.addi"(%94, %67) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %96 = "arith.constant"() <{value = 0 : index}> : () -> index
              %97 = "arith.addi"(%96, %77) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %98 = "air.dma_memcpy_nd"(%arg53, %arg48, %95, %97, %93) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 4 : i64, orbit.source_copies = array<i64: 17>, orbit.storage = "T", orbit.target_copies = array<i64: 18>, orbit.transfer = "l1_to_host", orbit.transfer_event = 14 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %99 = "air.wait_all"(%98) : (!air.async.token) -> !air.async.token
              "scf.yield"(%99) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%73) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%63) : (!air.async.token) -> ()
          "memref.dealloc"(%57) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%58) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.execution_group = 1 : i64, orbit.group_members = array<i64: 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd_4"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_4"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_4"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "air.launch"(%0, %0, %arg0, %arg1, %arg2, %arg3) ({
    ^bb0(%arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: memref<64x64xf32>, %arg9: memref<64x64xf32>, %arg10: memref<64x64xf32>, %arg11: memref<64x64xf32>):
      "air.segment"(%arg8, %arg9, %arg10, %arg11) ({
      ^bb0(%arg12: memref<64x64xf32>, %arg13: memref<64x64xf32>, %arg14: memref<64x64xf32>, %arg15: memref<64x64xf32>):
        %1 = "arith.constant"() <{value = 1 : index}> : () -> index
        "air.herd"(%1, %1, %arg12, %arg13, %arg14, %arg15) ({
        ^bb0(%arg16: index, %arg17: index, %arg18: index, %arg19: index, %arg20: memref<64x64xf32>, %arg21: memref<64x64xf32>, %arg22: memref<64x64xf32>, %arg23: memref<64x64xf32>):
          %2 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 9 : i64, orbit.storage_index = 1 : i64, orbit.tile_pool = "storage-1.data"} : () -> memref<1024xf32, 2 : i32>
          %3 = "memref.alloc"() <{operandSegmentSizes = array<i32: 0, 0>}> {orbit.allocation = 8 : i64, orbit.storage_index = 2 : i64, orbit.tile_pool = "storage-2.data.input.32.32.loops.32.32"} : () -> memref<1024xf32, 2 : i32>
          %4 = "air.wait_all"() : () -> !air.async.token
          %5 = "arith.constant"() <{value = 0 : index}> : () -> index
          %6 = "arith.constant"() <{value = 2 : index}> : () -> index
          %7 = "arith.constant"() <{value = 1 : index}> : () -> index
          %8 = "scf.for"(%5, %6, %7, %4) ({
          ^bb0(%arg24: index, %arg25: !air.async.token):
            %9 = "arith.constant"() <{value = 32 : index}> : () -> index
            %10 = "arith.muli"(%arg24, %9) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %11 = "arith.constant"() <{value = 32 : index}> : () -> index
            %12 = "arith.muli"(%arg24, %11) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %13 = "arith.constant"() <{value = 32 : index}> : () -> index
            %14 = "arith.muli"(%arg24, %13) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
            %15 = "arith.constant"() <{value = 0 : index}> : () -> index
            %16 = "arith.constant"() <{value = 2 : index}> : () -> index
            %17 = "arith.constant"() <{value = 1 : index}> : () -> index
            %18 = "scf.for"(%15, %16, %17, %arg25) ({
            ^bb0(%arg26: index, %arg27: !air.async.token):
              %19 = "arith.constant"() <{value = 32 : index}> : () -> index
              %20 = "arith.muli"(%arg26, %19) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %21 = "arith.constant"() <{value = 32 : index}> : () -> index
              %22 = "arith.muli"(%arg26, %21) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %23 = "arith.constant"() <{value = 32 : index}> : () -> index
              %24 = "arith.muli"(%arg26, %23) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %25 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %26 = "memref.reinterpret_cast"(%3) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "T"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %27 = "arith.constant"() <{value = 0 : index}> : () -> index
              %28 = "arith.addi"(%27, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %29 = "arith.constant"() <{value = 0 : index}> : () -> index
              %30 = "arith.addi"(%29, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %31 = "air.dma_memcpy_nd"(%arg27, %26, %arg22, %28, %30) {operandSegmentSizes = array<i32: 1, 1, 0, 0, 0, 1, 2, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 18>, orbit.storage = "T", orbit.target_copies = array<i64: 28>, orbit.transfer = "host_to_l1", orbit.transfer_event = 24 : i64, static_dst_offsets = array<i64: 0, 0>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 32, 1>, static_src_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 64, 1>} : (!air.async.token, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, memref<64x64xf32>, index, index) -> !air.async.token
              "air.wait_all"(%arg27, %31) {orbit.computation_event = 25 : i64, orbit.phase = 8 : i64, orbit.phase_dependencies = array<i64: 7>, orbit.public_dependencies = array<i64: 23, 24>, orbit.read_copies = array<i64: 28>, orbit.source_instance = 8 : i64, orbit.task = "square", orbit.write_copies = array<i64: 29>} : (!air.async.token, !air.async.token) -> ()
              %32 = "arith.constant"() <{value = 0 : index}> : () -> index
              %33 = "arith.constant"() <{value = 1 : index}> : () -> index
              %34 = "arith.constant"() <{value = 64 : index}> : () -> index
              %35 = "arith.constant"() <{value = 0 : index}> : () -> index
              %36 = "arith.constant"() <{value = 32 : index}> : () -> index
              %37 = "arith.constant"() <{value = 1 : index}> : () -> index
              "scf.for"(%35, %36, %37) ({
              ^bb0(%arg28: index):
                %45 = "arith.addi"(%arg28, %10) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                %46 = "arith.constant"() <{value = 0 : index}> : () -> index
                %47 = "arith.constant"() <{value = 32 : index}> : () -> index
                %48 = "arith.constant"() <{value = 1 : index}> : () -> index
                "scf.for"(%46, %47, %48) ({
                ^bb0(%arg29: index):
                  %49 = "arith.addi"(%arg29, %20) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %50 = "arith.subi"(%45, %14) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %51 = "arith.subi"(%49, %24) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %52 = "memref.load"(%26, %50, %51) <{nontemporal = false}> : (memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> f32
                  %53 = "arith.mulf"(%52, %52) <{fastmath = #arith.fastmath<none>}> : (f32, f32) -> f32
                  %54 = "arith.subi"(%45, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  %55 = "arith.subi"(%49, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
                  "memref.store"(%53, %25, %54, %55) <{nontemporal = false}> : (f32, memref<32x32xf32, strided<[32, 1]>, 2 : i32>, index, index) -> ()
                  "scf.yield"() : () -> ()
                }) : (index, index, index) -> ()
                "scf.yield"() : () -> ()
              }) : (index, index, index) -> ()
              %38 = "memref.reinterpret_cast"(%2) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 0>, static_sizes = array<i64: 32, 32>, static_strides = array<i64: 32, 1>}> {orbit.phase = 8 : i64, orbit.storage = "Y"} : (memref<1024xf32, 2 : i32>) -> memref<32x32xf32, strided<[32, 1]>, 2 : i32>
              %39 = "arith.constant"() <{value = 0 : index}> : () -> index
              %40 = "arith.addi"(%39, %12) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %41 = "arith.constant"() <{value = 0 : index}> : () -> index
              %42 = "arith.addi"(%41, %22) <{overflowFlags = #arith.overflow<none>}> : (index, index) -> index
              %43 = "air.dma_memcpy_nd"(%arg27, %arg21, %40, %42, %38) {operandSegmentSizes = array<i32: 1, 1, 2, 0, 0, 1, 0, 0, 0>, orbit.phase = 8 : i64, orbit.source_copies = array<i64: 29>, orbit.storage = "Y", orbit.target_copies = array<i64: 30>, orbit.transfer = "l1_to_host", orbit.transfer_event = 26 : i64, static_dst_offsets = array<i64: -9223372036854775808, -9223372036854775808>, static_dst_sizes = array<i64: 32, 32>, static_dst_strides = array<i64: 64, 1>, static_src_offsets = array<i64: 0, 0>, static_src_sizes = array<i64: 32, 32>, static_src_strides = array<i64: 32, 1>} : (!air.async.token, memref<64x64xf32>, index, index, memref<32x32xf32, strided<[32, 1]>, 2 : i32>) -> !air.async.token
              %44 = "air.wait_all"(%43) : (!air.async.token) -> !air.async.token
              "scf.yield"(%44) : (!air.async.token) -> ()
            }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
            "scf.yield"(%18) : (!air.async.token) -> ()
          }) {orbit.compressed_phases = 2 : i64} : (index, index, index, !air.async.token) -> !air.async.token
          "air.wait_all"(%8) : (!air.async.token) -> ()
          "memref.dealloc"(%2) : (memref<1024xf32, 2 : i32>) -> ()
          "memref.dealloc"(%3) : (memref<1024xf32, 2 : i32>) -> ()
          "air.herd_terminator"() : () -> ()
        }) {operandSegmentSizes = array<i32: 0, 2, 4>, orbit.execution_group = 2 : i64, orbit.group_members = array<i64: 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35>, orbit.mapping_strategy = "serial-tiled", orbit.spatial_owner = "npu.tile(0,2)", sym_name = "orbit_herd_8"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
        "air.segment_terminator"() : () -> ()
      }) {operandSegmentSizes = array<i32: 0, 0, 4>, sym_name = "orbit_segment_8"} : (memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
      "air.launch_terminator"() : () -> ()
    }) {operandSegmentSizes = array<i32: 0, 2, 4>, sym_name = "orbit_launch_8"} : (index, index, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>, memref<64x64xf32>) -> ()
    "func.return"() : () -> ()
  }) : () -> ()
}) {orbit.cost_status = "uncalibrated-direct-air", orbit.data_organization = "phase-local", orbit.data_organization_realization = "phase-local", orbit.data_organization_scope = "checked execution-group local allocations and copy users; no cross-group SRAM retention", orbit.graph_schedule_realization = "common execution groups and explicit copy/release dependencies; source compute order preserved; conservative timing reservations are separate from runtime arbitration", orbit.mapping_plan = "5377eec12ac8c1afcd57b736d58a95b4048975b63f159ccb793bc446986a6390", orbit.program_graph = "a068661e338dc6b3ad2e120bde38a360a317aaecb20b9113816b91189cd98513", orbit.source_fingerprint = "eeb420b6855a57cbbb44fa58deea0b869092c9081f75a0c52293bda2c8361570"} : () -> ()

