# Frozen FFN code and the first mixed-FP32 experiment

For subsequent full-program numerical acceptance and measurements, see the
[final v9 report](taskflow-ffn-profiling-v9.md). This note retains the initial
experiment's chronology, static proof boundaries and preserved failures.

This note separates static observations of the accepted M128 package from the new, initially unvalidated implementation candidate. The underlying model, compiler runtime and installed packages are unchanged. No static instruction count below is a measured cycle profile or DDR count.

## Current executed code

The evidence is `results/taskflow/orbit-direct-air-v7/ffn-m128-partition-long-r1`. It contains sixteen complete extent-8 commands and three passing full M128 seeds. Its executed ELF SHA256 is `43cf768bb42cbe8fcec0166efbfc8b7f80640988a9f74a03694da369183dc71b`. The archived compiler is `3e041bf53ebb3747e347b251dfc431af1a9f7ea95c6cf9ec74dd613fba68945c`; the extent-8 AIR hash is `c6834f8414f4390df7c1be23246590d91689c9303e251748715b65ac0294be81`.

The read-only preflight in `.work/ffn-profiling-preflight/code` verifies source/AIR/plan/ABI hashes and the ELF hash. It further checks each complete compute-core `.text` byte-for-byte inside its PDI and each complete PDI inside the executed ELF. The disassembly therefore belongs to this accepted package, rather than to an earlier failing experiment. `verify_frozen_code.py`, `package-code-binding.json`, `static-loop-counts.json`, the four disassemblies and their tool/command identities preserve the check.

The final runtime sequence configures Gate, Up, activation, and Down in that order. Each configuration uses the same single physical compute tile `(0,2)`, a 1x1 herd and separate stage-local pools. Four configurations do not imply four parallel cores. Reserved stack is 4096 bytes; maximum tensor payload is 20480 bytes. The declarations of eight memtiles are not proof of eight active compute cores or active L2 staging.

| M8 stage | FP32 multiply operations per complete stream | Add operations | Actual selected arithmetic |
|---|---:|---:|---|
| Gate | 180355072 | 180355072 | scalar `__mulsf3`, native `vadd.f` |
| Up | 180355072 | 180355072 | scalar `__mulsf3`, native `vadd.f` |
| Activation | 1056768 | 968704 | scalar multiply/divide helpers, native adds, selected f32 exp approximation |
| Down | 180355072 | 180355072 | scalar `__mulsf3`, native `vadd.f` |

Each GEMM's innermost K loop is unrolled by four and has four static `__mulsf3` call sites. No `__addsf3` symbol/call is present in these actual core ELFs. Scalar FP32 adds are implemented using vector-register lane insertion, `vadd.f`, and scalar extraction. There is no independent-output SIMD in the optimized scalar LLVM. The GEMM total is 541065216 multiply-helper calls per completed M8 stream, hence 8657043456 for M128's sixteen commands. These are static multiplicities from saved loop bounds; helper branch costs, instruction stalls and time shares are unmeasured. The LLVM already promotes the C accumulator through inner K, so merely proposing to remove an inner C load/store would overlook an existing downstream optimization.

The source-to-LLVM path preserves separate f32 multiply/add and K ordering, without FMA, global fast math or BF16 emulation. Activation still uses the existing explicitly selected polynomial exp approximation. This establishes the FP32 route and arithmetic structure; it does not replace numerical acceptance or prove bit-exact behavior for every exceptional input.

## Selected first experiment: scalar products with vector adds

The agreed implementation name is `scalar-product-vector-add-f32`. It reuses `GenericTaskImplementation` and the existing source-derived independent-lane proof; it is not a new operator recognizer or independent cost model. The original `independent-lane-f32` choice continues to report unsupported strict vector multiplication.

The initial capability is deliberately finite:

- Static affine loops and f32 storage, direct contiguous last-dimension spatial projection or invariant reads, with independently proved disjoint output lanes.
- The abstract mapping proof accepts four or eight lanes, but the current installed AIR target accepts only eight: four-lane compilation failed Peano register legalization (`G_IMPLICIT_DEF <2 x s64>`) and now reports unavailable. Every actual spatial tile span must be divisible by eight. Partial-lane tails fail closed.
- The selected spatial loop is widened; the source K loop, per-lane update ordering and accumulation tree are unchanged.
- After the standard affine vectorizer, vector f32 multiply/divide is expanded into scalar lane operations and reassembled. Add/subtract stays vector. Unsupported remaining vector operations and nonzero fast-math flags are rejected.
- Scalar multiply/divide uses external scalar `__mulsf3`/`__divsf3` declarations supplied by the existing target compiler-rt, the same operations selected by the current scalar target. This is not a new runtime. Calls prevent LLVM SLP from recreating the unsupported vector multiply; explicit scalar division also avoids a vector reciprocal-multiply legalization with different rounding. Builtins are marked no-program-memory/nounwind and noinline to preserve accumulator promotion and scalar call boundaries.
- Source tasks containing `math` operations remain explicitly scalar in task coverage. In FFN this keeps activation on its existing scalar approximation route; pure initializers also remain scalar. This first candidate makes no claim to vectorize the entire FFN.

The existing generic emitter clones the actual source body and applies this implementation legalization afterward. Pool allocation, public copy/version bindings, tile DMA regions, retention and stage sequencing continue to consume the checked plan. Scalar helper symbols/calls and the implementation choice are included in canonical AIR checking. A symbol collision fails rather than binding arbitrary user code.

Expected benefit is conditional: the multiplication helper count is unchanged. The candidate may amortize scalar lane moves/adds and improve contiguous access across independent outputs; packing, extra register pressure or calls may instead erase that benefit. The existing source-operation sensitivity model cannot predict such an implementation speedup. No scalar empirical coefficient should be silently relabeled as calibrated mixed-vector cost.

## Validation gates

1. Compiler-only tests generate eight-lane AIR and explicitly reject the unsupported four-lane target, require scalar multiply/divide calls and vector adds, reject unsupported tails/flags, preserve the old unsupported vector-multiply diagnostic, and reject helper substitution under the same plan identity. Standard installed AIR dependency verification is optional in this test. This stage does not execute an ELF.
2. Fresh installed `aircc` compilation must succeed. Inspect its final LLVM/core ELF, not only canonical AIR: no f32 vector multiply/divide, FMA or BF16; scalar helpers still present; meaningful multiple-lane add computation; K dependency retained; no unexpected stack/local-memory growth beyond separately audited bounds. Compilation failure remains a rejected capability; no installed package patch or verifier bypass is permitted.
3. Run small complete-main GEMM and changed-arithmetic/division sources against independent references under the established FP32 contract, then M1 complete FFN versus the frozen scalar route. Include multiple seeds and all output elements. Do not use the previously unreliable standalone subkernel dispatch route.
4. Measure paired complete programs with explicit compiler/ELF identities. Only after numerical and resource checks may M8 and the sixteen-command M128 schedule be evaluated. A successful small GEMM or a vector instruction in the ELF is not a whole-FFN speedup claim.

## Why genuine two-core mapping is a separate change

A two-core candidate is plausible because the current accepted computation uses one core, but it needs explicit public resource and schedule decisions. The plan must partition actual source output instances, prove complete disjoint coverage and preserve each output's reduction order, assign per-core memory/pools and DMA resources, and express joins before consumers. Current channel/FIFO keys and port allocations are stage/storage/direction oriented; simultaneous cores require a checked endpoint/placement dimension and routing audit. Capacity must be checked per physical core with separate stacks, and shared system-memory traffic cannot be assumed free.

Simply changing a herd from 1x1 to 1x2 would duplicate work unless induction ranges, DMA offsets, output coverage and events are distributed too. Running two host commands concurrently also does not establish physical core parallelism. The smallest useful two-core gate would be one independently partitioned GEMM in a complete main, followed by the four-stage program. This is a larger public mapping/codegen extension than the selected mixed-arithmetic legalization and is not included in its first implementation.

## Separate correctness gate discovered by profiling controls

The frozen scalar control compiler `c9ad0b198d8ca3b7cc6c5a5d7777ad3283a06f87eea3f7789492b8d2d56542ce` produced incorrect grouped M32x64 add/multiply results. These are separate from both accepted v7 FFN and the new mixed candidate. The r2 grouped source has a single perfect i/j nest; its source, region offsets and final core-local indexing are consistent. It must not be diagnosed as the earlier multiple-top-level-loop fixture.

Saved-output analysis of three seeds × twelve repeats × two outputs × two operations gives 144 unchanged source-reference failures. Multiply outputs exactly match a post-hoc stream-concatenation alternative: Y chunks use A0*A1, B0*B1, D0*D1, E0*E1; Z chunks use A2*A3, B2*B3, D2*D3, E2*E3. Add follows the same alternative within 1.1920928955078125e-7. Runtime IR sends complete BO-major producers into a compute S2MM chain cycling four local storage slots. This is strong evidence of a repeated stream-identity/ordering problem; no captured packet trace proves its hardware cause.

The immediate backend response is fail-closed for repeated serial-tiled stages with more than two distinct actual incoming or outgoing storage streams. Single-phase and whole-graph resident paths retain their established scope. This is a current target-validation capability limit, not a source arithmetic change or silicon claim. The public evaluator must share the limit so an unavailable candidate is not ranked as executable. Failed candidates are excluded from profiling model fitting. A later packed-two-input fixture is an independent candidate, not a numerical repair of this four-input source.

Full copied IR, raw array identities and the reproducible diagnostic are in `.work/ffn-profiling-preflight/control-failure-r1`. The Core compiler-only `stream_capacity_v9.py` checks rejected repeated four-input/three-output schedules and preserved two-input/two-output, single-phase and resident paths; target execution remains a separate validation gate.


## Mixed implementation diagnosis and current evidence

The first namespace fix addressed MLIR symbol lookup, not arithmetic: unregistered one-region AIR operations conservatively stop lookup before module-level `__mulsf3`. A namespace-only AIR facade allows ordinary function-symbol verification; the installed AIR toolchain still verifies actual AIR operations. Helper declarations belong only to the generated output module.

The r2 M1 Gate package then compiled at eight lanes but genuinely hit the NPU watchdog. Its loop bounds and offsets were wrong: GenericAnalysis records source loops in PreOrder, whereas the vector emitter originally collected them with default PostOrder. Applying i/j/k bounds and global shifts by those inconsistent indices exchanged axes. This was not evidence that the upstream vectorizer intentionally reordered a valid reduction. The correction uses PreOrder plus unique source-loop locations, checks a source-index bijection and unchanged bounds/steps after vectorization, then applies each shift by that source identity. The compiler-only test now checks actual address SSA, including cancellation of global shifts against region offsets; it rejects the preserved r2 wrong-axis AIR. The r2 package, needs_review result and real timeout remain preserved.

Fresh r3 compiler-only checks passed nine cases, including actual A(i,k), B(k,j), C(i,j), multiple ordered K tiles, unsupported four-lane/tail/fastmath cases and helper substitution. Static M1 review found a true eight-lane accumulator phi, one unit K advance per recurrence and unchanged lane order through the target add intrinsic's bitcasts/shuffles. The helper review explains changed linked addresses rather than claiming identical linked bytes: all `__mulsf3` branch-relative instructions agree, and its `__muldi3` callee is byte-identical. The generic verifier retains needs_review for the nonidentical linked helper bytes.

The main experiment driver subsequently ran the M1 Gate control and mixed route in interleaved order for three seeds: all18 complete outputs passed the unchanged numerical contract. Reported hot medians are approximately1539ms scalar and1425ms mixed, about7.4% lower for this Gate case. This observation belongs to that small Gate experiment; it is not a full-FFN or M128 speedup. The scalar multiply-helper count is unchanged.

The next complete M8 package, `results/taskflow/ffn-profiling-v9/mixed-full-r1/m8`, was statically reviewed in `mixed-full-code-audit-r1`. Twelve actual source-address checks cover all three GEMMs. Gate and Up use32 reduction tiles of64; Down uses172 tiles of64. Local K and the tile index advance by one, with source K=64*tile+k. Final optimized LLVM has an eight-lane phi and corresponding low-lane vector add recurrence; no FP32 vector multiply/divide, floating FMA or BF16 path is detected. Activation remains explicitly scalar and its complete core `.text` is byte-identical to the accepted scalar M8 baseline.

All four M8 core texts bind to their PDIs and complete program ELF. The saved strict linker audit binds that ELF, reports four serial stages on physical compute(0,2), maximum tensor payload20480B, zero extra tensor payload versus the checked plan and4096B reserved stack. These are static allocation facts, not stack high-water or DDR measurements. At this review checkpoint M1/M5/M8 full packages have compiled; this note does not report unobserved full-FFN numerical acceptance or timing.
