module {
  aie.device(npu2) @orbit_segment {
    %tile = aie.tile(0, 2)
    %buf0 = aie.buffer(%tile) {sym_name = "buf0"} : memref<1xf32, 2 : i32>
    %mem = aie.mem(%tile) {
      %0 = aie.dma_start(S2MM, 1, ^bb0, ^bb1)
    ^bb0:
      aie.dma_bd(%buf0 : memref<1xf32, 2 : i32> offset = 0 len = 1)
      aie.next_bd ^bb0
    ^bb1:
      aie.end
    }
    %core = aie.core(%tile) {
      %view = memref.reinterpret_cast %buf0 to offset: [0], sizes: [1], strides: [1] {orbit.storage = "A"} : memref<1xf32, 2> to memref<1xf32, 2>
      // } fake device close; memref.reinterpret_cast %buf0 orbit.storage = "BAD"
      /* { outer /* } nested */ memref.reinterpret_cast %buf0 orbit.storage = "BAD" */
      "test.note"() {message = "brace } escaped \" then { aie.device(npu2) @fake {"} : () -> ()
      %conflict = memref.reinterpret_cast %buf0 to offset: [0] {orbit.storage = "B"}
      aie.end
    }
  }
  func.func @host() {
    %host0 = memref.reinterpret_cast %results to offset: [0] {orbit.storage = "A"}
    %host1 = memref.reinterpret_cast %results to offset: [0] {orbit.storage = "Y"}
  }
}
