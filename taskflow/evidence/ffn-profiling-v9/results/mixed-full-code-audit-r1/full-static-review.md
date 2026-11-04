# M8 complete mixed package static review

The package is `mixed-full-r1/m8`, compiled with frozen taskflow-opt-v9-final-r1. The summary binds the exact AIR and program ELF. All four core .text payloads occur completely inside their PDIs, and the complete PDIs occur inside this program ELF.

All three GEMM update tasks select eight-lane scalar-product/vector-add; their initializer tasks and activation remain scalar. Twelve actual memory access checks establish A(i,k), B(k,j), C(i,j) after emitted shifts and region-offset subtraction. Two distinct final optimized GEMM LLVM bodies implement Gate/Up (identical arithmetic code) and Down. Both have `%32` local K phi incremented by one to64 and `%33 : <8 x float>` backedge `%83`; low-lane bitcast/shuffle provenance proves no output-lane permutation around the native add intrinsic. Gate/Up reduction-tile phi advances through32 tiles, Down through172, giving increasing source K=64*tile+k. The source M loop is8, independent N lanes advance by8. Actual helpers are scalar; no final vector FP32 multiply/divide, floating FMA, or BF16 path is detected.

Activation core .text is byte-for-byte identical to the accepted scalar M8 baseline. This is stronger than merely observing scalar coverage metadata: its existing explicit exp approximation and scalar helper route are unchanged in the executed-code payload.

The saved strict linker audit binds this ELF and records four sequential stages on compute tile(0,2), maximum tensor payload20480B, zero extra tensor payload versus plan, and4096B reserved stack. Payload is not a measurement of stack high-water or register spills. Native ISA static vadd sites and helper instruction counts are not measurements of SIMD utilization, time share, cycles or DDR traffic.

This static package is ready for numerical full-program validation. No full-FFN numerical result or speedup is asserted here. Different linked helper load addresses remain default needs_review in the generic verifier; branch-relative __mulsf3 instructions agree with baseline and the integer __muldi3 callee is exact byte-equivalent. The scalar activation helper bytes and complete text are exact matches.
