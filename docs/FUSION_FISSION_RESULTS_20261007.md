# Fusion/fission comparison: results and status

**Current status (2026-10-07): R11 is the planned fresh six-workload, five-stage cohort, and none of its 30 stages has started.** R10c and R10e preflights are closed; their source-owned census and controlled probes do not count as full S1–S5 stages. The renderer keeps all 30 fresh cells pending and does not carry R9 values forward.

The comparison is whole-program scheduled cycles, with lower values better. R9 is a separate, completed historical cohort. Fixed 1×1 and common-DFG AMOEBA are independently gated reference records.

| Workload | Fixed 1×1 | Common AMOEBA | R9 S1 | R9 S2 | R9 S3 | R9 S4 | R9 S5 | R11 S1 | R11 S2 | R11 S3 | R11 S4 | R11 S5 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| LLaMA | 1,129,656,837 | 757,412,371 | 762,655,252 | 595,551,249 | 424,250,388 | 424,250,388 | 424,250,388 | pending | pending | pending | pending | pending |
| LU | 18,501 | 9,811 | 11,347 | 9,486 | 9,486 | 9,486 | 9,486 | pending | pending | pending | pending | pending |
| Harris | 988,258 | 926,769 | 941,012 | 899,620 | 621,600 | 621,600 | 621,600 | pending | pending | pending | pending | pending |
| Radar | 1,317,811 | 1,317,811 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | pending | pending | pending | pending | pending |
| GCN | 95,775 | 83,802 | 89,388 | 86,987 | 86,987 | 86,987 | 86,987 | pending | pending | pending | pending | pending |
| Original Ray | N/A¹ | pending² | 176,711 | 176,711 | 176,711 | 176,711 | 176,711 | pending | pending | pending | pending | pending |

¹ Fixed 1×1 Ray is not applicable: the compiler-proved Task 13 unit-CGRA model lower bound is II 83, above the diagnostic runtime ceiling II 23. The baseline mapper was not run. This is not a failed mapping result. ² The common-DFG AMOEBA Ray record has not been supplied. Its cell stays pending. Its profile/F45 investigation is separate from native replay: the initial retime profile failed because Task 13 lacked an expected profile attribute; the profile is being checked against the candidate inventory before source annotation. Profile attempts for 2×2 and 1×4 each found four candidates (profile outputs 32,405 and 30,934); unit shape was absent and 1×4 was the exact fallback. No common-Ray baseline replay is claimed until the new pin checks pass.

The R9 public summary and all 30 stage receipts report native top-five replay, numeric pass, independent trace pass, and independent stage initialization. In that historical cohort S4 and S5 match S3 for all six workloads. This is an observed outcome, not proof that fusion or fission is ineffective or that the search found every useful candidate. R9 used a different pinned runtime and remains separate from the pending R11 cohort.

R9's receipt defines its reported stage-cycle source as the minimum whole-program native cycles across measured top-five candidates and controls. The audit retains native top five, controls, and the final `previous-winner.jsonl` selection as separate evidence; the table above does not relabel the stage-cycle minimum as the selected winner.

## R9 S4/S5 family funnel

The corrected R9 audit joins each saved search top five to its native top-five records by candidate ID. All 12 S4/S5 cells have five matching native records (60 total); every record passed mapper equality, numeric validation, and independent trace. Typed ordinary-action histories contain no `fusion` or `sibling-fusion` primitive in any of those 60 candidates. All saved typed `fissionActions` arrays are empty in S4 and S5. Harris's `producer-consumer-co-tiling` rows are `tile` primitives and stay in the co-tiling column.

| Program | S4 scored / stop; cursor | S5 scored / stop; cursor | Fusion paths in S4 / S5 native top five | Co-tiling final beam / search top five, S4; S5 | S5 census cuts; saved fission menu rows before / after cursor | S5 typed fission paths in native top five |
|---|---|---|---|---|---|---|
| LLaMA | 4,096 / max-unique-candidates; 17,669 | 4,096 / max-unique-candidates; 17,669 | 0/5; 0/5 | 1/16, 0/5; 1/16, 0/5 | 0; 0/0 | 0/5 |
| LU | 3,553 / max-rounds; 0 | 3,554 / max-rounds; 0 | 0/5; 0/5 | 0/16, 0/5; 0/16, 0/5 | 1; 0/0 | 0/5 |
| Harris | 4,096 / max-unique-candidates; 16,671 | 4,096 / max-unique-candidates; 16,690 | 0/5; 0/5 | 15/16, 5/5; 15/16, 5/5 | 30; 30/0 | 0/5 |
| Radar | 4,096 / max-unique-candidates; 16,715 | 4,096 / max-unique-candidates; 16,715 | 0/5; 0/5 | 0/16, 0/5; 0/16, 0/5 | 0; 0/0 | 0/5 |
| GCN | 4,096 / max-unique-candidates; 31,689 | 4,096 / max-unique-candidates; 31,689 | 0/5; 0/5 | 0/16, 0/5; 0/16, 0/5 | 0; 0/0 | 0/5 |
| Original Ray | 4,096 / max-unique-candidates; 22,390 | 4,096 / max-unique-candidates; 22,423 | 0/5; 0/5 | 0/16, 0/5; 0/16, 0/5 | 56; 56/0 | 0/5 |

The exact final checkpoint beam has zero fusion and zero fission path presence in all 12 cells. The beam/top-five entries are per-family path-presence counts from typed checkpoint/search histories; they are not additive across families. The fission-menu column gives exact source-census cut totals and saved fission-family rows around the checkpoint cursor, not attempts. S4 has no fission dimension; its empty S4 fission history is not evidence about fission attempts.

For every S4/S5 family, R9 lacks the event journal needed to recover total generated menu entries, attempted actions, materializations, fresh-cost preparations/scores, duplicate disposition, archive path presence, or family-specific rejection counts. Those stages remain **unknown**. The source census is exact for legal fission cuts, and top-five/beam path presence is exact where saved typed histories allow it; neither supplies missing earlier funnel counts. Aggregate rejects and duplicates are family-agnostic and cannot be assigned to fusion or fission. The checkpoint cursor locates action slots only, and cleanup receipts show that archive journals were deleted in 12 stages. Do not infer attempts from rows before the cursor or assign aggregate materializer rejects to a family.

The S5 cut census reports 30 Harris cuts, one LU cut, and 56 original-Ray cuts (Task 12: 3, Task 23: 30, Task 24: 23); LLaMA, Radar, and GCN have none. The audit also keeps native global top five, native controls, and the final `previous-winner.jsonl` selection separate. See [`audit.json`](../diagnostics/fusion-fission-audit-r9-20261007/audit.json) and the [human-readable R9 audit](../diagnostics/fusion-fission-audit-r9-20261007/report.md).

## Implementation fixes and current limits

- Source commit `7d682ef` replaces the S5 fission-prefix restriction with a typed footprint check: fission can follow an ordinary action only when that action has a known task footprint disjoint from the fission target. The implementation then reconstructs the canonical fission source, checks initial-shape coverage, and replays the full typed history; overlapping or unknown footprints remain rejected. This admits fission after a disjoint Task 1 shape/replica/tile history without relaxing source proof.
- Source commits `d19978a` and `39a341c` correct fusion graph facts. Valid retained producer-consumer fusion can carry its source-authenticated one-load/zero-store descriptor. Sibling fusion preserves the actual eliminated-load count in graph facts and structural keys while keeping eliminated stores at zero. R10e receipts exercise those counts. This fixes the valid retained `1/0` fact rejection; it does not imply that every mapper orientation succeeds.
- Source commit `45cef07` fixes parallel candidate-history association so moving a candidate into the beam cannot leave its family-funnel event with a moved-from candidate ID.
- Artifact commit `d55b29c` protects the family-funnel and archive journals, summary, and compiler family-best witnesses/cost snapshots during closed-stage cleanup. This preserves evidence for future runs; it does not restore journals deleted from R9.
- The controlled-probe worker also corrected a bounded-harness `best-found` footer bug. Its small diagnostic receipts are not full-stage winner evidence; use the candidate and native receipts, not a footer label, for claims.
- R10e's retained producer-consumer probes for Harris Task 0+1 and Radar Task 16+17 pass source-level exact-count checks for one eliminated load and zero eliminated stores. The four R10e 1×2/2×1 native PC orientations still fail at `calculateAward` (`mapping_util.cpp:1088`, no producer locations), so they supply no fused whole-program cycles or numeric result. Source commit `7c35269` adds a narrow identity-`DataMov` forwarding fix that peels only identity wrappers and rejects non-identity or cross-block chains; the fix still needs a fresh-pin native recheck. Preserve the tamper negatives and make no performance claim for PC fusion yet.

These changes establish legality, replay, accounting, and evidence preservation. They do not establish a full-cohort performance improvement. The R11 six-by-five stages are still pending.

## Controlled memory-operation probes

R10e controlled probes are separate from the full-program search and do not enter the comparison curve. Source-proven retained producer-consumer fusion removes one consumer load while preserving both observable output stores:

| Workload and pair | Loads before → after | Stores before → after |
|---|---:|---:|
| Harris Task 0 + Task 1 | 4 → 3 | 2 → 2 |
| Radar Task 16 + Task 17 | 6 → 5 | 2 → 2 |

The packaged R10e Radar Task 4 + Task 5 sibling-fusion receipt shares equivalent reads: loads fall from 8 to 4 and both public output stores remain. The parent tasks each use 1×1 (II 7/7); the same-resource fused 1×2 task has II 9. Whole-program communication edges fall from 33 to 31. The full program measures 1,579,954 cycles versus 1,317,811 for the identity control (+262,143, +19.8923%). Mapper equality, independent trace, and 259,904-value numeric checks pass. This is a diagnostic candidate, not a search winner; fewer memory operations do not by themselves imply a faster schedule.

R10e also has a source-fission positive for LU Task 0. Its census found one legal operation cut, `left_nodes=[0]`. Two 1×1 children use the same total resources as the 2×1 parent. The parent control measures 18,438 cycles and the fission candidate 18,694 (+256, +1.3884%); both pass exact source replay, mapper equality, independent trace, and numeric validation. Each child retains a certified source domain and reports 64 source work/firings. The witness policy is `retained-per-operation-not-disjoint-firing-partitions`: these are not disjoint firing partitions and must not be summed as unique parent firings. The scorer-owned child bodies are 2,529 and 2,559 bytes; the mapped task bodies are 4,214 and 4,244 bytes, each 16 operations at compiled II 2. This is a controlled positive, not a full-search winner or a full-program speedup.

The source-count table above records R10e retained-PC facts, not native fused results. All four R10e Harris/Radar 1×2 and 2×1 PC mapping attempts aborted at `calculateAward` (`mapping_util.cpp:1088`) before fused cycles or numeric results were produced. The narrow identity-`DataMov` fix needs a fresh-pin recheck. The sibling and fission receipts, along with their evidence scope and limits, are in the packaged [R10e controlled receipts](../diagnostics/fusion-fission-controlled-r10e-20261007/README.md) and [summary](../diagnostics/fusion-fission-controlled-r10e-20261007/summary.json).

Private producer-consumer intermediate storage may eliminate its paired producer store and consumer load only when exclusivity is proved. Publicly observable outputs retain their stores. These checks are not a substitute for the exact source/effect/alias/domain proof required for each rewrite.

## Reproducing the comparison

Run the renderer after setting these variables to paths in the checkout and result archive being examined. Keep `RENDER_ROOT` outside every measured result root. Captured absolute paths in a summary, `result.json`, or source-binding receipt are provenance pointers; they do not certify a binding that can be reused from a clean clone.

```sh
ARTIFACT_ROOT=/path/to/orbit-artifact
FIXED1X1_SUMMARY=/path/to/fixed1x1/summary.json
COMMON_AMOEBA_SUMMARY=/path/to/common-amoeba/summary.json
R9_SUMMARY="$ARTIFACT_ROOT/diagnostics/input0-memory-fusion-fission-r9-20261007/summary.json"
R9_RECEIPTS="$ARTIFACT_ROOT/diagnostics/input0-memory-fusion-fission-r9-20261007/stage-receipts.json"
R11_RESULTS_ROOT=/path/to/fresh-six-by-five-results
R11_PUBLIC_SUMMARY=/path/to/fresh-public-summary.json
RENDER_ROOT=/path/to/separate-comparison-output

python3 "$ARTIFACT_ROOT/scripts/render_fusion_fission_comparison.py" \
  --fixed-summary "$FIXED1X1_SUMMARY" \
  --common-amoeba-summary "$COMMON_AMOEBA_SUMMARY" \
  --historical-summary "$R9_SUMMARY" \
  --historical-stage-receipts "$R9_RECEIPTS" \
  --full-results-root "$R11_RESULTS_ROOT" \
  --public-stage-summary "$R11_PUBLIC_SUMMARY" \
  --output-root "$RENDER_ROOT"
```

The output directory receives `comparison.json`, portable `comparison.md`, and standalone `comparison.svg` plus `comparison.png` when matplotlib is installed. Stage cycles are consumed from `result.json` only after native top-five replay, numeric, trace, independent-stage and source-binding checks pass. Incomplete values become JSON `null` and visible pending/incomplete labels; they are never converted to zero. The public stage summary contributes status and capture provenance only, not cycle values. Optionally provide `--common-amoeba-ray-result PATH` once that independently validated record exists. Before a fresh run starts, omit `--full-results-root` and `--public-stage-summary`; the renderer reports `not-started` rather than manufacturing stage records.

The run contract is four rounds, at most 4,096 unique complete-program scores, beam width 16, diversity 4, native top five plus controls, with each stage initialized independently from the canonical program. The search is bounded and does not prove a global optimum. Do not mix records from a different graph, budget, stage initialization, or winner-selection policy.
