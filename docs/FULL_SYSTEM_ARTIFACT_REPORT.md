# ORBIT full-system artifact report

**ORBIT FULL-SYSTEM ARTIFACT PARTIAL.** Semantic computation completed but its frozen validator failed. The other backend modules have only fixture-level or pending evidence; none is promoted to full-system GO.

| Module | Verdict | Generated result |
|---|---|---|
| semantic | NO-GO | results/2026-09-28T193254+0800-semantic |
| resource | PARTIAL | results/2026-09-28T193440+0800-resource |
| spatial | PARTIAL | results/2026-09-28T193440+0800-spatial |
| temporal | PARTIAL | results/2026-09-28T193441+0800-temporal |
| cost | PARTIAL | results/2026-09-28T193440+0800-cost |
| replay | PENDING | none |
| paper | PENDING | none |

## Current source-backed and fixture evidence

- Shape: 8 source C++ rectangular candidates on a 4×4 **physical CGRA** fabric (16 total), with a separately declared four-CGRA per-task cap. Replica enumeration is absent from the pinned source.
- Spatial: 2 placed tasks and one canonical channel transfer of 32 bits with 1 link reservation. Tensor-wide, tile-local and halo route matrices are pending.
- Temporal: resource-release fixture makespan 1000005 cycles. The fixed/critical/pipeline/beam/exact activity-policy matrix is unavailable at the pinned source.
- Cost: 9 candidate shape fixture scores, selected `candidate-4`, using a declared analytical estimate; source production score pass was not run because its file-binding protocol conflicts with this artifact.
- Native replay: pending. Pinned mapper replay requires score/trace file bindings and has no current no-binding selected-candidate path.
- Paper: only semantic and fixture Markdown tables can currently be generated. Matched native baselines, performance tables and plots are pending.

The harness ran 40 tests with 0 failures and 0 errors. Existing CNN/GPT-2/FFT results use an earlier dirty source/provisional protocol and remain historical or diagnostic; they do not enter current paper comparisons. No full-workload, RTL, systolic, or blocked-GEMM long run was started. See `RESULT_COMPARABILITY.md` and `LONG_RUN_STATUS.md`.

RTL simulation is optional and is not a final artifact gate. Native mapper replay and matched current-protocol baselines remain required.

For full-system GO, resolve the frozen semantic attempt-count conflict, implement/reproduce replica-aware resource candidates and the activity scheduler policy matrix, remove the native replay file-binding conflict through a reviewed source protocol, run matched current-protocol baselines and selected native replay, and generate every paper table and plot from complete results. The public artifact repository and tag are separate publication checks and do not substitute for these gates.
