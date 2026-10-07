# Fusion/fission comparison: results and status

**Current status (2026-10-07): the fresh R11b six-workload, five-stage cohort is running.** LU S1 and S2 have completed; the other stage results remain pending until their own native, numeric, trace, and binding gates pass. R11b preflights, six controlled transformation cases, and the common-DFG AMOEBA original-Ray reference are complete. Controlled cases do not count as full S1–S5 stages or enter the main curve.

The comparison is whole-program scheduled cycles, with lower values better. R9 is a separate, completed historical cohort. Fixed 1×1 and common-DFG AMOEBA are independently gated reference records.

| Workload | Fixed 1×1 | Common AMOEBA | R9 S1 | R9 S2 | R9 S3 | R9 S4 | R9 S5 | R11b S1 | R11b S2 | R11b S3 | R11b S4 | R11b S5 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| LLaMA | 1,129,656,837 | 757,412,371 | 762,655,252 | 595,551,249 | 424,250,388 | 424,250,388 | 424,250,388 | pending | pending | pending | pending | pending |
| LU | 18,501 | 9,811 | 11,347 | 9,486 | 9,486 | 9,486 | 9,486 | 11,347 | 9,486 | pending | pending | pending |
| Harris | 988,258 | 926,769 | 941,012 | 899,620 | 621,600 | 621,600 | 621,600 | pending | pending | pending | pending | pending |
| Radar | 1,317,811 | 1,317,811 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | 1,309,622 | pending | pending | pending | pending | pending |
| GCN | 95,775 | 83,802 | 89,388 | 86,987 | 86,987 | 86,987 | 86,987 | pending | pending | pending | pending | pending |
| Original Ray | N/A¹ | 177,426² | 176,711 | 176,711 | 176,711 | 176,711 | 176,711 | pending | pending | pending | pending | pending |

¹ Fixed 1×1 Ray is not applicable: the compiler-proved Task 13 unit-CGRA II lower bound is 83, above the diagnostic runtime ceiling 23. The baseline mapper was not run. ² The completed common-DFG AMOEBA Ray replay retains the original 27 tasks and F45 count/shape/active-replica choices. Its 216 authenticated profile attempts are retained; Task 13 uses four CGRAs in shape 1×4 with two active replicas. Full-parent mapped duration is 30,934 and its effective duration is `ceil(30934 / 2) = 15467`. Four denotes CGRA count, not four profile candidates. The complete program measures 177,426 cycles, with mapper equality, independent trace, and all 61,892 numeric comparisons passing. See the [common-Ray receipt](../diagnostics/common-amoeba-original-ray-r11-20261007/README.md).

The R9 public summary and all 30 stage receipts report native top-five replay, numeric pass, independent trace pass, and independent stage initialization. In that historical cohort S4 and S5 match S3 for all six workloads. This is an observed outcome, not proof that fusion or fission is ineffective or that the search found every useful candidate. R9 used a different pinned runtime and remains separate from the fresh R11b cohort.

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
- R10e's retained producer-consumer probes for Harris Task 0+1 and Radar Task 16+17 pass source-level exact-count checks for one eliminated load and zero eliminated stores. The four R10e 1×2/2×1 native PC orientations still fail at `calculateAward` (`mapping_util.cpp:1088`, no producer locations), so they supply no fused whole-program cycles or numeric result. Source commit `7c35269` adds a narrow identity-`DataMov` forwarding fix that peels only identity wrappers and rejects non-identity or cross-block chains; all four fresh R11b native PC orientation rechecks now pass. The before/after roots and source namespaces remain separate, and the tamper negatives stay enforced.

The narrow source fixes establish legality, exact replay, accounting, evidence preservation, and native mapping for the tested controls. The full R11b cohort remains in progress; its performance conclusions require the complete new family funnel and measurements.

## Controlled memory-operation probes

These completed R11b cases use the new immutable pin and are separate from the full search. All pass exact source replay, fresh C++ cost/scoring, native mapper equality, numeric validation, and independent trace. Each compared pair has the same total eight PEs. Both public output stores remain; only source-proven loads or private intermediate stores can be removed.

| Case | Loads / stores before → after | Transformed vs same-resource control cycles | Change |
|---|---|---:|---:|
| Harris Task 0+1 PC, fused 1×2 | 4/2 → 3/2 | 955,485 / 988,258 | −3.3162% |
| Harris Task 0+1 PC, fused 2×1 | 4/2 → 3/2 | 939,361 / 988,258 | −4.9478% |
| Radar Task 16+17 PC, fused 1×2 | 6/2 → 5/2 | 1,310,353 / 1,317,811 | −0.5659% |
| Radar Task 16+17 PC, fused 2×1 | 6/2 → 5/2 | 1,312,031 / 1,317,811 | −0.4386% |
| Radar Task 4+5 sibling, fused 1×2 | 8/2 → 4/2 | 1,579,954 / 1,317,811 | +19.8923% |
| LU Task 0, children 1×1+1×1 vs parent 2×1 | Parent 1/1; each child 1/1 | 18,694 / 18,438 | +1.3884% |

The PC load elimination has a measured benefit in these controls. The sibling case halves the pair's loads but raises the mapped II from 7/7 to 9. Its program has 31 communication edges versus 33 for the identity, yet runs slower. Its predicted whole-program score prefers the fused candidate (1,276,089 versus 1,348,048), while native cycles reverse that ranking. This is a measured model-ranking error for this candidate, not an accuracy claim about every fusion.

LU has one source-owned cut, `left_nodes=[0]`, with full operation coverage/no duplication and exact typed replay. Each child retains 64 source work/firings under `retained-per-operation-not-disjoint-firing-partitions`; these are operation-domain counts and must not be added as unique parent firings. Scorer-owned child bodies are 2,529/2,559 bytes, each 16 operations, with startup 3, predicted II 2.7964169979 and duration 180. Mapped bodies are 4,214/4,244 bytes at actual II 2/2, versus parent II 1. The program adds one communication edge (11 versus 10) and runs 256 cycles slower. Native per-child startup/duration are not emitted and remain unknown.

The [R11b controlled receipt](../diagnostics/fusion-fission-controlled-r11b-20261007/README.md) and [structured summary](../diagnostics/fusion-fission-controlled-r11b-20261007/summary.json) record all task bodies, resource allocations, actual and predicted costs, domains, commands, candidate-ID joins, and positive/negative proofs. Whole-program per-task CGRA allocation sums reuse the grid over time and are not simultaneous demand; the physical target is 16 CGRAs/64 PEs.

The earlier [R10e receipts](../diagnostics/fusion-fission-controlled-r10e-20261007/README.md) retain four PC native aborts at `mapping_util.cpp:1088`. The R11b passes are new measurements on the fixed source, with different output roots. Private forwarding positives and forged metadata/alias/effect/stale-domain negatives remain fail-closed.

## Source preparation and LLaMA restrictions

All six current canonical programs exactly reproduce their bound native source lowering. The fission census is unchanged: LLaMA 0, LU 1, Harris 30, Radar 0, GCN 0, original Ray 56. Original Ray Task 13 remains unsupported by generic fission because its multiple carried outputs require a separate complete proof; no specialized pre-split graph enters this cohort.

Actual non-mapper materializer probes accept the three independent LLaMA GEMM sibling pairs (Tasks 0+1, 0+2, 1+2), including their independent reserve/phi slots. A facts-only `unknown/needs-stateful-kernel-support` label is conservative and does not establish rejection. The direct GEMM PC edges 0→3, 1→3, and 2→6 fail the earlier static-counter-domain equality check: 20,971,520 versus 26,214,400 firings. Their later stateful-kernel checks are not reached. These observations establish source/materialization behavior only; search scores, shortlist admission, and native performance must come from the new full-cohort records.

## Reproducing the comparison

Run the renderer after setting these variables to paths in the checkout and result archive being examined. Keep `RENDER_ROOT` outside every measured result root. Captured absolute paths in a summary, `result.json`, or source-binding receipt are provenance pointers; they do not certify a binding that can be reused from a clean clone.

```sh
ARTIFACT_ROOT=/path/to/orbit-artifact
FIXED1X1_SUMMARY=/path/to/fixed1x1/summary.json
COMMON_AMOEBA_SUMMARY=/path/to/common-amoeba/summary.json
R9_SUMMARY="$ARTIFACT_ROOT/diagnostics/input0-memory-fusion-fission-r9-20261007/summary.json"
R9_RECEIPTS="$ARTIFACT_ROOT/diagnostics/input0-memory-fusion-fission-r9-20261007/stage-receipts.json"
R11B_RESULTS_ROOT=/path/to/fresh-six-by-five-results
R11B_PUBLIC_SUMMARY=/path/to/fresh-public-summary.json
RENDER_ROOT=/path/to/separate-comparison-output

python3 "$ARTIFACT_ROOT/scripts/render_fusion_fission_comparison.py" \
  --fixed-summary "$FIXED1X1_SUMMARY" \
  --common-amoeba-summary "$COMMON_AMOEBA_SUMMARY" \
  --historical-summary "$R9_SUMMARY" \
  --historical-stage-receipts "$R9_RECEIPTS" \
  --full-results-root "$R11B_RESULTS_ROOT" \
  --public-stage-summary "$R11B_PUBLIC_SUMMARY" \
  --output-root "$RENDER_ROOT"
```

The output directory receives `comparison.json`, portable `comparison.md`, and standalone `comparison.svg` plus `comparison.png` when matplotlib is installed. Stage cycles are consumed from `result.json` only after native top-five replay, numeric, trace, independent-stage and source-binding checks pass. Incomplete values become JSON `null` and visible pending/incomplete labels; they are never converted to zero. The public stage summary contributes status and capture provenance only, not cycle values. Provide `--common-amoeba-ray-result PATH` for the completed 177,426-cycle original-Ray record. Before a fresh run starts, omit `--full-results-root` and `--public-stage-summary`; the renderer reports `not-started` rather than manufacturing stage records.

The run contract is four rounds, at most 4,096 unique complete-program scores, beam width 16, diversity 4, native top five plus controls, with each stage initialized independently from the canonical program. The search is bounded and does not prove a global optimum. Do not mix records from a different graph, budget, stage initialization, or winner-selection policy.

The [fresh reproduction runbook](FUSION_FISSION_REPRODUCTION_20261007.md) gives clean-clone build, pin, contract, source preparation, frozen-runtime paths, queue, census, and rendering commands. Captured local paths remain provenance; a new execution requires new bindings and a new result root.
