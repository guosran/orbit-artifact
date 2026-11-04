# Fresh r3 static review

The r2 timeout and earlier needs_review artifacts are preserved. This review binds only the r3 package named in summary.json.

The compiler-only suite passed nine checks under the frozen r3 compiler. Its deliberately distinct i/j/k domains detect the old axis confusion. The actual M1 package was checked separately: its scalar A load has local indices (i,k), B vector read has (k,j), and C vector read/write have (i,j), after simplifying the emitted global-IV additions and region-offset subtraction. Thus the stale tile offset terms that survived in r2 are absent.

Final optimized LLVM has local K `%21` initialized to zero, incremented by one (`%72`), ending at64. `%22 : <8 x float>` receives `%71` on that same backedge. Eight scalar __mulsf3 calls use A[k] and the eight consecutive B[k,j+lane] elements; insertions preserve lane0..7. Bitcasts and shuffle masks feed the native target add intrinsic with the same accumulator lane and return its corresponding low lane to `%71`. The tool follows those masks rather than simply searching an intrinsic name. Three negative LLVM mutations (lane swap, changed target config, broken phi recurrence) are rejected by this recognizer.

The enclosing reduction-tile induction `%16` advances by one for32 tiles, so source K is64*tile+k in increasing order. The spatial `%17` advances by8 through64 columns. M is1. The preserved actual AIR retains C across the reduction tile scope and initializes it once per output region.

Complete ELF text→PDI→program byte inclusion and compile-record SHA checks pass. The __mulsf3 linked load address differs from baseline, but all branch-relative instructions match. Its integer __muldi3 callee matches baseline byte-for-byte. The tool still reports needs_review rather than pretending the linked helper bytes are identical.

This is sufficient static evidence for a small numerical NPU diagnostic with the original FP32 contract. It is not proof of floating-point mode equivalence, an accepted optimization, measured SIMD utilization, traffic, or speedup. No build or NPU execution was performed for this review.
