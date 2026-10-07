# Completed-result storage cleanup

The 2026-10-06 cleanup preserved final candidate MLIR, mapped/native MLIR,
production and independent traces, numerical evidence, result JSON, source
bindings and raw statistics. It did not change search or validation results.

Nineteen completed cells in
`results/input0-neighborhood-2x2-v59-shared-scheduler-r3` had five shortlisted
candidates and one identity control. A separate housekeeping helper checked
their six mapper/native/numeric/trace gates and command exits. The incomplete
`gcn/full-joint` was excluded. The Sequential comparison still requires all
seven gates: five shortlisted candidates plus identity and search_anchor.

The existing archive writer recorded each auxiliary file's size and SHA-256,
then checked every archived member before removing its original. It compacted
`search/costs-*.json`, `search/spaces`, `search/witnesses`,
`search/archive.jsonl` and `search/archive.journal.jsonl`. The 19 cells saved
11,795,431,360 bytes. Their result JSON digests remained unchanged. Their
inputs are independent prepared canonical programs, not another cell's
auxiliary files. The audit is in
`diagnostics/sequential-comparison-4096-fast2-host/completed-storage-cleanup-audit.json`.

```sh
python3 scripts/compact_completed_ablation_raw.py \
  --results-root results/input0-neighborhood-2x2-v59-shared-scheduler-r3 \
  --workloads gcn harris llama lu radar --apply
```

Current ablation tables and final replay inputs remain readable. Readers
requiring raw auxiliary files must first restore their exact bytes:

```sh
python3 scripts/compact_sequential_raw.py --restore-cell <cell-directory>
```

For the fourteen completed Sequential comparison cells, the redundant
checkpoint and binding JSON files were compressed with verified gzip
round-trips before removing the plain copies. This saved 589,436,878 bytes.
Each cell's `completed-checkpoint-cleanup.jsonl` binds compressed and raw
sizes and SHA-256. Final replay does not require those checkpoints; the
query command now reads completed evaluation counts from search summaries.
The checkpoint cleanup is restricted to seven-gate completed cells:

```sh
python3 scripts/cleanup_completed_sequential_intermediates.py \
  --results-root results/sequential-comparison-4096-fast2-host --apply
```

The failed partial LLaMA 75/25 archive was removed only after verifying the
seven completed validation items and recording the partial's size and SHA-256.
The original raw evidence was then archived successfully. Certified catalogue
copies staged in `/tmp` were deleted only after their bytes were verified in
the completed archive. Neither live searches nor incomplete ablation cells
were cleaned by the completed-result helpers.

## Disk failure and recovery

The prior eight-core coordinator exited after ENOSPC while compacting the
completed LLaMA 75/25 cell. LU 25/75 stopped at the disk guard; its durable
objective-call bounds are 2,891–4,096, with 1,300.42 seconds of search time.
LU 75/25 failed publishing its initial binding before its first objective
evaluation; its scheduler, predictor and mapper call counts are zero.
Radar Joint did not launch a search. These attempts are excluded from the
primary comparison and recorded in `enospc-extra-search-costs.json` and
`runtime-disk-failure-audit.json` under the active results root.

Sequential checkpoint continuation is rejected by the pinned compiler
because phase-A anchor and phase-B frozen prefix are in-memory state.
Recovery preserves all fourteen validated cells, archives and retains failed
attempt directories under `*-enospc-attempt-1`, and starts only the six missing
cells with fresh private caches and the same original inputs and budget.
The original source-bound runtime and pinned optimizer remain unchanged.
Two disjoint CPU lanes, 0–3 and 4–7, each retain four scoring/mapper workers.
Completed recovery cells are immediately archived and their redundant
checkpoints compacted. Recovery provenance, script digests and process
affinity evidence are recorded in `runtime-recovery.json` and
`recovery-startup-process-affinity.json`.

One-shot status and final export, without polling or rerunning searches:

```sh
python3 scripts/show_sequential_comparison.py
```

Audited analysis of only currently completed cells, keeping predictions
separate from true mapper cycles:

```sh
python3 scripts/analyze_sequential_completed.py \
  --results-root results/sequential-comparison-4096-fast2-host \
  --output-dir diagnostics/sequential-comparison-4096-fast2-host/completed-analysis \
  --render-plots
```
