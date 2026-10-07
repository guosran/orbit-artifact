# Fusion/fission comparison: results and status

**Current status (2026-10-07): the fresh six-workload, five-stage R10c cohort has not started.** The launch is waiting on a valid retained-fusion fact rejection being fixed and pinned. There are no fresh S1–S5 performance results to report yet. The renderer therefore labels all 30 fresh cells pending; it does not carry old R9 values forward as new results.

The comparison is whole-program scheduled cycles, with lower values better. R9 is a separate, completed historical cohort. Fixed 1×1 and common-DFG AMOEBA are independently gated reference records.

| Workload | Fixed 1×1 | Common AMOEBA | R9 S1 | R9 S2 | R9 S3 | R9 S4 | R9 S5 | Fresh S1 | Fresh S2 | Fresh S3 | Fresh S4 | Fresh S5 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| LLaMA | 1,129,656,837 | 757,412,371 | 762,655,252 | 595,551,249 | 424,250,388 | 424,250,388 | 424,250,388 | pending | pending | pending | pending | pending |
| LU | 18,501 | 9,811 | 11,347 | 9,486 | 9,486 | 9,486 | 9,486 | pending | pending | pending | pending | pending |
| Harris | 988,258 | 926,769 | 941,012 | 899,620 | 621,600 | 621,600 | 621,600 | pending | pending | pending | pending | pending |
| Radar | 1,317,811 | 1,317,811 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | pending | pending | pending | pending | pending |
| GCN | 95,775 | 83,802 | 89,388 | 86,987 | 86,987 | 86,987 | 86,987 | pending | pending | pending | pending | pending |
| Original Ray | N/A¹ | pending² | 176,711 | 176,711 | 176,711 | 176,711 | 176,711 | pending | pending | pending | pending | pending |

¹ Fixed 1×1 Ray is not applicable: the compiler-proved Task 13 unit-CGRA model lower bound is II 83, above the diagnostic runtime ceiling II 23. The baseline mapper was not run. This is not a failed mapping result. ² The common-DFG AMOEBA Ray record has not been supplied. Its cell stays pending.

The R9 public summary and all 30 stage receipts report native top-five replay, numeric pass, independent trace pass, and independent stage initialization. In that historical cohort S4 and S5 match S3 for all six workloads. This is an observed outcome, not proof that fusion or fission is ineffective or that the search found every useful candidate. R9 used a different pinned runtime and remains separate from the pending R10c cohort.

R9's receipt defines its reported stage-cycle source as the minimum whole-program native cycles across measured top-five candidates and controls. The audit retains native top five, controls, and the final `previous-winner.jsonl` selection as separate evidence; the table above does not relabel the stage-cycle minimum as the selected winner.

## What the R9 funnel evidence says

The corrected typed-path audit finds **zero fusion candidates in the saved native global top five** for every R9 S4/S5 workload. Harris has producer-consumer co-tiling in 5/5 top-five candidates in both stages; its typed primitive kind is `tile`, so it is not fusion. The audit classifies by typed primitive kinds and dedicated action families, not by a family-name substring.

The R9 S5 source census reports 30 legal Harris cuts, one LU cut, and 56 original-Ray cuts. LLaMA, Radar, and GCN have zero legal cuts in that census. No S5 native top-five candidate has a typed fission action. The old run does not have per-family event logs, so family-specific attempted, materialized, cost-prepared, scored, duplicate, and reject counts remain **unknown**. Aggregate rejects cannot be assigned to fusion or fission. A final pending-menu snapshot and its checkpoint cursor establish menu slots, not attempts or outcomes; cleanup receipts also record deleted journals. See [`audit.json`](../diagnostics/fusion-fission-audit-r9-20261007/audit.json) and its [human-readable audit](../diagnostics/fusion-fission-audit-r9-20261007/report.md) for the evidence and per-cell cursor details.

Known implementation and proof fixes relevant to the fresh run are:

- Fissioning Task 0 after an ordinary Task 1 shape action now rebases on the current disjoint ordinary action while preserving the initial shapes. This fixes the parent-shape loss exposed by fission replay.
- Parallel scoring no longer moves a candidate identity before its worker result is associated with that identity (`45cef07`).
- Checkpoint downgrade handling now journals and checks exact replay; the recorded acceptance exercised 122 downgrades (`a4702f07`).
- A retained-fusion fact currently fails its source-owned witness check. The source owner is correcting and pinning that proof before the fresh cohort starts. Until that is resolved, final fresh performance and any R10c stage comparisons remain unknown.

These changes are evidence about implementation correctness and search accounting. They do not establish a performance improvement.

## Controlled memory-operation probes

Separate from the full-program search winners, source-proven retained producer-consumer fusion removes one consumer load while preserving both observable output stores:

| Workload and pair | Loads before → after | Stores before → after |
|---|---:|---:|
| Harris Task 0 + Task 1 | 4 → 3 | 2 → 2 |
| Radar Task 16 + Task 17 | 6 → 5 | 2 → 2 |

The Radar Task 4 + Task 5 sibling-fusion probe shares equivalent reads, reducing loads from 8 to 4 while preserving 2 stores. The source tasks each have II 7; the fused task has II 12 on 1×1 and II 9 on a same-total-8-PE 1×2 shape. That 1×2 whole-program candidate measures 1,579,954 cycles versus 1,317,811 cycles for the fixed 1×1 program, a 19.89% increase. Mapper equality, numeric validation, and independent trace pass. This is a diagnostic candidate, not a search winner. It shows why fewer memory operations alone do not imply a faster full program: the fused task's II and resource allocation also affect the schedule. Evidence: [`summary.json`](../diagnostics/fusion-memory-elimination-20261006/summary.json) and [summary.md](../diagnostics/fusion-memory-elimination-20261006/summary.md).

Private producer-consumer intermediate storage may eliminate its paired producer store and consumer load only when exclusivity is proved. Publicly observable outputs retain their stores. These checks are not a substitute for the exact source/effect/alias/domain proof required for each rewrite.

## Reproducing the comparison

Run the renderer after setting these variables to paths in the checkout and result archive being examined. Keep `RENDER_ROOT` outside every measured result root. Captured absolute paths in a summary, `result.json`, or source-binding receipt are provenance pointers; they do not certify a binding that can be reused from a clean clone.

```sh
ARTIFACT_ROOT=/path/to/orbit-artifact
FIXED1X1_SUMMARY=/path/to/fixed1x1/summary.json
COMMON_AMOEBA_SUMMARY=/path/to/common-amoeba/summary.json
R9_SUMMARY="$ARTIFACT_ROOT/diagnostics/input0-memory-fusion-fission-r9-20261007/summary.json"
R9_RECEIPTS="$ARTIFACT_ROOT/diagnostics/input0-memory-fusion-fission-r9-20261007/stage-receipts.json"
FRESH_RESULTS_ROOT=/path/to/fresh-six-by-five-results
FRESH_PUBLIC_SUMMARY=/path/to/fresh-public-summary.json
RENDER_ROOT=/path/to/separate-comparison-output

python3 "$ARTIFACT_ROOT/scripts/render_fusion_fission_comparison.py" \
  --fixed-summary "$FIXED1X1_SUMMARY" \
  --common-amoeba-summary "$COMMON_AMOEBA_SUMMARY" \
  --historical-summary "$R9_SUMMARY" \
  --historical-stage-receipts "$R9_RECEIPTS" \
  --full-results-root "$FRESH_RESULTS_ROOT" \
  --public-stage-summary "$FRESH_PUBLIC_SUMMARY" \
  --output-root "$RENDER_ROOT"
```

The output directory receives `comparison.json`, portable `comparison.md`, and standalone `comparison.svg` plus `comparison.png` when matplotlib is installed. Stage cycles are consumed from `result.json` only after native top-five replay, numeric, trace, independent-stage and source-binding checks pass. Incomplete values become JSON `null` and visible pending/incomplete labels; they are never converted to zero. The public stage summary contributes status and capture provenance only, not cycle values. Optionally provide `--common-amoeba-ray-result PATH` once that independently validated record exists. Before a fresh run starts, omit `--full-results-root` and `--public-stage-summary`; the renderer reports `not-started` rather than manufacturing stage records.

The run contract is four rounds, at most 4,096 unique complete-program scores, beam width 16, diversity 4, native top five plus controls, with each stage initialized independently from the canonical program. The search is bounded and does not prove a global optimum. Do not mix records from a different graph, budget, stage initialization, or winner-selection policy.
