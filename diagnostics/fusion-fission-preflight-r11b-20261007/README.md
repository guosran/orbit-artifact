# R11b fusion/fission preflight

This receipt records the accepted preflight gates and frozen launch binding for the R11b input-0 fusion/fission cohort. The full six-workload, five-stage run is **running**; this package makes no claim about its eventual candidates, scores, native cycles, or completion.

The machine-readable inventory is [summary.json](summary.json). Paths inside it point to the local acceptance records and frozen runtime used for this run. They document provenance and are not portable runtime bindings.

## Accepted gates

| Gate | Accepted evidence |
| --- | --- |
| C++ source proof and replay checks | 25/25 checks passed, including expected negative rejections. `/tmp/orbit-r11b-source-proof-acceptance-20261007/summary.json` |
| Strict native model-cache contract | 216 entries match exactly; cache bytes match exactly; II20 and II23 round trips, over-bound/mixed-YAML rejection checks, and printer-invariance check passed. `/tmp/orbit-r11b-native-cache-acceptance-20261007/summary.json` |
| Source-owned canonical lowering and cut census | Six workloads lowered to byte-identical canonicals and all census commands exited successfully. Legal actions were LU 1, Harris 30, Raytracing 56, GCN 0, LLaMA 0, Radar 0. `/tmp/orbit-r11b-source-owned-cohort-proofs-20261007/summary.json` |
| Targeted native controls | Both 1x2 and 2x1 control runs completed without changing the main-curve budget or claiming a search winner. `/tmp/orbit-r11b-controlled-fusion-fission-{1x2,2x1}-20261007/run.json` |
| Common AMOEBA Ray check | Native replay accepted. `/tmp/orbit-r11-common-amoeba-ray-native-20261007/raytracing/result.json` |
| Frozen prelaunch binding | Targeted controls and source gates accepted before launch. `/tmp/orbit-input0-fusion-fission-r11b-20261007/prelaunch-acceptance.json` |

## Bound mode and resource contract

The cohort fixes input 0 with compile-time-proven static bounds and starts all six workloads together: LU, Harris, Raytracing, GCN, LLaMA, and Radar. It uses five independent stages, each bounded to four rounds, 4,096 unique candidates, beam width 16, diversity 4, and native top five. Identity and prior-winner controls are outside top-k. Fusion and fission are part of the ablation; legality, transformation/materialization, candidate enumeration, global ranking, and production placement/temporal/communication scoring are compiler-side C++ work. Python is limited to orchestration, tests, and record rendering.

The physical target is 16 CGRAs and 64 PEs (a 4x4 grid of 2x2-PE CGRAs), with context memory 6 and control memory 20. The model namespace is the fresh four-member per-CGRA 2x2 ensemble. Model weights use the II20 contract; Raytracing's separately bound runtime diagnostic uses II23. The cohort uses an explicit common 4x4 mesh with 1-cycle links and 32 bits/cycle. These are prelaunch bindings, not measured full-run results.

## Source and pin provenance

The bound source namespace is `4547a3853452438af0a74f20342b4bc182cc9107`; the actual build snapshot is `2dd2bb327269eaff23e5dc8cdff11d968b0dda15`. The acceptance record confirms exact byte equality for all 140 source files (4,931,433 UTF-8 bytes in the recorded source snapshot). The source-namespace difference is checker-only; no implementation-file bytes changed.

The immutable R11b optimizer is 525,213,552 bytes, built with one compile/link job and detached from the build output. The pin acceptance record confirms its full binary stream exactly matches the original R11 pin. The archived R11 main pin was byte-verified against its complete decompressed stream; this work did not decompress or rebuild it. The active full R11b executable is already present in the frozen runtime at the path recorded in [summary.json](summary.json).

The first R11 build attempt is retained as a separate historical failure (`compile-failed-no-pin-produced` at source commit `94becdc5358db33b6738c6e5f18bf6cbfa93aa50`). It is excluded from every accepted check count and is not the R11b binary used by the frozen runtime.

No SHA-256 or other digest is used in this receipt. Identity statements refer to the cited acceptance records' exact byte comparisons.
