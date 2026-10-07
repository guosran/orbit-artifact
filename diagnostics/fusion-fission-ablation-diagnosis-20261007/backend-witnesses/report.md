# R9 backend witnesses

This package records six already completed fixed native probes from the exact R9 runtime in `summary.json` and individual receipts. It did not rerun mapping, native scheduling, numeric execution, or a build.

## Fixed fission probes

| Workload | Rank | Selected Task_0 form | Native cycles | Numeric check |
|---|---:|---|---:|---|
| lu | 0 | original | 18501 | pass (4025/4025, mismatches 0) |
| lu | 1 | original | 18438 | pass (4025/4025, mismatches 0) |
| lu | 2 | Task_0.split.0 + Task_0.split.1 | 18694 | pass (4025/4025, mismatches 0) |
| harris | 0 | original | 988258 | pass (884736/884736, mismatches 0) |
| harris | 1 | original | 988258 | pass (884736/884736, mismatches 0) |
| harris | 2 | Task_0.split.0 + Task_0.split.1 | 1012450 | pass (884736/884736, mismatches 0) |

The search manifest is the older `orbit-neighborhood-search-v1` format. Each receipt pins the exact selected search record by BLAKE2b-256 and retains its selected rank/action fields, the saved mapper/native/replay command JSON, native result JSON, independent trace result, numeric pass record, selected source facts, file digests, actual task schedule, and DFG/cache digests.

The selected original LU task and both fission children each retain 64 firings over the same 8×8 domain. The Harris original task and both fission children each retain 8064 firings over the same 63×128 domain. These are retained-per-operation domains, not disjoint child trip counts; do not sum the child firing counts. The fission action records axis 0, factor 1, left node `[0]`, and the children carry a temporary plus an inter-child RAW edge. Each receipt gives exact operation counts per original-domain firing and its dependency payloads.

For every selected kernel, `representative-kernels.mlir.txt` contains only the exact task-body excerpt. `raw_source_task_ir_blake2b_256` and `raw_source_kernel_region_blake2b_256` identify source IR separately from `mapper_visible_dfg_blake2b_256`, which hashes the actual mapper-cache `func.func` wrapper selected at the mapped task’s recorded grid. The normalizer requires the source kernel body and mapper wrapper body to agree after terminal yield spelling, whitespace, and SSA-name normalization.

Native trace schedules provide start, end, duration, dependencies, and routes. The mapped task attributes expose compiled II and profile duration. The trace has no per-task startup or resource-wait field; no schedule gap is described as pure resource wait. Search-cost startup estimates are labeled as predictions in the receipts and are not native startup measurements. `production_ready` remains false and SRAM capacity remains a pending gate (`target_sram_capacity_unestablished`).

These fixed results are limited to the tested R9 records. They do not establish a general performance claim.

## Radar fusion interface witness

The typed legality replay materializes `Task_16.fuse.Task_17` with two taskflow result ports and preserved indexed stores to `%input2` and `%input4`; `Task_18` remains a separate task. The source facts record an 840-firing domain and a refreshed source partition proof. In this R9 replay the facts record `cost_catalog_read=false`, `native_mapping_run=false`, `prediction_run=false`, and `ranking_performed=false`, so the package reports no fusion cost or native performance result.

## File map

`summary.json` indexes all evidence; `scope-check.json` records packaging checks; `receipts/lu-rank-{0,1,2}.json` and `receipts/harris-rank-{0,1,2}.json` hold the six fixed results; `receipts/radar-pc-16-17.json` holds the typed fusion interface; `representative-kernels.mlir.txt` holds compact selected task excerpts.
