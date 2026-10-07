# R9 fusion and fission funnel audit

Results root: `/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/results-original-ray-v6/input0-neighborhood-2x2-v60-memory-fusion-fission-r5-20261006`
Census root: `/tmp/orbit-r9-source-proof-acceptance-20261006`

Input paths identify the captured evidence. This audit does not certify that the local runtime binding is reusable from a clean clone.

## Findings

All six workloads are audited in S4 and S5. Typed primitive kinds drive fusion classification: a candidate counts as fusion when its action path contains a `fusion` or `sibling-fusion` primitive (or the corresponding exact dedicated family). Co-tiling families are counted separately only when their primitive kinds are tile/k-tile. A family-name substring alone never establishes fusion.

When the captured run has no family event journal, legal fission counts come from the source-owned cut census. The checkpoint preserves a final identity-parent pending-menu snapshot and action cursor, but those menu rows and cursor positions do not establish attempt, materialization, or scoring outcomes. Aggregate rejects and duplicates remain family agnostic. Those funnel stages are `unknown` unless a family-funnel log provides exact counters.

Checkpoint inputs: 2 `checkpoint.json`, 10 `checkpoint.json.gz`. Cleanup receipts record deletion of the archive journal in 12 stage(s); those receipts and checkpoint source paths are included in `audit.json`.

Across the captured S4/S5 cells, the native global top-five records show 60/60 mapper passes, 60/60 numeric passes, and 60/60 independent trace passes. Selected S4/S5 cycles match for 6/6 workloads with both selected measurements available.

Native global top-five records and controls are reported in separate fields. Final selection comes from `previous-winner.jsonl`; it is not inferred from the minimum cycle across controls.

## Per-workload evidence

| Program | Stage | Search scores / stop | Fusion top5 | Co-tiling top5 | Fission legal cuts / final pending menu rows (before/after cursor) / top5 | Selected cycles | Root menu cursor |
|---|---|---:|---:|---:|---|---:|---:|
| llama | S4 | 4096 / max-unique-candidates | 0/5 | 0/5 | — / — (—/—) / 0/5 | 424250388 | 17669 |
| llama | S5 | 4096 / max-unique-candidates | 0/5 | 0/5 | 0 / 0 (0/0) / 0/5 | 424250388 | 17669 |
| lu | S4 | 3553 / max-rounds | 0/5 | 0/5 | — / — (—/—) / 0/5 | 9486 | 0 |
| lu | S5 | 3554 / max-rounds | 0/5 | 0/5 | 1 / 0 (0/0) / 0/5 | 9486 | 0 |
| harris | S4 | 4096 / max-unique-candidates | 0/5 | 5/5 | — / — (—/—) / 0/5 | 621600 | 16671 |
| harris | S5 | 4096 / max-unique-candidates | 0/5 | 5/5 | 30 / 30 (30/0) / 0/5 | 621600 | 16690 |
| radar | S4 | 4096 / max-unique-candidates | 0/5 | 0/5 | — / — (—/—) / 0/5 | 1309622 | 16715 |
| radar | S5 | 4096 / max-unique-candidates | 0/5 | 0/5 | 0 / 0 (0/0) / 0/5 | 1309622 | 16715 |
| gcn | S4 | 4096 / max-unique-candidates | 0/5 | 0/5 | — / — (—/—) / 0/5 | 86987 | 31689 |
| gcn | S5 | 4096 / max-unique-candidates | 0/5 | 0/5 | 0 / 0 (0/0) / 0/5 | 86987 | 31689 |
| raytracing | S4 | 4096 / max-unique-candidates | 0/5 | 0/5 | — / — (—/—) / 0/5 | 176711 | 22390 |
| raytracing | S5 | 4096 / max-unique-candidates | 0/5 | 0/5 | 56 / 56 (56/0) / 0/5 | 176711 | 22423 |

## R9 classification correction

Harris S4 has zero fusion candidates in the saved global top five. Its 20 recorded actions across those five candidates have family `producer-consumer-co-tiling` and primitive kinds `tile` only. The earlier R9 prose table marked these five candidates as fusion because it treated the co-tiling family name as a fusion action; this corrected audit removes that classification.

S5 fission path presence uses `action_history.fissionActions` separately from ordinary `action_history.actions`. An empty typed-fission history in top five is not evidence that no legal source cut existed; consult the exact source census and funnel status for each workload. Menu rows before or after the checkpoint cursor are action slots only, not proof of an attempt outcome.

See `audit.json` for each top-five action, typed fission history, menu row/cursor counts, native top-five and controls, selected candidate, per-family funnel statuses, and exact source-file references.
