# Original AMOEBA input0 on the 2x2-PE architecture

All five standard programs pass current-body mapper binding, source-domain verification, independent schedule/network replay and complete input0 numeric execution. SRAM capacity remains unknown and `formal_go=false`.

| Program | Cycles | Numeric comparisons | Mismatches |
|---|---:|---:|---:|
| GCN | 106,351 | 603,920 | 0 |
| Harris | 1,072,495 | 884,736 | 0 |
| LLaMA | 636,723,751 | 131,072 | 0 |
| LU | 11,602 | 4,025 | 0 |
| Radar | 1,321,316 | 259,904 | 0 |

The captured original F45 counts, shapes, replica IDs, placement cells, contexts and dispatch order are preserved. Multi-replica tasks use `ceil(full_parent_cycles / active_replicas)`, with unchanged actual compiled II and the common structural startup/network model. The result explicitly records `child_mapper_profiles_used=false`; the replica duration is the original estimation rule. Historical F45 placement slots and profile durations are separately retained.

LU uses the same audited determinant-carry affine input repair as ORBIT, before fresh original parent profiling. The stale input failed one scalar comparison (1023 versus 1017) and is excluded. All 72 corrected parent profiles completed; Tasks 0–7 retain identical body records, Task 8 restores its determinant load, and the original decision objects and dispatch order compare exactly equal. Task 8 retains II3 and eight firings; the complete retimed makespan remains 11,602 cycles.

`evidence.json.gz` contains 441 exact text payloads: source/model bindings, prepared parent inputs and profiles, original scheduler decisions, retiming, numeric and trace evidence, fixed 1x1 evidence, and actual strict retimer acceptance. `manifest.json` lists logical paths and UTF-8 byte sizes and supplies `replay_inputs` for fresh preparation. Every archived text payload was compared directly with its original bytes. Compiler binaries and object files are excluded. Embedded measured paths retain provenance; the replay helper writes to a new root.

Follow the [reproduction guide](../../docs/ORIGINAL_AMOEBA_INPUT0.md) to prepare a fresh run from these parent measurements, or rerun the original profiler. The [portable result summary](../../reference/input0-neighborhood/evidence/2x2-original-amoeba-baselines.json) drives the result viewer. [Ray II23](../input0-original-amoeba-ii23-ray-v49-frozen/README.md) is separate from this standard II20 experiment.
